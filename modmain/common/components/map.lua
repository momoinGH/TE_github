--@Author: Peng
local Utils = require("tools/utils")

-----------map related--------------------------
require("components/map")

Map.IsTropicalAreaAtPoint = function(self, x, y, z)
    local node = self:FindVisualNodeAtPoint(x, y, z, "tropical")
        or self:FindVisualNodeAtPoint(x, y, z, "ForceDisconnected")

    if node ~= nil then
        return true
    else
        return false
    end
end

Map.IsShipwreckedAreaAtPoint = function(self, x, y, z)
    local node = self:FindVisualNodeAtPoint(x, y, z, "shipwrecked")
    if node ~= nil then
        return true
    else
        return false
    end
end

Map.IsHamletAreaAtPoint = function(self, x, y, z)
    local node = self:FindVisualNodeAtPoint(x, y, z, "hamlet")
    if node ~= nil then
        return true
    else
        return false
    end
end

Map.IsVolcanoAreaAtPoint = function(self, x, y, z)
    local node = self:FindVisualNodeAtPoint(x, y, z, "volcano")
    if node ~= nil then
        return true
    else
        return false
    end
end

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
    [WORLD_TILES.BATTLEGROUNDS] = true,
    [WORLD_TILES.PEBBLEBEACH] = true,
}

Utils.FnDecorator(Map, "CanDeployRecipeAtPoint", function(self, pt, recipe, rot)
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
