local preenchimento = GetModConfigData("fillingthebiomes") * 0.5
AddRoom("BG_plains_base_nocanopy1", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = WORLD_TILES.PLAINS,
    tags = { "ExitPiece", "RoadPoison", "hamlet" },
    contents = {
        countstaticlayouts = {
            ["pig_ruins_nocanopy_2"] = 1,
            ["pig_ruins_nocanopy_3"] = 1,
            ["pugalisk_fountain"] = 1,
        },
        distributepercent = .125 * preenchimento, --.22, --.26
        distributeprefabs =
        {
            clawpalmtree = 0.5,
            grass_tall = 1,
            sapling = .3,
            flower = 0.05,
            dungpile = 0.03,
            peagawk = 0.01,
            --		randomrelic = 0.0016,
            --randomruin = 0.0025,	
            randomdust = 0.0025,
            rock_flippable = 0.08,
            aloe_planted = 0.08,
            pog = 0.01,
            asparagus_planted = 0.05,
        },
        countprefabs =
        {
            grass_tall_patch = 2,
            underwater_entrance2 = 1,
            gravestone = 2,
            sculpture_rook = 1,
        },
    }
})


fazendas =
{
    [1] = "farm_1",
    [2] = "farm_2",
    [3] = "farm_3",
    [4] = "farm_4",
    [5] = "farm_5",
}

AddRoom("cultivated_base_1", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = WORLD_TILES.FIELDS,
    tags = { "ExitPiece", "hamlet" },
    contents = {
        distributepercent = 0.03 * preenchimento, ---0.1
        distributeprefabs =
        {
            -- 			grass = 0.05,
            --			flower = 0.3,
            rock1 = 0.01,
            teatree = 0.1,
            --			peekhenspawner = 0.003,
        },
        countstaticlayouts = { [fazendas[math.random(1, 5)]] = 1, },
    }
})

AddRoom("cultivated_base_2", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = WORLD_TILES.FIELDS,
    tags = { "ExitPiece", "hamlet" },
    contents = {
        distributepercent = 0.03 * preenchimento, ---0.1
        distributeprefabs =
        {
            -- 			grass = 0.05,
            --			flower = 0.3,
            rock1 = 0.01,
            teatree = 0.1,
            --			peekhenspawner = 0.003,
        },
        countstaticlayouts = { [fazendas[math.random(1, 5)]] = 1, },

    }
})

AddRoom("BG_plains_inicio", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = WORLD_TILES.PLAINS,
    tags = { "ExitPiece", "Chester_Eyebone", "hamlet" },
    contents = {
        distributepercent = .25, --.22, --.26
        distributeprefabs =
        {
            clawpalmtree = .25,
            grass_tall = 1,
            flower = 0.05,
            pog = 0.1,
            randomdust = 0.0025,
            rock_flippable = 0.08,
            aloe_planted = 0.08,
            asparagus_planted = 0.05,
        },
    }
})
AddRoom("city_base", {
    colour = { r = .1, g = 0.1, b = 0.1, a = 0.3 },
    value = WORLD_TILES.SUBURB,
    tags = { "RoadPoison", "hamlet" },
    contents = {
        distributepercent = 0.3,
        distributeprefabs =
        {
            rocks = 0.2,
            grass = 0.2,
            spoiled_food = 0.2,
            twigs = 0.2,
        },
    }
})
AddRoom("BG_suburb_base", {
    colour = { r = .3, g = 0.3, b = 0.3, a = 0.3 },
    value = WORLD_TILES.SUBURB,
    tags = { "ExitPiece", "hamlet" },
    contents = {
        distributepercent = 0.3,
        distributeprefabs =
        {
            rocks = 1,
            grass = 1,
            spoiled_food = 1,
            twigs = 1,
        },
    }
})

AddRoom("BG_cultivated_base", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = WORLD_TILES.FIELDS,
    tags = { "ExitPiece", "hamlet" },
    contents = {
        distributepercent = 0.06, ---0.1
        distributeprefabs =
        {
            rock1 = 0.01,
            teatree = 0.1,
        },
    }
})
AddRoom("MAINcity_base_1_set", {
    colour = { r = .1, g = 0.1, b = 0.1, a = 0.3 },
    value = WORLD_TILES.SUBURB,
    tags = { "RoadPoison" },
    contents = {
        countstaticlayouts = {
            ["cidade1"] = 1,
        },
        distributepercent = 0.3,
        distributeprefabs =
        {
            rocks = 0.2,
            grass = 0.2,
            spoiled_food = 0.2,
            twigs = 0.2,
        },
    }
})

AddRoom("MAINcity_base_2_set", {
    colour = { r = .1, g = 0.1, b = 0.1, a = 0.3 },
    value = WORLD_TILES.SUBURB,
    tags = { "RoadPoison" },
    contents = {
        countstaticlayouts = {
            ["cidade2"] = 1,
        },
        distributepercent = 0.3,
        distributeprefabs =
        {
            rocks = 0.2,
            grass = 0.2,
            spoiled_food = 0.2,
            twigs = 0.2,
        },
    }
})

AddRoom("MAINcity_base", {
    colour = { r = .1, g = 0.1, b = 0.1, a = 0.3 },
    value = WORLD_TILES.SUBURB,
    tags = { "RoadPoison" },
    contents = {
        distributepercent = 0.3,
        distributeprefabs =
        {
            rocks = 0.2,
            grass = 0.2,
            spoiled_food = 0.2,
            twigs = 0.2,
        },
    }
})
AddRoom("MAINBG_suburb_base", {
    colour = { r = .3, g = 0.3, b = 0.3, a = 0.3 },
    value = WORLD_TILES.SUBURB,
    tags = { "RoadPoison" },
    contents = {
        distributepercent = 0.3,
        distributeprefabs =
        {
            rocks = 1,
            grass = 1,
            spoiled_food = 1,
            twigs = 1,
        },
    }
})
