-- 海上布景，会显著加快地形生成
-- 通过把放在深海的布局提前填充到海洋中减少查找深海的时间来加快布局，有时候就是会因为岛屿太多没有深海一直卡在世界生成状态
-- 缺点是蟹奶奶岛和猴子岛可能生成离大陆比较近的位置

require("map/rooms/forest/terrain_ocean")
local rooms = require("map/rooms")

local ocean_rough_countstaticlayouts = shallowcopy(rooms.GetRoomByName("OceanRough").contents.countstaticlayouts)
AddLevelPreInitAny(function(level)
    if level.location == "forest" then
        level.ocean_prefill_setpieces = level.ocean_prefill_setpieces or {}

        table.trodeep_merge(level.ocean_prefill_setpieces, shallowcopy(ocean_rough_countstaticlayouts))
        -- level.ocean_prefill_setpieces["CrabKing"] = 1

        level.ocean_population = level.ocean_population or {}
        table.troinserttable_unique(level.ocean_population, {
            "OceanBrinepool",
        })
    end
end)

AddRoomPreInit("OceanRough", function(room)
    room.required_prefabs = {}
    for k, v in pairs(ocean_rough_countstaticlayouts) do
        room.contents.countstaticlayouts[k] = nil --删除
    end
end)

AddRoomPreInit("OceanSwell", function(room)
    -- room.required_prefabs = {}
    -- room.contents.countstaticlayouts = {} ---- delete ["CrabKing"] = 1
end)
