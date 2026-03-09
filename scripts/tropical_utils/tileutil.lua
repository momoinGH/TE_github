function IsSwLandTile(tile)
    return SW_LAND_TILES[tile] ~= nil
end

function IsTroWaterTile(tile)
    return TRO_OCEAN_TILES[tile] ~= nil
end

function IsValidNodeTile(tile)
    return (IsLandTile(tile) or IsTroWaterTile(tile)) and true or false
end
