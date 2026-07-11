local SHARK_TUNING = {
    MILD = {
        actions =
        {
            [ACTIONS.FISH]  = 0.01,
            [ACTIONS.REEL]  = 0.01,
            [ACTIONS.CATCH] = 0.01,
            [ACTIONS.BAIT]  = 0.01,
            [ACTIONS.NET]   = 0.01,
        },
        events = {},
        cooldown = TUNING.TOTAL_DAY_TIME * 7,
    },
    WET = {
        actions =
        {
            [ACTIONS.FISH]   = 0.01,
            [ACTIONS.REEL]   = 0.01,
            [ACTIONS.CATCH]  = 0.01,
            [ACTIONS.ATTACK] = 0.01,
            [ACTIONS.BAIT]   = 0.03,
            [ACTIONS.NET]    = 0.03,
            [ACTIONS.EAT]    = 0.03,
        },
        events =
        {
            ["boostbywave"] = 0.01,
        },
        cooldown = TUNING.TOTAL_DAY_TIME * 5,
    },
    GREEN = {
        actions =
        {
            [ACTIONS.FISH]   = 0.02,
            [ACTIONS.REEL]   = 0.02,
            [ACTIONS.CATCH]  = 0.02,
            [ACTIONS.ATTACK] = 0.02,
            [ACTIONS.BAIT]   = 0.06,
            [ACTIONS.NET]    = 0.06,
            [ACTIONS.EAT]    = 0.06,
        },
        events =
        {
            ["boostbywave"] = 0.05,
        },
        cooldown = TUNING.TOTAL_DAY_TIME * 3,
    },
    DRY = {
        actions =
        {
            [ACTIONS.FISH]  = 0.01,
            [ACTIONS.REEL]  = 0.01,
            [ACTIONS.CATCH] = 0.01,
            [ACTIONS.BAIT]  = 0.01,
            [ACTIONS.NET]   = 0.01,
        },
        events = {},
        cooldown = TUNING.TOTAL_DAY_TIME * 10,
    },
}

local function GetActiveActonsData()
    if TheWorld.state.ismild then
        return SHARK_TUNING.MILD
    elseif TheWorld.state.iswet then
        return SHARK_TUNING.WET
    elseif TheWorld.state.isdry then
        return SHARK_TUNING.DRY
    else
        return SHARK_TUNING.GREEN
    end
end

local SHARK_TIMERNAME = "shark_timetospawn"

local function OnEvent(doer, pct)
    local self = TheWorld.components.tigersharker
    local x, y, z = doer.Transform:GetWorldPosition()
    if TheWorld.Map:IsOceanAtPoint(x, y, z, true) and (math.random() <= pct or self.DEBUG_ALWAYS_SPAWN) then
        self:DoSharkEvent(doer)
    end
end

-- 根据季节改变改变监听的事件
local function OnSeasonChange(src, season)
    local self = TheWorld.components.tigersharker
    for _, v in ipairs(AllPlayers) do
        for e, f in pairs(self.events) do
            self.inst:RemoveEventCallback(e, f, v)
        end
    end

    self.events = {}
    local events = GetActiveActonsData().events
    for e, v in pairs(events) do
        self.events[e] = function(player) OnEvent(player, v) end
    end

    for _, v in ipairs(AllPlayers) do
        for e, f in pairs(self.events) do
            self.inst:ListenForEvent(e, f, v)
        end
    end
end

-- 海难虎鲨生成组件
local TigerSharker = Class(function(self, inst)
    self.inst = inst

    self.DEBUG_ALWAYS_SPAWN = nil                      --调试使用，触发action或者event时不考虑概率

    self.respawn_cooldown = TUNING.TOTAL_DAY_TIME * 10 --重生倒计时
    self.shark = nil                                   --虎鲨
    self.shark_data = nil                              --虎鲨消失的时候保存一下状态
    self.events = {}                                   --当前季节监听的事件

    local function OnActionSuccess(doer, data)
        local action = data.action.action
        local actions = GetActiveActonsData().actions
        if not actions[action] then return end
        local x, y, z = doer.Transform:GetWorldPosition()
        if TheWorld.Map:IsOceanAtPoint(x, y, z, true) and (math.random() < actions[action] or self.DEBUG_ALWAYS_SPAWN) then
            self:DoSharkEvent(doer)
        end
    end


    -- 玩家进来就监听事件和action
    local function OnPlayerJoined(src, player)
        inst:ListenForEvent("actionsuccess", OnActionSuccess, player)
        for e, f in pairs(self.events) do
            inst:ListenForEvent(e, f, player)
        end
    end

    local function OnPlayerLeft(src, player)
        inst:RemoveEventCallback("actionsuccess", OnActionSuccess, player)
        for e, f in pairs(self.events) do
            inst:RemoveEventCallback(e, f, player)
        end
    end

    inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, TheWorld)
    inst:ListenForEvent("ms_playerleft", OnPlayerLeft, TheWorld)


    self:WatchWorldState("season", OnSeasonChange)
end)

function TigerSharker:OnPostInit()
    OnSeasonChange()
    TheWorld.components.worldsettingstimer:AddTimer(SHARK_TIMERNAME, self.respawn_cooldown, true)
end

--出现的间隔，随生成条件更新
function TigerSharker:GetAppearanceCooldown()
    return GetActiveActonsData().cooldown
end

function TigerSharker:GetNearbySpawnPoint(target)
    local home_pos = self:GetHomePosition()
    if not home_pos then
        print("错误，地图上没有虎鲨的家，就生成不了虎鲨了！")
        return nil
    end

    local to_home = target:GetAngleToPoint(home_pos:Get())
    local pos = target:GetPosition()
    local offset = FindSwimmableOffset(pos, -to_home, 40, 12)
    if not offset then
        offset = FindWalkableOffset(pos, -to_home, 40, 12)
    end
    return (offset and pos + offset) or nil
end

function TigerSharker:GetHomePosition()
    local home = TroGetAnyEntByPrefab("sharkittenspawner")
    return home and home:GetPosition() or nil
end

function TigerSharker:CanSpawn(ignore_cooldown)
    if self.shark then
        return false --虎鲨还没死呢
    end
    if not ignore_cooldown and TheWorld.components.worldsettingstimer:ActiveTimerExists(SHARK_TIMERNAME) then
        return false --还没到生成时间
    end
    return true
end

function TigerSharker:SpawnShark(ignore_cooldown)
    if not self:CanSpawn(ignore_cooldown) then return end

    local shark
    if self.shark_data then
        shark = SpawnSaveRecord(self.shark_data)
        self.shark_data = nil
        if shark.components.health:GetPercent() < 0.25 then
            shark.components.health:SetPercent(0.25)
        end
    else
        shark = SpawnPrefab("tigershark")
    end

    self:TakeOwnership(shark)

    local home_pos = self:GetHomePosition()
    shark.components.knownlocations:RememberLocation("point_of_interest", home_pos)

    TheWorld.components.worldsettingstimer:StopTimer(SHARK_TIMERNAME)

    return shark
end

function TigerSharker:DoSharkEvent(target)
    if not self:CanSpawn() then return end

    local spawnpt = self:GetNearbySpawnPoint(target)
    if not spawnpt then return end

    local shark = self:SpawnShark()
    if not shark then return end

    shark.Transform:SetPosition(spawnpt:Get())

    --Look around the target for something you can interact with (kill)
    --要是没找到目标就会原地不动了
    local possible_target = FindEntity(target, 20,
        function(tar) return shark.components.combat:CanTarget(tar) end,
        nil, { --[["prey",]] "player", "companion", "bird", "butterfly", "sharkitten" })
    shark.components.combat:SuggestTarget(possible_target)
end

local function OnSharkDeath(shark)
    local self = TheWorld.components.tigersharker
    self.shark = nil

    TheWorld.components.worldsettingstimer:StopTimer(SHARK_TIMERNAME)
    TheWorld.components.worldsettingstimer:AddTimer(SHARK_TIMERNAME, math.max(self:GetAppearanceCooldown(), self.respawn_cooldown), true)
end

local function OnSharkSleep(shark)
    local self = TheWorld.components.tigersharker
    shark.shark_remove_task = shark:DoTaskInTime(1, function() self:DespawnShark() end)
end

local function OnSharkWake(shark)
    if shark.shark_remove_task then
        shark.shark_remove_task:Cancel()
        shark.shark_remove_task = nil
    end
end

function TigerSharker:TakeOwnership(shark)
    if self.shark and self.shark:IsValid() then
        self.inst:RemoveEventCallback("onremove", OnSharkDeath, self.shark)
        self.inst:RemoveEventCallback("entitywake", OnSharkWake, self.shark)
        self.inst:RemoveEventCallback("entitysleep", OnSharkSleep, self.shark)
    end

    self.shark = shark
    self.inst:ListenForEvent("onremove", OnSharkDeath, shark)
    self.inst:ListenForEvent("entitywake", OnSharkWake, shark)
    self.inst:ListenForEvent("entitysleep", OnSharkSleep, shark)
end

function TigerSharker:DespawnShark()
    local shark = self.shark
    self.shark = nil
    if not (shark and shark:IsValid()) then return end

    --If the shark isn't dead save the data here
    if not shark.components.health:IsDead() then
        self.shark_data = shark:GetSaveRecord()
    end
    shark:Remove()
end

function TigerSharker:OnSave()
    local data = {
        shark_data = self.shark_data,
    }
    local refs = {}
    if self.shark and self.shark:IsValid() then
        data.shark = self.shark.GUID
        table.insert(refs, self.shark.GUID)
    end
    return data, (#refs > 0 and refs or nil)
end

function TigerSharker:OnLoad(data)
    if not data then return end

    self.shark_data = data.shark_data
end

function TigerSharker:LoadPostPass(ents, data)
    if not data then return end
    if ents[data.shark] then
        self:TakeOwnership(ents[data.shark].entity)
    end
end

return TigerSharker
