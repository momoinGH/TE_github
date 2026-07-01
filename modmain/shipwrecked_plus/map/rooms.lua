AddRoom("pandajungle",
    {
        colour = { r = .6, g = .2, b = .8, a = .50 },
        value = WORLD_TILES.MEADOW,
        tags = { "RoadPoison", "shipwrecked" }, --"ForceDisconnected"
        contents =
        {
            distributepercent = 0.3,
            distributeprefabs = {
                sapling = 0.2,
                tree_forest_deep = 0.5,
                bambootree = 1,
                bambootreebig = 1,
                bush_vine = 0.05,
                cave_banana_tree = 0.05,
                snake_hole = 0.05,
                pandatree = 0.01,
            },

            countprefabs =
            {
                pandatree = function() return 10 + math.random(1, 2) end,
                pandahouse = function() return 2 + math.random(0, 1) end,
                red_mushroom = function() return math.random(1, 2) end,

            }
        }
    })
AddRoom("pandajungle1",
    {
        colour = { r = .6, g = .2, b = .8, a = .50 },
        value = WORLD_TILES.MEADOW,
        tags = { "RoadPoison", "shipwrecked" }, --"ForceDisconnected"
        contents =
        {
            distributepercent = 0.3,
            distributeprefabs = {
                sapling = 0.2,
                tree_forest_deep = 0.5,
                bambootree = 1,
                bambootreebig = 1,
                bush_vine = 0.05,
                cave_banana_tree = 0.05,
                snake_hole = 0.05,
            },

            countprefabs =
            {
                pandatree = function() return 4 + math.random(1, 2) end,
                pandahouse = function() return 2 + math.random(0, 1) end,
                red_mushroom = function() return math.random(1, 2) end,

            }
        }
    })
AddRoom("pandajungle2",
    {
        colour = { r = .6, g = .2, b = .8, a = .50 },
        value = WORLD_TILES.MEADOW,
        tags = { "RoadPoison", "shipwrecked" }, --"ForceDisconnected"
        contents =
        {
            distributepercent = 0.3,
            distributeprefabs = {
                sapling = 0.2,
                --tree_forest_deep = 0.5,
                bambootree = 1,
                bambootreebig = 1,
                cave_banana_tree = 0.5,
                snake_hole = 0.015,
            },

            countprefabs =
            {
                pandatree = function() return 4 + math.random(1, 2) end,
                red_mushroom = function() return math.random(0, 1) end,
                pandahouse = function() return 2 + math.random(0, 1) end,

            }
        }
    })
AddRoom("pandajungle3",
    {
        colour = { r = 1, g = 1, b = 1, a = .50 },
        value = WORLD_TILES.MEADOW,
        tags = { "RoadPoison", "shipwrecked" }, --"ForceDisconnected"
        contents =
        {
            distributepercent = 0.3,
            distributeprefabs =
            {
                houndbone = 0.25,
                bambootree = 1,
                bambootreebig = 1,
                --pandatree = 0.006,
                flower = 0.2,
            },
            countprefabs =
            {
                pandatree = function() return 4 + math.random(0, 1) end,
                pandahouse = function() return 1 + math.random(0, 1) end,
                red_mushroom = function() return math.random(0, 1) end,
            },
        }
    })
AddRoom("pandajungle4",
    {
        colour = { r = .6, g = .2, b = .8, a = .50 },
        value = WORLD_TILES.MEADOW,
        tags = { "RoadPoison", "shipwrecked" }, --"ForceDisconnected"
        contents =
        {
            distributepercent = 0.3,
            distributeprefabs = {
                sapling = 0.2,
                tree_forest_deep = 0.5,
                bambootree = 1,
                bambootreebig = 1,
                bush_vine = 0.02,
                cave_banana_tree = 0.05,
                snake_hole = 0.2,
            },

            countprefabs =
            {
                pandatree = function() return 4 + math.random(1, 2) end,
                pandahouse = function() return 1 + math.random(0, 1) end,
                red_mushroom = function() return math.random(0, 1) end,
            }
        }
    })

AddRoom("pandajungle5", {
    colour = { r = .8, g = 0.5, b = .6, a = .50 },
    value = WORLD_TILES.MEADOW,
    tags = { "RoadPoison", "shipwrecked" },
    contents = {
        countprefabs = {
            pandatree = function() return 4 + math.random(0, 1) end,
            pandahouse = function() return 1 + math.random(0, 1) end,
        },

        distributepercent = .4,
        distributeprefabs =
        {
            sapling = 0.2,
            tree_forest_deep = 0.4,
            bambootree = 1,
            bambootreebig = 1,
            bush_vine = 0.001,
        },
    }
})
AddRoom("pandajungle6", {
    colour = { r = .8, g = 0.5, b = .6, a = .50 },
    value = WORLD_TILES.MEADOW,
    tags = { "RoadPoison", "shipwrecked" },
    contents = {
        countprefabs = {
            pandatree = function() return 4 + math.random(0, 1) end,
            pandahouse = function() return 1 + math.random(0, 1) end,
        },

        distributepercent = .4,
        distributeprefabs =
        {
            sapling = 0.2,
            tree_forest_deep = 0.4,
            bambootree = 1,
            bambootreebig = 1,
            bush_vine = 0.001,
        },
    }
})


AddRoom("BGpandajungle", {
    colour = { r = 1, g = 1, b = 1, a = .50 },
    value = WORLD_TILES.MEADOW,
    tags = { "RoadPoison", "shipwrecked" }, --"ForceDisconnected"
    contents =
    {
        distributepercent = 0.3,
        distributeprefabs = {
            sapling = 0.2,
            tree_forest_deep = 0.5,
            bambootree = 1,
            bambootreebig = 1,
            bush_vine = 0.035,
            cave_banana_tree = 0.05,
            pandatree = 0.005,
        },
        countprefabs =
        {

            pandatree = function() return 1 + math.random(0, 1) end,
            pandahouse = function() return 1 + math.random(0, 1) end,
            red_mushroom = function() return math.random(0, 1) end,

        }
    }
})

AddRoom("seatarolake", {
    colour = { r = .6, g = .2, b = .8, a = .50 },
    value = WORLD_TILES.OCEAN_ROUGH,
    tags = { "RoadPoison", "ForceConnected" }, --"ForceDisconnected"
    type = NODE_TYPE.SeparatedRoom,
    contents =
    {
        distributepercent = 0.5,
        distributeprefabs =
        {
            seataro_planted = 1,
        },
    }
})

AddRoom("Marshpool", {
    colour = { r = 0.5, g = .16, b = .35, a = .50 },
    value = WORLD_TILES.MARSH,
    tags = { "RoadPoison" }, ----"ForceConnected"
    type = NODE_TYPE.SeparatedRoom,
    contents = {
        countstaticlayouts = {
            ["MushroomRingMedium"] = function()
                if math.random(0, 10) > 5 then
                    return 1
                end
                return 0
            end
        },
        distributepercent = .7,
        distributeprefabs =
        {
            tentacle = 0.40,
            flupspawner = 0.30,
            pighead = 0.01,
            reeds = 0.20,
            blue_mushroom = 0.20,
            green_mushroom = 0.15,
            mangrovetree = 0.2,
            Grasswaterspawner = 0.4,
            poisonmist = 0.3,
        },
        countprefabs =
        {
            sedimentpuddle = 1,
            mermhouse = 1,
            mermhouse_fisher = 1,
            poisonhole = 1.5,
            fishinhole = 1.5,
        },
    }
})
-- OX,en Biome
-- merm city
AddRoom("MermySwamp1", {
    colour = { r = 0.5, g = .16, b = .35, a = .50 },
    value = WORLD_TILES.MARSH,
    tags = { "RoadPoison" }, ----"ForceConnected"
    contents = {
        distributepercent = .8,
        distributeprefabs =
        {
            pighead = 0.01,
            bush_vine = 0.2,
            flower_evil = 0.4,
            mangrovetree = 0.5,
            Grasswaterspawner = 0.4,
            blue_mushroom = 0.01,
            green_mushroom = 2.02,
            poisonmist = 0.3,
            poisonhole = 0.1,
            reeds = 0.1,
        },
        countprefabs =
        {
            mermhouse = 3,
            mermhouse_fisher = 2,
            sedimentpuddle = 1,
            mangrovetree = 10,
            Grasswaterspawner = 15,
            farm_plow = 3,
        },
    }
})
AddRoom("swambpool1", {
    colour = { r = 0.5, g = .16, b = .35, a = .50 },
    value = WORLD_TILES.MARSH,
    tags = { "RoadPoison" }, ----"ForceConnected"
    type = NODE_TYPE.SeparatedRoom,
    contents = {
        distributepercent = 0.8,
        distributeprefabs =
        {
            mangrovetree = 0.5,
            Grasswaterspawner = 0.7,
            bush_vine = 0.3,
            snakeskin = 0.2,
            reeds = 0.1,
            poisonmist = 0.2,
            tentacle = 0.40,
            flupspawner = 0.30,
        },
        countprefabs =
        {
            sedimentpuddle = 1,
            poisonhole = 1,
            farm_plow = 2,
        },
    }
})
AddRoom("swambpool2", {
    colour = { r = 0.5, g = .16, b = .35, a = .50 },
    value = WORLD_TILES.MARSH,
    tags = { "RoadPoison" }, ----"ForceConnected"
    type = NODE_TYPE.SeparatedRoom,
    contents = {
        distributepercent = 0.8,
        distributeprefabs =
        {
            mangrovetree = 0.5,
            Grasswaterspawner = 0.7,
            bush_vine = 0.3,
            snakeskin = 0.2,
            reeds = 0.35,
            tentacle = 0.40,
            flupspawner = 0.30,
            poisonmist = 0.2,
        },
        countprefabs =
        {
            sedimentpuddle = 2,
            poisonhole = 3,
        },
    }
})

AddRoom("poolox", {
    colour = { r = 0.5, g = .16, b = .35, a = .50 },
    value = WORLD_TILES.OCEAN_COASTAL_SHORE,
    level_set_piece_blocker = true,
    tags = { "RoadPoison" }, ----"ForceConnected"
    type = NODE_TYPE.SeparatedRoom,
    contents = {
        countstaticlayouts = { ["pantano"] = 1 },
        distributepercent = 1,
        distributeprefabs =
        {
        },
    }
})
AddRoom("poolox1", {
    colour = { r = 0.5, g = .16, b = .35, a = .50 },
    value = WORLD_TILES.OCEAN_COASTAL_SHORE,
    level_set_piece_blocker = true,
    tags = { "RoadPoison" }, ----"ForceConnected"
    type = NODE_TYPE.SeparatedRoom,
    contents = {
        countstaticlayouts = { ["pantano"] = 1 },
        distributepercent = 1,
        distributeprefabs =
        {
        },
    }
})
AddRoom("poolox2", {
    colour = { r = 0.5, g = .16, b = .35, a = .50 },
    value = WORLD_TILES.OCEAN_COASTAL_SHORE,
    level_set_piece_blocker = true,
    tags = { "RoadPoison" }, ----"ForceConnected"
    type = NODE_TYPE.SeparatedRoom,
    contents = {
        countstaticlayouts = { ["pantano"] = 1 },
        distributepercent = 1,
        distributeprefabs =
        {
        },
    }
})
AddRoom("poolox3", {
    colour = { r = 0.5, g = .16, b = .35, a = .50 },
    value = WORLD_TILES.OCEAN_COASTAL_SHORE,
    level_set_piece_blocker = true,
    tags = { "RoadPoison" }, ----"ForceConnected"
    type = NODE_TYPE.SeparatedRoom,
    contents = {
        countstaticlayouts = { ["pantano"] = 1 },
        distributepercent = 1,
        distributeprefabs =
        {
        },
    }
})
