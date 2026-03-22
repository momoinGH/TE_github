local RoomUtils = require("tropical_utils/room_utils")

local room_creatures = {
    {
        { name = "bat", x_offset = (math.random() * 7) - (7 / 2), z_offset = (math.random() * 13) - (13 / 2) },
        { name = "bat", x_offset = (math.random() * 7) - (7 / 2), z_offset = (math.random() * 13) - (13 / 2) },
    },
    {
        { name = "bat", x_offset = (math.random() * 7) - (7 / 2), z_offset = (math.random() * 13) - (13 / 2) },
        { name = "bat", x_offset = (math.random() * 7) - (7 / 2), z_offset = (math.random() * 13) - (13 / 2) },
        { name = "bat", x_offset = (math.random() * 7) - (7 / 2), z_offset = (math.random() * 13) - (13 / 2) },
    },
    {
        { name = "scorpion", x_offset = (math.random() * 7) - (7 / 2), z_offset = (math.random() * 13) - (13 / 2) },
        { name = "scorpion", x_offset = (math.random() * 7) - (7 / 2), z_offset = (math.random() * 13) - (13 / 2) },
    },
    {
        { name = "scorpion", x_offset = (math.random() * 7) - (7 / 2), z_offset = (math.random() * 13) - (13 / 2) },
    },
}

local function GetDoorProp(room, dir, exit, width, depth)
    local name
    local build
    local init
    if room.color == "_blue" and not exit.secret then
        build = "pig_ruins_door_blue" --蓝色的门
    end
    if exit.secret then
        --隐藏门
        name = "wallcrack_ruins"
    elseif exit.vined then
        --藤蔓门
        name = "prop_door"
        init = function(inst)
            inst:SetVine()
        end
    else
        name = "prop_door"
    end

    local x_offset, z_offset
    if dir == RoomUtils.GetNorth() then
        x_offset = -depth / 2
    elseif dir == RoomUtils.GetSouth() then
        x_offset = depth / 2
    elseif dir == RoomUtils.GetEast() then
        z_offset = -width / 2
    elseif dir == RoomUtils.GetWest() then
        z_offset = width / 2
    end

    return {
        name = name,
        x_offset = x_offset,
        z_offset = z_offset,
        build = build,
        anim = dir.label,
        init = init,
    }
end

local function exitNumbers(room)
    local exits = room.exits
    local total = 0
    for i, exit in pairs(exits) do
        total = total + 1
    end
    if room.entrance1 or room.entrance2 then
        total = total + 1
    end
    return total
end
local function spawnspeartrapset(addprops, depth, width, offsetx, offsetz, tags, nocenter, full, scale, pluspattern)
    local scaledist = scale or 15
    if pluspattern then
        table.insert(addprops, { name = "pig_ruins_spear_trap", x_offset = -depth / scaledist + offsetx, z_offset = 0 + offsetz, addtags = tags })
        table.insert(addprops, { name = "pig_ruins_spear_trap", x_offset = 0 + offsetx, z_offset = -width / scaledist + offsetz, addtags = tags })
        table.insert(addprops, { name = "pig_ruins_spear_trap", x_offset = 0 + offsetx, z_offset = width / scaledist + offsetz, addtags = tags })
        table.insert(addprops, { name = "pig_ruins_spear_trap", x_offset = depth / scaledist - offsetx, z_offset = 0 + offsetz, addtags = tags })
    else
        table.insert(addprops, { name = "pig_ruins_spear_trap", x_offset = -depth / scaledist + offsetx, z_offset = -width / scaledist + offsetz, addtags = tags })
        table.insert(addprops, { name = "pig_ruins_spear_trap", x_offset = -depth / scaledist + offsetx, z_offset = width / scaledist + offsetz, addtags = tags })
        if not nocenter then
            table.insert(addprops, { name = "pig_ruins_spear_trap", x_offset = 0 + offsetx, z_offset = 0 + offsetz, addtags = tags })
        end
        table.insert(addprops, { name = "pig_ruins_spear_trap", x_offset = depth / scaledist + offsetx, z_offset = -width / scaledist + offsetz, addtags = tags })
        table.insert(addprops, { name = "pig_ruins_spear_trap", x_offset = depth / scaledist + offsetx, z_offset = width / scaledist + offsetz, addtags = tags })
        if full then
            table.insert(addprops, { name = "pig_ruins_spear_trap", x_offset = -depth / scaledist + offsetx, z_offset = 0 + offsetz, addtags = tags })
            table.insert(addprops, { name = "pig_ruins_spear_trap", x_offset = depth / scaledist + offsetx, z_offset = 0 + offsetz, addtags = tags })
            table.insert(addprops, { name = "pig_ruins_spear_trap", x_offset = 0 + offsetx, z_offset = -width / scaledist + offsetz, addtags = tags })
            table.insert(addprops, { name = "pig_ruins_spear_trap", x_offset = 0 + offsetx, z_offset = width / scaledist + offsetz, addtags = tags })
        end
    end
    return addprops
end
local function addgoldstatue(addprops, x, z)
    table.insert(addprops, { name = math.random() < 0.5 and "pig_ruins_pig" or "pig_ruins_ant", x_offset = x, z_offset = z })
    return addprops
end
local function addrelicstatue(addprops, x, z, tags)
    table.insert(addprops, { name = math.random() < 0.5 and "pig_ruins_idol" or "pig_ruins_plaque", x_offset = x, z_offset = z, addtags = tags })
    return addprops
end
local function makechoice(list)
    local item = nil
    local total = 0
    for i = 1, #list do
        total = total + list[i][2]
    end
    local choice = math.random(1, total)
    total = 0
    local last = 0
    local top = 0
    --    print("-------------")
    for i = 1, #list do
        top = top + list[i][2]
        --     print("CHECK",last,top,choice)
        if choice > last and choice <= top then
            --        print("CHECK TRUE")
            item = list[i][1]
            break
        end
        last = top
    end
    assert(item)
    return item
end


---构建房间
---@param dungeondef.name string|nil --遗迹类型，RUINS_5表示存放日晷的遗迹
---@param dungeondef.rooms number --房间数量
---@param dungeondef.lock boolean --遗迹入口门是否生成藤蔓
---@param dungeondef.doorvines number|nil --遗迹内部的门生成藤蔓的概率
---@param dungeondef.deepruins boolean --有些建筑外观是蓝色的，陷阱和装饰多一点，有蓝色母猪及宝石松露
---@param dungeondef.secretrooms number|nil --期望秘密房间数量，生成后有可能小于这个值
---@param dungeondef.nosecondexit boolean --是否没有第二个出口
---@param dungeondef.smallsecret boolean --秘密房间宝物生成多点还是少点
local function mazemaker(dungeondef)
    assert(dungeondef.rooms)
    dungeondef.secretrooms = dungeondef.secretrooms or 0

    local DIR = RoomUtils.DIR
    local DIR_OPPOSITE = RoomUtils.DIR_OPPOSITE
    local rooms_to_make = dungeondef.rooms
    local rooms = { {
        x = 0,                                    --房间坐标，遗迹入口位于0,0，x右加左减，y上加下减
        y = 0,
        idx = 1,                                  --房间编号，生成房间时会根据这个来判断什么房间相邻，生成对应的门
        exits = {},                               --表示这个房间可以通向哪些房间
        blocked_exits = { RoomUtils.GetNorth() }, --被堵塞的方向，表示上面不能建造门
        entrance1 = true,                         --表示遗迹出口一所在房间
    } }

    -- 构建每一个房间
    while #rooms < rooms_to_make do
        -- 从现有房间里随机选择一个房间作为前置房间，然后在前置房间随机选择一个方向
        local dir_choice = math.random(#DIR)
        local fromroom = rooms[math.random(#rooms)]
        local fail = false
        -- fail if this direction from the chosen room is blocked
        --该方向被堵住了
        for i, exit in ipairs(fromroom.blocked_exits) do
            if DIR[dir_choice] == exit then
                fail = true
                break
            end
        end
        -- fail if this room of the maze is already set up.
        -- 该方向已经有房间了
        if not fail then
            for i, checkroom in ipairs(rooms) do
                if checkroom.x == fromroom.x + DIR[dir_choice].x
                    and checkroom.y == fromroom.y + DIR[dir_choice].y
                then
                    fail = true
                    break
                end
            end
        end
        if not fail then
            local newroom = {
                x = fromroom.x + DIR[dir_choice].x,
                y = fromroom.y + DIR[dir_choice].y,
                idx = #rooms + 1,
                exits = {},
                blocked_exits = {},
            }
            fromroom.exits[DIR[dir_choice]] = {
                target_room = newroom.idx,
                room = fromroom.idx,
            }
            newroom.exits[DIR_OPPOSITE[dir_choice]] = {
                target_room = fromroom.idx,
                room = newroom.idx,
            }
            if dungeondef.doorvines and math.random() < dungeondef.doorvines then --藤蔓
                fromroom.exits[DIR[dir_choice]].vined = true
                newroom.exits[DIR_OPPOSITE[dir_choice]].vined = true
            end
            table.insert(rooms, newroom)
        end
    end

    local clock_placed = false
    local function CreateSecretRoom()
        -- grid[x][y] 表示坐标{x,y}的空间是可用的，可用来构建隐藏房间，值为相邻房间数据
        local grid = {}
        local function CheckFreeGridPos(x, y)
            for i, room in ipairs(rooms) do
                if room.x == x and room.y == y then
                    return false
                end
            end
            return true
        end
        local function CheckAdjacent(room, dir)
            local x = room.x + dir.x
            local y = room.y + dir.y
            if CheckFreeGridPos(x, y) then
                if not grid[x] then
                    grid[x] = {}
                end
                if not grid[x][y] then
                    grid[x][y] = { rooms = { room }, dirs = { dir } }
                else
                    table.insert(grid[x][y].rooms, room)
                    table.insert(grid[x][y].dirs, dir)
                end
            end
        end

        local function FindCandidates()
            for i, room in ipairs(rooms) do
                -- 通往秘密房间的门只会出现在上左右
                local north = RoomUtils.GetNorth()
                local west = RoomUtils.GetWest()
                local east = RoomUtils.GetEast()
                -- NORTH IS OPEN
                if not room.exits[north] and not room.entrance2 and not room.entrance1 then
                    CheckAdjacent(room, north)
                end
                -- WEST IS OPEN
                if not room.exits[west] then
                    CheckAdjacent(room, west)
                end
                -- EAST IS OPEN
                if not room.exits[east] then
                    CheckAdjacent(room, east)
                end
            end
        end
        -- 相邻房间最多的房间坐标
        local function GetMax()
            local max_x = 0
            local max_y = 0
            local max = 0
            for k, v in pairs(grid) do
                for k2, v2 in pairs(v) do
                    if #v2.rooms > max then
                        max = #v2.rooms
                        max_x = k
                        max_y = k2
                    end
                end
            end
            if max > 0 then
                return max_x, max_y
            end
        end
        -- 隐藏房间
        local function PopulateSecretRoom(x, y)
            local secret_room = {
                x = x,
                y = y,
                idx = #rooms + 1,
                exits = {},
                blocked_exits = {},
                secretroom = true
            }
            local grid_rooms = grid[x][y].rooms
            local grid_dirs = grid[x][y].dirs
            if dungeondef.name == "runis_5" and not clock_placed then
                -- 可以放置日晷
                clock_placed = true
                secret_room.aporkalypseclock = true
                while #grid_rooms > 1 do
                    local num = math.random(1, #grid_rooms)
                    table.remove(grid_rooms, num)
                    table.remove(grid_dirs, num)
                end
            end
            -- 将秘密房间和相邻房间相连通
            for i, grid_room in ipairs(grid_rooms) do
                local op_dir = RoomUtils.GetOppositeFromDirection(grid_dirs[i])
                local secret = true
                if secret_room.aporkalypseclock then
                    secret = false --有日晷的房间
                end
                secret_room.exits[op_dir] = {
                    target_room = grid_room.idx,
                    room = secret_room.idx,
                    secret = secret,
                }
                grid_room.exits[grid_dirs[i]] = {
                    target_room = secret_room.idx,
                    room = grid_room.idx,
                    secret = true
                }
            end
            grid[x][y] = nil
            return secret_room
        end

        FindCandidates()
        local secret_room_count = dungeondef.secretrooms --只是尝试次数
        for i = 1, secret_room_count do
            local x, y = GetMax()
            if x == nil or y == nil then
                print("COULDN'T FIND SUITABLE CANDIDATES FOR THE SECRET ROOM.")
            else
                local newroom = PopulateSecretRoom(x, y)
                if newroom then
                    table.insert(rooms, newroom)
                end
            end
        end
    end

    -- 遍历所有房间，查找那些顶部没有房间并且距离出口一房间最远的房间，查找结果随机选择一个作为遗迹出口二所在房间
    local choices
    if not dungeondef.nosecondexit then
        choices = {}
        local dist = 0
        for i, room in ipairs(rooms) do
            local north_exit_open = not room.exits[RoomUtils.GetNorth()]
            if math.abs(room.x) + math.abs(room.y) >= dist and north_exit_open then
                if math.abs(room.x) + math.abs(room.y) > dist then
                    choices = {}
                end
                table.insert(choices, room)
                dist = math.abs(room.x) + math.abs(room.y)
            end
        end
        if #choices > 0 then
            choices[math.random(#choices)].entrance2 = true
        end
    end

    -- 查找只有一个门的房间，用来生成一些乱七八糟的东西
    choices = {}
    for i, room in ipairs(rooms) do
        if exitNumbers(room) == 1 then
            table.insert(choices, room)
        end
    end
    local advancedtraps = false
    if dungeondef.name == "runis_3" then
        choices[math.random(#choices)].pheromonestone = true
    elseif dungeondef.name == "runis_1" then
        choices[math.random(#choices)].relictruffle = true
    elseif dungeondef.name == "runis_2" then
        choices[math.random(#choices)].relicsow = true
    elseif dungeondef.name == "runis_5" then
        advancedtraps = true
        choices[math.random(#choices)].endswell = true
    else
        choices[math.random(#choices)].treasure = true
    end
    CreateSecretRoom()


    local width = TUNING.ROOM_MEDIUM_WIDTH
    local depth = TUNING.ROOM_MEDIUM_DEPTH
    local inc = 0
    for id, room in ipairs(rooms) do
        room.width = width
        room.depth = depth

        local addprops = room.addprops
        if not addprops then
            addprops = {}
            room.addprops = addprops
        end

        if dungeondef.deepruins and math.random() < 0.3 then
            room.color = "_blue"
        else
            room.color = ""
        end
        local nopressureplates = false
        if exitNumbers(room) == 1 or math.random() < 0.3 then
            -- all rooms with 1 exit get creatures, randomly add creatures otherwise
            for p, prop in ipairs(room_creatures[math.random(#room_creatures)]) do
                table.insert(addprops, prop)
            end
        end
        if room.entrance1 then
            table.insert(addprops, {
                name = "prop_door",
                x_offset = -depth / 2,
                key = "entrance1"
            })
        end
        if room.entrance2 then
            table.insert(addprops, {
                name = "prop_door",
                x_offset = -depth / 2,
                key = "entrance2"
            })
        end
        if room.endswell then
            table.insert(addprops, { name = "deco_ruins_endswell" })
        end
        if room.pheromonestone then
            table.insert(addprops, { name = "pheromonestone" })
        end
        local roomtype = nil
        local treasuretype = nil
        if room.endswell then
            -- this prevents other features from conflicting with the endswell well.
            roomtype = "treasure"
            treasuretype = "endswell"
        elseif room.aporkalypseclock then
            roomtype = "treasure"
            treasuretype = "aporkalypse"
        elseif room.secretroom then
            roomtype = "treasure"
            treasuretype = "secret"
        elseif room.relictruffle or room.relicsow then
            roomtype = "treasure"
            treasuretype = "rarerelic"
        elseif room.treasure then
            roomtype = "treasure"
        else
            local roomtypes = { "grownover", "storeroom", "smalltreasure", "snakes!", "speartraps!", "darts!" } -- lightfires -- critters
            -- if more than one exit, add the doortrap to the potential list
            if exitNumbers(room) > 1 and not room.sercretroom then
                table.insert(roomtypes, "doortrap")
                table.insert(roomtypes, "doortrap")
            end
            roomtype = roomtypes[math.random(1, #roomtypes)]
        end

        -- 有概率生成假的隐藏门
        local northexitopen = not room.exits[RoomUtils.GetNorth()] and not room.entrance2 and not room.entrance1
        local westexitopen = not room.exits[RoomUtils.GetWest()]
        local southexitopen = not room.exits[RoomUtils.GetSouth()]
        local eastexitopen = not room.exits[RoomUtils.GetEast()]
        local numexits = GetTableSize(room.exits)
        local x_offset, z_offset = 0, 0
        local door_orientation
        if northexitopen and math.random() < 0.10 then
            x_offset = -depth / 2
            northexitopen = false
            door_orientation = "north"
        end
        if westexitopen and math.random() < 0.10 then
            z_offset = -width / 2
            westexitopen = false
            door_orientation = "west"
        end
        if eastexitopen and math.random() < 0.10 then
            z_offset = width / 2
            eastexitopen = false
            door_orientation = "east"
        end
        if door_orientation then
            table.insert(addprops, {
                name = "wallcrack_ruins", --假的
                x_offset = x_offset,
                z_offset = z_offset,
                anim = door_orientation
            })
        end

        local fountain = false
        -- 添加柱子
        local function addroomcolumn(x, z)
            if math.random() < 0.2 then
                table.insert(addprops, { name = "deco_ruins_beam_room_broken" .. room.color, x_offset = x, z_offset = z, })
            else
                table.insert(addprops, { name = "deco_ruins_beam_room" .. room.color, x_offset = x, z_offset = z, })
            end
        end
        local function getspawnlocation(widthrange, depthrange)
            local setwidth = width * widthrange * math.random() - width * widthrange / 2
            local setdepth = depth * depthrange * math.random() - depth * depthrange / 2
            if not fountain or math.abs(setwidth * setwidth) + math.abs(setdepth * setdepth) < 4 * 4 then --过滤到许愿井的位置
                return setwidth, setdepth
            end
        end
        -- put in the general decor... may dictate where other things go later, like due to the fountain.
        -- 柱子装饰
        if roomtype ~= "darts!"
            and roomtype ~= "speartraps!"
            and roomtype ~= "rarerelic"
            and roomtype ~= "treasure"
            and roomtype ~= "smalltreasure"
            and roomtype ~= "secret"
            and roomtype ~= "aporkalypse"
        then
            local feature = math.random(8)
            if feature == 1 then
                addroomcolumn(-depth / 6, -width / 6)
                addroomcolumn(depth / 6, width / 6)
                addroomcolumn(depth / 6, -width / 6)
                addroomcolumn(-depth / 6, width / 6)
            elseif feature == 2 then
                if roomtype ~= "doortrap" and not room.pheromonestone then
                    table.insert(addprops, { name = "deco_ruins_fountain" })
                    fountain = true
                end
                if math.random() < 0.5 then
                    addroomcolumn(-depth / 6, width / 3)
                    addroomcolumn(depth / 6, -width / 3)
                else
                    addroomcolumn(-depth / 4, width / 4)
                    addroomcolumn(-depth / 4, -width / 4)
                    addroomcolumn(depth / 4, -width / 4)
                    addroomcolumn(depth / 4, width / 4)
                end
            elseif feature == 3 then
                addroomcolumn(-depth / 4, width / 6)
                addroomcolumn(0, width / 6)
                addroomcolumn(depth / 4, width / 6)
                addroomcolumn(-depth / 4, -width / 6)
                addroomcolumn(0, -width / 6)
                addroomcolumn(depth / 4, -width / 6)
            end
        end
        -- Sets up the secret room
        -- 蝰蛇
        if roomtype == "snakes!" then
            for _ = 1, math.random(3, 6) do
                table.insert(addprops, {
                    name = "snake_amphibious",
                    x_offset = depth * 0.8 * math.random() - depth * 0.8 / 2,
                    z_offset = width * 0.8 * math.random() - width * 0.8 / 2
                })
            end
        end
        -- 瓦罐
        if roomtype == "storeroom" then
            for _ = 1, math.random(6) + 6 do
                local setwidth, setdepth = getspawnlocation(0.8, 0.8)
                if setwidth and setdepth then
                    table.insert(addprops, { name = "smashingpot", x_offset = setdepth, z_offset = setwidth })
                end
            end
        end
        -- 自动门
        if roomtype == "doortrap" then
            local setups = { "default", "default", "default", "hor", "vert" }
            if dungeondef.deepruins then
                if northexitopen or southexitopen then
                    table.insert(setups, "longhor")
                end
                if eastexitopen or westexitopen then
                    table.insert(setups, "longvert")
                end
            end
            local random = math.random(1, #setups)
            if setups[random] == "default" then
                table.insert(addprops,
                    { name = "pig_ruins_pressure_plate", x_offset = -depth / 2 + 3 + (math.random() * 2 - 1), z_offset = (math.random() * 2 - 1) })
                table.insert(addprops,
                    { name = "pig_ruins_pressure_plate", x_offset = depth / 2 - 3 + (math.random() * 2 - 1), z_offset = (math.random() * 2 - 1) })
                table.insert(addprops,
                    { name = "pig_ruins_pressure_plate", x_offset = (math.random() * 2 - 1), z_offset = (math.random() * 2 - 1) })
                table.insert(addprops, { name = "pig_ruins_pressure_plate", x_offset = (math.random() * 2 - 1), z_offset = width / 2 - 3 + (math.random() * 2 - 1) })
                table.insert(addprops, { name = "pig_ruins_pressure_plate", x_offset = (math.random() * 2 - 1), z_offset = -width / 2 + 3 + (math.random() * 2 - 1) })
            elseif setups[random] == "hor" then
                local unit = 1.5
                table.insert(addprops, { name = "pig_ruins_pressure_plate" })
                for i = 1, 3 do
                    table.insert(addprops, { name = "pig_ruins_pressure_plate", z_offset = i * unit })
                    table.insert(addprops, { name = "pig_ruins_pressure_plate", z_offset = -i * unit })
                end
            elseif setups[random] == "longvert" then
                local unit = 1.5
                local dir = {}
                if eastexitopen then
                    table.insert(dir, 1)
                end
                if westexitopen then
                    table.insert(dir, -1)
                end
                dir = dir[math.random(1, #dir)]
                table.insert(addprops, { name = "pig_ruins_pressure_plate", x_offset = depth / 4.5 * dir })
                for i = 1, 7 do
                    table.insert(addprops,
                        { name = "pig_ruins_pressure_plate", x_offset = depth / 4.5 * dir, z_offset = i * unit })
                    table.insert(addprops,
                        { name = "pig_ruins_pressure_plate", x_offset = depth / 4.5 * dir, z_offset = -i * unit })
                end
            elseif setups[random] == "vert" then
                local unit = 1.5
                table.insert(addprops, { name = "pig_ruins_pressure_plate" })
                for i = 1, 3 do
                    table.insert(addprops, { name = "pig_ruins_pressure_plate", x_offset = i * unit })
                    table.insert(addprops, { name = "pig_ruins_pressure_plate", x_offset = -i * unit })
                end
            elseif setups[random] == "longhor" then
                local unit = 1.5
                local dir = {}
                if northexitopen then
                    table.insert(dir, -1)
                end
                if southexitopen then
                    table.insert(dir, 1)
                end
                dir = dir[math.random(1, #dir)]
                table.insert(addprops, { name = "pig_ruins_pressure_plate", z_offset = width / 4.5 * dir })
                for i = 1, 5 do
                    table.insert(addprops, { name = "pig_ruins_pressure_plate", x_offset = i * unit, z_offset = width / 4.5 * dir })
                    table.insert(addprops, { name = "pig_ruins_pressure_plate", x_offset = -i * unit, z_offset = width / 4.5 * dir })
                end
            end
        end
        -- 宝物
        if roomtype == "treasure" then
            if treasuretype and treasuretype == "aporkalypse" then
                table.insert(addprops, { name = "aporkalypse_clock", x_offset = -1 })
                fountain = true
            elseif treasuretype and treasuretype == "secret" then
                local items = { redgem = 30, bluegem = 20, relic_1 = 10, relic_2 = 10, relic_3 = 10, nightsword = 1, ruins_bat = 1, ruinshat = 1, orangestaff = 1, armorruins = 1, multitool_axe_pickaxe = 1 }
                if not dungeondef.smallsecret then
                    table.insert(addprops,
                        { name = "shelves_ruins", x_offset = -depth / 7, z_offset = -width / 7, shelfitems = { { 1, weighted_random_choice(items) } } })
                    table.insert(addprops,
                        { name = "shelves_ruins", x_offset = depth / 7, z_offset = -width / 7, shelfitems = { { 1, weighted_random_choice(items) } } })
                    table.insert(addprops,
                        { name = "shelves_ruins", x_offset = -depth / 7, z_offset = width / 7, shelfitems = { { 1, weighted_random_choice(items) } } })
                    table.insert(addprops,
                        { name = "shelves_ruins", x_offset = depth / 7, z_offset = width / 7, shelfitems = { { 1, weighted_random_choice(items) } } })
                else
                    table.insert(addprops,
                        { name = "shelves_ruins", z_offset = -width / 7, shelfitems = { { 1, weighted_random_choice(items) } } })
                    table.insert(addprops,
                        { name = "shelves_ruins", z_offset = width / 7, shelfitems = { { 1, weighted_random_choice(items) } } })
                end
            elseif treasuretype and treasuretype == "rarerelic" then
                -- 文物
                room.color = "_blue"
                local relic = room.relicsow and "pig_ruins_sow" or "pig_ruins_truffle"
                if not northexitopen and southexitopen then
                    table.insert(addprops, { name = relic, x_offset = depth / 2 - 2, })
                    table.insert(addprops, { name = "pig_ruins_light_beam", x_offset = depth / 2 - 2 })
                elseif not southexitopen and northexitopen then
                    table.insert(addprops, { name = relic, x_offset = -depth / 2 + 2, })
                    table.insert(addprops, { name = "pig_ruins_light_beam", x_offset = -depth / 2 + 2 })
                elseif not westexitopen and eastexitopen then
                    table.insert(addprops, { name = relic, z_offset = width / 2 - 2, })
                    table.insert(addprops, { name = "pig_ruins_light_beam", z_offset = width / 2 - 2 })
                elseif not eastexitopen and westexitopen then
                    table.insert(addprops, { name = relic, z_offset = -width / 2 + 2, })
                    table.insert(addprops, { name = "pig_ruins_light_beam", z_offset = -width / 2 + 2 })
                else
                    -- Place it in the middle of the room as a fallback.
                    table.insert(addprops, { name = relic, })
                    table.insert(addprops, { name = "pig_ruins_light_beam" })
                end
                for i = 0, 3 do
                    for t = 0, 3 do
                        local x = -depth / 2 + (depth / 4 * i)
                        local z = -width / 2 + (width / 4 * i)
                        if math.random() < 0.6 then
                            table.insert(addprops, { name = "pig_ruins_light_beam", x_offset = x, z_offset = z })
                        end
                    end
                end
                local function add4plates(x, y)
                    if math.random() < 0.5 then
                        local xoffset = x + depth / 16
                        local yoffset = y - width / 16
                        if math.abs(xoffset) < depth / 2 and math.abs(yoffset) < width / 2 then
                            table.insert(addprops, { name = "pig_ruins_pressure_plate", x_offset = xoffset, z_offset = yoffset, })
                        end
                    end
                    if math.random() < 0.5 then
                        local xoffset = x - depth / 16
                        local yoffset = y - width / 16
                        if math.abs(xoffset) < depth / 2 and math.abs(yoffset) < width / 2 then
                            table.insert(addprops, { name = "pig_ruins_pressure_plate", x_offset = xoffset, z_offset = yoffset, })
                        end
                    end
                    if math.random() < 0.5 then
                        local xoffset = x - depth / 16
                        local yoffset = y + width / 16
                        if math.abs(xoffset) < depth / 2 and math.abs(yoffset) < width / 2 then
                            table.insert(addprops, { name = "pig_ruins_pressure_plate", x_offset = xoffset, z_offset = yoffset, })
                        end
                    end
                    if math.random() < 0.5 then
                        local xoffset = x + depth / 16
                        local yoffset = y + width / 16
                        if math.abs(xoffset) < depth / 2 and math.abs(yoffset) < width / 2 then
                            table.insert(addprops, { name = "pig_ruins_pressure_plate", x_offset = xoffset, z_offset = yoffset, })
                        end
                    end
                end
                if math.random() < 0.5 then
                    table.insert(addprops, { name = "pig_ruins_dart_statue", x_offset = depth / 4, z_offset = width / 4 })
                    table.insert(addprops, { name = "pig_ruins_dart_statue", x_offset = -depth / 4, z_offset = -width / 4 })
                else
                    table.insert(addprops, { name = "pig_ruins_dart_statue", x_offset = -depth / 4, z_offset = width / 4 })
                    table.insert(addprops, { name = "pig_ruins_dart_statue", x_offset = depth / 4, z_offset = -width / 4 })
                end
                add4plates(depth / 4, width / 4)
                add4plates(depth / 4, 0)
                add4plates(depth / 4, -width / 4)
                add4plates(0, width / 4)
                add4plates(0, 0)
                add4plates(0, -width / 4)
                add4plates(-depth / 4, width / 4)
                add4plates(-depth / 4, 0)
                add4plates(-depth / 4, -width / 4)
                add4plates(-depth / 2, width / 4)
                add4plates(-depth / 2, -width / 4)
                add4plates(depth / 2, width / 4)
                add4plates(depth / 2, -width / 4)
                add4plates(depth / 4, width / 2)
                add4plates(depth / 4, -width / 2)
                add4plates(-depth / 4, -width / 2)
                add4plates(-depth / 4, width / 2)
            elseif not treasuretype or treasuretype ~= "endswell" then
                -- 雕像
                local setups = { "darts n relics", "spears n relics", "relics n dust" }
                local random = math.random(1, #setups)
                random = 1
                if setups[random] == "relics n dust" then
                    addprops = addgoldstatue(addprops, -depth / 3, -width / 3)
                    addprops = addgoldstatue(addprops, depth / 3, width / 3)
                    addprops = addrelicstatue(addprops, 0, 0)
                    addprops = addgoldstatue(addprops, depth / 3, -width / 3)
                    addprops = addgoldstatue(addprops, -depth / 3, width / 3)
                elseif setups[random] == "spears n relics" then
                    addprops = addrelicstatue(addprops, 0, -width / 4)
                    addprops = addrelicstatue(addprops, 0, 0)
                    addprops = addrelicstatue(addprops, 0, width / 4)
                    addprops = spawnspeartrapset(addprops, depth, width, 0, -width / 4, nil, true, true, 12)
                    table.insert(addprops, { name = "pig_ruins_light_beam", z_offset = -width / 4 })
                    addprops = spawnspeartrapset(addprops, depth, width, 0, 0, nil, true, true, 12)
                    table.insert(addprops, { name = "pig_ruins_light_beam" })
                    addprops = spawnspeartrapset(addprops, depth, width, 0, width / 4, nil, true, true, 12)
                    table.insert(addprops, { name = "pig_ruins_light_beam", z_offset = width / 4 })
                elseif setups[random] == "darts n relics" then
                    addprops = addrelicstatue(addprops, 0, -width / 3 + 1, { "trggerdarttraps" })
                    addprops = addrelicstatue(addprops, depth / 4 - 1, 0, { "trggerdarttraps" })
                    addprops = addrelicstatue(addprops, 0, width / 3 - 1, { "trggerdarttraps" })
                    roomtype = "darts!"
                    nopressureplates = true
                end
            end
        elseif roomtype == "smalltreasure" then
            -- 小宝物
            if math.random() < 0.5 then
                addprops = addgoldstatue(addprops, 0, -width / 6)
                addprops = addgoldstatue(addprops, 0, width / 6)
            else
                addprops = addrelicstatue(addprops, 0, 0)
            end
        elseif roomtype == "grownover" then
            -- 杂草
            for i = 1, math.random(10) + 8 do
                local setwidth, setdepth = getspawnlocation(0.8, 0.8)
                if setwidth and setdepth then
                    table.insert(addprops, { name = "grass", x_offset = setdepth, z_offset = setwidth })
                end
            end
            for i = 1, math.random(4) + 8 do
                local setwidth, setdepth = getspawnlocation(0.8, 0.8)
                if setwidth and setdepth then
                    table.insert(addprops, { name = "sapling", x_offset = setdepth, z_offset = setwidth })
                end
            end
            for i = 1, math.random(10) + 10 do
                local setwidth, setdepth = getspawnlocation(0.8, 0.8)
                if setwidth and setdepth then
                    table.insert(addprops, { name = "deep_jungle_fern_noise_plant", x_offset = setdepth, z_offset = setwidth })
                end
            end
            table.insert(addprops, { name = "lightrays" })
        end
        -- GENERAL RUINS ROOM ART
        if math.random() < 0.8 or roomtype == "lightfires" or roomtype == "darts!" then -- the wall torches get blocked by the big beams
            table.insert(addprops,
                { name = "deco_ruins_cornerbeam" .. room.color, x_offset = -depth / 2, z_offset = -width / 2 })
            table.insert(addprops,
                { name = "deco_ruins_cornerbeam" .. room.color, x_offset = -depth / 2, z_offset = width / 2, scale = { -1, 1 } })
            table.insert(addprops,
                { name = "deco_ruins_cornerbeam" .. room.color, x_offset = depth / 2, z_offset = -width / 2 })
            table.insert(addprops,
                { name = "deco_ruins_cornerbeam" .. room.color, x_offset = depth / 2, z_offset = width / 2, scale = { -1, 1 } })
        else
            table.insert(addprops,
                { name = "deco_ruins_cornerbeam_heavy" .. room.color, x_offset = -depth / 2, z_offset = -width / 2 })
            table.insert(addprops,
                { name = "deco_ruins_cornerbeam_heavy" .. room.color, x_offset = -depth / 2, z_offset = width / 2, scale = { -1, 1 } })
            table.insert(addprops,
                { name = "deco_ruins_beam_heavy" .. room.color, x_offset = depth / 2, z_offset = -width / 2 })
            table.insert(addprops,
                { name = "deco_ruins_beam_heavy" .. room.color, x_offset = depth / 2, z_offset = width / 2, scale = { -1, 1 } })
        end
        local prop = math.random() < 0.2 and ("deco_ruins_beam_broken" .. room.color) or ("deco_ruins_beam" .. room.color)
        table.insert(addprops, { name = prop, x_offset = -depth / 2, z_offset = -width / 6 })
        table.insert(addprops, { name = prop, x_offset = -depth / 2, z_offset = width / 6, })
        if room.exits[RoomUtils.GetNorth()] and room.exits[RoomUtils.GetNorth()].vined then
            table.insert(addprops, { name = "pig_ruins_wall_vines_north", x_offset = -depth / 2, z_offset = -width / 2 + 0.75 })
            table.insert(addprops, { name = "pig_ruins_wall_vines_north", x_offset = -depth / 2, z_offset = -width / 3 + 0.75 })
            table.insert(addprops, { name = "pig_ruins_wall_vines_north", x_offset = -depth / 2, z_offset = -width / 3 - 0.75 })
            table.insert(addprops, { name = "pig_ruins_wall_vines_north", x_offset = -depth / 2, z_offset = -width / 6 + 0.75 })
            table.insert(addprops, { name = "pig_ruins_wall_vines_north", x_offset = -depth / 2, z_offset = -width / 6 - 0.75 })
            table.insert(addprops, { name = "pig_ruins_wall_vines_north", x_offset = -depth / 2, z_offset = width / 6 + 0.75 })
            table.insert(addprops, { name = "pig_ruins_wall_vines_north", x_offset = -depth / 2, z_offset = width / 6 - 0.75 })
            table.insert(addprops, { name = "pig_ruins_wall_vines_north", x_offset = -depth / 2, z_offset = width / 3 + 0.75 })
            table.insert(addprops, { name = "pig_ruins_wall_vines_north", x_offset = -depth / 2, z_offset = width / 3 - 0.75 })
            table.insert(addprops, { name = "pig_ruins_wall_vines_north", x_offset = -depth / 2, z_offset = width / 2 - 0.75 })
        end
        if room.exits[RoomUtils.GetWest()] and room.exits[RoomUtils.GetWest()].vined then
            table.insert(addprops, { name = "pig_ruins_wall_vines_east", x_offset = -depth / 2 + 0.75, z_offset = -width / 2 })
            table.insert(addprops, { name = "pig_ruins_wall_vines_east", x_offset = -depth / 3 - 0.75, z_offset = -width / 2 })
            table.insert(addprops, { name = "pig_ruins_wall_vines_east", x_offset = -depth / 6 - 0.75, z_offset = -width / 2 })
            table.insert(addprops, { name = "pig_ruins_wall_vines_east", x_offset = depth / 6 + 0.75, z_offset = -width / 2 })
            table.insert(addprops, { name = "pig_ruins_wall_vines_east", x_offset = depth / 3 - 0.75, z_offset = -width / 2 })
            table.insert(addprops, { name = "pig_ruins_wall_vines_east", x_offset = depth / 2 - 0.75, z_offset = -width / 2 })
        end
        if room.exits[RoomUtils.GetEast()] and room.exits[RoomUtils.GetEast()].vined then
            table.insert(addprops, { name = "pig_ruins_wall_vines_west", x_offset = -depth / 2 + 0.75, z_offset = width / 2 })
            table.insert(addprops, { name = "pig_ruins_wall_vines_west", x_offset = -depth / 3 - 0.75, z_offset = width / 2 })
            table.insert(addprops, { name = "pig_ruins_wall_vines_west", x_offset = -depth / 6 - 0.75, z_offset = width / 2 })
            table.insert(addprops, { name = "pig_ruins_wall_vines_west", x_offset = depth / 6 + 0.75, z_offset = width / 2 })
            table.insert(addprops, { name = "pig_ruins_wall_vines_west", x_offset = depth / 3 + 0.75, z_offset = width / 2 })
            table.insert(addprops, { name = "pig_ruins_wall_vines_west", x_offset = depth / 2 - 0.75, z_offset = width / 2 })
        end
        if roomtype == "speartraps!" then
            local speartraps = { "spottraps", "walltrap", "wavetrap", "bait" }
            if dungeondef.deepruins and numexits > 1 then
                table.insert(speartraps, "litfloor")
            end
            local random = math.random(1, #speartraps)
            --random = 4
            if speartraps[random] == "spottraps" then
                if math.random() < 0.3 then
                    addprops = spawnspeartrapset(addprops, depth, width, depth / 3, -width / 3)
                    table.insert(addprops, { name = "pig_ruins_light_beam", x_offset = depth / 3, z_offset = -width / 3 })
                elseif math.random() < 0.5 then
                    addprops = spawnspeartrapset(addprops, depth, width, 0, -width / 3)
                    table.insert(addprops, { name = "pig_ruins_light_beam", z_offset = -width / 3 })
                else
                    addprops = spawnspeartrapset(addprops, depth, width, -depth / 3, -width / 3)
                    table.insert(addprops,
                        { name = "pig_ruins_light_beam", x_offset = -depth / 3, z_offset = -width / 3 })
                end
                if math.random() < 0.3 then
                    addprops = spawnspeartrapset(addprops, depth, width, -depth / 3, width / 3)
                    table.insert(addprops,
                        { name = "pig_ruins_light_beam", x_offset = -depth / 3, z_offset = width / 3 })
                elseif math.random() < 0.5 then
                    addprops = spawnspeartrapset(addprops, depth, width, 0, width / 3)
                    table.insert(addprops,
                        { name = "pig_ruins_light_beam", z_offset = width / 3 })
                else
                    addprops = spawnspeartrapset(addprops, depth, width, depth / 3, width / 3)
                    table.insert(addprops,
                        { name = "pig_ruins_light_beam", x_offset = depth / 3, z_offset = width / 3 })
                end
                if math.random() < 0.3 then
                    addprops = spawnspeartrapset(addprops, depth, width, -depth / 3, 0)
                    table.insert(addprops,
                        { name = "pig_ruins_light_beam", x_offset = -depth / 3 })
                elseif math.random() < 0.5 then
                    addprops = spawnspeartrapset(addprops, depth, width, 0, 0)
                    table.insert(addprops,
                        { name = "pig_ruins_light_beam" })
                else
                    addprops = spawnspeartrapset(addprops, depth, width, depth / 3, 0)
                    table.insert(addprops,
                        { name = "pig_ruins_light_beam", x_offset = depth / 3 })
                end
            elseif speartraps[random] == "bait" then
                local baits = { { "goldnugget", 5 }, { "rocks", 20 }, { "flint", 20 }, { "redgem", 1 }, { "relic_1", 1 }, { "relic_2", 1 }, { "relic_3", 1 }, { "boneshard", 5 }, { "meat_dried", 5 }, }
                local offsets = { { -depth / 5, -width / 5 }, { depth / 5, -width / 5 }, { -depth / 5, width / 5 }, { depth / 5, width / 5 } }
                for i = 1, math.random(1, 3) do
                    local rand = 1
                    rand = math.random(1, #offsets)
                    local choicex = offsets[rand][1]
                    local choicez = offsets[rand][2]
                    table.remove(offsets, rand)
                    local loot = makechoice(deepcopy(baits))
                    addprops = spawnspeartrapset(addprops, depth, width, 0 + choicex, 0 + choicez, nil, true, true, 12)
                    table.insert(addprops,
                        { name = "pig_ruins_pressure_plate", x_offset = 0 + choicex, z_offset = 0 + choicez, })
                    table.insert(addprops, { name = loot, x_offset = 0 + choicex, z_offset = 0 + choicez })
                end
            elseif speartraps[random] == "walltrap" then
                local angle = 0
                local traps = 14
                local anglestep = (2 * PI) / traps
                local radius = 4
                for i = 1, traps do
                    local offset = Vector3(radius * math.cos(angle), 0, -radius * math.sin(angle))
                    table.insert(addprops, { name = "pig_ruins_spear_trap", x_offset = offset.x, z_offset = offset.z })
                    angle = angle + anglestep
                end
                angle = 0
                traps = 24
                anglestep = (2 * PI) / traps
                radius = 5
                for i = 1, traps do
                    local offset = Vector3(radius * math.cos(angle), 0, -radius * math.sin(angle))
                    table.insert(addprops, { name = "pig_ruins_spear_trap", x_offset = offset.x, z_offset = offset.z })
                    angle = angle + anglestep
                end
                table.insert(addprops, { name = "relic_1" })
                table.insert(addprops, { name = "pig_ruins_light_beam" })
            elseif speartraps[random] == "wavetrap" then
                if math.random() < 0.2 then
                    local function getrandomset()
                        local set = {}
                        local random = math.random(1, 3)
                        if random == 1 then
                            set = { "timed", "up_3", "down_6", "delay_3" }
                        elseif random == 2 then
                            set = { "timed", "up_3", "down_6", "delay_6" }
                        elseif random == 3 then
                            set = { "timed", "up_3", "down_6", "delay_9" }
                        end
                        return set
                    end
                    local function setrandomspearsets(xmod, ymod, plus)
                        local scaledist = 15
                        if plus then
                            table.insert(addprops, {
                                name = "pig_ruins_spear_trap",
                                x_offset = -depth / scaledist + xmod,
                                z_offset = ymod,
                                addtags = getrandomset()
                            })
                            table.insert(addprops, {
                                name = "pig_ruins_spear_trap",
                                x_offset = xmod,
                                z_offset = width / scaledist + ymod,
                                addtags = getrandomset()
                            })
                            table.insert(addprops, {
                                name = "pig_ruins_spear_trap",
                                x_offset = depth / scaledist + xmod,
                                z_offset = ymod,
                                addtags = getrandomset()
                            })
                            table.insert(addprops, {
                                name = "pig_ruins_spear_trap",
                                x_offset = xmod,
                                z_offset = -width / scaledist + ymod,
                                addtags = getrandomset()
                            })
                        else
                            table.insert(addprops, {
                                name = "pig_ruins_spear_trap",
                                x_offset = -depth / scaledist + xmod,
                                z_offset = -width / scaledist + ymod,
                                addtags = getrandomset()
                            })
                            table.insert(addprops, {
                                name = "pig_ruins_spear_trap",
                                x_offset = -depth / scaledist + xmod,
                                z_offset = width / scaledist + ymod,
                                addtags = getrandomset()
                            })
                            table.insert(addprops, {
                                name = "pig_ruins_spear_trap",
                                x_offset = depth / scaledist + xmod,
                                z_offset = -width / scaledist + ymod,
                                addtags = getrandomset()
                            })
                            table.insert(addprops, {
                                name = "pig_ruins_spear_trap",
                                x_offset = depth / scaledist + xmod,
                                z_offset = width / scaledist + ymod,
                                addtags = getrandomset()
                            })
                        end
                    end
                    setrandomspearsets(0, -width / 4)
                    setrandomspearsets(0, 0, true)
                    setrandomspearsets(0, width / 4)
                    setrandomspearsets(-depth / 4, -width / 4, true)
                    setrandomspearsets(-depth / 4, 0)
                    setrandomspearsets(-depth / 4, width / 4, true)
                    setrandomspearsets(depth / 4, -width / 4, true)
                    setrandomspearsets(depth / 4, 0)
                    setrandomspearsets(depth / 4, width / 4, true)
                else
                    if math.random() < 0.5 then
                        spawnspeartrapset(addprops, depth, width, 0, -width / 4, { "timed", "up_3", "down_6", "delay_3" }, true)
                        spawnspeartrapset(addprops, depth, width, 0, 0, { "timed", "up_3", "down_6", "delay_6" }, true)
                        spawnspeartrapset(addprops, depth, width, 0, width / 4, { "timed", "up_3", "down_6", "delay_9" }, true)
                        spawnspeartrapset(addprops, depth, width, -depth / 4, -width / 4,
                            { "timed", "up_3", "down_6", "delay_3" }, true)
                        spawnspeartrapset(addprops, depth, width, -depth / 4, 0, { "timed", "up_3", "down_6", "delay_6" }, true)
                        spawnspeartrapset(addprops, depth, width, -depth / 4, width / 4,
                            { "timed", "up_3", "down_6", "delay_9" }, true)
                        spawnspeartrapset(addprops, depth, width, depth / 4, -width / 4,
                            { "timed", "up_3", "down_6", "delay_3" }, true)
                        spawnspeartrapset(addprops, depth, width, depth / 4, 0, { "timed", "up_3", "down_6", "delay_6" }, true)
                        spawnspeartrapset(addprops, depth, width, depth / 4, width / 4,
                            { "timed", "up_3", "down_6", "delay_9" }, true)
                    else
                        spawnspeartrapset(addprops, depth, width, 0, -width / 4, { "timed", "up_3", "down_6", "delay_6" }, true)
                        spawnspeartrapset(addprops, depth, width, 0, 0, { "timed", "up_3", "down_6", "delay_6" }, true)
                        spawnspeartrapset(addprops, depth, width, 0, width / 4, { "timed", "up_3", "down_6", "delay_6" }, true)
                        spawnspeartrapset(addprops, depth, width, -depth / 4, -width / 4, { "timed", "up_3", "down_6", "delay_9" }, true)
                        spawnspeartrapset(addprops, depth, width, -depth / 4, 0, { "timed", "up_3", "down_6", "delay_9" }, true)
                        spawnspeartrapset(addprops, depth, width, -depth / 4, width / 4, { "timed", "up_3", "down_6", "delay_9" }, true)
                        spawnspeartrapset(addprops, depth, width, depth / 4, -width / 4, { "timed", "up_3", "down_6", "delay_3" }, true)
                        spawnspeartrapset(addprops, depth, width, depth / 4, 0, { "timed", "up_3", "down_6", "delay_3" }, true)
                        spawnspeartrapset(addprops, depth, width, depth / 4, width / 4, { "timed", "up_3", "down_6", "delay_3" }, true)
                    end
                end
            elseif speartraps[random] == "litfloor" then
                addprops = spawnspeartrapset(addprops, depth, width, depth / 2.7, -width / 2.7)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = depth / 2.5, z_offset = -width / 2.5 })
                addprops = spawnspeartrapset(addprops, depth, width, depth / 6, -width / 2.7, nil, nil, nil, nil, true)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = depth / 6, z_offset = -width / 2.5 })
                --        addprops = spawnspeartrapset(addprops, depth, width, 0, -width/2.5)
                --      table.insert(addprops, { name = "pig_ruins_light_beam",  z_offset =  -width/2.5, addtags={"localtrap"}} )
                addprops = spawnspeartrapset(addprops, depth, width, -depth / 6, -width / 2.7, nil, nil, nil, nil, true)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = -depth / 6, z_offset = -width / 2.5 })
                addprops = spawnspeartrapset(addprops, depth, width, -depth / 2.7, -width / 2.7)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = -depth / 2.5, z_offset = -width / 2.5 })
                addprops = spawnspeartrapset(addprops, depth, width, depth / 2.5, -width / 6, nil, nil, nil, nil, true)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = depth / 2.5, z_offset = -width / 6 })
                addprops = spawnspeartrapset(addprops, depth, width, depth / 6, -width / 6)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = depth / 6, z_offset = -width / 6 })
                addprops = spawnspeartrapset(addprops, depth, width, 0, -width / 6, nil, nil, nil, nil, true)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", z_offset = -width / 6 })
                addprops = spawnspeartrapset(addprops, depth, width, -depth / 6, -width / 6)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = -depth / 6, z_offset = -width / 6 })
                addprops = spawnspeartrapset(addprops, depth, width, -depth / 2.5, -width / 6, nil, nil, nil, nil, true)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = -depth / 2.5, z_offset = -width / 6 })
                --      addprops = spawnspeartrapset(addprops, depth, width, depth/2.5, 0)
                --      table.insert(addprops, { name = "pig_ruins_light_beam", x_offset = depth/2.5, z_offset =  0, addtags={"localtrap"}} )
                addprops = spawnspeartrapset(addprops, depth, width, depth / 6, 0, nil, nil, nil, nil, true)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = depth / 6 })
                addprops = spawnspeartrapset(addprops, depth, width, 0, 0)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam" })
                addprops = spawnspeartrapset(addprops, depth, width, -depth / 6, 0, nil, nil, nil, nil, true)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = -depth / 6 })
                --      addprops = spawnspeartrapset(addprops, depth, width, -depth/2.5, 0)
                --      table.insert(addprops, { name = "pig_ruins_light_beam", x_offset = -depth/2.5,  addtags={"localtrap"}} )
                addprops = spawnspeartrapset(addprops, depth, width, depth / 2.5, width / 6, nil, nil, nil, nil, true)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = depth / 2.5, z_offset = width / 6 })
                addprops = spawnspeartrapset(addprops, depth, width, depth / 6, width / 6)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = depth / 6, z_offset = width / 6 })
                addprops = spawnspeartrapset(addprops, depth, width, 0, width / 6, nil, nil, nil, nil, true)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", z_offset = width / 6 })
                addprops = spawnspeartrapset(addprops, depth, width, -depth / 6, width / 6)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = -depth / 6, z_offset = width / 6 })
                addprops = spawnspeartrapset(addprops, depth, width, -depth / 2.5, width / 6, nil, nil, nil, nil, true)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = -depth / 2.5, z_offset = width / 6 })
                addprops = spawnspeartrapset(addprops, depth, width, depth / 2.7, width / 2.7)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = depth / 2.5, z_offset = width / 2.5 })
                addprops = spawnspeartrapset(addprops, depth, width, depth / 6, width / 2.7, nil, nil, nil, nil, true)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = depth / 6, z_offset = width / 2.5 })
                --        addprops = spawnspeartrapset(addprops, depth, width, 0, width/2.5)
                --      table.insert(addprops, { name = "pig_ruins_light_beam",  z_offset = width/2.5, addtags={"localtrap"}} )
                addprops = spawnspeartrapset(addprops, depth, width, -depth / 6, width / 2.7, nil, nil, nil, nil, true)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = -depth / 6, z_offset = width / 2.5 })
                addprops = spawnspeartrapset(addprops, depth, width, -depth / 2.7, width / 2.7)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = -depth / 2.5, z_offset = width / 2.5 })
            end
        elseif roomtype == "darts!" then
            if advancedtraps and math.random() < 0.3 then
                local x = depth / 8
                if math.random() < 0.5 then
                    x = -x
                end
                local z = width / 8
                if math.random() < 0.5 then
                    z = -z
                end
                table.insert(addprops, { name = "pig_ruins_dart_statue", x_offset = x, z_offset = z })
            else
                table.insert(addprops, {
                    name = "pig_ruins_pigman_relief_dart" .. math.random(4) .. room.color, x_offset = -depth / 2, z_offset = -width / 3 })
                if northexitopen then
                    table.insert(addprops, { name = "pig_ruins_pigman_relief_dart" .. math.random(4) .. room.color, x_offset = -depth / 2 })
                end
                table.insert(addprops, {
                    name = "pig_ruins_pigman_relief_dart" .. math.random(4) .. room.color, x_offset = -depth / 2, z_offset = width / 3 })
                table.insert(addprops, {
                    name = "pig_ruins_pigman_relief_leftside_dart" .. room.color, x_offset = -depth / 4 + (math.random() * 1 - 0.5), z_offset = -width / 2 })
                if westexitopen then
                    table.insert(addprops, {
                        name = "pig_ruins_pigman_relief_leftside_dart" .. room.color, x_offset = 0 + (math.random() * 1 - 0.5), z_offset = -width / 2 })
                end
                table.insert(addprops, {
                    name = "pig_ruins_pigman_relief_leftside_dart" .. room.color,
                    x_offset = depth / 4 + (math.random() * 1 - 0.5),
                    z_offset = -width / 2
                })
                table.insert(addprops, {
                    name = "pig_ruins_pigman_relief_rightside_dart" .. room.color,
                    x_offset = -depth / 4 + (math.random() * 1 - 0.5),
                    z_offset = width / 2
                })
                if eastexitopen then
                    table.insert(addprops, {
                        name = "pig_ruins_pigman_relief_rightside_dart" .. room.color,
                        x_offset = 0 + (math.random() * 1 - 0.5),
                        z_offset = width / 2
                    })
                end
                table.insert(addprops, {
                    name = "pig_ruins_pigman_relief_rightside_dart" .. room.color,
                    x_offset = depth / 4 + (math.random() * 1 - 0.5),
                    z_offset = width / 2
                })
            end
            -- if the treasure room wants dart traps, then the plates get turned off.
            if not nopressureplates then
                table.insert(addprops, {
                    name = "pig_ruins_pressure_plate",
                    x_offset = -depth / 6 * 2 + (math.random() * 2 - 1),
                    z_offset = 0 + (math.random() * 2 - 1),

                })
                table.insert(addprops, {
                    name = "pig_ruins_pressure_plate",
                    x_offset = 0 + (math.random(2) - 1),
                    z_offset = 0 + (math.random() * 2 - 1),

                })
                if southexitopen then
                    table.insert(addprops, {
                        name = "pig_ruins_pressure_plate",
                        x_offset = depth / 6 * 2 + (math.random() * 2 - 1),
                        z_offset = 0 + (math.random() * 2 - 1),

                    })
                end
                table.insert(addprops, {
                    name = "pig_ruins_pressure_plate",
                    x_offset = -depth / 6 * 2 + (math.random() * 2 - 1),
                    z_offset = -width / 6 * 2 + (math.random() * 2 - 1),

                })
                table.insert(addprops, {
                    name = "pig_ruins_pressure_plate",
                    x_offset = (math.random() * 2 - 1),
                    z_offset = -width / 6 * 2 + (math.random() * 2 - 1),

                })
                table.insert(addprops, {
                    name = "pig_ruins_pressure_plate",
                    x_offset = -depth / 6 * 2 + (math.random() * 2 - 1),
                    z_offset = width / 6 * 2 + (math.random() * 2 - 1),

                })
                table.insert(addprops, {
                    name = "pig_ruins_pressure_plate",
                    x_offset = depth / 6 * 2 + (math.random() * 2 - 1),
                    z_offset = -width / 6 * 2 + (math.random() * 2 - 1),

                })
                table.insert(addprops, {
                    name = "pig_ruins_pressure_plate",
                    x_offset = (math.random() * 2 - 1),
                    z_offset = width / 6 * 2 + (math.random() * 2 - 1),

                })
                table.insert(addprops, {
                    name = "pig_ruins_pressure_plate",
                    x_offset = depth / 6 * 2 + (math.random() * 2 - 1),
                    z_offset = width / 6 * 2 + (math.random() * 2 - 1),

                })
            end
        else
            local wallrelief = math.random()
            if wallrelief < 0.6 and roomtype ~= "lightfires" then
                if math.random() < 0.8 then
                    table.insert(addprops, {
                        name = "deco_ruins_pigman_relief" .. math.random(3) .. room.color,
                        x_offset = -depth / 2,
                        z_offset = -width / 6 * 2,
                    })
                else
                    table.insert(addprops, {
                        name = "deco_ruins_crack_roots" .. math.random(4),
                        x_offset = -depth / 2,
                        z_offset = -width / 6 * 2,
                    })
                end
                if northexitopen then
                    if math.random() < 0.8 then
                        if math.random() < 0.1 then
                            table.insert(addprops, {
                                name = "deco_ruins_pigqueen_relief" .. room.color,
                                x_offset = -depth / 2,
                                z_offset = -width / 18,
                            })
                            table.insert(addprops, {
                                name = "deco_ruins_pigking_relief" .. room.color,
                                x_offset = -depth / 2,
                                z_offset = width / 18,
                            })
                        else
                            table.insert(addprops, {
                                name = "deco_ruins_pigman_relief" .. math.random(3) .. room.color,
                                x_offset = -depth / 2,
                            })
                        end
                    else
                        table.insert(addprops,
                            { name = "deco_ruins_crack_roots" .. math.random(4), x_offset = -depth / 2, })
                    end
                end
                if math.random() < 0.8 then
                    table.insert(addprops, {
                        name = "deco_ruins_pigman_relief" .. math.random(3) .. room.color,
                        x_offset = -depth / 2,
                        z_offset = width / 6 * 2,
                    })
                else
                    table.insert(addprops, {
                        name = "deco_ruins_crack_roots" .. math.random(4),
                        x_offset = -depth / 2,
                        z_offset = width / 6 * 2,
                    })
                end
            else
                if math.random() < 0.5 or roomtype == "lightfires" then
                    local tags = nil
                    if roomtype == "lightfires" then
                        tags = "something"
                        if northexitopen then
                            table.insert(addprops, { name = "deco_ruins_writing1", x_offset = -depth / 2, })
                            table.insert(addprops, {
                                name = "pig_ruins_torch_wall" .. room.color,
                                x_offset = -depth / 2,
                                z_offset = -width / 6 * 2,

                            })
                        else
                            table.insert(addprops,
                                { name = "deco_ruins_writing1", x_offset = -depth / 2, z_offset = -width / 6 * 2, })
                        end
                        table.insert(addprops, {
                            name = "pig_ruins_torch_wall" .. room.color,
                            x_offset = -depth / 2,
                            z_offset = width / 6 * 2,
                        })
                    else
                        table.insert(addprops, {
                            name = "pig_ruins_torch_wall" .. room.color,
                            x_offset = -depth / 2,
                            z_offset = -width / 6 * 2,
                        })
                        if northexitopen then
                            table.insert(addprops, { name = "pig_ruins_torch_wall" .. room.color, x_offset = -depth / 2, })
                        end
                        table.insert(addprops, {
                            name = "pig_ruins_torch_wall" .. room.color,
                            x_offset = -depth / 2,
                            z_offset = width / 6 * 2,
                        })
                    end
                    table.insert(addprops, {
                        name = "pig_ruins_torch_sidewall" .. room.color,
                        x_offset = -depth / 3 - 0.5,
                        z_offset = -width / 2,
                    })
                    if westexitopen then
                        table.insert(addprops, { name = "pig_ruins_torch_sidewall" .. room.color, x_offset = 0 - 0.5, z_offset = -width / 2, })
                    end
                    table.insert(addprops, {
                        name = "pig_ruins_torch_sidewall" .. room.color,
                        x_offset = depth / 3 - 0.5,
                        z_offset = -width / 2,
                    })
                    table.insert(addprops, {
                        name = "pig_ruins_torch_sidewall" .. room.color,
                        x_offset = -depth / 3 - 0.5,
                        z_offset = width / 2,
                        scale = { -1, 1 }
                    })
                    if eastexitopen then
                        table.insert(addprops, { name = "pig_ruins_torch_sidewall" .. room.color, x_offset = 0 - 0.5, z_offset = width / 2, scale = { -1, 1 } })
                    end
                    table.insert(addprops, {
                        name = "pig_ruins_torch_sidewall" .. room.color,
                        x_offset = depth / 3 - 0.5,
                        z_offset = width / 2,
                        scale = { -1, 1 }
                    })
                end
            end
        end
        local hangingroots = math.random()
        if hangingroots < 0.3 and not roomtype == "lightfires" then
            local function jostle()
                return math.random() - 0.5
            end
            local function flip()
                local test = true
                if math.random() < 0.5 then
                    test = false
                end
                return test
            end
            local roots_left = {
                { name = "deco_ruins_roots" .. math.random(3), x_offset = -depth / 2, z_offset = -width / 6 - width / 12 + jostle(), flip = flip() }, { name = "deco_ruins_roots" .. math.random(3), x_offset = -depth / 2, z_offset = -width / 6 - width / 12 * 2 + jostle(), flip = flip() }, { name = "deco_ruins_roots" .. math.random(3), x_offset = -depth / 2, z_offset = -width / 6 - width / 12 * 3 + jostle(), flip = flip() }
            }
            local num = math.random(#roots_left)
            for i = 1, num do
                local choice = math.random(#roots_left)
                table.insert(addprops, roots_left[choice])
                table.remove(roots_left, choice)
            end
            if northexitopen then
                local roots_center = {
                    { name = "deco_ruins_roots" .. math.random(3), x_offset = -depth / 2, z_offset = 0 + width / 12 + jostle(), flip = flip() }, { name = "deco_ruins_roots" .. math.random(3), x_offset = -depth / 2, z_offset = 0 + jostle(), flip = flip() }, { name = "deco_ruins_roots" .. math.random(3), x_offset = -depth / 2, z_offset = 0 - width / 12 + jostle(), flip = flip() }
                }
                local num = math.random(#roots_center)
                for i = 1, num do
                    local choice = math.random(#roots_center)
                    table.insert(addprops, roots_center[choice])
                    table.remove(roots_center, choice)
                end
            end
            local roots_right = {
                { name = "deco_ruins_roots" .. math.random(3), x_offset = -depth / 2, z_offset = width / 6 + width / 12 + jostle(), flip = flip() }, { name = "deco_ruins_roots" .. math.random(3), x_offset = -depth / 2, z_offset = width / 6 + width / 12 * 2 + jostle(), flip = flip() }, { name = "deco_ruins_roots" .. math.random(3), x_offset = -depth / 2, z_offset = width / 6 + width / 12 * 3 + jostle(), flip = flip() }
            }
            local num = math.random(#roots_right)
            for i = 1, num do
                local choice = math.random(#roots_right)
                table.insert(addprops, roots_right[choice])
                table.remove(roots_right, choice)
            end
        end
        if math.random() < 0.1 and roomtype ~= "lightfires" and roomtype ~= "speartraps!" then
            if math.random() < 0.5 then
                table.insert(addprops,
                    { name = "deco_ruins_corner_tree", x_offset = -depth / 2, z_offset = width / 2, scale = { -1, 1 } })
            else
                table.insert(addprops,
                    { name = "deco_ruins_corner_tree", x_offset = -depth / 2, z_offset = -width / 2, })
            end
        end
        --RANDOM POTS
        if roomtype ~= "secret" and roomtype ~= "aporkalypse" and math.random() < 0.25 then
            for i = 1, math.random(2) + 1 do
                local setwidth, setdepth = getspawnlocation(0.8, 0.8)
                if setwidth and setdepth then
                    table.insert(addprops, { name = "smashingpot", x_offset = setdepth, z_offset = setwidth })
                end
            end
        end

        -- 地板和墙壁
        if room.color == "_blue" then
            table.insert(addprops, { name = "interior_floor_ground_ruins_slab_blue" })
            table.insert(addprops, { name = "interior_wall_pig_ruins_blue" })
        else
            table.insert(addprops, { name = "interior_floor_ground_ruins_slab" })
            table.insert(addprops, { name = "interior_wall_pig_ruins" })
        end

        -- 门
        for dir, exit in pairs(room.exits) do
            local opposite_dir = RoomUtils.GetOppositeFromDirection(dir)
            local doorprop = GetDoorProp(room, dir, exit, width, depth)

            -- 把隔壁门也一起生成
            local opposite_room = rooms[exit.target_room]
            local opposite_exit = opposite_room.exits[opposite_dir]
            local doorprop2 = GetDoorProp(opposite_room, opposite_dir, opposite_exit, width, depth)
            opposite_room.exits[opposite_dir] = nil --不再处理

            doorprop.key = inc
            inc = inc + 1
            doorprop2.key = inc
            inc = inc + 1
            doorprop.target_door = doorprop2.key
            doorprop2.target_door = doorprop.key
            -- print("房间" .. id .. "生成" .. dir.label .. "门", doorprop.key, doorprop2.key)
            table.insert(addprops, doorprop)
            opposite_room.addprops = opposite_room.addprops or {}
            table.insert(opposite_room.addprops, doorprop2)
        end
    end

    return rooms
end


return mazemaker
