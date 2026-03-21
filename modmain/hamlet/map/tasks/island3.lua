AddTask("连接岛二和岛三中间的海", {
    locks = LOCKS.ISLAND_3,
    keys_given = KEYS.LAND_DIVIDE_2,
    room_choices = {
        ["ForceDisconnectedRoom"] = 5, --20,
    },
    room_bg = WORLD_TILES.OCEAN_SWELL,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("岛三雨林深处", {
    locks = LOCKS.LAND_DIVIDE_2,
    keys_given = { KEYS.LOST_JUNGLE_DEPTH_2 },
    --		entrance_room = "ForceDisconnectedRoom", --  THIS IS HOW THEY ARE ON SEPARATE ISLANDS
    room_choices = {
        ["BG_deeprainforest_base"] = math.random(2, 4),
        ["deeprainforest_flytrap_grove"] = math.random(2, 3),
    },
    room_bg = WORLD_TILES.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("岛三雨林", {
    locks = LOCKS.LOST_JUNGLE_DEPTH_2,
    keys_given = { KEYS.ISLAND_4 },
    room_choices = {
        ["BG_plains_base"] = math.random(1, 4),
        ["rainforest_lillypond"] = math.random(1, 2),
    },
    room_bg = WORLD_TILES.RAINFOREST,
    background_room = "BG_rainforest_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})
