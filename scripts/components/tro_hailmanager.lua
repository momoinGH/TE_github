local PI = math.pi

-- 冰雹相关的 TUNING 常量（从海难 tuning.lua 提取）
local TUNING_HAIL = {
    HURRICANE_PERCENT_HAIL_START = 0.25, -- 飓风进度25%开始下冰雹
    HURRICANE_PERCENT_HAIL_END   = 0.95, -- 飓风进度95%停止
    HURRICANE_HAIL_SCALE         = 0.5,  -- 冰雹强度缩放系数
    HURRICANE_HAIL_BREAK_CHANCE  = 0.8,  -- 冰雹落地碎裂概率（80%）
    HURRICANE_HAIL_DAMAGE        = 1,    -- 冰雹伤害（预留，原版注释掉了）
    PEAK_PRECIP_INTENSITY        = 1,    -- 降水峰值强度（默认1）
}

--------------------------------------------------------------------------
-- HailManager 组件
-- 挂在 TheWorld 上，负责冰雹速率计算、粒子特效驱动、冰雹实体生成
-- 需要配合飓风组件使用，从飓风组件获取进度信息
--------------------------------------------------------------------------
local HailManager = Class(function(self, inst)
    self.inst = inst

    -- 冰雹速率（0 ~ HAIL_SCALE），由飓风进度驱动
    self.hail_rate = 0

    -- 降水峰值强度，影响粒子数量
    self.peak_precip_intensity = TUNING_HAIL.PEAK_PRECIP_INTENSITY

    -- 粒子发射器实体引用（每个玩家一个）
    -- key = player, value = hail emitter entity
    self._emitters = {}

    -- 是否正在下冰雹
    self.active = false

    self.next_spawn_task = nil

    inst:ListenForEvent("hurricanestart", function()
        if not self.next_spawn_task and math.random() < 0.5 then --随机概率下冰雹
            self.next_spawn_task = inst:DoTaskInTime(math.random(15, TUNING.TOTAL_DAY_TIME / 2), function() self:Start() end)
        end
    end)
    inst:ListenForEvent("hurricanestop", function()
        self:Stop()
    end)
end)

-- 根据飓风进度百分比更新冰雹速率
-- @param percent  飓风进度 (0~1)，从飓风组件获取
function HailManager:UpdateHailRate(percent)
    local hailstart = TUNING_HAIL.HURRICANE_PERCENT_HAIL_START
    local hailend = TUNING_HAIL.HURRICANE_PERCENT_HAIL_END

    local hailpercent = math.clamp(
        (1.0 / (hailend - hailstart)) * (percent - hailstart),
        0.0, 1.0
    )
    self.hail_rate = TUNING_HAIL.HURRICANE_HAIL_SCALE * math.sin(PI * hailpercent)
end

-- 获取当前冰雹速率
function HailManager:GetHailRate()
    return self.hail_rate
end

-- 为指定玩家创建冰雹粒子发射器（如果还没有的话）
-- 联机版中每个玩家需要各自的粒子发射器
function HailManager:GetOrCreateEmitter(player)
    if self._emitters[player] and self._emitters[player]:IsValid() then
        return self._emitters[player]
    end

    -- 生成冰雹粒子 prefab
    local emitter = SpawnPrefab("hail_sw")
    emitter.entity:SetParent(player.entity)
    emitter.particles_per_tick = 0
    emitter.splashes_per_tick = 0
    emitter.ice_per_tick = 0
    self._emitters[player] = emitter
    return emitter
end

-- 移除指定玩家的冰雹粒子发射器
function HailManager:RemoveEmitter(player)
    local emitter = self._emitters[player]
    if emitter and emitter:IsValid() then
        emitter:Remove()
    end
    self._emitters[player] = nil
end

-- 移除所有粒子发射器
function HailManager:RemoveAllEmitters()
    for player, emitter in pairs(self._emitters) do
        if emitter:IsValid() then
            emitter:Remove()
        end
    end
    self._emitters = {}
end

-- 启动冰雹
function HailManager:Start()
    if self.active then return end
    self.active = true
    self.hail_rate = 0
    self.inst:StartUpdatingComponent(self)
end

-- 停止冰雹
function HailManager:Stop()
    if self.next_spawn_task then
        self.next_spawn_task:Cancel()
        self.next_spawn_task = nil
    end

    if not self.active then return end
    self.active = false
    self.hail_rate = 0

    -- 将所有发射器的粒子数归零（让已有粒子自然消失）
    for player, emitter in pairs(self._emitters) do
        if emitter:IsValid() then
            emitter.particles_per_tick = 0
            emitter.splashes_per_tick = 0
            emitter.ice_per_tick = 0
        end
    end

    self.inst:StopUpdatingComponent(self)
end

-- 每帧更新
-- 需要外部（飓风组件）在调用前先更新 hail_rate，
-- 或者传入飓风进度让本组件自行计算
function HailManager:OnUpdate(dt)
    if not self.active then return end

    local hurricane = self.inst.components.tro_hurricane
    if hurricane and hurricane.hurricane then
        local percent = hurricane.hurricane_timer / hurricane.hurricane_duration
        self:UpdateHailRate(percent)
    else
        -- 飓风未激活时，逐渐降低冰雹速率
        self.hail_rate = math.max(0, self.hail_rate - dt * 0.5)
        if self.hail_rate <= 0 then
            self:Stop()
            return
        end
    end

    -- 清理无效玩家的发射器
    for player, emitter in pairs(self._emitters) do
        if not player:IsValid() or not player:IsInShipwreckedArea() then
            if self.inst.SoundEmitter:PlayingSound("hail") then
                self.inst.SoundEmitter:KillSound("hail")
            end
            self:RemoveEmitter(player)
        end
    end

    -- 为每个在线玩家更新冰雹粒子
    for _, player in ipairs(AllPlayers) do
        if player:IsInShipwreckedArea() then --只在海难区域下
            local emitter = self:GetOrCreateEmitter(player)
            if emitter then
                -- 根据 hail_rate 设置每帧粒子数（与原版公式一致）
                local intensity            = self.peak_precip_intensity
                emitter.particles_per_tick = (5 + intensity * 25) * self.hail_rate
                emitter.splashes_per_tick  = 16 * intensity * self.hail_rate
                emitter.ice_per_tick       = 0.05 * self.hail_rate
            end
            if not self.inst.SoundEmitter:PlayingSound("hail") then
                self.inst.SoundEmitter:PlaySound("dontstarve_DLC002/rain/islandhailAMB", "hail")
            end
        end
    end
end

-- 保存 / 加载
function HailManager:OnSave()
    return {
        hail_rate = self.hail_rate,
        active = self.active,
        peak_precip_intensity = self.peak_precip_intensity,
    }
end

function HailManager:OnLoad(data)
    if data then
        self.hail_rate = data.hail_rate or 0
        self.peak_precip_intensity = data.peak_precip_intensity or TUNING_HAIL.PEAK_PRECIP_INTENSITY
        if data.active then
            self:Start()
        end
    end
end

-- 清理（实体被移除时）
function HailManager:OnRemoveFromEntity()
    self:Stop()
    self:RemoveAllEmitters()
end

return HailManager
