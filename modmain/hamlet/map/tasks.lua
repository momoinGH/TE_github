-- 给这些task添加新的钥匙，解锁该task就能凭借钥匙解锁其他的task了
AddTaskPreInit("GreenForest", function(task)
    task.keys_given = task.keys_given or {}
    table.insert(task.keys_given, KEYS.HAM_CAVE)
end)

AddTask("MPigcity", {
    locks = { LOCKS.JUNGLE_DEPTH_1 },
    keys_given = { KEYS.JUNGLE_DEPTH_3 },
    region_id = "island3",
    room_tags = { "RoadPoison", "hamlet" },
    room_choices = {
        ["city_base_1_set"] = 1,
        ["city_base"] = 1,
    },
    room_bg = WORLD_TILES.SUBURB,
    entrance_room = "city_base",
    background_room = "BG_suburb_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("MPigcityside1", {
    locks = { LOCKS.JUNGLE_DEPTH_3 },
    keys_given = { KEYS.NONE },
    region_id = "island3",
    room_tags = { "RoadPoison", "hamlet" },
    room_choices = {
        ["city_base"] = 1,
    },
    entrance_room = "city_base",
    room_bg = WORLD_TILES.SUBURB,
    background_room = "BG_suburb_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("MPigcityside2", {
    locks = { LOCKS.JUNGLE_DEPTH_2 },
    keys_given = { KEYS.JUNGLE_DEPTH_1 },
    region_id = "island3",
    room_tags = { "RoadPoison", "hamlet" },
    room_choices = {
        ["city_base"] = 1,

    },
    entrance_room = "city_base",
    room_bg = WORLD_TILES.SUBURB,
    background_room = "BG_suburb_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("MPigcityside3", {
    locks = { LOCKS.JUNGLE_DEPTH_3 },
    keys_given = { KEYS.NONE },
    region_id = "island3",
    room_tags = { "RoadPoison", "hamlet" },
    room_choices = {
        ["city_base"] = 1,

    },
    entrance_room = "city_base",
    room_bg = WORLD_TILES.SUBURB,
    background_room = "BG_suburb_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("MPigcityside4", {
    locks = { LOCKS.JUNGLE_DEPTH_3 },
    keys_given = { KEYS.NONE },
    region_id = "island3",
    room_tags = { "RoadPoison", "hamlet" },
    room_choices = {
        ["city_base"] = 1,

    },
    entrance_room = "city_base",
    room_bg = WORLD_TILES.SUBURB,
    background_room = "BG_suburb_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})


AddTask("MDeep_rainforest_3", {
    locks = {},
    keys_given = { KEYS.CIVILIZATION_2 },
    region_id = "island3",
    room_choices = {
        ["BG_deeprainforest_base"] = 2,
        ["deeprainforest_fireflygrove"] = 1,
        ["deeprainforest_flytrap_grove"] = 1,
        ["deeprainforest_ruins_exit"] = 1,
    },
    room_bg = WORLD_TILES.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("MPigcity2", {
    locks = { LOCKS.CIVILIZATION_1 },
    keys_given = { KEYS.CIVILIZATION_3 },
    region_id = "island3",
    room_tags = { "RoadPoison", "hamlet" },
    room_choices = {
        ["city_base_2_set"] = 1,
    },
    room_bg = WORLD_TILES.SUBURB,
    background_room = "BG_suburb_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("MPigcity2side1", {
    locks = { LOCKS.CIVILIZATION_3 },
    keys_given = { KEYS.CIVILIZATION_2 },
    region_id = "island3",
    room_tags = { "RoadPoison", "hamlet" },
    room_choices = {
        ["city_base"] = 1,
    },
    room_bg = WORLD_TILES.SUBURB,
    background_room = "BG_suburb_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("MPigcity2side2", {
    locks = { LOCKS.CIVILIZATION_2 },
    keys_given = { KEYS.CIVILIZATION_1 },
    region_id = "island3",
    room_tags = { "RoadPoison", "hamlet" },
    room_choices = {
        ["city_base"] = 1,

    },
    room_bg = WORLD_TILES.SUBURB,
    background_room = "BG_suburb_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("MPigcity2side3", {
    locks = { LOCKS.CIVILIZATION_3 },
    keys_given = { KEYS.NONE },
    region_id = "island3",
    room_tags = { "RoadPoison", "hamlet" },
    room_choices = {
        ["city_base"] = 1,
    },
    room_bg = WORLD_TILES.SUBURB,
    background_room = "BG_suburb_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("MPigcity2side4", {
    locks = { LOCKS.CIVILIZATION_3 },
    keys_given = { KEYS.NONE },
    region_id = "island3",
    room_tags = { "RoadPoison", "hamlet" },
    room_choices = {
        ["city_base"] = 1,

    },
    room_bg = WORLD_TILES.SUBURB,
    background_room = "BG_suburb_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("Mrainforest_ruins", {
    locks = { LOCKS.CIVILIZATION_3 },
    keys_given = { KEYS.NONE },
    region_id = "island3",
    room_choices = {
        ["rainforest_ruins"] = 3,
        ["rainforest_ruins_entrance"] = 1,
    },
    room_bg = WORLD_TILES.RAINFOREST,
    background_room = "BG_rainforest_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("MDeep_lost_ruins_gas", {
    locks = LOCKS.JUNGLE_DEPTH_3,
    keys_given = KEYS.JUNGLE_DEPTH_3,
    region_id = "island3",
    room_choices = {
        ["deeprainforest_gas"] = math.random(3, 4),
        ["deeprainforest_gas_flytrap_grove"] = math.random(2),
    },
    room_bg = WORLD_TILES.GASRAINFOREST,
    background_room = "deeprainforest_gas",
    colour = { r = 0.8, g = 0.6, b = 0.2, a = 0.3 }
})
AddTask("MEdge_of_civilization", {
    locks = { LOCKS.JUNGLE_DEPTH_2 },
    keys_given = { KEYS.JUNGLE_DEPTH_2 },
    region_id = "island3",
    room_choices = {
        ["cultivated_base_1"] = 1,
        ["cultivated_base_2"] = 1,
        --			["cultivated_base_3"] = 1,
        ["cultivated_base_4"] = 1,
        ["cultivated_base_5"] = 1,
        ["piko_land"] = 1,
    },
    room_bg = WORLD_TILES.FIELDS,
    background_room = "BG_cultivated_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})
AddTask("plains", {
    locks = {},
    keys_given = {},
    region_id = "hamlet2",
    room_choices = {
        ["plains_tallgrass"] = math.random(2, 3),
        ["plains_pogs_ruin"] = 1,
    },
    room_bg = WORLD_TILES.PLAINS,
    background_room = "BG_plains_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})
AddTask("plains_ruins", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = KEYS.JUNGLE_DEPTH_1,
    room_choices = {
        ["plains_ruins"] = math.random(2, 3),
        ["plains_pogs"] = math.random(0, 1),
    },
    room_bg = WORLD_TILES.PLAINS,
    background_room = "BG_plains_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
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
    room_bg = WORLD_TILES.PLAINS,
    background_room = "BG_painted_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})
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
        { name = "PigRuinsHead" },
        { name = "PigRuinsHead" },
        { name = "PigRuinsArtichoke" },
        { name = "PigRuinsArtichoke" },
    },
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})
