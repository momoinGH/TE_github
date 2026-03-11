local Layouts = require("map/layouts").Layouts
local StaticLayout = require("map/static_layout")

-- 重新映射布局中ground的数字对应的地皮，由于每个layout.ground_types都是独立的，所以覆盖也没问题
function RemapLayoutTile(layout_name, map)
    local layout = Layouts[layout_name]
    for i, tile_id in pairs(map) do
        while #layout.ground_types < i do
            table.insert(layout.ground_types, WORLD_TILES.IMPASSABLE)
        end
        layout.ground_types[i] = tile_id
    end
end

-- 多层世界，多个传送门
Layouts["lobby"] = StaticLayout.Get("map/static_layouts/lobby", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
RemapLayoutTile("lobby", {
    [2] = WORLD_TILES.COBBLEROAD,
})

-- 海象营地
Layouts["mactuskgrass"] = StaticLayout.Get("map/static_layouts/mactuskgrass", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
Layouts["mastuskrocky"] = StaticLayout.Get("map/static_layouts/mastuskrocky", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
Layouts["mactusksavanna"] = StaticLayout.Get("map/static_layouts/mactusksavanna", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
-- 传送门
Layouts["sw_exit"] = StaticLayout.Get("map/static_layouts/sw_exit", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
Layouts["hamlet_exit"] = StaticLayout.Get("map/static_layouts/hamlet_exit", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
Layouts["sw_entrance"] = StaticLayout.Get("map/static_layouts/sw_entrance", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
Layouts["hamlet_entrance"] = StaticLayout.Get("map/static_layouts/hamlet_entrance", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
Layouts["lobby_exit"] = StaticLayout.Get("map/static_layouts/lobby_exit", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})

Layouts["oceanworldstart"] = StaticLayout.Get("map/static_layouts/oceanworldstart", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})

Layouts["lilypadnovo"] = StaticLayout.Get("map/static_layouts/lilypadnovo", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE,
    areas =
    {
        objetoaleatorio = function()
            local variador = math.random()
            if variador > 0.4 then
                return { "lotus" }
            else
                local tipo = math.random(1, 11)
                if tipo == 1 then return { "reeds_water" } end
                if tipo == 2 then return { "reeds_water" } end
                if tipo == 3 then return { "reeds_water" } end
                if tipo == 4 then return { "reeds_water" } end
                if tipo == 5 then return { "reeds_water" } end
                if tipo == 6 then return { "reeds_water" } end
                if tipo == 7 then return { "reeds_water" } end
                if tipo == 8 then return { "watercress_planted" } end
                if tipo == 9 then return { "watercress_planted" } end
                if tipo == 10 then return { "watercress_planted" } end
                if tipo == 11 then return { "driftwood_log" } end
            end
        end,
    },
})

Layouts["lilypadnovograss"] = StaticLayout.Get("map/static_layouts/lilypadnovograss", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE,
    areas =
    {
        objetoaleatorio = function()
            local variador = math.random()
            if variador > 0.4 then
                return { "lotus" }
            else
                local tipo = math.random(1, 11)
                if tipo == 1 then return { "grass_tall" } end
                if tipo == 2 then return { "grass_tall" } end
                if tipo == 3 then return { "grass_tall" } end
                if tipo == 4 then return { "grass_tall" } end
                if tipo == 5 then return { "grass_tall" } end
                if tipo == 6 then return { "grass_tall" } end
                if tipo == 7 then return { "grass_tall" } end
                if tipo == 8 then return { "watercress_planted" } end
                if tipo == 9 then return { "watercress_planted" } end
                if tipo == 10 then return { "watercress_planted" } end
                if tipo == 11 then return { "driftwood_log" } end
            end
        end,
    },
})


Layouts["mangrove1"] = StaticLayout.Get("map/static_layouts/mangrove1", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    areas =
    {
        treearea = function()
            local stuff = {}

            table.insert(stuff, "tree_mangrove")
            for i = 1, 6 do
                if math.random() < 0.1 then
                    table.insert(stuff, "tree_mangrove")
                end
            end

            table.insert(stuff, "tree_mangrove")
            table.insert(stuff, "oceanvine_deco")


            if math.random() < 0.2 then
                table.insert(stuff, "tree_mangrove")
            end

            for i = 1, 3 do
                if math.random() < 0.3 then
                    table.insert(stuff, "watertree_root")
                end
            end

            for i = 1, 3 do
                if math.random() < 0.3 then
                    table.insert(stuff, "oceanvine_deco")
                end
            end

            for i = 1, 4 do
                if math.random() < 0.3 then
                    table.insert(stuff, "fishinhole")
                end
            end

            for i = 1, 2 do
                if math.random() < 0.3 then
                    table.insert(stuff, "tree_mangrovebee")
                end
            end


            for i = 1, 10 do
                if math.random() < 0.4 then
                    table.insert(stuff, "fireflies")
                end
            end

            return stuff
        end,

        notreearea = function()
            local variador = math.random()
            if variador > 0.4 then
                return { "grasswater" }
            else
                local tipo = math.random(1, 8)
                if tipo == 1 then
                    return { "sapling" }
                elseif tipo == 2 then
                    return { "seacucumber_planted" }
                elseif tipo == 3 then
                    return { "seataro_planted" }
                elseif tipo == 4 then
                    return { "mussel_farm" }
                elseif tipo == 5 then
                    return { "seaweed_planted" }
                elseif tipo == 6 then
                    return { "driftwood_log" }
                elseif tipo == 7 then
                    return { "watercress_planted" }
                elseif tipo == 8 then
                    return { "reeds_water" }
                else
                    return { "grasswater" }
                end
            end
        end,
    },


})


Layouts["mangrove2"] = StaticLayout.Get("map/static_layouts/mangrove1", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    areas =
    {
        treearea = function()
            local stuff = {}

            table.insert(stuff, "tree_mangrove")
            for i = 1, 6 do
                if math.random() < 0.1 then
                    table.insert(stuff, "tree_mangrove")
                end
            end

            table.insert(stuff, "tree_mangrove")
            table.insert(stuff, "oceanvine_deco")


            if math.random() < 0.2 then
                table.insert(stuff, "tree_mangrove")
            end

            for i = 1, 3 do
                if math.random() < 0.3 then
                    table.insert(stuff, "watertree_root")
                end
            end

            for i = 1, 3 do
                if math.random() < 0.3 then
                    table.insert(stuff, "oceanvine_deco")
                end
            end

            for i = 1, 4 do
                if math.random() < 0.3 then
                    table.insert(stuff, "fishinhole")
                end
            end

            for i = 1, 2 do
                if math.random() < 0.3 then
                    table.insert(stuff, "tree_mangrovebee")
                end
            end


            for i = 1, 10 do
                if math.random() < 0.4 then
                    table.insert(stuff, "fireflies")
                end
            end

            return stuff
        end,

        notreearea = function()
            local variador = math.random()
            if variador > 0.6 then
                return { "oceanbambootree" }
            else
                local tipo = math.random(1, 10)
                if tipo == 1 then
                    return { "sapling" }
                elseif tipo == 2 then
                    return { "seacucumber_planted" }
                elseif tipo == 3 then
                    return { "seataro_planted" }
                elseif tipo == 4 then
                    return { "mussel_farm" }
                elseif tipo == 5 then
                    return { "oceanbush_vine" }
                elseif tipo == 6 then
                    return { "driftwood_log" }
                elseif tipo == 7 then
                    return { "oceanbush_vine" }
                elseif tipo == 8 then
                    return { "oceanbush_vine" }
                elseif tipo == 9 then
                    return { "oceanbambootreebig" }
                elseif tipo == 10 then
                    return { "oceanbambootreebig" }
                else
                    return { "oceanbambootree" }
                end
            end
        end,
    },


})


Layouts["oceanforest"] = StaticLayout.Get("map/static_layouts/oceanforest", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    disable_transform = true,
    areas =
    {
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
                    return { "grasswater" }
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
                return { "grasswater" }
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
-----------------------------------------------------------------------------------------------			


Layouts["wildboreking"] = StaticLayout.Get("map/static_layouts/wildboreking", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})


Layouts["iceberg1"] = StaticLayout.Get("map/static_layouts/iceberg1", {

    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    layout_position = LAYOUT_POSITION.CENTER,
    disable_transform = true,

    areas =
    {
        treearea = function()
            local stuff = {}

            table.insert(stuff, "rock_ice_frost")
            for i = 1, 6 do
                if math.random() < 0.1 then
                    table.insert(stuff, "rock_ice_frost")
                end
            end

            table.insert(stuff, "rock_ice_frost")
            table.insert(stuff, "rock_ice_frost")


            if math.random() < 0.2 then
                table.insert(stuff, "rock_ice_frost")
            end

            for i = 1, 3 do
                if math.random() < 0.6 then
                    table.insert(stuff, "icedpad")
                end
            end

            for i = 1, 3 do
                if math.random() < 0.3 then
                    table.insert(stuff, "fishinhole")
                end
            end

            for i = 1, 2 do
                if math.random() < 0.3 then
                    table.insert(stuff, "whale_bluefinal")
                end
            end


            for i = 1, 4 do
                if math.random() < 0.4 then
                    table.insert(stuff, "rock_ice_frost")
                end
            end

            return stuff
        end,

    },
})


Layouts["CropCirclegorge"] =
{
    type = LAYOUT.CIRCLE_RANDOM,
    defs =
    {
        unknown_plant = { "potato_planted", "tomato_planted", },
    },
    count =
    {
        unknown_plant = 15,
    },
    scale = 1.5
}
