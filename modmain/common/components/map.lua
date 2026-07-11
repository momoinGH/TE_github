--@Author: Peng
-----------map related--------------------------
require("components/map")

Map.IsTropicalAreaAtPoint = function(self, x, y, z)
    local node = self:FindVisualNodeAtPoint(x, y, z, "tropical")
        or self:FindVisualNodeAtPoint(x, y, z, "ForceDisconnected")
    return node ~= nil
end

Map.IsShipwreckedAreaAtPoint = function(self, x, y, z)
    local node = self:FindVisualNodeAtPoint(x, y, z, "shipwrecked")
    return node ~= nil
end

Map.IsHamletAreaAtPoint = function(self, x, y, z)
    local node = self:FindVisualNodeAtPoint(x, y, z, "hamlet")
    return node ~= nil
end

Map.IsVolcanoAreaAtPoint = function(self, x, y, z)
    local node = self:FindVisualNodeAtPoint(x, y, z, "volcano")
    return node ~= nil
end

Map.IsUnderWaterAreaAtPoint = function(self, x, y, z)
    local node = self:FindVisualNodeAtPoint(x, y, z, "underwater")
    return node ~= nil
end

Map.IsFrostisLandAreaAtPoint = function(self, x, y, z)
    local node = self:FindVisualNodeAtPoint(x, y, z, "frost")
    return node ~= nil
end

Map.IsWindyAreaAtPoint = function(self, x, y, z)
    local node = self:FindVisualNodeAtPoint(x, y, z, "windy")
    return node ~= nil
end

-- 判断这个位置是否是冬天
Map.TroHasWinterAtPoint = function(self, x, y, z)
    if TheWorld.state.iswinter then
        return self:FindVisualNodeAtPoint(x, y, z, "No_Winter") == nil
    else
        return self:FindVisualNodeAtPoint(x, y, z, "Always_Winter") ~= nil
    end
end

-- 判断这个位置是否是夏天
Map.TroIsSummerAtPoint = function(self, x, y, z)
    if self:FindVisualNodeAtPoint(x, y, z, "Always_Winter") then
        return false
    end
    if TheWorld.state.issummer then
        return self:FindVisualNodeAtPoint(x, y, z, "No_Summer") == nil
    else
        return false
    end
end

local RoomUtils = require("tropical_utils/room_utils")
-- 判断是否在世界外面，一般世界外就是小房子
function Map:TroIsWorldOut(x, y, z)
    if x and z and (math.abs(z) >= RoomUtils.BASE_OFF or math.abs(x) >= RoomUtils.BASE_OFF) then
        return true
    else
        return false
    end
end

----------------------------------------------------------------------------------------------------

local _SetTile = Map.SetTile
function Map:SetTile(x, y, tile, ...)
    local newtile
    if tile == WORLD_TILES.DIRT then
        if self:IsVolcanoAreaAtPoint(x, 0, y) then
            print("is in volcano")
        end
        newtile =
        -- (self:IsVolcanoAreaAtPoint(x, 0, y) and WORLD_TILES.VOLCANO_ROCK) or
            (self:IsShipwreckedAreaAtPoint(x, 0, y) and WORLD_TILES.BEACH) or nil

        print(newtile)
    end
    _SetTile(self, x, y, newtile or tile, ...)
end

local BASE_TILES = {
    -- [WORLD_TILES.VOLCANO_ROCK] = true,
    [WORLD_TILES.BEACH] = true,
}

local _CanPlaceTurfAtPoint = Map.CanPlaceTurfAtPoint
function Map:CanPlaceTurfAtPoint(x, y, z, ...)
    return _CanPlaceTurfAtPoint(self, x, y, z, ...) or BASE_TILES[self:GetTileAtPoint(x, y, z)]
end

----------------------------------------------------------------------------------------------------

local CANT_DEPLOY_TILES = {
    [WORLD_TILES.UNDERWATER_SANDY] = true,
    [WORLD_TILES.UNDERWATER_ROCKY] = true,
}

local CANT_DEPLOY_IN_CAVE_TILES = {
    [WORLD_TILES.BEACH] = true,
    [WORLD_TILES.MAGMAFIELD] = true,
    [WORLD_TILES.PAINTED] = true,
    [WORLD_TILES.BATTLEGROUND] = true,
    [WORLD_TILES.PEBBLEBEACH] = true,
}

Hooks.FnDecorator(Map, "CanDeployRecipeAtPoint", function(self, pt, recipe, rot)
    local x, _, z = pt:Get()
    -- 地皮限制
    local tile = TheWorld.Map:GetTileAtPoint(x, 0, z)
    if CANT_DEPLOY_TILES[tile] or (TheWorld:HasTag("cave") and CANT_DEPLOY_IN_CAVE_TILES[tile]) then
        return { false }, true
    end
end)

----------------------------------------------------------------------------------------------------
-- TODO 这个可以写在每个预制件里，deployable提供了自定义检查的方法
local VOLCANO_PLANT_TILES = table.invert {
    WORLD_TILES.MAGMAFIELD,
    WORLD_TILES.ASH,
    WORLD_TILES.VOLCANO,
    WORLD_TILES.VOLCANO_ROCK,
}

local JUNGLE_PLANT_TILES = table.invert {
    WORLD_TILES.JUNGLE,
}

-- 咖啡、象仙人掌、荨麻、竹子、藤蔓
function Map:CanVolcanoPlantAtPoint(x, y, z)
    local tile = self:GetTileAtPoint(x, y, z)
    return VOLCANO_PLANT_TILES[tile]
end

function Map:CanJunglePlantAtPoint(x, y, z)
    local tile = self:GetTileAtPoint(x, y, z)
    return JUNGLE_PLANT_TILES[tile]
end

Hooks.FnDecorator(Map, "CanDeployPlantAtPoint", function(self, pt, inst, ...)
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

-- 如果x是Vector3时阻止报错，科雷暴食还有部分调用是传的Vector3，直接走可能会报错
local OldCanTillSoilAtPoint = Map.CanTillSoilAtPoint
function Map:CanTillSoilAtPoint(x, y, z, ...)
    if Vector3.is_instance(x) then
        x, y, z = x:Get()
    end
    return OldCanTillSoilAtPoint(self, x, y, z, ...)
end
