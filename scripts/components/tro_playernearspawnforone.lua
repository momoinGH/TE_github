local function RemoveSpawnCooldown(self)
    if self.spawn_cd_task then
        self.spawn_cd_task:Cancel()
        self.spawn_cd_task = nil
    end
end

local function CancelSpawnTask(self, is_success)
    if self.spawn_task then
        self.spawn_task:Cancel()
        self.spawn_task = nil
        if self.stop_spawn_fn then
            self.stop_spawn_fn(self.inst, is_success)
        end
    end
end

local function BindEnt(self, ent)
    self.all_ents[ent] = true
    self.inst:ListenForEvent("onremove", self._on_ent_remove, ent)
end

local function TrySpawnEnt(inst, self)
    if #AllPlayers <= 0 then --没玩家了，不再生成
        CancelSpawnTask(self, false)
        return
    end

    local all_players = shuffleArray(shallowcopy(AllPlayers)) --打乱顺序
    for _, player in ipairs(all_players) do
        local need_count = self.max_count - math.max(self.cur_spawn_count or 0, GetTableSize(self.all_ents))
        local ents = self.spawn_fn(inst, player, need_count)
        if ents and EntityScript.is_instance(ents) then
            ents = { ents }
        end
        for _, ent in ipairs(ents or {}) do
            BindEnt(self, ent)
            self.cur_spawn_count = self.cur_spawn_count + 1
        end

        if self.cur_spawn_count >= self.max_count or GetTableSize(self.all_ents) >= self.max_count then --第一个是一波固定的生成个数，第二个是单位死亡后补充不能超过这个数
            -- 数量足够了
            self.cur_spawn_count = 0
            self.next_spawn_time = nil
            CancelSpawnTask(self, true)
            break
        end
    end
end


local function StartSpawn(self)
    if not self.spawn_task then
        if self.start_spawn_fn then
            self.start_spawn_fn(self.inst)
        end
        self.spawn_task = self.inst:DoPeriodicTask(self.spawn_check_interval, TrySpawnEnt, 0, self)
    end
end

-- 生成冷却结束
local function OnSpawnCDDone(inst, self)
    RemoveSpawnCooldown(self)
    StartSpawn(self)
end

local function OnPlayerJoined(self, player)
    if self.spawn_cd_task then
        return --正在倒计时
    end
    if self.spawn_task then
        return --正在生成
    end
    if GetTableSize(self.all_ents) >= self.max_count then
        return --当前存活数量已经足够了
    end

    if not self.next_spawn_time then
        if self.is_first then
            self.is_first = false
            self.next_spawn_time = self.first_spawn_time
        end
        if not self.next_spawn_time then
            self.next_spawn_time = TroGetTotalTime() + FunctionOrValue(self.spawn_interval, self.inst)
        end
    end
    self.next_spawn_time = math.max(self.next_spawn_time, TroGetTotalTime() + math.random(5, 10)) --给点保护时间

    if TroGetTotalTime() >= self.next_spawn_time then
        --可以生成
        StartSpawn(self)
    else
        --冷却中
        if not self.spawn_cd_task then
            local time = self.next_spawn_time - TroGetTotalTime()
            self.spawn_cd_task = self.inst:DoTaskInTime(time, OnSpawnCDDone, self)
        end
    end
end

local function OnEntRemove(self, ent)
    self.all_ents[ent] = nil
    if not self.spawn_cd_task and GetTableSize(self.all_ents) < self.max_count then
        local time = FunctionOrValue(self.spawn_interval, self.inst)
        self.next_spawn_time = TroGetTotalTime() + time
        self.spawn_cd_task = self.inst:DoTaskInTime(time, OnSpawnCDDone, self)
    end
end

----------------------------------------------------------------------------------------------------
local function OnEnableChange(self, enable)
    self.inst:RemoveEventCallback("ms_playerjoined", self._on_player_joined, TheWorld)
    if enable then
        if not self.spawn_fn then
            TroErrorHandle("没生成函数怎么开始！" .. tostring(self.inst), false)
            return
        end

        self.inst:ListenForEvent("ms_playerjoined", self._on_player_joined, TheWorld)

        for _, v in ipairs(AllPlayers) do
            OnPlayerJoined(self, v)
        end
    else
        CancelSpawnTask(self, false)
        RemoveSpawnCooldown(self)
        self.next_spawn_time = nil
    end
end

local function Init(inst, self)
    self.inited = true
    OnEnableChange(self, self.enable)
end

local function onenable(self, enable)
    if self.inited then
        OnEnableChange(self, enable)
    end
end

--- 全局周期生成，随机选择一个玩家附近生成
--- 实体生成足够数量后停止生成，任意一个实体死亡会才会开始冷却
local PlayerNearSpawnForOne = Class(function(self, inst)
    self.inst = inst
    assert(inst)

    -- 可赋值
    self.spawn_fn = nil --生成任务，返回值为true才表示玩家条件满足生成了东西，就会进入冷却
    self.start_spawn_fn = nil
    self.stop_spawn_fn = nil
    self.spawn_interval = TUNING.TOTAL_DAY_TIME --生成间隔，就是死了再重新生成的间隔
    self.first_spawn_time = nil                 --第一次生成所需时间，在世界多少时间之后
    self.enable = true                          --是否启用
    self.max_count = 1
    self.spawn_check_interval = 1

    self.all_ents = {} --已经生成的实体id
    self.cur_spawn_count = 0
    self.spawn_task = nil
    self.spawn_cd_task = nil
    self.next_spawn_time = nil
    self.is_first = true

    self._on_player_joined = function(src, player) OnPlayerJoined(self, player) end
    self._on_ent_remove = function(src) OnEntRemove(self, src) end

    self.inited = false
    inst:DoTaskInTime(0, Init, self)
end, nil, {
    enable = onenable
})

function PlayerNearSpawnForOne:SetNextSpawnTime(override_interval)
    self.next_spawn_time = GetTime() + math.max((override_interval or self.spawn_interval), 0)
    if self.is_first and self.first_spawn_time then --第一次生成所需时间，两者取其长
        self.next_spawn_time = math.max(self.first_spawn_time, self.next_spawn_time)
    end
    self.is_first = false
end

function PlayerNearSpawnForOne:OnRemoveFromEntity()
    OnEnableChange(self, false)
end

function PlayerNearSpawnForOne:OnSave()
    local refs = {}
    local ents_id = {}
    for ent, _ in pairs(self.all_ents) do
        table.insert(ents_id, ent.GUID)
        table.insert(refs, ent.GUID)
    end

    return {
        ents_id = ents_id,
        next_spawn_time = self.next_spawn_time,
        is_first = self.is_first
    }, refs
end

function PlayerNearSpawnForOne:OnLoad(data)
    if not data then return end

    self.next_spawn_time = data.next_spawn_time or self.next_spawn_time
    if data.is_first ~= nil then
        self.is_first = data.is_first
    end
end

function PlayerNearSpawnForOne:LoadPostPass(ents, data)
    if data and data.ents_id then
        for i, guid in ipairs(data.ents_id) do
            local ent = ents[guid]
            if ent ~= nil then
                BindEnt(self, ent.entity)
            end
        end
    end
end

return PlayerNearSpawnForOne
