AddLevelPreInitAny(function(level)
    if level.location == "forest" then
        table.insert(level.tasks, "GREENSWAMP_TASK_FOREST_ISLAND")
        -- table.insert(level.tasks, "GREENSWAMP_TASK_FOREST")
    end
end)
