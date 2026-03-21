local Layouts = require("map/layouts").Layouts
local StaticLayout = require("map/static_layout")

-- 直接把单机版的表拿来了
local ground_types = {
    -- Translates tile type index from constants.lua into tiled tileset.
    -- Order they appear here is the order they will be used in tiled.
    --联机版也有的
    WORLD_TILES.IMPASSABLE,
    WORLD_TILES.ROAD or 0,
    WORLD_TILES.ROCKY or 0,
    WORLD_TILES.DIRT or 0,
    WORLD_TILES.SAVANNA or 0,
    WORLD_TILES.GRASS or 0,
    WORLD_TILES.FOREST or 0,
    WORLD_TILES.MARSH or 0,
    WORLD_TILES.WOODFLOOR or 0,
    WORLD_TILES.CARPET or 0,
    WORLD_TILES.CHECKER or 0,
    WORLD_TILES.CAVE or 0,
    WORLD_TILES.FUNGUS or 0,
    WORLD_TILES.SINKHOLE or 0,
    WORLD_TILES.WALL_ROCKY or 0,
    WORLD_TILES.WALL_DIRT or 0,
    WORLD_TILES.WALL_MARSH or 0,
    WORLD_TILES.WALL_CAVE or 0,
    WORLD_TILES.WALL_FUNGUS or 0,
    WORLD_TILES.WALL_SINKHOLE or 0,
    WORLD_TILES.UNDERROCK or 0,
    WORLD_TILES.MUD or 0,
    WORLD_TILES.WALL_MUD or 0,
    WORLD_TILES.WALL_WOOD or 0,
    WORLD_TILES.BRICK or 0,
    WORLD_TILES.BRICK_GLOW or 0,
    WORLD_TILES.TILES or 0,
    WORLD_TILES.TILES_GLOW or 0,
    WORLD_TILES.TRIM or 0,
    WORLD_TILES.TRIM_GLOW or 0,
    WORLD_TILES.WALL_HUNESTONE or 0,
    WORLD_TILES.WALL_HUNESTONE_GLOW or 0,
    WORLD_TILES.WALL_STONEEYE or 0,
    WORLD_TILES.WALL_STONEEYE_GLOW or 0,
    WORLD_TILES.FUNGUSRED or 0,
    WORLD_TILES.FUNGUSGREEN or 0,

    --哈姆雷特的
    WORLD_TILES.BEACH or 0,
    WORLD_TILES.JUNGLE or 0,
    WORLD_TILES.SWAMP or 0, --没定义
    WORLD_TILES.OCEAN_SHALLOW or 0,
    WORLD_TILES.OCEAN_MEDIUM or 0,
    WORLD_TILES.OCEAN_DEEP or 0,
    WORLD_TILES.OCEAN_CORAL or 0,
    WORLD_TILES.MANGROVE or 0,
    WORLD_TILES.MAGMAFIELD or 0,
    WORLD_TILES.TIDALMARSH or 0,
    WORLD_TILES.MEADOW or 0,
    WORLD_TILES.VOLCANO or 0,
    WORLD_TILES.VOLCANO_LAVA or 0, --没定义，哈姆雷特不需要
    WORLD_TILES.ASH or 0,
    WORLD_TILES.VOLCANO_ROCK or 0,
    WORLD_TILES.OCEAN_SHIPGRAVEYARD or 0,
    WORLD_TILES.COBBLEROAD or 0,
    WORLD_TILES.FOUNDATION or 0,
    WORLD_TILES.DEEPRAINFOREST or 0,
    WORLD_TILES.LAWN or 0,
    WORLD_TILES.PIGRUINS or 0,
    WORLD_TILES.LILYPOND or 0, --58
    WORLD_TILES.GASRAINFOREST or 0,
    WORLD_TILES.SUBURB or 0,
    WORLD_TILES.RAINFOREST or 0,        --61
    WORLD_TILES.PIGRUINS_NOCANOPY or 0, --室内地皮，没有
    WORLD_TILES.PLAINS or 0,
    WORLD_TILES.PAINTED or 0,
    WORLD_TILES.BATTLEGROUND or 0,
    WORLD_TILES.INTERIOR or 0, --室内地皮，没有
    WORLD_TILES.FIELDS or 0
}

-- 不老泉
Layouts["pugalisk_fountain"] = StaticLayout.Get("map/static_layouts/pugalisk_fountain", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
-- 农场
Layouts["farm_1"] = StaticLayout.Get("map/static_layouts/farm_1", {
    layout_position = LAYOUT_POSITION.RANDOM,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("farm_1", ground_types)
Layouts["farm_2"] = StaticLayout.Get("map/static_layouts/farm_2", {
    layout_position = LAYOUT_POSITION.RANDOM,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("farm_2", ground_types)
Layouts["farm_3"] = StaticLayout.Get("map/static_layouts/farm_3", {
    layout_position = LAYOUT_POSITION.RANDOM,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("farm_3", ground_types)
Layouts["farm_4"] = StaticLayout.Get("map/static_layouts/farm_4", {
    layout_position = LAYOUT_POSITION.RANDOM,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("farm_4", ground_types)
Layouts["farm_5"] = StaticLayout.Get("map/static_layouts/farm_5", {
    layout_position = LAYOUT_POSITION.RANDOM,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("farm_5", ground_types)
-- 瞭望塔
Layouts["farm_fill_1"] = StaticLayout.Get("map/static_layouts/farm_fill_1", {
    layout_position = LAYOUT_POSITION.RANDOM,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
Layouts["farm_fill_2"] = StaticLayout.Get("map/static_layouts/farm_fill_2", {
    layout_position = LAYOUT_POSITION.RANDOM,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
Layouts["farm_fill_3"] = StaticLayout.Get("map/static_layouts/farm_fill_3", {
    layout_position = LAYOUT_POSITION.RANDOM,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
-- 城镇
Layouts["cidade1"] = StaticLayout.Get("map/static_layouts/cidade1", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("cidade1", {
    [2] = WORLD_TILES.COBBLEROAD,
    [4] = WORLD_TILES.FOUNDATION,
    [6] = WORLD_TILES.LAWN
})

Layouts["cidade2"] = StaticLayout.Get("map/static_layouts/cidade2", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("cidade2", {
    [2] = WORLD_TILES.COBBLEROAD,
    [4] = WORLD_TILES.FOUNDATION,
    [6] = WORLD_TILES.LAWN
})

-- 曼德拉丘
Layouts["mandraketown"] = StaticLayout.Get("map/static_layouts/mandraketown", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
-- 出生点
Layouts["porkland_start"] = StaticLayout.Get("map/static_layouts/porkland_start", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})

Layouts["nettlegrove"] = StaticLayout.Get("map/static_layouts/nettlegrove", {
    layout_position = LAYOUT_POSITION.RANDOM,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("nettlegrove", ground_types)

Layouts["pig_ruins_entrance_1"] = StaticLayout.Get("map/static_layouts/pig_ruins_entrance_1", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("pig_ruins_entrance_1", ground_types)

Layouts["pig_ruins_entrance_2"] = StaticLayout.Get("map/static_layouts/pig_ruins_entrance_2", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("pig_ruins_entrance_2", ground_types)

Layouts["pig_ruins_entrance_3"] = StaticLayout.Get("map/static_layouts/pig_ruins_entrance_3", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("pig_ruins_entrance_3", ground_types)

Layouts["pig_ruins_entrance_4"] = StaticLayout.Get("map/static_layouts/pig_ruins_entrance_4", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("pig_ruins_entrance_4", ground_types)
Layouts["pig_ruins_entrance_5"] = StaticLayout.Get("map/static_layouts/pig_ruins_entrance_5", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("pig_ruins_entrance_5", ground_types)

Layouts["pig_ruins_exit_1"] = StaticLayout.Get("map/static_layouts/pig_ruins_exit_1", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("pig_ruins_exit_1", ground_types)

Layouts["pig_ruins_exit_2"] = StaticLayout.Get("map/static_layouts/pig_ruins_exit_2", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("pig_ruins_exit_2", ground_types)

Layouts["pig_ruins_exit_4"] = StaticLayout.Get("map/static_layouts/pig_ruins_exit_4", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})

-- 睡莲使用静态布局，和单机的不是同一个布局
Layouts["lilypad"] = StaticLayout.Get("map/static_layouts/lilypad")
TroRemapLayoutTile("lilypad", ground_types)

Layouts["pig_ruins_artichoke"] = StaticLayout.Get("map/static_layouts/pig_ruins_artichoke", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})

Layouts["pig_ruins_head"] = StaticLayout.Get("map/static_layouts/pig_ruins_head", {
    areas = {
        item1 = { "pig_ruins_head" },
        item2 = function()
            local list = { "smashingpot", "grass", "pig_ruins_torch" }
            for i = #list, 1, -1 do
                if math.random() < 0.7 then
                    table.remove(list, i)
                end
            end
            return list
        end,
    },
})
TroRemapLayoutTile("pig_ruins_head", ground_types)

Layouts["pig_ruins_nocanopy"] = StaticLayout.Get("map/static_layouts/pig_ruins_nocanopy", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("pig_ruins_nocanopy", ground_types)
Layouts["pig_ruins_nocanopy_2"] = StaticLayout.Get("map/static_layouts/pig_ruins_nocanopy_2", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("pig_ruins_nocanopy_2", ground_types)
Layouts["pig_ruins_nocanopy_3"] = StaticLayout.Get("map/static_layouts/pig_ruins_nocanopy_3", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("pig_ruins_nocanopy_3", ground_types)
Layouts["pig_ruins_nocanopy_4"] = StaticLayout.Get("map/static_layouts/pig_ruins_nocanopy_4", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("pig_ruins_nocanopy_4", ground_types)

Layouts["roc_cave"] = StaticLayout.Get("map/static_layouts/roc_cave", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
Layouts["roc_nest"] = StaticLayout.Get("map/static_layouts/roc_nest", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})

Layouts["cave_entranceham1"] = StaticLayout.Get("map/static_layouts/cave_entranceham1", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("cave_entranceham1", ground_types)

Layouts["cave_entranceham2"] = StaticLayout.Get("map/static_layouts/cave_entranceham2", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("cave_entranceham2", ground_types)

Layouts["cave_entranceham3"] = StaticLayout.Get("map/static_layouts/cave_entranceham3", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("cave_entranceham3", ground_types)

Layouts["ruins_exit"] = StaticLayout.Get("map/static_layouts/ruins_exit", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})

Layouts["ruins_exit2"] = StaticLayout.Get("map/static_layouts/ruins_exit2", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})

Layouts["antqueencave"] = StaticLayout.Get("map/static_layouts/antqueencave", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})

-- 天空之椅
Layouts["ligamundoham"] = StaticLayout.Get("map/static_layouts/ligamundoham", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})

Layouts["ligamundohamexit"] = StaticLayout.Get("map/static_layouts/ligamundohamexit", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})


Layouts["city_park_1"] = StaticLayout.Get("map/static_layouts/city_park_1")
TroRemapLayoutTile("city_park_1", ground_types)
Layouts["city_park_2"] = StaticLayout.Get("map/static_layouts/city_park_2")
TroRemapLayoutTile("city_park_2", ground_types)
Layouts["city_park_3"] = StaticLayout.Get("map/static_layouts/city_park_3")
TroRemapLayoutTile("city_park_3", ground_types)
Layouts["city_park_4"] = StaticLayout.Get("map/static_layouts/city_park_4")
TroRemapLayoutTile("city_park_4", ground_types)
Layouts["city_park_5"] = StaticLayout.Get("map/static_layouts/city_park_5")
TroRemapLayoutTile("city_park_5", ground_types)
Layouts["city_park_6"] = StaticLayout.Get("map/static_layouts/city_park_6")
TroRemapLayoutTile("city_park_6", ground_types)
Layouts["city_park_7"] = StaticLayout.Get("map/static_layouts/city_park_7")
TroRemapLayoutTile("city_park_7", ground_types)
Layouts["city_park_8"] = StaticLayout.Get("map/static_layouts/city_park_8")
TroRemapLayoutTile("city_park_8", ground_types)
Layouts["city_park_9"] = StaticLayout.Get("map/static_layouts/city_park_9")
TroRemapLayoutTile("city_park_9", ground_types)
Layouts["city_park_10"] = StaticLayout.Get("map/static_layouts/city_park_10")
TroRemapLayoutTile("city_park_10", ground_types)
Layouts["pig_playerhouse_1"] = StaticLayout.Get("map/static_layouts/pig_playerhouse_1")
TroRemapLayoutTile("pig_playerhouse_1", ground_types)
Layouts["pig_palace_1"] = StaticLayout.Get("map/static_layouts/pig_palace_1")
TroRemapLayoutTile("pig_palace_1", ground_types)
Layouts["pig_cityhall_1"] = StaticLayout.Get("map/static_layouts/pig_cityhall_1")
TroRemapLayoutTile("pig_cityhall_1", ground_types)


-- 莲花池群系
Layouts["lilypadnovo"] = StaticLayout.Get("map/static_layouts/lilypadnovo", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE,
    areas =
    {
        objetoaleatorio = function()
            return PickSomeWithDups(1,
                { "lotus", "reeds_water", "reeds_water", "reeds_water", "reeds_water", "reeds_water", "reeds_water", "reeds_water", "watercress_planted",
                    "watercress_planted", "watercress_planted", "driftwood_log" })
        end,
    },
})
