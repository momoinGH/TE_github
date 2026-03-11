local Layouts = require("map/layouts").Layouts
local StaticLayout = require("map/static_layout")

Layouts["atlantida"] = StaticLayout.Get("map/static_layouts/atlantida", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
RemapLayoutTile("atlantida", {
    [1] = WORLD_TILES.IMPASSABLE,
    [2] = WORLD_TILES.PIGRUINS,
    [9] = WORLD_TILES.UNDERWATER_ROCKY
})
