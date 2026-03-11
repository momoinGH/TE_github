local Layouts = require("map/layouts").Layouts
local StaticLayout = require("map/static_layout")

-- 直接把单机版的表拿来了
local hamlet_tile_remap = {
    --Translates tile type index from constants.lua into tiled tileset.
    --Order they appear here is the order they will be used in tiled.
    WORLD_TILES.IMPASSABLE, WORLD_TILES.ROAD, WORLD_TILES.ROCKY, WORLD_TILES.DIRT,
    WORLD_TILES.SAVANNA, WORLD_TILES.GRASS, WORLD_TILES.FOREST, WORLD_TILES.MARSH,

    WORLD_TILES.WOODFLOOR, WORLD_TILES.CARPET, WORLD_TILES.CHECKER, WORLD_TILES.CAVE,
    WORLD_TILES.FUNGUS, WORLD_TILES.SINKHOLE, WORLD_TILES.WALL_ROCKY, WORLD_TILES.WALL_DIRT,

    WORLD_TILES.WALL_MARSH, WORLD_TILES.WALL_CAVE, WORLD_TILES.WALL_FUNGUS, WORLD_TILES.WALL_SINKHOLE,
    WORLD_TILES.UNDERROCK, WORLD_TILES.MUD, WORLD_TILES.WALL_MUD, WORLD_TILES.WALL_WOOD,

    WORLD_TILES.BRICK, WORLD_TILES.BRICK_GLOW, WORLD_TILES.TILES, WORLD_TILES.TILES_GLOW,
    WORLD_TILES.TRIM, WORLD_TILES.TRIM_GLOW, WORLD_TILES.WALL_HUNESTONE, WORLD_TILES.WALL_HUNESTONE_GLOW,

    WORLD_TILES.WALL_STONEEYE, WORLD_TILES.WALL_STONEEYE_GLOW, WORLD_TILES.FUNGUSRED, WORLD_TILES.FUNGUSGREEN,
    WORLD_TILES.BEACH, WORLD_TILES.JUNGLE, WORLD_TILES.SWAMP, WORLD_TILES.OCEAN_SHALLOW,

    WORLD_TILES.OCEAN_MEDIUM, WORLD_TILES.OCEAN_DEEP, WORLD_TILES.OCEAN_CORAL, WORLD_TILES.MANGROVE,
    WORLD_TILES.MAGMAFIELD, WORLD_TILES.TIDALMARSH, WORLD_TILES.MEADOW, WORLD_TILES.VOLCANO,

    WORLD_TILES.VOLCANO_LAVA, WORLD_TILES.ASH, WORLD_TILES.VOLCANO_ROCK, WORLD_TILES.OCEAN_SHIPGRAVEYARD,
    WORLD_TILES.COBBLEROAD, WORLD_TILES.FOUNDATION, WORLD_TILES.DEEPRAINFOREST, WORLD_TILES.LAWN,

    WORLD_TILES.PIGRUINS, WORLD_TILES.LILYPOND, WORLD_TILES.GASJUNGLE, WORLD_TILES.SUBURB,
    WORLD_TILES.RAINFOREST, WORLD_TILES.PIGRUINS_NOCANOPY, WORLD_TILES.PLAINS, WORLD_TILES.PAINTED,

    WORLD_TILES.BATTLEGROUND, WORLD_TILES.INTERIOR, WORLD_TILES.FIELDS }

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
RemapLayoutTile("farm_1", hamlet_tile_remap)
Layouts["farm_2"] = StaticLayout.Get("map/static_layouts/farm_2", {
    layout_position = LAYOUT_POSITION.RANDOM,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
RemapLayoutTile("farm_2", hamlet_tile_remap)
Layouts["farm_3"] = StaticLayout.Get("map/static_layouts/farm_3", {
    layout_position = LAYOUT_POSITION.RANDOM,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
RemapLayoutTile("farm_3", hamlet_tile_remap)
Layouts["farm_4"] = StaticLayout.Get("map/static_layouts/farm_4", {
    layout_position = LAYOUT_POSITION.RANDOM,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
RemapLayoutTile("farm_4", hamlet_tile_remap)
Layouts["farm_5"] = StaticLayout.Get("map/static_layouts/farm_5", {
    layout_position = LAYOUT_POSITION.RANDOM,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
RemapLayoutTile("farm_5", hamlet_tile_remap)
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
RemapLayoutTile("cidade1", {
    [2] = WORLD_TILES.COBBLEROAD,
    [4] = WORLD_TILES.FOUNDATION,
    [6] = WORLD_TILES.LAWN
})

Layouts["cidade2"] = StaticLayout.Get("map/static_layouts/cidade2", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
RemapLayoutTile("cidade2", {
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
RemapLayoutTile("nettlegrove", hamlet_tile_remap)

Layouts["pig_ruins_entrance_1"] = StaticLayout.Get("map/static_layouts/pig_ruins_entrance_1", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
RemapLayoutTile("pig_ruins_entrance_1", hamlet_tile_remap)

Layouts["pig_ruins_entrance_2"] = StaticLayout.Get("map/static_layouts/pig_ruins_entrance_2", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
RemapLayoutTile("pig_ruins_entrance_2", hamlet_tile_remap)

Layouts["pig_ruins_entrance_3"] = StaticLayout.Get("map/static_layouts/pig_ruins_entrance_3", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
RemapLayoutTile("pig_ruins_entrance_3", hamlet_tile_remap)

Layouts["pig_ruins_entrance_4"] = StaticLayout.Get("map/static_layouts/pig_ruins_entrance_4", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
RemapLayoutTile("pig_ruins_entrance_4", hamlet_tile_remap)
Layouts["pig_ruins_entrance_5"] = StaticLayout.Get("map/static_layouts/pig_ruins_entrance_5", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
RemapLayoutTile("pig_ruins_entrance_5", hamlet_tile_remap)

Layouts["pig_ruins_exit_1"] = StaticLayout.Get("map/static_layouts/pig_ruins_exit_1", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
RemapLayoutTile("pig_ruins_exit_1", hamlet_tile_remap)

Layouts["pig_ruins_exit_2"] = StaticLayout.Get("map/static_layouts/pig_ruins_exit_2", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
RemapLayoutTile("pig_ruins_exit_2", hamlet_tile_remap)

Layouts["pig_ruins_exit_4"] = StaticLayout.Get("map/static_layouts/pig_ruins_exit_4", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})

Layouts["lilypad"] = StaticLayout.Get("map/static_layouts/lilypad", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
RemapLayoutTile("lilypad", {
    [58] = WORLD_TILES.OCEAN_COASTAL,
})

Layouts["pig_ruins_artichoke"] = StaticLayout.Get("map/static_layouts/pig_ruins_artichoke", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})

Layouts["pig_ruins_head"] = StaticLayout.Get("map/static_layouts/pig_ruins_head", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
RemapLayoutTile("pig_ruins_head", hamlet_tile_remap)

Layouts["pig_ruins_nocanopy"] = StaticLayout.Get("map/static_layouts/pig_ruins_nocanopy", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
RemapLayoutTile("pig_ruins_nocanopy", hamlet_tile_remap)
Layouts["pig_ruins_nocanopy_2"] = StaticLayout.Get("map/static_layouts/pig_ruins_nocanopy_2", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
RemapLayoutTile("pig_ruins_nocanopy_2", hamlet_tile_remap)
Layouts["pig_ruins_nocanopy_3"] = StaticLayout.Get("map/static_layouts/pig_ruins_nocanopy_3", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
RemapLayoutTile("pig_ruins_nocanopy_3", hamlet_tile_remap)
Layouts["pig_ruins_nocanopy_4"] = StaticLayout.Get("map/static_layouts/pig_ruins_nocanopy_4", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
RemapLayoutTile("pig_ruins_nocanopy_4", hamlet_tile_remap)

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
RemapLayoutTile("cave_entranceham1", hamlet_tile_remap)

Layouts["cave_entranceham2"] = StaticLayout.Get("map/static_layouts/cave_entranceham2", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
RemapLayoutTile("cave_entranceham2", hamlet_tile_remap)

Layouts["cave_entranceham3"] = StaticLayout.Get("map/static_layouts/cave_entranceham3", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
RemapLayoutTile("cave_entranceham3", hamlet_tile_remap)

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
