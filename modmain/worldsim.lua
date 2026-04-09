if not rawget(_G, "WorldSim") then
    return
end

-- 调整世界大小
local world_size_mult = GetModConfigData("world_size_multi")
local world_size
local mt = getmetatable(WorldSim).__index
local OldSetWorldSize = mt.SetWorldSize
mt.SetWorldSize = function(self, map_width, map_height)
    world_size = math.max(world_size or 0, map_width * world_size_mult)
    world_size = math.max(world_size, map_height * world_size_mult)
    return OldSetWorldSize(self, world_size, world_size)
end

local OldConvertToTileMap = mt.ConvertToTileMap
mt.ConvertToTileMap = function(self, size)
    if not world_size then
        world_size = size * world_size_mult
    end
    return OldConvertToTileMap(self, world_size)
end

-- 海岸线调整
-- 默认情况下，task之间只有单个room相连，修改这个函数之后所有相邻room都会相连，体现在地图上就是海岸线更加平滑
mt.SeparateIslands = function(self) print("Not Seperating Islands") end
