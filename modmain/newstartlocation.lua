-- 指定出生点
AddLevelPreInitAny(function(level)
    if level.location == "forest" then
        if TUNING.tropical.startlocation == "shipwrecked" then
            level.overrides.start_location = "SWStart"
            level.valid_start_tasks = { "HomeIsland" }
        elseif TUNING.tropical.startlocation == "hamlet" then
            level.overrides.start_location = "HamStart"
            level.valid_start_tasks = { "岛一平原" }
        end
    end
end)
