local Utils = require("tropical_utils/utils")
require "components/map"

Utils.FnDecorator(Map, "IsPassableAtPoint", function(self, x, y, z)
    if #TheSim:FindEntities(x, y, z, 30, { "blows_air" }) > 0
        or #TheSim:FindEntities(x, y, z, 1.2, { "boat" }) > 0
    then
        return { true }, true
    end
end)

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

Utils.FnDecorator(Map, "CanDeployRecipeAtPoint", function(self, pt, recipe, rot)
    local x, _, z = pt:Get()
    -- 地皮限制
    local tile = TheWorld.Map:GetTileAtPoint(x, 0, z)
    if CANT_DEPLOY_TILES[tile] or (TheWorld:HasTag("cave") and CANT_DEPLOY_IN_CAVE_TILES[tile]) then
        return { false }, true
    end

    if #TheSim:FindEntities(x, 0, z, 12, { "canbuild" }) > 0
        and (recipe.testfn == nil or recipe.testfn(pt, rot))
        and self:IsDeployPointClear(pt, nil, recipe.min_spacing or 3.2) then
        return { true }, true
    end
end)

-- 虚空也不希望返回一个空值
Utils.FnDecorator(Map, "GetTileCenterPoint", nil, function(retTab, self, x, y, z)
    return next(retTab) and retTab
        or x and z and { math.floor(x / 4) * 4 + 2, 0, math.floor(z / 4) * 4 + 2 }
        or {}
end)
