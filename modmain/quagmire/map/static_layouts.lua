local Layouts = require("map/layouts").Layouts
local StaticLayout = require("map/static_layout")

-- 给暴食布局周围加一点空间，因为这个room太大，很容易出现和其他地形接壤的情况
-- Reserve extra ocean around the 50x50 event layout so other regions cannot touch it.
local QUAGMIRE_PADDING = 12
local quagmire_layout = Layouts["Quagmire_Kitchen"]
if quagmire_layout then
    local padded_ground = {}
    local padded_size = #quagmire_layout.ground + QUAGMIRE_PADDING * 2

    for y = 1, padded_size do
        local row = {}
        for x = 1, padded_size do
            local source_y = y - QUAGMIRE_PADDING
            local source_x = x - QUAGMIRE_PADDING
            row[x] = quagmire_layout.ground[source_y] ~= nil
                and quagmire_layout.ground[source_y][source_x]
                or 0
        end
        padded_ground[y] = row
    end

    quagmire_layout.ground = padded_ground
end


----------------------------------------------------------------------------------------------------

Layouts["strangerpigs"] = StaticLayout.Get("map/static_layouts/strangerpigs", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})

Layouts["mermtrader1set"] = StaticLayout.Get("map/static_layouts/mermtrader1set", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})

Layouts["mermtrader2set"] = StaticLayout.Get("map/static_layouts/mermtrader2set", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})

Layouts["mermtrader3set"] = StaticLayout.Get("map/static_layouts/mermtrader3set", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("mermtrader3set", {
    [23] = WORLD_TILES.QUAGMIRE_GATEWAY,
    [55] = WORLD_TILES.ROAD
})

Layouts["elderpig"] = StaticLayout.Get("map/static_layouts/elderpig", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})

Layouts["goatkid"] = StaticLayout.Get("map/static_layouts/goatkid", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    areas =
    {
        oldcity = function()
            local tipo = math.random(1, 12)
            if tipo == 1 then return { "quagmire_rubble_pubdoor" } end
            if tipo == 2 then return { "quagmire_rubble_cathedral" } end
            if tipo == 3 then return { "quagmire_rubble_clock" } end
            if tipo == 4 then return { "quagmire_rubble_chimney" } end
            if tipo == 5 then return { "quagmire_rubble_carriage" } end
            if tipo == 6 then return { "quagmire_rubble_clocktower" } end
            if tipo == 7 then return { "quagmire_rubble_empty" } end
            if tipo == 8 then return { "rocks" } end
            if tipo == 9 then return { "firepit" } end
            if tipo == 10 then return { "quagmire_lamp_post" } end
            if tipo == 11 then return { "quagmire_lamp_post" } end
            if tipo == 12 then return { "quagmire_lamp_post" } end
        end,
    },
})
TroRemapLayoutTile("goatkid", {
    [2] = WORLD_TILES.QUAGMIRE_CITYSTONE,
})

Layouts["goatkid2"] = StaticLayout.Get("map/static_layouts/goatkid2", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    areas =
    {
        oldcity = function()
            local tipo = math.random(1, 12)
            if tipo == 1 then return { "quagmire_rubble_bike" } end
            if tipo == 2 then return { "quagmire_rubble_chimney2" } end
            if tipo == 3 then return { "quagmire_rubble_roof" } end
            if tipo == 4 then return { "quagmire_pond_salt" } end
            if tipo == 5 then return { "quagmire_rubble_chimney" } end
            if tipo == 6 then return { "quagmire_pond_salt" } end
            if tipo == 7 then return { "rocks" } end
            if tipo == 8 then return { "firepit" } end
            if tipo == 9 then return { "quagmire_lamp_post" } end
            if tipo == 10 then return { "quagmire_lamp_post" } end
            if tipo == 11 then return { "quagmire_lamp_post" } end
            if tipo == 12 then return { "quagmire_rubble_empty" } end
        end,
    },
})
TroRemapLayoutTile("goatkid2", {
    [2] = WORLD_TILES.QUAGMIRE_CITYSTONE,
})

----------------------------------------------------------------------------------------------------
-- 加一个传送门的简单静态布局
Layouts["TE_QuagmirePortal"] = {
    type = LAYOUT.STATIC,

    ground_types = {
        WORLD_TILES.IMPASSABLE,
        WORLD_TILES.MARSH,
    },

    -- 预留一小块沼泽地，避免传送门压在水池或地形边缘。
    ground = {
        { 2, 2, 2 },
        { 2, 2, 2 },
        { 2, 2, 2 },
    },

    layout = {
        quagmire_portal = {
            { x = 0, y = 0 },
        },
    },

    scale = 1,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
}
