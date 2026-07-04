AddRoom("CoralReefJunked", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = WORLD_TILES.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2) - 1) end,
            sunkenchest_spawner = function() return (math.random(2) - 1) end,
        },

        distributepercent = 0.3,
        distributeprefabs = {
            sandstone_boulder = 0.01,
            uw_coral = 1.3,
            uw_coral_blue = 1.3,
            uw_coral_green = 1.3,
            reef_jellyfish = 0.4,
            --			seatentacle = 0.5,
            bubble_vent = 0.03,
            squidunderwater = 0.01,
            cut_orange_coral = 1,
            decorative_shell = 0.05,
            sea_eel = 0.2,
            sponge = 0.15,
            commonfish = 0.2,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },
    },
})
AddRoom("bg_CoralReef", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = WORLD_TILES.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        distributepercent = 0.8,
        distributeprefabs = {
            sandstone_boulder = 0.01,
            uw_coral = 2,
            uw_coral_blue = 2.5,
            uw_coral_green = 2,
            reef_jellyfish = 0.3,
            kelpunderwater = 1,
            bubble_vent = 0.1,
            commonfish = 0.1,
            shrimp = 0.1,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },
    },
})

AddRoom("CoralReef", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = WORLD_TILES.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2) - 1) end,
        },

        distributepercent = 0.6,
        distributeprefabs = {
            sandstone_boulder = 0.01,
            uw_coral = 1.5,
            uw_coral_blue = 1.5,
            uw_coral_green = 1,
            reef_jellyfish = 0.4,
            --			seatentacle = 0.5,
            bubble_vent = 0.03,
            squidunderwater = 0.001,
            decorative_shell = 0.2,
            sea_eel = 0.2,
            sponge = 0.15,
            rainbowjellyfish_underwater = 0.01,
            commonfish = 0.1,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },
    },
})
AddRoom("CoralReefLight", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = WORLD_TILES.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2) - 1) end,
            gnarwailunderwater = 1,
        },

        distributepercent = 0.3,
        distributeprefabs = {
            sandstone_boulder = 0.05,
            uw_coral = 1,
            uw_coral_blue = 1,
            uw_coral_green = 1,
            iron_boulder = 0.5,
            bubble_vent = 0.03,
            rotting_trunk = 0.1,
            reef_jellyfish = 0.4,
            squidunderwater = 0.01,
            decorative_shell = 0.1,
            wormplant = 0.1,
            sponge = 0.15,
            commonfish = 0.2,
            rainbowjellyfish_underwater = 0.01,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },
    },
})
