-------------------------------------------------------Hamlet task exclusivas ilha inicial---------------------------------	

local tamanho = GetModConfigData("continentsize")

AddTask("Edge_of_the_unknown", {
    locks = LOCKS.NONE,
    keys_given = KEYS.JUNGLE_DEPTH_1,
    room_choices = {
        ["BG_plains_base"] = 1 + tamanho,
    },
    room_bg = GROUND.PLAINS,
    background_room = "BG_plains_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("painted_sands", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = KEYS.JUNGLE_DEPTH_1,
    room_choices = {
        ["BG_painted_base"] = 1 + tamanho,
        ["BG_battleground_base"] = math.random(0, 1),
        ["battleground_ribs"] = 1,
        ["battleground_claw"] = 1,
        ["battleground_leg"] = 1,
    },
    room_bg = GROUND.PLAINS,
    background_room = "BG_painted_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})
AddTask("plains", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = KEYS.JUNGLE_DEPTH_1,
    room_choices = {
        ["plains_tallgrass"] = 1 + tamanho,
        ["plains_pogs_ruin"] = 1,
    },
    room_bg = GROUND.PLAINS,
    background_room = "BG_plains_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})
AddTask("rainforests", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = KEYS.JUNGLE_DEPTH_1,
    room_choices = {
        ["BG_rainforest_base"] = 1 + tamanho,
    },
    room_bg = GROUND.PLAINS,
    background_room = "BG_rainforest_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 },
})
AddTask("rainforest_ruins", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = KEYS.JUNGLE_DEPTH_1,
    room_choices = {
        ["rainforest_ruins"] = 1 + tamanho,
        ["rainforest_ruins_entrance"] = 1,
    },
    room_bg = GROUND.PLAINS,
    background_room = "BG_rainforest_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})
AddTask("plains_ruins", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = KEYS.JUNGLE_DEPTH_1,
    room_choices = {
        ["plains_ruins"] = 1 + tamanho,
        ["plains_ruins_set"] = 1,
        ["plains_pogs"] = math.random(0, 1),
    },
    room_bg = GROUND.PLAINS,
    background_room = "BG_plains_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("Edge_of_civilization", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = KEYS.CIVILIZATION_1,
    room_choices = {
        ["cultivated_base_1"] = 2 + tamanho,
        ["piko_land"] = 1 + tamanho,
    },
    room_bg = GROUND.FIELDS,
    background_room = "BG_cultivated_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("Deep_rainforest", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = { KEYS.JUNGLE_DEPTH_2, KEYS.JUNGLE_DEPTH_3 },
    room_choices = {
        ["BG_rainforest_base"] = 1 + tamanho,
        ["BG_deeprainforest_base"] = 1,
        ["deeprainforest_spider_monkey_nest"] = 1 + tamanho,
        ["deeprainforest_fireflygrove"] = math.random(1, 1),
        ["deeprainforest_flytrap_grove"] = 1 + tamanho,
        ["deeprainforest_anthill_exit2"] = 1,
    },
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("Pigtopia", {
    locks = LOCKS.CIVILIZATION_1,
    keys_given = KEYS.CIVILIZATION_2,
    room_choices = {
        ["suburb_base_1"] = 1 + tamanho,
    },
    room_bg = GROUND.MOSS,
    background_room = "suburb_base_1",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})


AddTask("Pigtopia_capital", {
    locks = LOCKS.CIVILIZATION_2,
    keys_given = KEYS.ISLAND_2,
    room_choices = {
        ["city_base_1_set"] = 1,
        ["city_base_1_set2"] = 1,
        ["city_base_1"] = 1,
    },
    room_bg = GROUND.MOSS,
    background_room = "suburb_base_1",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("Deep_lost_ruins_gas", {
    locks = LOCKS.JUNGLE_DEPTH_3,
    keys_given = KEYS.JUNGLE_DEPTH_3,
    room_choices = {
        ["deeprainforest_gas"] = 1 + tamanho,
        ["deeprainforest_gas_set"] = 1,
        ["deeprainforest_gas_flytrap_grove"] = 1,
        ["deeprainforest_gas_flytrap_grove_set"] = 1,
    },
    room_bg = GROUND.GASRAINFOREST,
    background_room = "deeprainforest_gas",
    colour = { r = 0.8, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("Edge_of_the_unknown_2", {
    locks = LOCKS.CIVILIZATION_1,
    keys_given = KEYS.JUNGLE_DEPTH_1,
    room_choices = {
        ["BG_rainforest_base"] = 1 + tamanho,
        ["plains_tallgrass"] = 1 + tamanho,
        ["plains_pogs_ruin"] = 1,
        ["rainforest_ruins"] = 1 + tamanho,
        ["BG_painted_base"] = 1 + tamanho,

        ["battleground_head"] = 1,
        ["battleground_claw"] = 1,
        ["battleground_leg"] = 1,
    },
    room_bg = GROUND.PLAINS,
    background_room = "BG_plains_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("Lilypond_land", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = KEYS.JUNGLE_DEPTH_2,
    room_choices = {
        ["BG_rainforest_base"] = 1,
    },
    entrance_room = "rainforest_lillypond",
    room_bg = GROUND.RAINFOREST,
    background_room = "BG_rainforest_base",
    colour = { r = 1, g = 0.3, b = 0.3, a = 0.3 }
})

AddTask("Lilypond_land_2", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = KEYS.JUNGLE_DEPTH_2,
    room_choices = {
        ["BG_rainforest_base"] = 1,
    },
    entrance_room = "rainforest_lillypond",
    room_bg = GROUND.RAINFOREST,
    background_room = "BG_rainforest_base",
    colour = { r = 1, g = 0.3, b = 0.3, a = 0.3 }
})

AddTask("this_is_how_you_get_ants", {
    locks = LOCKS.JUNGLE_DEPTH_2,
    keys_given = { KEYS.JUNGLE_DEPTH_2, KEYS.JUNGLE_DEPTH_3 },
    room_choices = {
        ["deeprainforest_anthill"] = 1,
    },
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    colour = { r = 0, g = 0, b = 1, a = 0.3 }
})

AddTask("Deep_rainforest_2", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = { KEYS.JUNGLE_DEPTH_2, KEYS.JUNGLE_DEPTH_3 },
    room_choices = {
        ["BG_deeprainforest_base"] = 1 + tamanho,
        ["deeprainforest_spider_monkey_nest"] = 1 + tamanho,
        ["deeprainforest_fireflygrove"] = 1 + tamanho,
        ["deeprainforest_flytrap_grove"] = 1 + tamanho,
        ["deeprainforest_anthill_exit"] = 1,
        ["deeprainforest_ruins_entrance2"] = 1,
    },
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("Lost_Ruins_1", {
    locks = LOCKS.JUNGLE_DEPTH_3,
    keys_given = KEYS.NONE,
    room_choices = {
        ["deeprainforest_ruins_entrance"] = 1,
    },
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("Land_Divide_1", {
    locks = {
        LOCKS.ISLAND_2,
    },
    keys_given = KEYS.LAND_DIVIDE_1,
    level_set_piece_blocker = true,
    room_choices = {
        ["ForceDisconnectedRoom"] = 10,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

-- THE OTHER PIG CITY
AddTask("Deep_rainforest_3", {
    locks = LOCKS.LAND_DIVIDE_1,
    keys_given = { KEYS.OTHER_JUNGLE_DEPTH_2 },
    room_choices = {
        ["BG_deeprainforest_base"] = 1 + tamanho,
        ["deeprainforest_fireflygrove"] = 0 + tamanho,
        ["deeprainforest_flytrap_grove"] = 1 + tamanho,
        ["deeprainforest_ruins_exit"] = 1,
    },
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("Deep_rainforest_mandrake", {
    locks = LOCKS.OTHER_JUNGLE_DEPTH_2,
    keys_given = { KEYS.NONE },
    room_choices = {
        ["deeprainforest_mandrakeman"] = 1,
    },
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})


AddTask("Path_to_the_others", {
    locks = LOCKS.OTHER_JUNGLE_DEPTH_2,
    keys_given = KEYS.OTHER_JUNGLE_DEPTH_1,
    room_choices = {
        ["BG_plains_base"] = 1 + tamanho,
        ["plains_tallgrass"] = 1 + tamanho,
        ["plains_pogs"] = 1 + tamanho,
    },
    room_bg = GROUND.RAINFOREST,
    background_room = "BG_rainforest_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("Other_edge_of_civilization", {
    locks = LOCKS.OTHER_JUNGLE_DEPTH_1,
    keys_given = KEYS.OTHER_CIVILIZATION_1,
    room_choices = {
        ["cultivated_base_2"] = 1 + tamanho,
    },
    room_bg = GROUND.FIELDS,
    background_room = "BG_cultivated_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})


AddTask("Other_pigtopia", {
    locks = LOCKS.OTHER_CIVILIZATION_1,
    keys_given = KEYS.OTHER_CIVILIZATION_2,
    room_choices = {
        ["suburb_base_2"] = 1 + tamanho,
    },
    room_bg = GROUND.MOSS,
    background_room = "suburb_base_2",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("Other_pigtopia_capital", {
    locks = LOCKS.OTHER_CIVILIZATION_2,
    keys_given = KEYS.ISLAND_3,
    room_choices = {
        ["city_base_2_set"] = 1,
        ["city_base_2_set2"] = 1,
        ["city_base_2"] = 1,
    },
    room_bg = GROUND.FOUNDATION,
    background_room = "suburb_base_2",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("Land_Divide_2", {
    locks = LOCKS.ISLAND_3,
    keys_given = KEYS.LAND_DIVIDE_2,
    level_set_piece_blocker = true,
    room_choices = {
        ["ForceDisconnectedRoom"] = 10, --20,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

-- Other Jungle
AddTask("Deep_lost_ruins4", {
    locks = LOCKS.LAND_DIVIDE_2,
    keys_given = { KEYS.LOST_JUNGLE_DEPTH_2 },
    room_choices = {
        ["BG_deeprainforest_base"] = 1 + tamanho,
        ["deeprainforest_flytrap_grove"] = 1 + tamanho,
        ["deeprainforest_ruins_exit2"] = 1,
    },
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "BG_deeprainforest_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("lost_rainforest", {
    locks = LOCKS.LOST_JUNGLE_DEPTH_2,
    keys_given = { KEYS.ISLAND_4 },
    room_choices = {
        ["BG_plains_base_nocanopy"] = math.random(1),
        ["BG_plains_base_nocanopy1"] = 1,
        ["BG_plains_base_nocanopy2"] = math.random(0, 1),
        ["BG_plains_base_nocanopy3"] = math.random(0, 1),
    },

    entrance_room = "rainforest_lillypond",
    room_bg = GROUND.RAINFOREST,
    background_room = "BG_rainforest_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("Land_Divide_3", {
    locks = LOCKS.ISLAND_4,
    keys_given = KEYS.LAND_DIVIDE_3,
    level_set_piece_blocker = true,
    room_choices = {
        ["ForceDisconnectedRoom"] = 10,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})


AddTask("pincale", {
    locks = LOCKS.LAND_DIVIDE_3,
    keys_given = KEYS.PINACLE,
    room_choices = {
        ["BG_pinacle_base_set"] = 1,
    },
    room_bg = GROUND.ROCKY,
    background_room = "BG_pinacle_base",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("Land_Divide_4", {
    locks = LOCKS.PINACLE,
    keys_given = KEYS.LAND_DIVIDE_4,
    level_set_piece_blocker = true,
    room_choices = {
        ["ForceDisconnectedRoom"] = 10,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

-- Other Jungle
AddTask("Deep_wild_ruins4", {
    locks = LOCKS.LAND_DIVIDE_4,
    keys_given = { KEYS.WILD_JUNGLE_DEPTH_1 },
    room_choices = {
        ["deeprainforest_base_nobatcave"] = 1 + tamanho,
        ["deeprainforest_flytrap_grove"] = 1 + tamanho,
        ["deeprainforest_base_nobatcave_PigRuinsExit4"] = 1,
    },

    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "deeprainforest_base_nobatcave",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("wild_rainforest", {
    locks = LOCKS.WILD_JUNGLE_DEPTH_1,
    keys_given = { KEYS.WILD_JUNGLE_DEPTH_2 },
    room_choices = {
        ["plains_base_nobatcave"] = 2 + tamanho,
        ["painted_base_nobatcave"] = 2 + tamanho,
        ["rainforest_base_nobatcave"] = 2 + tamanho,
    },
    entrance_room = "rainforest_lillypond",
    room_bg = GROUND.RAINFOREST,
    background_room = "rainforest_base_nobatcave",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})
AddTask("wild_ancient_ruins", {
    locks = LOCKS.WILD_JUNGLE_DEPTH_2,
    keys_given = { KEYS.ISLAND_5 },
    room_choices = {
        ["deeprainforest_flytrap_grove"] = 2 + tamanho,
        ["deeprainforest_flytrap_grove_PigRuinsEntrance5"] = 1,
    },

    room_bg = GROUND.RAINFOREST,
    background_room = "rainforest_base_nobatcave",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("Land_Divide_5", {
    locks = LOCKS.ISLAND_5,
    keys_given = KEYS.LAND_DIVIDE_5,
    level_set_piece_blocker = true,
    room_choices = {
        ["ForceDisconnectedRoom"] = 20,
    },
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("interior_space", {
    locks = LOCKS.LAND_DIVIDE_5,
    keys_given = { KEYS.NONE },
    crosslink_factor = 1,
    make_loop = true,
    room_choices = {
        ["BG_interior_base"] = 20,
    },

    room_bg = GROUND.RAINFOREST,
    background_room = "BG_interior_base",
    colour = { r = 0.01, g = 0.01, b = 0.01, a = 0.3 }
})

----------------------------------------------------------- ROOM PORKLAND--------------------------------------------------------------------------------------------------
----------------------------------------------------------- battlegrounds room--------------------------------------------------------------------------------------------------

local preenchimento = GetModConfigData("fillingthebiomes") * 0.5

AddRoom("BG_battleground_base", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = GROUND.DIRT,
    tags = { "ExitPiece", "RoadPoison", "hamlet" },
    contents = {
        distributepercent = .11 * preenchimento, -- .22, --.26
        distributeprefabs =
        {
            rainforesttree = 0.1,
            flower = 0.7,
            meteor_impact = 0.5,
            charcoal = 0.5,
            rainforesttree_burnt = 1,

            radish_planted = 0.05,
            asparagus_planted = 0.05,
        },
        countprefabs =
        {
            vampirebatcave_potential = 1,
        },
    }
})

AddRoom("battleground_ribs", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = GROUND.DIRT,
    tags = { "ExitPiece", "RoadPoison", "hamlet" },
    contents = {
        distributepercent = .11 * preenchimento, -- .22, --.26
        distributeprefabs =
        {
            rainforesttree = 0.1,
            flower = 0.7,
            meteor_impact = 0.5,
            charcoal = 0.5,
            rainforesttree_burnt = 1,

            radish_planted = 0.05,
            asparagus_planted = 0.05,
        },
        countprefabs =
        {
            ancient_robot_ribs = 1,
            vampirebatcave_potential = 1,
        },
    }
})
AddRoom("battleground_claw", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = GROUND.DIRT,
    tags = { "ExitPiece", "RoadPoison", "hamlet" },
    contents = {
        distributepercent = .11 * preenchimento, -- .22, --.26
        distributeprefabs =
        {
            rainforesttree = 0.1,
            flower = 0.7,
            meteor_impact = 0.5,
            charcoal = 0.5,
            rainforesttree_burnt = 1,

            radish_planted = 0.05,
            asparagus_planted = 0.05,
        },
        countprefabs =
        {
            ancient_robot_claw = 1,
            vampirebatcave_potential = 1,
        },
    }
})
AddRoom("battleground_leg", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = GROUND.DIRT,
    tags = { "ExitPiece", "RoadPoison", "hamlet" },
    contents = {
        distributepercent = .11 * preenchimento, -- .22, --.26
        distributeprefabs =
        {
            rainforesttree = 0.1,
            flower = 0.7,
            meteor_impact = 0.5,
            charcoal = 0.5,
            rainforesttree_burnt = 1,

            radish_planted = 0.05,
            asparagus_planted = 0.05,
        },
        countprefabs =
        {
            ancient_robot_leg = 1,
            vampirebatcave_potential = 1,
        },
    }
})
AddRoom("battleground_head", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = GROUND.DIRT,
    tags = { "ExitPiece", "RoadPoison", "hamlet" },
    contents = {
        distributepercent = .11 * preenchimento, -- .22, --.26
        distributeprefabs =
        {
            rainforesttree = 0.1,
            flower = 0.7,
            meteor_impact = 0.5,
            charcoal = 0.5,
            rainforesttree_burnt = 1,

            radish_planted = 0.05,
            asparagus_planted = 0.05,
        },
        countprefabs =
        {
            ancient_robot_head = 1,
            vampirebatcave_potential = 1,
        },
    }
})

----------------------------------------------------------- deeprainforest room--------------------------------------------------------------------------------------------------
AddRoom("BG_deeprainforest_base", {
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 },
    value = GROUND.DEEPRAINFOREST,
    tags = { "ExitPiece", "RoadPoison", "hamlet", "folha", "Terrarium_Spawner", "StatueHarp_HedgeSpawner", "CharlieStage_Spawner" },
    contents = {

        countstaticlayouts = {
            ["pig_ruins_head"] = math.max(0, 2 - math.random(0, 15)),
            ["pig_ruins_artichoke"] = math.max(0, 2 - math.random(0, 15)),
        },

        distributepercent = 0.25 * preenchimento,
        distributeprefabs =
        {
            rainforesttree = 2, --4,
            tree_pillar = 0.5, --0.5,
            nettle = 0.12,
            flower_rainforest = 1,
            deep_jungle_fern_noise = 1,
            jungle_border_vine = 0.5,
            fireflies = 0.2,
            --										hanging_vine_patch = 0.1,
            randomrelic = 0.02,
            randomruin = 0.02,
            randomdust = 0.02,
            pig_ruins_torch = 0.02,
            --		pig_ruins_artichoke = 0.01,
            --		pig_ruins_head = 0.01,
            --										mean_flytrap = 0.05,
            rock_flippable = 0.1,
            radish_planted = 0.5,
        },

        countprefabs =
        {
            vampirebatcave_potential = 1
        },

    }
})

AddRoom("deeprainforest_spider_monkey_nest", {
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 },
    value = GROUND.DEEPRAINFOREST,
    tags = { "ExitPiece", "RoadPoison", "hamlet", "folha" },
    contents = {

        countstaticlayouts = {
            ["pig_ruins_head"] = math.max(0, 2 - math.random(0, 20)),
            ["pig_ruins_artichoke"] = math.max(0, 2 - math.random(0, 20)),
        },
        distributepercent = 0.125 * preenchimento, --.3
        distributeprefabs =
        {
            rainforesttree = 3, --4,
            tree_pillar = 1, --0.5,
            nettle = 0.12,
            flower_rainforest = 1,
            --										lightrays_jungle = 1.2,								
            deep_jungle_fern_noise = 1,
            jungle_border_vine = 0.5,
            randomrelic = 0.02,
            randomruin = 0.02,
            randomdust = 0.02,
            pig_ruins_torch = 0.02,
            --		pig_ruins_artichoke = 0.01,
            --		pig_ruins_head = 0.01,
            rock_flippable = 0.1,
            radish_planted = 0.5,
        },
        countprefabs =
        {
            spider_monkey = math.random(1, 2),
            --					                	hanging_vine_patch = math.random(0,2)
        },
    }
})
AddRoom("deeprainforest_flytrap_grove", {
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 },
    value = GROUND.DEEPRAINFOREST,
    tags = { "ExitPiece", "RoadPoison", "hamlet", "folha" },
    contents = {
        countstaticlayouts = {
            ["pig_ruins_head"] = math.max(0, 2 - math.random(0, 20)),
            ["pig_ruins_artichoke"] = math.max(0, 2 - math.random(0, 20)),
            ["nettlegrove"] = function()
                if math.random(1, 10) > 7 then return 1 end
                return 0
            end,
        },

        distributepercent = 0.125 * preenchimento, --.3
        distributeprefabs =
        {
            rainforesttree = 4,
            tree_pillar = 1, --0.5,
            nettle = 0.12,
            flower_rainforest = 1,
            --										lightrays_jungle = 1.2,								
            deep_jungle_fern_noise = 1,
            jungle_border_vine = 0.5,
            fireflies = 0.2,
            randomrelic = 0.02,
            randomruin = 0.02,
            randomdust = 0.02,
            pig_ruins_torch = 0.02,
            --			pig_ruins_artichoke = 0.01,
            --			pig_ruins_head = 0.01,
            rock_flippable = 0.1,
            radish_planted = 0.5,
        },
        countprefabs =
        {
            --					                	mean_flytrap = math.random(10, 15),
            --					                	adult_flytrap = math.random(3, 7),
            --					                	hanging_vine_patch = math.random(0,2)
        },
    }
})

AddRoom("deeprainforest_flytrap_grove_PigRuinsEntrance5", {
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 },
    value = GROUND.DEEPRAINFOREST,
    tags = { "ExitPiece", "RoadPoison", "hamlet", "folha" },
    contents = {
        countstaticlayouts = {
            ["pig_ruins_head"] = math.max(0, 2 - math.random(0, 20)),
            ["pig_ruins_artichoke"] = math.max(0, 2 - math.random(0, 20)),
            ["pig_ruins_entrance_5"] = 1,
        },

        distributepercent = 0.125 * preenchimento, --.3
        distributeprefabs =
        {
            rainforesttree = 4,
            tree_pillar = 1, --0.5,
            nettle = 0.12,
            flower_rainforest = 1,
            --										lightrays_jungle = 1.2,								
            deep_jungle_fern_noise = 1,
            jungle_border_vine = 0.5,
            fireflies = 0.2,
            randomrelic = 0.02,
            randomruin = 0.02,
            randomdust = 0.02,
            pig_ruins_torch = 0.02,
            --			pig_ruins_artichoke = 0.01,
            --			pig_ruins_head = 0.01,
            rock_flippable = 0.1,
            radish_planted = 0.5,
        },
        countprefabs =
        {
            --					                	mean_flytrap = math.random(10, 15),
            --					                	adult_flytrap = math.random(3, 7),
            --					                	hanging_vine_patch = math.random(0,2)
        },
    }
})

AddRoom("deeprainforest_fireflygrove", {
    colour = { r = 1, g = 1, b = 0.2, a = 0.3 },
    value = GROUND.DEEPRAINFOREST,
    tags = { "ExitPiece", "RoadPoison", "hamlet", "folha" },
    contents = {

        countstaticlayouts = {
            ["pig_ruins_head"] = math.max(0, 2 - math.random(0, 20)),
            ["pig_ruins_artichoke"] = math.max(0, 2 - math.random(0, 20)),
        },
        distributepercent = 0.125 * preenchimento, --0.25, --.3
        distributeprefabs =
        {
            rainforesttree = 4,
            tree_pillar = 1, --0.5,
            nettle = 0.12,
            flower_rainforest = 1,
            --										lightrays_jungle = 1.2,								
            deep_jungle_fern_noise = 1,
            jungle_border_vine = 0.5,
            fireflies = 5,
            --										hanging_vine_patch = 0.1,
            randomrelic = 0.02,
            randomruin = 0.02,
            randomdust = 0.02,
            pig_ruins_torch = 0.02,
            --		pig_ruins_artichoke = 0.01,
            --		pig_ruins_head = 0.01,
            rock_flippable = 0.1,
            radish_planted = 0.5,
        },
        countprefabs =
        {
            fireflies = math.random(5, 10)
        },
    }
})


AddRoom("deeprainforest_gas", {
    colour = { r = 1, g = 0.6, b = 0.2, a = 0.3 },
    value = GROUND.GASRAINFOREST,
    tags = { "ExitPiece", "RoadPoison", "hamlet", "folha" },
    contents = {
        distributepercent = 0.225 * preenchimento, --.45
        distributeprefabs =
        {
            rainforesttree_rot = 4,
            tree_pillar = 0.5,
            nettle = 0.12,
            red_mushroom = 0.3,
            green_mushroom = 0.3,
            blue_mushroom = 0.3,
            --	berrybush = 1,
            --										lightrays_jungle = 1.2,
            poisonmist = 8,
            randomrelic = 0.02,
            randomruin = 0.02,
            randomdust = 0.02,
            rock_flippable = 0.05,
            jungle_border_vine = 0.5,
        },
    }
})

AddRoom("deeprainforest_gas_set", {
    colour = { r = 1, g = 0.6, b = 0.2, a = 0.3 },
    value = GROUND.GASRAINFOREST,
    tags = { "ExitPiece", "RoadPoison", "hamlet", "folha" },
    contents = {
        countstaticlayouts = {
            ["pig_ruins_entrance_4"] = 1 },
        distributepercent = 0.225 * preenchimento, --.45
        distributeprefabs =
        {
            rainforesttree_rot = 4,
            tree_pillar = 0.5,
            nettle = 0.12,
            red_mushroom = 0.3,
            green_mushroom = 0.3,
            blue_mushroom = 0.3,
            --	berrybush = 1,
            --										lightrays_jungle = 1.2,
            poisonmist = 8,
            randomrelic = 0.02,
            randomruin = 0.02,
            randomdust = 0.02,
            rock_flippable = 0.05,
            jungle_border_vine = 0.5,
        },
    }
})

AddRoom("deeprainforest_gas_flytrap_grove", {
    colour = { r = 1, g = 0.6, b = 0.2, a = 0.3 },
    value = GROUND.GASRAINFOREST,
    tags = { "ExitPiece", "RoadPoison", "hamlet", "folha" },
    contents = {
        countstaticlayouts = {
            ["pig_ruins_head"] = 1,
            ["pig_ruins_artichoke"] = 1,
        },
        distributepercent = 0.25 * preenchimento, --.45
        distributeprefabs =
        {
            rainforesttree_rot = 2,
            tree_pillar = 0.5,
            nettle = 0.12,
            red_mushroom = 0.3,
            green_mushroom = 0.3,
            blue_mushroom = 0.3,
            --	berrybush = 1,
            --										lightrays_jungle = 1.2,
            --mistarea = 6,	
            randomrelic = 0.02,
            randomruin = 0.02,
            randomdust = 0.02,
            poisonmist = 8,
            rock_flippable = 0.05,
            jungle_border_vine = 0.5,
        },
        countprefabs =
        {
            --					                	mean_flytrap = math.random(10, 15),
            --					                	adult_flytrap = math.random(3, 7),
        },
    }
})

AddRoom("deeprainforest_gas_flytrap_grove_set", {
    colour = { r = 1, g = 0.6, b = 0.2, a = 0.3 },
    value = GROUND.GASRAINFOREST,
    tags = { "ExitPiece", "RoadPoison", "hamlet", "folha" },
    contents = {
        countstaticlayouts = {
            ["pig_ruins_entrance_3"] = 1 },
        distributepercent = 0.25 * preenchimento, --.45
        distributeprefabs =
        {
            rainforesttree_rot = 2,
            tree_pillar = 0.5,
            nettle = 0.12,
            red_mushroom = 0.3,
            green_mushroom = 0.3,
            blue_mushroom = 0.3,
            --	berrybush = 1,
            --										lightrays_jungle = 1.2,
            --mistarea = 6,	
            randomrelic = 0.02,
            randomruin = 0.02,
            randomdust = 0.02,
            poisonmist = 8,
            rock_flippable = 0.05,
            jungle_border_vine = 0.5,
        },
        countprefabs =
        {
            --					                	mean_flytrap = math.random(10, 15),
            --					                	adult_flytrap = math.random(3, 7),
        },
    }
})


AddRoom("deeprainforest_ruins_entrance", {
    colour = { r = 1, g = 0.1, b = 0.2, a = 0.5 },
    value = GROUND.DEEPRAINFOREST,
    tags = { "ExitPiece", "RoadPoison", "hamlet", "folha" },
    contents = {
        countstaticlayouts = { ["pig_ruins_entrance_1"] = 1 },
        distributepercent = 0.125 * preenchimento, --.3
        distributeprefabs =
        {
            rainforesttree = 4,
            tree_pillar = 1,
            nettle = 0.12,
            flower_rainforest = 1,
            --										lightrays_jungle = 1.2,								
            deep_jungle_fern_noise = 1,
            jungle_border_vine = 0.5,
            fireflies = 0.2,
            randomrelic = 0.02,
            randomruin = 0.02,
            randomdust = 0.02,
            pig_ruins_torch = 0.02,
            rock_flippable = 0.1,
            radish_planted = 0.5,
        },
        countprefabs =
        {
            -- 	pig_ruins_torch = 3,
            -- 	pig_ruins_entrance = 1,
            -- 	pig_ruins_artichoke = 1,
        },

    }
})

AddRoom("deeprainforest_ruins_entrance2", {
    colour = { r = 1, g = 0.1, b = 0.2, a = 0.5 },
    value = GROUND.DEEPRAINFOREST,
    tags = { "ExitPiece", "RoadPoison", "hamlet", "folha" },
    contents = {
        countstaticlayouts = { ["pig_ruins_entrance_2"] = 1 },
        distributepercent = 0.125 * preenchimento, --.3
        distributeprefabs =
        {
            rainforesttree = 4,
            tree_pillar = 1,
            nettle = 0.12,
            flower_rainforest = 1,
            --										lightrays_jungle = 1.2,								
            deep_jungle_fern_noise = 1,
            jungle_border_vine = 0.5,
            fireflies = 0.2,
            randomrelic = 0.02,
            randomruin = 0.02,
            randomdust = 0.02,
            pig_ruins_torch = 0.02,
            rock_flippable = 0.1,
            radish_planted = 0.5,
        },
        countprefabs =
        {
            -- 	pig_ruins_torch = 3,
            -- 	pig_ruins_entrance = 1,
            -- 	pig_ruins_artichoke = 1,
        },

    }
})

AddRoom("deeprainforest_ruins_exit", {
    colour = { r = 0.2, g = 0.1, b = 1, a = 0.5 },
    value = GROUND.DEEPRAINFOREST,
    tags = { "ExitPiece", "RoadPoison", "hamlet", "folha" },
    contents = {
        countstaticlayouts = { ["pig_ruins_exit_1"] = 1 },
        distributepercent = 0.125 * preenchimento, --.3
        distributeprefabs =
        {
            rainforesttree = 4,
            tree_pillar = 1,
            nettle = 0.12,
            flower_rainforest = 1,
            --										lightrays_jungle = 1.2,								
            deep_jungle_fern_noise = 1,
            jungle_border_vine = 0.5,
            fireflies = 0.2,
            randomrelic = 0.02,
            randomruin = 0.02,
            randomdust = 0.02,
            pig_ruins_torch = 0.02,
            rock_flippable = 0.1,
            radish_planted = 0.5,
        },
        countprefabs =
        {
            -- 	pig_ruins_torch = 3,
            -- 	pig_ruins_exit = 1,
            -- 	pig_ruins_head = 1,					                	
        },

    }
})

AddRoom("deeprainforest_ruins_exit2", {
    colour = { r = 0.2, g = 0.1, b = 1, a = 0.5 },
    value = GROUND.DEEPRAINFOREST,
    tags = { "ExitPiece", "RoadPoison", "hamlet", "folha" },
    contents = {
        countstaticlayouts = { ["pig_ruins_exit_2"] = 1, ["nettlegrove"] = 1, },
        distributepercent = 0.125 * preenchimento, --.3
        distributeprefabs =
        {
            rainforesttree = 4,
            tree_pillar = 1,
            nettle = 0.12,
            flower_rainforest = 1,
            --										lightrays_jungle = 1.2,								
            deep_jungle_fern_noise = 1,
            jungle_border_vine = 0.5,
            fireflies = 0.2,
            randomrelic = 0.02,
            randomruin = 0.02,
            randomdust = 0.02,
            pig_ruins_torch = 0.02,
            rock_flippable = 0.1,
            radish_planted = 0.5,
        },
        countprefabs =
        {
            -- 	pig_ruins_torch = 3,
            -- 	pig_ruins_exit = 1,
            -- 	pig_ruins_head = 1,					                	
        },

    }
})

AddRoom("deeprainforest_anthill", {
    colour = { r = 1, g = 0, b = 1, a = 0.3 },
    value = GROUND.DEEPRAINFOREST,
    tags = { "ExitPiece", "RoadPoison", "hamlet", "folha" },
    contents = {
        distributepercent = 0.125 * preenchimento, --.3
        distributeprefabs =
        {
            rainforesttree = 4,
            tree_pillar = 1,
            nettle = 0.12,
            flower_rainforest = 1,
            --										lightrays_jungle = 1.2,								
            deep_jungle_fern_noise = 1,
            jungle_border_vine = 0.5,
            fireflies = 0.2,
            pig_ruins_torch = 0.02,
            rock_flippable = 0.1,
            radish_planted = 0.5,
            randomrelic = 0.02,
            randomruin = 0.02,
            randomdust = 0.02,
        },

        countprefabs =
        {
            maze_anthill = 1,
            pighead = 4,
        },

    }
})
AddRoom("deeprainforest_mandrakeman", {
    colour = { r = 1, g = 0, b = 1, a = 0.3 },
    value = GROUND.DEEPRAINFOREST,
    tags = { "ExitPiece", "RoadPoison", "hamlet", "folha" },
    contents = {
        countstaticlayouts = { ["mandraketown"] = 1 },
        distributepercent = 0.125 * preenchimento, --.3
        distributeprefabs =
        {
            rainforesttree = 4,
            tree_pillar = 1,
            nettle = 0.12,
            flower_rainforest = 1,
            --										lightrays_jungle = 1.2,								
            deep_jungle_fern_noise = 1,
            jungle_border_vine = 0.5,
            fireflies = 0.2,
            pig_ruins_torch = 0.02,
            rock_flippable = 0.1,
            radish_planted = 0.5,
            randomrelic = 0.02,
            randomruin = 0.02,
            randomdust = 0.02,
        },

        countprefabs =
        {
            mandrakehouse = 2
        },

    }
})
AddRoom("deeprainforest_anthill_exit", {
    colour = { r = 1, g = 0, b = 1, a = 0.3 },
    value = GROUND.DEEPRAINFOREST,
    tags = { "ExitPiece", "hamlet", "folha" },
    contents = {
        distributepercent = 0.125 * preenchimento, --.3
        distributeprefabs =
        {
            rainforesttree = 4,
            tree_pillar = 1,
            nettle = 0.12,
            flower_rainforest = 1,
            --										lightrays_jungle = 1.2,								
            deep_jungle_fern_noise = 1,
            jungle_border_vine = 0.5,
            fireflies = 0.2,
            pig_ruins_torch = 0.02,
            rock_flippable = 0.1,
            radish_planted = 0.5,
            randomrelic = 0.02,
            randomruin = 0.02,
            randomdust = 0.02,
        },

        countprefabs =
        {
            anthill_exit_1 = 1,
        },

    }
})

AddRoom("deeprainforest_anthill_exit2", {
    colour = { r = 1, g = 0, b = 1, a = 0.3 },
    value = GROUND.DEEPRAINFOREST,
    tags = { "ExitPiece", "hamlet", "folha" },
    contents = {
        distributepercent = 0.125 * preenchimento, --.3
        distributeprefabs =
        {
            rainforesttree = 4,
            tree_pillar = 1,
            nettle = 0.12,
            flower_rainforest = 1,
            --										lightrays_jungle = 1.2,								
            deep_jungle_fern_noise = 1,
            jungle_border_vine = 0.5,
            fireflies = 0.2,
            pig_ruins_torch = 0.02,
            rock_flippable = 0.1,
            radish_planted = 0.5,
            randomrelic = 0.02,
            randomruin = 0.02,
            randomdust = 0.02,
        },

        countprefabs =
        {
            anthill_exit_2 = 1,
        },

    }
})
----------------------------------------------------------- painted room--------------------------------------------------------------------------------------------------
AddRoom("BG_painted_base", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = GROUND.PAINTED,
    tags = { "ExitPiece", "RoadPoison", "hamlet" },
    contents = {
        distributepercent = .075 * preenchimento, --.26
        distributeprefabs =
        {
            tubertree = 1,
            gnatmound = 0.1,
            rocks = 0.1,
            nitre = 0.1,
            flint = 0.05,
            iron = 0.2,
            thunderbirdnest = 0.1,
            sedimentpuddle = 0.1,
            pangolden = 0.005,
        },
        countprefabs =
        {
            pangolden = 1,
            vampirebatcave_potential = 1,
        },
    }
})
----------------------------------------------------------- rainflorest room--------------------------------------------------------------------------------------------------
AddRoom("BG_rainforest_base", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = GROUND.RAINFOREST,
    tags = { "ExitPiece", "RoadPoison", "hamlet", "folha", "StagehandGarden", "Terrarium_Spawner", "StatueHarp_HedgeSpawner", "CharlieStage_Spawner" },
    contents = {
        distributepercent = .19 * preenchimento, --.5
        distributeprefabs =
        {
            rainforesttree = 0.6, --1.4,
            grass_tall = .5,
            sapling = .6,
            flower_rainforest = 0.1,
            flower = 0.05,
            dungpile = 0.03,
            fireflies = 0.05,
            peagawk = 0.01,
            --	randomrelic = 0.008,
            --	randomruin = 0.005,	
            randomdust = 0.005,
            rock_flippable = 0.08,
            radish_planted = 0.05,
            asparagus_planted = 0.05,
        },
        countprefabs =
        {
            vampirebatcave_potential = 1,
        },
    }
})

AddRoom("rainforest_ruins", {
    colour = { r = 0.0, g = 1, b = 0.3, a = 0.3 },
    value = GROUND.RAINFOREST,
    tags = { "ExitPiece", "RoadPoison", "hamlet", "folha" },
    contents = {
        distributepercent = 0.175 * preenchimento, -- .5
        distributeprefabs =
        {
            rainforesttree = .5, --.7,
            grass_tall = 0.5,
            sapling = .6,
            flower_rainforest = 0.1,
            flower = 0.05,
            --	randomrelic = 0.008,
            --	randomruin = 0.005,	
            randomdust = 0.005,
            rock_flippable = 0.08,
            radish_planted = 0.05,
            asparagus_planted = 0.05,
        },
        countprefabs =
        {
            vampirebatcave_potential = 1,
        },
    }
})

AddRoom("rainforest_ruins_entrance", {
    colour = { r = 0.0, g = 1, b = 0.3, a = 0.3 },
    value = GROUND.RAINFOREST,
    tags = { "ExitPiece", "RoadPoison", "hamlet", "folha" },
    contents = {
        distributepercent = .175 * preenchimento, -- .5
        distributeprefabs =
        {
            rainforesttree = .5, --.7,
            grass_tall = 0.5,
            sapling = .6,
            flower_rainforest = 0.1,
            flower = 0.05,
            --	randomrelic = 0.008,
            --	randomruin = 0.005,	
            randomdust = 0.005,
            rock_flippable = 0.08,
            radish_planted = 0.05,
            asparagus_planted = 0.05,
        },
        countprefabs =
        {
            maze_pig_ruins_entrance6 = 1,
            vampirebatcave_entrance_roc = 1,
        },
    }
})


AddRoom("rainforest_lillypond", {
    colour = { r = 1.0, g = 0.3, b = 0.3, a = 0.3 },
    value = GROUND.RAINFOREST,
    tags = { "ExitPiece", "RoadPoison", "hamlet", "folha" },
    contents = {
        countstaticlayouts = {
            ["lilypad"] = 1, --math.random(4,8),										
        },

        distributepercent = .25 * preenchimento, -- .3				

        distributeprefabs =
        {
            reeds_water = 3,
            lotus = 2,
            hippopotamoose = 0.08,
            relic_1 = 0.04,
            relic_2 = 0.04,
            relic_3 = 0.04,
        },
        countprefabs =
        {
            hippopotamoose = 1,
        },
    }
})

AddRoom("rainforest_pugalisk", {
    colour = { r = 0.0, g = 1, b = 0.3, a = 0.3 },
    value = GROUND.RAINFOREST,
    tags = { "ExitPiece", "RoadPoison", "hamlet", "folha" },
    contents = {
        distributepercent = .075 * preenchimento, -- .3
        distributeprefabs =
        {
            rainforesttree = .7,
            grass_tall = 0.5,
            sapling = .6,
            flower_rainforest = 0.1,
            flower = 0.05,
            --	randomrelic = 0.008,
            --	randomruin = 0.005,	
            randomdust = 0.005,
            rock_flippable = 0.08,
            radish_planted = 0.05,
            asparagus_planted = 0.05,
        },
        countprefabs =
        {
            pugalisk = 1
        },
    }
})
----------------------------------------------------------- pinacle room--------------------------------------------------------------------------------------------------
AddRoom("BG_pinacle_base_set", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = GROUND.ROCKY,
    tags = { "hamlet" },
    contents = {
        countstaticlayouts = {
            ["roc_nest"] = 1,
            ["roc_cave"] = 1,
        },
        distributepercent = .05 * preenchimento, --.26
        distributeprefabs =
        {
            rock1 = 0.1,
            flint = 0.1,
            roc_nest_tree1 = 0.1,
            roc_nest_tree2 = 0.1,
            roc_nest_branch1 = 0.5,
            roc_nest_branch2 = 0.5,
            roc_nest_bush = 1,
            rocks = 0.5,
            twigs = 1,

        },
        countprefabs =
        {
            flint = 2,
            twigs = 2,
            pig_scepter = 1,
        },
    }
})

AddRoom("BG_pinacle_base", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = GROUND.ROCKY,
    tags = { "hamlet" },
    contents = {
        distributepercent = .05 * preenchimento, --.26
        distributeprefabs =
        {
            rock1 = 0.1,
            flint = 0.1,
            roc_nest_tree1 = 0.1,
            roc_nest_tree2 = 0.1,
            roc_nest_branch1 = 0.5,
            roc_nest_branch2 = 0.5,
            roc_nest_bush = 1,
            rocks = 0.5,
            twigs = 1,

        },
        countprefabs =
        {
            flint = 2,
            twigs = 2,
        },
    }
})
----------------------------------------------------------- plain room--------------------------------------------------------------------------------------------------
AddRoom("BG_plains_base", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = GROUND.PLAINS,
    tags = { "ExitPiece", "RoadPoison", "hamlet" },
    contents = {
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
            vampirebatcave_potential = 1,
        },
    }
})

AddRoom("BG_plains_base_nocanopy", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = GROUND.PLAINS,
    tags = { "ExitPiece", "RoadPoison", "hamlet" },
    contents = {
        countstaticlayouts = {
            ["pig_ruins_nocanopy"] = 1,
            ["pig_ruins_nocanopy_2"] = 1,
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
            vampirebatcave_potential = 1,
        },
    }
})

AddRoom("BG_plains_base_nocanopy1", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = GROUND.PLAINS,
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
            vampirebatcave_potential = 1,
            underwater_entrance2 = 1,
            vidanomar = 1,
            gravestone = 2,
            sculpture_rook = 1,
        },
    }
})

AddRoom("BG_plains_base_nocanopy2", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = GROUND.PLAINS,
    tags = { "ExitPiece", "RoadPoison", "hamlet" },
    contents = {
        countstaticlayouts = {
            ["pig_ruins_nocanopy_3"] = 1,
            ["pig_ruins_nocanopy_4"] = 1,
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
            vampirebatcave_potential = 1,
        },
    }
})

AddRoom("BG_plains_base_nocanopy3", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = GROUND.PLAINS,
    tags = { "ExitPiece", "RoadPoison", "hamlet" },
    contents = {
        countstaticlayouts = {
            ["pig_ruins_nocanopy_4"] = 1,
            ["pig_ruins_nocanopy"] = 1,
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
            vampirebatcave_potential = 1,
        },
    }
})

AddRoom("plains_tallgrass", {
    colour = { r = 0.0, g = 1, b = 0.3, a = 0.3 },
    value = GROUND.PLAINS,
    tags = { "ExitPiece", "RoadPoison", "hamlet" },
    contents = {
        distributepercent = .075 * preenchimento, -- .15, -- .3
        distributeprefabs =
        {
            clawpalmtree = .25,
            grass_tall = 1,
            flower = 0.05,
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
            vampirebatcave_potential = 1,
        },
    }
})

AddRoom("plains_ruins", {
    colour = { r = 0.0, g = 1, b = 0.3, a = 0.3 },
    value = GROUND.PLAINS,
    tags = { "ExitPiece", "RoadPoison", "hamlet" },
    contents = {
        distributepercent = .125 * preenchimento, -- .15, -- .3
        distributeprefabs =
        {
            clawpalmtree = .25,
            grass_tall = 1,
            flower = 0.05,
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
            vampirebatcave_potential = 1,
        },
    }
})

AddRoom("plains_ruins_set", {
    colour = { r = 0.0, g = 1, b = 0.3, a = 0.3 },
    value = GROUND.PLAINS,
    tags = { "ExitPiece", "RoadPoison", "hamlet" },
    contents = {
        distributepercent = .125 * preenchimento, -- .15, -- .3
        distributeprefabs =
        {
            clawpalmtree = .25,
            grass_tall = 1,
            flower = 0.05,
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
            maze_pig_ruins_entrance_small = 1,
            vampirebatcave_potential = 1,
        },
    }
})

AddRoom("plains_pogs", {
    colour = { r = 0.0, g = 1, b = 0.3, a = 0.3 },
    value = GROUND.PLAINS,
    tags = { "ExitPiece", "RoadPoison", "hamlet" },
    contents = {
        distributepercent = .125 * preenchimento, -- .15, -- .3
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
        countprefabs =
        {
            pog = 2,
            vampirebatcave_potential = 1,
        },
    }
})

AddRoom("plains_pogs_ruin", {
    colour = { r = 0.0, g = 1, b = 0.3, a = 0.3 },
    value = GROUND.PLAINS,
    tags = { "ExitPiece", "RoadPoison", "hamlet" },
    contents = {
        distributepercent = .125 * preenchimento, -- .15, -- .3
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
        countprefabs =
        {
            pog = 2,
            maze_pig_ruins_entrance_small = 1,
            vampirebatcave_potential = 1,
        },
    }
})

-------------------------------------------------------------city room------------------------------------------------------------------------------------
AddRoom("BG_city_base", {
    colour = { r = .1, g = 0.1, b = 0.1, a = 0.3 },
    value = GROUND.MOSS,
    tags = { "ExitPiece", "hamlet" },
    contents = {
        distributepercent = 0.05 * preenchimento,
        distributeprefabs =
        {
            rocks = 1,
            grass = 1,
            spoiled_food = 1,
            twigs = 1,
        },
    }
})


AddRoom("city_base_1", {
    colour = { r = .1, g = 0.1, b = 0.1, a = 0.3 },
    value = GROUND.MOSS,
    tags = { "ExitPiece", "hamlet" },
    contents = {
        distributepercent = 0.05 * preenchimento,
        distributeprefabs =
        {
            rocks = 1,
            grass = 1,
            spoiled_food = 1,
            twigs = 1,
        },
    }
})

AddRoom("city_base_1_set", {
    colour = { r = .1, g = 0.1, b = 0.1, a = 0.3 },
    value = GROUND.MOSS,
    tags = { "ExitPiece", "hamlet" },
    contents = {
        countstaticlayouts = {
            ["cidade1"] = 1,
        },
        distributepercent = 0.05 * preenchimento,
        distributeprefabs =
        {
            rocks = 1,
            grass = 1,
            spoiled_food = 1,
            twigs = 1,
        },
    }
})

AddRoom("city_base_1_set2", {
    colour = { r = .1, g = 0.1, b = 0.1, a = 0.3 },
    value = GROUND.MOSS,
    tags = { "ExitPiece", "hamlet" },
    contents = {
        distributepercent = 0.05 * preenchimento,
        distributeprefabs =
        {
            rocks = 1,
            grass = 1,
            spoiled_food = 1,
            twigs = 1,
        },
    }
})

AddRoom("city_base_2", {
    colour = { r = .1, g = 0.1, b = 0.1, a = 0.3 },
    value = GROUND.FOUNDATION,
    tags = { "ExitPiece", "hamlet" },
    contents = {
        distributepercent = 0.05 * preenchimento,
        distributeprefabs =
        {
            rocks = 1,
            grass = 1,
            spoiled_food = 1,
            twigs = 1,
        },
    }
})

AddRoom("city_base_2_set", {
    colour = { r = .1, g = 0.1, b = 0.1, a = 0.3 },
    value = GROUND.FOUNDATION,
    tags = { "ExitPiece", "hamlet" },
    contents = {

        countstaticlayouts = {
            ["cidade2"] = 1,
        },


        distributepercent = 0.05 * preenchimento,
        distributeprefabs =
        {
            rocks = 1,
            grass = 1,
            spoiled_food = 1,
            twigs = 1,
        },
    }
})

AddRoom("city_base_2_set2", {
    colour = { r = .1, g = 0.1, b = 0.1, a = 0.3 },
    value = GROUND.FOUNDATION,
    tags = { "ExitPiece", "hamlet" },
    contents = {

        --        countstaticlayouts={
        --        ["pig_mainstreet"]= 1,
        --		   },				


        distributepercent = 0.05 * preenchimento,
        distributeprefabs =
        {
            rocks = 1,
            grass = 1,
            spoiled_food = 1,
            twigs = 1,
        },
    }
})
--------------------------------------------------cultivated room--------------------------------------------------------------------------------------------------------------------
fazendas =
{
    [1] = "farm_1",
    [2] = "farm_2",
    [3] = "farm_3",
    [4] = "farm_4",
    [5] = "farm_5",
}

AddRoom("BG_cultivated_base", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = GROUND.FIELDS,
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
        --[[        countstaticlayouts={
        ["farm_1"]=function()
        		return math.random(1,2)			
		   end,
		["farm_2"]=function()
        		return math.random(0,2)			
		   end,
		["farm_3"]=function()
        		return math.random(0,1)			
		   end
		   },
		]]
    }
})


AddRoom("cultivated_base_1", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = GROUND.FIELDS,
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
    value = GROUND.FIELDS,
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

AddRoom("piko_land", {
    colour = { r = 1.0, g = 0.0, b = 1.0, a = 0.3 },
    value = GROUND.FIELDS,
    tags = { "ExitPiece", "hamlet" },
    contents = {
        distributepercent = 0.03 * preenchimento, --0.1
        distributeprefabs =
        {
            --	grass = 0.05,
            --	flower = 0.3,
            rock1 = 0.01,
            teatree = 2.0,
        },
        countprefabs =
        {
            teatree_piko_nest_patch = 1
        },
    }

})

-----------------------------------------------------suburb room-----------------------------------------
AddRoom("BG_suburb_base", {
    colour = { r = .3, g = 0.3, b = 0.3, a = 0.3 },
    value = GROUND.MOSS,
    tags = { "ExitPiece", "hamlet" },
    contents = {
        distributepercent = 0.05 * preenchimento,
        distributeprefabs =
        {
            rocks = 1,
            grass = 1,
            spoiled_food = 1,
            twigs = 1,
        },
    }
})

AddRoom("suburb_base_1", {
    colour = { r = .3, g = 0.3, b = 0.3, a = 0.3 },
    value = GROUND.MOSS,
    tags = { "ExitPiece", "hamlet" },
    contents = {
        distributepercent = 0.05 * preenchimento,
        distributeprefabs =
        {
            rocks = 1,
            grass = 1,
            spoiled_food = 1,
            twigs = 1,
        },
    }
})

AddRoom("suburb_base_2", {
    colour = { r = .3, g = 0.3, b = 0.3, a = 0.3 },
    value = GROUND.MOSS,
    tags = { "ExitPiece", "hamlet" },
    contents = {
        distributepercent = 0.05 * preenchimento,
        distributeprefabs =
        {
            rocks = 1,
            grass = 1,
            spoiled_food = 1,
            twigs = 1,
        },
    }
})

--------------------------interior-----------------------------------		
AddRoom("BG_interior_base", {
    colour = { r = .01, g = 0.01, b = 0.01, a = 0.3 },
    value = GROUND.INTERIOR,
    tags = { "hamlet" },
    contents = {
        distributepercent = 0.0,
        distributeprefabs =
        {

        },
    }

})

---------------------------------island 5--------------------------------------
AddRoom("deeprainforest_base_nobatcave", {
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 },
    value = GROUND.DEEPRAINFOREST,
    tags = { "ExitPiece", "hamlet", "folha" },
    contents = {

        distributepercent = 0.25 * preenchimento,
        distributeprefabs =
        {
            rainforesttree = 2, --4,
            tree_pillar = 0.5, --0.5,
            nettle = 0.12,
            flower_rainforest = 1,
            --	berrybush = 1,
            --										lightrays_jungle = 1.2,								
            deep_jungle_fern_noise = 1,
            jungle_border_vine = 0.5,
            fireflies = 0.2,
            --										hanging_vine_patch = 0.1,
            randomrelic = 0.02,
            randomruin = 0.02,
            randomdust = 0.02,
            pig_ruins_torch = 0.02,
            --		pig_ruins_artichoke = 0.01,
            --		pig_ruins_head = 0.01,
            --										mean_flytrap = 0.05,
            rock_flippable = 0.1,
            radish_planted = 0.5,
        },
    }
})

AddRoom("deeprainforest_base_nobatcave_PigRuinsExit4", {
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 },
    value = GROUND.DEEPRAINFOREST,
    tags = { "ExitPiece", "hamlet", "folha" },
    contents = {
        countstaticlayouts = {
            ["pig_ruins_exit_4"] = 1,
        },
        distributepercent = 0.25 * preenchimento,
        distributeprefabs =
        {
            rainforesttree = 2, --4,
            tree_pillar = 0.5, --0.5,
            nettle = 0.12,
            flower_rainforest = 1,
            --	berrybush = 1,
            --										lightrays_jungle = 1.2,								
            deep_jungle_fern_noise = 1,
            jungle_border_vine = 0.5,
            fireflies = 0.2,
            --										hanging_vine_patch = 0.1,
            randomrelic = 0.02,
            randomruin = 0.02,
            randomdust = 0.02,
            pig_ruins_torch = 0.02,
            --		pig_ruins_artichoke = 0.01,
            --		pig_ruins_head = 0.01,
            --										mean_flytrap = 0.05,
            rock_flippable = 0.1,
            radish_planted = 0.5,
        },
    }
})


AddRoom("rainforest_base_nobatcave", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = GROUND.RAINFOREST,
    tags = { "ExitPiece", "hamlet", "folha" },
    contents = {
        distributepercent = .19 * preenchimento, --.5
        distributeprefabs =
        {
            rainforesttree = 0.6, --1.4,
            grass_tall = .5,
            sapling = .6,
            flower_rainforest = 0.1,
            flower = 0.05,
            dungpile = 0.03,
            fireflies = 0.05,
            peagawk = 0.01,
            --	randomrelic = 0.008,
            --	randomruin = 0.005,	
            randomdust = 0.005,
            rock_flippable = 0.08,
            radish_planted = 0.05,
            asparagus_planted = 0.05,
        },
    }
})

AddRoom("painted_base_nobatcave", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = GROUND.PAINTED,
    tags = { "ExitPiece", "hamlet" },
    contents = {
        distributepercent = .075 * preenchimento, --.26
        distributeprefabs =
        {
            tubertree = 1,
            gnatmound = 0.1,
            rocks = 0.1,
            nitre = 0.1,
            flint = 0.05,
            iron = 0.2,
            thunderbirdnest = 0.1,
            sedimentpuddle = 0.1,
            pangolden = 0.005,
        },
        countprefabs =
        {
            pangolden = 1,
        },
    }
})

AddRoom("plains_base_nobatcave", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = GROUND.PLAINS,
    tags = { "ExitPiece", "hamlet" },
    contents = {
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
        },
    }
})
---------------------------------------------------------------------------Start Room -------------------------------------------------------------------------------------------------------------------------------------	
AddRoom("PorklandPortalRoom", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.PLAINS,
    tags = { "RoadPoison", "hamlet", "Chester_Eyebone" },
    contents = {
        distributepercent = .25,
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
        countprefabs =
        {
            spawnpoint_multiplayer = 1,
            --lake = 1,
        }

    }
})

AddTask("inicio", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = { KEYS.JUNGLE_DEPTH_1 },
    room_choices = {
        ["PorklandPortalRoom"] = 1,
    },
    room_bg = GROUND.PLAINS,
    background_room = "BG_plains_base",
    colour = { r = 0, g = 1, b = 0, a = 1 }
})
--------------------------------------------------
AddTask("separavulcao", {
    locks = {
        LOCKS.RUINS,
    },
    keys_given = KEYS.LAND_DIVIDE_3,
    room_choices = {
        ["ForceDisconnectedRoom"] = 10,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.VOLCANO,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})


AddTask("separahamcave", {
    locks = {
        LOCKS.SACRED,
    },
    keys_given = KEYS.LAND_DIVIDE_5,
    room_choices = {
        ["ForceDisconnectedRoom"] = 10,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.VOLCANO,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})


AddTask("HamMudWorld", {
    locks = { LOCKS.LAND_DIVIDE_5 },
    keys_given = { KEYS.ISLAND1, KEYS.ISLAND2 },
    room_choices = {
        ["HamLightPlantField"] = 1,
        ["HamLightPlantFieldexit"] = 1,
        ["HamWormPlantField"] = 1,
        ["HamFernGully"] = 1,
        ["HamSlurtlePlains"] = 1,
        ["HamMudWithRabbit"] = 1,
        ["PitRoom"] = 1,
    },
    background_room = "HamBGMud",
    room_bg = GROUND.MUD,
    colour = { r = 0.6, g = 0.4, b = 0.0, a = 0.9 },
})

AddTask("HamMudCave", {
    locks = { LOCKS.ISLAND1, LOCKS.ISLAND2 },
    keys_given = { KEYS.ISLAND1, KEYS.ISLAND3 },
    room_choices = {
        ["HamWormPlantField"] = 1,
        ["HamSlurtlePlains"] = 1,
        ["HamMudWithRabbit"] = 1,
        ["HamMudWithRabbitexit"] = 1,
        ["PitRoom"] = 1,
    },
    background_room = "HamBGBatCaveRoom",
    room_bg = GROUND.MUD,
    colour = { r = 0.7, g = 0.5, b = 0.0, a = 0.9 },
})

AddTask("HamMudLights", {
    locks = { LOCKS.ISLAND1, LOCKS.ISLAND2 },
    keys_given = { KEYS.ISLAND1, KEYS.ISLAND3 },
    room_choices = {
        ["HamLightPlantField"] = 3,
        ["HamWormPlantField"] = 1,
        ["PitRoom"] = 1,
    },
    background_room = "HamWormPlantField",
    room_bg = GROUND.MUD,
    colour = { r = 0.7, g = 0.5, b = 0.0, a = 0.9 },
})

AddTask("HamMudPit", {
    locks = { LOCKS.ISLAND1, LOCKS.ISLAND2 },
    keys_given = { KEYS.ISLAND1, KEYS.ISLAND3 },
    room_choices = {
        ["SlurtlePlains"] = 1,
        ["PitRoom"] = 2,
    },
    background_room = "HamFernGully",
    room_bg = GROUND.MUD,
    colour = { r = 0.6, g = 0.4, b = 0.0, a = 0.9 },
})

------------------------------------------------------------
-- Main Caves Branches
------------------------------------------------------------
-- Big Bat Cave
AddTask("HamBigBatCave", {
    locks = { LOCKS.ISLAND1, LOCKS.ISLAND3 },
    keys_given = { KEYS.ISLAND1, KEYS.ISLAND4 },
    room_choices = {
        ["HamBatCave"] = 3,
        ["HamBattyCave"] = 1,
        ["HamFernyBatCave"] = 1,
        ["HamFernyBatCaveexit"] = 1,
        ["PitRoom"] = 2,
    },
    background_room = "HamBGBatCaveRoom",
    room_bg = GROUND.CAVE,
    colour = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 },
})

-- Rocky Land
AddTask("HamRockyLand", {
    locks = { LOCKS.ISLAND1, LOCKS.ISLAND3 },
    keys_given = { KEYS.ISLAND1, KEYS.ISLAND4, KEYS.ISLAND7 },
    room_choices = {
        ["HamSlurtleCanyon"] = 1,
        ["HamBatsAndSlurtles"] = 1,
        ["HamRockyPlains"] = 1,
        ["HamRockyPlainsexit"] = 1,
        ["HamRockyHatchingGrounds"] = 1,
        ["HamBatsAndRocky"] = 1,
        ["PitRoom"] = 1,
    },
    background_room = "HamBGRockyCaveRoom",
    room_bg = GROUND.CAVE,
    colour = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 },
})

----------------------------------

-- Red Forest
AddTask("HamRedForest", {
    locks = { LOCKS.ISLAND1, LOCKS.ISLAND3 },
    keys_given = { KEYS.ISLAND1, KEYS.ISLAND4 },
    room_choices = {
        ["HamRedMushForest"] = 2,
        ["HamRedSpiderForest"] = 1,
        ["HamRedSpiderForestexit"] = 1,
        ["HamRedMushPillars"] = 1,
        ["HamStalagmiteForest"] = 1,
        ["HamSpillagmiteMeadow"] = 1,
        ["PitRoom"] = 1,
    },
    background_room = "HamBGRedMush",
    room_bg = GROUND.QUAGMIRE_PARKFIELD,
    colour = { r = 1.0, g = 0.5, b = 0.5, a = 0.9 },
})

AddRoom("caveruinexitroom", {
    colour = { r = .25, g = .28, b = .25, a = .50 },
    value = GROUND.SINKHOLE,
    contents = {
        countstaticlayouts = {
            ["ruins_exit"] = 1,
        },
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

AddRoom("caveruinexitroom2", {
    colour = { r = .25, g = .28, b = .25, a = .50 },
    value = GROUND.SINKHOLE,
    contents = {
        countstaticlayouts = {
            ["ruins_exit2"] = 1,
        },
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

AddTask("caveruinsexit", {
    locks = { LOCKS.ENTRANCE_INNER },
    keys_given = {},
    room_choices = {
        ["caveruinexitroom"] = 1,
    },
    background_room = "BGSinkhole",
    room_bg = GROUND.SINKHOLE,
    colour = { r = 1, g = 0, b = 1, a = 1 },
})

AddTask("caveruinsexit2", {
    locks = { LOCKS.ENTRANCE_OUTER },
    keys_given = {},
    room_choices = {
        ["caveruinexitroom2"] = 1,
    },
    background_room = "BGSinkhole",
    room_bg = GROUND.SINKHOLE,
    colour = { r = 1, g = 0, b = 1, a = 1 },
})

-- Green Forest
AddTask("HamGreenForest", {
    locks = { LOCKS.ISLAND1, LOCKS.ISLAND3 },
    keys_given = { KEYS.ISLAND1, KEYS.ISLAND4 },
    room_choices = {
        ["HamGreenMushForest"] = 2,
        ["HamGreenMushPonds"] = 1,
        ["HamGreenMushSinkhole"] = 1,
        ["HamGreenMushMeadow"] = 1,
        ["HamGreenMushRabbits"] = 1,
        ["HamGreenMushNoise"] = 1,
        ["PitRoom"] = 1,
    },
    background_room = "HamBGGreenMush",
    room_bg = GROUND.QUAGMIRE_PARKFIELD,
    colour = { r = 0.5, g = 1.0, b = 0.5, a = 0.9 },
})

-- Blue Forest
AddTask("HamBlueForest", {
    locks = { LOCKS.ISLAND1, LOCKS.ISLAND3 },
    keys_given = { KEYS.ISLAND1, KEYS.ISLAND4, KEYS.ISLAND5 },
    room_choices = {
        ["HamBlueMushForest"] = 3,
        ["HamBlueMushMeadow"] = 2,
        ["HamBlueSpiderForest"] = 1,
        ["HamDropperDesolation"] = 1,
        ["PitRoom"] = 1,
    },
    background_room = "HamBGBlueMush",
    room_bg = GROUND.QUAGMIRE_PARKFIELD,
    colour = { r = 0.5, g = 0.5, b = 1.0, a = 0.9 },
})

--------------------ham pigmaze--------------------------

AddTask("HamMoonCaveForest", {
    locks = { LOCKS.ISLAND5 },
    keys_given = { KEYS.ISLAND6 },
    room_tags = { "nocavein" },
    room_choices = {
        ["HamCaveGraveyard"] = 1,
        ["HamCaveGraveyardentrance"] = 1,
    },
    background_room = "HamCaveGraveyard",
    room_bg = GROUND.FUNGUSMOON,
    colour = { r = 0.3, g = 0.3, b = 0.3, a = 0.9 },
})

AddTask("HamArchiveMaze", {
    locks = { LOCKS.ISLAND6 },
    keys_given = {},
    room_tags = { "nocavein" },
    entrance_room = "HamArchiveMazeEntrance",
    room_choices =
    {
        ["ArchiveMazeRooms"] = 4,
    },
    room_bg = GROUND.ARCHIVE,
    --    maze_tiles = {rooms = {"archive_hallway"}, bosses = {"archive_hallway"}, keyroom = {"archive_keyroom"}, archive = {start={"archive_start"}, finish={"archive_end"}}, bridge_ground=GROUND.FAKE_GROUND},
    maze_tiles = { rooms = { "hamlet_hallway", "hamlet_hallway_two" }, bosses = { "hamlet_hallway" }, archive = { keyroom = { "hamlet_keyroom" } }, special = { finish = { "hamlet_end" }, start = { "hamlet_start" } }, bridge_ground = GROUND.FAKE_GROUND },
    background_room = "ArchiveMazeRooms",
    cove_room_chance = 0,
    cove_room_max_edges = 0,
    make_loop = true,
    colour = { r = 1, g = 0, b = 0.0, a = 1 },
})

AddRoom("HamArchiveMazeEntrance", {
    colour = { r = 0.1, g = 0.1, b = 0.8, a = 0.9 },
    value = GROUND.CAVE_NOISE,
    tags = { "MazeEntrance", "RoadPoison" },
    contents = {
        distributepercent = 0.6,
        distributeprefabs =
        {
            tree_forest_rot = 0.05,
            lightflier_flower = 0.01,
            cavelightmoon = 0.01,
            cavelightmoon_small = 0.01,
            cavelightmoon_tiny = 0.01,

            stalagmite_tall = 0.03,
            stalagmite_tall_med = 0.03,
            stalagmite_tall_low = 0.03,
            batcave = 0.01,
        },
    }
})

AddRoom("HamCaveGraveyardentrance", {
    colour = { r = 0.1, g = 0.1, b = 0.8, a = 0.9 },
    value = GROUND.MARSH,
    tags = { "RoadPoison", "Mist" },
    contents = {
        distributepercent = 0.6,
        distributeprefabs =
        {
            tree_forest_rot = 0.05,

            lightflier_flower = 0.01,

            cavelightmoon = 0.01,
            cavelightmoon_small = 0.01,
            cavelightmoon_tiny = 0.01,

            pigghostspawner = 0.005,
            piggravestone1 = 0.02,
            piggravestone2 = 0.02,
        },
    }
})

AddRoom("HamCaveGraveyard", {
    colour = { r = .010, g = .010, b = .10, a = .50 },
    value = GROUND.MARSH,
    tags = { "Mist" },
    contents = {
        countprefabs = {
            tree_forest_rot = 20,
            pigghostspawner = 10,
            goldnugget = function() return math.random(10) end,
            piggravestone1 = function() return 10 + math.random(4) end,
            piggravestone2 = function() return 10 + math.random(4) end,
        }
    }
})
----------------------------------------------

AddTask("HamSpillagmiteCaverns", {
    locks = { LOCKS.ISLAND1, LOCKS.ISLAND3 },
    keys_given = { KEYS.ISLAND1, KEYS.ISLAND4 },
    room_choices = {
        ["HamSpidersAndBats"] = 1,
        ["HamThuleciteDebris"] = 1,
        ["PitRoom"] = 1,
    },
    background_room = "HamBGSpillagmite",
    room_bg = GROUND.UNDERROCK,
    colour = { r = 0.3, g = 0.3, b = 0.3, a = 0.9 },
})

AddTask("HamSpillagmiteCaverns1", {
    locks = { LOCKS.ISLAND1, LOCKS.ISLAND3 },
    keys_given = { KEYS.ISLAND1, KEYS.ISLAND4 },
    room_choices = {
        ["HamSpillagmiteForest"] = 1,
        ["HamDropperCanyon"] = 1,
        ["HamStalagmitesAndLights"] = 1,
    },
    background_room = "HamSpillagmiteForest",
    room_bg = GROUND.FUNGUS,
    colour = { r = 0.3, g = 0.3, b = 0.3, a = 0.9 },
})
----------------------------------------------Ham caves---------------------------------------------------------------------------
-- plainscave
AddRoom("HamLightPlantField", {
    colour = { r = 0.7, g = 0.5, b = 0.3, a = 0.9 },
    value = GROUND.SINKHOLE,
    tags = { "Hutch_Fishbowl" },
    contents = {
        distributepercent = .4,
        distributeprefabs =
        {
            flower_cave = 1.0,
            flower_cave_double = 0.5,
            flower_cave_triple = 0.5,

            jungle_border_vine = 0.5,
            pig_ruins_torch = 0.02,
            pig_ruins_pig = 0.02,
            pig_ruins_light_beam = 0.02,

            pig_ruins_head = 0.02,
            flower_rainforest = 2,
            pillar_cave_flintless = 0.02,
            deep_jungle_fern_noise_plant = 1,
            deep_jungle_fern_noise_plant2 = 1,
            clawpalmtree = 0.5,
            grass_tall = 1,
            sapling = .3,
            flower = 0.05,
            peagawk = 0.01,
            rock_flippable = 0.08,
            aloe_planted = 0.08,
            pog = 0.01,
            asparagus_planted = 0.05,
        },
    }
})

-- plainscave 2
AddRoom("HamLightPlantFieldexit", {
    colour = { r = 0.7, g = 0.5, b = 0.3, a = 0.9 },
    value = GROUND.SINKHOLE,
    tags = { "Hutch_Fishbowl" },
    contents = {
        distributepercent = .4,
        distributeprefabs =
        {
            flower_cave = 1.0,
            flower_cave_double = 0.5,
            flower_cave_triple = 0.5,

            jungle_border_vine = 0.5,
            pig_ruins_torch = 0.02,
            pig_ruins_pig = 0.02,
            pig_ruins_light_beam = 0.02,

            pig_ruins_head = 0.02,
            flower_rainforest = 2,
            pillar_cave_flintless = 0.02,
            deep_jungle_fern_noise_plant = 0.5,
            deep_jungle_fern_noise_plant2 = 0.5,
            clawpalmtree = 0.5,
            grass_tall = 1,
            sapling = .3,
            flower = 0.05,
            peagawk = 0.01,
            rock_flippable = 0.08,
            aloe_planted = 0.08,
            pog = 0.01,
            asparagus_planted = 0.05,
        },
        countprefabs =
        {
            cave_exit_ham1 = 1,
        },
    }
})


-- plainscave 3
AddRoom("HamWormPlantField", {
    colour = { r = 0.7, g = 0.5, b = 0.3, a = 0.9 },
    value = GROUND.SINKHOLE,
    tags = { "Hutch_Fishbowl" },
    contents = {
        distributepercent = .3,
        distributeprefabs =
        {
            flower_cave = 0.5,
            flower_cave_double = 0.1,
            flower_cave_triple = 0.1,

            jungle_border_vine = 0.5,
            pig_ruins_torch = 0.02,
            pig_ruins_pig = 0.02,
            pig_ruins_light_beam = 0.02,
            pig_ruins_head = 0.02,

            pillar_cave_flintless = 0.02,

            deep_jungle_fern_noise_plant = 0.5,
            deep_jungle_fern_noise_plant2 = 0.5,
            clawpalmtree = 0.5,
            grass_tall = 1,
            sapling = .3,
            flower = 0.05,
            peagawk = 0.01,
            rock_flippable = 0.08,
            aloe_planted = 0.08,
            pog = 0.01,
            asparagus_planted = 0.05,

            wormlight_plant = 0.2,

        },
    }
})

-- plainscave 4 fern
AddRoom("HamFernGully", {
    colour = { r = 0.7, g = 0.5, b = 0.3, a = 0.9 },
    value = GROUND.SINKHOLE,
    tags = { "Hutch_Fishbowl" },
    contents = {
        distributepercent = .5,
        distributeprefabs =
        {
            flower_cave = 0.2,
            flower_cave_double = 0.1,
            flower_cave_triple = 0.1,

            jungle_border_vine = 0.5,
            pig_ruins_torch = 0.02,
            pig_ruins_pig = 0.02,
            pig_ruins_light_beam = 0.02,
            pig_ruins_head = 0.02,
            pillar_cave_flintless = 0.02,
            deep_jungle_fern_noise_plant = 0.5,
            deep_jungle_fern_noise_plant2 = 0.5,
            clawpalmtree = 0.5,
            grass_tall = 1,
            sapling = .3,
            flower = 0.05,
            peagawk = 0.01,
            rock_flippable = 0.08,
            aloe_planted = 0.08,
            pog = 0.03,
            asparagus_planted = 0.05,


            cave_fern = 2.0,
            wormlight_plant = 0.05,
        },
    }
})

-- plainscave
AddRoom("HamSlurtlePlains", {
    colour = { r = 0.7, g = 0.5, b = 0.3, a = 0.9 },
    value = GROUND.SINKHOLE,
    tags = { "Hutch_Fishbowl" },
    contents = {
        distributepercent = .4,
        distributeprefabs =
        {
            flower_cave = 0.2,
            flower_cave_double = 0.1,
            flower_cave_triple = 0.1,

            jungle_border_vine = 0.5,
            pig_ruins_torch = 0.02,
            pig_ruins_pig = 0.02,
            pig_ruins_light_beam = 0.02,
            pig_ruins_head = 0.02,
            pillar_cave_flintless = 0.02,
            deep_jungle_fern_noise_plant = 0.5,
            deep_jungle_fern_noise_plant2 = 0.5,
            clawpalmtree = 0.5,
            grass_tall = 1,
            sapling = .3,
            flower = 0.05,
            peagawk = 0.01,
            rock_flippable = 0.08,
            aloe_planted = 0.08,
            pog = 0.03,
            asparagus_planted = 0.05,


            cave_fern = 2.0,
            wormlight_plant = 0.05,
        },
    }
})

-- plainscave
AddRoom("HamMudWithRabbit", {
    colour = { r = 0.7, g = 0.5, b = 0.3, a = 0.9 },
    value = GROUND.SINKHOLE,
    tags = { "Hutch_Fishbowl" },
    contents = {
        distributepercent = .3,
        distributeprefabs =
        {
            flower_cave = 0.2,
            flower_cave_double = 0.1,
            flower_cave_triple = 0.1,

            jungle_border_vine = 0.5,
            pig_ruins_torch = 0.02,
            pig_ruins_pig = 0.02,
            pig_ruins_light_beam = 0.02,
            pig_ruins_head = 0.02,
            pillar_cave_flintless = 0.02,
            deep_jungle_fern_noise_plant = 0.5,
            deep_jungle_fern_noise_plant2 = 0.5,
            clawpalmtree = 0.5,
            grass_tall = 1,
            sapling = .3,
            flower = 0.05,
            peagawk = 0.01,
            rock_flippable = 0.08,
            aloe_planted = 0.08,
            pog = 0.03,
            asparagus_planted = 0.05,


            cave_fern = 2.0,
            wormlight_plant = 0.05,
        },
    }
})

-- plainscave
AddRoom("HamMudWithRabbitexit", {
    colour = { r = 0.7, g = 0.5, b = 0.3, a = 0.9 },
    value = GROUND.SINKHOLE,
    tags = { "Hutch_Fishbowl" },
    contents = {
        distributepercent = .3,
        distributeprefabs =
        {
            flower_cave = 0.2,
            flower_cave_double = 0.1,
            flower_cave_triple = 0.1,

            jungle_border_vine = 0.5,
            pig_ruins_torch = 0.02,
            pig_ruins_pig = 0.02,
            pig_ruins_light_beam = 0.02,
            pig_ruins_head = 0.02,
            pillar_cave_flintless = 0.02,
            deep_jungle_fern_noise_plant = 0.5,
            deep_jungle_fern_noise_plant2 = 0.5,
            clawpalmtree = 0.5,
            grass_tall = 1,
            sapling = .3,
            flower = 0.05,
            peagawk = 0.01,
            rock_flippable = 0.08,
            aloe_planted = 0.08,
            pog = 0.03,
            asparagus_planted = 0.05,


            cave_fern = 2.0,
            wormlight_plant = 0.05,

        },
        countprefabs =
        {
            cave_exit_ham2 = 1,
        },
    }
})

-- plainscave
AddRoom("HamBGMud", {
    colour = { r = 0.7, g = 0.5, b = 0.3, a = 0.9 },
    value = GROUND.SINKHOLE,
    tags = { "Hutch_Fishbowl" },
    contents = {
        distributepercent = .3,
        distributeprefabs =
        {
            flower_cave = 0.2,
            flower_cave_double = 0.1,
            flower_cave_triple = 0.1,

            jungle_border_vine = 0.5,
            pig_ruins_torch = 0.02,
            pig_ruins_pig = 0.02,
            pig_ruins_light_beam = 0.02,
            pig_ruins_head = 0.02,
            pillar_cave_flintless = 0.02,
            deep_jungle_fern_noise_plant = 0.5,
            deep_jungle_fern_noise_plant2 = 0.5,
            clawpalmtree = 0.5,
            grass_tall = 1,
            sapling = .3,
            flower = 0.05,
            peagawk = 0.01,
            rock_flippable = 0.08,
            aloe_planted = 0.08,
            pog = 0.03,
            asparagus_planted = 0.05,


            cave_fern = 2.0,
            wormlight_plant = 0.05,
        },
    }
})


-- cave iron
AddRoom("HamBatCave", {
    colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
    value = GROUND.MUD,
    tags = { "Hutch_Fishbowl" },
    contents = {
        distributepercent = .15,
        distributeprefabs =
        {
            goldnugget = .05,
            flint = 0.05,
            stalagmite_tall = 0.4,
            stalagmite_tall_med = 0.4,
            stalagmite_tall_low = 0.4,
            pillar_cave_rock = 0.08,
            fissure = 0.05,
            tubertree = 1,
            gnatmound = 0.1,
            rocks = 0.1,
            nitre = 0.1,
            iron = 0.3,
            --            thunderbirdnest = 0.1,
            sedimentpuddle = 0.2,
            pangolden = 0.02,
            slurtlehole = 0.5,
        }
    }
})

-- cave iron
AddRoom("HamBattyCave", {
    colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
    value = GROUND.MUD,
    tags = { "Hutch_Fishbowl" },
    contents = {
        distributepercent = .25,
        distributeprefabs =
        {
            goldnugget = .05,
            flint = 0.05,
            stalagmite_tall = 0.4,
            stalagmite_tall_med = 0.4,
            stalagmite_tall_low = 0.4,
            pillar_cave_rock = 0.08,
            fissure = 0.05,
            tubertree = 1,
            gnatmound = 0.1,
            rocks = 0.1,
            nitre = 0.1,
            iron = 0.3,
            --            thunderbirdnest = 0.1,
            sedimentpuddle = 0.2,
            pangolden = 0.1,
            slurtlehole = 0.5,
        }
    }
})
-- cave iron
AddRoom("HamFernyBatCave", {
    colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
    value = GROUND.MUD,
    tags = { "Hutch_Fishbowl" },
    contents = {
        distributepercent = .25,
        distributeprefabs =
        {
            goldnugget = .05,
            flint = 0.05,
            stalagmite_tall = 0.4,
            stalagmite_tall_med = 0.4,
            stalagmite_tall_low = 0.4,
            pillar_cave_rock = 0.08,
            fissure = 0.05,
            tubertree = 1,
            gnatmound = 0.1,
            rocks = 0.1,
            nitre = 0.1,
            iron = 0.3,
            --            thunderbirdnest = 0.1,
            sedimentpuddle = 0.2,
            pangolden = 0.02,
            slurtlehole = 0.5,
        }
    }
})

-- cave iron
AddRoom("HamFernyBatCaveexit", {
    colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
    value = GROUND.MUD,
    tags = { "Hutch_Fishbowl" },
    contents = {
        distributepercent = .25,
        distributeprefabs =
        {
            cave_fern = 0.5,
            goldnugget = .05,
            flint = 0.05,
            stalagmite_tall = 0.4,
            stalagmite_tall_med = 0.4,
            stalagmite_tall_low = 0.4,
            pillar_cave_rock = 0.08,
            fissure = 0.05,
            tubertree = 1,
            gnatmound = 0.1,
            rocks = 0.1,
            nitre = 0.1,
            iron = 0.3,
            --            thunderbirdnest = 0.1,
            sedimentpuddle = 0.2,
            pangolden = 0.02,
            slurtlehole = 0.5,
        },
        countprefabs =
        {
            cave_exit_ham3 = 1,
        },
    }
})

-- caveiron
AddRoom("HamBGBatCaveRoom", {
    colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
    value = GROUND.MUD,
    tags = { "Hutch_Fishbowl" },
    contents = {
        distributepercent = .13,
        distributeprefabs =
        {
            cave_fern = 0.5,
            goldnugget = .05,
            flint = 0.05,
            stalagmite_tall = 0.4,
            stalagmite_tall_med = 0.4,
            stalagmite_tall_low = 0.4,
            pillar_cave_rock = 0.08,
            fissure = 0.05,
            tubertree = 1,
            gnatmound = 0.1,
            rocks = 0.1,
            nitre = 0.1,
            iron = 0.3,
            --            thunderbirdnest = 0.1,
            sedimentpuddle = 0.2,
            pangolden = 0.02,
            slurtlehole = 0.5,
        },
    }
})

---------------inicia aqui-----------------------	

-- fip
AddRoom("HamSlurtleCanyon", {
    colour = { r = 0.7, g = 0.7, b = 0.7, a = 0.9 },
    value = GROUND.MUD,
    --    tags = {"Hutch_Fishbowl"},
    type = GLOBAL.NODE_TYPE.Room,
    internal_type = GLOBAL.NODE_INTERNAL_CONNECTION_TYPE.EdgeSite,
    contents = {
        distributepercent = .20,
        distributeprefabs =
        {
            anthill_cavelamp = 0.1,
            grotto_pillar_bug = 0.1,
            rock_flippable = 0.3,
            rock_antcave = 0.7,
            sapling = 0.2,
            rock_flintless = 1.0,
            rock_flintless_med = 1.0,
            rock_flintless_low = 1.0,
            pillar_cave_flintless = 0.2,

            stalagmite_tall = 0.5,
            stalagmite_tall_med = 0.2,
            stalagmite_tall_low = 0.2,
            fissure = 0.01,
            deco_cave_ceiling_drip_2 = 0.1,
        },
        countprefabs =
        {
            --		antcombhomecave = 2,
            ant_cave_lantern = 2,
            anthillcave = 4,
            grotto_parsnip_planted = 3,
            grotto_parsnip_giant = 1,

        },
    }
})

-- fip
AddRoom("HamBatsAndSlurtles", {
    colour = { r = 0.7, g = 0.7, b = 0.7, a = 0.9 },
    value = GROUND.MUD,
    --    tags = {"Hutch_Fishbowl"},
    type = GLOBAL.NODE_TYPE.Room,
    internal_type = GLOBAL.NODE_INTERNAL_CONNECTION_TYPE.EdgeSite,
    contents = {
        distributepercent = .20,
        distributeprefabs =
        {
            anthill_cavelamp = 0.1,
            grotto_pillar_bug = 0.1,
            rock_flippable = 0.3,
            rock_antcave = 0.7,
            sapling = 0.2,
            rock_flintless = 1.0,
            rock_flintless_med = 1.0,
            rock_flintless_low = 1.0,
            pillar_cave_flintless = 0.2,
            stalagmite_tall = 0.5,
            stalagmite_tall_med = 0.2,
            deco_hive_debris = 0.2,
            deco_cave_ceiling_drip_2 = 0.1,
        },
        countprefabs =
        {
            --		antcombhomecave = 2,
            ant_cave_lantern = 2,
            anthillcave = 4,
            grotto_parsnip_planted = 3,
            grotto_parsnip_giant = 1,
            antchest = 1,
        },
    }
})

-- fip
AddRoom("HamRockyPlains", {
    colour = { r = 0.7, g = 0.7, b = 0.7, a = 0.9 },
    value = GROUND.MUD,
    --    tags = {"Hutch_Fishbowl"},
    type = GLOBAL.NODE_TYPE.Room,
    internal_type = GLOBAL.NODE_INTERNAL_CONNECTION_TYPE.EdgeSite,
    contents = {
        distributepercent = .25,
        distributeprefabs =
        {
            anthill_cavelamp = 0.1,
            grotto_pillar_bug = 0.1,
            rock_flippable = 0.3,
            rock_antcave = 0.7,
            antcombhomecave = 0.15,
            sapling = 0.2,
            guano = 0.27,
            goldnugget = .05,
            flint = 0.05,
            stalagmite_tall = 0.4,
            stalagmite_tall_med = 0.4,
            stalagmite_tall_low = 0.4,
            fissure = 0.05,
            deco_cave_ceiling_drip_2 = 0.1,
        },
        countprefabs =
        {
            --		antcombhomecave = 2,
            giantgrubspawner = 1,
            ant_cave_lantern = 2,
            anthillcave = 4,
            grotto_grub_nest = 1,
            grotto_parsnip_planted = 3,
            grotto_parsnip_giant = 1,
            pond_cave = 2,
        },
    }
})

-- fip
AddRoom("HamRockyPlainsexit", {
    colour = { r = 0.7, g = 0.7, b = 0.7, a = 0.9 },
    value = GROUND.MUD,
    --    tags = {"Hutch_Fishbowl"},
    type = GLOBAL.NODE_TYPE.Room,
    internal_type = GLOBAL.NODE_INTERNAL_CONNECTION_TYPE.EdgeSite,
    contents = {
        distributepercent = .20,
        distributeprefabs =
        {
            anthill_cavelamp = 0.1,
            grotto_pillar_bug = 0.08,
            ant_cave_lantern = 0.1,
            rock_flippable = 0.7,
            rock_antcave = 0.3,
            sapling = 0.2,
            deco_cave_ceiling_drip_2 = 0.1,
        },
        countprefabs =
        {
            --		antcombhomecave = 2,
            giantgrubspawner = 1,
            ant_cave_lantern = 2,
            grotto_grub_nest = 5,
            grotto_parsnip_planted = 3,
            grotto_parsnip_giant = 1,
        },
    }
})

-- fip
AddRoom("HamRockyHatchingGrounds", {
    colour = { r = 0.7, g = 0.7, b = 0.7, a = 0.9 },
    value = GROUND.MUD,
    --    tags = {"Hutch_Fishbowl"},
    type = GLOBAL.NODE_TYPE.Room,
    internal_type = GLOBAL.NODE_INTERNAL_CONNECTION_TYPE.EdgeSite,
    contents = {
        distributepercent = .30,
        distributeprefabs =
        {
            anthill_cavelamp = 0.1,
            grotto_pillar_bug = 0.08,
            rock_flippable = 0.3,
            rock_antcave = 0.7,
            deco_cave_ceiling_drip_2 = 0.1,
        },
        countprefabs =
        {
            --		antcombhomecave = 2,
            giantgrubspawner = 1,
            ant_cave_lantern = 2,
            grotto_grub_nest = 5,
            grotto_parsnip_planted = 3,
            grotto_parsnip_giant = 1,
        },
    }
})

-- fip
AddRoom("HamBatsAndRocky", {
    colour = { r = 0.7, g = 0.7, b = 0.7, a = 0.9 },
    value = GROUND.MUD,
    --    tags = {"Hutch_Fishbowl"},
    type = GLOBAL.NODE_TYPE.SeparatedRoom,
    internal_type = GLOBAL.NODE_INTERNAL_CONNECTION_TYPE.EdgeCentroid,
    contents = {
        countstaticlayouts = {
            ["antqueencave"] = 1,
        },
        distributepercent = .35,
        distributeprefabs =
        {
            anthill_cavelamp = 0.1,
            grotto_pillar_bug = 0.08,
            rock_flippable = 0.3,
            rock_antcave = 0.7,
            sapling = 0.2,
            deco_cave_ceiling_drip_2 = 0.1,
        },
        countprefabs =
        {
            --		antchest = 1,
        },
    }
})


-- fip
AddRoom("HamBGRockyCaveRoom", {
    colour = { r = 0.7, g = 0.7, b = 0.7, a = 0.9 },
    value = GROUND.MUD,
    --    tags = {"Hutch_Fishbowl"},	
    type = GLOBAL.NODE_TYPE.Room,
    internal_type = GLOBAL.NODE_INTERNAL_CONNECTION_TYPE.EdgeSite,
    contents = {
        distributepercent = .20,
        distributeprefabs =
        {
            flower_cave_triple = 0.1,
            grotto_pillar_bug = 0.08,
            rock_flippable = 0.3,
            rock_antcave = 0.7,
            sapling = 0.2,
            deco_cave_ceiling_drip_2 = 0.1,
        },
        countprefabs =
        {
            --		antcombhomecave = 2,
            giantgrubspawner = 1,
            --		ant_cave_lantern = 2,
            anthillcave = 2,
            anthill_cavelamp = 2,
            grotto_grub_nest = 1,
            grotto_parsnip_planted = 3,
            grotto_parsnip_giant = 1,
            grotto_pillar_bug = 2,
        },
    }
})


---------

-- Gass MIX MUSH
AddRoom("HamRedMushForest", {
    colour = { r = 0.8, g = 0.1, b = 0.1, a = 0.9 },
    value = GROUND.QUAGMIRE_PARKFIELD,
    tags = { "Hutch_Fishbowl", "folha" },
    contents = {
        distributepercent = .3,
        distributeprefabs =
        {
            mushtree_yelow = 9.0,
            yelow_mushroom = 0.9,

            stalagmite = 0.5,
            spiderhole = 0.05,

            pillar_cave = 0.05,
            cavelight = 0.6,
            --			poisonmist = 8,
            rock_flippable = 0.05,
            jungle_border_vine = 0.5,
            pig_ruins_torch = 0.2,
            pig_ruins_head = 0.5,
            pig_ruins_pig = 0.5,
            pig_ruins_ant = 0.5,
        },
    }
})

-- Gass MIX MUSH
AddRoom("HamRedSpiderForest", {
    colour = { r = 0.8, g = 0.1, b = 0.4, a = 0.9 },
    value = GROUND.QUAGMIRE_PARKFIELD,
    tags = { "Hutch_Fishbowl", "folha" },
    contents = {
        distributepercent = .3,
        distributeprefabs =
        {
            mushtree_yelow = 9.0,
            yelow_mushroom = 0.9,

            stalagmite = 1.5,
            spiderhole = 0.4,

            pillar_cave = 0.05,
            cavelight = 0.6,
            --			poisonmist = 8,
            rock_flippable = 0.05,
            jungle_border_vine = 0.5,
            pig_ruins_torch = 0.2,
            pig_ruins_head = 0.5,
            pig_ruins_pig = 0.5,
            pig_ruins_ant = 0.5,
        },
    }
})

-- Gass MIX MUSH
AddRoom("HamRedSpiderForestexit", {
    colour = { r = 0.8, g = 0.1, b = 0.4, a = 0.9 },
    value = GROUND.QUAGMIRE_PARKFIELD,
    tags = { "Hutch_Fishbowl", "folha" },
    contents = {
        distributepercent = .3,
        distributeprefabs =
        {
            mushtree_yelow = 9.0,
            yelow_mushroom = 0.9,

            spiderhole = 0.4,
            stalagmite = 0.2,
            pillar_cave = 0.5,
            cavelight = 0.6,
            --			poisonmist = 8,
            rock_flippable = 0.05,
            jungle_border_vine = 0.5,
            pig_ruins_torch = 0.2,
            pig_ruins_head = 0.5,
            pig_ruins_pig = 0.5,
            pig_ruins_ant = 0.5,
        },
    }
})

-- Gass MIX MUSH
AddRoom("HamRedMushPillars", {
    colour = { r = 0.8, g = 0.1, b = 0.4, a = 0.9 },
    value = GROUND.QUAGMIRE_PARKFIELD,
    tags = { "Hutch_Fishbowl", "folha" },
    contents = {
        distributepercent = .15,
        distributeprefabs =
        {
            mushtree_yelow = 6.0,
            yelow_mushroom = 0.9,

            stalagmite = 0.5,
            spiderhole = 0.01,

            pillar_cave = 0.05,
            cavelight = 0.6,
            --			poisonmist = 8,
            rock_flippable = 0.05,
            jungle_border_vine = 0.5,
            pig_ruins_torch = 0.2,
            pig_ruins_head = 0.5,
            pig_ruins_pig = 0.5,
            pig_ruins_ant = 0.5,
        },
    }
})

-- Gass MIX MUSH
AddRoom("HamStalagmiteForest", {
    colour = { r = 0.8, g = 0.1, b = 0.1, a = 0.9 },
    value = GROUND.QUAGMIRE_PARKFIELD,
    tags = { "Hutch_Fishbowl", "folha" },
    contents = {
        distributepercent = .3,
        distributeprefabs =
        {
            mushtree_yelow = 9.0,
            yelow_mushroom = 0.9,

            stalagmite = 3.5,
            spiderhole = 0.15,

            pillar_cave = 0.05,
            cavelight = 0.6,
            --			poisonmist = 8,
            rock_flippable = 0.05,
            jungle_border_vine = 0.5,
            pig_ruins_torch = 0.2,
            pig_ruins_head = 0.5,
            pig_ruins_pig = 0.5,
            pig_ruins_ant = 0.5,
        },
    }
})

-- Gass MIX MUSH
AddRoom("HamSpillagmiteMeadow", {
    colour = { r = 0.8, g = 0.1, b = 0.1, a = 0.9 },
    value = GROUND.QUAGMIRE_PARKFIELD,
    tags = { "Hutch_Fishbowl", "folha" },
    contents = {
        distributepercent = .15,
        distributeprefabs =
        {
            mushtree_yelow = 9.0,
            yelow_mushroom = 0.9,

            stalagmite = 1.5,
            spiderhole = 0.45,

            pillar_cave = 0.05,
            cavelight = 0.6,
            --			poisonmist = 8,
            rock_flippable = 0.05,
            jungle_border_vine = 0.5,
            pig_ruins_torch = 0.2,
            pig_ruins_head = 0.5,
            pig_ruins_pig = 0.5,
            pig_ruins_ant = 0.5,
        },
        countprefabs =
        {
            maze_pig_ruins_entrance2 = 1,
        },
    }
})

-- Gass MIX MUSH
AddRoom("HamBGRedMush", {
    colour = { r = 0.8, g = 0.1, b = 0.1, a = 0.9 },
    value = GROUND.QUAGMIRE_PARKFIELD,
    tags = { "Hutch_Fishbowl", "folha" },
    contents = {
        distributepercent = .3,
        distributeprefabs =
        {
            mushtree_yelow = 9.0,
            yelow_mushroom = 0.9,

            pillar_cave = 0.05,
            cavelight = 0.6,
            --			poisonmist = 8,
            rock_flippable = 0.05,
            jungle_border_vine = 0.5,
            pig_ruins_torch = 0.2,
            pig_ruins_head = 0.5,
            pig_ruins_pig = 0.5,
            pig_ruins_ant = 0.5,
        },
    }
})

-- Green mush forest
AddRoom("HamGreenMushForest", {
    colour = { r = 0.1, g = 0.8, b = 0.1, a = 0.9 },
    value = GROUND.RAINFOREST,
    tags = { "Hutch_Fishbowl", "folha" },
    contents = {
        distributepercent = .35,
        distributeprefabs =
        {
            mushtree_small = 5.0,
            green_mushroom = 3.0,
            flower_cave = 0.2,
            flower_cave_double = 0.1,
            flower_cave_triple = 0.1,

            spider_monkey_tree = 1,
            spider_monkey = 1,
            rainforesttree = 6, --4,
            pillar_cave = 1, --0.5,
            flower_rainforest = 4,
            berrybush_juicy = 2,
            cavelight = 0.6,
            deep_jungle_fern_noise = 2,
            jungle_border_vine = 2,
            fireflies = 0.2,
            hanging_vine_patch = 2,
            pig_ruins_torch = 0.02,
            rock_flippable = 0.1,
        },
    }
})

-- green
AddRoom("HamGreenMushPonds", {
    colour = { r = 0.1, g = 0.8, b = 0.3, a = 0.9 },
    value = GROUND.RAINFOREST,
    tags = { "Hutch_Fishbowl", "folha" },
    contents = {
        distributepercent = .3,
        distributeprefabs =
        {
            pond = 1,

            mushtree_small = 5.0,
            green_mushroom = 3.0,
            flower_cave = 0.2,
            flower_cave_double = 0.1,
            flower_cave_triple = 0.1,

            spider_monkey_tree = 1,
            spider_monkey = 1,
            rainforesttree = 6, --4,
            pillar_cave = 1, --0.5,
            flower_rainforest = 4,
            berrybush_juicy = 2,
            cavelight = 0.6,
            deep_jungle_fern_noise = 2,
            jungle_border_vine = 2,
            fireflies = 0.2,
            hanging_vine_patch = 2,
            pig_ruins_torch = 0.02,
            rock_flippable = 0.1,
        },
    }
})

-- Greenmush Sinkhole
AddRoom("HamGreenMushSinkhole", {
    colour = { r = 0.1, g = 0.8, b = 0.3, a = 0.9 },
    value = GROUND.RAINFOREST,
    tags = { "Hutch_Fishbowl", "folha" },
    contents = {
        countstaticlayouts = {
            ["EvergreenSinkhole"] = 1,
        },
        distributepercent = .2,
        distributeprefabs =
        {
            cavelight_small = 0.05,

            grass = 0.1,
            sapling = 0.1,
            twiggytree = 0.04,

            mushtree_small = 5.0,
            green_mushroom = 3.0,
            flower_cave = 0.2,
            flower_cave_double = 0.1,
            flower_cave_triple = 0.1,

            spider_monkey_tree = 1,
            spider_monkey = 1,
            rainforesttree = 6, --4,
            pillar_cave = 1, --0.5,
            flower_rainforest = 4,
            berrybush_juicy = 2,
            cavelight = 0.6,
            deep_jungle_fern_noise = 2,
            jungle_border_vine = 2,
            fireflies = 0.2,
            hanging_vine_patch = 2,
            pig_ruins_torch = 0.02,
            rock_flippable = 0.1,
        },
    }
})

-- green
AddRoom("HamGreenMushMeadow", {
    colour = { r = 0.1, g = 0.8, b = 0.3, a = 0.9 },
    value = GROUND.RAINFOREST,
    tags = { "Hutch_Fishbowl", "folha" },
    contents = {
        distributepercent = .25,
        distributeprefabs =
        {
            cavelight_small = 0.05,

            mushtree_small = 5.0,
            green_mushroom = 3.0,
            flower_cave = 0.2,
            flower_cave_double = 0.1,
            flower_cave_triple = 0.1,

            spider_monkey_tree = 1,
            spider_monkey = 1,
            rainforesttree = 6, --4,
            pillar_cave = 1, --0.5,
            flower_rainforest = 4,
            berrybush_juicy = 2,
            cavelight = 0.6,
            deep_jungle_fern_noise = 2,
            jungle_border_vine = 2,
            fireflies = 0.2,
            hanging_vine_patch = 2,
            pig_ruins_torch = 0.02,
            rock_flippable = 0.1,
        },
        countprefabs =
        {
            maze_pig_ruins_entrance = 1,
        },
    }
})

-- green
AddRoom("HamGreenMushRabbits", {
    colour = { r = 0.1, g = 0.8, b = 0.3, a = 0.9 },
    value = GROUND.RAINFOREST,
    tags = { "Hutch_Fishbowl", "folha" },
    contents = {
        countstaticlayouts = {
            ["farm_3"] = 1,
        },
        distributepercent = .2,
        distributeprefabs =
        {
            grass = 0.1,
            sapling = 0.1,
            twiggytree = 0.04,

            mushtree_small = 5.0,
            green_mushroom = 3.0,
            flower_cave = 0.2,
            flower_cave_double = 0.1,
            flower_cave_triple = 0.1,

            spider_monkey_tree = 1,
            spider_monkey = 1,
            rainforesttree = 6, --4,
            pillar_cave = 1, --0.5,
            flower_rainforest = 4,
            berrybush_juicy = 2,
            cavelight = 0.6,
            deep_jungle_fern_noise = 2,
            jungle_border_vine = 2,
            fireflies = 0.2,
            hanging_vine_patch = 2,
            pig_ruins_torch = 0.02,
            rock_flippable = 0.1,
        },
        countprefabs =
        {
            cavelight = 3,
            cavelight_small = 3,
            cavelight_tiny = 3,
        }
    }
})

-- Green Mush and Sinkhole Noise
AddRoom("HamGreenMushNoise", {
    colour = { r = .36, g = .32, b = .38, a = .50 },
    value = GROUND.RAINFOREST,
    tags = { "Hutch_Fishbowl", "folha" },
    contents = {
        distributepercent = .25,
        distributeprefabs =
        {
            mushtree_small = 5.0,
            green_mushroom = 3.0,
            flower_cave = 0.2,
            flower_cave_double = 0.1,
            flower_cave_triple = 0.1,

            spider_monkey_tree = 1,
            spider_monkey = 1,
            rainforesttree = 6, --4,
            pillar_cave = 1, --0.5,
            flower_rainforest = 4,
            berrybush_juicy = 2,
            cavelight = 0.6,
            deep_jungle_fern_noise = 2,
            jungle_border_vine = 2,
            fireflies = 0.2,
            hanging_vine_patch = 2,
            pig_ruins_torch = 0.02,
            rock_flippable = 0.1,
        },
    }
})

--Green
AddRoom("HamBGGreenMush", {
    colour = { r = .36, g = .32, b = .38, a = .50 },
    value = GROUND.RAINFOREST,
    tags = { "Hutch_Fishbowl", "folha" },
    contents = {
        distributepercent = .25,
        distributeprefabs =
        {
            mushtree_small = 5.0,
            green_mushroom = 3.0,
            flower_cave = 0.2,
            flower_cave_double = 0.1,
            flower_cave_triple = 0.1,

            spider_monkey_tree = 1,
            spider_monkey = 1,
            rainforesttree = 6, --4,
            pillar_cave = 1, --0.5,
            flower_rainforest = 4,
            berrybush_juicy = 2,
            cavelight = 0.6,
            deep_jungle_fern_noise = 2,
            jungle_border_vine = 2,
            fireflies = 0.2,
            hanging_vine_patch = 2,
            pig_ruins_torch = 0.02,
            rock_flippable = 0.1,
        },
    }
})

-- Blue mush forest
AddRoom("HamBlueMushForest", {
    colour = { r = 0.1, g = 0.1, b = 0.8, a = 0.9 },
    value = GROUND.MEADOW,
    tags = { "Hutch_Fishbowl" },
    contents = {
        distributepercent = .5,
        distributeprefabs =
        {
            mushtree_tall = 4.0,
            blue_mushroom = 0.5,
            flower_cave = 0.1,
            flower_cave_double = 0.05,
            flower_cave_triple = 0.05,

            sapling = 1,
            grass_tall = 3,
            ox = 0.5,
            teatree = 0.8,
            teatree_piko_nest_patch = 0.5,
        },
    }
})

-- Blue mush forest
AddRoom("HamBlueMushMeadow", {
    colour = { r = 0.1, g = 0.1, b = 0.8, a = 0.9 },
    value = GROUND.MEADOW,
    tags = { "Hutch_Fishbowl" },
    contents = {
        distributepercent = .3,
        distributeprefabs =
        {
            mushtree_tall = 1.0,
            blue_mushroom = 0.5,
            flower_cave = 0.1,
            flower_cave_double = 0.05,
            flower_cave_triple = 0.05,

            sapling = 1,
            grass_tall = 3,
            ox = 0.5,
            teatree = 0.8,
            teatree_piko_nest_patch = 0.5,
        },
    }
})

-- Blue mush forest
AddRoom("HamBlueSpiderForest", {
    colour = { r = 0.1, g = 0.1, b = 0.8, a = 0.9 },
    value = GROUND.MEADOW,
    tags = { "Hutch_Fishbowl" },
    contents = {
        countstaticlayouts = {
            ["mandraketown"] = 1,
        },


        distributepercent = .3,
        distributeprefabs =
        {
            mushtree_tall = 3.0,
            blue_mushroom = 0.5,
            flower_cave = 0.1,
            flower_cave_double = 0.05,
            flower_cave_triple = 0.05,

            sapling = 1,
            grass_tall = 3,
            ox = 0.5,
            teatree = 0.8,
            teatree_piko_nest_patch = 0.5,
        },
        countprefabs =
        {
            cavelight = 3,
            cavelight_small = 3,
            cavelight_tiny = 3,
        }
    }
})

-- Blue mush forest
AddRoom("HamDropperDesolation", {
    colour = { r = 0.1, g = 0.1, b = 0.8, a = 0.9 },
    value = GROUND.MEADOW,
    tags = { "Hutch_Fishbowl" },
    contents = {
        distributepercent = .2,
        distributeprefabs =
        {
            mushtree_tall = 1.0,
            blue_mushroom = 0.5,
            flower_cave = 0.1,
            flower_cave_double = 0.05,
            flower_cave_triple = 0.05,

            sapling = 1,
            grass_tall = 3,
            ox = 0.5,
            teatree = 0.8,
            teatree_piko_nest_patch = 0.5,
        },
    }
})

-- Blue mush forest
AddRoom("HamBGBlueMush", {
    colour = { r = 0.1, g = 0.1, b = 0.8, a = 0.9 },
    value = GROUND.MEADOW,
    tags = { "Hutch_Fishbowl" },
    contents = {
        distributepercent = .5,
        distributeprefabs =
        {
            mushtree_tall = 5.0,
            blue_mushroom = 0.5,
            flower_cave = 0.1,
            flower_cave_double = 0.05,
            flower_cave_triple = 0.05,

            sapling = 1,
            grass_tall = 3,
            ox = 0.5,
            teatree = 0.8,
            teatree_piko_nest_patch = 0.5,
        },
    }
})


-- vampire
AddRoom("HamSpillagmiteForest", {
    colour = { r = 0.4, g = 0.4, b = 0.4, a = 0.9 },
    value = GROUND.FUNGUS,
    tags = { "Hutch_Fishbowl" },
    contents = {
        distributepercent = .35,
        distributeprefabs =
        {
            flower_cave_triple = 0.1,
            pillar_cave_rock = 0.1,

            rock1 = 0.1,
            flint = 0.1,
            deco_cave_ceiling_trim = 0.3,
            deco_cave_beam_room = 0.3,
            stalagmite = 0.3,
            stalagmite_tall = 0.3,
            deco_cave_stalactite = 0.3,
            rocks = 0.3,
            twigs = 1,
            cave_fern = 0.8,
            deco_cave_bat_burrow = 0.2,
            mushtree_medium = 1.0,
            spiderhole = 0.1,
        },
    }
})

-- vampire
AddRoom("HamDropperCanyon", {
    colour = { r = 0.4, g = 0.4, b = 0.4, a = 0.9 },
    value = GROUND.FUNGUS,
    tags = { "Hutch_Fishbowl" },
    contents = {
        distributepercent = .35,
        distributeprefabs =
        {
            flower_cave_triple = 0.1,
            pillar_cave_rock = 0.1,

            rock1 = 0.1,
            flint = 0.1,
            deco_cave_ceiling_trim = 0.3,
            deco_cave_beam_room = 0.3,
            stalagmite = 0.3,
            stalagmite_tall = 0.3,
            deco_cave_stalactite = 0.3,
            rocks = 0.3,
            twigs = 1,
            cave_fern = 0.8,
            deco_cave_bat_burrow = 0.2,
            mushtree_medium = 1.0,
            spiderhole = 0.1,
        },
    }
})

-- vampire
AddRoom("HamStalagmitesAndLights", {
    colour = { r = 0.4, g = 0.4, b = 0.4, a = 0.9 },
    value = GROUND.FUNGUS,
    tags = { "Hutch_Fishbowl" },
    contents = {
        distributepercent = .15,
        distributeprefabs =
        {
            flower_cave_triple = 0.1,
            pillar_cave_rock = 0.1,

            rock1 = 0.1,
            flint = 0.1,
            deco_cave_ceiling_trim = 0.3,
            deco_cave_beam_room = 0.3,
            stalagmite = 0.3,
            stalagmite_tall = 0.3,
            deco_cave_stalactite = 0.3,
            rocks = 0.3,
            twigs = 1,
            cave_fern = 0.8,
            deco_cave_bat_burrow = 0.2,
            mushtree_medium = 1.0,
            spiderhole = 0.1,
        },
    }
})

-- red
AddRoom("HamSpidersAndBats", {
    colour = { r = 0.4, g = 0.4, b = 0.4, a = 0.9 },
    value = GROUND.QUAGMIRE_PARKFIELD,
    tags = { "Hutch_Fishbowl" },
    contents = {
        distributepercent = .20,
        distributeprefabs =
        {
            flower_cave_triple = 0.1,
            pillar_cave_rock = 0.1,

            rock1 = 0.1,
            flint = 0.1,
            roc_nest_tree1 = 0.1,
            roc_nest_tree2 = 0.1,
            roc_nest_branch1 = 0.5,
            roc_nest_branch2 = 0.5,
            roc_nest_bush = 1,
            rocks = 0.5,
            twigs = 1,
            rock2 = 0.1,
            dropperweb = 0.2,
            mushtree_medium = 2.0,
        },
    }
})

-- red
AddRoom("HamThuleciteDebris", {
    colour = { r = 0.4, g = 0.4, b = 0.4, a = 0.9 },
    value = GROUND.QUAGMIRE_PARKFIELD,
    tags = { "Hutch_Fishbowl" },
    contents = {
        distributepercent = .20,
        distributeprefabs =
        {
            flower_cave_triple = 0.1,
            pillar_cave_rock = 0.1,

            rock1 = 0.1,
            flint = 0.1,
            roc_nest_tree1 = 0.1,
            roc_nest_tree2 = 0.1,
            roc_nest_branch1 = 0.5,
            roc_nest_branch2 = 0.5,
            roc_nest_bush = 1,
            rocks = 0.5,
            twigs = 1,
            rock2 = 0.1,
            dropperweb = 0.2,
            mushtree_medium = 2.0,
        },
    }
})

-- red
AddRoom("HamBGSpillagmite", {
    colour = { r = 0.4, g = 0.4, b = 0.4, a = 0.9 },
    value = GROUND.QUAGMIRE_PARKFIELD,
    tags = { "Hutch_Fishbowl" },
    contents = {
        distributepercent = .35,
        distributeprefabs =
        {
            flower_cave_triple = 0.1,
            pillar_cave_rock = 0.1,

            rock1 = 0.1,
            flint = 0.1,
            roc_nest_tree1 = 0.1,
            roc_nest_tree2 = 0.1,
            roc_nest_branch1 = 0.5,
            roc_nest_branch2 = 0.5,
            roc_nest_bush = 1,
            rocks = 0.5,
            twigs = 1,
            rock2 = 0.1,
            --		   dropperweb= 0.2,
            mushtree_medium = 2.0,
        },
    }
})

-- red não usado
AddRoom("HamCaveExitRoom", {
    colour = { r = .25, g = .28, b = .25, a = .50 },
    value = GROUND.QUAGMIRE_PARKFIELD,
    contents = {
        countstaticlayouts = {
            ["CaveExit"] = 1,
        },
        distributepercent = .2,
        distributeprefabs =
        {
            flower_cave_triple = 0.1,
            pillar_cave_rock = 0.1,

            rock1 = 0.1,
            flint = 0.1,
            roc_nest_tree1 = 0.1,
            roc_nest_tree2 = 0.1,
            roc_nest_branch1 = 0.5,
            roc_nest_branch2 = 0.5,
            roc_nest_bush = 1,
            rocks = 0.5,
            twigs = 1,
            rock2 = 0.1,
            --		   tallbirdnest= 0.2,
            mushtree_medium = 2.0,
        }
    }
})
---------------
---------------------------------------------------------creep in the deeps------------------------------------
AddTask("underwaterdivide", {
    locks = { LOCKS.LAND_DIVIDE_3 },
    keys_given = { KEYS.LAND_DIVIDE_4 },
    room_choices = {
        ["ForceDisconnectedRoom"] = 20,
    },
    level_set_piece_blocker = true,
    entrance_room = "VolcanoObsidian",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddRoom("VolcanoObsidian", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.BEARDRUG,
    tags = { "RoadPoison", "tropical" },
    contents = {
        --									countstaticlayouts={["beaverking"]=1}, --adds 1 per room
        distributepercent = .2,
        distributeprefabs =
        {
            magmarock = .5,
            magmarock_gold = .5,
            rock_obsidian = .3,
            rock_charcoal = .3,
            volcano_shrub = .2,
            charcoal = 0.04,
            skeleton = 0.1,
            dragoonden = .05,
            elephantcactus = 0.1,
            --coffeebush = 1,
        },

        countprefabs =
        {
            volcanofog = math.random(1, 2)
        },
    }
})

AddTask("UnderwaterStart", {
    locks = LOCKS.LAND_DIVIDE_4,
    keys_given = { KEYS.JUNGLE_DEPTH_1, KEYS.JUNGLE_DEPTH_2, KEYS.JUNGLE_DEPTH_3, },

    room_choices = {
        ["SandyBottom"] = math.random(2),
        ["SandyBottomCoralPatch"] = (math.random() > 0.5 and 1) or 0,
        ["startPatch"] = 1,
    },
    level_set_piece_blocker = true,
    room_bg = GROUND.UNDERWATER_SANDY,
    background_room = "bg_SandyBottom",
    colour = { r = 0, g = 0, b = 0, a = 0 },
})

AddTask("SandyBiome", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = { KEYS.OTHER_JUNGLE_DEPTH_1 },

    room_choices = {
        ["SandyBottom"] = math.random(2),
        ["SandyBottomTreasureTrove"] = (math.random() > 0.5 and 1) or 0,
        ["SandyBottomCoralPatch"] = 1,
    },
    level_set_piece_blocker = true,
    room_bg = GROUND.UNDERWATER_SANDY,
    background_room = "bg_SandyBottom",
    colour = { r = 0, g = 0, b = 0, a = 0 },
})

AddTask("ReefBiome", {
    locks = LOCKS.JUNGLE_DEPTH_2,
    keys_given = { KEYS.OTHER_JUNGLE_DEPTH_2 },

    room_choices = {
        ["CoralReef"] = math.random(2),
        ["CoralReefLight"] = (math.random() > 0.5 and 1) or 0,
        ["CoralReefJunked"] = 1,
    },
    level_set_piece_blocker = true,
    room_bg = GROUND.UNDERWATER_SANDY,
    background_room = "bg_CoralReef",
    colour = { r = 0, g = 0, b = 0, a = 0 },
})

AddTask("KelpBiome", {
    locks = LOCKS.JUNGLE_DEPTH_3,
    keys_given = { KEYS.LOST_JUNGLE_DEPTH_2 },

    room_choices = {
        ["KelpForest"] = math.random(2),
        ["KelpForestInfested"] = (math.random() > 0.5 and 1) or 0,
        ["KelpForestLight"] = 1,
    },
    level_set_piece_blocker = true,
    room_bg = GROUND.UNDERWATER_SANDY,
    background_room = "bg_KelpForest",
    colour = { r = 0, g = 0, b = 0, a = 0 },
})

AddTask("RockyBiome", {
    locks = LOCKS.OTHER_JUNGLE_DEPTH_1,
    keys_given = { KEYS.PINACLE },

    room_choices = {
        ["RockyBottom"] = math.random(2),
        ["RockyBottomBroken"] = 1,
    },
    level_set_piece_blocker = true,
    room_bg = GROUND.UNDERWATER_ROCKY,
    background_room = "bg_RockyBottom",
    colour = { r = 0, g = 0, b = 0, a = 0 },
})

AddTask("MoonBiome", {
    locks = LOCKS.PINACLE,
    keys_given = { KEYS.WILD_JUNGLE_DEPTH_2 },

    room_choices = {
        ["LunnarBottom"] = 2,
        ["LunnarBottomBroken"] = 1,
        ["Lunnarrocks"] = 1,
        ["Lunnarrocksgnar"] = 1,
    },
    level_set_piece_blocker = true,
    room_bg = GROUND.PEBBLEBEACH,
    background_room = "bg_LunnarBottom",
    colour = { r = 0, g = 0, b = 0, a = 0 },
})

AddTask("OpenWaterBiome", {
    locks = LOCKS.OTHER_JUNGLE_DEPTH_1,
    keys_given = { KEYS.PINACLE },

    entrance_room = "TidalZoneEntrance",
    room_choices = {
        ["TidalZone"] = math.random(2),
    },
    level_set_piece_blocker = true,
    room_bg = GROUND.UNDERWATER_SANDY,
    background_room = "bg_TidalZone",
    colour = { r = 0, g = 0, b = 0, a = 0 },
})

AddTask("UnderwaterExit1", {
    locks = LOCKS.WILD_JUNGLE_DEPTH_2,
    keys_given = { KEYS.WILD_JUNGLE_DEPTH_2, },

    room_choices = {
        ["SandyBottom"] = math.random(2),
        ["SandyBottomCoralPatch"] = (math.random() > 0.5 and 1) or 0,
        ["exitPatch1"] = 1,
    },
    level_set_piece_blocker = true,
    room_bg = GROUND.UNDERWATER_SANDY,
    background_room = "bg_SandyBottom",
    colour = { r = 0, g = 0, b = 0, a = 0 },
})
-----------------------

AddTask("EntranceToReef", {
    locks = { LOCKS.SPIDERS_DEFEATED },
    keys_given = { KEYS.SPIDERS },

    room_choices = {
        ["UnderwaterEntrance"] = 1,
    },
    room_bg = GROUND.FOREST,
    background_room = "BGGrass",
    colour = { r = 0, g = 0, b = 0, a = 0 },
})


-------------new tasks-------------------------------------------------------
AddTask("task_underground_beach", {
    locks = LOCKS.OTHER_JUNGLE_DEPTH_2,
    keys_given = { KEYS.CIVILIZATION_1 },
    room_choices = {
        ["beach1"] = 1,
        ["beach2"] = 1,
        ["beach_crab"] = 1,
    },
    level_set_piece_blocker = true,
    room_bg = GROUND.UNDERWATER_SANDY,
    background_room = "beach_bg",
    colour = { r = 0, g = 1, b = 0, a = 1 }
})

AddTask("task_underwatermagmafield", {
    locks = LOCKS.OTHER_JUNGLE_DEPTH_2,
    keys_given = { KEYS.CIVILIZATION_1 },
    room_choices = {
        ["underwatermagmafield1"] = 2,
        ["underwatermagmafield"] = 1,
    },
    level_set_piece_blocker = true,
    room_bg = GROUND.UNDERWATER_ROCKY,
    background_room = "underwatermagmafield",
    colour = { r = 0, g = 1, b = 0, a = 1 }
})

AddTask("task_underwater_kraken_zone", {
    locks = LOCKS.CIVILIZATION_1,
    keys_given = { KEYS.OTHER_CIVILIZATION_1 },
    room_choices = {
        ["kraken_zone"] = 1,
        ["kraken_zone_basic"] = 2,
    },
    level_set_piece_blocker = true,
    room_bg = GROUND.IMPASSABLE,
    background_room = "kraken_zone_bg",
    colour = { r = 0, g = 1, b = 0, a = 1 }
})

AddTask("secretcavedivisor", {
    locks = LOCKS.OTHER_CIVILIZATION_1,
    keys_given = KEYS.WILD_JUNGLE_DEPTH_1,
    room_choices = {
        ["ForceDisconnectedRoom"] = 6,
    },
    level_set_piece_blocker = true,
    entrance_room = "cave_underwater1_entrance",
    room_bg = GROUND.UNDERWATER_ROCKY,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("task_secretcave1", {
    locks = LOCKS.WILD_JUNGLE_DEPTH_1,
    keys_given = KEYS.WILD_JUNGLE_DEPTH_1,
    room_choices = {
        ["cave_underwater1_part1"] = 1,
        --			["cave_underwater1_part2"] =  1, 			
    },
    level_set_piece_blocker = true,
    --		entrance_room = "ForceDisconnectedRoom",		
    room_bg = GROUND.IMPASSABLE,
    background_room = "cave_underwater_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})

AddTask("atlantidaExitRoom", {
    locks = { LOCKS.ENTRANCE_INNER, LOCKS.ENTRANCE_OUTER },
    keys_given = {},
    room_choices =
    {
        ["atlantidaExitRoom"] = 1,
    },
    room_bg = GROUND.SNOWLAND,
    background_room = "BGSinkhole",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("task_underwaterlavarock", {
    locks = LOCKS.LOST_JUNGLE_DEPTH_2,
    keys_given = { KEYS.CIVILIZATION_2 },
    room_choices = {
        ["underwaterlavarock"] = 3,
    },
    level_set_piece_blocker = true,
    room_bg = GROUND.UNDERWATER_ROCKY,
    background_room = "underwaterlavarock",
    colour = { r = 0, g = 1, b = 0, a = 1 }
})

AddTask("task_underwaterothers", {
    locks = LOCKS.LOST_JUNGLE_DEPTH_2,
    keys_given = { KEYS.CIVILIZATION_2 },
    room_choices = {
        ["underwaterothers_lobster"] = 1,
        ["underwaterothers_basic"] = 2,
    },
    level_set_piece_blocker = true,
    room_bg = GROUND.UNDERWATER_SANDY,
    background_room = "underwaterothers_bg",
    colour = { r = 0, g = 1, b = 0, a = 1 }
})

AddTask("task_underwaterwatercoral", {
    locks = LOCKS.CIVILIZATION_2,
    keys_given = { KEYS.OTHER_CIVILIZATION_2 },
    room_choices = {
        ["underwaterwatercoral_octopus"] = 1,
        ["underwaterwatercoral"] = 2,

    },
    level_set_piece_blocker = true,
    room_bg = GROUND.PAINTED,
    background_room = "underwaterwatercoral_bg",
    colour = { r = 0, g = 1, b = 0, a = 1 }
})

AddTask("UnderwaterExit2", {
    locks = LOCKS.OTHER_CIVILIZATION_2,
    keys_given = { KEYS.OTHER_CIVILIZATION_2, },

    room_choices = {
        ["SandyBottom"] = math.random(2),
        ["SandyBottomCoralPatch"] = (math.random() > 0.5 and 1) or 0,
        ["exitPatch2"] = 1,
    },
    level_set_piece_blocker = true,
    room_bg = GROUND.UNDERWATER_SANDY,
    background_room = "bg_SandyBottom",
    colour = { r = 0, g = 0, b = 0, a = 0 },
})

---------------------new creeps rooms-------------------------------
AddRoom("beach1", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = GROUND.BEACH,
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
    value = GROUND.BEACH,
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
    value = GROUND.BEACH,
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
    value = GROUND.BEACH,
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


AddRoom("underwaterothers_lobster", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.UNDERWATER_SANDY,
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
            spongea = .2,
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
    value = GROUND.UNDERWATER_SANDY,
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
            spongea = .2,
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
    value = GROUND.UNDERWATER_SANDY,
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
            spongea = .2,
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

AddRoom("kraken_zone_basic", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2)) end,
            sunkenchest_spawner = function() return (math.random(2) - 1) end,
        },
        distributepercent = .25,
        distributeprefabs =
        {
            spongea = .2,
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
    value = GROUND.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2) - 1) end,
            krakenunderwater = 1,
        },
        distributepercent = .25,
        distributeprefabs =
        {
            spongea = .2,
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
    value = GROUND.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2)) end,
        },
        distributepercent = .25,
        distributeprefabs =
        {
            spongea = .2,
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

AddRoom("cave_underwater1_entrance", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.UNDERWATER_ROCKY,
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


AddRoom("cave_underwater1_part1", {
    colour = { r = .25, g = .28, b = .25, a = .50 },
    value = GROUND.UNDERWATER_ROCKY,
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

AddRoom("atlantidaExitRoom", {
    colour = { r = .25, g = .28, b = .25, a = .50 },
    value = GROUND.SINKHOLE,
    contents = {
        countprefabs = { underwater_entrance3 = 1, },
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


AddRoom("cave_underwater1_part2", {
    colour = { r = 0.3, g = 0.2, b = 0.1, a = 0.3 },
    value = GROUND.UNDERWATER_ROCKY,
    tags = { "RoadPoison" },
    contents = {
        distributepercent = .15,
        distributeprefabs =
        {
            stalagmite = 0.15,
            stalagmite_med = 0.15,
            stalagmite_low = 0.15,
            pillar_cave = 0.08,
            fissure = 0.05,
        }
    }
})

AddRoom("cave_underwater_base", {
    colour = { r = 0, g = 0, b = 0, a = 0.9 },
    value = GROUND.UNDERWATER_ROCKY,
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

AddRoom("underwaterlavarock", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.UNDERWATER_ROCKY,
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
            spongea = .2,
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
    value = GROUND.MAGMAFIELD,
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
    value = GROUND.MAGMAFIELD,
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
            --									squid = 0.002,
            bubble_vent = 0.01,
            shrimp = 0.1,
            --									bioluminescence = 0.03,		
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },

    }
})


AddRoom("underwaterwatercoral", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.PAINTED,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2)) end,
            coral_brain_rockunderwater = 1,
        },
        distributepercent = .25,
        distributeprefabs =
        {
            spongea = .2,
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

AddRoom("underwaterwatercoral_octopus", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.PAINTED,
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
            spongea = .2,
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
    value = GROUND.PAINTED,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2)) end,
            coral_brain_rockunderwater = 1,
        },
        distributepercent = .25,
        distributeprefabs =
        {
            spongea = .2,
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
------------------------------------------------------------------------------------------
-- Sandy rooms
------------------------------------------------------------------------------------------	

AddRoom("SandyBottom", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = GROUND.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
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

AddRoom("startPatch", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = GROUND.UNDERWATER_SANDY,
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

AddRoom("exitPatch1", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = GROUND.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            underwater_exit1 = 1,
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

AddRoom("exitPatch2", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = GROUND.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            underwater_exit2 = 1,
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
            rainbowjellyfish_underwater = 0.01,
            sea_cucumber = 0.1,
            commonfish = 0.1,
            shrimp = 0.2,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
            uw_flowers = 0.1,
        },
    },
})

AddRoom("SandyBottomTreasureTrove", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = GROUND.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2) - 1) end,
            sunkenchest_spawner = function() return (math.random(2) - 1) end,
        },

        distributepercent = 0.3,
        distributeprefabs = {
            seagrass = 0.35,
            sandstone_boulder = 0.01,
            uw_coral = 0.4,
            uw_coral_blue = 0.3,
            uw_coral_green = 0.3,
            --			seatentacle = 0.01,
            rotting_trunk = 0.2,
            bubble_vent = 0.03,
            kelpunderwater = 0.5,
            squidunderwater = 0.001,
            flower_sea = 0.1,
            decorative_shell = 0.05,
            wormplant = 0.1,
            sea_eel = 0.2,
            clam = 0.06,
            sponge = 0.25,
            sea_cucumber = 0.1,
            commonfish = 0.1,
            shrimp = 0.1,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
            uw_flowers = 0.1,
        },
    },
})

AddRoom("SandyBottomCoralPatch", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = GROUND.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2) - 1) end,
        },

        distributepercent = 0.3,
        distributeprefabs = {
            seagrass = 0.01,
            sandstone_boulder = 0.1,
            uw_coral = 0.25,
            uw_coral_blue = 0.25,
            uw_coral_green = 0.25,
            reef_jellyfish = 0.1,
            bubble_vent = 0.03,
            kelpunderwater = 0.2,
            squidunderwater = 0.001,
            flower_sea = 0.1,
            decorative_shell = 0.2,
            wormplant = 0.1,
            clam = 0.06,
            sponge = 0.25,
            sea_cucumber = 0.3,
            commonfish = 0.1,
            shrimp = 0.1,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
            uw_flowers = 0.1,
        },
    },
})

------------------------------------------------------------------------------------------
-- Reef rooms
------------------------------------------------------------------------------------------	

AddRoom("CoralReef", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = GROUND.UNDERWATER_SANDY,
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

AddRoom("CoralReefJunked", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = GROUND.UNDERWATER_SANDY,
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

AddRoom("CoralReefLight", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = GROUND.UNDERWATER_SANDY,
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

------------------------------------------------------------------------------------------
-- Kelp rooms
------------------------------------------------------------------------------------------

AddRoom("KelpForest", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = GROUND.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        distributepercent = 0.6,
        distributeprefabs = {
            kelpunderwater = 2.5,
            rotting_trunk = 0.01,
            seagrass = 0.005,
            sandstone_boulder = 0.0008,
            squidunderwater = 0.001,
            flower_sea = 0.1,
            sea_eel = 0.001,
            bubble_vent = 0.03,
            commonfish = 0.2,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },
    },
})

AddRoom("KelpForestLight", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = GROUND.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2) - 1) end,
            sunkenchest_spawner = function() return (math.random(2) - 1) end,
        },
        distributepercent = 0.6,
        distributeprefabs = {
            kelpunderwater = 0.5,
            rotting_trunk = 0.05,
            seagrass = 0.005,
            sandstone_boulder = 0.0008,
            --			mermworkerhouse = 0.02,
            squidunderwater = 0.0001,
            --			seatentacle = 0.0001,
            flower_sea = 0.1,
            sea_eel = 0.002,
            bubble_vent = 0.03,
            commonfish = 0.05,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },
    },
})

AddRoom("KelpForestInfested", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = GROUND.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        distributepercent = 0.6,
        distributeprefabs = {
            kelpunderwater = 2.5,
            rotting_trunk = 0.01,
            seagrass = 0.005,
            sandstone_boulder = 0.008,
            reef_jellyfish = 0.2,
            squidunderwater = 0.005,
            flower_sea = 0.1,
            sea_eel = 0.001,
            rainbowjellyfish_underwater = 0.01,
            bubble_vent = 0.03,
            commonfish = 0.15,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },
    },
})


------------------------------------------------------------------------------------------
-- Rocky rooms
------------------------------------------------------------------------------------------	

AddRoom("RockyBottom", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = GROUND.UNDERWATER_ROCKY,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2)) end,
        },

        distributepercent = 0.225,
        distributeprefabs = {
            rock1 = 0.1,
            rock2 = 0.05,
            iron_boulder = 0.4,
            squidunderwater = 0.002,
            lava_stone = 0.005,
            sponge = 0.001,
            bubble_vent = 0.01,
            commonfish = 0.1,
            shrimp = 0.1,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },
    },
})

AddRoom("RockyBottomBroken", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = GROUND.UNDERWATER_ROCKY,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2)) end,
        },

        distributepercent = 0.15,
        distributeprefabs = {
            rocks = 0.1,
            rock1 = 0.1,
            rock2 = 0.05,
            iron_ore = 0.03,
            iron_boulder = 0.4,
            squidunderwater = 0.002,
            lava_stone = 0.005,
            sponge = 0.001,
            bubble_vent = 0.01,
            commonfish = 0.1,
            shrimp = 0.1,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },
    },
})

------------------------------------------------------------------------------------------
-- Lunnar rooms
------------------------------------------------------------------------------------------	

AddRoom("LunnarBottom", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = GROUND.PEBBLEBEACH,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2)) end,
        },

        distributepercent = 0.3,
        distributeprefabs = {
            squidunderwater = 0.002,
            lava_stone = 0.005,
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
    value = GROUND.PEBBLEBEACH,
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
            lava_stone = 0.005,
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
    value = GROUND.PEBBLEBEACH,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            geothermal_vent = function() return (math.random(2)) end,
        },

        distributepercent = 0.3,
        distributeprefabs = {
            iron_boulder = 0.4,
            squidunderwater = 0.002,
            lava_stone = 0.005,
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
    value = GROUND.PEBBLEBEACH,
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
            lava_stone = 0.005,
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
    value = GROUND.PEBBLEBEACH,
    tags = { "RoadPoison" },
    contents = {
        distributepercent = 0.20,
        distributeprefabs = {
            squidunderwater = 0.002,
            lava_stone = 0.005,
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
------------------------------------------------------------------------------------------
-- Open water rooms
------------------------------------------------------------------------------------------	

AddRoom("TidalZoneEntrance", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = GROUND.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        distributepercent = 0.7,
        distributeprefabs = {
            seagrass = 0.05,
            sandstone = 0.35,
            uw_coral = 0.01,
            uw_coral_blue = 0.01,
            uw_coral_green = 0.01,
            cut_orange_coral = 0.1,
            tidal_node = 5,
            sponge = 0.01,
            bubble_vent = 0.03,
            commonfish = 0.05,
            shrimp = 0.1,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },
    },
})

AddRoom("TidalZone", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = GROUND.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        distributepercent = 0.7,
        distributeprefabs = {
            seagrass = 0.25,
            sandstone = 0.45,
            uw_coral = 0.04,
            uw_coral_blue = 0.04,
            uw_coral_green = 0.04,
            cut_orange_coral = 0.3,
            tidal_node = 5,
            squidunderwater = 0.008,
            sponge = 0.03,
            bubble_vent = 0.03,
            commonfish = 0.05,
            shrimp = 0.1,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },
    },
})


------------------------------------------------------------------------------------------
-- Background rooms
------------------------------------------------------------------------------------------	

AddRoom("bg_SandyBottom", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = GROUND.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        distributepercent = 0.25,
        distributeprefabs = {
            seagrass = 0.15,
            uw_coral = 0.02,
            uw_coral_blue = 0.03,
            uw_coral_green = 0.03,
            kelpunderwater = 0.01,
            commonfish = 0.1,
            shrimp = 0.1,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
            uw_flowers = 0.1,
        },
    },
})

AddRoom("bg_CoralReef", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = GROUND.UNDERWATER_SANDY,
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

AddRoom("bg_KelpForest", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = GROUND.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        distributepercent = 0.8,
        distributeprefabs = {
            kelpunderwater = 2.5,
            rotting_trunk = 0.01,
            seagrass = 0.005,
            sandstone_boulder = 0.0008,
            flower_sea = 0.1,
            commonfish = 0.1,
            shrimp = 0.1,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },
    },
})

AddRoom("bg_RockyBottom", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = GROUND.UNDERWATER_ROCKY,
    tags = { "RoadPoison" },
    contents = {
        distributepercent = 0.15,
        distributeprefabs = {
            rock1 = 0.1,
            rock2 = 0.05,
            iron_boulder = 0.4,
            squidunderwater = 0.002,
            lava_stone = 0.005,
            sponge = 0.001,
            bubble_vent = 0.01,
            commonfish = 0.1,
            shrimp = 0.1,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },
    },
})

AddRoom("bg_TidalZone", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = GROUND.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        distributepercent = 0.9,
        distributeprefabs = {
            seagrass = 0.25,
            sandstone = 0.45,
            uw_coral = 0.1,
            uw_coral_blue = 0.1,
            uw_coral_green = 0.1,
            cut_orange_coral = 0.3,
            tidal_node = 5,
            commonfish = 0.05,
            rainbowjellyfish_underwater = 0.01,
            shrimp = 0.1,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
        },
    },
})



------------------------------------------------------------------------------------------
-- Underwater Entrance
------------------------------------------------------------------------------------------

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
            --reeds = 1,
            --evergreen_sparse = .5,
        }
    }
})
--------------------------------cherry----------------------------
if GLOBAL.KnownModIndex:IsModEnabled("workshop-1289779251") then
    AddTask("cherry_mainland", {
        locks = LOCKS.JUNGLE_DEPTH_1,
        keys_given = { KEYS.JUNGLE_DEPTH_1 },
        room_tags = { "cherryarea" },
        room_choices = {
            ["CherryForest"] = 5,
            ["CherryBugs"] = 2,

            ["CherrySpawn"] = 1,
            ["CherryTrees"] = 1,
            ["CherryDeepForest"] = 1,

            ["CherryVillage"] = 1,
        },
        room_bg = GROUND.CHERRY,
        background_room = "BGCherry",
        colour = { r = .5, g = 0.6, b = .080, a = .10 },
    })
end
-----------------------------------------------------
local function LevelPreInit(level)
    if level.location == "cave" and GetModConfigData("togethercaves_hamletworld") == 0 then
        if not TUNING.tropical.underwater then
            level.tasks = {}
            level.numoptionaltasks = 0
            level.set_pieces = {}
        end
    end

    -----------------------------underwater----------------------------------------
    if TUNING.tropical.underwater then
        if level.location == "cave" then
            level.overrides.keep_disconnected_tiles = true
            table.insert(level.tasks, "separavulcao")
            table.insert(level.tasks, "underwaterdivide")
            table.insert(level.tasks, "UnderwaterStart")
            table.insert(level.tasks, "SandyBiome")
            table.insert(level.tasks, "ReefBiome")
            table.insert(level.tasks, "KelpBiome")
            table.insert(level.tasks, "RockyBiome")
            table.insert(level.tasks, "MoonBiome")
            table.insert(level.tasks, "OpenWaterBiome")
            table.insert(level.tasks, "task_underground_beach")
            table.insert(level.tasks, "task_underwaterothers")
            table.insert(level.tasks, "task_underwater_kraken_zone")
            table.insert(level.tasks, "secretcavedivisor")
            table.insert(level.tasks, "task_secretcave1")
            table.insert(level.tasks, "atlantidaExitRoom")
            table.insert(level.tasks, "task_underwaterlavarock")
            table.insert(level.tasks, "task_underwatermagmafield")
            table.insert(level.tasks, "task_underwaterwatercoral")
            table.insert(level.tasks, "UnderwaterExit2")
        end
    end
    ---------------------------------------------------------------------



    -----------------------------hamlet caves----------------------------------------
    if TUNING.tropical.hamlet_caves then
        if level.location == "cave" then
            level.overrides.keep_disconnected_tiles = true
            table.insert(level.tasks, "separavulcao")

            table.insert(level.tasks, "separahamcave")
            table.insert(level.tasks, "HamMudWorld")
            table.insert(level.tasks, "HamMudCave")
            table.insert(level.tasks, "HamMudLights")
            table.insert(level.tasks, "HamMudPit")

            table.insert(level.tasks, "HamBigBatCave")
            table.insert(level.tasks, "HamRockyLand")
            table.insert(level.tasks, "HamRedForest")
            table.insert(level.tasks, "HamGreenForest")
            table.insert(level.tasks, "HamBlueForest")
            table.insert(level.tasks, "HamSpillagmiteCaverns")
            table.insert(level.tasks, "HamSpillagmiteCaverns1")
            table.insert(level.tasks, "caveruinsexit")
            table.insert(level.tasks, "caveruinsexit2")

            table.insert(level.tasks, "HamMoonCaveForest")
            table.insert(level.tasks, "HamArchiveMaze")
        end
    end
    -------------------------------------------------------------------------------------------------------
    if level.location == "forest" then
        level.overrides.start_location = "porkland_start"
        level.random_set_pieces =
        {
        }
        level.numrandom_set_pieces = 0
        level.ordered_story_setpieces =
        {

        }
        --    level.islands = "always"
        level.overrides.has_ocean = false
        level.overrides.keep_disconnected_tiles = true
        level.location = "forest"
    end
end

AddLevelPreInitAny(LevelPreInit)


local function TasksetPreInit(taskset)
    if taskset.location ~= "forest" then return end
    taskset.tasks = {
        "inicio",
        "Pigtopia",
        "Pigtopia_capital",
        "Edge_of_civilization",
        "Edge_of_the_unknown",
        "Edge_of_the_unknown_2",
        "Lilypond_land",
        "Lilypond_land_2",
        "Deep_rainforest",
        "Deep_rainforest_2",
        "Deep_lost_ruins_gas",
        "Lost_Ruins_1",

        "Deep_rainforest_3",
        "Deep_rainforest_mandrake",
        "Path_to_the_others",
        "Other_pigtopia_capital",
        "Other_pigtopia",
        "Other_edge_of_civilization",
        "this_is_how_you_get_ants",

        "Deep_lost_ruins4",
        "lost_rainforest",
        --			"interior_space",

        "Land_Divide_1",
        "Land_Divide_2",
        "Land_Divide_3",
        "Land_Divide_4",

        "painted_sands",
        "plains",
        "rainforests",
        "rainforest_ruins",
        "plains_ruins",
        "pincale",

        "Deep_wild_ruins4",
        "wild_rainforest",
        "wild_ancient_ruins",
        --            "Land_Divide_5",			
    }

    taskset.numoptionaltasks = 0
    taskset.optionaltasks =
    {

    }

    taskset.ocean_prefill_setpieces = {}

    taskset.ocean_population = {}


    taskset.valid_start_tasks = {
        "inicio",
    }


    taskset.set_pieces = {}



    -----------------------------umcompromissing-----------------------------------------------------		
    if GLOBAL.KnownModIndex:IsModEnabled("workshop-2039181790") then
        table.insert(taskset.tasks, "GiantTrees")
    end
    -----------------------------cherry forest-----------------------------------------------------
    if GLOBAL.KnownModIndex:IsModEnabled("workshop-1289779251") then
        table.insert(taskset.tasks, "cherry_mainland")
    end



    if GetModConfigData("togethercaves_hamletworld") == 1 then
        taskset.set_pieces["CaveEntrance"] = { count = 10, tasks = { "plains", "plains_ruins", "Deep_rainforest", "Deep_rainforest_2", "painted_sands", "Edge_of_civilization", "Deep_rainforest_mandrake", "rainforest_ruins", "Pigtopia" } }
    end

    if TUNING.tropical.hamlet_caves then
        taskset.set_pieces["cave_entranceham1"] = { count = 1, tasks = { "plains", "plains_ruins" } }
        taskset.set_pieces["cave_entranceham2"] = { count = 1, tasks = { "Deep_rainforest", "Deep_rainforest_2", "painted_sands" } }
        taskset.set_pieces["cave_entranceham3"] = { count = 1, tasks = { "Edge_of_civilization", "Deep_rainforest_mandrake", "rainforest_ruins" } }
    end
    taskset.location = "forest"

    if TUNING.tropical.tropicalshards ~= 0 then
        taskset.set_pieces["hamlet_exit"] = { count = 1, tasks = { "plains", "plains_ruins", "Deep_rainforest", "Deep_rainforest_2", "painted_sands", "Edge_of_civilization", "Deep_rainforest_mandrake", "rainforest_ruins" } }
    end
end


AddTaskSetPreInitAny(TasksetPreInit)

AddStartLocation("porkland_start", {
    name = "Porkland",
    location = "forest",
    start_setpeice = "porkland_start",
    start_node = "PorklandPortalRoom",
})
---------------------------a partir daqui o mod volcano biome normal------------------------------------
