require("map/terrain")

-- 只在允许的地皮上
local function OnlyAllow(approved)
    local filter = {}
    for _, v in pairs(GetWorldTileMap()) do
        if not table.contains(approved, v) then
            table.insert(filter, v)
        end
    end
    return filter
end

local only_ocean_filter = {}
for _, v in pairs(GetWorldTileMap()) do
    if v < WORLD_TILES_OCEAN_START or v > WORLD_TILES_OCEAN_END then --把非海水地皮加进去
        table.insert(only_ocean_filter, v)
    end
end

-- 只在海水地皮上
local function OnlyOcean()
    return only_ocean_filter
end

----------------------------------------------------------------------------------------------------
-- 预制体不能在哪些地皮上生成
local MY_TERRAIN_FILTER = {
    -- 哈姆雷特
    reeds_water = OnlyOcean(), --芦苇
    lotus = OnlyOcean(),       --莲花
    lilypad = OnlyOcean(),     --超大荷叶
    hippopotamoose = OnlyOcean(),

    -- 大风平原
    peach_tree1 = { WORLD_TILES.ROAD, WORLD_TILES.WOODFLOOR, WORLD_TILES.CARPET, WORLD_TILES.CHECKER, WORLD_TILES.ROCKY, WORLD_TILES.MARSH }, --桃树
    peach_tree2 = { WORLD_TILES.ROAD, WORLD_TILES.WOODFLOOR, WORLD_TILES.CARPET, WORLD_TILES.CHECKER, WORLD_TILES.ROCKY, WORLD_TILES.MARSH }, --桃树
    peach_tree3 = { WORLD_TILES.ROAD, WORLD_TILES.WOODFLOOR, WORLD_TILES.CARPET, WORLD_TILES.CHECKER, WORLD_TILES.ROCKY, WORLD_TILES.MARSH }, --桃树
}

----------------------------------------------------------------------------------------------------

if troisdev then
    -- 检查写的地皮是否有效
    for terrain, tiles in pairs(MY_TERRAIN_FILTER) do
        for i, tile in ipairs(tiles) do
            if tile == nil then
                TroErrorHandle("modmain/map/terrain.lua里预制体" .. terrain .. "加了不存在的地皮，索引为" .. i, false, false)
            end
        end
    end
end

for terrain, tiles in pairs(MY_TERRAIN_FILTER) do
    table.insert(tiles, WORLD_TILES.ARCHIVE)
    table.insert(tiles, WORLD_TILES.VAULT)
    table.insert(tiles, WORLD_TILES.VAULT_CLEAN)
end

table.tromerge(terrain.filter, MY_TERRAIN_FILTER)
