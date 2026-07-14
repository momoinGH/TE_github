modimport "modmain/hamlet/map/forest_map.lua"


-- 沿海地形
AddRoomPreInit("OceanCoastal", function(room)
    room.contents.countstaticlayouts["lilypadnovo"] = 2 --莲花池
end)

-- 给这些task添加新的钥匙，解锁该task就能凭借钥匙解锁其他的task了
-- AddTaskPreInit("GreenForest", function(task)
--     task.keys_given = task.keys_given or {}
--     table.insert(task.keys_given, KEYS.HAM_CAVE)
-- end)



----------------------------------------------------------------------------------------------------


-- local tasks = {
--     "Pigtopia",                   --郊区
--     "Pigtopia_capital",           --郊区2
--     "Edge_of_civilization",       --城镇边缘
--     "Edge_of_the_unknown",        --初始探索区域
--     "Edge_of_the_unknown_2",      --进阶探索区域，有雨林、遗迹、机器人零件
--     "Lilypond_land",              --睡莲池塘
--     "Lilypond_land_2",            --睡莲池塘
--     "Deep_rainforest",            --深层雨林
--     "Deep_rainforest_2",          --遗迹二
--     "Deep_lost_ruins_gas",        --有毒气的深层雨林，遗迹三、遗迹四
--     "Lost_Ruins_1",               --遗迹一
--     "Deep_rainforest_3",          --遗迹一出口
--     "Deep_rainforest_mandrake",   --有曼德拉丘的雨林
--     "Path_to_the_others",         --雨林到平原的过渡
--     "Other_pigtopia_capital",     --二岛郊区
--     "Other_pigtopia",             --二岛郊区
--     "Other_edge_of_civilization", --城镇边缘
--     "this_is_how_you_get_ants",   --蚁丘

--     "Deep_lost_ruins4",           --遗迹二出口
--     "lost_rainforest",

--     -- 这里用海洋填充
--     -- "Land_Divide_1",
--     -- "Land_Divide_2",
--     -- "Land_Divide_3",
--     -- "Land_Divide_4",

--     "painted_sands", --铁巨人各个零件
--     "plains",
--     "rainforests",
--     "rainforest_ruins",
--     "plains_ruins",
--     "pincale",

--     "Deep_wild_ruins4",
--     "wild_rainforest",
--     "wild_ancient_ruins",
-- }


local tasks = {
    "岛一平原基础",
    "岛一平原",
    "岛一睡莲",
    "岛一猪镇农场",
    "岛一猪镇",
    "岛一雨林深处",
    "岛一战场",
    "岛一雨林遗迹",
    "岛一蚁丘",

    "岛一和岛二之间的海洋", --通过海洋task让这些岛生成在一起
    "岛二雨林深处",
    "岛二曼德拉丘",
    "岛二农场",
    "岛二郊区",
    "岛二猪镇",

    "连接岛二和岛三中间的海",
    "岛三雨林深处",
    "岛三雨林",

    "连接岛三和岛四中间的海",
    "岛四",

    "连接岛四和岛五中间的海",
    "岛五雨林深处",
    "岛五雨林",
    "岛五毁灭雨林",
}


-- 给这些task的room统一添加hamlet地形标签
for _, t in ipairs(tasks) do
    AddTaskPreInit(t, function(task)
        task.region_id = "hamlet" --所有地形为一个岛

        task.room_tags = task.room_tags or {}
        table.insert(task.room_tags, "tropical")     --我们mod地形
        table.insert(task.room_tags, "hamlet")       --模块专属标签
        table.insert(task.room_tags, "RoadPoison")   --禁止生成卵石路
        table.insert(task.room_tags, "not_mainland") --单独的小岛
        table.insert(task.room_tags, "No_Winter")    --没有冬天
        table.insert(task.room_tags, "nohasslers")   --不生成熊大
    end)
end

AddLevelPreInitAny(function(level)
    if level.location == "forest" then
        for _, t in ipairs(tasks) do
            table.insert(level.tasks, t)
        end
    end
end)

-- 联机版task不支持set_pieces字段，这里用联机版的方式添加布局
AddTaskSetPreInitAny(function(task_set)
    if task_set.location == "forest" then
        task_set.set_pieces = task_set.set_pieces or {}

        task_set.set_pieces["pig_ruins_entrance_1"] = { count = 1, tasks = { "岛一雨林深处" } }
        task_set.set_pieces["pig_ruins_exit_1"] = { count = 1, tasks = { "岛二雨林深处" } }
        task_set.set_pieces["pig_ruins_entrance_2"] = { count = 1, tasks = { "岛二雨林深处" } }
        task_set.set_pieces["pig_ruins_exit_2"] = { count = 1, tasks = { "岛三雨林深处" } }
        task_set.set_pieces["pig_ruins_entrance_3"] = { count = 1, tasks = { "岛三雨林深处" } }
        task_set.set_pieces["pig_ruins_entrance_4"] = { count = 1, tasks = { "岛三雨林深处" } }
        task_set.set_pieces["pig_ruins_exit_4"] = { count = 1, tasks = { "岛五雨林深处" } }
        task_set.set_pieces["pig_ruins_entrance_5"] = { count = 1, tasks = { "岛五毁灭雨林" } }

        task_set.set_pieces["roc_nest"] = { count = 1, tasks = { "岛四" } }
        task_set.set_pieces["roc_cave"] = { count = 1, tasks = { "岛四" } }

        task_set.set_pieces["pig_ruins_head"] = { count = 1, tasks = { "岛一雨林深处", "岛二雨林深处", "岛三雨林深处" } }
        task_set.set_pieces["pig_ruins_artichoke"] = { count = 2, tasks = { "岛一雨林深处", "岛二雨林深处", "岛三雨林深处" } }
        task_set.set_pieces["mandraketown"] = { count = 1, tasks = { "岛二曼德拉丘" } }
        task_set.set_pieces["nettlegrove"] = { count = 2, tasks = { "岛三雨林深处" } }
        task_set.set_pieces["pugalisk_fountain"] = { count = 1, tasks = { "岛三雨林" } }
        task_set.set_pieces["pig_ruins_nocanopy"] = { count = 1, tasks = { "岛三雨林" } }
        task_set.set_pieces["pig_ruins_nocanopy_2"] = { count = 2, tasks = { "岛三雨林" } }
        task_set.set_pieces["pig_ruins_nocanopy_3"] = { count = 2, tasks = { "岛三雨林" } }
        task_set.set_pieces["pig_ruins_nocanopy_4"] = { count = 2, tasks = { "岛三雨林" } }
    end
end)
