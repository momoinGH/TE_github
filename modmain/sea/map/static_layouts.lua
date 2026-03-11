local Layouts = require("map/layouts").Layouts
local StaticLayout = require("map/static_layout")

Layouts["oceanbamboforest"] = StaticLayout.Get("map/static_layouts/oceanbamboforest", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    disable_transform = true,
    areas =
    {
        objetoaleatorio = function()
            local variador = math.random()
            if variador > 0.3 then
                return { "oceanbambootree" }
            else
                local tipo = math.random(1, 20)
                if tipo == 1 then return { "frogsplash" } end
                if tipo == 2 then return { "frogsplash" } end
                if tipo == 3 then return { "tree_mangrovebee" } end
                if tipo == 4 then return { "oceanbambootreebig" } end
                if tipo == 5 then return { "spidercoralhole" } end
                if tipo == 6 then return { "grasswater" } end
                if tipo == 7 then return { "fishinhole" } end
                if tipo == 8 then return { "waterygrave" } end
                if tipo == 9 then return { "sapling" } end
                if tipo == 10 then return { "oceanbush_vine" } end
                if tipo == 11 then return { "oceanbambootreebig" } end
                if tipo == 12 then return { "oceanbambootreebig" } end
                if tipo == 13 then return { "mussel_farm" } end
                if tipo == 14 then return { "seaweed_planted" } end
                if tipo == 15 then return { "oceanbush_vine" } end
                if tipo == 16 then return { "tree_mangrovebee" } end
                if tipo == 17 then return { "driftwood_log" } end
                if tipo == 18 then return { "sapling" } end
                if tipo == 19 then return { "oceanbush_vine" } end
                if tipo == 20 then return { "oceanbush_vine" } end
            end
        end,
    },
})
