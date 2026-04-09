local function GetTotalTime()
    return (TheWorld.state.cycles + TheWorld.state.time) * TUNING.TOTAL_DAY_TIME
end

local function RemoveSpawnCooldown(player_data)
    if player_data.spawn_cd_task then
        player_data.spawn_cd_task:Cancel()
        player_data.spawn_cd_task = nil
    end
end

local function CancelSpawnTask(player_data)
    if player_data.spawn_task then
        player_data.spawn_task:Cancel()
        player_data.spawn_task = nil
    end
end

local function BindEnt(self, player_data, ent)
    player_data.all_ents[ent] = true
    self.inst:ListenForEvent("onremove", self._on_ent_remove, ent)
end

local function OnPlayerLeft(self, player)
    local player_data = self.player_datas[player.userid]
    if not player_data then return end

    RemoveSpawnCooldown(player_data)
    CancelSpawnTask(player_data)
end

-- 尝试去生成
local function TrySpawnEnt(inst, self, player)
    if not player:IsValid() then --以防万一
        OnPlayerLeft(self, player)
        return
    end

    local player_data = self.player_datas[player.userid]
    player_data.cur_spawn_count = player_data.cur_spawn_count or 0
    local need_count = self.max_count - math.max(player_data.cur_spawn_count, GetTableSize(player_data.all_ents))
    local ents = self.spawn_fn(inst, player, need_count)
    if ents and EntityScript.is_instance(ents) then
        ents = { ents }
    end

    for _, ent in ipairs(ents or {}) do
        BindEnt(self, player_data, ent)
        player_data.cur_spawn_count = player_data.cur_spawn_count + 1
    end

    if player_data.cur_spawn_count >= self.max_count or GetTableSize(player_data.all_ents) >= self.max_count then
        -- 数量足够了
        player_data.cur_spawn_count = 0
        player_data.next_spawn_time = nil
        CancelSpawnTask(player_data)
    end
end

-- 生成冷却结束
local function OnSpawnCDDone(inst, self, player)
    local player_data = self.player_datas[player.userid]
    RemoveSpawnCooldown(player_data)
    if not player_data.spawn_task then
        player_data.spawn_task = self.inst:DoPeriodicTask(self.spawn_check_interval, TrySpawnEnt, 0, self, player)
    end
end

local function OnEntRemove(self, ent)
    for userid, data in pairs(self.player_datas) do
        if data.all_ents[ent] then
            data.all_ents[ent] = nil
            local player = TroGetPlayerById(userid)
            if not data.spawn_cd_task and player then
                local time = FunctionOrValue(self.spawn_interval, self.inst, player)
                data.next_spawn_time = GetTotalTime() + time
                data.spawn_cd_task = self.inst:DoTaskInTime(time, OnSpawnCDDone, self, player)
            end
        end
    end
end

local function OnPlayerJoined(self, player)
    local is_first = not self.player_datas[player.userid]
    self.player_datas[player.userid] = self.player_datas[player.userid] or {
        all_ents = {},
    }
    local player_data = self.player_datas[player.userid]
    if player_data.spawn_cd_task then
        return --正在倒计时
    end
    if player_data.spawn_task then
        return --正在生成
    end
    if GetTableSize(player_data.all_ents) >= self.max_count then
        return --当前存活数量已经足够了
    end

    if not player_data.next_spawn_time then
        if is_first and self.first_spawn_time then
            player_data.next_spawn_time = self.first_spawn_time
        else
            player_data.next_spawn_time = GetTotalTime() + FunctionOrValue(self.spawn_interval, self.inst)
        end
        player_data.next_spawn_time = math.max(player_data.next_spawn_time, GetTotalTime() + math.random(5, 10)) --给点保护时间
    end

    if GetTotalTime() >= player_data.next_spawn_time then
        OnSpawnCDDone(self.inst, self, player) --可以生成
    else
        --冷却中
        CancelSpawnTask(player_data)
        RemoveSpawnCooldown(player_data)
        local time = math.max(0, player_data.next_spawn_time - GetTotalTime())
        player_data.spawn_cd_task = self.inst:DoTaskInTime(time, OnSpawnCDDone, self, player)
    end
end


local function OnEnableChange(self, enable)
    self.inst:RemoveEventCallback("ms_playerjoined", self._on_player_joined, TheWorld)
    self.inst:RemoveEventCallback("ms_playerleft", self._on_player_left, TheWorld)
    if enable then
        if not self.spawn_fn then
            TroErrorHandle("没生成函数怎么开始！" .. tostring(self.inst), false)
            return
        end

        self.inst:ListenForEvent("ms_playerjoined", self._on_player_joined, TheWorld)
        self.inst:ListenForEvent("ms_playerleft", self._on_player_left, TheWorld)

        for _, v in ipairs(AllPlayers) do
            OnPlayerJoined(self, v)
        end
    else
        for userid, data in pairs(self.player_datas) do
            CancelSpawnTask(data)
            RemoveSpawnCooldown(data)
        end
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

--- 每个玩家附近周期生成
--- 实体生成足够数量后停止生成，任意一个实体死亡会才会开始冷却
--- 这既可以当成组件用，也可以当普通的类创建对象用，因此你不能在文件里使用inst.components.tro_playernearspawn这样的代码
local PlayerNearSpawnForEach = Class(function(self, inst)
    assert(inst)
    self.inst = inst

    -- 可赋值
    self.spawn_fn = nil                         --生成任务，返回值为true才表示玩家条件满足生成了东西，就会进入冷却
    self.spawn_interval = TUNING.TOTAL_DAY_TIME --生成间隔
    self.first_spawn_time = nil                 --第一次生成所需时间，在世界多少时间之后
    self.enable = true                          --是否启用
    self.max_count = 1
    self.spawn_check_interval = 1

    --玩家数据
    self.player_datas = {
        -- aaa = { --玩家id
        --     next_spawn_time = 10000, --下一次生成时间
        --     spawn_task = nil, --正在生成任务
        --     spawn_cd_task = nil --生成冷却
        -- }
    }

    self._on_player_joined = function(src, player) OnPlayerJoined(self, player) end
    self._on_player_left = function(src, player) OnPlayerLeft(self, player) end
    self._on_ent_remove = function(src) OnEntRemove(self, src) end

    self.inited = false
    inst:DoTaskInTime(0, Init, self) --延迟一帧，等OnLoad恢复数据
end, nil, {
    enable = onenable
})

function PlayerNearSpawnForEach:OnRemoveFromEntity()
    OnEnableChange(self, false)
end

function PlayerNearSpawnForEach:OnSave()
    local player_datas = {}
    local refs = {}
    local all_ents = {}
    for userid, data in pairs(self.player_datas) do
        all_ents[userid] = {}
        for ent, _ in pairs(data.all_ents) do
            table.insert(all_ents[userid], ent.GUID)
            table.insert(refs, ent.GUID)
        end
        player_datas[userid] = { next_spawn_time = data.next_spawn_time }
    end

    return {
        all_ents = all_ents,
        global_next_spawn_time = self.global_next_spawn_time,
        player_datas = player_datas,
    }, refs
end

function PlayerNearSpawnForEach:OnLoad(data)
    if not data then return end

    self.player_datas = data.player_datas or self.player_datas
end

function PlayerNearSpawnForEach:LoadPostPass(ents, data)
    if data and data.all_ents then
        for userid, ents_id in pairs(data.all_ents) do
            local player_data = self.player_datas[userid]
            if player_data then
                player_data.all_ents = player_data.all_ents or {}
                for i, guid in ipairs(ents_id) do
                    local ent = ents[guid]
                    if ent ~= nil then
                        BindEnt(self, player_data, ent.entity)
                    end
                end
            end
        end
    end
end

return PlayerNearSpawnForEach
