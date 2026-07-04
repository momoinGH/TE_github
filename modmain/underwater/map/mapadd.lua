--[[
把地形生成在主大陆之外是通过separavulcao、underwaterdivide塞入大量虚空房间，然后再让地形用这个task给的keys解锁
世界生成后处理可能会清理/修正不连通区域。keep_disconnected_tiles允许那些和主大陆不接壤的 tile 被保留下来
不过这些很多的虚空房间也会把主大陆挤到墙角
]]

local forest_tasks = {
    "EntranceToReef" --入口
}

local cave_tasks = {
    "separavulcao",
    "underwaterdivide",
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


AddTaskSetPreInitAny(function(taskset)
    if taskset.location == "forest" then
        table.insert(taskset.tasks, "EntranceToReef")
    end
end)
