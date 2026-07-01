AddLevelPreInitAny(function(level)
    if level.location == "forest" then
        table.insert(level.tasks, "gorgeisland")
        table.insert(level.tasks, "quagmireblue")
        table.insert(level.tasks, "quagmirepink")
        table.insert(level.tasks, "gorgeislandchicken")
        table.insert(level.tasks, "gorgeislandforest")
    end
end)
