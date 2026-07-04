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

----------------------------------------------------------------------------------------------------

--[[
separavulcao是洞穴一大片虚空地形，作为其他模块小岛的基础，现在是给海底世界地形使用
把地形生成在主大陆之外是通过separavulcao、underwaterdivide塞入大量虚空房间，然后再让地形用这个task给的keys解锁
世界生成后处理可能会清理/修正不连通区域。keep_disconnected_tiles允许那些和主大陆不接壤的 tile 被保留下来
不过这些很多的虚空房间也会把主大陆挤到墙角
]]
AddLevelPreInitAny(function(level)
    if level.location == "cave" then
        level.overrides.keep_disconnected_tiles = true
        table.insert(level.tasks, "separavulcao")
    end
end)
