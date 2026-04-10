require("map/graphnode")

local function IsValidNodeTile(self, tile)
    if IsLandTile(tile) then
        return true
    end

    if TRO_OCEAN_TILES[tile] then
        return true --mod地皮，那肯定是我们的布局
    end

    if table.contains(self.data.tags, "tropical") then
        return true --检查该节点是否含有我们mod地形标签
    end

    return false
end

-- 允许在mod海洋地皮上填充实体
Node.AddEntity = function(self, prefab, points_x, points_y, current_pos_idx, entitiesOut, width, height, prefab_list, prefab_data, rand_offset)
    local tile = WorldSim:GetTile(points_x[current_pos_idx], points_y[current_pos_idx])
    if not IsValidNodeTile(self, tile) then
        return
    end
    PopulateWorld_AddEntity(prefab, points_x[current_pos_idx], points_y[current_pos_idx], tile, entitiesOut, width, height, prefab_list, prefab_data, rand_offset)
end
