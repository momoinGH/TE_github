local Utils = require("tropical_utils/utils")
require "components/map"

local NOT_PASSABLE_TILES = {
    [WORLD_TILES.OCEAN_SWELL] = true,
    [WORLD_TILES.OCEAN_BRINEPOOL] = true,
    [WORLD_TILES.OCEAN_BRINEPOOL_SHORE] = true,
    [WORLD_TILES.OCEAN_HAZARDOUS] = true,
    [WORLD_TILES.OCEAN_ROUGH] = true,
    [WORLD_TILES.OCEAN_COASTAL_SHORE] = true,
    [WORLD_TILES.OCEAN_WATERLOG] = true,
    [WORLD_TILES.OCEAN_COASTAL] = true
}

Utils.FnDecorator(Map, "IsPassableAtPoint", function(self, x, y, z)
    if #TheSim:FindEntities(x, y, z, 30, { "blows_air" }) > 0
        or #TheSim:FindEntities(x, y, z, 1.2, { "boat" }) > 0
    then
        return { true }, true
    end

    if NOT_PASSABLE_TILES[TheWorld.Map:GetTileAtPoint(x, y, z)] then
        return { false }, true
    end
end)


Utils.FnDecorator(Map, "CanDeployRecipeAtPoint", function(self, pt, recipe, rot)
    local x, _, z = pt:Get()
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
