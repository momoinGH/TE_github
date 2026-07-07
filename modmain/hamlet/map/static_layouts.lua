local Layouts = require("map/layouts").Layouts
local StaticLayout = require("map/static_layout")

-- 直接把单机版的表拿来了
local ground_types = {
    -- Translates tile type index from constants.lua into tiled tileset.
    -- Order they appear here is the order they will be used in tiled.
    --联机版也有的
    WORLD_TILES.IMPASSABLE,
    WORLD_TILES.ROAD or 0,
    WORLD_TILES.ROCKY or 0,
    WORLD_TILES.DIRT or 0,
    WORLD_TILES.SAVANNA or 0,
    WORLD_TILES.GRASS or 0,
    WORLD_TILES.FOREST or 0,
    WORLD_TILES.MARSH or 0,
    WORLD_TILES.WOODFLOOR or 0,
    WORLD_TILES.CARPET or 0,
    WORLD_TILES.CHECKER or 0,
    WORLD_TILES.CAVE or 0,
    WORLD_TILES.FUNGUS or 0,
    WORLD_TILES.SINKHOLE or 0,
    GROUND.WALL_ROCKY or 0,
    GROUND.WALL_DIRT or 0,
    GROUND.WALL_MARSH or 0,
    GROUND.WALL_CAVE or 0,
    GROUND.WALL_FUNGUS or 0,
    GROUND.WALL_SINKHOLE or 0,
    WORLD_TILES.UNDERROCK or 0,
    WORLD_TILES.MUD or 0,
    GROUND.WALL_MUD or 0,
    GROUND.WALL_WOOD or 0,
    WORLD_TILES.BRICK or 0,
    WORLD_TILES.BRICK_GLOW or 0,
    WORLD_TILES.TILES or 0,
    WORLD_TILES.TILES_GLOW or 0,
    WORLD_TILES.TRIM or 0,
    WORLD_TILES.TRIM_GLOW or 0,
    GROUND.WALL_HUNESTONE or 0,
    GROUND.WALL_HUNESTONE_GLOW or 0,
    GROUND.WALL_STONEEYE or 0,
    GROUND.WALL_STONEEYE_GLOW or 0,
    WORLD_TILES.FUNGUSRED or 0,
    WORLD_TILES.FUNGUSGREEN or 0,

    --哈姆雷特的
    WORLD_TILES.BEACH or 0,
    WORLD_TILES.JUNGLE or 0,
    WORLD_TILES.SWAMP or 0, --没定义
    WORLD_TILES.OCEAN_SHALLOW or 0,
    WORLD_TILES.OCEAN_MEDIUM or 0,
    WORLD_TILES.OCEAN_DEEP or 0,
    WORLD_TILES.OCEAN_CORAL or 0,
    WORLD_TILES.MANGROVE or 0,
    WORLD_TILES.MAGMAFIELD or 0,
    WORLD_TILES.TIDALMARSH or 0,
    WORLD_TILES.MEADOW or 0,
    WORLD_TILES.VOLCANO or 0,
    WORLD_TILES.VOLCANO_LAVA or 0, --没定义，哈姆雷特不需要
    WORLD_TILES.ASH or 0,
    WORLD_TILES.VOLCANO_ROCK or 0,
    WORLD_TILES.OCEAN_SHIPGRAVEYARD or 0,
    WORLD_TILES.COBBLEROAD or 0,
    WORLD_TILES.FOUNDATION or 0,
    WORLD_TILES.DEEPRAINFOREST or 0,
    WORLD_TILES.LAWN or 0,              --56
    WORLD_TILES.PIGRUINS or 0,
    WORLD_TILES.LILYPOND or 0,          --58
    WORLD_TILES.GASRAINFOREST or 0,
    WORLD_TILES.SUBURB or 0,            --60
    WORLD_TILES.RAINFOREST or 0,        --61
    WORLD_TILES.PIGRUINS_NOCANOPY or 0, --室内地皮，没有
    WORLD_TILES.PLAINS or 0,
    WORLD_TILES.PAINTED or 0,
    WORLD_TILES.BATTLEGROUND or 0,
    WORLD_TILES.INTERIOR or 0, --室内地皮，没有
    WORLD_TILES.FIELDS or 0
}

local function GetHamletStaticLayout(name, data, path, custom_ground_types)
    path = path or ("map/static_layouts/" .. name)
    data = data and deepcopy(data) or {} --data需要拷贝一份，会被修改的
    Layouts[name] = StaticLayout.Get(path, data)
    TroRemapLayoutTile(name, custom_ground_types or ground_types)
    return Layouts[name]
end

local function CenterPosition()
    return {
        layout_position = LAYOUT_POSITION.CENTER,
        start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
        fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    }
end

local function RandomPosition()
    return {
        layout_position = LAYOUT_POSITION.RANDOM,
        start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
        fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    }
end


-- 不老泉
GetHamletStaticLayout("pugalisk_fountain", CenterPosition())

-- 农场
GetHamletStaticLayout("farm_1", RandomPosition())
GetHamletStaticLayout("farm_2", RandomPosition())
GetHamletStaticLayout("farm_3", RandomPosition())
GetHamletStaticLayout("farm_4", RandomPosition())
GetHamletStaticLayout("farm_5", RandomPosition())
-- 瞭望塔
GetHamletStaticLayout("farm_fill_1", RandomPosition())
GetHamletStaticLayout("farm_fill_2", RandomPosition())
GetHamletStaticLayout("farm_fill_3", RandomPosition())
-- 城镇
GetHamletStaticLayout("cidade1", CenterPosition(), nil, {
    [2] = WORLD_TILES.COBBLEROAD,
    [4] = WORLD_TILES.FOUNDATION,
    [6] = WORLD_TILES.LAWN
})
GetHamletStaticLayout("cidade2", CenterPosition(), nil, {
    [2] = WORLD_TILES.COBBLEROAD,
    [4] = WORLD_TILES.FOUNDATION,
    [6] = WORLD_TILES.LAWN
})


-- 曼德拉丘
GetHamletStaticLayout("mandraketown", CenterPosition())

-- 出生点
GetHamletStaticLayout("porkland_start", CenterPosition())
GetHamletStaticLayout("start_ham", CenterPosition())

GetHamletStaticLayout("nettlegrove", RandomPosition())

GetHamletStaticLayout("pig_ruins_entrance_1", CenterPosition())
GetHamletStaticLayout("pig_ruins_entrance_2", CenterPosition())
GetHamletStaticLayout("pig_ruins_entrance_3", CenterPosition())
GetHamletStaticLayout("pig_ruins_entrance_4", CenterPosition())
GetHamletStaticLayout("pig_ruins_entrance_5", CenterPosition())

GetHamletStaticLayout("pig_ruins_exit_1", CenterPosition())
GetHamletStaticLayout("pig_ruins_exit_2", CenterPosition())
GetHamletStaticLayout("pig_ruins_exit_4", CenterPosition())


-- 睡莲使用静态布局，和单机的不是同一个布局
GetHamletStaticLayout("lilypad")

GetHamletStaticLayout("pig_ruins_artichoke", CenterPosition())

GetHamletStaticLayout("pig_ruins_head", {
    areas = {
        item1 = { "pig_ruins_head" },
        item2 = function()
            local list = { "smashingpot", "grass", "pig_ruins_torch" }
            for i = #list, 1, -1 do
                if math.random() < 0.7 then
                    table.remove(list, i)
                end
            end
            return list
        end,
    },
})

GetHamletStaticLayout("pig_ruins_nocanopy", CenterPosition())
GetHamletStaticLayout("pig_ruins_nocanopy_2", CenterPosition())
GetHamletStaticLayout("pig_ruins_nocanopy_3", CenterPosition())
GetHamletStaticLayout("pig_ruins_nocanopy_4", CenterPosition())

GetHamletStaticLayout("roc_cave", CenterPosition())
GetHamletStaticLayout("roc_nest", CenterPosition())

GetHamletStaticLayout("cave_entranceham1", CenterPosition())
GetHamletStaticLayout("cave_entranceham2", CenterPosition())
GetHamletStaticLayout("cave_entranceham3", CenterPosition())

GetHamletStaticLayout("ruins_exit", CenterPosition())

GetHamletStaticLayout("ruins_exit2", CenterPosition())

GetHamletStaticLayout("antqueencave", CenterPosition())

-- 天空之椅
GetHamletStaticLayout("ligamundoham", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})
GetHamletStaticLayout("ligamundohamexit", {
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
})


GetHamletStaticLayout("city_park_1")
GetHamletStaticLayout("city_park_2")
GetHamletStaticLayout("city_park_3")
GetHamletStaticLayout("city_park_4")
GetHamletStaticLayout("city_park_5")
GetHamletStaticLayout("city_park_6")
GetHamletStaticLayout("city_park_7")
GetHamletStaticLayout("city_park_8")
GetHamletStaticLayout("city_park_9")
GetHamletStaticLayout("city_park_10")
GetHamletStaticLayout("pig_playerhouse_1")
GetHamletStaticLayout("pig_palace_1")
GetHamletStaticLayout("pig_cityhall_1")


-- 莲花池群系
GetHamletStaticLayout("lilypadnovo", {
    layout_position = LAYOUT_POSITION.CENTER,
    start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
    areas =
    {
        objetoaleatorio = function()
            return PickSomeWithDups(1,
                { "lotus", "reeds_water", "reeds_water", "reeds_water", "reeds_water", "reeds_water", "reeds_water", "reeds_water", "watercress_planted",
                    "watercress_planted", "watercress_planted", "driftwood_log" })
        end,
    },
})
