AddTask("GREENSWAMP_TASK_FOREST", {
    locks = { LOCKS.TIER3, LOCKS.ADVANCED_COMBAT },
    keys_given = { KEYS.TIER4 },
    room_choices =
    {
        ["SnakesGreenSwamp"] = math.random(1),
        ["SpidersGreenSwamp"] = math.random(1),
        ["ForestGreenSwamp"] = math.random(1),
        ["WillageGreenSwamp"] = math.random(1),
        ["WatcherGreenSwamp"] = 1,
    },
    entrance_room = "EntranceGreenSwamp",
    room_bg = WORLD_TILES.MARSH_SW,
    background_room = "BGGreenSwamp",
    colour = { r = 1, g = 0, b = 0.6, a = 1 },
})

AddTask("GREENSWAMP_TASK_FOREST_ISLAND", {
    locks = { LOCKS.TIER3, LOCKS.ADVANCED_COMBAT },
    keys_given = { KEYS.TIER4 },
    region_id = "greenworld",
    room_choices =
    {
        ["SnakesGreenSwamp"] = math.random(1),
        ["SpidersGreenSwamp"] = math.random(1),
        ["ForestGreenSwamp"] = math.random(1),
        ["WillageGreenSwamp"] = math.random(1),
        ["WatcherGreenSwamp"] = 1,
        ["EntranceGreenSwamp"] = 1,
    },
    room_bg = WORLD_TILES.MARSH_SW,
    background_room = "BGGreenSwamp",
    colour = { r = 1, g = 0, b = 0.6, a = 1 },
})
