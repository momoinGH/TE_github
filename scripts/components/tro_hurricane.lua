local PI = math.pi


-- 阵风状态机常量
local HURRICANE_GUST_WAIT = 0     -- 等待下一次阵风
local HURRICANE_GUST_ACTIVE = 1   -- 阵风满速持续中
local HURRICANE_GUST_RAMPUP = 2   -- 风速渐增中
local HURRICANE_GUST_RAMPDOWN = 3 -- 风速渐减中


-- TUNING 常量（可按需调整或移到 modmain 的 TUNING 表中）
local TUNING_HURRICANE = {
    -- 阵风风速
    WIND_GUSTSPEED_PEAK_MIN = 0.9,                        -- 阵风峰值最小值
    WIND_GUSTSPEED_PEAK_MAX = 1.0,                        -- 阵风峰值最大值
    -- 阵风时间
    WIND_GUSTRAMPUP_TIME = 0.5,                           -- 风速渐增时间(秒)
    WIND_GUSTRAMPDOWN_TIME = 32.0 / 30.0,                 -- 风速渐减时间(秒)，与windshirl动画同步
    WIND_GUSTLENGTH_MIN = 7,                              -- 阵风持续最短(秒)
    WIND_GUSTLENGTH_MAX = 10,                             -- 阵风持续最长(秒)
    WIND_GUSTDELAY_MIN = 15,                              -- 阵风间隔最短(秒)
    WIND_GUSTDELAY_MAX = 16,                              -- 阵风间隔最长(秒)
    -- 飓风整体
    HURRICANE_LENGTH_MIN = TUNING.TOTAL_DAY_TIME,         -- 飓风最短持续时间(1天)
    HURRICANE_LENGTH_MAX = 2.5 * TUNING.TOTAL_DAY_TIME,   -- 飓风最长持续时间(2.5天)
    HURRICANE_TEASE_LENGTH = 0.5 * TUNING.TOTAL_DAY_TIME, -- 飓风预兆持续时间(半天)
    -- 飓风进度中风的起止百分比
    HURRICANE_PERCENT_WIND_START = 0.01,                  -- 风在飓风进度1%时开始
    HURRICANE_PERCENT_WIND_END = 0.8,                     -- 风在飓风进度80%时结束
}


-- 工具函数
local function GetRandomMinMax(min, max)
    return min + math.random() * (max - min)
end

local function OnIsWet(inst, iswet)
    local self = inst.components.tro_hurricane
    if self == nil then return end
    if iswet then
        self:StartHurricaneTease()
    else
        self:StopHurricaneTease()
    end
end

-- 海难季节管理，飓风季大风生成
-- 从单机版 seasonmanager_sw.lua 中提取的飓风大风核心逻辑，适配联机版
local Hurricane = Class(function(self, inst)
    self.inst = inst

    -- 飓风状态
    self.hurricane = false      -- 是否处于飓风中
    self.is_tease = false       -- 是否为预兆模式（区分完整飓风和预兆）
    self.hurricane_timer = 0    -- 飓风已持续时间
    self.hurricane_duration = 0 -- 飓风总持续时间

    -- 风速相关
    self.hurricane_gust_speed = 0.0                 -- 当前阵风风速
    self.hurricane_gust_timer = 0.0                 -- 阵风状态计时器
    self.hurricane_gust_period = 0.0                -- 当前阵风阶段的目标时长
    self.hurricane_gust_peak = 0.0                  -- 当前阵风的峰值风速
    self.hurricane_gust_state = HURRICANE_GUST_WAIT -- 阵风状态机当前状态

    -- 风模式: "dynamic" 动态 / "never" 无风
    self.windmode = "dynamic"

    self._trail_timers = {}
    self._trail_cleanup = nil

    inst:WatchWorldState("iswet", OnIsWet)
    inst:DoTaskInTime(0, function(inst)
        if TheWorld.state.iswet then
            OnIsWet(inst, true)
        end
    end)
end)

-- 获取当前阵风风速
function Hurricane:GetHurricaneWindSpeed()
    return self.hurricane_gust_speed
end

-- 是否处于飓风中
function Hurricane:IsHurricaneStorm()
    return self.hurricane
end

-- 获取飓风进度百分比 (0~1)
function Hurricane:GetHurricanePercent()
    if self.hurricane_duration <= 0 then return 0 end
    return self.hurricane_timer / self.hurricane_duration
end

-- 重置所有风速状态到初始值
function Hurricane:_ResetWindState()
    self.hurricane_gust_speed = 0.0
    self.hurricane_gust_timer = 0.0
    self.hurricane_gust_period = 0.0
    self.hurricane_gust_peak = 0.0
    self.hurricane_gust_state = HURRICANE_GUST_WAIT
end

-- 启动飓风
-- @param duration_override 可选，手动指定持续时间
function Hurricane:StartHurricaneStorm(duration_override)
    if not self:IsHurricaneStorm() then
        self.hurricane = true
        self.is_tease = false
        self.hurricane_timer = 0
        self.hurricane_duration = duration_override
            or math.random(TUNING_HURRICANE.HURRICANE_LENGTH_MIN, TUNING_HURRICANE.HURRICANE_LENGTH_MAX)

        self:_ResetWindState()
        self.inst:StartUpdatingComponent(self)

        self.inst:PushEvent("hurricanestart")
    end
end

-- 停止飓风
function Hurricane:StopHurricaneStorm()
    if self:IsHurricaneStorm() then
        self.hurricane = false
        self.is_tease = false
        self._trail_timers = {}
        self:_ResetWindState()
        self.inst:StopUpdatingComponent(self)

        self.inst:PushEvent("hurricanestop")
    end
end

-- 启动飓风预兆（较短的飓风，无闪电）
function Hurricane:StartHurricaneTease(duration_override)
    if not self:IsHurricaneStorm() then
        self:StartHurricaneStorm(duration_override or TUNING_HURRICANE.HURRICANE_TEASE_LENGTH)
        self.is_tease = true
    end
end

-- 停止飓风预兆
function Hurricane:StopHurricaneTease()
    self:StopHurricaneStorm()
end

-- 核心：更新阵风状态机
-- 阵风循环: WAIT -> RAMPUP -> ACTIVE -> RAMPDOWN -> WAIT
-- @param dt        帧间隔
-- @param percent   飓风进度 (0~1)
-- @param windstart 风开始的进度阈值
-- @param windend   风结束的进度阈值
function Hurricane:UpdateHurricaneWind(dt, percent, windstart, windend)
    if windstart <= percent and percent <= windend then
        self.hurricane_gust_timer = self.hurricane_gust_timer + dt

        if self.hurricane_gust_state == HURRICANE_GUST_WAIT then
            -- 等待阶段：风速为0，等待间隔时间到达后进入渐增
            self.hurricane_gust_speed = 0
            if self.hurricane_gust_timer >= self.hurricane_gust_period then
                self.hurricane_gust_peak = GetRandomMinMax(
                    TUNING_HURRICANE.WIND_GUSTSPEED_PEAK_MIN,
                    TUNING_HURRICANE.WIND_GUSTSPEED_PEAK_MAX)
                self.hurricane_gust_timer = 0.0
                self.hurricane_gust_period = TUNING_HURRICANE.WIND_GUSTRAMPUP_TIME
                self.hurricane_gust_state = HURRICANE_GUST_RAMPUP

                self.inst:PushEvent("wind_rampup")
                self.inst:PushEvent("windguststart")
            end
        elseif self.hurricane_gust_state == HURRICANE_GUST_RAMPUP then
            -- 渐增阶段：余弦曲线从0平滑上升到peak
            local peak = 0.5 * self.hurricane_gust_peak
            self.hurricane_gust_speed = -peak * math.cos(PI * self.hurricane_gust_timer / self.hurricane_gust_period) + peak
            if self.hurricane_gust_timer >= self.hurricane_gust_period then
                self.hurricane_gust_timer = 0.0
                self.hurricane_gust_period = GetRandomMinMax(
                    TUNING_HURRICANE.WIND_GUSTLENGTH_MIN,
                    TUNING_HURRICANE.WIND_GUSTLENGTH_MAX)
                self.hurricane_gust_state = HURRICANE_GUST_ACTIVE
            end
        elseif self.hurricane_gust_state == HURRICANE_GUST_ACTIVE then
            -- 满速阶段：保持峰值风速
            self.hurricane_gust_speed = self.hurricane_gust_peak
            if self.hurricane_gust_timer >= self.hurricane_gust_period then
                self.hurricane_gust_timer = 0.0
                self.hurricane_gust_period = TUNING_HURRICANE.WIND_GUSTRAMPDOWN_TIME
                self.hurricane_gust_state = HURRICANE_GUST_RAMPDOWN
            end
        elseif self.hurricane_gust_state == HURRICANE_GUST_RAMPDOWN then
            -- 渐减阶段：余弦曲线从peak平滑下降到0
            local peak = 0.5 * self.hurricane_gust_peak
            self.hurricane_gust_speed = peak * math.cos(PI * self.hurricane_gust_timer / self.hurricane_gust_period) + peak
            if self.hurricane_gust_timer >= self.hurricane_gust_period then
                self.hurricane_gust_timer = 0.0
                self.hurricane_gust_period = GetRandomMinMax(
                    TUNING_HURRICANE.WIND_GUSTDELAY_MIN,
                    TUNING_HURRICANE.WIND_GUSTDELAY_MAX)
                self.hurricane_gust_state = HURRICANE_GUST_WAIT
                self.inst:PushEvent("windgustend")
            end
        end
    else
        -- 不在风的有效进度范围内，重置
        self.hurricane_gust_timer = 0.0
        self.hurricane_gust_speed = 0.0
    end
end

-- 每帧更新（由 StartUpdatingComponent 驱动）
function Hurricane:OnUpdate(dt)
    if not self.hurricane then return end

    self.hurricane_timer = self.hurricane_timer + dt

    local windstart = TUNING_HURRICANE.HURRICANE_PERCENT_WIND_START
    local windend = TUNING_HURRICANE.HURRICANE_PERCENT_WIND_END
    local percent = self.hurricane_timer / self.hurricane_duration

    if self.windmode == "dynamic" then
        self:UpdateHurricaneWind(dt, percent, windstart, windend)
    end

    -- 统一吹动玩家附近的实体，这个替代单机给每个实体加的blowinwind组件
    self:UpdateBlowEntities(dt, self.hurricane_gust_speed)

    -- 飓风持续时间到达，停止
    if self.hurricane_timer >= self.hurricane_duration then
        if self.is_tease then
            self:StopHurricaneTease()
        else
            self:StopHurricaneStorm()
        end
    end
end

-- 风吹物品的速度配置
local BLOW_SEARCH_RADIUS = 30      -- 搜索半径（围绕每个玩家）
local BLOW_BASE_SPEED = 2          -- 基础吹动速度（TUNING.WILSON_WALK_SPEED / 4 ≈ 1.5）
local BLOW_SPEED_VAR = 0.3         -- 速度随机波动幅度（±30%）
local WINDTRAIL_SPAWN_PERIOD = 1.0 -- windtrail 生成间隔（秒）
local WINDTRAIL_SPAWN_CHANCE = 0.8 -- windtrail 生成概率

local function SpawnTrailForEnt(self, ent, dt, windspeed)
    local angle = TheWorld.components.worldwind:GetWindAngle() * DEGREES
    if not ent.Physics then
        return
    end
    -- 跳过被持有的物品
    if ent.components.inventoryitem and ent.components.inventoryitem:IsHeld() then
        return
    end
    -- 跳过正在下落的物品
    if ent:HasTag("falling") then
        return
    end

    -- 计算吹动速度：基础速度 × 风速 × 随机波动
    local speed_var = 1.0 + (math.random() * 2 - 1) * BLOW_SPEED_VAR
    local blow_speed = BLOW_BASE_SPEED * windspeed * speed_var

    -- 施加物理速度（沿风向）
    ent.Physics:SetMotorVel(blow_speed, 0, 0)
    -- 设置朝向为风向
    ent.Transform:SetRotation(angle / DEGREES)

    -- 如果物品在陷阱上，先脱离陷阱
    if ent.components.bait and ent.components.bait.trap then
        ent.components.bait.trap:RemoveBait()
    end

    -- 生成 windtrail 拖尾特效
    local key = ent.GUID
    self._trail_timers[key] = (self._trail_timers[key] or WINDTRAIL_SPAWN_PERIOD) + dt
    if self._trail_timers[key] >= WINDTRAIL_SPAWN_PERIOD and blow_speed > 3.0 then
        if math.random() < WINDTRAIL_SPAWN_CHANCE then
            local trail = SpawnPrefab("windtrail")
            if trail then
                local ex, ey, ez = ent.Transform:GetWorldPosition()
                trail.Transform:SetPosition(ex, ey, ez)
                trail.Transform:SetRotation(angle / DEGREES)
            end
        end
        self._trail_timers[key] = 0
    end
end

-- 核心：遍历玩家附近所有可吹动实体，统一施加风力和生成 windtrail
-- @param dt        帧间隔
-- @param windspeed 当前风速 (0~1)
function Hurricane:UpdateBlowEntities(dt, windspeed)
    if windspeed <= 0.01 then
        return
    end

    -- 遍历所有玩家（联机版支持多人）
    for _, player in ipairs(AllPlayers) do
        if player:IsInShipwreckedArea() then --只在海难区域影响
            local px, py, pz = player.Transform:GetWorldPosition()
            for _, ent in ipairs(TheSim:FindEntities(px, py, pz, BLOW_SEARCH_RADIUS, nil, { "INLIMBO" }, { "smallcreature", "_inventoryitem" })) do
                SpawnTrailForEnt(self, ent, dt, windspeed)
            end
        end
    end

    -- 清理已失效实体的计时器（每 10 秒清理一次，避免内存泄漏）
    if self._trail_cleanup == nil then self._trail_cleanup = 0 end
    self._trail_cleanup = self._trail_cleanup + dt
    if self._trail_cleanup > 10 then
        self._trail_cleanup = 0
        for guid, _ in pairs(self._trail_timers) do
            if Ents[guid] == nil then
                self._trail_timers[guid] = nil
            end
        end
    end
end

function Hurricane:OnSave()
    return {
        hurricane = self.hurricane,
        is_tease = self.is_tease,
        hurricane_timer = self.hurricane_timer,
        hurricane_duration = self.hurricane_duration,
        hurricane_gust_speed = self.hurricane_gust_speed,
        hurricane_gust_timer = self.hurricane_gust_timer,
        hurricane_gust_period = self.hurricane_gust_period,
        hurricane_gust_peak = self.hurricane_gust_peak,
        hurricane_gust_state = self.hurricane_gust_state,
        windmode = self.windmode,
    }
end

function Hurricane:OnLoad(data)
    if data then
        self.hurricane = data.hurricane or false
        self.is_tease = data.is_tease or false
        self.hurricane_timer = data.hurricane_timer or 0
        self.hurricane_duration = data.hurricane_duration or 0
        self.hurricane_gust_speed = data.hurricane_gust_speed or 0.0
        self.hurricane_gust_timer = data.hurricane_gust_timer or 0.0
        self.hurricane_gust_period = data.hurricane_gust_period or 0.0
        self.hurricane_gust_peak = data.hurricane_gust_peak or 0.0
        self.hurricane_gust_state = data.hurricane_gust_state or HURRICANE_GUST_WAIT
        self.windmode = data.windmode or "dynamic"

        -- 加载后如果飓风正在进行，需要重新启动更新
        if self.hurricane then
            self.inst:StartUpdatingComponent(self)
        end
    end
end

return Hurricane
