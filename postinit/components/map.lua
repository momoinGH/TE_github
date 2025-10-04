local Util = require "tools/utils"
require "components/map"
local Map = (_G or GLOBAL).Map

Util.FnDecorator(Map, "IsPassableAtPoint", function(self, x, y, z)
    local entities = TheSim:FindEntities(x, y, z, 30, { "blows_air" })
    if entities and #entities > 0 then
        return { true }, true
    end
    entities = TheSim:FindEntities(x, y, z, 1.2, { "boat" })
    if entities and #entities > 0 then
        return { true }, true
    end
end)

Util.FnDecorator(Map, "CanDeployRecipeAtPoint", nil, function(rets, self, pt, recipe, rot)
    if rets and #rets > 0 and rets[1] then
        return rets
    end
    local is_valid_ground = false;
    local x, y, z = pt:Get()
    local entities = TheSim:FindEntities(x, 0, z, 20, { "canbuild" })
    for i, v in ipairs(entities) do
        local platform_x, platform_y, platform_z = v.Transform:GetWorldPosition()
        local distance_sq = VecUtil_LengthSq(x - platform_x, z - platform_z)
        if distance_sq <= 150 then
            is_valid_ground = true
        end
    end
    return { is_valid_ground and (recipe.testfn == nil or recipe.testfn(pt, rot)) and
    self:IsDeployPointClear(pt, nil, recipe.min_spacing or 3.2) }
end)

local GOODOCEANARENAPOINTS_ITERATIONS_PER_TICK, key_1 = Util.FindUpvalue(Map.StartFindingGoodOceanArenaPoints,
    "GOODOCEANARENAPOINTS_ITERATIONS_PER_TICK")
local GOODOCEANARENAPOINTS_TIME_PER_TICK, key_2 = Util.FindUpvalue(Map.StartFindingGoodOceanArenaPoints,
    "GOODOCEANARENAPOINTS_TIME_PER_TICK")
Util.FnDecorator(Map, "StartFindingGoodOceanArenaPoints", function(self)
    if TheWorld.components.sharkboimanager and TheWorld.components.sharkboimanager.TEMP_DEBUG_RATE then
        debug.setupvalue(Map.StartFindingGoodOceanArenaPoints, key_1, 3000)
        debug.setupvalue(Map.StartFindingGoodOceanArenaPoints, key_2, 0.0)
    end
end)
