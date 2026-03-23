local PickButterfly = require("prefabs/tro_butterflydefs").PickButterfly

AddComponentPostInit("butterflyspawner", function(self, inst)
    local SpawnButterflyForPlayer, _scheduledtasks

    local ScheduleSpawn = Hooks.FindUpvalue(self.OnPostInit, "ToggleUpdate", "ScheduleSpawn")
    if not ScheduleSpawn then
        local OnPlayerJoined = Hooks.GetEventCallback(inst, "ms_playerjoined", TheWorld, "scripts/components/butterflyspawner.lua")
        ScheduleSpawn = OnPlayerJoined and Hooks.FindUpvalue(OnPlayerJoined, "ScheduleSpawn")
    end
    if ScheduleSpawn then
        SpawnButterflyForPlayer = Hooks.GetUpvalue(ScheduleSpawn, "SpawnButterflyForPlayer")
        _scheduledtasks = Hooks.GetUpvalue(ScheduleSpawn, "_scheduledtasks")
    end
    if not (SpawnButterflyForPlayer and _scheduledtasks) then
        print("没有hook到butterflyspawner组件的ScheduleSpawn和_scheduledtasks，无法根据地形改变生成的蝴蝶")
        return
    end

    local BUTTERFLY_TAGS = Hooks.FindUpvalue(SpawnButterflyForPlayer, "BUTTERFLY_TAGS") or { "butterfly" }
    local _maxbutterflies = Hooks.FindUpvalue(SpawnButterflyForPlayer, "_maxbutterflies") or TUNING.MAX_BUTTERFLIES
    local function NewSpawnButterflyForPlayer(player, reschedule)
        local pt = player:GetPosition()
        local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 64, BUTTERFLY_TAGS)
        if #ents < _maxbutterflies then
            local spawnflower = GetSpawnPoint(player)
            if spawnflower ~= nil then
                local prefab = PickButterfly(player)
                local butterfly = SpawnPrefab(prefab)
                if butterfly then
                    if butterfly.components.pollinator ~= nil then
                        butterfly.components.pollinator:Pollinate(spawnflower)
                    end
                    butterfly.components.homeseeker:SetHome(spawnflower)
                    -- KAJ: TODO: Butterflies can be despawned before getting to the rest of the logic if this is above the homeseeker
                    butterfly.Physics:Teleport(spawnflower.Transform:GetWorldPosition())
                end
            end
        end
        _scheduledtasks[player] = nil
        reschedule(player)
    end

    Hooks.SetUpvalue(ScheduleSpawn, "SpawnButterflyForPlayer", NewSpawnButterflyForPlayer)
end)
