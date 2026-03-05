require "components/map"

-- 海难小船
local WALKABLE_PLATFORM_TAGS = { "shipwrecked_boat" }
local BOAT_CANT_TAGS = { "INLIMBO" }

function Map:GetSWBoatAtPoint(pos_x, pos_y, pos_z)
    return TheSim:FindEntities(pos_x, 0, pos_z, 0.5, WALKABLE_PLATFORM_TAGS, BOAT_CANT_TAGS)[1]
end