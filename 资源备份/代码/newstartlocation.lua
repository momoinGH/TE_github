local in_shipwrecked = TUNING.tropical.startlocation == "shipwrecked" and TUNING.tropical.shipwrecked
local in_hamlet = TUNING.tropical.startlocation == "hamlet" and TUNING.tropical.hamlet
if not in_shipwrecked and not in_hamlet then
    return
end


-- 指定出生点
AddLevelPreInitAny(function(level)
    if level.location == "forest" then
        if in_shipwrecked then
            level.overrides.start_location = "SWStart"
            level.valid_start_tasks = { "HomeIsland" }
        elseif in_hamlet then
            level.overrides.start_location = "HamStart"
            level.valid_start_tasks = { "岛一平原" }
        end
    end
end)


require("map/storygen")
function Story:AddRegionsToMainland(on_region_added_fn)
    local land = self.level.location == "forest" and TUNING.tropical.startlocation or "mainland"
    for region_id, region_taskset in pairs(self.region_tasksets) do
        if region_id ~= "mainland" and region_id ~= "ruins_island" and region_id ~= "vault_island" and region_id ~= land then
            local c1, c2 = self:FindMainlandNodesForNewRegion()
            local new_region = self:GenerateNodesForRegion(region_taskset, "RestrictNodesByKey")

            local new_task_nodes = {}
            for k, v in pairs(region_taskset) do
                new_task_nodes[k] = self.TERRAIN[k]
            end
            self:AddCoveNodes(new_task_nodes)
            self:InsertAdditionalSetPieces(new_task_nodes)

            self:LinkRegions(c1, new_region.entranceNode)
            self:LinkRegions(c2, new_region.finalNode)

            if on_region_added_fn ~= nil then
                on_region_added_fn()
            end
        end
    end
end

-- 从出生区域的任务集生成初始节点
function Story:GenerateNodesFromTasks()
    local land = self.level.location == "forest" and TUNING.tropical.startlocation or "mainland"
    local g = self:GenerateNodesForRegion(self.region_tasksets[land], self.gen_params.layout_mode)
    self.startNode = self:_AddPlayerStartNode(g) -- Adds where the player portal will be spawned and used in placement.lua to force the starting point to be at the center of the map
end

----------------------------------------------------------------------------------------------------

AddStartLocation("SWStart", {
    name = STRINGS.UI.SANDBOXMENU.DEFAULTSTART,
    location = "forest",
    start_setpeice = "start_sw",      --生成的static layout  --layout太大的话需要设置大小
    start_node = "Shipwrecked start", --"Blank",  --生成位置, 并在包含该room的task新生成一个相同room  blank就是生成在海上
})
AddStartLocation("HamStart", {
    name = STRINGS.UI.SANDBOXMENU.DEFAULTSTART,
    location = "forest",
    start_setpeice = "start_ham",     --生成的static layout  --layout太大的话需要设置大小
    start_node = "Hamlet start",      --"Blank",  --生成位置, 并在包含该room的task新生成一个相同room  blank就是生成在海上
})

-- 由于覆盖了GenerateNodesFromTasks，导致有些必须生成的场景找不到可以生成的地形了，所以这里得在出生点所在岛屿地形上加上标签
if TUNING.tropical.startlocation == "hamlet" then
    local forest_rooms = {
        [1] = "BG_rainforest_base",
        [2] = "BG_deeprainforest_base"
    }

    local plains_rooms = {
        [1] = "BG_plains_base"
    }

    local rock_rooms = {
        [1] = "BG_painted_base"
    }

    local field_rooms = {
        [1] = "BG_cultivated_base", -----这个没有应用啊
        [2] = "cultivated_base_1",
        [3] = "cultivated_base_2"
    }

    for i, room in ipairs(forest_rooms) do
        AddRoomPreInit(room, function(room)
            table.insert(room.tags, "Terrarium_Spawner")
            table.insert(room.tags, "StatueHarp_HedgeSpawner")
        end)
    end

    for i, room in ipairs(plains_rooms) do
        AddRoomPreInit(room, function(room)
            table.insert(room.tags, "CharlieStage_Spawner")
        end)
    end

    for i, room in ipairs(rock_rooms) do
        AddRoomPreInit(room, function(room)
            table.insert(room.tags, "Junkyard_Spawner")
        end)
    end

    for i, room in ipairs(field_rooms) do
        AddRoomPreInit(room, function(room)
            table.insert(room.tags, "Balatro_Spawner")
            table.insert(room.tags, "StagehandGarden")
        end)
    end
end
