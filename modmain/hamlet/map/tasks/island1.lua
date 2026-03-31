AddTask("岛一平原基础", {
    locks = LOCKS.NONE,
    keys_given = KEYS.JUNGLE_DEPTH_1,
    room_choices = {
        ["BG_plains_base"] = 2,
    },
    room_bg = WORLD_TILES.PLAINS,
    background_room = "BG_plains_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("岛一平原", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = KEYS.JUNGLE_DEPTH_1,
    room_choices = {
        ["plains_tallgrass"] = math.random(2, 3),
        ["plains_pogs"] = 1,
    },
    room_bg = WORLD_TILES.PLAINS,
    background_room = "BG_plains_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("岛一睡莲", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = KEYS.JUNGLE_DEPTH_2,
    room_choices = {
        ["rainforest_lillypond"] = math.random(2, 3),
    },
    level_set_piece_blocker = true,
    room_bg = WORLD_TILES.RAINFOREST,
    background_room = "BG_rainforest_base",
    colour = { r = 1, g = 0.3, b = 0.3, a = 0.3 }
})

AddTask("岛一猪镇农场", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = { KEYS.CIVILIZATION_1, KEYS.CIVILIZATION_2 },
    room_choices = {
        ["cultivated_base_1"] = math.random(2, 3),
        ["piko_land"] = math.random(2, 3), --茶树
    },
    room_bg = WORLD_TILES.FIELDS,
    background_room = "cultivated_base_1",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

-- AddTask("岛一猪镇郊区", {
--     locks = LOCKS.CIVILIZATION_1,
--     keys_given = KEYS.CIVILIZATION_2,
--     room_choices = {
--         ["suburb_base_1"] = 1,
--     },
--     room_bg = WORLD_TILES.SUBURB,
--     background_room = "suburb_base_1",
--     colour = { r = 1, g = 1, b = 1, a = 0.3 }
-- })

AddTask("岛一猪镇", {
    locks = LOCKS.CIVILIZATION_2,
    keys_given = KEYS.ISLAND_2,
    room_choices = {
        ["city_base_1"] = math.random(5, 7),
    },
    level_set_piece_blocker = true,
    room_bg = WORLD_TILES.SUBURB,
    background_room = "suburb_base_1",
    crosslink_factor = 10,
    -- cove_room_name = "suburb_base_1",
    make_loop = true,
    -- cove_room_chance = 1,
    -- cove_room_max_edges = 10,
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("岛一战场", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = KEYS.JUNGLE_DEPTH_1,
    room_choices = {
        ["BG_painted_base"] = 1,
        ["BG_battleground_base"] = math.random(0, 1),
        ["battleground_head"] = 1, --头
        ["battleground_ribs"] = 1, --躯干
        ["battleground_claw"] = 1, --爪子
        ["battleground_leg"] = 1,  --脚
    },
    room_bg = WORLD_TILES.PLAINS,
    background_room = "BG_painted_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("岛一雨林遗迹", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = KEYS.JUNGLE_DEPTH_2,
    room_choices = {
        ["rainforest_ruins"] = 2,
    },
    room_bg = WORLD_TILES.PLAINS,
    background_room = "BG_rainforest_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("岛一雨林深处", {
    locks = LOCKS.JUNGLE_DEPTH_2,
    keys_given = { KEYS.JUNGLE_DEPTH_2, KEYS.JUNGLE_DEPTH_3 },
    room_choices = {
        ["BG_deeprainforest_base"] = math.random(1, 2),
        ["deeprainforest_spider_monkey_nest"] = math.random(1, 2),
        ["deeprainforest_fireflygrove"] = math.random(0, 2),
        ["deeprainforest_flytrap_grove"] = math.random(1, 2),
        ["deeprainforest_anthill_exit"] = 1,
    },
    room_bg = WORLD_TILES.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("岛一蚁丘", {
    locks = LOCKS.JUNGLE_DEPTH_2,
    keys_given = { KEYS.JUNGLE_DEPTH_2, KEYS.JUNGLE_DEPTH_3 },
    room_choices = {
        ["deeprainforest_anthill"] = 1,
    },
    room_bg = WORLD_TILES.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    colour = { r = 0, g = 0, b = 1, a = 0.3 }
})
