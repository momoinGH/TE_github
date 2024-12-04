--@Author: Peng

require("components/map")

local function FindVisualNodeAtPoint_TestArea(map, pt_x, pt_z, r)
    local best = { tile_type = WORLD_TILES.INVALID, render_layer = -1 }
    for _z = -1, 1 do
        for _x = -1, 1 do
            local x, z = pt_x + _x * r, pt_z + _z * r

            local tile_type = map:GetTileAtPoint(x, 0, z) -----这里判断地皮总有点不太合适，判断初始地皮会好一些
            if IsLandTile(tile_type) then
                local tile_info = GetTileInfo(tile_type)
                local render_layer = tile_info ~= nil and tile_info._render_layer or 0
                if render_layer > best.render_layer then
                    best.tile_type = tile_type
                    best.render_layer = render_layer
                    best.x = x
                    best.z = z
                end
            end
        end
    end

    return best.tile_type ~= WORLD_TILES.INVALID and best or nil
end

Map.FindVisualNodeAtPoint = function(self, x, y, z, has_tag)
    local node_index

    local nodeid = self:GetNodeIdAtPoint(x, 0, z)
    local in_node = nodeid and nodeid ~= 0

    local tile_type = self:GetTileAtPoint(x, 0, z)
    local is_valid_tile = IsLandTile(tile_type)
    if in_node and is_valid_tile then
        node_index = nodeid
    else
        local best = FindVisualNodeAtPoint_TestArea(self, x, z, 4)
            or FindVisualNodeAtPoint_TestArea(self, x, z, 16)
            or FindVisualNodeAtPoint_TestArea(self, x, z, 64)

        node_index = (best ~= nil) and self:GetNodeIdAtPoint(best.x, 0, best.z) or 0
    end


    if has_tag == nil then
        return TheWorld.topology.nodes[node_index], node_index
    else
        local node = TheWorld.topology.nodes[node_index]
        return ((node ~= nil and table.contains(node.tags, has_tag)) and node or nil), node_index
    end
end


Map.IsTropicalAreaAtPoint = function(self, x, y, z)
    local node = self:FindVisualNodeAtPoint(x, y, z, "shipwrecked")
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
