local Layouts = require("map/layouts").Layouts
local StaticLayout = require("map/static_layout")

Layouts["gwestatua"] = StaticLayout.Get("map/static_layouts/gwestatua", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE,
})
