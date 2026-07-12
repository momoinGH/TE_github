AddRoom("FrostIsland_Beach", {
    colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
    value = WORLD_TILES.SNOWLAND,
    tags = { "RoadPoison" },
    contents = {
        countprefabs =
        {
            snowspiderden2 = 1,
            snowpile1 = 1,
            giantsnowspawner = 1,
            billsnowspawner = 1,
        },
        distributepercent = 0.18,
        distributeprefabs =
        {
            dead_sea_bones = 0.35,
            driftwood_small1 = 0.2,
            driftwood_small2 = 0.2,
            driftwood_tall = 0.25,
            rock_ice = 0.05,
            pond = 0.1,
            rocks = 0.5,
            flint = 0.5,
            rock1 = 0.5,
            twigs = 0.25,
        },
    },
})
AddRoom("FrostIsland_deciduoustree", {
    colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
    value = WORLD_TILES.SNOWLAND,
    tags = { "RoadPoison" },
    internal_type = NODE_INTERNAL_CONNECTION_TYPE.EdgeCentroid,
    contents = {
        countstaticlayouts =
        {
        },
        countprefabs =
        {
            billsnowspawner = 1,
            snow_castle = 1,
            cratesnow = 1,
            snowgoat = 3,
        },
        distributepercent = 0.22,
        distributeprefabs =
        {
            snowdeciduoustree = 0.5,
            --			sapling_moon = 0.3,
            ground_twigs = 0.1,
            rabbithole = 0.1,
            rock_ice = 0.05,
            pond = 0.1,
            snow_dune = 0.1,
            arctic_flowers = 0.4,
        },
    },
})

AddRoom("FrostIsland_Mine", {
    colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
    value = WORLD_TILES.SNOWLAND,
    tags = { "RoadPoison" },
    internal_type = NODE_INTERNAL_CONNECTION_TYPE.EdgeCentroid,
    contents = {
        countprefabs =
        {
            giantsnowspawner = 1,
            cratesnow = 1,
            snowpile1 = 1,
        },
        distributepercent = 0.12,
        distributeprefabs =
        {
            rock2 = 0.2,
            rock_moon = 0.2,
            rock_ice = 0.2,
            moonrocknugget = 0.1,
            rocks = 0.1,
            flint = 0.1,
            pond = 0.2,
            snow_dune = 0.2,
        },
    },
})

AddRoom("FrostIsland_Mineboss", {
    colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
    value = WORLD_TILES.SNOWLAND,
    tags = { "RoadPoison" },
    internal_type = NODE_INTERNAL_CONNECTION_TYPE.EdgeCentroid,
    contents = {
        countprefabs =
        {
            snowwarg = 1,
            cratesnow = 1,
            snowpile1 = 1,
            --			houndmound = 2,
        },
        distributepercent = 0.12,
        distributeprefabs =
        {
            rock1 = 0.4,
            rock2 = 0.8,
            rock_moon = 0.2,
            rock_ice = 0.2,
            moonrocknugget = 0.1,
            rocks = 0.1,
            flint = 0.1,
            pond = 0.2,
            snow_dune = 0.2,
            skeleton = 0.2,
        },
    },
})

AddRoom("FrostIsland_Mammoth", {
    colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
    value = WORLD_TILES.SNOWLAND,
    tags = { "RoadPoison" },
    -- tags = { "RoadPoison" },
    internal_type = NODE_INTERNAL_CONNECTION_TYPE.EdgeCentroid,
    random_node_entrance_weight = 0,
    contents = {
        countprefabs =
        {
            snow_castle = 1,
            cratesnow = 1,
            mammoth = 5,
        },
        distributepercent = 0.3,
        distributeprefabs =
        {
            marsh_bush = 0.5,
            sapling = 0.5,
            rock_ice = 0.3,
            pond = 0.2,
            snow_dune = 0.2,
            perma_grass = 0.8,
            rabbithole = 0.4,
            arctic_flowers = 0.2,
        },
    },
})

AddRoom("FrostIsland_Meadows", {
    colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
    value = WORLD_TILES.SNOWLAND,
    tags = { "RoadPoison" },
    internal_type = NODE_INTERNAL_CONNECTION_TYPE.EdgeCentroid,
    random_node_exit_weight = 0,
    contents = {
        countprefabs =
        {
            snow_castle = 1,
            snowpile1 = 1,
            bearden = 1,
            snowspiderden2 = 1,
        },
        distributepercent = 0.25,
        distributeprefabs =
        {
            pond = 0.2,
            snow_dune = 0.2,
            rock_ice = 0.2,
            rock1 = 0.05,
            perma_grass = 0.7,
            rabbithole = 0.25,
            green_mushroom = .005,
            marsh_bush = 0.4,
            arctic_flowers = 0.2,
        },
    },
})

AddRoom("FrostIsland_Meadowscave", {
    colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
    value = WORLD_TILES.SNOWLAND,
    tags = { "RoadPoison" },
    internal_type = NODE_INTERNAL_CONNECTION_TYPE.EdgeCentroid,
    random_node_exit_weight = 0,
    contents = {
        countprefabs =
        {
            billsnowspawner = 1,
            snow_castle = 1,
            snowpile1 = 1,
            bearden = 1,
        },
        distributepercent = 0.12,
        distributeprefabs =
        {
            pond = 0.2,
            snow_dune = 0.2,
            --			sapling_moon = 1,
            ground_twigs = 1,
            snowberrybush = 1,
            evergreen = 0.5,
            rock_ice = 0.5,
            twigs = 0.5,
            arctic_flowers = 0.2,
        },
    },
})

AddRoom("strange_island_maxwell", {
    colour = { r = 0.5, g = .18, b = .35, a = .50 },
    value = WORLD_TILES.SNOWLAND,
    tags = { "RoadPoison" },
    contents = {
        countstaticlayouts = { ["mactuskgrass"] = 1 },
        distributepercent = .1,
        distributeprefabs = {
            evergreen = 0.75,
            marsh_bush = 1.5,
            snowpile1 = 1,
            arctic_flowers = 0.2,
        },
    }
})


AddRoom("strange_island_maxwell_set", {
    colour = { r = 0.5, g = .18, b = .35, a = .50 },
    value = WORLD_TILES.SNOWLAND,
    tags = { "RoadPoison" },
    contents = {
        countstaticlayouts = {
            ["strangerlord"] = 1,
            ["mactuskgrass"] = 1,
        },
        distributepercent = .1,
        distributeprefabs = {
            marsh_tree = 0.5,
            evergreen = 1,
            arctic_flowers = 0.2,
            --					                    marsh_bush= 1.5,	
        },

        countprefabs =
        {
            maxwellstatuebracod = 1,
            gravestone = 2,
            cave_entrance_frost = 1,
            cratesnow = 1,
        }
    }
})

AddRoom("strange_island_canada", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = WORLD_TILES.SNOWLAND,
    tags = { "RoadPoison" },
    --					type = NODE_TYPE.SeparatedRoom,		
    contents = {
        countstaticlayouts =
        {
            ["LivingTree"] = 1
        },
        distributepercent = .8,
        distributeprefabs =
        {
            fireflies = 0.1,
            grass = .05,
            sapling = .5,
            twiggytree = 0.5,
            ground_twigs = 0.3,
            snowberrybush = .021,
            blue_mushroom = 0.02,
            arctic_flowers = 0.2,
            trees = { weight = 6, prefabs = { "evergreen", "evergreen_sparse" } },
        },

        countprefabs =
        {
            wildbeaver_house = 3,
            gravestone = 2,
            snowpile1 = 1,
        }
    }
})


AddRoom("strange_island_canada2", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = WORLD_TILES.SNOWLAND,
    tags = { "RoadPoison" },
    --					type = NODE_TYPE.SeparatedRoom,	
    contents = {
        distributepercent = .38, --.5
        distributeprefabs =
        {
            fireflies = 0.2,
            rock1 = 0.05,
            grass = .05,
            sapling = .8,
            twiggytree = 0.8,
            roc_nest_debris1 = 0.05,
            roc_nest_debris2 = 0.05,
            roc_nest_debris3 = 0.05,
            roc_nest_debris4 = 0.05,
            --rabbithole=.05,
            snowberrybush = .045,
            red_mushroom = .03,
            green_mushroom = .02,
            arctic_flowers = 0.2,
            trees = { weight = 6, prefabs = { "evergreen", "evergreen_sparse" } },
        },
        countprefabs =
        {
            cratesnow = 1,
            wildbeaver_house = 3,
        },
    }
})

AddRoom("strange_island_canada3", {
    colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
    value = WORLD_TILES.SNOWLAND,
    tags = { "RoadPoison" },
    type = NODE_TYPE.SeparatedRoom,
    contents = {
        distributepercent = 0.17,
        distributeprefabs =
        {
            fireflies = 0.1,
            evergreen_sparse = 6,
            spiderden = 0.01,
            grass = .05,
            sapling = .5,
            twiggytree = 0.16,
            roc_nest_debris1 = 0.05,
            roc_nest_debris2 = 0.05,
            roc_nest_debris3 = 0.05,
            roc_nest_debris4 = 0.05,
            snowberrybush = .021,
            blue_mushroom = 0.02,
            pond = 0.2,
            snow_dune = 0.2,
            rock_ice = 0.3,
            arctic_flowers = 0.2,
        },
        countprefabs =
        {
            wildbeaver_house = 1,
        },
    },
})



AddRoom("frost_island_palace", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = WORLD_TILES.SNOWLAND,
    tags = { "RoadPoison" },
    contents = {
        --					countstaticlayouts={["strangerpigs"]=1},					
        distributepercent = .2,
        distributeprefabs =
        {
            --					                    quagmire_sugarwoodtree = 0.5, --nitre
            --					                    quagmire_pond_salt = .1,
            evergreen_sparse = 0.5,
            pond = .1,
            arctic_flowers = 0.112,
            carrot_planted = 0.05,
            flint = 0.05,
            --										quagmire_spotspice_shrub= 0.3,
            sapling = 0.2,
            blue_mushroom = .01,
            green_mushroom = .006,
            red_mushroom = .008,
        },

        countprefabs =
        {
            --					                	quagmire_beefalo = 3,
            --										beefalo = 1,
            --										quagmire_swampig_house_rubble = 3,
            maxwellstatuecabeca = 1,
            cratesnow = 1,
            snowpile1 = 1,
        }

    }
})

AddRoom("frost_island_palace_set", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = WORLD_TILES.SNOWLAND,
    tags = { "RoadPoison" },
    contents = {
        distributepercent = .2,
        distributeprefabs =
        {
            evergreen_sparse = 0.5,
            pond = .1,
            arctic_flowers = 0.112,
            carrot_planted = 0.05,
            flint = 0.05,
            --										quagmire_spotspice_shrub= 0.3,
            sapling = 0.5,
            blue_mushroom = .01,
            green_mushroom = .006,
            red_mushroom = .008,
        },

        countprefabs =
        {
            --					                	quagmire_beefalo = 3,
            --										beefalo = 1,
            --										quagmire_swampig_house_rubble = 3,
            maxwellstatuebracoe = 1,
        }

    }
})


AddRoom("frost_island_palace_city", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = WORLD_TILES.SNOWLAND,
    tags = { "RoadPoison" },
    contents = {
        countstaticlayouts = { ["city"] = 1 },
        distributepercent = .5,
        distributeprefabs =
        {
            evergreen_sparse = 0.5,
            arctic_flowers = 0.112,
            carrot_planted = 0.05,
            flint = 0.05,
            --										quagmire_spotspice_shrub= 0.3,
            sapling = 0.2,
            blue_mushroom = .01,
            green_mushroom = .006,
            red_mushroom = .008,
        },

        countprefabs =
        {
            snowman_lamp = 3,
            snowberrybush = 3,
        }

    }
})


AddRoom("FrostIsland_icelake_beager", {
    colour = { r = 0.5, g = .18, b = .35, a = .50 },
    value = WORLD_TILES.ICELAND,
    tags = { "RoadPoison", "sandstorm" },
    contents = {
        distributepercent = .1,
        distributeprefabs = {
            rock_ice = 0.5,
            pond = 0.05,
            icerockspider = 0.5,
            icerockpigman = 0.1,
            icerockcrow = 0.5,
            cristaled_tree_short = 0.5,
            cristaled_tree_tall = 0.5,
            icerockcarrat = 0.3,
        },
        countprefabs =
        {
            icerockbearger = 1,
            ice_deer = 3,
            icerockpigman = 2
        }
    }
})

AddRoom("FrostIsland_deeclop", {
    colour = { r = 0.5, g = .18, b = .35, a = .50 },
    value = WORLD_TILES.ICELAND,
    tags = { "RoadPoison", "sandstorm" },
    contents = {
        distributepercent = .1,
        distributeprefabs = {
            rock_ice = 0.5,
            pond = 0.05,
            icerockspider = 0.5,
            icerockpigman = 0.1,
            icerockcrow = 0.5,
            cristaled_tree_short = 0.5,
            cristaled_tree_tall = 0.5,
            icerockcarrat = 0.3,
        },
        countprefabs =
        {
            icerockdeerclops = 1,
            ice_deer = 4,
        }
    }
})

AddRoom("FrostIsland_icelake_cave", {
    colour = { r = 0.5, g = .18, b = .35, a = .50 },
    value = WORLD_TILES.ICELAND,
    tags = { "RoadPoison", "sandstorm" },
    contents = {
        distributepercent = .15,
        distributeprefabs = {
            rock_ice = 0.3,
            pond = 0.05,
            icerockspider = 0.5,
            icerockpigman = 0.1,
            icerockcrow = 0.5,
            cristaled_tree_short = 0.5,
            cristaled_tree_tall = 0.5,
            icerockcarrat = 0.3,
        },
        countprefabs =
        {
            icerockleif = 1,
            icerockleif2 = 1,
        }

    }
})

AddRoom("FrostIsland_icelake", {
    colour = { r = 0.5, g = .18, b = .35, a = .50 },
    value = WORLD_TILES.ICELAND,
    tags = { "RoadPoison", "sandstorm" },
    contents = {
        distributepercent = .15,
        distributeprefabs = {
            rock_ice = 0.3,
            pond = 0.05,
            icerockspider = 0.5,
            icerockpigman = 0.1,
            icerockcrow = 0.5,
            cristaled_tree_short = 0.5,
            cristaled_tree_tall = 0.5,
            icerockcarrat = 0.3,
        },
    }
})

AddRoom("rock_ice_frost_lake", {
    colour = { r = .6, g = .2, b = .8, a = .50 },
    value = WORLD_TILES.OCEAN_ROUGH,
    tags = { "RoadPoison", "ForceConnected" }, --"ForceDisconnected"
    type = NODE_TYPE.SeparatedRoom,
    contents =
    {
        distributepercent = 0.2,
        distributeprefabs =
        {
            rock_ice_frost_spawner = 1,
        },
    }
})
