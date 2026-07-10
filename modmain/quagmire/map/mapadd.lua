local tasks = {
    -- "gorgeisland",
    -- "quagmireblue",
    -- "quagmirepink",
    -- "gorgeislandchicken",
    -- "gorgeislandforest",

    -- 这里使用科雷的静态布局作为暴食地形
    "Quagmire_KitchenTask"
}

AddTaskPreInit("Quagmire_KitchenTask", function(task)
    task.room_choices = {
        TE_QuagmireKitchenRoom = 1,
    }
    task.background_room = "TE_QuagmireKitchenRoom"
    task.room_bg = WORLD_TILES.IMPASSABLE
end)


for _, t in ipairs(tasks) do
    AddTaskPreInit(t, function(task)
        task.region_id = "quagmire" --所有地形为一个岛

        task.room_tags = task.room_tags or {}
        table.insert(task.room_tags, "tropical")     --我们mod地形
        table.insert(task.room_tags, "quagmire")     --模块专属标签
        table.insert(task.room_tags, "RoadPoison")   --禁止生成卵石路
        table.insert(task.room_tags, "not_mainland") --单独的小岛
        table.insert(task.room_tags, "No_Winter")    --没有冬天
        table.insert(task.room_tags, "nohasslers")   --不生成熊大
        table.insert(task.room_tags, "nohunt")       --无猎犬
    end)
end

AddLevelPreInitAny(function(level)
    if level.location == "forest" then
        for _, task in ipairs(tasks) do
            table.insert(level.tasks, task)
        end
    end
end)

-- 在大陆沼泽地形找个地方生成一个通向暴食地形的传送门
AddTaskSetPreInitAny(function(taskset)
    if taskset.location ~= "forest" or not table.contains(taskset.tasks, "Squeltch") then
        return
    end

    taskset.set_pieces = taskset.set_pieces or {}
    taskset.set_pieces["TE_QuagmirePortal"] = {
        count = 1,
        tasks = { "Squeltch", },
    }
end)
