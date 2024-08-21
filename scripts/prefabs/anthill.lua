local InteriorSpawnerUtils = require("interiorspawnerutils")

local assets =
{
    Asset("ANIM", "anim/ant_hill_entrance.zip"),
    Asset("ANIM", "anim/ant_queen_entrance.zip"),
    Asset("SOUND", "sound/pig.fsb"),
    Asset("MINIMAP_IMAGE", "ant_hill_entrance"),
    Asset("MINIMAP_IMAGE", "ant_cave_door"),
}

local prefabs =
{
    "antman",
    "antman_warrior",
    "int_ceiling_dust_fx",
    "antchest",
    "giantgrub",
    "ant_cave_lantern",
    "antqueen",
}

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

local width = TUNING.ROOM_LARGE_WIDTH
local depth = TUNING.ROOM_LARGE_DEPTH

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

local MIN_LANTERNS          = 1
local MAX_LANTERNS          = 3

-- 房间类型
local room_setup_fns        = {
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

local NUM_ENTRANCES         = 3
local NUM_CHAMBER_ENTRANCES = 1 --3

local NUM_ROWS              = 5
local NUM_COLS              = 5

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

local function CreateQueenChambers(rooms, room_count)
    for i = 1, room_count do
        local addprops = {}
        table.insert(rooms, {
            width = width,
            depth = depth,
            idx = #rooms + 1,
            exits = {},
            addprops = addprops,
        })

        if i ~= room_count then
            AddChamberDeco(addprops)

            for i = 1, math.random(2, 5) do
                table.insert(addprops,
                    { name = "antman_warrior", x_offset = getlocationoutofcenter(depth * 0.65, 5, true), z_offset = getlocationoutofcenter(width * 0.65, 5, true) })
            end
            -- 一路向上的门
            table.insert(addprops, { name = "ant_cave_exit_door", x_offset = -depth / 2, key = #rooms .. "NORTH", target_door = (#rooms + 1) .. "SOUTH" })
        else
            -- 蚁后房间
            addprops = AddCommonDeco(addprops)

            table.insert(addprops, { name = "antqueen", })
            table.insert(addprops, { name = "ant_cave_lantern", x_offset = -depth / 2, }) -- Behind the queen, placed there for better lighting

            table.insert(addprops, { name = "ant_cave_lantern", x_offset = -depth / 2, z_offset = (depth / 2) - 2 })
            table.insert(addprops, { name = "ant_cave_lantern", x_offset = -depth / 2, z_offset = (-depth / 2) + 2 })

            table.insert(addprops, { name = "ant_cave_lantern", z_offset = (depth / 2) + 1 })
            table.insert(addprops, { name = "ant_cave_lantern", z_offset = (-depth / 2) - 1 })

            -------------
            -- Gross
            table.insert(addprops, { name = "throne_wall_large", x_offset = 1, z_offset = 2.25 })
            table.insert(addprops, { name = "throne_wall", x_offset = 2.2, z_offset = 2.5 })
            table.insert(addprops, { name = "throne_wall", x_offset = 1.9, z_offset = 3 })
            table.insert(addprops, { name = "throne_wall", x_offset = 1.6, z_offset = 3.5 })
            table.insert(addprops, { name = "throne_wall", x_offset = 1.3, z_offset = 4 })
            table.insert(addprops, { name = "throne_wall", x_offset = 1, z_offset = 4.5 })
            table.insert(addprops, { name = "throne_wall", x_offset = 0.7, z_offset = 5 })
            table.insert(addprops, { name = "throne_wall", x_offset = 0.4, z_offset = 5.5 })
            table.insert(addprops, { name = "throne_wall", x_offset = 0.1, z_offset = 6 })
            table.insert(addprops, { name = "throne_wall", x_offset = -0.4, z_offset = 6 })

            table.insert(addprops, { name = "throne_wall", x_offset = -3.25, z_offset = 1.5 })
            table.insert(addprops, { name = "throne_wall", x_offset = -3, z_offset = 2 })
            table.insert(addprops, { name = "throne_wall", x_offset = -2.75, z_offset = 2.5 })
            table.insert(addprops, { name = "throne_wall", x_offset = -2.5, z_offset = 3 })
            table.insert(addprops, { name = "throne_wall", x_offset = -2.25, z_offset = 3.5 })
            table.insert(addprops, { name = "throne_wall", x_offset = -2, z_offset = 4 })
            table.insert(addprops, { name = "throne_wall", x_offset = -1.75, z_offset = 4.5 })
            table.insert(addprops, { name = "throne_wall", x_offset = -1.5, z_offset = 5 })
            table.insert(addprops, { name = "throne_wall", x_offset = -1.25, z_offset = 5.5 })
            table.insert(addprops, { name = "throne_wall", x_offset = -1, z_offset = 6 })

            table.insert(addprops, { name = "throne_wall", x_offset = -3.25, z_offset = 1 })
            table.insert(addprops, { name = "throne_wall", x_offset = -3.25, .5 })
            table.insert(addprops, { name = "throne_wall", x_offset = -3.25, z_offset = -0 })
            table.insert(addprops, { name = "throne_wall", x_offset = -3.25, z_offset = -0.5 })
            table.insert(addprops, { name = "throne_wall", x_offset = -3.25, z_offset = -1 })
            table.insert(addprops, { name = "throne_wall", x_offset = -3.25, z_offset = -1.5 })
            table.insert(addprops, { name = "throne_wall", x_offset = -3, z_offset = -2 })
            table.insert(addprops, { name = "throne_wall", x_offset = -2.75, z_offset = -2.5 })
            table.insert(addprops, { name = "throne_wall", x_offset = -2.5, z_offset = -3 })
            table.insert(addprops, { name = "throne_wall", x_offset = -2.25, z_offset = -3.5 })
            table.insert(addprops, { name = "throne_wall", x_offset = -2, z_offset = -4 })
            table.insert(addprops, { name = "throne_wall", x_offset = -1.75, z_offset = -4.5 })
            table.insert(addprops, { name = "throne_wall", x_offset = -1.5, z_offset = -5 })
            table.insert(addprops, { name = "throne_wall", x_offset = -1.25, z_offset = -5.5 })
            table.insert(addprops, { name = "throne_wall", x_offset = -1, z_offset = -6 })

            table.insert(addprops, { name = "throne_wall_large", x_offset = 1.5, z_offset = -2.5 })
            table.insert(addprops, { name = "throne_wall", x_offset = 2, z_offset = -3 })
            table.insert(addprops, { name = "throne_wall", x_offset = 1.75, z_offset = -3.5 })
            table.insert(addprops, { name = "throne_wall", x_offset = 1.5, z_offset = -4 })
            table.insert(addprops, { name = "throne_wall", x_offset = 1.25, z_offset = -4.5 })
            table.insert(addprops, { name = "throne_wall", x_offset = 1, z_offset = -5 })
            table.insert(addprops, { name = "throne_wall", x_offset = 0.75, z_offset = -5.5 })
            table.insert(addprops, { name = "throne_wall", z_offset = -6 })
            table.insert(addprops, { name = "throne_wall", x_offset = -0.5, z_offset = -6 })
        end

        table.insert(addprops, {
            name = "ant_cave_south_door",
            x_offset = depth / 2,
            key = #rooms .. "SOUTH",
            target_door = i == 1 and "boss_door" or (#rooms - 1) .. "NORTH" --需要和前面的房间连起来
        })
    end
end

local function spawnDust(inst, dustCount)
    if dustCount > 0 then
        local interior_spawner = GetWorld().components.interiorspawner
        local current_interior = interior_spawner.current_interior

        local pt = interior_spawner:getSpawnOrigin()
        local fx = SpawnPrefab("int_ceiling_dust_fx")
        local VARIANCE = 8.0

        fx.Transform:SetPosition(pt.x + math.random(-VARIANCE, VARIANCE), 0.0, pt.z + math.random(-VARIANCE, VARIANCE))
        fx.Transform:SetScale(2.0, 2.0, 2.0)
        inst:DoTaskInTime(0.5, function() spawnDust(inst, dustCount - 1) end)
    else
        inst:DoTaskInTime(0.5, function() inst.SoundEmitter:KillSound("miniearthquake") end)
    end
end



local function CreateMaze(inst)
    if inst.components.teleporter:GetTarget() then return end

    local queen_chamber_count = math.random(3, 6)

    -- 构建所有房间(不算蚁后那几个房间)
    local rooms = {}
    for i = 1, NUM_ROWS do
        for j = 1, NUM_COLS do
            local idx = #rooms + 1
            local newRoom = {
                width = width,
                depth = depth,
                x = j,
                y = i,
                idx = idx,
                addprops = {},
                exits = {},
                isEntrance = false,
                isChamberEntrance = false,
            }
            --相邻门
            if i > 1 then --顶部有房间
                table.insert(newRoom.addprops, {
                    name = "ant_cave_north_door",
                    x_offset = -depth / 2,
                    key = #rooms .. "NORTH",
                    target_door = (idx - NUM_COLS) .. "SOUTH"
                })
            end
            if i < NUM_ROWS then --底部有房间
                table.insert(newRoom.addprops, {
                    name = "ant_cave_south_door",
                    x_offset = depth / 2,
                    key = #rooms .. "SOUTH",
                    target_door = (idx + NUM_COLS) .. "NORTH"
                })
            end
            if j > 1 then --左边有房间
                table.insert(newRoom.addprops, {
                    name = "ant_cave_east_door",
                    z_offset = -width / 2,
                    key = #rooms .. "EAST",
                    target_door = (idx - 1) .. "WEST"
                })
            end
            if j < NUM_COLS then --右边有房间
                table.insert(newRoom.addprops, {
                    name = "ant_cave_west_door",
                    z_offset = width / 2,
                    key = #rooms .. "WEST",
                    target_door = (idx + 1) .. "EAST"
                })
            end

            table.insert(rooms, newRoom)
        end
    end

    -- 随机选3个房间,isEntrance，三个出口
    local numEntrancesChosen = 0
    repeat
        local room = rooms[math.random(1, #rooms)]
        if not room.isEntrance then
            room.isEntrance = true
            numEntrancesChosen = numEntrancesChosen + 1
        end
    until (numEntrancesChosen == NUM_ENTRANCES)

    -- 随机选1个房间,isChamberEntrance，作为通向蚁后的房间
    numEntrancesChosen = 0
    repeat
        local room = rooms[math.random(1, #rooms)]
        if not room.isEntrance and not room.isChamberEntrance then
            room.isChamberEntrance = true
            numEntrancesChosen = numEntrancesChosen + 1
        end
    until (numEntrancesChosen == NUM_CHAMBER_ENTRANCES)

    --按照比例给每个房间分配不同的类型，编号1~4
    local room_idx_list = {}
    for id, count in ipairs({ 7, 5, 10, 3 }) do
        for i = 1, count do
            table.insert(room_idx_list, id)
        end
    end
    room_idx_list = shuffleArray(room_idx_list) --打乱

    local isEntranceId = 1
    for id, room in ipairs(rooms) do
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

            table.insert(addprops, {
                name = "anthill_cave_queen_door",
                x_offset = spawn_pt.x,
                z_offset = spawn_pt.z,
                key = "boss_door",
            })

            for i = 1, math.random(2, 4) do
                table.insert(addprops,
                    { name = "antman_warrior", x_offset = getlocationoutofcenter(depth * 0.65, 5, true), z_offset = getlocationoutofcenter(width * 0.65, 5, true) })
            end

            for i = 1, math.random(2, 4) do
                table.insert(addprops,
                    { name = "ant_cave_lantern", x_offset = getlocationoutofcenter(depth * 0.65, 5, true), z_offset = getlocationoutofcenter(width * 0.65, 5, true) })
            end
        else
            local floorPlan = buildFloorPlan() --可用位置标记表
            local props = room_setup_fns[room_idx_list[id]]()
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

                table.insert(addprops, prop)
            end

            if room.isEntrance then
                table.insert(addprops, { name = "ant_cave_exit_door", x_offset = -depth / 2, key = "exit" .. isEntranceId })
                isEntranceId = isEntranceId + 1
            end

            addprops = AddDeco(addprops)
        end
    end

    CreateQueenChambers(rooms, queen_chamber_count)

    -- 墙壁和地板
    for _, room in ipairs(rooms) do
        local addprops = room.addprops
        table.insert(addprops, { name = "interior_floor_antcave" })
        table.insert(addprops, { name = "interior_wall_antcave_wall_rock" })
    end

    --连接三个出口
    isEntranceId = isEntranceId - 1
    local doors = InteriorSpawnerUtils.CreateRooms(rooms)
    inst.components.teleporter:Target(doors["exit" .. isEntranceId])
    doors["exit" .. isEntranceId].components.teleporter:Target(inst)

    for _, v in ipairs(TheWorld.anthill_exits) do
        if v:IsValid() and not v.components.teleporter:GetTarget() then
            isEntranceId = isEntranceId - 1
            v.components.teleporter:Target(doors["exit" .. isEntranceId])
            doors["exit" .. isEntranceId].components.teleporter:Target(v)
            if isEntranceId <= 1 then
                break
            end
        end
    end

    while isEntranceId > 1 do --以防万一，就算没有剩下两个出口也要删掉，留个没法用的门也不好
        isEntranceId = isEntranceId - 1
        doors["exit" .. isEntranceId]:Remove()
    end
end

local function getstatus(inst)
    if inst:HasTag("burnt") then
        return "BURNT"
    elseif inst.components.spawner and inst.components.spawner:IsOccupied() then
        if inst.lightson then
            return "FULL"
        else
            return "LIGHTSOUT"
        end
    end
end



local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle")
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local function common(buildanthill)
    local inst = InteriorSpawnerUtils.MakeBaseDoor("ant_hill_entrance", "ant_hill_entrance", "idle", false, false, "ant_hill_entrance.png")

    local light = inst.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(.5)
    light:SetRadius(1)
    light:Enable(false)
    light:SetColour(180 / 255, 195 / 255, 50 / 255)

    inst.Transform:SetScale(0.8, 0.8, 0.8)

    MakeObstaclePhysics(inst, 1.3)

    inst:AddTag("structure")
    inst:AddTag("anthill_outside")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "antman"
    inst.components.childspawner:SetRegenPeriod(TUNING.ANTMAN_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.ANTMAN_RELEASE_TIME)
    inst.components.childspawner:SetMaxChildren(math.random(TUNING.ANTMAN_MIN, TUNING.ANTMAN_MAX))
    inst.components.childspawner:StartSpawning()

    inst.components.inspectable.getstatus = getstatus
    inst.components.inspectable.nameoverride = "anthill"

    inst.name = STRINGS.NAMES.ANTHILL

    if buildanthill then
        inst:DoTaskInTime(0, CreateMaze)
    else
        table.insert(TheWorld.anthill_exits, inst)
    end

    MakeSnowCovered(inst, .01)

    inst.OnSave = onsave
    inst.OnLoad = onload

    inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

local function makefn(buildanthill)
    local fn = function() return common(buildanthill) end
    return fn
end

-- 一个anthill搭配两个anthill_exit使用
return Prefab("anthill", makefn(true), assets, prefabs),
    Prefab("anthill_exit", makefn(false), assets, prefabs)
