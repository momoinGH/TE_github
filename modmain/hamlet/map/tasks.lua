-- 初始探索区域
AddTask("Edge_of_the_unknown", {
    locks = LOCKS.NONE,
    keys_given = KEYS.JUNGLE_DEPTH_1,
    room_choices = {
        ["BG_plains_base"] = 2,
    },
    room_bg = WORLD_TILES.PLAINS,
    background_room = "BG_plains_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})
-- 进阶探索区域，有雨林、遗迹、机器人零件
AddTask("Edge_of_the_unknown_2", {
    locks = LOCKS.CIVILIZATION_1,
    keys_given = KEYS.JUNGLE_DEPTH_1,
    room_choices = {
        ["plains_tallgrass"] = math.random(1, 2),   --高草
        ["plains_pogs"] = math.random(0, 2),        --小狐狸
        ["rainforest_ruins"] = math.random(2, 3),   --雨林遗迹
        ["BG_painted_base"] = math.random(1, 2),    --淘金兽
        ["BG_rainforest_base"] = math.random(1, 3), --雨林基础

        ["battleground_head"] = 1,                  --铁巨人头
        ["battleground_claw"] = 1,                  --铁巨人爪
        ["battleground_leg"] = 1,                   --铁巨人腿
    },
    room_bg = WORLD_TILES.PLAINS,
    background_room = "BG_plains_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})
-- 睡莲池塘
AddTask("Lilypond_land", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = KEYS.JUNGLE_DEPTH_2,
    room_choices = {
        ["rainforest_lillypond"] = math.random(3, 5),
    },
    room_bg = GROUND.RAINFOREST,
    background_room = "BG_rainforest_base",
    colour = { r = 1, g = 0.3, b = 0.3, a = 0.3 }
})
AddTask("Lilypond_land_2", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = KEYS.JUNGLE_DEPTH_2,
    room_choices = {
        ["rainforest_lillypond"] = math.random(2, 3),
    },
    room_bg = GROUND.RAINFOREST,
    background_room = "BG_rainforest_base",
    colour = { r = 1, g = 0.3, b = 0.3, a = 0.3 }
})
-- 城镇边缘
AddTask("Edge_of_civilization", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = KEYS.CIVILIZATION_1,
    room_choices = {
        ["cultivated_base_1"] = math.random(3, 5),
        ["piko_land"] = math.random(2, 3), --茶树
    },
    room_bg = WORLD_TILES.FIELDS,
    background_room = "cultivated_base_1",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})
-- 郊区
AddTask("Pigtopia", {
    locks = LOCKS.CIVILIZATION_1,
    keys_given = KEYS.CIVILIZATION_2,
    room_choices = {
        ["suburb_base_1"] = 1,
    },
    room_bg = WORLD_TILES.SUBURB,
    background_room = "suburb_base_1",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})
-- 郊区2
AddTask("Pigtopia_capital", {
    locks = LOCKS.CIVILIZATION_2,
    keys_given = KEYS.ISLAND_2,
    room_choices = {
        ["city_base_1"] = math.random(2, 3),
    },
    room_bg = WORLD_TILES.SUBURB,
    background_room = "suburb_base_1",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

-- 雨林深处、捕蝇草、萤火虫、荨麻、蚁巢
AddTask("Deep_rainforest", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = { KEYS.JUNGLE_DEPTH_2, KEYS.JUNGLE_DEPTH_3 },
    room_choices = {
        ["BG_rainforest_base"] = math.random(2, 3),
        ["BG_deeprainforest_base"] = 1,
        ["deeprainforest_spider_monkey_nest"] = math.random(1, 2),
        ["deeprainforest_fireflygrove"] = math.random(1, 1),
        ["deeprainforest_flytrap_grove"] = math.random(1, 2),
        ["deeprainforest_anthill_exit"] = 1,
    },
    set_pieces = {
        { name = "pig_ruins_head" },
        { name = "pig_ruins_head" },
        { name = "pig_ruins_artichoke" },
        { name = "pig_ruins_artichoke" },
    },
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("Deep_rainforest_2", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = { KEYS.JUNGLE_DEPTH_2, KEYS.JUNGLE_DEPTH_3 },
    room_choices = {
        ["BG_deeprainforest_base"] = math.random(1, 2),
        ["deeprainforest_spider_monkey_nest"] = math.random(1, 2),
        ["deeprainforest_fireflygrove"] = math.random(0, 2),
        ["deeprainforest_flytrap_grove"] = math.random(1, 3),
        ["deeprainforest_anthill_exit"] = 1,
    },
    set_pieces = {
        { name = "pig_ruins_entrance_2" },
        { name = "pig_ruins_head" },
        { name = "pig_ruins_artichoke" },
        { name = "pig_ruins_artichoke" },
    },
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

-- 有毒气的深层雨林，有两个遗迹
AddTask("Deep_lost_ruins_gas", {
    locks = LOCKS.JUNGLE_DEPTH_3,
    keys_given = KEYS.JUNGLE_DEPTH_3,
    room_choices = {
        ["deeprainforest_gas"] = math.random(3, 4),
        ["deeprainforest_gas_flytrap_grove"] = math.random(2),
    },
    set_pieces = {
        { name = "pig_ruins_entrance_3" },
        { name = "pig_ruins_head" },
        { name = "pig_ruins_artichoke" },
        { name = "pig_ruins_entrance_4" },
    },
    room_bg = GROUND.GASJUNGLE,
    background_room = "deeprainforest_gas",
    colour = { r = 0.8, g = 0.6, b = 0.2, a = 0.3 }
})


AddTask("Lost_Ruins_1", {
    locks = LOCKS.JUNGLE_DEPTH_3,
    keys_given = KEYS.NONE,
    room_choices = {
        ["deeprainforest_ruins_entrance"] = 1,
    },
    set_pieces = {
        { name = "pig_ruins_entrance_1" }
    },
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("Deep_rainforest_3", {
    locks = LOCKS.LAND_DIVIDE_1,
    keys_given = { KEYS.OTHER_JUNGLE_DEPTH_2 },
    --	entrance_room = "ForceDisconnectedRoom",   --  THIS IS HOW THEY ARE ON SEPARATE ISLANDS
    room_choices = {
        ["BG_deeprainforest_base"] = math.random(2, 4),
        ["deeprainforest_fireflygrove"] = math.random(0, 1),
        ["deeprainforest_flytrap_grove"] = math.random(1, 2),
        --	["deeprainforest_ruins_exit"] = 1,
    },
    set_pieces = {
        { name = "pig_ruins_exit_1" },
        { name = "pig_ruins_head" },
        { name = "pig_ruins_artichoke" },
        { name = "pig_ruins_artichoke" },
    },
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

-- 曼德拉丘
AddTask("Deep_rainforest_mandrake", {
    locks = LOCKS.OTHER_JUNGLE_DEPTH_2,
    keys_given = { KEYS.NONE },
    room_choices = {
        ["deeprainforest_mandrakeman"] = 1,
    },
    set_pieces = {
        { name = "mandraketown" },
    },
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})


AddTask("Path_to_the_others", {
    locks = LOCKS.OTHER_JUNGLE_DEPTH_2,
    keys_given = KEYS.OTHER_JUNGLE_DEPTH_1,
    room_choices = {
        ["BG_plains_base"] = math.random(1, 2),
        ["plains_tallgrass"] = math.random(1, 2),
        ["plains_pogs"] = math.random(1, 2),
    },
    room_bg = GROUND.RAINFOREST,
    background_room = "BG_rainforest_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})


AddTask("Other_pigtopia_capital", {
    locks = LOCKS.OTHER_CIVILIZATION_2,
    keys_given = KEYS.ISLAND_3,
    room_choices = {
        ["city_base_2"] = math.random(2, 3),
    },
    room_bg = GROUND.SUBURB,
    background_room = "suburb_base_2",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})


AddTask("Other_pigtopia", {
    locks = LOCKS.OTHER_CIVILIZATION_1,
    keys_given = KEYS.OTHER_CIVILIZATION_2,
    room_choices = {
        ["suburb_base_2"] = math.random(2, 3),
    },
    room_bg = GROUND.SUBURB,
    background_room = "suburb_base_2",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})


AddTask("Other_edge_of_civilization", {
    locks = LOCKS.OTHER_JUNGLE_DEPTH_1,
    keys_given = KEYS.OTHER_CIVILIZATION_1,
    room_choices = {
        ["cultivated_base_2"] = math.random(1, 3),
    },
    room_bg = GROUND.FIELDS,
    background_room = "cultivated_base_2",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("this_is_how_you_get_ants", {
    locks = LOCKS.JUNGLE_DEPTH_2,
    keys_given = { KEYS.JUNGLE_DEPTH_2, KEYS.JUNGLE_DEPTH_3 },
    room_choices = {
        ["deeprainforest_anthill"] = 1,
    },
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    colour = { r = 0, g = 0, b = 1, a = 0.3 }
})

-- Other Jungle
AddTask("Deep_lost_ruins4", {
    locks = LOCKS.LAND_DIVIDE_2,
    keys_given = { KEYS.LOST_JUNGLE_DEPTH_2 },
    --		entrance_room = "ForceDisconnectedRoom", --  THIS IS HOW THEY ARE ON SEPARATE ISLANDS
    room_choices = {
        ["BG_deeprainforest_base"] = math.random(2, 4),
        ["deeprainforest_flytrap_grove"] = math.random(2, 3),
    },
    set_pieces = {
        { name = "pig_ruins_exit_2" },
        { name = "pig_ruins_head" },
        { name = "pig_ruins_artichoke" },
        { name = "pig_ruins_artichoke" },
        { name = "nettlegrove" },
        { name = "nettlegrove" },
    },
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("lost_rainforest", {
    locks = LOCKS.LOST_JUNGLE_DEPTH_2,
    keys_given = { KEYS.ISLAND_4 },
    room_choices = {
        ["BG_plains_base"] = math.random(1, 4),
        ["rainforest_lillypond"] = math.random(2, 4),
    },
    set_pieces = {
        { name = "pugalisk_fountain" },
        { name = "pig_ruins_nocanopy" },
        { name = "pig_ruins_nocanopy_2" },
        { name = "pig_ruins_nocanopy_2" },
        { name = "pig_ruins_nocanopy_3" },
        { name = "pig_ruins_nocanopy_3" },
        { name = "pig_ruins_nocanopy_4" },
        { name = "pig_ruins_nocanopy_4" },
    },
    room_bg = GROUND.RAINFOREST,
    background_room = "BG_rainforest_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("painted_sands", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = KEYS.JUNGLE_DEPTH_1,
    room_choices = {
        ["BG_painted_base"] = math.random(2, 3),
        ["BG_battleground_base"] = math.random(0, 1),
        ["battleground_ribs"] = 1,
        ["battleground_claw"] = 1,
        ["battleground_leg"] = 1,
    },
    room_bg = GROUND.PLAINS,
    background_room = "BG_painted_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("plains", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = KEYS.JUNGLE_DEPTH_1,
    room_choices = {
        ["plains_tallgrass"] = math.random(2, 3),
        ["plains_pogs"] = 1,
    },
    room_bg = GROUND.PLAINS,
    background_room = "BG_plains_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("rainforests", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = KEYS.JUNGLE_DEPTH_1,
    room_choices = {
        ["BG_rainforest_base"] = math.random(2, 3),
    },
    room_bg = GROUND.PLAINS,
    background_room = "BG_rainforest_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 },
})

AddTask("rainforest_ruins", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = KEYS.JUNGLE_DEPTH_1,
    room_choices = {
        ["rainforest_ruins"] = math.random(2, 3),
    },
    room_bg = GROUND.PLAINS,
    background_room = "BG_rainforest_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("plains_ruins", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = KEYS.JUNGLE_DEPTH_1,
    room_choices = {
        ["plains_ruins"] = math.random(2, 3),
        ["plains_pogs"] = math.random(0, 1),
    },
    room_bg = GROUND.PLAINS,
    background_room = "BG_plains_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

-- BFB nest area
AddTask("pincale", {
    locks = LOCKS.LAND_DIVIDE_3,
    keys_given = KEYS.PINACLE,
    room_choices = {
        ["BG_pinacle_base"] = 1,
    },
    set_pieces = {
        { name = "roc_nest" },
        { name = "roc_cave" },
    },
    room_bg = GROUND.ROCKY,
    background_room = "BG_pinacle_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

-- Other Jungle
AddTask("Deep_wild_ruins4", {
    locks = LOCKS.LAND_DIVIDE_4,
    keys_given = { KEYS.WILD_JUNGLE_DEPTH_1 },
    --		entrance_room = "ForceDisconnectedRoom", --  THIS IS HOW THEY ARE ON SEPARATE ISLANDS
    room_choices = {
        ["deeprainforest_base_nobatcave"] = math.random(2, 4),
        ["deeprainforest_flytrap_grove"] = math.random(2, 3),
    },
    set_pieces = {
        { name = "pig_ruins_exit_4" },
    },
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "deeprainforest_base_nobatcave",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("wild_rainforest", {
    locks = LOCKS.WILD_JUNGLE_DEPTH_1,
    keys_given = { KEYS.WILD_JUNGLE_DEPTH_2 },
    room_choices = {
        ["plains_base_nobatcave"] = math.random(3, 4),
        ["rainforest_lillypond"] = math.random(3, 4),
        ["painted_base_nobatcave"] = math.random(3, 4),
        ["rainforest_base_nobatcave"] = math.random(3, 4),
    },
    room_bg = GROUND.RAINFOREST,
    background_room = "rainforest_base_nobatcave",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("wild_ancient_ruins", {
    locks = LOCKS.WILD_JUNGLE_DEPTH_2,
    keys_given = { KEYS.ISLAND_5 },
    room_choices = {
        ["deeprainforest_flytrap_grove"] = math.random(4, 5),
    },
    set_pieces = {
        { name = "pig_ruins_entrance_5" },
    },
    room_bg = GROUND.RAINFOREST,
    background_room = "rainforest_base_nobatcave",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})
