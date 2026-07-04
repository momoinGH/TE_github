modimport "modmain/underwater/map/rooms/coral_reef.lua"
modimport "modmain/underwater/map/rooms/sandy_bottom.lua"
modimport "modmain/underwater/map/rooms/kelp_forest.lua"
modimport "modmain/underwater/map/rooms/rocky_bottom.lua"
modimport "modmain/underwater/map/rooms/tidal_zone.lua"
modimport "modmain/underwater/map/rooms/beach.lua"
modimport "modmain/underwater/map/rooms/underwaterothers.lua"
modimport "modmain/underwater/map/rooms/kraken_zone.lua"
modimport "modmain/underwater/map/rooms/underwaterwatercoral.lua"
modimport "modmain/underwater/map/rooms/exit_patch.lua"
modimport "modmain/underwater/map/rooms/lunnar.lua"

AddRoom("cave_underwater1_part1", {
    colour = { r = .25, g = .28, b = .25, a = .50 },
    value = WORLD_TILES.UNDERWATER_ROCKY,
    tags = { "RoadPoison" },
    contents = {
        countstaticlayouts = {
            ["atlantida"] = 1,
        },
        distributepercent = .175,
        distributeprefabs =
        {
            stalagmite = .025,
            stalagmite_med = .025,
            stalagmite_low = .025,
            bioluminescence = 0.01,
            fissure = 0.002,
            lichen = .25,
            cave_fern = 1,
            pillar_algae = .05,
        },
    }
})
AddRoom("startPatch", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = WORLD_TILES.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            underwater_exit = 1,
        },
        distributepercent = 0.3,
        distributeprefabs = {
            seagrass = 0.35,
            sandstone_boulder = 0.01,
            bubble_vent = 0.03,
            kelpunderwater = 0.2,
            squidunderwater = 0.001,
            flower_sea = 0.1,
            decorative_shell = 0.05,
            wormplant = 0.1,
            sea_eel = 0.01,
            clam = 0.06,
            sponge = 0.25,
            sea_cucumber = 0.1,
            commonfish = 0.1,
            shrimp = 0.2,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
            uw_flowers = 0.1,
        },
    },
})
AddRoom("cave_underwater_base", {
    colour = { r = 0, g = 0, b = 0, a = 0.9 },
    value = WORLD_TILES.UNDERWATER_ROCKY,
    tags = { "RoadPoison" },
    contents = {
        --									countstaticlayouts={
        --										["CaveBase"]=1,
        --									},
        distributepercent = .15,
        distributeprefabs =
        {
            bioluminescence = 0.3,
            quagmire_salmom_alive = 0.15,
            stalagmite_tall_low = 1,
            stalagmite_tall_med = 0.6,
            stalagmite_tall = 0.2,
            pillar_cave = .05,
            pillar_stalactite = .05,
        },
    }
})
AddRoom("cave_underwater1_entrance", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.UNDERWATER_ROCKY,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2)) end,
            secretcaveentrance = 1,
        },
        distributepercent = .25,
        distributeprefabs =
        {
            stalagmite = 0.15,
            stalagmite_med = 0.15,
            stalagmite_low = 0.15,
            pillar_cave = 0.08,
            uw_flowers = 0.05,
            dogfish_under = 0.1,
            commonfish = 0.1,
        }

    }
})
AddRoom("atlantidaExitRoom", {
    colour = { r = .25, g = .28, b = .25, a = .50 },
    value = WORLD_TILES.SINKHOLE,
    contents = {
        countprefabs = { underwater_exit = 1, },
        distributepercent = .2,
        distributeprefabs =
        {
            cavelight = 0.05,
            cavelight_small = 0.05,
            cavelight_tiny = 0.05,
            flower_cave = 0.5,
            flower_cave_double = 0.1,
            flower_cave_triple = 0.05,
            cave_fern = 0.5,
            fireflies = 0.01,

            red_mushroom = 0.1,
            green_mushroom = 0.1,
            blue_mushroom = 0.1,
        }
    }
})
AddRoom("underwaterlavarock", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.UNDERWATER_ROCKY,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2)) end,
            sunkenchest_spawner = function() return (math.random(2) - 1) end,
        },
        distributepercent = .25,
        distributeprefabs =
        {
            rock_limpet = 0.1,
            bubble_vent = 0.03,
            uw_flowers = .1,
            commonfish = 0.05,
            --										shrimp = 0.1,
            dogfish_under = 0.1,
            fish_coi = 0.1,
            redbarrelunderwater = 0.2,
            --										bioluminescence = 0.03,		
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },

    }
})

AddRoom("underwatermagmafield", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.MAGMAFIELD,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2)) end,
            sunkenchest_spawner = function() return (math.random(2) - 1) end,
        },
        distributepercent = .25,
        distributeprefabs =
        {
            magmarock = 1,
            magmarock_gold = 0.2,
            iron_boulder = 0.6,
            rock_cave = 0.5,
            quagmire_salmom_alive = 0.05,
            dogfish_under = 0.1,
            rock_charcoal = 0.5,
            --									squid = 0.002,
            bubble_vent = 0.01,
            --									shrimp = 0.1,
            --									bioluminescence = 0.03,		
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },

    }
})

AddRoom("underwatermagmafield1", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.MAGMAFIELD,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2)) end,
        },
        distributepercent = .25,
        distributeprefabs =
        {
            magmarock = 1,
            magmarock_gold = 0.2,
            iron_ore = 0.03,
            iron_boulder = 0.8,
            rock_cave = 0.5,
            quagmire_salmom_alive = 0.05,
            dogfish_under = 0.1,
            rock_charcoal = 0.5,
            bubble_vent = 0.01,
            shrimp = 0.1,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },

    }
})
AddRoom("UnderwaterEntrance", {
    colour = { r = 1, g = 0, b = 0, a = 0.3 },
    value = GROUND.FOREST,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            underwater_entrance = 1,
        },
        distributepercent = 0.25,
        distributeprefabs = {
            grass = 2,
            sapling = 2,
            green_mushroom = 3,
            blue_mushroom = 3,
            flower = 1,
            houndbone = 1,
        }
    }
})
