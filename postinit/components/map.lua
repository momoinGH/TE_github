local Utils = require("tropical_utils/utils")
local InteriorSpawnerUtils = require("interiorspawnerutils")
require "components/map"

local CANT_DEPLOY_TILES = {
    [WORLD_TILES.UNDERWATER_SANDY] = true,
    [WORLD_TILES.UNDERWATER_ROCKY] = true,
}

local CANT_DEPLOY_IN_CAVE_TILES = {
    [WORLD_TILES.BEACH] = true,
    [WORLD_TILES.MAGMAFIELD] = true,
    [WORLD_TILES.PAINTED] = true,
    [WORLD_TILES.BATTLEGROUNDS] = true,
    [WORLD_TILES.PEBBLEBEACH] = true,
}

local VOLCANO_PLANT_TILES = table.invert {
    WORLD_TILES.MAGMAFIELD,
    WORLD_TILES.ASH,
    WORLD_TILES.VOLCANO,
    WORLD_TILES.VOLCANO_ROCK,
}

local JUNGLE_PLANT_TILES = table.invert {
    WORLD_TILES.JUNGLE,
}

Utils.FnDecorator(Map, "CanDeployRecipeAtPoint", function(self, pt, recipe, rot)
    local x, _, z = pt:Get()
    -- 地皮限制
    local tile = TheWorld.Map:GetTileAtPoint(x, 0, z)
    if CANT_DEPLOY_TILES[tile] or (TheWorld:HasTag("cave") and CANT_DEPLOY_IN_CAVE_TILES[tile]) then
        return { false }, true
    end
end)


local DIS = InteriorSpawnerUtils.RADIUS --只要不比房子半径小就行
local lastcenter = nil                  --缓存，短时间内在一个房间附近求值的可能性较大
-- 室内可放置建筑，物品不会掉入“水”中

local function IsInRoom(center, x, y, z)
    local cx, cy, cz = center.Transform:GetWorldPosition()
    local room_width, room_depth = center.room_width:value() / 2 + 1, center.room_depth:value() / 2 + 1 --留点空隙
    return x >= cx - room_depth and x <= cx + room_depth and z >= cz - room_width and z <= cz + room_width
end

local function CheckPointBefore(self, x, y, z)
    if z < InteriorSpawnerUtils.BASE_OFF then  --判断的基础
        return
    end

    -- 缓存
    if lastcenter then
        if lastcenter:IsValid() and IsInRoom(lastcenter, x, y, z) then
            return { true }, true
        else
            lastcenter = nil
        end
    end

    -- 查找
    for _, center in ipairs(TheSim:FindEntities(x, 0, z, DIS, { "interior_center" })) do
        if IsInRoom(center, x, y, z) then
            lastcenter = center
            return { true }, true
        end
    end

    -- 就不返回false了，交给原方法执行，防止影响其他mod
end

local function GetRoomCenter(self, x, y, z)
    for _, center in ipairs(TheSim:FindEntities(x, 0, z, DIS, { "interior_center" })) do
        if IsInRoom(center, x, y, z) then
            return center
        end
    end
    return false
end

Map.TroGetRoomCenter = GetRoomCenter
Utils.FnDecorator(Map, "IsAboveGroundAtPoint", CheckPointBefore)
Utils.FnDecorator(Map, "IsPassableAtPoint", CheckPointBefore)
Utils.FnDecorator(Map, "IsVisualGroundAtPoint", CheckPointBefore)
-- Utils.FnDecorator(Map, "CanPlantAtPoint", CheckPointBefore) --允许房间里种植，不知道算不算超模，如果可以的话，需要处理耕地机等其他问题

-- 虚空也不希望返回一个空值
Utils.FnDecorator(Map, "GetTileCenterPoint", nil, function(retTab, self, x, y, z)
    return next(retTab) and retTab
        or x and z and { math.floor(x / 4) * 4 + 2, 0, math.floor(z / 4) * 4 + 2 }
        or {}
end)

-- 咖啡、象仙人掌、荨麻、竹子、藤蔓
function Map:CanVolcanoPlantAtPoint(x, y, z)
    local tile = self:GetTileAtPoint(x, y, z)
    return VOLCANO_PLANT_TILES[tile]
end

function Map:CanJunglePlantAtPoint(x, y, z)
    local tile = self:GetTileAtPoint(x, y, z)
    return JUNGLE_PLANT_TILES[tile]
end

Utils.FnDecorator(Map, "CanDeployPlantAtPoint", function(self, pt, inst, ...)
    if inst.prefab == "dug_elephantcactus" or inst.prefab == "dug_coffeebush" then
        return
            { self:CanVolcanoPlantAtPoint(pt:Get()) and
            self:IsDeployPointClear(pt, inst, inst.replica.inventoryitem ~= nil and inst.replica.inventoryitem:DeploySpacingRadius() or DEPLOYSPACING_RADIUS[DEPLOYSPACING.DEFAULT]) },
            true
    elseif inst.prefab == "dug_bush_vine" or inst.prefab == "dug_bambootree" then
        return
            { self:CanJunglePlantAtPoint(pt:Get()) and
            self:IsDeployPointClear(pt, inst, inst.replica.inventoryitem ~= nil and inst.replica.inventoryitem:DeploySpacingRadius() or DEPLOYSPACING_RADIUS[DEPLOYSPACING.DEFAULT]) },
            true
    end
end)

----------------------------------------------------------------------------------------------------

-- 海难小船
local WALKABLE_PLATFORM_TAGS = { "shipwrecked_boat" }
local BOAT_CANT_TAGS = { "INLIMBO" }

function Map:GetSWBoatAtPoint(pos_x, pos_y, pos_z)
    return TheSim:FindEntities(pos_x, 0, pos_z, 0.5, WALKABLE_PLATFORM_TAGS, BOAT_CANT_TAGS)[1]
end

Utils.FnDecorator(Map, "IsPassableAtPointWithPlatformRadiusBias", nil, function(retTab, self, x, y, z, allow_water, exclude_boats, platform_radius_bias, ignore_land_overhang)
    if retTab[1] or allow_water or exclude_boats then
        return retTab
    end

    if Map:GetSWBoatAtPoint(x, y, z) then
        return { true }
    end

    return retTab
end)
