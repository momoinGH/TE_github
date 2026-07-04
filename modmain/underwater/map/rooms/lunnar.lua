AddRoom("LunnarBottom", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = WORLD_TILES.PEBBLEBEACH,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2)) end,
        },

        distributepercent = 0.3,
        distributeprefabs = {
            squidunderwater = 0.002,
            sponge = 0.001,
            bubble_vent = 0.01,
            shrimp = 0.1,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
            oceanfishableflotsam = 0.1,
            trap_starfish = 0.5,
            dead_sea_bones = 0.5,
            pond_algae = 0.5,
            seaweedunderwater = 2,
        },
    },
})

AddRoom("LunnarBottomBroken", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = WORLD_TILES.PEBBLEBEACH,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = 1,
            gnarwailunderwater = 1,
            sunkenchest_spawner = function() return (math.random(2) - 1) end,
        },

        distributepercent = 0.3,
        distributeprefabs = {
            squidunderwater = 0.002,
            sponge = 0.001,
            bubble_vent = 0.01,
            shrimp = 0.1,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
            singingshell_octave3 = 0.1,
            singingshell_octave4 = 0.1,
            singingshell_octave5 = 0.1,
            shell_cluster = 0.01,
            oceanfishableflotsam = 0.1,
            trap_starfish = 0.5,
            dead_sea_bones = 0.5,
            pond_algae = 0.5,
            seaweedunderwater = 0.1,
        },
    },
})

AddRoom("Lunnarrocks", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = WORLD_TILES.PEBBLEBEACH,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2)) end,
        },

        distributepercent = 0.3,
        distributeprefabs = {
            iron_boulder = 0.4,
            squidunderwater = 0.002,
            sponge = 0.001,
            bubble_vent = 0.01,
            shrimp = 0.1,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
            shell_cluster = 0.01,
            oceanfishableflotsam = 0.1,
            trap_starfish = 0.5,
            dead_sea_bones = 0.5,
            pond_algae = 0.5,
            saltstack = 1,
            seastack = 1,
        },
    },
})

AddRoom("Lunnarrocksgnar", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = WORLD_TILES.PEBBLEBEACH,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = 1,
            gnarwailunderwater = 1,
        },

        distributepercent = 0.3,
        distributeprefabs = {
            iron_boulder = 0.4,
            squidunderwater = 0.002,
            sponge = 0.001,
            bubble_vent = 0.01,
            shrimp = 0.1,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
            shell_cluster = 0.01,
            oceanfishableflotsam = 0.1,
            trap_starfish = 0.5,
            dead_sea_bones = 0.5,
            pond_algae = 0.5,
            saltstack = 1,
            seastack = 1,
        },
    },
})

AddRoom("bg_LunnarBottom", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = WORLD_TILES.PEBBLEBEACH,
    tags = { "RoadPoison" },
    contents = {
        distributepercent = 0.20,
        distributeprefabs = {
            squidunderwater = 0.002,
            sponge = 0.001,
            bubble_vent = 0.01,
            shrimp = 0.1,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
            shell_cluster = 0.01,
            oceanfishableflotsam = 0.1,
            trap_starfish = 0.5,
            dead_sea_bones = 0.4,
            pond_algae = 0.5,
            seaweedunderwater = 0.2,
            seastack = 0.3,
            uw_coral = 0.2,
            uw_coral_blue = 0.2,
            uw_coral_green = 0.2,
        },
    },
})
