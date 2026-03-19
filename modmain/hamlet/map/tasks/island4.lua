local island_hamlet = "island_hamlet"

AddTask("连接岛三和岛四中间的海", {
    locks = LOCKS.ISLAND_4,
    keys_given = KEYS.LAND_DIVIDE_3,
    region_id = island_hamlet,
    room_choices = {
        ["ForceDisconnectedRoom"] = 20,
    },
    room_bg = WORLD_TILES.OCEAN_SWELL,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("岛四", {
    locks = LOCKS.LAND_DIVIDE_3,
    keys_given = KEYS.PINACLE,
    region_id = island_hamlet,
    room_choices = {
        ["BG_pinacle_base"] = 1,
    },
    set_pieces = {
        { name = "roc_nest" },
        { name = "roc_cave" },
    },
    room_bg = WORLD_TILES.ROCKY,
    background_room = "BG_pinacle_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})
