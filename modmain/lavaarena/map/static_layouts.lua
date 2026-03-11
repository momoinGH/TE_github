local Layouts = require("map/layouts").Layouts
local StaticLayout = require("map/static_layout")

-- 熔炉竞技场
Layouts["lava_arena"] = StaticLayout.Get("map/static_layouts/lava_arena", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    layout_position = LAYOUT_POSITION.CENTER,
    disable_transform = true,
})
RemapLayoutTile("lava_arena", {
    [2] = WORLD_TILES.LAVALAND,
    [30] = WORLD_TILES.BATFLOOR
})