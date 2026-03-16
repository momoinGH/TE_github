local Layouts = require("map/layouts").Layouts
local StaticLayout = require("map/static_layout")


-- 麦斯威尔的暗影心脏
Layouts["strangerlord"] = StaticLayout.Get("map/static_layouts/strangerlord", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})

Layouts["city"] = StaticLayout.Get("map/static_layouts/city", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("city", {
    [2] = WORLD_TILES.SNOWLAND,
    [3] = WORLD_TILES.SNOWLAND,
    [6] = WORLD_TILES.SNOWLAND
})

Layouts["IceSpiderpillar"] = StaticLayout.Get("map/static_layouts/IceSpiderpillar", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("IceSpiderpillar", {
    [3] = WORLD_TILES.SNOWLAND
})
