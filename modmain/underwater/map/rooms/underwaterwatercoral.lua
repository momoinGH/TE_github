AddRoom("underwaterwatercoral_octopus", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.PAINTED,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2)) end,
            coral_brain_rockunderwater = 1,
            sunkenchest_spawner = function() return (math.random(2) - 1) end,
            --									octopuskingunderwater = 1,
        },
        distributepercent = .25,
        distributeprefabs =
        {
            coralreefunderwater = 1,
            bubble_vent = 0.03,
            uw_flowers = .1,
            shrimp = 0.1,
            fish4_alive = 0.1,
            fish5_alive = 0.1,
            --										bioluminescence = 0.03,		
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },

    }
})

AddRoom("underwaterwatercoral", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.PAINTED,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2)) end,
            coral_brain_rockunderwater = 1,
        },
        distributepercent = .25,
        distributeprefabs =
        {
            coralreefunderwater = 1,
            bubble_vent = 0.03,
            uw_flowers = .1,
            shrimp = 0.1,
            fish4_alive = 0.1,
            fish5_alive = 0.1,
            --										bioluminescence = 0.03,		
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },

    }
})
AddRoom("underwaterwatercoral_bg", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.PAINTED,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2)) end,
            coral_brain_rockunderwater = 1,
        },
        distributepercent = .25,
        distributeprefabs =
        {
            coralreefunderwater = 0.2,
            bubble_vent = 0.03,
            uw_flowers = .1,
            fish4_alive = 0.05,
            fish5_alive = 0.05,
            --										bioluminescence = 0.03,		
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },

    }
})
