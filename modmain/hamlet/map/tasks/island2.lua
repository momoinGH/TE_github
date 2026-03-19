local island_hamlet = "island_hamlet"

AddTask("岛一和岛二之间的海洋", {
    locks = LOCKS.ISLAND_2,
    keys_given = KEYS.LAND_DIVIDE_1,
    region_id = island_hamlet,
    room_choices = {
        ["ForceDisconnectedRoom"] = 5, --20,
    },
    room_bg = WORLD_TILES.OCEAN_SWELL,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("岛二雨林深处", {
    locks = LOCKS.LAND_DIVIDE_1,
    keys_given = { KEYS.OTHER_JUNGLE_DEPTH_2 },
    region_id = island_hamlet,
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
    room_bg = WORLD_TILES.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("岛二曼德拉丘", {
    locks = LOCKS.OTHER_JUNGLE_DEPTH_2,
    keys_given = { KEYS.OTHER_JUNGLE_DEPTH_1 },
    region_id = island_hamlet,
    room_choices = {
        ["deeprainforest_mandrakeman"] = 1,
    },
    set_pieces = {
        { name = "mandraketown" },
    },
    room_bg = WORLD_TILES.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("岛二农场", {
    locks = LOCKS.OTHER_JUNGLE_DEPTH_1,
    keys_given = KEYS.OTHER_CIVILIZATION_1,
    region_id = island_hamlet,
    room_choices = {
        ["cultivated_base_2"] = math.random(1, 3),
    },
    room_bg = WORLD_TILES.FIELDS,
    background_room = "cultivated_base_2",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("岛二郊区", {
    locks = LOCKS.OTHER_CIVILIZATION_1,
    keys_given = KEYS.OTHER_CIVILIZATION_2,
    region_id = island_hamlet,
    room_choices = {
        ["suburb_base_2"] = math.random(2, 3),
    },
    room_bg = WORLD_TILES.SUBURB,
    background_room = "suburb_base_2",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("岛二猪镇", {
    locks = LOCKS.OTHER_CIVILIZATION_2,
    keys_given = KEYS.ISLAND_3,
    region_id = island_hamlet,
    room_choices = {
        ["city_base_2"] = math.random(2, 3),
    },
    room_bg = WORLD_TILES.SUBURB,
    background_room = "suburb_base_2",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})
