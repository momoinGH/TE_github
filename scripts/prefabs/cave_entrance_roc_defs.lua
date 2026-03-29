local RoomUtils = require("tropical_utils/room_utils")

local function GetDoorProp(room, dir, exit)
    return {
        name = "ant_cave_door",
        anim = dir.label
    }
end

local function getlocationoutofcenter(dist, hole, random, invert)
    local pos = (math.random() * ((dist / 2) - (hole / 2))) + hole / 2
    if invert or (random and math.random() < 0.5) then
        pos = pos * -1
    end
    return pos
end

local width = TUNING.ROOM_MEDIUM_WIDTH
local depth = TUNING.ROOM_MEDIUM_DEPTH
local rooms_to_make = 6
local MazeBuilder = require("prefabs/tro_maze_builder")
local function CreateMaze()
    local builder = MazeBuilder()
    builder:SetAllRoomsSize(width, depth)
    builder:CreateRandomRooms(rooms_to_make)
    builder:SetEntrance(1, 1)

    -- 随机选择一个顶部敞开的房间作为出口二，出口是个绳子，随便找个房间也行的
    builder:SelectEntranceRoom(2)

    local inc = 1
    for idx, room in ipairs(builder.rooms) do
        local westexitopen = not room.exits[RoomUtils.DIR.west]
        local southexitopen = not room.exits[RoomUtils.DIR.south]
        local eastexitopen = not room.exits[RoomUtils.DIR.east]

        if room.entrance2 then
            builder:AddRoomProp(idx, { name = "hamlet_cave_exit", z_offset = -width / 6, key = "entrance2" })
        end

        if room.entrance1 then
            builder:AddRoomProp(idx, { name = "hamlet_cave_exit", z_offset = -width / 6, key = "entrance1" })
            builder:AddRoomProp(idx, { name = "roc_cave_light_beam", z_offset = -width / 6 })
        end

        local roomtypes = { "stalacmites", "stalacmites", "glowplants", "ferns", "mushtree" }
        local roomtype = room.entrance1 and "stalacmites" or roomtypes[math.random(1, #roomtypes)]

        builder:AddRoomProp(idx, { name = "deco_cave_cornerbeam", x_offset = -depth / 2, z_offset = -width / 2, })
        builder:AddRoomProp(idx, { name = "deco_cave_cornerbeam", x_offset = -depth / 2, z_offset = width / 2, scale = { -1, 1 } })
        builder:AddRoomProp(idx, { name = "deco_cave_pillar_side", x_offset = depth / 2, z_offset = -width / 2, })
        builder:AddRoomProp(idx, { name = "deco_cave_pillar_side", x_offset = depth / 2, z_offset = width / 2, scale = { -1, 1 } })

        for i = 1, math.random(1, 3) do
            builder:AddRoomProp(idx, { name = "deco_cave_ceiling_trim", x_offset = -depth / 2, z_offset = getlocationoutofcenter(width * 0.6, 3, true) })
        end

        builder:AddRoomProp(idx, { name = "deco_cave_floor_trim_front", x_offset = depth / 2, z_offset = -width / 4, })
        if southexitopen then
            builder:AddRoomProp(idx, { name = "deco_cave_floor_trim_front", x_offset = depth / 2, z_offset = 0, })
        end
        builder:AddRoomProp(idx, { name = "deco_cave_floor_trim_front", x_offset = depth / 2, z_offset = width / 4, })

        if westexitopen and math.random() < 0.7 then
            builder:AddRoomProp(idx, { name = "deco_cave_floor_trim_2", x_offset = (math.random() * depth * 0.5) - depth / 2 * 0.5, z_offset = -width / 2, })
        end

        if eastexitopen and math.random() < 0.7 then
            builder:AddRoomProp(idx, { name = "deco_cave_floor_trim_2", x_offset = (math.random() * depth * 0.5) - depth / 2 * 0.5, z_offset = width / 2, scale = { -1, 1 } })
        end

        if math.random() < 0.7 then
            builder:AddRoomProp(idx, { name = "deco_cave_ceiling_trim_2", x_offset = (math.random() * depth * 0.5) - depth / 2 * 0.5, z_offset = -width / 2, })
        end
        if math.random() < 0.7 then
            builder:AddRoomProp(idx, { name = "deco_cave_ceiling_trim_2", x_offset = (math.random() * depth * 0.5) - depth / 2 * 0.5, z_offset = width / 2, scale = { -1, 1 } })
        end

        if math.random() < 0.5 then
            builder:AddRoomProp(idx, { name = "deco_cave_beam_room", x_offset = (math.random() * depth * 0.65) - depth / 2 * 0.65, z_offset = getlocationoutofcenter(width * 0.65, 7, false, true), })
        end
        if math.random() < 0.5 then
            builder:AddRoomProp(idx, { name = "deco_cave_beam_room", x_offset = (math.random() * depth * 0.65) - depth / 2 * 0.65, z_offset = getlocationoutofcenter(width * 0.65, 7), })
        end

        if math.random() < 0.5 then
            builder:AddRoomProp(idx, { name = "flint", x_offset = getlocationoutofcenter(depth * 0.65, 3, true), z_offset = getlocationoutofcenter(width * 0.65, 3, true) })
        end

        if roomtype == "stalacmites" then
            if math.random() < 0.3 then
                builder:AddRoomProp(idx, { name = "stalagmite", x_offset = getlocationoutofcenter(depth * 0.65, 4, true), z_offset = getlocationoutofcenter(width * 0.65, 4, true) })
            end
            if math.random() < 0.2 then
                if math.random() < 0.5 then
                    builder:AddRoomProp(idx, { name = "stalagmite", x_offset = getlocationoutofcenter(depth * 0.65, 4, true), z_offset = getlocationoutofcenter(width * 0.65, 4, true) })
                else
                    builder:AddRoomProp(idx, { name = "stalagmite_tall", x_offset = getlocationoutofcenter(depth * 0.65, 4, true), z_offset = getlocationoutofcenter(width * 0.65, 4, true) })
                end
            end
            if math.random() < 0.3 then
                builder:AddRoomProp(idx, { name = "stalagmite_tall", x_offset = getlocationoutofcenter(depth * 0.65, 3, true), z_offset = getlocationoutofcenter(width * 0.65, 3, true) })
            end
            if math.random() < 0.5 then
                builder:AddRoomProp(idx, { name = "deco_cave_stalactite", x_offset = (math.random() * depth * 0.5) - depth * 0.5 / 2, z_offset = getlocationoutofcenter(width, 6, true) })
            end
            if math.random() < 0.5 then
                builder:AddRoomProp(idx, { name = "deco_cave_stalactite", x_offset = (math.random() * depth * 0.5) - depth * 0.5 / 2, z_offset = getlocationoutofcenter(width, 6, true) })
            end
        end

        if math.random() < 0.5 then
            builder:AddRoomProp(idx, { name = "deco_cave_stalactite", x_offset = (math.random() * depth * 0.5) - depth * 0.5 / 2, z_offset = getlocationoutofcenter(width, 6, true) })
        end
        if math.random() < 0.5 then
            builder:AddRoomProp(idx, { name = "deco_cave_stalactite", x_offset = (math.random() * depth * 0.5) - depth * 0.5 / 2, z_offset = getlocationoutofcenter(width, 6, true) })
        end

        if roomtype == "ferns" then
            for i = 1, math.random(5, 15) do
                builder:AddRoomProp(idx, { name = "cave_fern", x_offset = (math.random() * depth * 0.7) - depth * 0.7 / 2, z_offset = (math.random() * width * 0.7) - width * 0.7 / 2 })
            end
        end

        if roomtype == "mushtree" then
            if math.random() < 0.3 then
                for i = 1, math.random(3, 8) do
                    builder:AddRoomProp(idx, { name = "mushtree_tall", x_offset = (math.random() * depth * 0.7) - depth * 0.7 / 2, z_offset = (math.random() * width * 0.7) - width * 0.7 / 2 })
                end
            elseif math.random() < 0.5 then
                for i = 1, math.random(3, 8) do
                    builder:AddRoomProp(idx, { name = "mushtree_medium", x_offset = (math.random() * depth * 0.7) - depth * 0.7 / 2, z_offset = (math.random() * width * 0.7) - width * 0.7 / 2 })
                end
            else
                for i = 1, math.random(3, 8) do
                    builder:AddRoomProp(idx, { name = "mushtree_small", x_offset = (math.random() * depth * 0.7) - depth * 0.7 / 2, z_offset = (math.random() * width * 0.7) - width * 0.7 / 2 })
                end
            end
        end

        if roomtype == "glowplants" then
            for i = 1, math.random(4, 12) do
                builder:AddRoomProp(idx, { name = "flower_cave", x_offset = (math.random() * depth * 0.7) - depth * 0.7 / 2, z_offset = (math.random() * width * 0.7) - width * 0.7 / 2 })
            end
        end

        for i = 1, math.random(2, 5) do
            builder:AddRoomProp(idx, { name = "cave_fern", x_offset = getlocationoutofcenter(depth * 0.7, 3, true), z_offset = getlocationoutofcenter(width * 0.7, 3, true) })
        end

        --地板和墙壁
        builder:AddRoomProp(idx, { name = "interior_floor_batcave" })
        builder:AddRoomProp(idx, { name = "interior_wall_batcave_wall_rock" })
    end


    --房间门
    builder:AddAllRoomDoorProp(GetDoorProp)

    return builder.rooms
end

return CreateMaze
