local Util = require "tools/utils"

AddClassPostConstruct("components/butterflyspawner", function(Spawner)
    local ScheduleSpawn = Util.ChainFindUpvalue(Spawner.OnPostInit, "ToggleUpdate", "ScheduleSpawn")
    if ScheduleSpawn then
        local old_SpawnButterflyForPlayer, key = Util.FindUpvalue(ScheduleSpawn, "SpawnButterflyForPlayer")
        if old_SpawnButterflyForPlayer then
            local BUTTERFLY_TAGS = Util.FindUpvalue(old_SpawnButterflyForPlayer, "BUTTERFLY_TAGS") or { "butterfly" }
            local _maxbutterflies = Util.FindUpvalue(old_SpawnButterflyForPlayer, "_maxbutterflies") or
            TUNING.MAX_BUTTERFLIES
            local _scheduledtasks = Util.FindUpvalue(old_SpawnButterflyForPlayer, "_scheduledtasks") or {}
            local function SpawnButterflyForPlayer(player, reschedule)
                local pt = player:GetPosition()
                local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 64, BUTTERFLY_TAGS)
                if #ents < _maxbutterflies then
                    local spawnflower = GetSpawnPoint(player)
                    if spawnflower ~= nil then
                        local butterfly
                        local map = TheWorld.Map
                        local ground = map:GetTile(map:GetTileCoordsAtPoint(pt:Get()))
                        if ground == GROUND.DEEPRAINFOREST or ground == GROUND.RAINFOREST then
                            butterfly = SpawnPrefab("glowfly")
                        elseif ground == GROUND.WINDY then
                            butterfly = SpawnPrefab("goddess_butterfly")
                        elseif ground == GROUND.JUNGLE or ground == GROUND.MEADOW or ground == GROUND.BEACH then
                            butterfly = SpawnPrefab("butterfly_tropical")
                        end
                        if not butterfly then
                            return old_SpawnButterflyForPlayer(player, reschedule)
                        end
                        if butterfly.components.pollinator ~= nil then
                            butterfly.components.pollinator:Pollinate(spawnflower)
                        end
                        if butterfly.components.homeseeker ~= nil then
                            butterfly.components.homeseeker:SetHome(spawnflower)
                        end
                        -- KAJ: TODO: Butterflies can be despawned before getting to the rest of the logic if this is above the homeseeker
                        butterfly.Physics:Teleport(spawnflower.Transform:GetWorldPosition())
                    end
                end
                _scheduledtasks[player] = nil
                reschedule(player)
            end
            debug.setupvalue(ScheduleSpawn, key, SpawnButterflyForPlayer)
        end
    end
end)
