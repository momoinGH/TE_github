AddRoom("beach1", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = WORLD_TILES.BEACH,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = { sunkenchest_spawner = function() return (math.random(2) - 1) end, },

        distributepercent = 0.3,
        distributeprefabs = {
            sandhill = .3,
            seashell_beached = .5,
            rock_limpet = 0.08,
            crate = 0.1,
            jellyfish_underwater = 0.1,
            fish2_alive = 0.1,
            fish3_alive = 0.05,
            shrimp = 0.1,
            bubble_vent = 0.03,
            --										bioluminescence = 0.03,		
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },
    },
})

AddRoom("beach2", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = WORLD_TILES.BEACH,
    tags = { "RoadPoison" },
    contents = {
        distributepercent = 0.3,
        distributeprefabs = {
            sandhill = 0.5,
            seashell_beached = 0.5,
            rock_limpet = 1,
            crate = 0.1,
            stungrayunderwater = 1,
            jellyfish_underwater = 0.1,
            fish2_alive = 0.1,
            --										shrimp = 0.1,										
            fish3_alive = 0.05,
            bubble_vent = 0.03,
            --										bioluminescence = 0.03,	
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },
    },
})

AddRoom("beach_crab", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.BEACH,
    tags = { "RoadPoison" },
    contents = {
        distributepercent = .25,
        distributeprefabs =
        {
            sandhill = 0.5,
            seashell_beached = 1,
            rock_limpet = 0.5,
            crate = 0.1,
            crabhole = 1,
            fish2_alive = 0.05,
            fish3_alive = 0.05,
            --										shrimp = 0.1,										
            bubble_vent = 0.03,
            --										bioluminescence = 0.03,	
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },

    }
})

AddRoom("beach_bg", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.BEACH,
    tags = { "RoadPoison" },
    contents = {
        distributepercent = .25,
        distributeprefabs =
        {
            sandhill = 1,
            seashell_beached = 0.5,
            rock_limpet = 0.5,
            crate = 0.1,
            fish2_alive = 0.1,
            fish3_alive = 0.05,
            squidunderwater = 0.002,
            bubble_vent = 0.03,
            --										shrimp = 0.1,
            bioluminescence = 0.03,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },

    }
})
