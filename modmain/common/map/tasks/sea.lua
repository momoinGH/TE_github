AddStartLocation("OceanWorld", {
    name = "OceanWorld",
    location = "forest",
    start_setpeice = "oceanworldstart",
    start_node = "Blank",
})

AddTask("OceanWorldstart", {
    locks = {},
    keys_given = {},
    room_choices = {
        ["Blank"] = 1,
    },
    room_bg = GROUND.GRASS,
    background_room = "Blank",
    colour = { r = 0, g = 1, b = 0, a = 1 }
})

AddRoom("OceanCoastalShore_SEA", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.OCEAN_COASTAL_SHORE,
    contents = {
        distributepercent = 0.005,
        distributeprefabs =
        {
            wobster_den_spawner_shore = 1,
        },
    }
})

AddRoom("OceanCoastal_SEA", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.OCEAN_COASTAL,
    contents = {

        countprefabs =
        {
            seaweed_planted = 200,
            mussel_farm = 300,
            messagebottle_sw = 20,
            mermboat = 4,
        },

        distributepercent = 0.01,
        distributeprefabs =
        {
            driftwood_log = 1,
            bullkelp_plant = 2,
            messagebottle = 0.08,
        },

    }
})


AddRoom("OceanSwell_SEA", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.OCEAN_SWELL,
    required_prefabs = { "crabking_spawner" },
    contents = {

        countprefabs =
        {

        },
        distributepercent = 0.005,
        distributeprefabs =
        {
            seastack = 1,
            seastack_spawner_swell = 0.1,
            undersearock1 = 0.5,
            undersearock2 = 0.25,
            undersearock_flintless = 0.1,
            undersearock_moon = 0.1,
            oceanfish_shoalspawner = 0.07,
        },
        countstaticlayouts =
        {
            ["CrabKing"] = 1,
            ["BullkelpFarmSmall"] = 6,
            ["BullkelpFarmMedium"] = 3,
            ["lilypadnovo"] = 2 * GetModConfigData("lilypad"),
            ["lilypadnovograss"] = GetModConfigData("lilypad"),
            ["icebergs"] = 8,
            ["oceangrotolunar"] = 1,
            ["oceanrocks"] = 4,
        },

    }
})

-- "moonglass_wobster_den"	"lobsterhole"	"wobster_den"
AddRoom("OceanRough_SEA", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.OCEAN_ROUGH,
    required_prefabs = {
        "hermithouse_construction1",
        "waterplant",
    },
    contents = {
        -- countprefabs =
        -- {
        -- 	messagebottle_sw = 20,
        -- },

        distributepercent = 0.01,
        distributeprefabs =
        {
            seastack = 1,
            seastack_spawner_rough = 0.09,
            undersearock1 = 0.5,
            undersearock2 = 0.25,
            undersearock_flintless = 0.1,
            undersearock_moon = 0.1,
            waterplant_spawner_rough = 0.04,
        },

        countprefabs =
        {
            waterplant = 1,
        },

        countstaticlayouts =
        {
            ["HermitcrabIsland"] = 1,
            ["MonkeyIsland"] = 1,
            ["BullkelpFarmSmall"] = 6,
            ["BullkelpFarmMedium"] = 3,
            ["oceanforest"] = 5,
            ["oceanbamboforest"] = 5,
        },
    }
})

--coral					
AddRoom("OceanReef_SEA", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.OCEAN_BRINEPOOL,
    contents = {
        countprefabs =
        {
        },

        distributepercent = 0,
        distributeprefabs =
        {
        },

    }
})

--ship gravery
AddRoom("OceanHazardous_SEA", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.OCEAN_HAZARDOUS,
    contents = {
        countprefabs =
        {
        },
        distributepercent = 0.15,
        distributeprefabs =
        {
            boatfragment03 = 1,
            boatfragment04 = 1,
            boatfragment05 = 1,
            seastack = 1,
        },
    }
})

AddLevelPreInitAny(function(level)
    if level.location ~= "forest" then
        return
    end
    level.tasks = { "OceanWorldstart" }
    level.numoptionaltasks = 0
    level.optionaltasks = {}
    level.valid_start_tasks = nil
    level.set_pieces = {}


    if level.ocean_population == nil then
        level.ocean_population = {}
    end

    level.ocean_population = {
        "OceanCoastalShore_SEA",
        "OceanCoastal_SEA",
        "OceanSwell_SEA",
        "OceanRough_SEA",
        "OceanReef_SEA",
        "OceanHazardous_SEA",
    }

    level.random_set_pieces = {}
    level.ordered_story_setpieces = {}
    level.numrandom_set_pieces = 0

    level.overrides.start_location = "OceanWorld"
    level.overrides.keep_disconnected_tiles = true
    level.overrides.roads = "never"

    level.ocean_prefill_setpieces["coralpool1"] = { count = 3 * GetModConfigData("coralbiome") }
    level.ocean_prefill_setpieces["coralpool2"] = { count = 3 * GetModConfigData("coralbiome") }
    level.ocean_prefill_setpieces["coralpool3"] = { count = 2 * GetModConfigData("coralbiome") }
    level.ocean_prefill_setpieces["octopuskinghome"] = { count = GetModConfigData("octopusking") }
    level.ocean_prefill_setpieces["mangrove1"] = { count = 2 * GetModConfigData("mangrove") }
    level.ocean_prefill_setpieces["mangrove2"] = { count = GetModConfigData("mangrove") }
    level.ocean_prefill_setpieces["wreck"] = { count = GetModConfigData("shipgraveyard") }
    level.ocean_prefill_setpieces["wreck2"] = { count = GetModConfigData("shipgraveyard") }
    level.ocean_prefill_setpieces["kraken"] = { count = GetModConfigData("kraken") }

    level.required_prefabs = {}
end)
