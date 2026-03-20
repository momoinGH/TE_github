local is_worldgen = rawget(_G, "WORLDGEN_MAIN") ~= nil
if is_worldgen then return end

--与碰撞有关
for tile_id, _ in pairs(TRO_OCEAN_TILES) do
    TileGroupManager:AddInvalidTile(TileGroups.TransparentOceanTiles, tile_id)
    -- TileGroupManager:AddValidTile(TileGroups.OceanTiles, tile_id)
end
