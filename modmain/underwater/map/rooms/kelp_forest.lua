AddRoom("KelpForest", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = WORLD_TILES.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        distributepercent = 0.6,
        distributeprefabs = {
            kelpunderwater = 2.5,
            rotting_trunk = 0.01,
            seagrass = 0.005,
            sandstone_boulder = 0.0008,
            squidunderwater = 0.001,
            flower_sea = 0.1,
            sea_eel = 0.001,
            bubble_vent = 0.03,
            commonfish = 0.2,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },
    },
})

AddRoom("KelpForestLight", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = WORLD_TILES.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2) - 1) end,
            sunkenchest_spawner = function() return (math.random(2) - 1) end,
        },
        distributepercent = 0.6,
        distributeprefabs = {
            kelpunderwater = 0.5,
            rotting_trunk = 0.05,
            seagrass = 0.005,
            sandstone_boulder = 0.0008,
            --			mermworkerhouse = 0.02,
            squidunderwater = 0.0001,
            --			seatentacle = 0.0001,
            flower_sea = 0.1,
            sea_eel = 0.002,
            bubble_vent = 0.03,
            commonfish = 0.05,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },
    },
})
AddRoom("KelpForestInfested", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = WORLD_TILES.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        distributepercent = 0.6,
        distributeprefabs = {
            kelpunderwater = 2.5,
            rotting_trunk = 0.01,
            seagrass = 0.005,
            sandstone_boulder = 0.008,
            reef_jellyfish = 0.2,
            squidunderwater = 0.005,
            flower_sea = 0.1,
            sea_eel = 0.001,
            rainbowjellyfish_underwater = 0.01,
            bubble_vent = 0.03,
            commonfish = 0.15,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },
    },
})

AddRoom("bg_KelpForest", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = WORLD_TILES.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        distributepercent = 0.8,
        distributeprefabs = {
            kelpunderwater = 2.5,
            rotting_trunk = 0.01,
            seagrass = 0.005,
            sandstone_boulder = 0.0008,
            flower_sea = 0.1,
            commonfish = 0.1,
            shrimp = 0.1,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },
    },
})
