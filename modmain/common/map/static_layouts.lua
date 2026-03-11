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

Layouts["wildboreking"] = StaticLayout.Get("map/static_layouts/wildboreking", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
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
