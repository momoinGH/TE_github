local GroundTiles = require("worldtiledefs")
local NoiseFunctions = require("noisetilefunctions")
local ChangeTileRenderOrder = ChangeTileRenderOrder
local AddTile = AddTile

local WORLD_TILES = WORLD_TILES
local GROUND = GROUND



GLOBAL.setfenv(1, GLOBAL) --这个是让所有的全局变量挂在global上

local AddNewTile = function(tile, range, tile_data, ground_tile_def, minimap_tile_def, turf_def)
    if WORLD_TILES[tile] then
        return
    end

    AddTile(tile, range, tile_data, ground_tile_def, minimap_tile_def, turf_def)
end

local is_worldgen = rawget(_G, "WORLDGEN_MAIN") ~= nil

if not is_worldgen then
    TileGroups.TAOceanTiles = TileGroupManager:AddTileGroup()
end


local TileRanges =
{
    LAND = "LAND",
    SW_LAND = "SW_LAND",
    HAM_LAND = "HAM_LAND",
    --ICE_LAND = "ICE_LAND",
    -- LAVA_LAND = "LAVA_LAND",
    NOISE = "NOISE",
    OCEAN = "OCEAN",
    TRO_OCEAN = "TRO_OCEAN",
    IMPASSABLE = "IMPASSABLE",
}


local tro_tiledefs = {


    -------------------以下为水体地皮---------------------
    MANGROVE = {
        tile_range       = TileRanges.TRO_OCEAN,
        tile_data        = {
            ground_name = "Mangrove",
            old_static_id = 106,
        },
        ground_tile_def  = {
            name = "sw/water_medium",
            noise_texture = "sw/water_mangrove",
            flashpoint_modifier = 250,
            ocean_depth = "SHALLOW",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_water_mangrove",
        },
    },


    LILYPOND = {
        tile_range       = TileRanges.TRO_OCEAN,
        tile_data        = {
            ground_name = "Lilypond",
            old_static_id = 107,
        },
        ground_tile_def  = {
            name = "sw/water_medium", ----- "water_medium"
            noise_texture = "ham/water_lilypond2",
            -- is_shoreline = true,   -------------加上
            flashpoint_modifier = 250,
            ocean_depth = "SHALLOW",
            -- colors = OCEAN_COLOR, ----有了这个就会有边缘的瀑布效果--而且不能改颜色？
            -- wavetint = WAVETINTS.waterlog,
            is_shoreline = true,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "ham/mini_water_lilypond",
        },
    },

    OCEAN_CORAL = {
        tile_range       = TileRanges.TRO_OCEAN,
        tile_data        = {
            ground_name = "Coral",
            old_static_id = 104,
        },
        ground_tile_def  = {
            name = "sw/water_medium",
            noise_texture = "sw/water_coral", --   "ground_water_coral",
            flashpoint_modifier = 250,
            ocean_depth = "SHALLOW",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_water_coral",
        },
    },

    OCEAN_SHALLOW_SHORE = { --was called OCEAN_SHORE in sw, kept for ambientsound
        tile_range       = TileRanges.TRO_OCEAN,
        tile_data        = {
            ground_name = "Shallow Shore",
            old_static_id = 101,
        },
        ground_tile_def  = {
            name = "sw/water_shallow",
            noise_texture = "sw/water_shallow",
            flashpoint_modifier = 250,
            -- is_shoreline = true,
            ocean_depth = "SHALLOW",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_water_shallow",
        },
    },
    OCEAN_SHALLOW = {
        tile_range       = TileRanges.TRO_OCEAN,
        tile_data        = {
            ground_name = "Shallow",
            old_static_id = 101,
        },
        ground_tile_def  = {
            name = "sw/water_shallow",
            noise_texture = "sw/water_shallow",
            flashpoint_modifier = 250,
            ocean_depth = "SHALLOW",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_water_shallow",
        },
    },


    OCEAN_MEDIUM = {
        tile_range       = TileRanges.TRO_OCEAN,
        tile_data        = {
            ground_name = "Medium",
            old_static_id = 102,
        },
        ground_tile_def  = {
            name = "sw/water_medium",
            noise_texture = "sw/water_medium",
            flashpoint_modifier = 250,
            ocean_depth = "DEEP",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_water_medium",
        },
    },
    OCEAN_DEEP = {
        tile_range       = TileRanges.TRO_OCEAN,
        tile_data        = {
            ground_name = "Deep",
            old_static_id = 103,
        },
        ground_tile_def  = {
            name = "sw/water_deep",
            noise_texture = "sw/water_deep",
            flashpoint_modifier = 250,
            ocean_depth = "VERY_DEEP",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_water_deep",
        },
    },
    OCEAN_SHIPGRAVEYARD = {
        tile_range       = TileRanges.TRO_OCEAN,
        tile_data        = {
            ground_name = "Ship Grave",
            old_static_id = 105,
        },
        ground_tile_def  = {
            name = "sw/water_deep",
            noise_texture = "sw/water_graveyard",
            flashpoint_modifier = 250,
            ocean_depth = "BASIC",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_water_graveyard",
        },
    },

    ---------------------以下为海难陆地地皮------------------------------

	ASH = {----------------灰烬地皮
        tile_range       = TileRanges.SW_LAND,
        tile_data        = {
            ground_name = "Ash",
            old_static_id = 33,
        },
        ground_tile_def  = {
            name = "cave",
            noise_texture = "sw/ground_ash",
            runsound = "dontstarve/movement/run_dirt",
            walksound = "dontstarve/movement/walk_dirt",
            snowsound = "dontstarve/movement/run_ice",
            flashpoint_modifier = 0,
            hard = true,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_ground_ash",
        },
        turf_def         = {
            name = "ash",
            bank_build = "turf_sw",
        },
    },

    BEACH = { ------------沙滩地皮
        tile_range       = TileRanges.SW_LAND,
        tile_data        = {
            ground_name = "Beach",
            old_static_id = 33,
        },
        ground_tile_def  = {
            name = "sw/beach",
            noise_texture = "sw/ground_beach",
            runsound = "dontstarve/movement/run_sand",
            walksound = "dontstarve/movement/walk_sand",
            flashpoint_modifier = 0,
            -- cannotbedug = true,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_ground_beach",
        },
        turf_def         = {
            name = "beach",
            bank_build = "turf_sw",
        },
    },

    JUNGLE = {------------丛林地皮
        tile_range       = TileRanges.SW_LAND,
        tile_data        = {
            ground_name = "Jungle",
            old_static_id = 33,
        },
        ground_tile_def  = {
            name = "sw/jungle",
            noise_texture = "sw/ground_jungle",
            runsound = "dontstarve/movement/run_dirt",
            walksound = "dontstarve/movement/walk_dirt",
            -- snowsound = "dontstarve/movement/run_ice",
            -- mudsound = "dontstarve/movement/run_mud",
            flashpoint_modifier = 0,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_ground_jungle",
        },
        turf_def         = {
            name = "jungle",
            bank_build = "turf_sw",
        },
    },

    -- SWAMP = {
    --     tile_range = TileRanges.SW_LAND,
    --     tile_data = {
    --         ground_name = "Swamp",
    --         old_static_id = 33,
    --     },
    --     ground_tile_def  = {
    --         name = "swamp",
    --         noise_texture = "ground_noise_swamp",
    --         runsound = "dontstarve/movement/run_marsh",
    --         walksound = "dontstarve/movement/walk_marsh",
    --     },
    --     minimap_tile_def = {
    --         name = "map_edge",
    --         noise_texture = "mini_swamp_noise",
    --     },
    --     turf_def = {
    --         name = "swamp",
    --     },
    -- },

    MAGMAFIELD = {------------岩浆岩地皮
        tile_range       = TileRanges.SW_LAND,
        tile_data        = {
            ground_name = "Magmafield",
            old_static_id = 33,
        },
        ground_tile_def  = {
            name = "cave",
            noise_texture = "sw/ground_magmafield",
            runsound = "dontstarve/movement/run_rock",
            walksound = "dontstarve/movement/walk_rock",
            -- runsound = "dontstarve/movement/run_slate",
            -- walksound = "dontstarve/movement/walk_slate",
            snowsound = "dontstarve/movement/run_ice",
            flashpoint_modifier = 0,
            hard = true,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_ground_magmafield",
        },
        turf_def         = {
            name = "magmafield",
            bank_build = "turf_sw",
        },
    },

    MEADOW = {------------草甸地皮
        tile_range       = TileRanges.SW_LAND,
        tile_data        = {
            ground_name = "Meadow",
            old_static_id = 33,
        },
        ground_tile_def  = {
            name = "sw/jungle",
            noise_texture = "sw/ground_meadow",
            runsound = "dontstarve/movement/run_tallgrass",
            walksound = "dontstarve/movement/walk_tallgrass",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_ground_meadow",
        },
        turf_def         = {
            name = "meadow",
            bank_build = "turf_sw",
        },
    },

    SNAKESKINFLOOR = {------------蛇皮地毯
        tile_range       = TileRanges.SW_LAND,
        tile_data        = {
            ground_name = "Snakeskin Carpet",
            old_static_id = 33,
        },
        ground_tile_def  = {
            name = "carpet",
            noise_texture = "sw/ground_snakeskinfloor",
            runsound = "dontstarve/movement/run_carpet",
            walksound = "dontstarve/movement/walk_carpet",
            flashpoint_modifier = 0,
            flooring = true,
            hard = true,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_ground_snakeskinfloor",
        },
        turf_def         = {
            name = "snakeskinfloor",
            bank_build = "turf_sw",
        },
    },

    TIDALMARSH = {------------潮滩地皮
        tile_range       = TileRanges.SW_LAND,
        tile_data        = {
            ground_name = "Tidal Marsh",
            old_static_id = 33,
        },
        ground_tile_def  = {
            name = "sw/tidalmarsh",
            noise_texture = "sw/ground_tidalmarsh",
            runsound = "dontstarve/movement/run_marsh",
            walksound = "dontstarve/movement/walk_marsh",
            flashpoint_modifier = 0,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_ground_tidalmarsh",
        },
        turf_def         = {
            name = "tidalmarsh",
            bank_build = "turf_sw",
        },
    },

    VOLCANO = {------------火山地皮
        tile_range       = TileRanges.SW_LAND,
        tile_data        = {
            ground_name = "Lava Rock",
            old_static_id = 33,
        },
        ground_tile_def  = {
            name = "cave",
            noise_texture = "sw/ground_volcano",
            runsound = "dontstarve/movement/run_rock",
            walksound = "dontstarve/movement/walk_rock",
            snowsound = "dontstarve/movement/run_ice",
            flashpoint_modifier = 0,
            hard = true,
            cannotbedug = true, ----不能挖
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_ground_volcano",
        },
        turf_def         = {
            name = "volcano",
            bank_build = "turf_sw",
        },
    },


    VOLCANO_ROCK = { -------------火山岩地皮
        tile_range       = TileRanges.SW_LAND,
        tile_data        = {
            ground_name = "Volcano Rock",
            old_static_id = 33,
        },
        ground_tile_def  = {
            name = "rocky",
            noise_texture = "sw/ground_volcano_rock",
            runsound = "dontstarve/movement/run_rock",
            walksound = "dontstarve/movement/walk_rock",
            flashpoint_modifier = 0,
            hard = true, ----不可种植
            cannotbedug = true,

        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_ground_volcano_rock",
        },

        turf_def         = {
            name = "volcano_rock",
            bank_build = "turf_sw",
        },
    },



    -------------------------------
    -- IMPASSABLE
    -- (render order doesnt matter)
    -------------------------------

    -- VOLCANO_LAVA = {
    --     tile_range = TileRanges.IMPASSABLE,
    --     tile_data = {
    --         ground_name = "Lava",
    --     },
    --     minimap_tile_def = {
    --         name = "map_edge",
    --         noise_texture = "mini_lava_noise",
    --     },
    -- },

    -------------------------------
    -- NOISE
    -- (only for worldgen)
    -------------------------------

    -- VOLCANO_NOISE = {
    --     tile_range = volcano_noisefn,
    -- },


    --------------------------以下为哈姆陆地地皮---------------------

    ANTCAVE = {------------蚁巢地皮
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "Antcave",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "cave",
            noise_texture = "ham/ground_antcave",
            runsound = "dontstarve/movement/run_dirt",
            walksound = "dontstarve/movement/walk_dirt",
            snowsound = "run_ice",
            cannotbedug = true
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "ham/mini_ground_antcave"
        },
        turf_def = {
            name = "antcave",
            anim = "antcave",
            bank_build = "turf_ham",
        },
    },

    BATCAVE = {------------蝙蝠洞地皮
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "Batcave",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "cave",
            noise_texture = "ham/ground_batcave",
            runsound = "dontstarve/movement/run_dirt",
            walksound = "dontstarve/movement/walk_dirt",
            snowsound = "run_ice",
            cannotbedug = true
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "ham/mini_ground_batcave"
        },
        turf_def = {
            name = "batcave",
            anim = "batcave",
            bank_build = "turf_ham",
        },
    },

    BATTLEGROUNDS = { --------古代战场地皮
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "Battlegrounds",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "ham/jungle_deep",
            noise_texture = "ham/ground_battlegrounds",
            runsound = "dontstarve/movement/run_dirt",
            walksound = "dontstarve/movement/walk_dirt",
            snowsound = "run_ice",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "ham/mini_ground_battlegrounds"
        },
        turf_def = {
            name = "battlegrounds",
            anim = "battlegrounds",
            bank_build = "turf_ham",
        },
    },

   COBBLEROAD = {------------石板路地皮
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "Cobbleroad",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "ham/stoneroad",
            noise_texture = "ham/ground_cobbleroad",
            runsound = "dontstarve/movement/run_marble",
            walksound = "dontstarve/movement/walk_marble",
            snowsound = "run_ice",
            flashpoint_modifier = 0,
            flooring = true,
            hard = true,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "ham/mini_ground_cobbleroad",
        },
        turf_def = {
            name = "cobbleroad",
            bank_build = "turf_ham",
        },
    },

    DEEPRAINFOREST = {------------深层雨林地皮
        tile_range       = TileRanges.HAM_LAND,
        tile_data        = {
            ground_name = "Jungle Deep",
            old_static_id = 33,
        },
        ground_tile_def  = {
            name = "ham/jungle_deep",
            noise_texture = "ham/ground_deeprainforest",
            runsound = "dontstarve/movement/run_woods",
            walksound = "dontstarve/movement/walk_woods",
            flashpoint_modifier = 0,
			--cannotbedug = true,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "ham/mini_ground_deeprainforest",
        },
        turf_def         = {
            name = "deeprainforest",
            bank_build = "turf_ham",
        },
    },

    DEEPRAINFOREST_CRAFTED = {------------茂密雨林地皮（玩家做的深层雨林地皮）
        tile_range       = TileRanges.HAM_LAND,
        tile_data        = {
            ground_name = "Jungle Deep Nocanopy",
            old_static_id = 33,
        },
        ground_tile_def  = {
            name = "ham/jungle_deep",
            noise_texture = "ham/ground_deeprainforest_nocanopy",
            runsound = "dontstarve/movement/run_woods",
            walksound = "dontstarve/movement/walk_woods",
            flashpoint_modifier = 0,
            --cannotbedug = true, 
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "ham/mini_ground_deeprainforest_nocanopy",
        },
        turf_def         = {
             name = "deeprainforest_nocanopy",
             anim = "deeprainforest",
             bank_build = "turf_ham",
        },
    },

    FIELDS = {------------耕种地皮
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "fields",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "ham/jungle",
            noise_texture = "ham/ground_fields",
            runsound = "dontstarve/movement/run_woods",
            walksound = "dontstarve/movement/walk_woods",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "ham/mini_ground_fields",
        },
        turf_def = {
            name = "fields",
            bank_build = "turf_ham",
        },
    },

    FOUNDATION = {------------平整石地皮
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "Foundation",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "ham/blocky",
            noise_texture = "ham/ground_foundation",
            runsound = "dontstarve/movement/run_marble",
            walksound = "dontstarve/movement/walk_marble",
            snowsound = "run_ice",
            flashpoint_modifier = 0,
            flooring = true,
            hard = true,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "ham/mini_ground_foundation",
        },
        turf_def = {
            name = "foundation",
            bank_build = "turf_ham",
        },
    },

    GASRAINFOREST = {------------毒瘴雨林地皮
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "Gas Jungle",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "ham/jungle_deep",
            noise_texture = "ham/ground_gasrainforest",
            runsound = "dontstarve/movement/run_moss",
            walksound = "dontstarve/movement/walk_moss",
            --cannotbedug = true,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "ham/mini_ground_gasrainforest",
        },
        turf_def = {
            name = "gasrainforest",
            anim = "gasrainforest",
            bank_build = "turf_ham",
        },
    },

    LAWN = {------------草坪地皮
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "Lawn",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "ham/pebble",
            noise_texture = "ham/ground_lawn",
            runsound = "dontstarve/movement/run_grass",
            walksound = "dontstarve/movement/walk_grass",
            -- runsound = "run_grass",
            -- walksound = "walk_grass",
            flashpoint_modifier = 0,
            flooring = true,
            hard = true,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "ham/mini_ground_lawn",
        },
        turf_def = {
            name = "lawn",
            anim = "lawn",
            bank_build = "turf_ham",
        },
    },

    MOSS = {------------苔藓地皮
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "Suburb",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "ham/deciduous",
            noise_texture = "ham/ground_moss",
            runsound = "dontstarve/movement/run_dirt",
            walksound = "dontstarve/movement/walk_dirt",
            snowsound = "run_ice",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "ham/mini_ground_moss",
        },
        turf_def = {
            name = "moss",
            anim = "moss",
            bank_build = "turf_ham",
        },
    },

    PAINTED = {------------彩绘沙漠地皮
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "Painted",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "ham/swamp",
            noise_texture = "ham/ground_painted",
            runsound = "dontstarve/movement/run_sand",
            walksound = "dontstarve/movement/walk_sand",
            mudsound = "run_sand"
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "ham/mini_ground_painted",
        },
        turf_def = {
            name = "painted",
            bank_build = "turf_ham",
        },
    },

    PIGRUINS = {------------古代废墟地皮
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "Pigruins",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "ham/blocky",
            noise_texture = "ham/ground_pigruins",
            runsound = "dontstarve/movement/run_dirt",
            walksound = "dontstarve/movement/walk_dirt",
            snowsound = "run_ice",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "ham/mini_ground_pigruins"
        },
        turf_def = {
            name = "pigruins",
            bank_build = "turf_ham",
        },
    },

    PIGRUINS_BLUE = {------------蓝色古代废墟地皮
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "Pigruins Blue",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "ham/blocky",
            noise_texture = "ham/ground_pigruins_blue",
            runsound = "dontstarve/movement/run_dirt",
            walksound = "dontstarve/movement/walk_dirt",
            snowsound = "run_ice",
            --cannotbedug = true
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "ham/mini_ground_pigruins"
        },
         turf_def = {
             name = "pigruins_blue",
             anim = "pigruins",
             bank_build = "turf_ham",
         },
    },

    PLAINS = {------------荒野平原地皮
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "Plains",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "ham/jungle",
            noise_texture = "ham/ground_plains",
            runsound = "dontstarve/movement/run_tallgrass",
            walksound = "dontstarve/movement/walk_tallgrass",
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "ham/mini_ground_plains",
        },
        turf_def = {
            name = "plains",
            bank_build = "turf_ham",
        },
    },

    RAINFOREST = {------------雨林地皮
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "Rain Forest",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "ham/rain_forest",
            noise_texture = "ham/ground_rainforest",
            runsound = "dontstarve/movement/run_woods",
            walksound = "dontstarve/movement/walk_woods",
            flashpoint_modifier = 0,

        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "ham/mini_ground_rainforest",
        },
        turf_def = {
            name = "rainforest",
            bank_build = "turf_ham",
        },
    },

    HAMARCHIVE = { --------------- 哈姆洞穴遗迹迷宫地皮（重写海底世界范围判断逻辑后就可以删除）
        tile_range       = TileRanges.HAM_LAND,
        tile_data        = {
            ground_name = "Pigruins Archive",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "ham/blocky",
            noise_texture = "ham/ground_pigruins",
            runsound = "dontstarve/movement/run_dirt",
            walksound = "dontstarve/movement/walk_dirt",
            snowsound = "run_ice",
            --cannotbedug = true
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "ham/mini_ground_pigruins"
        },
         turf_def = {
             name = "hamarchive",
             anim = "pigruins",
             bank_build = "turf_ham",
        },
    },
--------------------------以下为暴食地皮-------------------------
--[[
	QUAGMIRE_GATEWAY = { --------------- 沼地草坪地皮
        tile_range       = TileRanges.LAND,
        tile_data        = {
            ground_name = "Gorge Gateway",
            old_static_id = GROUND.QUAGMIRE_GATEWAY,
        },
        ground_tile_def  = {
            name = "grass3",
            noise_texture = "quagmire_gateway_noise",
            runsound="dontstarve/movement/run_woods",
            walksound="dontstarve/movement/walk_woods",
            snowsound="dontstarve/movement/run_snow",
            mudsound = "dontstarve/movement/run_mud",
            flashpoint_modifier = 0,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "quagmire_gateway_mini",
        },
        turf_def         = {
            name = "quagmire_gateway",
            bank_build = "turf_quagmire",
        },
    },
	
	    QUAGMIRE_CITYSTONE = { --------------- 城市石头地皮
        tile_range       = TileRanges.LAND,
        tile_data        = {
            ground_name = "Gorge Citystone",
            old_static_id = GROUND.QUAGMIRE_CITYSTONE,
        },
        ground_tile_def  = {
            name = "cave",
            noise_texture = "quagmire_citystone_noise",
            runsound="dontstarve/movement/run_dirt",
            walksound="dontstarve/movement/walk_dirt",
            snowsound="dontstarve/movement/run_ice",
            mudsound = "dontstarve/movement/run_mud",
            flashpoint_modifier = 0,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "quagmire_citystone_mini",
        },
        turf_def         = {
            name = "quagmire_citystone",
            bank_build = "turf_quagmire",
        },
    },
	
	    QUAGMIRE_PARKFIELD = { --------------- 糖木草坪地皮
        tile_range       = TileRanges.LAND,
        tile_data        = {
            ground_name = "Gorge Park Grass",
            old_static_id = GROUND.QUAGMIRE_PARKFIELD,
        },
        ground_tile_def  = {
            name = "deciduous",
            noise_texture = "quagmire_parkfield_noise",
            runsound="dontstarve/movement/run_carpet",
            walksound="dontstarve/movement/walk_carpet",
            snowsound="dontstarve/movement/run_snow",
            mudsound = "dontstarve/movement/run_mud",
            flashpoint_modifier = 0,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "quagmire_parkfield_mini",
        },
        turf_def         = {
            name = "quagmire_parkfield",
            bank_build = "turf_quagmire",
        },
    },
	
	    QUAGMIRE_PARKSTONE = { --------------- 糖木石头地皮
        tile_range       = TileRanges.LAND,
        tile_data        = {
            ground_name = "Gorge Park Path",
            old_static_id = GROUND.QUAGMIRE_PARKSTONE,
        },
        ground_tile_def  = {
            name = "cave",
            noise_texture = "quagmire_parkstone_noise",
            runsound="dontstarve/movement/run_dirt",
            walksound="dontstarve/movement/walk_dirt",
            snowsound="dontstarve/movement/run_ice",
            mudsound = "dontstarve/movement/run_mud",
            flashpoint_modifier = 0,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "quagmire_parkstone_mini",
        },
        turf_def         = {
            name = "quagmire_parkstone",
            bank_build = "turf_quagmire",
        },
    },
	
	    QUAGMIRE_PEATFOREST = { --------------- 泥炭林地皮
        tile_range       = TileRanges.LAND,
        tile_data        = {
            ground_name = "Gorge Peat Forest",
            old_static_id = GROUND.QUAGMIRE_PEATFOREST,
        },
        ground_tile_def  = {
            name = "grass2",
            noise_texture = "quagmire_peatforest_noise",
            runsound="dontstarve/movement/run_marsh",
            walksound="dontstarve/movement/walk_marsh",
            snowsound="dontstarve/movement/run_ice",
            mudsound = "dontstarve/movement/run_mud",
            flashpoint_modifier = 0,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/quagmire_peatforest_mini",
        },
        turf_def         = {
            name = "quagmire_peatforest",
            bank_build = "turf_quagmire",
        },
    },
	]]
--------------------------以下为海底世界地皮---------------------

    UNDERWATER_SANDY = {------------海底沙滩地皮
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "uwsand",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "cave",
            noise_texture = "lavaarena/ground_lavaarena_floor",
            runsound = "dontstarve/movement/run_dirt",
            walksound = "dontstarve/movement/walk_dirt",
            snowsound = "run_ice",
            cannotbedug = true
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "lavaarena/mini_ground_lavaarena_floor"
        },
        turf_def = {
            name = "lavaland",
            bank_build = "turf",
        },
    },

    UNDERWATER_ROCKY = {------------海底岩石地皮
        tile_range = TileRanges.HAM_LAND,
        tile_data = {
            ground_name = "uwrocky",
            old_static_id = 33,
        },
        ground_tile_def = {
            name = "cave",
            noise_texture = "lavaarena/ground_lavaarena_floor",
            runsound = "dontstarve/movement/run_dirt",
            walksound = "dontstarve/movement/walk_dirt",
            snowsound = "run_ice",
            cannotbedug = true
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "lavaarena/mini_ground_lavaarena_floor"
        },
        turf_def = {
            name = "lavaland",
            bank_build = "turf",
        },
    },

    --------------------------以下为冰霜岛屿地皮---------------------

    ICELAND = { --------------- 冰封地皮
        tile_range       = TileRanges.LAND,
        tile_data        = {
            ground_name = "iceland",
            old_static_id = 33,
        },
        ground_tile_def  = {
            name = "cave",
            noise_texture = "frost/ground_iceland",
            runsound = "dontstarve/movement/run_marsh",
            walksound = "dontstarve/movement/walk_marsh",
            flashpoint_modifier = 0,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "frost/mini_ground_iceland",
        },
        turf_def         = {
            name = "iceland",
			anim = "tidalmarsh",
            bank_build = "turf_sw",
        },
    },

    SNOWLAND = { --------------- 覆雪地皮
        tile_range       = TileRanges.LAND,
        tile_data        = {
            ground_name = "snowland",
            old_static_id = 33,
        },
        ground_tile_def  = {
            name = "cave",
            noise_texture = "frost/ground_snowland",
            runsound = "dontstarve/movement/run_marsh",
            walksound = "dontstarve/movement/walk_marsh",
            flashpoint_modifier = 0,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "frost/mini_ground_snowland",
        },
        turf_def         = {
            name = "snowland",
			anim = "tidalmarsh",
            bank_build = "turf_sw",
        },
    },

    --------------------------以下为绿色世界地皮---------------------

    MARSH_SW = { ----------------湿地草皮
        tile_range       = TileRanges.SW_LAND,
        tile_data        = {
            ground_name = "Marsh sw",
            old_static_id = 33,
        },
        ground_tile_def  = {
            name = "sw/tidalmarsh",
            noise_texture = "sw/ground_tidalmarsh",
            runsound = "dontstarve/movement/run_marsh",
            walksound = "dontstarve/movement/walk_marsh",
            flashpoint_modifier = 0,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_ground_tidalmarsh",
        },
        turf_def         = {
            name = "marsh sw",
			anim = "tidalmarsh",
            bank_build = "turf_sw",
        },
    },

    --------------------------以下为大风平原地皮---------------------

    WINDY = { ----------------微风草皮
        tile_range       = TileRanges.SW_LAND,
        tile_data        = {
            ground_name = "Windy",
            old_static_id = 33,
        },
        ground_tile_def  = {
            name = "sw/tidalmarsh",
            noise_texture = "sw/ground_tidalmarsh",
            runsound = "dontstarve/movement/run_marsh",
            walksound = "dontstarve/movement/walk_marsh",
            flashpoint_modifier = 0,
        },
        minimap_tile_def = {
            name = "map_edge",
            noise_texture = "sw/mini_ground_tidalmarsh",
        },
        turf_def         = {
            name = "windy",
			anim = "tidalmarsh",
            bank_build = "turf_sw",
        },
    },




}


TRO_OCEAN_TILES = {}
SW_LAND_TILES = {}
HAM_LAND_TILES = {}
TRO_LAND_TILES = {}

for tile, def in pairs(tro_tiledefs) do
    local range = def.tile_range
    if range == TileRanges.TRO_OCEAN then
        range = TileRanges.OCEAN
    elseif range == TileRanges.SW_LAND or range == TileRanges.HAM_LAND then
        range = TileRanges.LAND
    elseif type(range) == "function" then
        range = TileRanges.NOISE
    end

    AddNewTile(tile, range, def.tile_data, def.ground_tile_def, def.minimap_tile_def, def.turf_def)

    local tile_id = WORLD_TILES[tile]
    if def.tile_range == TileRanges.TRO_OCEAN then
        if not is_worldgen then
            TileGroupManager:AddInvalidTile(TileGroups.TransparentOceanTiles, tile_id)
            -- TileGroupManager:AddValidTile(TileGroups.OceanTiles, tile_id)
            TileGroupManager:AddValidTile(TileGroups.TAOceanTiles, tile_id)
        end
        TRO_OCEAN_TILES[tile_id] = true
    elseif def.tile_range == TileRanges.OCEAN then
        if not is_worldgen then
            -- TileGroupManager:AddInvalidTile(TileGroups.TransparentOceanTiles, tile_id)
            -- TileGroupManager:AddValidTile(TileGroups.Legacy_OceanTiles, tile_id)
            -- TileGroupManager:AddValidTile(TileGroups.TAOceanTiles, tile_id)
        end
        TRO_OCEAN_TILES[tile_id] = true
    elseif def.tile_range == TileRanges.SW_LAND then
        SW_LAND_TILES[tile_id] = true
        TRO_LAND_TILES[tile_id] = true
    elseif def.tile_range == TileRanges.HAM_LAND then
        HAM_LAND_TILES[tile_id] = true
        TRO_LAND_TILES[tile_id] = true
    elseif type(def.tile_range) == "function" then
        NoiseFunctions[tile_id] = def.tile_range
    end
end


-- ID 1 is for impassable
-- in ds, tile priority after the desert tile

ChangeTileRenderOrder(WORLD_TILES.ASH, WORLD_TILES.DESERT_DIRT, true)
ChangeTileRenderOrder(WORLD_TILES.BEACH, WORLD_TILES.DESERT_DIRT, true)
ChangeTileRenderOrder(WORLD_TILES.JUNGLE, WORLD_TILES.DESERT_DIRT, true)
ChangeTileRenderOrder(WORLD_TILES.MAGMAFIELD, WORLD_TILES.DESERT_DIRT, true)
ChangeTileRenderOrder(WORLD_TILES.MEADOW, WORLD_TILES.DESERT_DIRT, true)
ChangeTileRenderOrder(WORLD_TILES.SNAKESKINFLOOR, WORLD_TILES.CARPET, false)
ChangeTileRenderOrder(WORLD_TILES.TIDALMARSH, WORLD_TILES.DESERT_DIRT, true)
ChangeTileRenderOrder(WORLD_TILES.VOLCANO, WORLD_TILES.DESERT_DIRT, true)
ChangeTileRenderOrder(WORLD_TILES.VOLCANO_ROCK, WORLD_TILES.DESERT_DIRT, true)


ChangeTileRenderOrder(WORLD_TILES.ANTCAVE, WORLD_TILES.MUD, true)--ANTFLOOR
ChangeTileRenderOrder(WORLD_TILES.BATCAVE, WORLD_TILES.MUD, true)--BATFLOOR
ChangeTileRenderOrder(WORLD_TILES.BATTLEGROUNDS, WORLD_TILES.MUD, true)
ChangeTileRenderOrder(WORLD_TILES.COBBLEROAD, WORLD_TILES.WOODFLOOR, true)
ChangeTileRenderOrder(WORLD_TILES.DEEPRAINFOREST, WORLD_TILES.MUD, true)
ChangeTileRenderOrder(WORLD_TILES.FIELDS, WORLD_TILES.MUD, true)
ChangeTileRenderOrder(WORLD_TILES.FOUNDATION, WORLD_TILES.WOODFLOOR, true)
ChangeTileRenderOrder(WORLD_TILES.GASRAINFOREST, WORLD_TILES.MUD, true)--GASJUNGLE
ChangeTileRenderOrder(WORLD_TILES.LAWN, WORLD_TILES.WOODFLOOR, true)--CHECKEREDLAWN
ChangeTileRenderOrder(WORLD_TILES.MOSS, WORLD_TILES.MUD, true)--SUBURB
ChangeTileRenderOrder(WORLD_TILES.PAINTED, WORLD_TILES.MUD, true)
ChangeTileRenderOrder(WORLD_TILES.PIGRUINS, WORLD_TILES.CHECKER, true)
ChangeTileRenderOrder(WORLD_TILES.PLAINS, WORLD_TILES.MUD, true)
ChangeTileRenderOrder(WORLD_TILES.RAINFOREST, WORLD_TILES.MUD, true)

-- --Priority turf

-- ChangeTileRenderOrder(WORLD_TILES.BEARDRUG, WORLD_TILES.CARPET, false)

-----ocean turf -------如果是联机海水就不能设置高优先级
-- ChangeTileRenderOrder(WORLD_TILES.OCEAN_SHALLOW, WORLD_TILES.OCEAN_COASTAL, false)
-- ChangeTileRenderOrder(WORLD_TILES.LILYPOND, WORLD_TILES.OCEAN_COASTAL, false)
-- ChangeTileRenderOrder(WORLD_TILES.OCEAN_CORAL, WORLD_TILES.OCEAN_COASTAL, false)
-- ChangeTileRenderOrder(WORLD_TILES.MANGROVE, WORLD_TILES.OCEAN_COASTAL, false)
-- ChangeTileRenderOrder(WORLD_TILES.OCEAN_COASTAL, WORLD_TILES.OCEAN_COASTAL, false)---这种海洋地皮不可能在陆地地皮上面

ChangeTileRenderOrder(WORLD_TILES.LILYPOND, WORLD_TILES.DIRT, false)
ChangeTileRenderOrder(WORLD_TILES.OCEAN_CORAL, WORLD_TILES.DIRT, false)
ChangeTileRenderOrder(WORLD_TILES.MANGROVE, WORLD_TILES.DIRT, false)
-- ChangeTileRenderOrder(WORLD_TILES.OCEAN_COASTAL, WORLD_TILES.CARPET2, true)---这种海洋地皮不可能在陆地地皮上面
ChangeTileRenderOrder(WORLD_TILES.OCEAN_SHALLOW, WORLD_TILES.MONKEY_DOCK, false)
ChangeTileRenderOrder(WORLD_TILES.OCEAN_SHALLOW_SHORE, WORLD_TILES.MONKEY_DOCK, false)
ChangeTileRenderOrder(WORLD_TILES.OCEAN_MEDIUM, WORLD_TILES.MONKEY_DOCK, false)
ChangeTileRenderOrder(WORLD_TILES.OCEAN_DEEP, WORLD_TILES.MONKEY_DOCK, false)
ChangeTileRenderOrder(WORLD_TILES.OCEAN_CORAL, WORLD_TILES.MONKEY_DOCK, false)
ChangeTileRenderOrder(WORLD_TILES.OCEAN_SHIPGRAVEYARD, WORLD_TILES.MONKEY_DOCK, false)

for tile, def in pairs(tro_tiledefs) do
    if GROUND[tile] == nil then
        GROUND[tile] = WORLD_TILES[tile]
    end
end
