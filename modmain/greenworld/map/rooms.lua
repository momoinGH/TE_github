AddRoom("BGGreenSwamp", {
    colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
    value = WORLD_TILES.MARSH_SW,
    contents =
    {
        distributepercent = 0.25,
        distributeprefabs =
        {
            marshberry = 0.08,
            reeds = 0.3,
            marsh_bush = 0.3,
            evergreen = 0.5,
            marsh_tree = 0.5,
            greententacle = 0.2
        },
    }
})

AddRoom("SnakesGreenSwamp", {
    colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
    value = WORLD_TILES.MARSH_SW,
    contents =
    {
        -- countprefabs =
        -- {
        --     shelves_bonestaff = 1,
        -- },
        distributepercent = 0.3,
        distributeprefabs =
        {
            evergreen = 1.2,
            reeds = 0.07,
            greententacle = 0.04,
            snake_hole = 0.01,
        },
    }
})

AddRoom("SpidersGreenSwamp", {
    colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
    value = WORLD_TILES.MARSH_SW,
    contents =
    {
        countprefabs =
        {

        },
        distributepercent = 0.3,
        distributeprefabs =
        {
            evergreen = 1.2,
            reeds = 0.07,
            greententacle = 0.06,
            snake_hole = 0.01,
            spiderden = 0.09,
            rock1 = 0.02
        },
        prefabdata =
        {
            spiderden = function()
                if math.random() < 0.2 then
                    return { growable = { stage = 2 } }
                else
                    return { growable = { stage = 1 } }
                end
            end,
        },
    }
})

AddRoom("ForestGreenSwamp", {
    colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
    value = WORLD_TILES.MARSH_SW,
    contents =
    {
        countprefabs =
        {

        },
        distributepercent = 0.7,
        distributeprefabs =
        {
            evergreen = 1.2,
            sapling = 0.05,
            snake_hole = 0.01,
            green_mushroom = 0.05,
            blue_mushroom = 0.05,
            red_mushroom = 0.05,
        },
        prefabdata =
        {

        },
    }
})

AddRoom("WatcherGreenSwamp", {
    colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
    value = WORLD_TILES.MARSH_SW,
    tags = { "StagehandGarden", "RoadPoison" },
    contents =
    {
        distributepercent = 0.1,
        distributeprefabs =
        {
            reeds = 0.1,
            greententacle = 0.02,
            goldnugget = 0.01
        },
        countstaticlayouts = {
            gwestatua = 1
        }
    }
})

AddRoom("WillageGreenSwamp", {
    colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
    value = WORLD_TILES.MARSH_SW,
    contents =
    {
        countprefabs =
        {
            pond = 1,
        },
        distributepercent = 0.3,
        distributeprefabs =
        {
            evergreen = 0.7,
            sapling = 0.3,
            grass = 0.3,
            lizardman_cave = 0.15,
            rock1 = 0.1,
        },
    }
})

AddRoom("EntranceGreenSwamp", {
    colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
    value = WORLD_TILES.MARSH_SW,
    contents =
    {
        distributepercent = 0.5,
        distributeprefabs =
        {
            evergreen = 2,
            rock1 = 0.04,
            sapling = 0.05,
            spiderden = 0.3,
            grass = 0.05,
        },
        prefabdata =
        {
            spiderden = function()
                if math.random() < 0.2 then
                    return { growable = { stage = 2 } }
                else
                    return { growable = { stage = 1 } }
                end
            end,
        },
    }
})
