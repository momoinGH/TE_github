local Layouts = require("map/layouts").Layouts
local StaticLayout = require("map/static_layout")

-- 度假营地
Layouts["vacation"] = StaticLayout.Get("map/static_layouts/vacation", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
-- TroRemapLayoutTile("vacation", {
--     [6] = WORLD_TILES.BEACH
-- })

-- 黄金球，金色方尖碑
Layouts["eldorado"] = StaticLayout.Get("map/static_layouts/eldorado", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
-- 部落帐篷
Layouts["tikitribe"] = StaticLayout.Get("map/static_layouts/tikitribe", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
