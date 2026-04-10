local SHARK_TUNING = {
    [SEASONS.MILD] =
    {
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
    [SEASONS.WET] =
    {
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
    [SEASONS.GREEN] =
    {
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
    [SEASONS.DRY] =
    {
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

local function GetTotalTime()
    return (TheWorld.state.cycles + TheWorld.state.time) * TUNING.TOTAL_DAY_TIME
end

local function GetActiveActons()
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

-- 海难虎鲨生成组件
local TigerSharker = Class(function(self, inst)
    self.inst = inst

    self.next_spawn_time = self:GetAppearanceCooldown() --下次生成时间
    self.shark = nil                                    --虎鲨
    self.shark_data = nil                               --虎鲨消失的时候保存一下状态

    local function OnActionSuccess(doer, buf)
        if GetTotalTime() < self.next_spawn_time then return end --没到生成时间

        local actions = GetActiveActons()
        if not actions[buf.action] then return end
        local x, y, z = doer.Transform:GetWorldPosition()
        if TheWorld.Map:IsOceanAtPoint(x, y, z, true) and math.random() < actions[buf.action] or true then --TODO
            self:DoSharkEvent(doer)
        end
    end

    local function OnPlayerJoined(src, player)
        inst:ListenForEvent("actionsuccess", OnActionSuccess, player)
    end

    local function OnPlayerLeft(src, player)
        inst:RemoveEventCallback("actionsuccess", OnActionSuccess, player)
    end

    inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, TheWorld)
    inst:ListenForEvent("ms_playerleft", OnPlayerLeft, TheWorld)

    local function OnSeasonChange(inst, season)
        for _, v in ipairs(AllPlayers) do
            -- TODO
        end
    end
    self:WatchWorldState("season", OnSeasonChange)
end)

--出现的间隔，随生成条件更新
function GetAppearanceCooldown()
    local actions = GetActiveActons()
    return actions.cooldown
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
    local home = TroGetAnyEntByPrefab("sharkhome")
    return home and home:GetPosition() or nil
end

function TigerSharker:DoSharkEvent(target)
    local spawnpt = self:GetNearbySpawnPoint(target)
    if not spawnpt then return end

    if self.shark_data then
        shark = SpawnSaveRecord(self.shark_data)
        self.shark_data = nil
    else
        shark = SpawnPrefab(self.shark_prefab)
    end
    if shark.components.health:GetPercent() < 0.25 then
        shark.components.health:SetPercent(0.25)
    end
    self:TakeOwnership(shark)
    shark.Transform:SetPosition(spawnpt:Get())
    local home_pos = self:GetHomePosition()
    shark.components.knownlocations:RememberLocation("point_owaf_interest", home_pos)

    --Look around the target for something you can interact with (kill)
    local possible_target = FindEntity(target, 20,
        function(tar) return shark.components.combat:CanTarget(tar) end,
        nil, { "prey", "player", "companion", "bird", "butterfly", "sharkitten" })
    shark.components.combat:SuggestTarget(possible_target)

    self.next_spawn_time = GetTotalTime() + self:GetAppearanceCooldown()
end

local function OnSharkDeath(shark)
    local self = TheWorld.components.tigersharker
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
        self.inst:RemoveEventCallback("death", OnSharkDeath, self.shark)
        self.inst:RemoveEventCallback("entitywake", OnSharkWake, self.shark)
        self.inst:RemoveEventCallback("entitysleep", OnSharkSleep, self.shark)
    end

    self.shark = shark
    self.inst:ListenForEvent("death", OnSharkDeath, shark)
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
        next_spawn_time = self.next_spawn_time
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

    self.next_spawn_time = data.next_spawn_time or self.next_spawn_time
end

function TigerSharker:LoadPostPass(ents, data)
    if not data then return end
    if ents[data.shark] then
        self:TakeOwnership(ents[data.shark].entity)
    end
end

return TigerSharker
