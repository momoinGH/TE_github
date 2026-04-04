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

local TrySpawnEnt

-- 生成冷却结束
local function OnPlayerSpawnCDDone(inst, self, player)
    player_data = self.player_datas[player.userid]
    if not player_data.spawn_task then
        player_data.spawn_task = self.inst:DoPeriodicTask(0.1, TrySpawnEnt, 0, self, player)
    end
end

-- 生成成功，重新倒计时
local function OnPlayerSpawned(self, player, player_data, next_spawn_time)
    CancelSpawnTask(player_data)
    RemoveSpawnCooldown(player_data)
    local time = math.max(0, next_spawn_time - GetTotalTime())
    player_data.spawn_cd_task = self.inst:DoTaskInTime(time, OnPlayerSpawnCDDone, self, player)
end

-- 尝试去生成
TrySpawnEnt = function(inst, self, player)
    if not self.spawn_fn(player) then
        return
    end

    --生成成功
    local next_spawn_time = self:GetNextSpawnTime(player, true)
    if self.each_player_spawn then
        local data = self.player_datas[player.userid]
        OnPlayerSpawned(self, player, data, next_spawn_time)
        data.next_spawn_time = next_spawn_time
    else
        for _, v in ipairs(AllPlayers) do
            if self.player_datas[v.userid] then --对每个玩家停止倒计时，重新倒计时
                OnPlayerSpawned(self, v, self.player_datas[v.userid], next_spawn_time)
            end
        end
        self.global_next_spawn_time = next_spawn_time
        self.is_first = false
    end
end


local function OnPlayerJoined(self, player)
    local next_spawn_time = self:GetNextSpawnTime(player) --创建表之前获取
    self.player_datas[player.userid] = self.player_datas[player.userid] or {}
    local player_data = self.player_datas[player.userid]
    player_data.next_spawn_time = next_spawn_time

    if GetTotalTime() >= next_spawn_time then
        OnPlayerSpawnCDDone(self.inst, self, player)
    end
end

local function OnPlayerLeft(self, player)
    local player_data = self.player_datas[player.userid]
    if not player_data then return end

    RemoveSpawnCooldown(player_data)
    CancelSpawnTask(player_data)
end

--- 玩家附近生成辅助类，专门用于在玩家附近生成一些单位
--- 这不是一个组件，其他组件里可以直接创建这个对象，self.xxx = PlayerNearSpawn(inst,...)，然后外部调用这里面的方法，别忘了调用OnSave和OnLoad
local PlayerNearSpawn = Class(function(self, inst)
    assert(inst)
    self.inst = inst

    --玩家数据
    self.player_datas = {
        -- aaa = {
        --     next_spawn_time = 10000, --下一次生成时间
        --     spawn_task = nil, --正在生成任务
        --     spawn_cd_task = nil --生成冷却
        -- }
    }

    -- 可赋值
    self.spawn_fn = nil                         --生成任务，返回值为true才表示玩家条件满足生成了东西，就会进入冷却
    self.spawn_interval = TUNING.TOTAL_DAY_TIME --生成间隔
    self.first_spawn_time = nil                 --第一次生成所需时间
    self.each_player_spawn = false              --生成实体是否对每个玩家单独计算冷却，比如boss只生成一个，蝙蝠小怪对每个玩家都生成

    --用于全局生成
    self.global_next_spawn_time = nil
    self.is_first = true

    self._on_player_joined = function(src, player) OnPlayerJoined(self, player) end
    self._on_player_left = function(src, player) OnPlayerLeft(self, player) end
end)

-- 所有字段初始化好后就可以调用这个初始化了
function PlayerNearSpawn:Start()
    assert(self.spawn_fn, "没生成函数怎么开始！")

    self.inst:ListenForEvent("ms_playerjoined", self._on_player_joined, TheWorld)
    self.inst:ListenForEvent("ms_playerleft", self._on_player_left, TheWorld)

    for _, v in ipairs(AllPlayers) do
        OnPlayerJoined(self, v)
    end
end

function PlayerNearSpawn:OnRemoveFromEntity()
    self.inst:RemoveEventCallback("ms_playerjoined", self._on_player_joined, TheWorld)
    self.inst:RemoveEventCallback("ms_playerleft", self._on_player_left, TheWorld)
end

function PlayerNearSpawn:GetNextSpawnTime(player, get_new)
    if self.each_player_spawn then
        local player_data = self.player_datas[player.userid]
        if player_data then
            if get_new then
                return FunctionOrValue(self.spawn_interval, self.inst, player, player_data) + GetTotalTime()
            else
                return player_data.next_spawn_time
            end
        else
            --这个玩家是第一次
            if self.first_spawn_time then
                return self.first_spawn_time + GetTotalTime()
            else
                return FunctionOrValue(self.spawn_interval, self.inst, player, player_data) + GetTotalTime()
            end
        end
    else
        if self.is_first and self.first_spawn_time then
            return self.first_spawn_time + GetTotalTime()
        else
            if get_new or not self.global_next_spawn_time then
                return FunctionOrValue(self.spawn_interval, self.inst) + GetTotalTime()
            else
                return self.global_next_spawn_time
            end
        end
    end
end

function PlayerNearSpawn:OnSave()
    for userid, data in pairs(self.player_datas) do
        RemoveSpawnCooldown(data)
        CnacelSpawnTask(data)
    end

    return {
        global_next_spawn_time = self.global_next_spawn_time,
        player_datas = self.player_datas,
        is_first = self.is_first
    }
end

function PlayerNearSpawn:OnLoad(data)
    if not data then return end

    self.player_datas = data.player_datas or self.player_datas
    self.global_next_spawn_time = data.global_next_spawn_time or self.global_next_spawn_time
    if data.is_first ~= nil then
        self.is_first = data.is_first
    end
end

return PlayerNearSpawn
