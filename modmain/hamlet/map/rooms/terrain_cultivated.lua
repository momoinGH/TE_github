-- 茶树
AddRoom("piko_land", {
    colour = { r = 1.0, g = 0.0, b = 1.0, a = 0.3 },
    value = WORLD_TILES.FIELDS,
    tags = { "ExitPiece", "Cultivated" },
    contents = {
        distributepercent = 0.06, --0.1
        distributeprefabs =
        {
            rock1 = 0.01,
            teatree = 2.0,
        },
        countprefabs =
        {
            teatree_piko_nest = math.random(4, 8)
        },
    }
})

local cultivated_contnets = {
    distributepercent = 0.06, ---0.1
    distributeprefabs =
    {
        -- 			grass = 0.05,
        --			flower = 0.3,
        rock1 = 0.01,
        teatree = 0.1,
        --			peekhenspawner = 0.003,
    },
}

AddRoom("cultivated_base_1", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = WORLD_TILES.FIELDS,
    tags = { "ExitPiece", "Cultivated", "City1" },
    contents = cultivated_contnets
})
AddRoom("cultivated_base_2", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = WORLD_TILES.FIELDS,
    tags = { "ExitPiece", "Cultivated", "City2" },
    contents = cultivated_contnets
})
