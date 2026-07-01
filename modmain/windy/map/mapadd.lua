AddLevelPreInitAny(function(level)
    if level.location ~= "forest" then
        return
    end

    table.insert(level.tasks, "WindyPlainsisland")
    -- table.insert(level.tasks, "WindyPlains")
end)
