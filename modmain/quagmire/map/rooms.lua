AddRoom("gorge_main", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.IMPASSABLE,
    tags = { "RoadPoison" },
    contents = {
        countstaticlayouts =
        {
            ["quagmire_kitchen"] = 1 --adds 1 per room											
        },
        distributepercent = .25,
        distributeprefabs =
        {
            rocks = .1,
        },

    }
})


AddRoom("quagmire", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = WORLD_TILES.QUAGMIRE_GATEWAY,

    contents = {
        distributepercent = .2,
        distributeprefabs =
        {
            sugarwood_tall = 0.5, --nitre
            --					                    quagmire_pond_salt = .1,
            flower = 0.112,
            carrot_planted = 0.05,
            flint = 0.05,
            quagmire_spotspice_shrub = 0.3,
            sapling = 0.2,
            blue_mushroom = .005,
            green_mushroom = .003,
            red_mushroom = .004,
            rabbithole = 0.01,
        },

        countprefabs =
        {
            --					                	quagmire_swampig_house_rubble = 3,
        }
    }
})


AddRoom("quagmire1", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = WORLD_TILES.QUAGMIRE_GATEWAY,

    contents = {
        --									countstaticlayouts=
        --									{
        --										[esculturas[math.random(1, 4)]] = 1,	
        --									},								
        distributepercent = .2,
        distributeprefabs =
        {
            cottontree_normal = 0.5, --nitre
            --					                    quagmire_pond_salt = .1,
            quagmire_spotspice_shrub = 0.1,
        },

        countprefabs =
        {
            quagmire_swampig_house = 3,
            quagmiregoat = 4,
        }
    }
})


AddRoom("gorgeislandcity", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = WORLD_TILES.QUAGMIRE_CITYSTONE,

    contents = {
        countstaticlayouts = { ["goatkid"] = 1, },
        distributepercent = .2,
        distributeprefabs =
        {
            --cottontree = 0.5, --nitre
            --					                    quagmire_pond_salt = .15,
            quagmire_spotspice_shrub = 0.1,
            rock1 = 0.3,
            rock2 = 0.3,
            rock_moon = 0.1,
            rock_flintless = 0.2,
            rocks = 0.1,
            nitre = 0.1,
            flint = 0.1,
        },

        countprefabs =
        {
            --					                	quagmire_swampig_house_rubble = 2,
            --										pebblecrabspawner = 2,
        }
    }
})

AddRoom("gorgeislandcity2", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = WORLD_TILES.QUAGMIRE_CITYSTONE,

    contents = {
        countstaticlayouts = { ["goatkid2"] = 1, },
        distributepercent = .2,
        distributeprefabs =
        {
            --cottontree = 0.5, --nitre
            --					                    quagmire_pond_salt = .15,
            quagmire_spotspice_shrub = 0.1,
            rock1 = 0.3,
            rock2 = 0.3,
            rock_moon = 0.1,
            rock_flintless = 0.2,
            rocks = 0.1,
            nitre = 0.1,
            flint = 0.1,
        },

        countprefabs =
        {
            --					                	quagmire_swampig_house_rubble = 2,
            --										pebblecrabspawner = 2,
        }
    }
})

AddRoom("quagmire2", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = WORLD_TILES.QUAGMIRE_CITYSTONE,

    contents = {
        distributepercent = .2,
        distributeprefabs =
        {
            --cottontree = 0.5, --nitre
            quagmire_spotspice_shrub = 0.1,
            rock1 = 0.3,
            rock2 = 0.3,
            rock_moon = 0.1,
            rock_flintless = 0.2,
            rocks = 0.1,
            nitre = 0.1,
            flint = 0.1,
        },

        countprefabs =
        {
            --					                	quagmire_swampig_house_rubble = 2,
            pebblecrabspawner = 2,
            quagmire_pond_salt = 1,
        }
    }
})
AddRoom("quagmireswampcity", {
    colour = { r = 0.8, g = .8, b = .1, a = .50 },
    value = WORLD_TILES.QUAGMIRE_PEATFOREST,
    required_prefabs = { "quagmire_swampigelder" },
    contents = {
        distributepercent = .5,
        distributeprefabs =
        {
            fireflies = 0.1,
            --evergreen = 6,
            grass = .05,
            sapling = .5,
            evergreen_sparse = 0.5,
            ground_twigs = 0.3,
            berrybush = .02,
            berrybush_juicy = 0.01,
            blue_mushroom = 0.02,
            quagmire_mushroomstump = 0.02,
            trees = { weight = 6, prefabs = { "evergreen_sparse", "evergreen_sparse" } }
        },

        countstaticlayouts =
        {
            ["elderpig"] = 1,
            ["CropCirclegorge"] = 1,
        },
        countprefabs = {
            quagmire_swampig_house = 2,
        }
    }
})

AddRoom("quagmireswamp", {
    colour = { r = 0, g = .9, b = 0, a = .50 },
    value = WORLD_TILES.QUAGMIRE_PEATFOREST,
    contents = {
        distributepercent = .5,
        distributeprefabs =
        {
            fireflies = 0.1,
            --evergreen = 6,
            grass = .05,
            sapling = .5,
            evergreen_sparse = 0.5,
            ground_twigs = 0.3,
            berrybush = .02,
            berrybush_juicy = 0.01,
            blue_mushroom = 0.02,
            trees = { weight = 6, prefabs = { "evergreen_sparse", "evergreen_sparse" } }
        },
        countprefabs = {
            quagmire_mushroomstump = 7,
            quagmire_swampig_house = 1,
        }
    }

})
AddRoom("chickenbiomeset", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = WORLD_TILES.SAVANNA,

    contents = {
        countstaticlayouts = { ["mermtrader1set"] = 1, },
        distributepercent = .2,
        distributeprefabs =
        {
            rock_flippable = 0.10,
            grass = 0.4,
            twiggytree = 0.2,
            carrot_planted = 0.05,
            radish_planted = 0.05,
        },

        countprefabs =
        {
            quagmire_beefalo = 4,
            beefalo = 1,
            chickenhouse = 2,
        }
    }
})

AddRoom("chickenbiome", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = WORLD_TILES.SAVANNA,

    contents = {
        distributepercent = .2,
        distributeprefabs =
        {
            rock_flippable = 0.10,
            grass = 0.4,
            twiggytree = 0.2,
            carrot_planted = 0.05,
            radish_planted = 0.05,
        },

        countprefabs =
        {
            chickenhouse = 2,
        }
    }
})
AddRoom("quagmirepinkset", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = WORLD_TILES.QUAGMIRE_PARKFIELD,
    contents = {
        countstaticlayouts = { ["mermtrader2set"] = 1, },
        distributepercent = .6,
        distributeprefabs =
        {
            cottontree_small = 0.5, --nitre
            cave_fern = 0.112,
            turnip_planted = 0.05,
            flint = 0.05,
            quagmire_spotspice_shrub = 0.3,
            blue_mushroom = .005,
            green_mushroom = .003,
            red_mushroom = .004,
            rabbithole = 0.01,
            gravestone = 0.01,
            sapling = 0.15,
            rock1 = 0.008,
            rock2 = 0.008,
        },
        countprefabs =
        {
            --										quagmire_swampig_house_rubble = 4,
        }
    }
})

AddRoom("quagmirepink", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = WORLD_TILES.QUAGMIRE_PARKFIELD,
    contents = {
        distributepercent = .6,
        distributeprefabs =
        {
            cottontree_normal = 0.5, --nitre
            cave_fern = 0.112,
            turnip_planted = 0.05,
            flint = 0.05,
            quagmire_spotspice_shrub = 0.3,
            blue_mushroom = .005,
            green_mushroom = .003,
            red_mushroom = .004,
            rabbithole = 0.01,
            gravestone = 0.01,
            sapling = 0.15,
            rock1 = 0.008,
            rock2 = 0.008,
        },
        countprefabs =
        {
            --										quagmire_swampig_house_rubble = 4,
        }
    }
})

-----------blue biome ------------------					
AddRoom("quagmireblueset", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = WORLD_TILES.QUAGMIRE_GATEWAY,
    contents = {
        countstaticlayouts = { ["mermtrader3set"] = 1, },
        distributepercent = .3,
        distributeprefabs =
        {
            sapling = 0.1, --nitre
            --										twiggytree = 0.2,
            --										cave_fern=0.112,
            carrot_planted = 0.05,
            flint = 0.05,
            quagmire_spotspice_shrub = 0.3,
            berrybush2 = 0.1,
            blue_mushroom = .005,
            green_mushroom = .003,
            red_mushroom = .004,
            rabbithole = 0.01,
        },
        countprefabs =
        {
            --										quagmire_swampig_house_rubble = 4,
        }
    }
})


AddRoom("quagmireblue", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = WORLD_TILES.QUAGMIRE_GATEWAY,
    contents = {
        distributepercent = .3,
        distributeprefabs =
        {
            sapling = 0.1, --nitre
            --										twiggytree = 0.2,
            --										cave_fern=0.112,
            carrot_planted = 0.05,
            flint = 0.05,
            quagmire_spotspice_shrub = 0.3,
            berrybush2 = 0.1,
            blue_mushroom = .005,
            green_mushroom = .003,
            red_mushroom = .004,
            rabbithole = 0.01,
        },
        countprefabs =
        {
            --										quagmire_swampig_house_rubble = 4,
        }
    }
})
