AddTask("连接岛四和岛五中间的海", {
    locks = LOCKS.PINACLE,
    keys_given = KEYS.LAND_DIVIDE_4,
    room_choices = {
        ["ForceDisconnectedRoom"] = 20,
    },
    room_bg = WORLD_TILES.OCEAN_SWELL,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("岛五雨林深处", {
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
    room_bg = WORLD_TILES.DEEPRAINFOREST,
    background_room = "deeprainforest_base_nobatcave",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("岛五雨林", {
    locks = LOCKS.WILD_JUNGLE_DEPTH_1,
    keys_given = { KEYS.WILD_JUNGLE_DEPTH_2 },
    room_choices = {
        ["plains_base_nobatcave"] = math.random(3, 4),
        ["rainforest_lillypond"] = math.random(3, 4),
        ["painted_base_nobatcave"] = math.random(3, 4),
        ["rainforest_base_nobatcave"] = math.random(3, 4),
    },
    room_bg = WORLD_TILES.RAINFOREST,
    background_room = "rainforest_base_nobatcave",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("岛五毁灭雨林", {
    locks = LOCKS.WILD_JUNGLE_DEPTH_2,
    keys_given = { KEYS.ISLAND_5 },
    room_choices = {
        ["deeprainforest_flytrap_grove"] = math.random(4, 5),
    },
    set_pieces = {
        { name = "pig_ruins_entrance_5" },
    },
    room_bg = WORLD_TILES.RAINFOREST,
    background_room = "rainforest_base_nobatcave",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})
