require "components/map"

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
