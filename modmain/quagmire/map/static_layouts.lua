local Layouts = require("map/layouts").Layouts
local StaticLayout = require("map/static_layout")


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

Layouts["mermtrader3setmainland"] = StaticLayout.Get("map/static_layouts/mermtrader3setmainland", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
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

Layouts["quagmire_kitchen"] = StaticLayout.Get("map/static_layouts/quagmire_kitchen", {

    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    layout_position = LAYOUT_POSITION.CENTER,
    disable_transform = true,

    areas =
    {
        quagmire_parkspike_row = function(area, data)
            local vert = data.height > data.width
            --				local x = vert and (data.x) or (data.x - data.width/2.0)
            --				local y = vert and (data.y - data.height/2.0) or (data.y)
            local x = data.x - data.width / 2.0
            local y = data.y - data.height / 2.0
            local spacing = 0.18
            local num = math.ceil((vert and data.height or data.width) / spacing)

            local prefabs = {}
            for i = 1, num do
                table.insert(prefabs,
                    {
                        prefab = i % 2 == (vert and 0 or 1) and "quagmire_parkspike_short" or "quagmire_parkspike",
                        x = x,
                        y = y,
                    })
                if vert then
                    y = y + spacing
                else
                    x = x + spacing
                end
            end
            return prefabs
        end,
    },
})
TroRemapLayoutTile("quagmire_kitchen", {
    [2] = WORLD_TILES.ROAD,
    [15] = WORLD_TILES.QUAGMIRE_GATEWAY,
    [23] = WORLD_TILES.QUAGMIRE_PEATFOREST,
    [31] = WORLD_TILES.QUAGMIRE_PARKSTONE,
    [32] = WORLD_TILES.QUAGMIRE_PARKFIELD,
    [40] = WORLD_TILES.QUAGMIRE_CITYSTONE
})
