local NUM_ROWS  = 5
local NUM_COLS  = 5

local width     = TUNING.ROOM_LARGE_WIDTH
local depth     = TUNING.ROOM_LARGE_DEPTH

local RoomUtils = require("tropical_utils/room_utils")
local DIR       = RoomUtils.DIR

-- The camera is setup in the interiors such that it looks along the x axis.
-- Therefore, the x values are back to front, and the z values are side to side.

local function getOffsetX()
    return (math.random() * 7) - (7 / 2)
end

local function getOffsetBackX()
    return (math.random(0, 0.3) * 7) - (7 / 2)
end

local function getOffsetFrontX()
    return (math.random(0.7, 1.0) * 7) - (7 / 2)
end

local function getOffsetZ()
    return (math.random() * 13) - (13 / 2)
end

local function getOffsetLhsZ()
    return (math.random(0, 0.3) * 13) - (13 / 2)
end

local function getOffsetRhsZ()
    return (math.random(0.7, 1.0) * 13) - (13 / 2)
end

-- These are the room quadrants for
-- generating lanterns in the anthill.
-- |-------|-------|
-- |   1   |   2   |
-- |-------|-------|
-- |   3   |   4   |
-- |-------|-------|

local ROOM_QUADRANT_1 = 1
local ROOM_QUADRANT_2 = 2
local ROOM_QUADRANT_3 = 3
local ROOM_QUADRANT_4 = 4



local function getOffsetConstrainedToQuadrant(roomQuadrant)
    local x = 0
    local z = 0

    if roomQuadrant == ROOM_QUADRANT_1 then
        x = getOffsetBackX()
        z = getOffsetLhsZ()
    end

    if roomQuadrant == ROOM_QUADRANT_2 then
        x = getOffsetBackX()
        z = getOffsetRhsZ()
    end

    if roomQuadrant == ROOM_QUADRANT_3 then
        x = getOffsetFrontX()
        z = getOffsetLhsZ()
    end

    if roomQuadrant == ROOM_QUADRANT_4 then
        x = getOffsetFrontX()
        z = getOffsetRhsZ()
    end

    return { x_offset = x, z_offset = z }
end

local function addLanternTables(roomItems, minLanterns, maxLanterns)
    assert((minLanterns > 0) and (minLanterns <= maxLanterns))
    local numLanterns = math.random(minLanterns, maxLanterns)
    local quadrants = shuffleArray({ ROOM_QUADRANT_1, ROOM_QUADRANT_2, ROOM_QUADRANT_3, ROOM_QUADRANT_4 })

    for i = 1, numLanterns, 1 do
        local offsets = getOffsetConstrainedToQuadrant(quadrants[i])
        local itemTable = { name = "ant_cave_lantern", x_offset = offsets.x_offset, z_offset = offsets.z_offset }
        table.insert(roomItems, itemTable)
    end
end

local function addItemTables(itemTypeName, roomItems, minItems, maxItems)
    assert((minItems > 0) and (minItems <= maxItems))
    local numItems = math.random(minItems, maxItems)

    for i = 1, numItems, 1 do
        local itemTable = { name = itemTypeName, x_offset = getOffsetX(), z_offset = getOffsetZ() }
        table.insert(roomItems, itemTable)
    end
end

local MIN_LANTERNS   = 1
local MAX_LANTERNS   = 3

-- 房间类型
local room_setup_fns = {
    function()
        local roomItems = {}
        addLanternTables(roomItems, MIN_LANTERNS, MAX_LANTERNS)
        return roomItems
    end, -- EMPTY ROOM

    function()
        local roomItems = {}
        addItemTables("antcombhomecave", roomItems, 1, 2)
        addItemTables("antman", roomItems, 3, 4)
        addLanternTables(roomItems, MIN_LANTERNS, MAX_LANTERNS)
        return roomItems
    end, -- ANT HOME ROOM

    function()
        local roomItems = {}
        addItemTables("antman", roomItems, 1, 3)
        addLanternTables(roomItems, MIN_LANTERNS, MAX_LANTERNS)
        return roomItems
    end, -- WANDERING ANT ROOM

    function()
        local roomItems = {}
        addItemTables("antcombhomecave", roomItems, 1, 1)
        addItemTables("antman", roomItems, 1, 2)
        addItemTables("antchest", roomItems, 1, 2)
        addLanternTables(roomItems, MIN_LANTERNS, MAX_LANTERNS)
        return roomItems
    end, -- TREASURE ROOM
}

local function GetDoorProp(room, dir, exit)
    return {
        name = "ant_cave_door",
        anim = dir.label
    }
end

-- 把房间分成5*5 = 25份，用来放置东西
local function buildFloorPlan()
    local NUM_TILE_ROWS = 5
    local NUM_TILE_COLS = 5

    local tiles = {}
    for i = 1, NUM_TILE_ROWS do
        local tileRow = {}
        for j = 1, NUM_TILE_COLS do
            table.insert(tileRow, false)
        end
        table.insert(tiles, tileRow)
    end
    return tiles
end

local function getlocationoutofcenter(dist, hole, random, invert)
    local pos = (math.random() * ((dist / 2) - (hole / 2))) + hole / 2
    if invert or (random and math.random() < 0.5) then
        pos = pos * -1
    end
    return pos
end

local function spawnhoney()
    local choice = math.random(1, 4)
    if choice == 1 then
        return { name = "deco_cave_honey_drip_1", x_offset = -depth / 2, z_offset = getlocationoutofcenter(width * 0.65, 3, true), }
    elseif choice == 2 then
        return { name = "deco_cave_ceiling_drip_2", x_offset = -depth / 2, z_offset = getlocationoutofcenter(width * 0.65, 3, true), }
    elseif choice == 3 then
        if math.random() < 0.5 then
            return { name = "deco_cave_honey_drip_side_1", x_offset = getlocationoutofcenter(depth * 0.65, 3, true), z_offset = -width / 2, }
        else
            return { name = "deco_cave_honey_drip_side_1", x_offset = getlocationoutofcenter(depth * 0.65, 3, true), z_offset = width / 2, scale = { -1, 1 } }
        end
    elseif choice == 4 then
        if math.random() < 0.5 then
            return { name = "deco_cave_honey_drip_side_2", x_offset = getlocationoutofcenter(depth * 0.65, 3, true), z_offset = -width / 2, }
        else
            return { name = "deco_cave_honey_drip_side_2", x_offset = getlocationoutofcenter(depth * 0.65, 3, true), z_offset = width / 2, scale = { -1, 1 } }
        end
    end
end

local function AddCommonDeco(addprops)
    table.insert(addprops, { name = "deco_hive_cornerbeam", x_offset = -depth / 2, z_offset = -width / 2, })
    table.insert(addprops, { name = "deco_hive_cornerbeam", x_offset = -depth / 2, z_offset = width / 2, scale = { -1, 1 } })
    table.insert(addprops, { name = "deco_hive_pillar_side", x_offset = depth / 2, z_offset = -width / 2, })
    table.insert(addprops, { name = "deco_hive_pillar_side", x_offset = depth / 2, z_offset = width / 2, scale = { -1, 1 } })

    table.insert(addprops, { name = "deco_hive_floor_trim", x_offset = depth / 2, z_offset = -width / 4, })
    table.insert(addprops, { name = "deco_hive_floor_trim", x_offset = depth / 2, })
    table.insert(addprops, { name = "deco_hive_floor_trim", x_offset = depth / 2, z_offset = width / 4, })

    return addprops
end

local function AddChamberDeco(addprops)
    addprops = AddCommonDeco(addprops)

    for i = 1, math.random(8, 16) do
        table.insert(addprops, { name = "rock_antcave", x_offset = getlocationoutofcenter(depth * 0.65, 3, true), z_offset = getlocationoutofcenter(width * 0.65, 3, true) })
    end

    if math.random() < 0.3 then
        table.insert(addprops, { name = "deco_hive_debris", x_offset = depth * 0.65 * math.random() - depth * 0.65 / 2, z_offset = width * 0.65 * math.random() - width * 0.65 / 2 })
    end

    if math.random() < 0.3 then
        table.insert(addprops, { name = "deco_hive_debris", x_offset = depth * 0.65 * math.random() - depth * 0.65 / 2, z_offset = width * 0.65 * math.random() - width * 0.65 / 2 })
    end

    local drips = math.random(1, 6) - 1
    while drips > 0 do
        table.insert(addprops, spawnhoney())
        drips = drips - 1
    end

    return addprops
end

local function AddDeco(addprops)
    addprops = AddCommonDeco(addprops)

    if math.random() < 0.5 then
        table.insert(addprops, { name = "rock_antcave", x_offset = -depth / 2 * 0.65 * math.random(), z_offset = getlocationoutofcenter(width * 0.65, 3, true) })
    end

    if math.random() < 0.5 then
        table.insert(addprops, { name = "rock_antcave", x_offset = -depth / 2 * 0.65 * math.random(), z_offset = getlocationoutofcenter(width * 0.65, 3, true) })
    end

    if math.random() < 0.5 then
        table.insert(addprops, { name = "rock_antcave", x_offset = -depth / 2 * 0.65 * math.random(), z_offset = getlocationoutofcenter(width * 0.65, 3, true) })
    end

    if math.random() < 0.3 then
        table.insert(addprops, { name = "deco_hive_debris", x_offset = depth * 0.65 * math.random() - depth * 0.65 / 2, z_offset = width * 0.65 * math.random() - width * 0.65 / 2 })
    end

    if math.random() < 0.3 then
        table.insert(addprops, { name = "deco_hive_debris", x_offset = depth * 0.65 * math.random() - depth * 0.65 / 2, z_offset = width * 0.65 * math.random() - width * 0.65 / 2 })
    end

    local drips = math.random(1, 6) - 1
    while drips > 0 do
        table.insert(addprops, spawnhoney())
        drips = drips - 1
    end

    return addprops
end

local MazeBuilder = require("prefabs/tro_maze_builder")
local function CreateQueenChambers()
    local builder = MazeBuilder()
    builder:SetMazeNight()
    builder:SetAllRoomsSize(width, depth)
    builder:CreateGridRooms(1, math.random(3, 6))

    for idx, room in ipairs(builder.rooms) do
        if idx ~= 1 then
            AddChamberDeco(room.addprops)

            for i = 1, math.random(2, 5) do
                builder:AddRoomProp(idx, { name = "antman_warrior", x_offset = getlocationoutofcenter(depth * 0.65, 5, true), z_offset = getlocationoutofcenter(width * 0.65, 5, true) })
            end
            -- 一路向上的门
            builder:SetRoomExit(idx, "north", idx - 1)

            if idx == #builder.rooms then
                --入口
                builder:SetEntrance(room.idx, 1, "south")
                builder:AddRoomProp(idx, { name = "ant_cave_door", x_offset = depth / 2, anim = "south", key = "boss_door" })
            end
        else
            -- 蚁后房间
            AddCommonDeco(room.addprops)

            builder:AddRoomProp(idx, { name = "antqueen", })
            builder:AddRoomProp(idx, { name = "ant_cave_lantern", x_offset = -depth / 2, }) -- Behind the queen, placed there for better lighting

            builder:AddRoomProp(idx, { name = "ant_cave_lantern", x_offset = -depth / 2, z_offset = (depth / 2) - 2 })
            builder:AddRoomProp(idx, { name = "ant_cave_lantern", x_offset = -depth / 2, z_offset = (-depth / 2) + 2 })

            builder:AddRoomProp(idx, { name = "ant_cave_lantern", z_offset = (depth / 2) + 1 })
            builder:AddRoomProp(idx, { name = "ant_cave_lantern", z_offset = (-depth / 2) - 1 })

            -------------
            -- Gross
            builder:AddRoomProp(idx, { name = "throne_wall_large", x_offset = 1, z_offset = 2.25 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = 2.2, z_offset = 2.5 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = 1.9, z_offset = 3 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = 1.6, z_offset = 3.5 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = 1.3, z_offset = 4 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = 1, z_offset = 4.5 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = 0.7, z_offset = 5 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = 0.4, z_offset = 5.5 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = 0.1, z_offset = 6 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -0.4, z_offset = 6 })

            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -3.25, z_offset = 1.5 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -3, z_offset = 2 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -2.75, z_offset = 2.5 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -2.5, z_offset = 3 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -2.25, z_offset = 3.5 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -2, z_offset = 4 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -1.75, z_offset = 4.5 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -1.5, z_offset = 5 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -1.25, z_offset = 5.5 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -1, z_offset = 6 })

            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -3.25, z_offset = 1 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -3.25, .5 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -3.25, z_offset = -0 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -3.25, z_offset = -0.5 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -3.25, z_offset = -1 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -3.25, z_offset = -1.5 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -3, z_offset = -2 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -2.75, z_offset = -2.5 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -2.5, z_offset = -3 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -2.25, z_offset = -3.5 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -2, z_offset = -4 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -1.75, z_offset = -4.5 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -1.5, z_offset = -5 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -1.25, z_offset = -5.5 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -1, z_offset = -6 })

            builder:AddRoomProp(idx, { name = "throne_wall_large", x_offset = 1.5, z_offset = -2.5 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = 2, z_offset = -3 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = 1.75, z_offset = -3.5 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = 1.5, z_offset = -4 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = 1.25, z_offset = -4.5 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = 1, z_offset = -5 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = 0.75, z_offset = -5.5 })
            builder:AddRoomProp(idx, { name = "throne_wall", z_offset = -6 })
            builder:AddRoomProp(idx, { name = "throne_wall", x_offset = -0.5, z_offset = -6 })
        end
    end

    -- 墙壁和地板
    for idx, room in ipairs(builder.rooms) do
        builder:AddRoomProp(idx, "interior_floor_antcave")
        builder:AddRoomProp(idx, "interior_wall_antcave_wall_rock")
    end

    builder:AddAllRoomDoorProp(GetDoorProp)

    return builder.rooms
end


-- 网格布局房间
-- 三个入口、一个通往蚁后房间的门
local function CreateMaze(entrance_num)
    local builder = MazeBuilder()
    builder:SetMazeNight()
    builder:SetAllRoomsSize(width, depth)

    -- 构建所有房间
    builder:CreateGridRooms(NUM_ROWS, NUM_COLS)

    --入口
    local numEntrancesChosen = 0
    repeat
        local room = builder[math.random(1, #builder.rooms)]
        if not room.is_entrance then
            numEntrancesChosen = numEntrancesChosen + 1
            builder:SetEntrance(room.idx, 1, "north")
        end
    until (numEntrancesChosen == entrance_num)

    -- 随机选1个房间,isChamberEntrance，作为通向蚁后的房间
    while true do
        local room = builder[math.random(1, #builder.rooms)]
        if not room.is_entrance then
            room.isChamberEntrance = true
            break
        end
    end

    --按照比例给每个房间分配不同的类型，编号1~4
    local room_idx_list = {}
    for id, count in ipairs({ 7, 5, 10, 3 }) do
        for i = 1, count do
            table.insert(room_idx_list, id)
        end
    end
    room_idx_list = shuffleArray(room_idx_list) --打乱

    local isEntranceId = 1
    for idx, room in ipairs(builder.rooms) do
        local addprops = room.addprops

        if room.isChamberEntrance then
            local antqueen_chamber_pts =
            {
                { x = (depth / 2) - 3.5, z = (width / 2) - 5.5 },
                { x = -(depth / 2) + 3.5, z = (width / 2) - 5.5 },
                { x = (depth / 2) - 3.5, z = -(width / 2) + 5.5 },
                { x = -(depth / 2) + 3.5, z = -(width / 2) + 5.5 },
            }
            local spawn_pt = antqueen_chamber_pts[math.random(1, #antqueen_chamber_pts)]
            builder:AddRoomProp(idx, { name = "anthill_cave_queen_door", x_offset = spawn_pt.x, z_offset = spawn_pt.z, key = "boss_door" })

            for i = 1, math.random(2, 4) do
                builder:AddRoomProp(idx, { name = "antman_warrior", x_offset = getlocationoutofcenter(depth * 0.65, 5, true), z_offset = getlocationoutofcenter(width * 0.65, 5, true) })
            end

            for i = 1, math.random(2, 4) do
                builder:AddRoomProp(idx, { name = "ant_cave_lantern", x_offset = getlocationoutofcenter(depth * 0.65, 5, true), z_offset = getlocationoutofcenter(width * 0.65, 5, true) })
            end
        else
            local floorPlan = buildFloorPlan() --可用位置标记表
            local props = room_setup_fns[room_idx_list[idx]]()
            for _, prop in ipairs(props) do
                local newTileFound = false
                -- 把房间分成5*5 = 25份，用来放置东西
                repeat
                    local rowTileIndex = math.random(1, #floorPlan)
                    local colTileIndex = math.random(1, #floorPlan[1])
                    newTileFound = not floorPlan[rowTileIndex][colTileIndex]

                    if newTileFound then
                        floorPlan[rowTileIndex][colTileIndex] = true

                        local rowFloorTilePos = rowTileIndex / #floorPlan
                        local colFloorTilePos = colTileIndex / #floorPlan[1]

                        local offsetX = (rowFloorTilePos * 7) - (7 / 2)
                        local offsetZ = (colFloorTilePos * 13) - (13 / 2)

                        prop.x_offset = offsetX
                        prop.z_offset = offsetZ
                    end
                until newTileFound
                builder:AddRoomProp(idx, prop)
            end
            addprops = AddDeco(addprops)
        end
    end

    -- 墙壁和地板、入口
    for idx, room in ipairs(builder.rooms) do
        if room.is_entrance then
            builder:AddRoomProp(idx, { name = "ant_cave_door", x_offset = -depth / 2, key = "exit" .. isEntranceId, anim = "north" })
            isEntranceId = isEntranceId + 1
        end
        builder:AddRoomProp(idx, { name = "interior_floor_antcave" })
        builder:AddRoomProp(idx, { name = "interior_wall_antcave_wall_rock" })
    end

    builder:AddAllRoomDoorProp(GetDoorProp)

    return builder.rooms
end


return {
    CreateMaze = CreateMaze,
    CreateQueenChambers = CreateQueenChambers
}
