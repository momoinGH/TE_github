-- this file function only for worldgen, in game use main/util.lua functions
local SpawnUtil = {}

local function CheckTileType(tile, check)
    if type(check) == "function" then
        return check(tile)
    end
    return tile == check
end

function SpawnUtil.IsSurroundedByTile(x, y, radius, tile)
    local num_edge_points = math.ceil((radius * 2) / 4) - 1

    -- test the corners first

    if not CheckTileType(WorldSim:GetTile(x + radius, y + radius), tile) then return false end
    if not CheckTileType(WorldSim:GetTile(x - radius, y + radius), tile) then return false end
    if not CheckTileType(WorldSim:GetTile(x + radius, y - radius), tile) then return false end
    if not CheckTileType(WorldSim:GetTile(x - radius, y - radius), tile) then return false end

    -- if the radius is less than 1(2 after the +1), it won't have any edges to test and we can end the testing here.
    if num_edge_points == 0 then return true end

    local dist = (radius * 2) / (num_edge_points + 1)
    -- test the edges next
    for i = 1, num_edge_points do
        local idist = dist * i
        if not CheckTileType(WorldSim:GetTile(x - radius + idist, y + radius), tile) then return false end
        if not CheckTileType(WorldSim:GetTile(x - radius + idist, y - radius), tile) then return false end
        if not CheckTileType(WorldSim:GetTile(x - radius, y - radius + idist), tile) then return false end
        if not CheckTileType(WorldSim:GetTile(x + radius, y - radius + idist), tile) then return false end
    end

    -- test interior points last
    for i = 1, num_edge_points do
        local idist = dist * i
        for j = 1, num_edge_points do
            local jdist = dist * j
            if not CheckTileType(WorldSim:GetTile(x - radius + idist, y - radius + jdist), tile) then return false end
        end
    end
    return true
end

function SpawnUtil.IsSurroundedByWaterTile(x, y, radius)
    return SpawnUtil.IsSurroundedByTile(x, y, radius, IsOceanTile)
end

function SpawnUtil.IsCloseToTile(x, y, radius, check)
    radius = radius or 1
    for i = -radius, radius do
        if CheckTileType(WorldSim:GetTile(x - radius, y + i), check) or CheckTileType(WorldSim:GetTile(x + radius, y + i), check) then
            return true
        end
    end
    for i = -(radius - 1), radius - 1, 1 do
        if CheckTileType(WorldSim:GetTile(x + i, y - radius), check) or CheckTileType(WorldSim:GetTile(x + i, y + radius), check) then
            return true
        end
    end
    return false
end

function SpawnUtil.IsCloseToWaterTile(x, y, radius)
    return SpawnUtil.IsCloseToTile(x, y, radius, IsOceanTile)
end

function SpawnUtil.IsCloseToLandTile(x, y, radius)
    return SpawnUtil.IsCloseToTile(x, y, radius, IsLandTile)
end

function SpawnUtil.GetShortestDistToPrefab(x, y, ents, prefab)
    local w, h = WorldSim:GetWorldSize()
    local halfw, halfh = w / 2, h / 2
    local dist = 100000
    if ents ~= nil and ents[prefab] ~= nil then
        for i, spawn in ipairs(ents[prefab]) do
            local sx, sy = spawn.x, spawn.z
            local dx, dy = (x - halfw) * TILE_SCALE - sx, (y - halfh) * TILE_SCALE - sy
            local d = math.sqrt(dx * dx + dy * dy)
            if d < dist then
                dist = d
            end
            -- print(string.format("SpawnUtil.GetShortestDistToPrefab (%d, %d) -> (%d, %d) = %d", x, y, sx, sy, dist))
        end
    end
    return dist
end

function SpawnUtil.GetDistToSpawnPoint(x, y, ents)
    return SpawnUtil.GetShortestDistToPrefab(x, y, ents, "spawnpoint")
end

local commonspawnfn = {
    spiderden = function(x, y, ents)
        return not SpawnUtil.IsCloseToWaterTile(x, y, 5) and SpawnUtil.GetDistToSpawnPoint(x, y, ents) >= 100
    end,
    fishinhole = function(x, y, ents)
        local tile = WorldSim:GetTile(x, y)
        return (tile == WORLD_TILES.OCEAN_CORAL or tile == WORLD_TILES.MANGROVE or (IsOceanTile(tile) and not SpawnUtil.IsCloseToTile(x, y, 5, WORLD_TILES.OCEAN_SHALLOW))) and
            SpawnUtil.IsSurroundedByWaterTile(x, y, 1)
    end,
    tidalpool = function(x, y, ents)
        return not SpawnUtil.IsCloseToWaterTile(x, y, 2) and
            SpawnUtil.GetShortestDistToPrefab(x, y, ents, "tidalpool") >= 3 * TILE_SCALE
    end,

    seashell_beached = function(x, y, ents)
        return not SpawnUtil.IsCloseToWaterTile(x, y, 1) and SpawnUtil.IsCloseToWaterTile(x, y, 4)
    end,
    mangrovetree = function(x, y, ents)
        return SpawnUtil.IsSurroundedByTile(x, y, 1, WORLD_TILES.MANGROVE)
    end,
    grass_water = function(x, y, ents)
        return SpawnUtil.IsSurroundedByTile(x, y, 1, WORLD_TILES.MANGROVE)
    end,
}

function SpawnUtil.SpawntestFn(prefab, x, y, ents)
    return prefab ~= nil and (commonspawnfn[prefab] == nil or commonspawnfn[prefab](x, y, ents))
end

local function surroundedbywater(x, y, ents)
    return SpawnUtil.IsSurroundedByWaterTile(x, y, 1)
end

local function notclosetowater(x, y, ents)
    return not SpawnUtil.IsCloseToWaterTile(x, y, 1)
end

local waterprefabs = {
    "rock_coral", "seaweed_planted", "mussel_farm", "lobsterhole", "messagebottle", "messagebottleempty",
    "shipwreck", "ballphinhouse"
}

local landprefabs = {
    "livingjungletree", "volcano_shrub", "jungletree", "palmtree", "bush_vine", "limpetrock", "sanddune", "sapling",
    "poisonhole", "coffeebush", "elephantcactus",
    "dragoonden", "wildborehouse", "mermhouse", "mermhouse_tropical", "magmarock", "magmarock_gold", "flower",
    "fireflies", "grass", "charcoal",
    "bambootree", "berrybush", "berrybush_snake", "berrybush2", "berrybush2_snake", "crabhole", "rock1", "rock2",
    "rock_obsidian", "rock_charcoal", "skeleton",
    "rock_flintless", "rocks", "flint", "goldnugget", "gravestone", "mound", "red_mushroom", "blue_mushroom",
    "wallyintro_shipmast", "wallyintro_debris_1", "wallyintro_debris_2", "wallyintro_debris_3",
    "green_mushroom", "carrot_planted", "beehive", "beequeenhive", "reeds", "marsh_tree", "snakeden", "pond",
    "primeapebarrel",
    "mandrake_planted", "mermhouse_fisher", "sweet_potato_planted", "flup", "flupspawner", "flupspawner_sparse",
    "flupspawner_dense", "wasphive", "flower_evil", "crate", "tallbirdnest", "terrariumchest",
    "marsh_bush", "deerspawningground",
}

-- Mod support
function SpawnUtil.AddWaterCommonSpawn(prefab)
    assert(commonspawnfn[prefab] == nil) -- don't replace an existing one
    commonspawnfn[prefab] = surroundedbywater
end

function SpawnUtil.AddLandCommonSpawn(prefab)
    assert(commonspawnfn[prefab] == nil) -- don't replace an existing one
    commonspawnfn[prefab] = notclosetowater
end

for i = 1, #waterprefabs do
    SpawnUtil.AddWaterCommonSpawn(waterprefabs[i])
end

for i = 1, #landprefabs do
    SpawnUtil.AddLandCommonSpawn(landprefabs[i])
end

-- for in-game checks, use FindRandomWaterPoints
-- overrides basegame function from RoT, so populating_tile may be a function or nil.
function SpawnUtil.FindRandomWaterPoints(populating_tile, width, height, edge_dist, needed)
    local points = {}
    local points_x = {}
    local points_y = {}
    local incs = { 263, 137, 67, 31, 17, 9, 5, 3, 1 }
    local adj_width, adj_height = width - 2 * edge_dist, height - 2 * edge_dist
    local start_x, start_y = math.random(0, adj_width), math.random(0, adj_height)

    for inc = 1, #incs do
        if #points < needed then
            -- dunno why this was a function
            local i, j = 0, 0
            while j < adj_height and #points < needed do
                local y = ((start_y + j) % adj_height) + edge_dist
                while i < adj_width and #points < needed do
                    local x = ((start_x + i) % adj_width) + edge_dist
                    -- local ground = WorldSim:GetTile(x, y)
                    -- if populating_tile(ground, x, y) then
                    if populating_tile == nil
                        or (type(populating_tile) == "function" and populating_tile(WorldSim:GetTile(x, y), x, y, points))
                        or (type(populating_tile) == "number" and not WorldSim:IsTileReserved(x, y) and populating_tile == WorldSim:GetTile(x, y)) then
                        table.insert(points, { x = x, y = y })
                    end
                    i = i + incs[inc]
                end
                j = j + incs[inc]
                i = 0
            end

            -- print(string.format("%d (of %d) points found", #points, needed))
        end
    end

    points = shuffleArray(points)
    for i = 1, #points do
        table.insert(points_x, points[i].x)
        table.insert(points_y, points[i].y)
    end

    return points_x, points_y
end

function SpawnUtil.NodeHasTag(tag)

end

function SpawnUtil.NodeHasGlobalTag(topology_save, tag)
    local d = topology_save.GlobalTags[tag]
end

return SpawnUtil
