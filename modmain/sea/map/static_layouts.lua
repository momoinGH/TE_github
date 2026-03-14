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
                if tipo == 6 then return { "grass_water" } end
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

Layouts["oceanworldstart"] = StaticLayout.Get("map/static_layouts/oceanworldstart", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})

Layouts["oceanforest"] = StaticLayout.Get("map/static_layouts/oceanforest", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    disable_transform = true,
    areas = {
        objetoaleatorio = function()
            local variador = math.random()
            if variador > 0.3 then
                return { "tree_mangrove" }
            else
                local tipo = math.random(1, 20)
                if tipo == 1 then
                    return { "frogsplash" }
                elseif tipo == 2 then
                    return { "sapling" }
                elseif tipo == 3 then
                    return { "tree_mangrovebee" }
                elseif tipo == 4 then
                    return { "tentacleunderwater" }
                elseif tipo == 5 then
                    return { "spidercoralhole" }
                elseif tipo == 6 then
                    return { "grass_water" }
                elseif tipo == 7 then
                    return { "fishinhole" }
                elseif tipo == 8 then
                    return { "waterygrave" }
                elseif tipo == 9 then
                    return { "redbarrel" }
                elseif tipo == 10 then
                    return { "mermboat" }
                elseif tipo == 11 then
                    return { "seacucumber_planted" }
                elseif tipo == 12 then
                    return { "seataro_planted" }
                elseif tipo == 13 then
                    return { "mussel_farm" }
                elseif tipo == 14 then
                    return { "seaweed_planted" }
                elseif tipo == 15 then
                    return { "oxbaby" }
                elseif tipo == 16 then
                    return { "ox" }
                elseif tipo == 17 then
                    return { "driftwood_log" }
                elseif tipo == 18 then
                    return { "watercress_planted" }
                elseif tipo == 19 then
                    return { "reeds_water" }
                elseif tipo == 20 then
                    return { "luggagechest_spawner" }
                else
                    return { "tree_mangrove" }
                end
            end
        end,
    },
})

Layouts["oceanrocks"] = StaticLayout.Get("map/static_layouts/oceanrocks", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    disable_transform = true,
    areas =
    {
        rochaaleatoria = function()
            local variador = math.random()
            if variador > 0.8 then
                return { "grass_water" }
            else
                local tipo = math.random(1, 10)
                if tipo == 1 then return { "tree_mangrovebee" } end
                if tipo == 2 then return { "frogsplash" } end
                if tipo == 3 then return { "frogsplash" } end
                if tipo == 4 then return { "frogsplash" } end
                if tipo == 5 then return { "frogsplash" } end
                if tipo == 6 then return { "sapling" } end
                if tipo == 7 then return { "reeds_water" } end
                if tipo == 8 then return { "reeds_water" } end
                if tipo == 9 then return { "seaweed_planted" } end
                if tipo == 10 then return { "mussel_farm" } end
            end
        end,
    },
})

Layouts["icebergs"] = StaticLayout.Get("map/static_layouts/icebergs", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})

Layouts["oceangrotolunar"] = StaticLayout.Get("map/static_layouts/oceangrotolunar", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
