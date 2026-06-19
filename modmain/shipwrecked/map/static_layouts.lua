local Layouts = require("map/layouts").Layouts
local StaticLayout = require("map/static_layout")

-- 内部会修改这个表，不能复用
local function GetDefaultLayoutData()
    return {
        layout_position = LAYOUT_POSITION.CENTER,
        start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
        fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    }
end


-- 猫鲨
Layouts["sharkhome"] = StaticLayout.Get("map/static_layouts/sharkhome", {
    start_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE, --配合room虚空地皮，可以只在虚空地皮上（铺海洋前）生成布局
    fill_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE,
})
TroRemapLayoutTile("sharkhome", {
    [37] = WORLD_TILES.BEACH,
})

-- 咖啡丛
Layouts["CoffeeBushBunch"] = StaticLayout.Get("map/static_layouts/coffeebushbunch", GetDefaultLayoutData())
--火山出口
Layouts["Entradavulcao"] = StaticLayout.Get("map/static_layouts/volcano_start", GetDefaultLayoutData())
-- 黑曜石工作台
Layouts["ObsidianWorkbench"] = StaticLayout.Get("map/static_layouts/volcano_workbench", GetDefaultLayoutData())
-- 海盗船长的牢笼
Layouts["WoodlegsUnlock"] = StaticLayout.Get("map/static_layouts/woodlegs_unlock", GetDefaultLayoutData())
-- 火豹卷
Layouts["volcano_altar"] = StaticLayout.Get("map/static_layouts/volcano_altar", GetDefaultLayoutData())
-- 丛林树精
Layouts["LivingJungleTree"] = StaticLayout.Get("map/static_layouts/livingjungletree")

-- 竹丛、藤蔓、浆果
Layouts["BerryBushBunch"] = StaticLayout.Get("map/static_layouts/berrybushbunch", GetDefaultLayoutData())
-- 老虎机
Layouts["slotmachine"] = StaticLayout.Get("map/static_layouts/slotmachine", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
--矿堆、宝藏
Layouts["skull_isle2"] = StaticLayout.Get("map/static_layouts/skull_isle2", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("skull_isle2", {
    [3] = WORLD_TILES.MAGMAFIELD,
    [8] = WORLD_TILES.BEACH,
})

-- 珊瑚
Layouts["coral"] = StaticLayout.Get("map/static_layouts/coral", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
-- 渡渡鸟
Layouts["doydoym"] = StaticLayout.Get("map/static_layouts/doydoym", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("doydoym", {
    [1] = WORLD_TILES.BEACH
})

Layouts["doydoyf"] = StaticLayout.Get("map/static_layouts/doydoyf", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("doydoyf", {
    [1] = WORLD_TILES.BEACH
})

-- 传送门
Layouts["BeachStart"] = StaticLayout.Get("map/static_layouts/beachstart", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
-- 火山
Layouts["volcano_entrance"] = StaticLayout.Get("map/static_layouts/volcano_entrance", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
-- 海盗帽
Layouts["x_spot"] = StaticLayout.Get("map/static_layouts/x_spot", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("x_spot", {
    [3] = WORLD_TILES.BEACH
})

-- 红树
Layouts["pantano"] = StaticLayout.Get("map/static_layouts/pantano", {
    layout_position = LAYOUT_POSITION.RANDOM,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
TroRemapLayoutTile("pantano", {
    [6] = WORLD_TILES.MARSH
})

Layouts["ligamundosw"] = StaticLayout.Get("map/static_layouts/ligamundosw", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})

Layouts["ligamundoswexit"] = StaticLayout.Get("map/static_layouts/ligamundoswexit", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})

Layouts["coralpool1"] = StaticLayout.Get("map/static_layouts/coralpool1", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,

    areas =
    {
        coralzone = function()
            local variador = math.random()
            if variador > 0.4 then
                return { "coralreef" }
            else
                local tipo = math.random(1, 25)
                if tipo == 1 then return { "mussel_farm" } end
                if tipo == 2 then return { "mussel_farm" } end
                if tipo == 3 then return { "mussel_farm" } end
                if tipo == 4 then return { "mussel_farm" } end
                if tipo == 5 then return { "mussel_farm" } end
                if tipo == 6 then return { "seaweed_planted" } end
                if tipo == 7 then return { "seaweed_planted" } end
                if tipo == 8 then return { "seaweed_planted" } end
                if tipo == 9 then return { "seaweed_planted" } end
                if tipo == 10 then return { "seaweed_planted" } end
                if tipo == 11 then return { "spidercoralhole" } end
                if tipo == 12 then return { "spidercoralhole" } end
                if tipo == 13 then return { "ballphinhouse" } end
                if tipo == 14 then return { "ballphinhouse" } end
                if tipo == 15 then return { "ballphinhouse" } end
                if tipo == 16 then return { "fishinhole" } end
                if tipo == 17 then return { "fishinhole" } end
                if tipo == 18 then return { "fishinhole" } end
                if tipo == 19 then return { "fishinhole" } end
                if tipo == 20 then return { "coral_brain_rock" } end
                if tipo == 21 then return { "lobsterhole" } end
                if tipo == 22 then return { "lobsterhole" } end
                if tipo == 23 then return { "lobsterhole" } end
                if tipo == 24 then return { "messagebottle_sw" } end
                if tipo == 25 then return { "tar_pool" } end
            end
        end,
    },
})



Layouts["coralpool2"] = StaticLayout.Get("map/static_layouts/coralpool2", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    areas =
    {
        coralzone = function()
            local variador = math.random()
            if variador > 0.4 then
                return { "coralreef" }
            else
                local tipo = math.random(1, 25)
                if tipo == 1 then return { "mussel_farm" } end
                if tipo == 2 then return { "mussel_farm" } end
                if tipo == 3 then return { "mussel_farm" } end
                if tipo == 4 then return { "mussel_farm" } end
                if tipo == 5 then return { "mussel_farm" } end
                if tipo == 6 then return { "seaweed_planted" } end
                if tipo == 7 then return { "seaweed_planted" } end
                if tipo == 8 then return { "seaweed_planted" } end
                if tipo == 9 then return { "seaweed_planted" } end
                if tipo == 10 then return { "seaweed_planted" } end
                if tipo == 11 then return { "spidercoralhole" } end
                if tipo == 12 then return { "spidercoralhole" } end
                if tipo == 13 then return { "ballphinhouse" } end
                if tipo == 14 then return { "ballphinhouse" } end
                if tipo == 15 then return { "ballphinhouse" } end
                if tipo == 16 then return { "fishinhole" } end
                if tipo == 17 then return { "fishinhole" } end
                if tipo == 18 then return { "fishinhole" } end
                if tipo == 19 then return { "fishinhole" } end
                if tipo == 20 then return { "coral_brain_rock" } end
                if tipo == 21 then return { "lobsterhole" } end
                if tipo == 22 then return { "lobsterhole" } end
                if tipo == 23 then return { "lobsterhole" } end
                if tipo == 24 then return { "messagebottle_sw" } end
                if tipo == 25 then return { "tar_pool" } end
            end
        end,
    },
})


Layouts["coralpool3"] = StaticLayout.Get("map/static_layouts/coralpool3", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    areas =
    {
        coralzone = function()
            local variador = math.random()
            if variador > 0.4 then
                return { "coralreef" }
            else
                local tipo = math.random(1, 25)
                if tipo == 1 then return { "mussel_farm" } end
                if tipo == 2 then return { "mussel_farm" } end
                if tipo == 3 then return { "mussel_farm" } end
                if tipo == 4 then return { "mussel_farm" } end
                if tipo == 5 then return { "mussel_farm" } end
                if tipo == 6 then return { "seaweed_planted" } end
                if tipo == 7 then return { "seaweed_planted" } end
                if tipo == 8 then return { "seaweed_planted" } end
                if tipo == 9 then return { "seaweed_planted" } end
                if tipo == 10 then return { "seaweed_planted" } end
                if tipo == 11 then return { "spidercoralhole" } end
                if tipo == 12 then return { "spidercoralhole" } end
                if tipo == 13 then return { "ballphinhouse" } end
                if tipo == 14 then return { "ballphinhouse" } end
                if tipo == 15 then return { "ballphinhouse" } end
                if tipo == 16 then return { "fishinhole" } end
                if tipo == 17 then return { "fishinhole" } end
                if tipo == 18 then return { "fishinhole" } end
                if tipo == 19 then return { "fishinhole" } end
                if tipo == 20 then return { "ballphinhouse" } end
                if tipo == 21 then return { "lobsterhole" } end
                if tipo == 22 then return { "lobsterhole" } end
                if tipo == 23 then return { "lobsterhole" } end
                if tipo == 24 then return { "messagebottle_sw" } end
                if tipo == 25 then return { "tar_pool" } end
            end
        end,
    },
})

Layouts["wreck"] = StaticLayout.Get("map/static_layouts/wreck", {
    disable_transform = true,
    areas = {
        ship_area = { "wreck" },
        mast_area = function() if math.random() < 0.75 then return { "wreck" } else return {} end end,
        debris_area = PickSomeWithDups(math.random(1, 4), { "boards", "rope", "fabric", "messagebottleempty" })
    },
})

Layouts["wreck2"] = StaticLayout.Get("map/static_layouts/wreck2", {
    disable_transform = true,
    areas = {
        ship_area = { "wreck" },
        mast_area = function() if math.random() < 0.75 then return { "wreck" } else return {} end end,
        debris_area = PickSomeWithDups(math.random(1, 4), { "boards", "rope", "fabric", "messagebottleempty" })
    },
})

-- 海妖
Layouts["kraken"] = StaticLayout.Get("map/static_layouts/kraken", {

    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    layout_position = LAYOUT_POSITION.CENTER,
    disable_transform = true,

    areas =
    {
        debris_area = function()
            local stuff = {}

            table.insert(stuff, "wreck")
            for i = 1, 6 do
                if math.random() < 0.1 then
                    table.insert(stuff, "wreck")
                end
            end

            table.insert(stuff, "luggagechest_spawner")
            table.insert(stuff, "waterygrave")


            if math.random() < 0.2 then
                table.insert(stuff, "luggagechest_spawner")
            end

            for i = 1, 3 do
                if math.random() < 0.3 then
                    table.insert(stuff, "redbarrel")
                end
            end

            for i = 1, 3 do
                if math.random() < 0.3 then
                    table.insert(stuff, "waterygrave")
                end
            end

            for i = 1, 4 do
                if math.random() < 0.1 then
                    table.insert(stuff, "boatfragment01")
                end
            end

            for i = 1, 4 do
                if math.random() < 0.1 then
                    table.insert(stuff, "boatfragment02")
                end
            end


            for i = 1, 4 do
                if math.random() < 0.1 then
                    table.insert(stuff, "boatfragment03")
                end
            end



            for i = 1, 2 do
                if math.random() < 0.3 then
                    table.insert(stuff, "redbarrel")
                end
            end


            for i = 1, 4 do
                if math.random() < 0.1 then
                    table.insert(stuff, "fishinhole")
                end
            end

            return stuff
        end,

    },
})

Layouts["start_sw"] = StaticLayout.Get("map/static_layouts/start_sw", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED, --mask什么意思不太明白
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    layout_position = LAYOUT_POSITION.CENTER,
    disable_transform = true,
    defs = {
        welcomitem = { "flower" }
    },
})

Layouts["lava_arena"] = StaticLayout.Get("map/static_layouts/lava_arena", {
    start_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    layout_position = GLOBAL.LAYOUT_POSITION.CENTER,
    disable_transform = true,
})
Layouts["wildboreking"] = StaticLayout.Get("map/static_layouts/wildboreking", {
    layout_position = GLOBAL.LAYOUT_POSITION.CENTER,
    start_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
