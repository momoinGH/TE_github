AddRoom("RockyBottom", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = WORLD_TILES.UNDERWATER_ROCKY,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2)) end,
        },

        distributepercent = 0.225,
        distributeprefabs = {
            rock1 = 0.1,
            rock2 = 0.05,
            iron_boulder = 0.4,
            squidunderwater = 0.002,
            sponge = 0.001,
            bubble_vent = 0.01,
            commonfish = 0.1,
            shrimp = 0.1,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },
    },
})

AddRoom("RockyBottomBroken", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = WORLD_TILES.UNDERWATER_ROCKY,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2)) end,
        },

        distributepercent = 0.15,
        distributeprefabs = {
            rocks = 0.1,
            rock1 = 0.1,
            rock2 = 0.05,
            iron_ore = 0.03,
            iron_boulder = 0.4,
            squidunderwater = 0.002,
            sponge = 0.001,
            bubble_vent = 0.01,
            commonfish = 0.1,
            shrimp = 0.1,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },
    },
})
AddRoom("bg_RockyBottom", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = WORLD_TILES.UNDERWATER_ROCKY,
    tags = { "RoadPoison" },
    contents = {
        distributepercent = 0.15,
        distributeprefabs = {
            rock1 = 0.1,
            rock2 = 0.05,
            iron_boulder = 0.4,
            squidunderwater = 0.002,
            sponge = 0.001,
            bubble_vent = 0.01,
            commonfish = 0.1,
            shrimp = 0.1,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },
    },
})
