AddTask("GREENSWAMP_TASK_FOREST", {
    locks = { LOCKS.TIER3, LOCKS.ADVANCED_COMBAT },
    keys_given = { KEYS.TIER4 },
    room_choices =
    {
        ["SnakesGreenSwamp"] = 1,
        ["SpidersGreenSwamp"] = 1,
        ["ForestGreenSwamp"] = 1,
        ["WillageGreenSwamp"] = 1,
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
        ["SnakesGreenSwamp"] = 1,
        ["SpidersGreenSwamp"] = 1,
        ["ForestGreenSwamp"] = 1,
        ["WillageGreenSwamp"] = 1,
        ["WatcherGreenSwamp"] = 1,
        ["EntranceGreenSwamp"] = 1,
    },
    room_bg = WORLD_TILES.MARSH_SW,
    background_room = "BGGreenSwamp",
    colour = { r = 1, g = 0, b = 0.6, a = 1 },
})
