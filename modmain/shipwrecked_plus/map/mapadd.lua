AddLevelPreInitAny(function(level)
    if level.location == "forest" then
        table.insert(level.tasks, "pandataskjunto")
        table.insert(level.tasks, "pantanojunto")
    end
end)
