AddRoom("kraken_zone_basic", {
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
            bubble_vent = 0.03,
            uw_flowers = .1,
            wreckunderwater = 0.5,
            --										shrimp = 0.1,
            quagmire_salmom_alive = 0.1,
            crate = 0.1,
            redbarrelunderwater = 0.2,
            --										bioluminescence = 0.03,		
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
            uw_coral_blue = 0.1,
            uw_coral_green = 0.1,
            tidal_node = 0.1,
        },

    }
})

AddRoom("kraken_zone", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2) - 1) end,
            krakenunderwater = 1,
        },
        distributepercent = .25,
        distributeprefabs =
        {
            bubble_vent = 0.03,
            uw_flowers = .1,
            --                                      mussel_bed = .2,
            commonfish = 0.05,
            shrimp = 0.1,
            quagmire_salmom_alive = 0.1,
            redbarrelunderwater = 0.1,
            wreckunderwater = 0.5,
            crate = 0.5,
            --										bioluminescence = 0.03,		
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },

    }
})

AddRoom("kraken_zone_bg", {
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
            bubble_vent = 0.03,
            uw_flowers = .1,
            --										mussel_bed =.2,
            commonfish = 0.05,
            shrimp = 0.1,
            quagmire_salmom_alive = 0.1,
            wreckunderwater = 0.5,
            crate = 0.1,
            redbarrelunderwater = 0.2,
            --										bioluminescence = 0.03,		
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
            uw_coral_blue = 0.1,
            uw_coral_green = 0.1,
            tidal_node = 0.1,
        },

    }
})
