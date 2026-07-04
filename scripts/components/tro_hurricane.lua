local PI = math.pi


-- 阵风状态机常量
local HURRICANE_GUST_WAIT = 0     -- 等待下一次阵风
local HURRICANE_GUST_ACTIVE = 1   -- 阵风满速持续中
local HURRICANE_GUST_RAMPUP = 2   -- 风速渐增中
local HURRICANE_GUST_RAMPDOWN = 3 -- 风速渐减中


-- TUNING 常量（可按需调整或移到 modmain 的 TUNING 表中）
local TUNING_HURRICANE = {
    --飓风季下每次飓风之间间隔
    WIND_COOLDOWN = TUNING.TOTAL_DAY_TIME,

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
    HURRICANE_TEASE_LENGTH = 0.5 * TUNING.TOTAL_DAY_TIME, -- 飓风预兆持续时间(半天)
    -- 飓风进度中风的起止百分比
    HURRICANE_PERCENT_WIND_START = 0.01,                  -- 风在飓风进度1%时开始
    HURRICANE_PERCENT_WIND_END = 0.8,                     -- 风在飓风进度80%时结束
}


-- 工具函数
local function GetRandomMinMax(min, max)
    return min + math.random() * (max - min)
end

-- 海难季节管理，飓风季大风生成
-- 从单机版 seasonmanager_sw.lua 中提取的飓风大风核心逻辑，适配联机版
local Hurricane = Class(function(self, inst)
    self.inst = inst

    --除玩家外还要刮风的单位，飓风季玩家只有在海难区域才能刮，但是这个只要有值哪里都能刮风
    self.target_ents = {}
    self.next_update_ents_time = 0

    -- 飓风状态
    self.hurricane = false      -- 是否处于飓风中
    self.is_tease = false       -- 是否为预兆模式（区分完整飓风和预兆）
    self.hurricane_timer = 0    -- 飓风已持续时间
    self.hurricane_duration = 0 -- 飓风总持续时间
    self.last_stop_time = 0     --上次飓风停止时间

    -- 风速相关
    self.hurricane_gust_speed = 0.0                 -- 当前阵风风速
    self.hurricane_gust_timer = 0.0                 -- 阵风状态计时器
    self.hurricane_gust_period = 0.0                -- 当前阵风阶段的目标时长
    self.hurricane_gust_peak = 0.0                  -- 当前阵风的峰值风速
    self.hurricane_gust_state = HURRICANE_GUST_WAIT -- 阵风状态机当前状态

    -- 单位拖尾特效
    self._trail_timers = {} --记录每个单位拖尾特效生成时间

    -- 刮风特效
    self.windfx_spawn_rate = 0
    self.windfx_spawn_pre_sec = 16

    self.inst:StartUpdatingComponent(self)
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

-- 启动飓风，外部可调用生成临时的风
-- @param duration_override 指定持续时间
function Hurricane:StartHurricaneStorm(duration_override, target_ent)
    if target_ent then
        self.target_ents[target_ent] = duration_override + GetTime()
    end

    if self:IsHurricaneStorm() then
        if target_ent then
            self.hurricane_duration = math.max(self.hurricane_duration, duration_override) --持续时间取最长
        end
        return
    end

    self.hurricane = true
    self.is_tease = false
    self.hurricane_timer = 0
    self.hurricane_duration = duration_override

    self:_ResetWindState()
    self.inst:PushEvent("hurricanestart")
end

-- 停止飓风
function Hurricane:StopHurricaneStorm()
    if self:IsHurricaneStorm() then
        self.hurricane = false
        self.is_tease = false
        self._trail_timers = {}
        self.target_ents = {}
        self.last_stop_time = GetTime()
        self.next_update_ents_time = 0
        self:_ResetWindState()
        self.inst:PushEvent("hurricanestop")
    end
end

function Hurricane:GetWindAngle(ent)
    for _, v in ipairs(AllPlayers) do
        if v:GetDistanceSqToInst(ent) <= 625 then
            local item = v.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if item and item.prefab == "sail_stick" then
                return v.Transform:GetRotation() + 180
            end
        end
    end
    return TheWorld.components.worldwind:GetWindAngle()
end

local function TrySpawnWindSwirl(self, dt)
    self.windfx_spawn_rate = self.windfx_spawn_rate + self.windfx_spawn_pre_sec * dt
    if self.windfx_spawn_rate < 1.0 then
        return
    end

    local spawn_pos = {}
    for _, v in ipairs(AllPlayers) do
        local px, py, pz = v.Transform:GetWorldPosition()
        local can_spawn = true
        for _, pos in ipairs(spawn_pos) do
            if distsq(pos.x, pos.z, px, pz) < 256 then
                can_spawn = false --玩家挤在一起的时候只生成一个
                break
            end
        end
        if can_spawn then
            local dx, dz = 16 * UnitRand(), 16 * UnitRand()
            local x, y, z = px + dx, py, pz + dz
            local angle = self:GetWindAngle(v)
            self:SpawnWindSwirl(x, y, z, self.hurricane_gust_speed, angle)
            table.insert(spawn_pos, { x = x, y = y, z = z })
        end
    end

    self.windfx_spawn_rate = self.windfx_spawn_rate - 1.0
end

function Hurricane:SpawnWindSwirl(x, y, z, speed, angle)
    local swirl = SpawnPrefab("windswirl")
    swirl.Transform:SetPosition(x, y, z)
    swirl.Transform:SetRotation(angle + 180)
    swirl.AnimState:SetMultColour(1, 1, 1, math.clamp(speed, 0.0, 1.0))
    --swirl.Physics:SetMotorVel(speed, 0, 0)
end

-- 核心：更新阵风状态机
-- 阵风循环: WAIT -> RAMPUP -> ACTIVE -> RAMPDOWN -> WAIT
-- @param dt        帧间隔
-- @param percent   飓风进度 (0~1)
-- @param windstart 风开始的进度阈值
-- @param windend   风结束的进度阈值
function Hurricane:UpdateHurricaneWind(dt, percent, windstart, windend)
    if not (windstart <= percent and percent <= windend) then
        -- 不在风的有效进度范围内，重置
        self.hurricane_gust_timer = 0.0
        self.hurricane_gust_speed = 0.0
        return
    end

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
        end
    end
end

-- 检查是否可以开启飓风
local function CheckCanHurricane(self)
    if self.hurricane then
        return
    end

    if TheWorld.state.iswet then
        if GetTime() - self.last_stop_time > TUNING_HURRICANE.WIND_COOLDOWN then --冷却过了
            -- 启动飓风预兆（较短的飓风，无闪电）
            self:StartHurricaneStorm(TUNING_HURRICANE.HURRICANE_TEASE_LENGTH)
            self.is_tease = true
        end
    end
end

function Hurricane:OnUpdate(dt)
    CheckCanHurricane(self)

    if not self.hurricane then
        return
    end

    self.hurricane_timer = self.hurricane_timer + dt

    local windstart = TUNING_HURRICANE.HURRICANE_PERCENT_WIND_START
    local windend = TUNING_HURRICANE.HURRICANE_PERCENT_WIND_END
    local percent = self.hurricane_timer / self.hurricane_duration

    self:UpdateHurricaneWind(dt, percent, windstart, windend)

    -- 统一吹动玩家附近的实体，这个替代单机给每个实体加的blowinwind组件
    self:UpdateBlowEntities(dt, self.hurricane_gust_speed)

    -- 生成一些风特效
    TrySpawnWindSwirl(self, dt)

    -- 飓风持续时间到达，停止
    if percent >= 1 then
        self:StopHurricaneStorm()
    end
end

-- 风吹物品的速度配置
local BLOW_SEARCH_RADIUS = 30      -- 搜索半径（围绕每个玩家）
local BLOW_BASE_SPEED = 2          -- 基础吹动速度（TUNING.WILSON_WALK_SPEED / 4 ≈ 1.5）
local BLOW_SPEED_VAR = 0.3         -- 速度随机波动幅度（±30%）
local WINDTRAIL_SPAWN_PERIOD = 1.0 -- windtrail 生成间隔（秒）
local WINDTRAIL_SPAWN_CHANCE = 0.7 -- windtrail 生成概率

local function SpawnTrailForEnt(self, ent, dt, windspeed)
    local angle = self:GetWindAngle(ent)
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
    if ent._stop_hurricane_task then
        ent._stop_hurricane_task:Cancel()
    end
    ent._stop_hurricane_task = ent:DoTaskInTime(1, function(ent)
        ent._stop_hurricane_task = nil
        ent.Physics:SetMotorVel(0, 0, 0) --不停下来会一直跑
    end)

    -- 设置朝向为风向
    ent.Transform:SetRotation(angle)

    -- 如果物品在陷阱上，先脱离陷阱
    if ent.components.bait and ent.components.bait.trap then
        ent.components.bait.trap:RemoveBait()
    end

    -- 生成 windtrail 拖尾特效
    local key = ent.GUID
    self._trail_timers[key] = (self._trail_timers[key] or WINDTRAIL_SPAWN_PERIOD) + dt
    if self._trail_timers[key] >= WINDTRAIL_SPAWN_PERIOD then
        if math.random() < WINDTRAIL_SPAWN_CHANCE then
            local trail = SpawnPrefab("windtrail")
            local ex, ey, ez = ent.Transform:GetWorldPosition()
            trail.Transform:SetPosition(ex, ey, ez)
            trail.Transform:SetRotation(angle)
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

    self.next_update_ents_time = self.next_update_ents_time - dt
    if self.next_update_ents_time > 0 then
        return --降低一下更新频率
    end
    self.next_update_ents_time = 0.1

    -- 遍历所有玩家（联机版支持多人）
    for _, player in ipairs(AllPlayers) do
        if player:IsInShipwreckedArea() then --只在海难区域影响
            local px, py, pz = player.Transform:GetWorldPosition()
            for _, ent in ipairs(TheSim:FindEntities(px, py, pz, BLOW_SEARCH_RADIUS, nil, { "INLIMBO" }, { "smallcreature", "_inventoryitem" })) do
                SpawnTrailForEnt(self, ent, dt, windspeed)
            end
        end
    end

    -- 指定的单位在哪里都能刮风
    for target_ent, end_time in pairs(self.target_ents) do
        if GetTime() > end_time or not target_ent:IsValid() then
            self.target_ents[target_ent] = nil
        else
            local px, py, pz = target_ent.Transform:GetWorldPosition()
            for _, ent in ipairs(TheSim:FindEntities(px, py, pz, BLOW_SEARCH_RADIUS, nil, { "INLIMBO" }, { "smallcreature", "_inventoryitem" })) do
                SpawnTrailForEnt(self, ent, dt, windspeed)
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
    end
end

return Hurricane
