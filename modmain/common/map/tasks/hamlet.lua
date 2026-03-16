

--------------------------------cherry----------------------------
if KnownModIndex:IsModEnabled("workshop-1289779251") then
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
        room_bg = WORLD_TILES.CHERRY,
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
    taskset.optionaltasks ={}

    taskset.ocean_prefill_setpieces = {}

    taskset.ocean_population = {}


    taskset.valid_start_tasks = {
        "inicio",
    }


    taskset.set_pieces = {}



    -----------------------------umcompromissing-----------------------------------------------------		
    if KnownModIndex:IsModEnabled("workshop-2039181790") then
        table.insert(taskset.tasks, "GiantTrees")
    end
    -----------------------------cherry forest-----------------------------------------------------
    if KnownModIndex:IsModEnabled("workshop-1289779251") then
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


---------------------------a partir daqui o mod volcano biome normal------------------------------------
