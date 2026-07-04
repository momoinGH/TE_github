AddRoom("underwaterothers_lobster", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2)) end,
            sunkenchest_spawner = function() return (math.random(2) - 1) end,
        },
        distributepercent = .25,
        distributeprefabs =
        {
            seagrass = 0.25,
            sandstone = 0.45,
            uw_coral = 0.1,
            uw_coral_blue = 0.1,
            uw_coral_green = 0.1,
            bubble_vent = 0.03,
            uw_flowers = .1,
            --										shrimp = 0.1,
            dogfish_under = 0.5,
            fish_coi = 0.5,
            lobsterunderwater = 1,
            --										bioluminescence = 0.03,	
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },

    }
})
AddRoom("underwaterothers_basic", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2)) end,
        },
        distributepercent = .25,
        distributeprefabs =
        {
            seagrass = 0.25,
            sandstone = 0.45,
            uw_coral = 0.1,
            uw_coral_blue = 0.1,
            uw_coral_green = 0.1,
            bubble_vent = 0.03,
            uw_flowers = .1,
            --										shrimp = 0.1,
            dogfish_under = 0.5,
            fish_coi = 0.5,
            tidal_node = 0.5,
            lobsterunderwater = 1,
            --										bioluminescence = 0.03,	
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },

    }
})
AddRoom("underwaterothers_bg", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2)) end,
        },
        distributepercent = .25,
        distributeprefabs =
        {
            seagrass = 0.25,
            sandstone = 0.45,
            uw_coral = 0.1,
            uw_coral_blue = 0.1,
            uw_coral_green = 0.1,
            bubble_vent = 0.03,
            uw_flowers = .1,
            --										shrimp = 0.1,
            dogfish_under = 0.5,
            fish_coi = 0.5,
            --										bioluminescence = 0.03,	
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },

    }
})
