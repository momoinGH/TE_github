-- This file loads all static layouts and contains all non-static layouts
local StaticLayout = require("map/static_layout")
local AllLayouts = require("map/layouts").Layouts

local ground_types = {
    -- Translates tile type index from constants.lua into tiled tileset.
    -- Order they appear here is the order they will be used in tiled.
    WORLD_TILES.IMPASSABLE or 65536, WORLD_TILES.ROAD or 65536, WORLD_TILES.ROCKY or 65536, WORLD_TILES.DIRT or 65536,
    WORLD_TILES.SAVANNA or 65536, WORLD_TILES.GRASS or 65536, WORLD_TILES.FOREST or 65536, WORLD_TILES.MARSH or 65536,

    WORLD_TILES.WOODFLOOR or 65536, WORLD_TILES.CARPET or 65536, WORLD_TILES.CHECKER or 65536, WORLD_TILES.CAVE or 65536,
    WORLD_TILES.FUNGUS or 65536, WORLD_TILES.SINKHOLE or 65536, WORLD_TILES.WALL_ROCKY or 65536, WORLD_TILES.WALL_DIRT or 65536,
    WORLD_TILES.WALL_MARSH or 65536, WORLD_TILES.WALL_CAVE or 65536, WORLD_TILES.WALL_FUNGUS or 65536, WORLD_TILES.WALL_SINKHOLE or 65536,
    WORLD_TILES.UNDERROCK or 65536, WORLD_TILES.MUD or 65536, WORLD_TILES.WALL_MUD or 65536, WORLD_TILES.WALL_WOOD or 65536,

    WORLD_TILES.BRICK or 65536, WORLD_TILES.BRICK_GLOW or 65536, WORLD_TILES.TILES or 65536, WORLD_TILES.TILES_GLOW or 65536,
    WORLD_TILES.TRIM or 65536, WORLD_TILES.TRIM_GLOW or 65536, WORLD_TILES.WALL_HUNESTONE or 65536, WORLD_TILES.WALL_HUNESTONE_GLOW or 65536,
    WORLD_TILES.WALL_STONEEYE or 65536, WORLD_TILES.WALL_STONEEYE_GLOW or 65536,
    WORLD_TILES.FUNGUSRED or 65536, WORLD_TILES.FUNGUSGREEN or 65536,
    WORLD_TILES.BEACH or 65536, WORLD_TILES.JUNGLE or 65536, WORLD_TILES.SWAMP or 65536, WORLD_TILES.OCEAN_SHALLOW or 65536,

    WORLD_TILES.OCEAN_MEDIUM or 65536, WORLD_TILES.OCEAN_DEEP or 65536, WORLD_TILES.OCEAN_CORAL or 65536, WORLD_TILES.MANGROVE or 65536,
    WORLD_TILES.MAGMAFIELD or 65536, WORLD_TILES.TIDALMARSH or 65536, WORLD_TILES.MEADOW or 65536, WORLD_TILES.VOLCANO or 65536,
    WORLD_TILES.VOLCANO_LAVA or 65536, WORLD_TILES.ASH or 65536, WORLD_TILES.VOLCANO_ROCK or 65536, WORLD_TILES.OCEAN_SHIPGRAVEYARD or 65536,
    WORLD_TILES.COBBLEROAD or 65536, WORLD_TILES.FOUNDATION or 65536, WORLD_TILES.DEEPRAINFOREST or 65536, WORLD_TILES.CHECKEREDLAWN or 65536,
    WORLD_TILES.PIGRUINS or 65536, WORLD_TILES.LILYPOND or 65536, WORLD_TILES.GASRAINFOREST or 65536, WORLD_TILES.SUBURB or 65536,
    WORLD_TILES.RAINFOREST or 65536, WORLD_TILES.PIGRUINS_NOCANOPY or 65536, WORLD_TILES.PLAINS or 65536, WORLD_TILES.PAINTED or 65536,
    WORLD_TILES.BATTLEGROUND or 65536, WORLD_TILES.INTERIOR or 65536, WORLD_TILES.FIELDS
}

local ground_types_rainforest = {
    WORLD_TILES.DEEPRAINFOREST or 65536, WORLD_TILES.GASRAINFOREST or 65536,
}

-- AllLayouts["PorkLandStart"] = StaticLayout.Get("map/static_layouts/porkland_start", {
--     start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
--     fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
--     layout_position = LAYOUT_POSITION.CENTER,
-- })
-- AllLayouts["PorkLandStart"].ground_types = ground_types

-- local function LilypadResource()
--     return math.random() < 0.5 and { "frog_poison_lilypad" } or { "mosquito_lilypad" }
-- end

-- AllLayouts["lilypad"] = StaticLayout.Get("map/static_layouts/lilypad", {
--     water = true,
--     areas = {
--         resource_area = LilypadResource
--     }
-- })
-- AllLayouts["lilypad"].ground_types = ground_types

-- AllLayouts["lilypad2"] = StaticLayout.Get("map/static_layouts/lilypad_2", {
--     water = true,
--     areas = {
--         resource_area = LilypadResource,
--         resource_area2 = LilypadResource
--     }
-- })
-- AllLayouts["lilypad2"].ground_types = ground_types

-- AllLayouts["PigRuinsHead"] = StaticLayout.Get("map/static_layouts/pig_ruins_head", {
--     areas = {
--         item1 = { "pig_ruins_head" },
--         item2 = function()
--             local list = { "smashingpot", "grass", "pig_ruins_torch" }
--             for i = #list, 1, -1 do
--                 if math.random() < 0.7 then
--                     table.remove(list, i)
--                 end
--             end
--             return list
--         end
--     }
-- })
-- AllLayouts["PigRuinsHead"].ground_types = ground_types_rainforest

-- local function GetRandomSmashingpot()
--     return math.random() < 0.7 and { "smashingpot" } or nil
-- end

-- local function GetSmashingpot()
--     return math.random() < 1 and { "smashingpot" } or nil
-- end

-- AllLayouts["PigRuinsArtichoke"] = StaticLayout.Get("map/static_layouts/pig_ruins_artichoke", {
--     areas = {
--         item1 = GetRandomSmashingpot,
--         item2 = { "pig_ruins_artichoke" }
--     }
-- })
-- AllLayouts["PigRuinsArtichoke"].ground_types = ground_types_rainforest

-- local function PigRuinsEntranceProps()
--     return {
--         areas = {
--             item1 = GetSmashingpot,
--             item2 = GetSmashingpot,
--             item3 = GetSmashingpot
--         }
--     }
-- end

-- AllLayouts["PigRuinsEntrance1"] = StaticLayout.Get("map/static_layouts/pig_ruins_entrance_1", PigRuinsEntranceProps())
-- AllLayouts["PigRuinsEntrance1"].ground_types = ground_types

-- AllLayouts["PigRuinsEntrance2"] = StaticLayout.Get("map/static_layouts/pig_ruins_entrance_2")
-- AllLayouts["PigRuinsEntrance2"].ground_types = ground_types

-- AllLayouts["PigRuinsEntrance3"] = StaticLayout.Get("map/static_layouts/pig_ruins_entrance_3")
-- AllLayouts["PigRuinsEntrance3"].ground_types = ground_types

-- AllLayouts["PigRuinsEntrance4"] = StaticLayout.Get("map/static_layouts/pig_ruins_entrance_4", PigRuinsEntranceProps())
-- AllLayouts["PigRuinsEntrance4"].ground_types = ground_types

-- AllLayouts["PigRuinsEntrance5"] = StaticLayout.Get("map/static_layouts/pig_ruins_entrance_5", PigRuinsEntranceProps())
-- AllLayouts["PigRuinsEntrance5"].ground_types = ground_types

-- AllLayouts["PigRuinsExit1"] = StaticLayout.Get("map/static_layouts/pig_ruins_exit_1")
-- AllLayouts["PigRuinsExit1"].ground_types = ground_types

-- local function GetPigRuinsExitProps()
--     return {
--         areas = {
--             item1 = GetRandomSmashingpot,
--             item2 = GetRandomSmashingpot,
--             item3 = GetRandomSmashingpot
--         }
--     }
-- end

-- AllLayouts["PigRuinsExit2"] = StaticLayout.Get("map/static_layouts/pig_ruins_exit_2", GetPigRuinsExitProps())
-- AllLayouts["PigRuinsExit2"].ground_types = ground_types

-- AllLayouts["PigRuinsExit4"] = StaticLayout.Get("map/static_layouts/pig_ruins_exit_4", GetPigRuinsExitProps())
-- AllLayouts["PigRuinsExit4"].ground_types = ground_types

-- AllLayouts["pig_ruins_nocanopy"] = StaticLayout.Get("map/static_layouts/pig_ruins_nocanopy")
-- AllLayouts["pig_ruins_nocanopy"].ground_types = ground_types

-- AllLayouts["pig_ruins_nocanopy_2"] = StaticLayout.Get("map/static_layouts/pig_ruins_nocanopy_2")
-- AllLayouts["pig_ruins_nocanopy_2"].ground_types = ground_types

-- AllLayouts["pig_ruins_nocanopy_3"] = StaticLayout.Get("map/static_layouts/pig_ruins_nocanopy_3")
-- AllLayouts["pig_ruins_nocanopy_3"].ground_types = ground_types

-- AllLayouts["pig_ruins_nocanopy_4"] = StaticLayout.Get("map/static_layouts/pig_ruins_nocanopy_4")
-- AllLayouts["pig_ruins_nocanopy_4"].ground_types = ground_types

-- AllLayouts["mandraketown"] = StaticLayout.Get("map/static_layouts/mandraketown")
-- AllLayouts["mandraketown"].ground_types = ground_types

-- AllLayouts["nettlegrove"] = StaticLayout.Get("map/static_layouts/nettlegrove")
-- AllLayouts["nettlegrove"].ground_types = ground_types

-- AllLayouts["fountain_of_youth"] = StaticLayout.Get("map/static_layouts/pugalisk_fountain")
-- AllLayouts["fountain_of_youth"].ground_types = ground_types

-- AllLayouts["roc_nest"] = StaticLayout.Get("map/static_layouts/roc_nest")
-- AllLayouts["roc_nest"].ground_types = ground_types

-- AllLayouts["roc_cave"] = StaticLayout.Get("map/static_layouts/roc_cave")
-- AllLayouts["roc_cave"].ground_types = ground_types

--AllLayouts["teleportato_hamlet_potato_layout"] = StaticLayout.Get("map/static_layouts/teleportato_hamlet_potato_layout")
--AllLayouts["teleportato_hamlet_potato_layout"].ground_types = ground_types

AllLayouts["city_park_1"] = StaticLayout.Get("map/static_layouts/city_park_1")
AllLayouts["city_park_1"].ground_types = ground_types

AllLayouts["city_park_2"] = StaticLayout.Get("map/static_layouts/city_park_2")
AllLayouts["city_park_2"].ground_types = ground_types

AllLayouts["city_park_3"] = StaticLayout.Get("map/static_layouts/city_park_3")
AllLayouts["city_park_3"].ground_types = ground_types

AllLayouts["city_park_4"] = StaticLayout.Get("map/static_layouts/city_park_4")
AllLayouts["city_park_4"].ground_types = ground_types

AllLayouts["city_park_5"] = StaticLayout.Get("map/static_layouts/city_park_5")
AllLayouts["city_park_5"].ground_types = ground_types

AllLayouts["city_park_6"] = StaticLayout.Get("map/static_layouts/city_park_6")
AllLayouts["city_park_6"].ground_types = ground_types

AllLayouts["city_park_7"] = StaticLayout.Get("map/static_layouts/city_park_7")
AllLayouts["city_park_7"].ground_types = ground_types

AllLayouts["city_park_8"] = StaticLayout.Get("map/static_layouts/city_park_8")
AllLayouts["city_park_8"].ground_types = ground_types

AllLayouts["city_park_9"] = StaticLayout.Get("map/static_layouts/city_park_9")
AllLayouts["city_park_9"].ground_types = ground_types

AllLayouts["city_park_10"] = StaticLayout.Get("map/static_layouts/city_park_10")
AllLayouts["city_park_10"].ground_types = ground_types

AllLayouts["farm_1"] = StaticLayout.Get("map/static_layouts/farm_1")
AllLayouts["farm_1"].ground_types = ground_types

AllLayouts["farm_2"] = StaticLayout.Get("map/static_layouts/farm_2")
AllLayouts["farm_2"].ground_types = ground_types

AllLayouts["farm_3"] = StaticLayout.Get("map/static_layouts/farm_3")
AllLayouts["farm_3"].ground_types = ground_types

AllLayouts["farm_4"] = StaticLayout.Get("map/static_layouts/farm_4")
AllLayouts["farm_4"].ground_types = ground_types

AllLayouts["farm_5"] = StaticLayout.Get("map/static_layouts/farm_5")
AllLayouts["farm_5"].ground_types = ground_types

AllLayouts["farm_fill_1"] = StaticLayout.Get("map/static_layouts/farm_fill_1")
AllLayouts["farm_fill_1"].ground_types = ground_types

AllLayouts["farm_fill_2"] = StaticLayout.Get("map/static_layouts/farm_fill_2")
AllLayouts["farm_fill_2"].ground_types = ground_types

AllLayouts["farm_fill_3"] = StaticLayout.Get("map/static_layouts/farm_fill_3")
AllLayouts["farm_fill_3"].ground_types = ground_types

AllLayouts["pig_playerhouse_1"] = StaticLayout.Get("map/static_layouts/pig_playerhouse_1")
AllLayouts["pig_playerhouse_1"].ground_types = ground_types

AllLayouts["pig_palace_1"] = StaticLayout.Get("map/static_layouts/pig_palace_1")
AllLayouts["pig_palace_1"].ground_types = ground_types

AllLayouts["pig_cityhall_1"] = StaticLayout.Get("map/static_layouts/pig_cityhall_1")
AllLayouts["pig_cityhall_1"].ground_types = ground_types
