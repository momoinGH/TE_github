local RoomUtils = require("tropical_utils/room_utils")
local MazeBuilder = require("prefabs/tro_maze_builder")

-- 房间里怪物
local room_creatures = {
    { bat = 2 },
    { bat = 3 },
    { scorpion = 2 },
    { scorpion = 1 },
}

local function GetDoorProp(room, dir, exit)
    local name, build
    if room.color == "_blue" and not exit.secret then
        build = "pig_ruins_door_blue" --蓝色的门
    end
    if exit.secret then
        --隐藏门
        name = "wallcrack_ruins"
    elseif exit.vined then
        --藤蔓门
        name = "prop_door"
    else
        name = "prop_door"
    end

    return {
        name = name,
        build = build,
        anim = dir.label,
        vined = exit.vined,
    }
end

-- 长矛陷阱
local function spawnspeartrapset(builder, idx, depth, width, offsetx, offsetz, tags, nocenter, full, scale, pluspattern)
    local scaledist = scale or 15
    if pluspattern then
        builder:AddRoomProp(idx, { name = "pig_ruins_spear_trap", x_offset = -depth / scaledist + offsetx, z_offset = 0 + offsetz, addtags = tags })
        builder:AddRoomProp(idx, { name = "pig_ruins_spear_trap", x_offset = 0 + offsetx, z_offset = -width / scaledist + offsetz, addtags = tags })
        builder:AddRoomProp(idx, { name = "pig_ruins_spear_trap", x_offset = 0 + offsetx, z_offset = width / scaledist + offsetz, addtags = tags })
        builder:AddRoomProp(idx, { name = "pig_ruins_spear_trap", x_offset = depth / scaledist - offsetx, z_offset = 0 + offsetz, addtags = tags })
    else
        builder:AddRoomProp(idx, { name = "pig_ruins_spear_trap", x_offset = -depth / scaledist + offsetx, z_offset = -width / scaledist + offsetz, addtags = tags })
        builder:AddRoomProp(idx, { name = "pig_ruins_spear_trap", x_offset = -depth / scaledist + offsetx, z_offset = width / scaledist + offsetz, addtags = tags })
        if not nocenter then
            builder:AddRoomProp(idx, { name = "pig_ruins_spear_trap", x_offset = 0 + offsetx, z_offset = 0 + offsetz, addtags = tags })
        end
        builder:AddRoomProp(idx, { name = "pig_ruins_spear_trap", x_offset = depth / scaledist + offsetx, z_offset = -width / scaledist + offsetz, addtags = tags })
        builder:AddRoomProp(idx, { name = "pig_ruins_spear_trap", x_offset = depth / scaledist + offsetx, z_offset = width / scaledist + offsetz, addtags = tags })
        if full then
            builder:AddRoomProp(idx, { name = "pig_ruins_spear_trap", x_offset = -depth / scaledist + offsetx, z_offset = 0 + offsetz, addtags = tags })
            builder:AddRoomProp(idx, { name = "pig_ruins_spear_trap", x_offset = depth / scaledist + offsetx, z_offset = 0 + offsetz, addtags = tags })
            builder:AddRoomProp(idx, { name = "pig_ruins_spear_trap", x_offset = 0 + offsetx, z_offset = -width / scaledist + offsetz, addtags = tags })
            builder:AddRoomProp(idx, { name = "pig_ruins_spear_trap", x_offset = 0 + offsetx, z_offset = width / scaledist + offsetz, addtags = tags })
        end
    end
end

-- 雕像雕像
local function addgoldstatue(builder, idx, x, z)
    return builder:AddRoomProp(idx, { name = math.random() < 0.5 and "pig_ruins_pig" or "pig_ruins_ant", x_offset = x, z_offset = z })
end

-- 添加文物
local function addrelicstatue(builder, idx, x, z, tags)
    return builder:AddRoomProp(idx, { name = math.random() < 0.5 and "pig_ruins_idol" or "pig_ruins_plaque", x_offset = x, z_offset = z, addtags = tags })
end

-- 添加隐藏房间
local function CreateSecretRoom(builder, secret_room_count, place_clock)
    -- grid[x][y] 表示坐标{x,y}的空间是可用的，可用来构建隐藏房间，值为相邻房间数据
    local grid = {}
    local function CheckAdjacent(room, dir)
        local x = room.x + dir.x
        local y = room.y + dir.y
        if builder:CheckFreeGridPos(x, y) then
            grid[x] = grid[x] or {}
            grid[x][y] = grid[x][y] or { rooms = {}, dirs = {} }
            table.insert(grid[x][y].rooms, room)
            table.insert(grid[x][y].dirs, dir)
        end
    end

    -- 相邻房间最多的房间坐标
    local function GetMax()
        local max_x = 0
        local max_y = 0
        local max = 0
        for x, row in pairs(grid) do
            for y, data in pairs(row) do
                if #data.rooms > max then
                    max = #data.rooms
                    max_x = x
                    max_y = y
                end
            end
        end
        if max > 0 then
            return max_x, max_y
        end
        return nil, nil
    end

    -- 隐藏房间
    local function PopulateSecretRoom(x, y)
        local secret_room = builder:AddRoom(x, y)
        secret_room.secretroom = true

        local grid_rooms = grid[x][y].rooms
        local grid_dirs = grid[x][y].dirs
        if place_clock then
            -- 可以放置日晷
            place_clock = false
            secret_room.aporkalypseclock = true
            while #grid_rooms > 1 do
                local num = math.random(1, #grid_rooms)
                table.remove(grid_rooms, num)
                table.remove(grid_dirs, num)
            end
        end
        -- 将秘密房间和相邻房间相连通
        for i, grid_room in ipairs(grid_rooms) do
            local op_dir = RoomUtils.DIR_OPPOSITE[grid_dirs[i].label]
            builder:SetRoomExit(grid_room.idx, grid_dirs[i].label, secret_room.idx)
            secret_room.exits[op_dir].secret = not secret_room.aporkalypseclock --不是日晷的房间
            grid_room.exits[grid_dirs[i]].secret = true
        end
        grid[x][y] = nil
        return secret_room
    end

    for i, room in ipairs(builder.rooms) do
        -- 通往秘密房间的门只会出现在上左右
        local north = RoomUtils.DIR.north
        local west = RoomUtils.DIR.west
        local east = RoomUtils.DIR.east
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

    for i = 1, secret_room_count do  --只是尝试次数
        local x, y = GetMax()
        if x == nil or y == nil then --没有空间生成隐藏房间
            print("COULDN'T FIND SUITABLE CANDIDATES FOR THE SECRET ROOM.")
        else
            PopulateSecretRoom(x, y)
        end
    end
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

    local DIR_OPPOSITE = RoomUtils.DIR_OPPOSITE
    local builder = MazeBuilder(TUNING.ROOM_MEDIUM_WIDTH, TUNING.ROOM_MEDIUM_DEPTH)
    -- 这里默认第一个房间是出口1，房间位置为0,0
    local start_room = builder:AddRoom(0, 0, nil, { RoomUtils.DIR.north })
    builder:SetEntrance(start_room.idx, 1, "north")

    builder:SetPropsRadius({
        deco_ruins_fountain = 4
    })

    -- 构建足够数量的空房间
    builder:CreateRandomRooms(dungeondef.rooms)

    -- 门生长藤蔓的概率
    if dungeondef.doorvines then
        for _, room in ipairs(builder.rooms) do
            for dir, data in pairs(room.exits) do
                if math.random() < dungeondef.doorvines then --藤蔓
                    data.vined = true
                    builder.rooms[data.target_room].exits[DIR_OPPOSITE[dir.label]].vined = true
                end
            end
        end
    end

    -- 第二个出口
    if not dungeondef.nosecondexit then
        builder:SelectEntranceRoom(2, "north")
    end


    -- 查找只有一个门的房间，用来生成一些乱七八糟的东西
    local choices = {}
    for i, room in ipairs(builder.rooms) do
        if builder:GetRoomExitCount(i) == 1 then
            table.insert(choices, room)
        end
    end
    local advancedtraps = false
    if dungeondef.name == "runis_1" then
        choices[math.random(#choices)].relictruffle = true
    elseif dungeondef.name == "runis_2" then
        choices[math.random(#choices)].relicsow = true
    elseif dungeondef.name == "runis_3" then
        choices[math.random(#choices)].pheromonestone = true
    elseif dungeondef.name == "runis_5" then
        advancedtraps = true
        choices[math.random(#choices)].endswell = true
    else
        choices[math.random(#choices)].treasure = true
    end

    CreateSecretRoom(builder, dungeondef.secretrooms or 0, dungeondef.name == "runis_5")

    local width = TUNING.ROOM_MEDIUM_WIDTH
    local depth = TUNING.ROOM_MEDIUM_DEPTH
    local door_key_inc = 1
    for idx, room in ipairs(builder.rooms) do
        local fountain = false


        room.color = ""
        if dungeondef.deepruins and math.random() < 0.3 then
            room.color = "_blue"
        end

        local nopressureplates = false

        -- all rooms with 1 exit get creatures, randomly add creatures otherwise；所有只有一个出口的房间都会出现怪物，其他房间随机出现怪物。
        if builder:GetRoomExitCount(idx) == 1 or math.random() < 0.3 then
            for creature, count in pairs(room_creatures[math.random(#room_creatures)]) do
                for i = 1, count do
                    builder:AddRomPropAtInside(idx, creature)
                end
            end
        end

        -- 出口
        if room.entrance1 then
            builder:AddRoomProp(idx, { name = "prop_door", key = "entrance1", x_offset = -depth / 2 })
        end
        if room.entrance2 then
            builder:AddRoomProp(idx, { name = "prop_door", key = "entrance2", x_offset = -depth / 2 })
        end

        -- 终焉之井
        if room.endswell then
            builder:AddRoomProp(idx, "deco_ruins_endswell")
        end
        -- 信息素石
        if room.pheromonestone then
            builder:AddRoomProp(idx, "pheromonestone")
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
            if builder:GetRoomExitCount(idx) > 1 and not room.sercretroom then
                table.insert(roomtypes, "doortrap")
                table.insert(roomtypes, "doortrap")
            end
            roomtype = roomtypes[math.random(1, #roomtypes)]
        end

        -- 有概率生成假的隐藏门
        local northexitopen = not room.exits[RoomUtils.DIR.north] and not room.entrance2 and not room.entrance1
        local westexitopen = not room.exits[RoomUtils.DIR.west]
        local southexitopen = not room.exits[RoomUtils.DIR.south]
        local eastexitopen = not room.exits[RoomUtils.DIR.east]
        local init = function(inst)
            print("生成假门", inst)
        end
        if northexitopen and math.random() < 0.10 then
            northexitopen = false
            builder:AddRoomProp(idx, { name = "wallcrack_ruins", x_offset = -depth / 2, anim = "north", init = init })
        end
        if westexitopen and math.random() < 0.10 then
            westexitopen = false
            builder:AddRoomProp(idx, { name = "wallcrack_ruins", z_offset = -width / 2, anim = "west", init = init })
        end
        if eastexitopen and math.random() < 0.10 then
            eastexitopen = false
            builder:AddRoomProp(idx, { name = "wallcrack_ruins", z_offset = width / 2, anim = "east", init = init })
        end

        -- 添加柱子
        local function addroomcolumn(x, z)
            local name = math.random() < 0.2 and "deco_ruins_beam_room_broken" or "deco_ruins_beam_room"
            builder:AddRoomProp(idx, { name = name .. room.color, x_offset = x, z_offset = z })
        end
        local function getspawnlocation(widthrange, depthrange)
            local setwidth = width * widthrange * math.random() - width * widthrange / 2
            local setdepth = depth * depthrange * math.random() - depth * depthrange / 2
            if not fountain or (math.abs(setwidth * setwidth) + math.abs(setdepth * setdepth) >= 4 * 4) then --过滤到许愿井的位置
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
                    builder:AddRoomProp(idx, "deco_ruins_fountain") --许愿井
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
            builder:AddRomPropAtInside(idx, "snake_amphibious", math.random(3, 6))
        end
        -- 瓦罐
        if roomtype == "storeroom" then
            builder:AddRomPropAtInside(idx, "smashingpot", math.random(6) + 6)
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
                builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = -depth / 2 + 3 + (math.random() * 2 - 1), z_offset = (math.random() * 2 - 1) })
                builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = depth / 2 - 3 + (math.random() * 2 - 1), z_offset = (math.random() * 2 - 1) })
                builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = (math.random() * 2 - 1), z_offset = (math.random() * 2 - 1) })
                builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = (math.random() * 2 - 1), z_offset = width / 2 - 3 + (math.random() * 2 - 1) })
                builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = (math.random() * 2 - 1), z_offset = -width / 2 + 3 + (math.random() * 2 - 1) })
            elseif setups[random] == "hor" then
                builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate" })
                for i = 1, 3 do
                    builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", z_offset = i * 1.5 })
                    builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", z_offset = -i * 1.5 })
                end
            elseif setups[random] == "longvert" then
                local dir = {}
                if eastexitopen then
                    table.insert(dir, 1)
                end
                if westexitopen then
                    table.insert(dir, -1)
                end
                dir = dir[math.random(1, #dir)]
                builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = depth / 4.5 * dir })
                for i = 1, 7 do
                    builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = depth / 4.5 * dir, z_offset = i * 1.5 })
                    builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = depth / 4.5 * dir, z_offset = -i * 1.5 })
                end
            elseif setups[random] == "vert" then
                builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate" })
                for i = 1, 3 do
                    builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = i * 1.5 })
                    builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = -i * 1.5 })
                end
            elseif setups[random] == "longhor" then
                local dir = {}
                if northexitopen then
                    table.insert(dir, -1)
                end
                if southexitopen then
                    table.insert(dir, 1)
                end
                dir = dir[math.random(1, #dir)]
                builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", z_offset = width / 4.5 * dir })
                for i = 1, 5 do
                    builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = i * 1.5, z_offset = width / 4.5 * dir })
                    builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = -i * 1.5, z_offset = width / 4.5 * dir })
                end
            end
        end

        -- 宝物
        if roomtype == "treasure" then
            if treasuretype and treasuretype == "aporkalypse" then
                builder:AddRoomProp(idx, { name = "aporkalypse_clock", x_offset = -1 }) --日晷
                fountain = true
            elseif treasuretype and treasuretype == "secret" then
                local items = { redgem = 30, bluegem = 20, relic_1 = 10, relic_2 = 10, relic_3 = 10, nightsword = 1, ruins_bat = 1, ruinshat = 1, orangestaff = 1, armorruins = 1, multitool_axe_pickaxe = 1 }
                if not dungeondef.smallsecret then
                    builder:AddRoomProp(idx, { name = "shelves_ruins", x_offset = -depth / 7, z_offset = -width / 7, shelfitems = { { 1, weighted_random_choice(items) } } })
                    builder:AddRoomProp(idx, { name = "shelves_ruins", x_offset = depth / 7, z_offset = -width / 7, shelfitems = { { 1, weighted_random_choice(items) } } })
                    builder:AddRoomProp(idx, { name = "shelves_ruins", x_offset = -depth / 7, z_offset = width / 7, shelfitems = { { 1, weighted_random_choice(items) } } })
                    builder:AddRoomProp(idx, { name = "shelves_ruins", x_offset = depth / 7, z_offset = width / 7, shelfitems = { { 1, weighted_random_choice(items) } } })
                else
                    builder:AddRoomProp(idx, { name = "shelves_ruins", z_offset = -width / 7, shelfitems = { { 1, weighted_random_choice(items) } } })
                    builder:AddRoomProp(idx, { name = "shelves_ruins", z_offset = width / 7, shelfitems = { { 1, weighted_random_choice(items) } } })
                end
            elseif treasuretype and treasuretype == "rarerelic" then
                -- 文物
                room.color = "_blue"
                local relic = room.relicsow and "pig_ruins_sow" or "pig_ruins_truffle"
                if not northexitopen and southexitopen then
                    builder:AddRoomProp(idx, { name = relic, x_offset = depth / 2 - 2, })
                    builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = depth / 2 - 2 })
                elseif not southexitopen and northexitopen then
                    builder:AddRoomProp(idx, { name = relic, x_offset = -depth / 2 + 2, })
                    builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = -depth / 2 + 2 })
                elseif not westexitopen and eastexitopen then
                    builder:AddRoomProp(idx, { name = relic, z_offset = width / 2 - 2, })
                    builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", z_offset = width / 2 - 2 })
                elseif not eastexitopen and westexitopen then
                    builder:AddRoomProp(idx, { name = relic, z_offset = -width / 2 + 2, })
                    builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", z_offset = -width / 2 + 2 })
                else
                    -- Place it in the middle of the room as a fallback.
                    builder:AddRoomProp(idx, { name = relic, })
                    builder:AddRoomProp(idx, { name = "pig_ruins_light_beam" })
                end
                for i = 0, 3 do
                    for t = 0, 3 do
                        local x = -depth / 2 + (depth / 4 * i)
                        local z = -width / 2 + (width / 4 * i)
                        if math.random() < 0.6 then
                            builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = x, z_offset = z })
                        end
                    end
                end
                local function add4plates(x, y)
                    if math.random() < 0.5 then
                        local xoffset = x + depth / 16
                        local yoffset = y - width / 16
                        if math.abs(xoffset) < depth / 2 and math.abs(yoffset) < width / 2 then
                            builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = xoffset, z_offset = yoffset, })
                        end
                    end
                    if math.random() < 0.5 then
                        local xoffset = x - depth / 16
                        local yoffset = y - width / 16
                        if math.abs(xoffset) < depth / 2 and math.abs(yoffset) < width / 2 then
                            builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = xoffset, z_offset = yoffset, })
                        end
                    end
                    if math.random() < 0.5 then
                        local xoffset = x - depth / 16
                        local yoffset = y + width / 16
                        if math.abs(xoffset) < depth / 2 and math.abs(yoffset) < width / 2 then
                            builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = xoffset, z_offset = yoffset, })
                        end
                    end
                    if math.random() < 0.5 then
                        local xoffset = x + depth / 16
                        local yoffset = y + width / 16
                        if math.abs(xoffset) < depth / 2 and math.abs(yoffset) < width / 2 then
                            builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = xoffset, z_offset = yoffset, })
                        end
                    end
                end
                if math.random() < 0.5 then
                    builder:AddRoomProp(idx, { name = "pig_ruins_dart_statue", x_offset = depth / 4, z_offset = width / 4 })
                    builder:AddRoomProp(idx, { name = "pig_ruins_dart_statue", x_offset = -depth / 4, z_offset = -width / 4 })
                else
                    builder:AddRoomProp(idx, { name = "pig_ruins_dart_statue", x_offset = -depth / 4, z_offset = width / 4 })
                    builder:AddRoomProp(idx, { name = "pig_ruins_dart_statue", x_offset = depth / 4, z_offset = -width / 4 })
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
                    addgoldstatue(builder, idx, -depth / 3, -width / 3)
                    addgoldstatue(builder, idx, depth / 3, width / 3)
                    addrelicstatue(builder, idx, 0, 0)
                    addgoldstatue(builder, idx, depth / 3, -width / 3)
                    addgoldstatue(builder, idx, -depth / 3, width / 3)
                elseif setups[random] == "spears n relics" then
                    addrelicstatue(builder, idx, 0, -width / 4)
                    addrelicstatue(builder, idx, 0, 0)
                    addrelicstatue(builder, idx, 0, width / 4)
                    spawnspeartrapset(builder, idx, depth, width, 0, -width / 4, nil, true, true, 12)
                    builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", z_offset = -width / 4 })
                    spawnspeartrapset(builder, idx, depth, width, 0, 0, nil, true, true, 12)
                    builder:AddRoomProp(idx, { name = "pig_ruins_light_beam" })
                    spawnspeartrapset(builder, idx, depth, width, 0, width / 4, nil, true, true, 12)
                    builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", z_offset = width / 4 })
                elseif setups[random] == "darts n relics" then
                    addrelicstatue(builder, idx, 0, -width / 3 + 1, { "trggerdarttraps" })
                    addrelicstatue(builder, idx, depth / 4 - 1, 0, { "trggerdarttraps" })
                    addrelicstatue(builder, idx, 0, width / 3 - 1, { "trggerdarttraps" })
                    roomtype = "darts!"
                    nopressureplates = true
                end
            end
        elseif roomtype == "smalltreasure" then
            -- 小宝物
            if math.random() < 0.5 then
                addgoldstatue(builder, idx, 0, -width / 6)
                addgoldstatue(builder, idx, 0, width / 6)
            else
                addrelicstatue(builder, idx, 0, 0)
            end
        elseif roomtype == "grownover" then
            -- 杂草
            builder:AddRomPropAtInside(idx, "grass", math.random(10) + 8)
            builder:AddRomPropAtInside(idx, "sapling", math.random(4) + 8)
            builder:AddRomPropAtInside(idx, "deep_jungle_fern_noise_plant", math.random(10) + 10)
            builder:AddRoomProp(idx, "lightrays")
        end

        -- GENERAL RUINS ROOM ART
        -- 墙角柱子
        if math.random() < 0.8 or roomtype == "lightfires" or roomtype == "darts!" then -- the wall torches get blocked by the big beams
            builder:AddRoomProp(idx, { name = "deco_ruins_cornerbeam" .. room.color, x_offset = -depth / 2, z_offset = -width / 2 })
            builder:AddRoomProp(idx, { name = "deco_ruins_cornerbeam" .. room.color, x_offset = -depth / 2, z_offset = width / 2, scale = { -1, 1 } })
            builder:AddRoomProp(idx, { name = "deco_ruins_cornerbeam" .. room.color, x_offset = depth / 2, z_offset = -width / 2 })
            builder:AddRoomProp(idx, { name = "deco_ruins_cornerbeam" .. room.color, x_offset = depth / 2, z_offset = width / 2, scale = { -1, 1 } })
        else
            builder:AddRoomProp(idx, { name = "deco_ruins_cornerbeam_heavy" .. room.color, x_offset = -depth / 2, z_offset = -width / 2 })
            builder:AddRoomProp(idx, { name = "deco_ruins_cornerbeam_heavy" .. room.color, x_offset = -depth / 2, z_offset = width / 2, scale = { -1, 1 } })
            builder:AddRoomProp(idx, { name = "deco_ruins_beam_heavy" .. room.color, x_offset = depth / 2, z_offset = -width / 2 })
            builder:AddRoomProp(idx, { name = "deco_ruins_beam_heavy" .. room.color, x_offset = depth / 2, z_offset = width / 2, scale = { -1, 1 } })
        end

        local prop = math.random() < 0.2 and ("deco_ruins_beam_broken" .. room.color) or ("deco_ruins_beam" .. room.color)
        builder:AddRoomProp(idx, { name = prop, x_offset = -depth / 2, z_offset = -width / 6 })
        builder:AddRoomProp(idx, { name = prop, x_offset = -depth / 2, z_offset = width / 6, })
        if room.exits[RoomUtils.DIR.north] and room.exits[RoomUtils.DIR.north].vined then
            builder:AddRoomProp(idx, { name = "pig_ruins_wall_vines_north", x_offset = -depth / 2, z_offset = -width / 2 + 0.75 })
            builder:AddRoomProp(idx, { name = "pig_ruins_wall_vines_north", x_offset = -depth / 2, z_offset = -width / 3 + 0.75 })
            builder:AddRoomProp(idx, { name = "pig_ruins_wall_vines_north", x_offset = -depth / 2, z_offset = -width / 3 - 0.75 })
            builder:AddRoomProp(idx, { name = "pig_ruins_wall_vines_north", x_offset = -depth / 2, z_offset = -width / 6 + 0.75 })
            builder:AddRoomProp(idx, { name = "pig_ruins_wall_vines_north", x_offset = -depth / 2, z_offset = -width / 6 - 0.75 })
            builder:AddRoomProp(idx, { name = "pig_ruins_wall_vines_north", x_offset = -depth / 2, z_offset = width / 6 + 0.75 })
            builder:AddRoomProp(idx, { name = "pig_ruins_wall_vines_north", x_offset = -depth / 2, z_offset = width / 6 - 0.75 })
            builder:AddRoomProp(idx, { name = "pig_ruins_wall_vines_north", x_offset = -depth / 2, z_offset = width / 3 + 0.75 })
            builder:AddRoomProp(idx, { name = "pig_ruins_wall_vines_north", x_offset = -depth / 2, z_offset = width / 3 - 0.75 })
            builder:AddRoomProp(idx, { name = "pig_ruins_wall_vines_north", x_offset = -depth / 2, z_offset = width / 2 - 0.75 })
        end
        if room.exits[RoomUtils.DIR.west] and room.exits[RoomUtils.DIR.west].vined then
            builder:AddRoomProp(idx, { name = "pig_ruins_wall_vines_east", x_offset = -depth / 2 + 0.75, z_offset = -width / 2 })
            builder:AddRoomProp(idx, { name = "pig_ruins_wall_vines_east", x_offset = -depth / 3 - 0.75, z_offset = -width / 2 })
            builder:AddRoomProp(idx, { name = "pig_ruins_wall_vines_east", x_offset = -depth / 6 - 0.75, z_offset = -width / 2 })
            builder:AddRoomProp(idx, { name = "pig_ruins_wall_vines_east", x_offset = depth / 6 + 0.75, z_offset = -width / 2 })
            builder:AddRoomProp(idx, { name = "pig_ruins_wall_vines_east", x_offset = depth / 3 - 0.75, z_offset = -width / 2 })
            builder:AddRoomProp(idx, { name = "pig_ruins_wall_vines_east", x_offset = depth / 2 - 0.75, z_offset = -width / 2 })
        end
        if room.exits[RoomUtils.DIR.east] and room.exits[RoomUtils.DIR.east].vined then
            builder:AddRoomProp(idx, { name = "pig_ruins_wall_vines_west", x_offset = -depth / 2 + 0.75, z_offset = width / 2 })
            builder:AddRoomProp(idx, { name = "pig_ruins_wall_vines_west", x_offset = -depth / 3 - 0.75, z_offset = width / 2 })
            builder:AddRoomProp(idx, { name = "pig_ruins_wall_vines_west", x_offset = -depth / 6 - 0.75, z_offset = width / 2 })
            builder:AddRoomProp(idx, { name = "pig_ruins_wall_vines_west", x_offset = depth / 6 + 0.75, z_offset = width / 2 })
            builder:AddRoomProp(idx, { name = "pig_ruins_wall_vines_west", x_offset = depth / 3 + 0.75, z_offset = width / 2 })
            builder:AddRoomProp(idx, { name = "pig_ruins_wall_vines_west", x_offset = depth / 2 - 0.75, z_offset = width / 2 })
        end

        if roomtype == "speartraps!" then
            local speartraps = { "spottraps", "walltrap", "wavetrap", "bait" }
            local numexits = GetTableSize(room.exits)
            if dungeondef.deepruins and numexits > 1 then
                table.insert(speartraps, "litfloor")
            end
            local random = math.random(1, #speartraps)
            --random = 4
            if speartraps[random] == "spottraps" then
                if math.random() < 0.3 then
                    spawnspeartrapset(builder, idx, depth, width, depth / 3, -width / 3)
                    builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = depth / 3, z_offset = -width / 3 })
                elseif math.random() < 0.5 then
                    spawnspeartrapset(builder, idx, depth, width, 0, -width / 3)
                    builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", z_offset = -width / 3 })
                else
                    spawnspeartrapset(builder, idx, depth, width, -depth / 3, -width / 3)
                    builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = -depth / 3, z_offset = -width / 3 })
                end
                if math.random() < 0.3 then
                    spawnspeartrapset(builder, idx, depth, width, -depth / 3, width / 3)
                    builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = -depth / 3, z_offset = width / 3 })
                elseif math.random() < 0.5 then
                    spawnspeartrapset(builder, idx, depth, width, 0, width / 3)
                    builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", z_offset = width / 3 })
                else
                    spawnspeartrapset(builder, idx, depth, width, depth / 3, width / 3)
                    builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = depth / 3, z_offset = width / 3 })
                end
                if math.random() < 0.3 then
                    spawnspeartrapset(builder, idx, depth, width, -depth / 3, 0)
                    builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = -depth / 3 })
                elseif math.random() < 0.5 then
                    spawnspeartrapset(builder, idx, depth, width, 0, 0)
                    builder:AddRoomProp(idx, { name = "pig_ruins_light_beam" })
                else
                    spawnspeartrapset(builder, idx, depth, width, depth / 3, 0)
                    builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = depth / 3 })
                end
            elseif speartraps[random] == "bait" then
                local baits = {
                    goldnugget = 5,
                    rocks = 20,
                    flint = 20,
                    redgem = 1,
                    relic_1 = 1,
                    relic_2 = 1,
                    relic_3 = 1,
                    boneshard = 5,
                    meat_dried = 5,
                }
                local offsets = { { -depth / 5, -width / 5 }, { depth / 5, -width / 5 }, { -depth / 5, width / 5 }, { depth / 5, width / 5 } }
                for i = 1, math.random(1, 3) do
                    local rand = 1
                    rand = math.random(1, #offsets)
                    local choicex = offsets[rand][1]
                    local choicez = offsets[rand][2]
                    table.remove(offsets, rand)
                    spawnspeartrapset(builder, idx, depth, width, 0 + choicex, 0 + choicez, nil, true, true, 12)
                    builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = 0 + choicex, z_offset = 0 + choicez, })
                    local loot = weighted_random_choice(baits)
                    builder:AddRoomProp(idx, { name = loot, x_offset = 0 + choicex, z_offset = 0 + choicez })
                end
            elseif speartraps[random] == "walltrap" then
                local angle = 0
                local traps = 14
                local anglestep = (2 * PI) / traps
                local radius = 4
                for i = 1, traps do
                    local offset = Vector3(radius * math.cos(angle), 0, -radius * math.sin(angle))
                    builder:AddRoomProp(idx, { name = "pig_ruins_spear_trap", x_offset = offset.x, z_offset = offset.z })
                    angle = angle + anglestep
                end
                angle = 0
                traps = 24
                anglestep = (2 * PI) / traps
                radius = 5
                for i = 1, traps do
                    local offset = Vector3(radius * math.cos(angle), 0, -radius * math.sin(angle))
                    builder:AddRoomProp(idx, { name = "pig_ruins_spear_trap", x_offset = offset.x, z_offset = offset.z })
                    angle = angle + anglestep
                end
                builder:AddRoomProp(idx, { name = "relic_1" })
                builder:AddRoomProp(idx, { name = "pig_ruins_light_beam" })
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
                            builder:AddRoomProp(idx, { name = "pig_ruins_spear_trap", x_offset = -depth / scaledist + xmod, z_offset = ymod, addtags = getrandomset() })
                            builder:AddRoomProp(idx, { name = "pig_ruins_spear_trap", x_offset = xmod, z_offset = width / scaledist + ymod, addtags = getrandomset() })
                            builder:AddRoomProp(idx, { name = "pig_ruins_spear_trap", x_offset = depth / scaledist + xmod, z_offset = ymod, addtags = getrandomset() })
                            builder:AddRoomProp(idx, { name = "pig_ruins_spear_trap", x_offset = xmod, z_offset = -width / scaledist + ymod, addtags = getrandomset() })
                        else
                            builder:AddRoomProp(idx, { name = "pig_ruins_spear_trap", x_offset = -depth / scaledist + xmod, z_offset = -width / scaledist + ymod, addtags = getrandomset() })
                            builder:AddRoomProp(idx, { name = "pig_ruins_spear_trap", x_offset = -depth / scaledist + xmod, z_offset = width / scaledist + ymod, addtags = getrandomset() })
                            builder:AddRoomProp(idx, { name = "pig_ruins_spear_trap", x_offset = depth / scaledist + xmod, z_offset = -width / scaledist + ymod, addtags = getrandomset() })
                            builder:AddRoomProp(idx, { name = "pig_ruins_spear_trap", x_offset = depth / scaledist + xmod, z_offset = width / scaledist + ymod, addtags = getrandomset() })
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
                        spawnspeartrapset(builder, idx, depth, width, 0, -width / 4, { "timed", "up_3", "down_6", "delay_3" }, true)
                        spawnspeartrapset(builder, idx, depth, width, 0, 0, { "timed", "up_3", "down_6", "delay_6" }, true)
                        spawnspeartrapset(builder, idx, depth, width, 0, width / 4, { "timed", "up_3", "down_6", "delay_9" }, true)
                        spawnspeartrapset(builder, idx, depth, width, -depth / 4, -width / 4, { "timed", "up_3", "down_6", "delay_3" }, true)
                        spawnspeartrapset(builder, idx, depth, width, -depth / 4, 0, { "timed", "up_3", "down_6", "delay_6" }, true)
                        spawnspeartrapset(builder, idx, depth, width, -depth / 4, width / 4, { "timed", "up_3", "down_6", "delay_9" }, true)
                        spawnspeartrapset(builder, idx, depth, width, depth / 4, -width / 4, { "timed", "up_3", "down_6", "delay_3" }, true)
                        spawnspeartrapset(builder, idx, depth, width, depth / 4, 0, { "timed", "up_3", "down_6", "delay_6" }, true)
                        spawnspeartrapset(builder, idx, depth, width, depth / 4, width / 4, { "timed", "up_3", "down_6", "delay_9" }, true)
                    else
                        spawnspeartrapset(builder, idx, depth, width, 0, -width / 4, { "timed", "up_3", "down_6", "delay_6" }, true)
                        spawnspeartrapset(builder, idx, depth, width, 0, 0, { "timed", "up_3", "down_6", "delay_6" }, true)
                        spawnspeartrapset(builder, idx, depth, width, 0, width / 4, { "timed", "up_3", "down_6", "delay_6" }, true)
                        spawnspeartrapset(builder, idx, depth, width, -depth / 4, -width / 4, { "timed", "up_3", "down_6", "delay_9" }, true)
                        spawnspeartrapset(builder, idx, depth, width, -depth / 4, 0, { "timed", "up_3", "down_6", "delay_9" }, true)
                        spawnspeartrapset(builder, idx, depth, width, -depth / 4, width / 4, { "timed", "up_3", "down_6", "delay_9" }, true)
                        spawnspeartrapset(builder, idx, depth, width, depth / 4, -width / 4, { "timed", "up_3", "down_6", "delay_3" }, true)
                        spawnspeartrapset(builder, idx, depth, width, depth / 4, 0, { "timed", "up_3", "down_6", "delay_3" }, true)
                        spawnspeartrapset(builder, idx, depth, width, depth / 4, width / 4, { "timed", "up_3", "down_6", "delay_3" }, true)
                    end
                end
            elseif speartraps[random] == "litfloor" then
                spawnspeartrapset(builder, idx, depth, width, depth / 2.7, -width / 2.7)
                builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = depth / 2.5, z_offset = -width / 2.5 })
                spawnspeartrapset(builder, idx, depth, width, depth / 6, -width / 2.7, nil, nil, nil, nil, true)
                builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = depth / 6, z_offset = -width / 2.5 })
                spawnspeartrapset(builder, idx, depth, width, -depth / 6, -width / 2.7, nil, nil, nil, nil, true)
                builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = -depth / 6, z_offset = -width / 2.5 })
                spawnspeartrapset(builder, idx, depth, width, -depth / 2.7, -width / 2.7)
                builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = -depth / 2.5, z_offset = -width / 2.5 })
                spawnspeartrapset(builder, idx, depth, width, depth / 2.5, -width / 6, nil, nil, nil, nil, true)
                builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = depth / 2.5, z_offset = -width / 6 })
                spawnspeartrapset(builder, idx, depth, width, depth / 6, -width / 6)
                builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = depth / 6, z_offset = -width / 6 })
                spawnspeartrapset(builder, idx, depth, width, 0, -width / 6, nil, nil, nil, nil, true)
                builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", z_offset = -width / 6 })
                spawnspeartrapset(builder, idx, depth, width, -depth / 6, -width / 6)
                builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = -depth / 6, z_offset = -width / 6 })
                spawnspeartrapset(builder, idx, depth, width, -depth / 2.5, -width / 6, nil, nil, nil, nil, true)
                builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = -depth / 2.5, z_offset = -width / 6 })
                spawnspeartrapset(builder, idx, depth, width, depth / 6, 0, nil, nil, nil, nil, true)
                builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = depth / 6 })
                spawnspeartrapset(builder, idx, depth, width, 0, 0)
                builder:AddRoomProp(idx, { name = "pig_ruins_light_beam" })
                spawnspeartrapset(builder, idx, depth, width, -depth / 6, 0, nil, nil, nil, nil, true)
                builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = -depth / 6 })
                spawnspeartrapset(builder, idx, depth, width, depth / 2.5, width / 6, nil, nil, nil, nil, true)
                builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = depth / 2.5, z_offset = width / 6 })
                spawnspeartrapset(builder, idx, depth, width, depth / 6, width / 6)
                builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = depth / 6, z_offset = width / 6 })
                spawnspeartrapset(builder, idx, depth, width, 0, width / 6, nil, nil, nil, nil, true)
                builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", z_offset = width / 6 })
                spawnspeartrapset(builder, idx, depth, width, -depth / 6, width / 6)
                builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = -depth / 6, z_offset = width / 6 })
                spawnspeartrapset(builder, idx, depth, width, -depth / 2.5, width / 6, nil, nil, nil, nil, true)
                builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = -depth / 2.5, z_offset = width / 6 })
                spawnspeartrapset(builder, idx, depth, width, depth / 2.7, width / 2.7)
                builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = depth / 2.5, z_offset = width / 2.5 })
                spawnspeartrapset(builder, idx, depth, width, depth / 6, width / 2.7, nil, nil, nil, nil, true)
                builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = depth / 6, z_offset = width / 2.5 })
                spawnspeartrapset(builder, idx, depth, width, -depth / 6, width / 2.7, nil, nil, nil, nil, true)
                builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = -depth / 6, z_offset = width / 2.5 })
                spawnspeartrapset(builder, idx, depth, width, -depth / 2.7, width / 2.7)
                builder:AddRoomProp(idx, { name = "pig_ruins_light_beam", x_offset = -depth / 2.5, z_offset = width / 2.5 })
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
                builder:AddRoomProp(idx, { name = "pig_ruins_dart_statue", x_offset = x, z_offset = z })
            else
                builder:AddRoomProp(idx, { name = "pig_ruins_pigman_relief_dart" .. math.random(4) .. room.color, x_offset = -depth / 2, z_offset = -width / 3 })
                if northexitopen then
                    builder:AddRoomProp(idx, { name = "pig_ruins_pigman_relief_dart" .. math.random(4) .. room.color, x_offset = -depth / 2 })
                end
                builder:AddRoomProp(idx, { name = "pig_ruins_pigman_relief_dart" .. math.random(4) .. room.color, x_offset = -depth / 2, z_offset = width / 3 })
                builder:AddRoomProp(idx, { name = "pig_ruins_pigman_relief_leftside_dart" .. room.color, x_offset = -depth / 4 + (math.random() * 1 - 0.5), z_offset = -width / 2 })
                if westexitopen then
                    builder:AddRoomProp(idx, { name = "pig_ruins_pigman_relief_leftside_dart" .. room.color, x_offset = 0 + (math.random() * 1 - 0.5), z_offset = -width / 2 })
                end
                builder:AddRoomProp(idx, { name = "pig_ruins_pigman_relief_leftside_dart" .. room.color, x_offset = depth / 4 + (math.random() * 1 - 0.5), z_offset = -width / 2 })
                builder:AddRoomProp(idx, { name = "pig_ruins_pigman_relief_rightside_dart" .. room.color, x_offset = -depth / 4 + (math.random() * 1 - 0.5), z_offset = width / 2 })
                if eastexitopen then
                    builder:AddRoomProp(idx, { name = "pig_ruins_pigman_relief_rightside_dart" .. room.color, x_offset = 0 + (math.random() * 1 - 0.5), z_offset = width / 2 })
                end
                builder:AddRoomProp(idx, { name = "pig_ruins_pigman_relief_rightside_dart" .. room.color, x_offset = depth / 4 + (math.random() * 1 - 0.5), z_offset = width / 2 })
            end
            -- if the treasure room wants dart traps, then the plates get turned off.
            if not nopressureplates then
                builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = -depth / 6 * 2 + (math.random() * 2 - 1), z_offset = 0 + (math.random() * 2 - 1), })
                builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = 0 + (math.random(2) - 1), z_offset = 0 + (math.random() * 2 - 1), })
                if southexitopen then
                    builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = depth / 6 * 2 + (math.random() * 2 - 1), z_offset = 0 + (math.random() * 2 - 1), })
                end
                builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = -depth / 6 * 2 + (math.random() * 2 - 1), z_offset = -width / 6 * 2 + (math.random() * 2 - 1), })
                builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = (math.random() * 2 - 1), z_offset = -width / 6 * 2 + (math.random() * 2 - 1), })
                builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = -depth / 6 * 2 + (math.random() * 2 - 1), z_offset = width / 6 * 2 + (math.random() * 2 - 1), })
                builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = depth / 6 * 2 + (math.random() * 2 - 1), z_offset = -width / 6 * 2 + (math.random() * 2 - 1), })
                builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = (math.random() * 2 - 1), z_offset = width / 6 * 2 + (math.random() * 2 - 1), })
                builder:AddRoomProp(idx, { name = "pig_ruins_pressure_plate", x_offset = depth / 6 * 2 + (math.random() * 2 - 1), z_offset = width / 6 * 2 + (math.random() * 2 - 1), })
            end
        else
            local wallrelief = math.random()
            if wallrelief < 0.6 and roomtype ~= "lightfires" then
                if math.random() < 0.8 then
                    builder:AddRoomProp(idx, { name = "deco_ruins_pigman_relief" .. math.random(3) .. room.color, x_offset = -depth / 2, z_offset = -width / 6 * 2, })
                else
                    builder:AddRoomProp(idx, { name = "deco_ruins_crack_roots" .. math.random(4), x_offset = -depth / 2, z_offset = -width / 6 * 2, })
                end
                if northexitopen then
                    if math.random() < 0.8 then
                        if math.random() < 0.1 then
                            builder:AddRoomProp(idx, { name = "deco_ruins_pigqueen_relief" .. room.color, x_offset = -depth / 2, z_offset = -width / 18, })
                            builder:AddRoomProp(idx, { name = "deco_ruins_pigking_relief" .. room.color, x_offset = -depth / 2, z_offset = width / 18, })
                        else
                            builder:AddRoomProp(idx, { name = "deco_ruins_pigman_relief" .. math.random(3) .. room.color, x_offset = -depth / 2, })
                        end
                    else
                        builder:AddRoomProp(idx, { name = "deco_ruins_crack_roots" .. math.random(4), x_offset = -depth / 2, })
                    end
                end
                if math.random() < 0.8 then
                    builder:AddRoomProp(idx, { name = "deco_ruins_pigman_relief" .. math.random(3) .. room.color, x_offset = -depth / 2, z_offset = width / 6 * 2, })
                else
                    builder:AddRoomProp(idx, { name = "deco_ruins_crack_roots" .. math.random(4), x_offset = -depth / 2, z_offset = width / 6 * 2, })
                end
            else
                if math.random() < 0.5 or roomtype == "lightfires" then
                    local tags = nil
                    if roomtype == "lightfires" then
                        tags = "something"
                        if northexitopen then
                            builder:AddRoomProp(idx, { name = "deco_ruins_writing1", x_offset = -depth / 2, })
                            builder:AddRoomProp(idx, { name = "pig_ruins_torch_wall" .. room.color, x_offset = -depth / 2, z_offset = -width / 6 * 2,
                            })
                        else
                            builder:AddRoomProp(idx, { name = "deco_ruins_writing1", x_offset = -depth / 2, z_offset = -width / 6 * 2, })
                        end
                        builder:AddRoomProp(idx, { name = "pig_ruins_torch_wall" .. room.color, x_offset = -depth / 2, z_offset = width / 6 * 2, })
                    else
                        builder:AddRoomProp(idx, { name = "pig_ruins_torch_wall" .. room.color, x_offset = -depth / 2, z_offset = -width / 6 * 2, })
                        if northexitopen then
                            builder:AddRoomProp(idx, { name = "pig_ruins_torch_wall" .. room.color, x_offset = -depth / 2, })
                        end
                        builder:AddRoomProp(idx, { name = "pig_ruins_torch_wall" .. room.color, x_offset = -depth / 2, z_offset = width / 6 * 2, })
                    end
                    builder:AddRoomProp(idx, { name = "pig_ruins_torch_sidewall" .. room.color, x_offset = -depth / 3 - 0.5, z_offset = -width / 2, })
                    if westexitopen then
                        builder:AddRoomProp(idx, { name = "pig_ruins_torch_sidewall" .. room.color, x_offset = 0 - 0.5, z_offset = -width / 2, })
                    end
                    builder:AddRoomProp(idx, { name = "pig_ruins_torch_sidewall" .. room.color, x_offset = depth / 3 - 0.5, z_offset = -width / 2, })
                    builder:AddRoomProp(idx, { name = "pig_ruins_torch_sidewall" .. room.color, x_offset = -depth / 3 - 0.5, z_offset = width / 2, scale = { -1, 1 } })
                    if eastexitopen then
                        builder:AddRoomProp(idx, { name = "pig_ruins_torch_sidewall" .. room.color, x_offset = 0 - 0.5, z_offset = width / 2, scale = { -1, 1 } })
                    end
                    builder:AddRoomProp(idx, { name = "pig_ruins_torch_sidewall" .. room.color, x_offset = depth / 3 - 0.5, z_offset = width / 2, scale = { -1, 1 } })
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
                { name = "deco_ruins_roots" .. math.random(3), x_offset = -depth / 2, z_offset = -width / 6 - width / 12 + jostle(), flip = flip() },
                { name = "deco_ruins_roots" .. math.random(3), x_offset = -depth / 2, z_offset = -width / 6 - width / 12 * 2 + jostle(), flip = flip() },
                { name = "deco_ruins_roots" .. math.random(3), x_offset = -depth / 2, z_offset = -width / 6 - width / 12 * 3 + jostle(), flip = flip() }
            }
            local num = math.random(#roots_left)
            for i = 1, num do
                local choice = math.random(#roots_left)
                builder:AddRoomProp(idx, roots_left[choice])
                table.remove(roots_left, choice)
            end
            if northexitopen then
                local roots_center = {
                    { name = "deco_ruins_roots" .. math.random(3), x_offset = -depth / 2, z_offset = 0 + width / 12 + jostle(), flip = flip() },
                    { name = "deco_ruins_roots" .. math.random(3), x_offset = -depth / 2, z_offset = 0 + jostle(), flip = flip() },
                    { name = "deco_ruins_roots" .. math.random(3), x_offset = -depth / 2, z_offset = 0 - width / 12 + jostle(), flip = flip() }
                }
                local num = math.random(#roots_center)
                for i = 1, num do
                    local choice = math.random(#roots_center)
                    builder:AddRoomProp(idx, roots_center[choice])
                    table.remove(roots_center, choice)
                end
            end
            local roots_right = {
                { name = "deco_ruins_roots" .. math.random(3), x_offset = -depth / 2, z_offset = width / 6 + width / 12 + jostle(), flip = flip() },
                { name = "deco_ruins_roots" .. math.random(3), x_offset = -depth / 2, z_offset = width / 6 + width / 12 * 2 + jostle(), flip = flip() },
                { name = "deco_ruins_roots" .. math.random(3), x_offset = -depth / 2, z_offset = width / 6 + width / 12 * 3 + jostle(), flip = flip() }
            }
            local num = math.random(#roots_right)
            for i = 1, num do
                local choice = math.random(#roots_right)
                builder:AddRoomProp(idx, roots_right[choice])
                table.remove(roots_right, choice)
            end
        end
        if math.random() < 0.1 and roomtype ~= "lightfires" and roomtype ~= "speartraps!" then
            if math.random() < 0.5 then
                builder:AddRoomProp(idx, { name = "deco_ruins_corner_tree", x_offset = -depth / 2, z_offset = width / 2, scale = { -1, 1 } })
            else
                builder:AddRoomProp(idx, { name = "deco_ruins_corner_tree", x_offset = -depth / 2, z_offset = -width / 2, })
            end
        end
        --RANDOM POTS
        if roomtype ~= "secret" and roomtype ~= "aporkalypse" and math.random() < 0.25 then
            for i = 1, math.random(2) + 1 do
                local setwidth, setdepth = getspawnlocation(0.8, 0.8)
                if setwidth and setdepth then
                    builder:AddRoomProp(idx, { name = "smashingpot", x_offset = setdepth, z_offset = setwidth })
                end
            end
        end

        -- 地板和墙壁
        if room.color == "_blue" then
            builder:AddRoomProp(idx, { name = "interior_floor_ground_ruins_slab_blue" })
            builder:AddRoomProp(idx, { name = "interior_wall_pig_ruins_blue" })
        else
            builder:AddRoomProp(idx, { name = "interior_floor_ground_ruins_slab" })
            builder:AddRoomProp(idx, { name = "interior_wall_pig_ruins" })
        end
    end

    -- 门
    builder:AddAllRoomDoorProp(GetDoorProp)

    return builder.rooms
end


return mazemaker
