local ta_worldgen = TA_CONFIG.WORLDGEN

if GLOBAL.rawget(GLOBAL, "WorldSim") then
    local worldsim = GLOBAL.getmetatable(GLOBAL.WorldSim).__index

    ------海岸线调整
    if ta_worldgen.coastline then
        worldsim.SeparateIslands = function(self) print("Not Seperating Islands") end
    end
end




-----------------------出生地调整-----------------------------
-- if ta_worldgen.multiplayerportal == "shipwrecked" and ta_worldgen.shipwrecked then
--     AddLevelPreInitAny(function(level)
--         if level.location == "forest" then
--             -- table.insert(level.tasks, "HomeIsland_start")
--             level.overrides.start_location = "SWStart"
--             level.valid_start_tasks = { "HomeIsland" }
--         elseif level.location == "cave" and (not ta_worldgen.together) then
--             -- table.insert(level.tasks, "Plains_start")
--             -- level.overrides.start_location = "HamStart"
--             level.valid_start_tasks = { "Volcano entrance" }
--         end
--     end)
-- elseif ta_worldgen.multiplayerportal == "hamlet" and ta_worldgen.hamlet then
--     AddLevelPreInitAny(function(level)
--         if level.location == "forest" then
--             -- table.insert(level.tasks, "Plains_start")
--             level.overrides.start_location = "HamStart"
--             level.valid_start_tasks = { "Plains" }
--         elseif level.location == "cave" and (not ta_worldgen.together) then
--             -- table.insert(level.tasks, "Plains_start")
--             -- level.overrides.start_location = "HamStart"
--             level.valid_start_tasks = { "HamMudWorld" }
--         end
--     end)
-- end
