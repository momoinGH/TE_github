local tasks = {
    "WindyPlainsisland",
    -- "WindyPlains"
}

for _, t in ipairs(tasks) do
    AddTaskPreInit(t, function(task)
        task.room_tags = task.room_tags or {}
        table.insert(task.room_tags, "tropical")   --我们mod地形
        table.insert(task.room_tags, "windy")      --模块专属标签
        table.insert(task.room_tags, "RoadPoison") --禁止生成卵石路
        table.insert(task.room_tags, "nohasslers") --不生成熊大
    end)
end

AddLevelPreInitAny(function(level)
    if level.location ~= "forest" then
        return
    end

    for _, t in ipairs(tasks) do
        table.insert(level.tasks, t)
    end
end)
