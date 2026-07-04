local cave_tasks = {
    "underwaterdivide", --虚空地形
    "SandyBiome",
    "ReefBiome",
    "KelpBiome",
    "RockyBiome",
    "MoonBiome",
    "OpenWaterBiome",
    "task_underground_beach",
    "task_underwaterothers",
    "task_underwater_kraken_zone",
    "secretcavedivisor",
    "task_secretcave1",
    "task_underwaterlavarock",
    "task_underwatermagmafield",
    "task_underwaterwatercoral",

    "UnderwaterStart",
    "atlantidaExitRoom",
    "UnderwaterExit2",
}

for _, t in ipairs(cave_tasks) do
    AddTaskPreInit(t, function(task)
        task.room_tags = task.room_tags or {}
        table.insert(task.room_tags, "tropical")   --我们mod地形
        table.insert(task.room_tags, "underwater") --模块专属标签
    end)
end

AddLevelPreInitAny(function(level)
    if level.location == "cave" then
        level.overrides.keep_disconnected_tiles = true

        for _, task in ipairs(cave_tasks) do
            table.insert(level.tasks, task)
        end
    end
end)

--地上入口
AddTaskSetPreInitAny(function(taskset)
    if taskset.location == "forest" then
        table.insert(taskset.tasks, "EntranceToReef")
    end
end)
