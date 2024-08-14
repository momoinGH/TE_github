local InteriorSpawnerUtils = require("interiorspawnerutils")
local assets               =
{
    Asset("ANIM", "anim/pig_ruins_entrance.zip"),
    Asset("ANIM", "anim/pig_door_test.zip"),
    Asset("MINIMAP_IMAGE", "pig_ruins_entrance"),
    Asset("ANIM", "anim/pig_ruins_entrance_build.zip"),
    Asset("ANIM", "anim/pig_ruins_entrance_top_build.zip"),
}
local prefabs              =
{
    "deco_roomglow",
    "light_dust_fx",
    "deco_ruins_wallcrumble_1",
    "deco_ruins_wallcrumble_side_1",
    "deco_ruins_cornerbeam",
    "deco_ruins_beam",
    "deco_ruins_wallstrut",
    "deco_ruins_beam_broken",
    "deco_ruins_cornerbeam_heavy",
    "deco_ruins_beam_room",
    "deco_ruins_fountain",
    "pig_ruins_torch_sidewall",
    "deco_ruins_pigman_relief_side",
    "deco_ruins_writing1",
    "pig_ruins_dart",
    "pig_ruins_pressure_plate",
    "pig_ruins_torch_wall",
    "deco_ruins_crack_roots1",
    "deco_ruins_crack_roots2",
    "deco_ruins_crack_roots3",
    "deco_ruins_crack_roots4",
    "deco_ruins_pigqueen_relief",
    "deco_ruins_pigking_relief",
    "deco_ruins_pigman_relief1",
    "deco_ruins_pigman_relief2",
    "deco_ruins_pigman_relief3",
    "pig_ruins_creeping_vines",
    "pig_ruins_wall_vines_north",
    "pig_ruins_wall_vines_east",
    "pig_ruins_wall_vines_west",
    "smashingpot",
    "aporkalypse_clock",
    "wallcrack_ruins"
}
local room_creatures       = {
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
---@param dungeondef table 配置
---@return table|nil entranceRoom 入口房间
---@return table|nil exitRoom 出口房间
local function mazemaker(dungeondef)
    local interior_spawner = GetWorld().components.interiorspawner
    local DIR = InteriorSpawnerUtils.DIR
    local rooms_to_make = dungeondef.rooms --24
    local entranceRoom = nil
    local exitRoom = nil
    local rooms = { {
        x = 0,
        y = 0,
        idx = dungeondef.name .. "_" .. interior_spawner:GetNewID(),
        exits = {},
        blocked_exits = { DIR.NORTH }, -- 3 == NORTH
        entrance1 = true,
    } }
    local clock_placed = false
    while #rooms < rooms_to_make do
        -- 构建每一个房间
        -- 从现有房间里随机选择一个房间作为前置房间，然后在前置房间随机选择一个方向
        local dir_opposite = InteriorSpawnerUtils.DIR_OPPOSITE
        local dir_choice = math.random(#DIR)
        local fromroom = rooms[math.random(#rooms)]
        local fail = false
        -- fail if this direction from the chosen room is blocked
        for i, exit in ipairs(fromroom.blocked_exits) do
            if dir_choice == exit then
                fail = true
                break
            end
        end
        -- fail if this room of the maze is already set up.
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
                idx = dungeondef.name .. "_" .. interior_spawner:GetNewID(),
                exits = {},
                blocked_exits = {},
            }
            fromroom.exits[DIR[dir_choice]] = {
                target_room = newroom.idx,
                bank = "doorway_ruins",
                build = "pig_ruins_door",
                room = fromroom.idx,
            }
            newroom.exits[dir_opposite[dir_choice]] = {
                target_room = fromroom.idx,
                bank = "doorway_ruins",
                build = "pig_ruins_door",
                room = newroom.idx,
            }
            if math.random() < dungeondef.doorvines then --藤蔓
                fromroom.exits[DIR[dir_choice]].vined = true
                newroom.exits[dir_opposite[dir_choice]].vined = true
            end
            table.insert(rooms, newroom)
        end
    end
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
                local north = DIR.NORTH
                local west = DIR.WEST
                local east = DIR.EAST
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
                idx = dungeondef.name .. "_" .. interior_spawner:GetNewID(),
                exits = {},
                blocked_exits = {},
                secretroom = true
            }
            local grid_rooms = grid[x][y].rooms
            local grid_dirs = grid[x][y].dirs
            local bank = "interior_wall_decals_ruins"
            local build = "interior_wall_decals_ruins_cracks"
            if dungeondef.name == "RUINS_5" and not clock_placed then
                -- 可以放置日晷
                clock_placed = true
                secret_room.aporkalypseclock = true
                while #grid_rooms > 1 do
                    local num = math.random(1, #grid_rooms)
                    table.remove(grid_rooms, num)
                    table.remove(grid_dirs, num)
                    bank = "doorway_ruins"
                    build = "pig_ruins_door"
                end
            end
            -- 将秘密房间和相邻房间相连通
            for i, grid_room in ipairs(grid_rooms) do
                local op_dir = InteriorSpawnerUtils.DIR_OPPOSITE2[grid_dirs[i]]
                local secret = true
                if secret_room.aporkalypseclock then
                    secret = false --有日晷的房间
                end
                secret_room.exits[op_dir] = {
                    target_room = grid_room.idx,
                    bank = bank,
                    build = build,
                    room = secret_room.idx,
                    secret = secret,
                }
                grid_room.exits[grid_dirs[i]] = {
                    target_room = secret_room.idx,
                    bank = "interior_wall_decals_ruins",
                    build = "interior_wall_decals_ruins_cracks",
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
    local choices
    if not dungeondef.nosecondexit then
        choices = {}
        -- 挑选最边缘的，顶部没有门的房间作为出口所在房间
        local dist = 0
        for i, room in ipairs(rooms) do
            -- local dir = interior_spawner:GetDir()
            local north_exit_open = not room.exits[interior_spawner:GetNorth()]
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
    if dungeondef.name == "RUINS_3" then
        choices[math.random(#choices)].pheromonestone = true
    elseif dungeondef.name == "RUINS_1" then
        choices[math.random(#choices)].relictruffle = true
    elseif dungeondef.name == "RUINS_2" then
        choices[math.random(#choices)].relicsow = true
    elseif dungeondef.name == "RUINS_5" then
        advancedtraps = true
        choices[math.random(#choices)].endswell = true
    else
        choices[math.random(#choices)].treasure = true
    end
    CreateSecretRoom()


    local width = 24
    local depth = 16
    local props_by_room = {} --每个房间对应的预制件列表
    for _, room in ipairs(rooms) do
        if dungeondef.deepruins and math.random() < 0.3 then
            room.color = "_blue"
        else
            room.color = ""
        end
        local addprops = {}
        local nopressureplates = false
        if exitNumbers(room) == 1 or math.random() < 0.3 then
            -- all rooms with 1 exit get creatures, randomly add creatures otherwise
            for p, prop in ipairs(room_creatures[math.random(#room_creatures)]) do
                table.insert(addprops, prop)
            end
        end
        if room.entrance1 then
            local prefab = {
                name = "pig_ruins_door_entrada",
                x_offset = -8,
                my_door_id = dungeondef.name .. "_EXIT1",
                target_door_id = dungeondef.name .. "_ENTRANCE1",
            }
            table.insert(addprops, prefab)
            entranceRoom = room
        end
        if room.entrance2 then
            local prefab = {
                name = "pig_ruins_door_entrada",
                x_offset = -8,
                my_door_id = dungeondef.name .. "_EXIT2",
                target_door_id = dungeondef.name .. "_ENTRANCE2",
            }
            table.insert(addprops, prefab)
            exitRoom = room
        end
        if room.endswell then
            local prefab = { name = "deco_ruins_endswell" }
            table.insert(addprops, prefab)
        end
        if room.pheromonestone then
            local prefab = { name = "pheromonestone" }
            table.insert(addprops, prefab)
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
        local northexitopen = not room.exits[DIR.NORTH] and not room.entrance2 and not room.entrance1
        local westexitopen = not room.exits[DIR.WEST]
        local southexitopen = not room.exits[DIR.SOUTH]
        local eastexitopen = not room.exits[DIR.EAST]
        local numexits = GetTableSize(room.exits)
        if northexitopen and math.random() < 0.10 then
            table.insert(addprops, { name = "pig_ruins_door_cimaescondida", x_offset = -depth / 2 })
            northexitopen = false
        end
        if westexitopen and math.random() < 0.10 then
            table.insert(addprops, { name = "pig_ruins_door_esquerdaescondida", z_offset = -width / 2 })
            westexitopen = false
        end
        if eastexitopen and math.random() < 0.10 then
            table.insert(addprops, { name = "pig_ruins_door_direitaescondida", z_offset = width / 2 })
            eastexitopen = false
        end
        local fountain = false
        -- 添加柱子
        local function addroomcolumn(x, z)
            if math.random() < 0.2 then
                table.insert(addprops,
                    { name = "deco_ruins_beam_room_broken" .. room.color, x_offset = x, z_offset = z, })
            else
                table.insert(addprops,
                    { name = "deco_ruins_beam_room" .. room.color, x_offset = x, z_offset = z, })
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
                widepilars = true
            elseif feature == 2 then
                if roomtype ~= "doortrap" and not room.pheromonestone then
                    table.insert(addprops, { name = "deco_ruins_fountain" })
                    fountain = true
                end
                if math.random() < 0.5 then
                    addroomcolumn(-depth / 6, width / 3)
                    addroomcolumn(depth / 6, -width / 3)
                    widepilars = true
                else
                    addroomcolumn(-depth / 4, width / 4)
                    addroomcolumn(-depth / 4, -width / 4)
                    addroomcolumn(depth / 4, -width / 4)
                    addroomcolumn(depth / 4, width / 4)
                    pilars = true
                end
            elseif feature == 3 then
                addroomcolumn(-depth / 4, width / 6)
                addroomcolumn(0, width / 6)
                addroomcolumn(depth / 4, width / 6)
                addroomcolumn(-depth / 4, -width / 6)
                addroomcolumn(0, -width / 6)
                addroomcolumn(depth / 4, -width / 6)
                pilars = true
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
                table.insert(addprops, { name = "pig_ruins_pressure_plate", z_offset = 0 })
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
                table.insert(addprops, { name = "pig_ruins_pressure_plate", x_offset = depth / 4.5 * dir, z_offset = 0 })
                for i = 1, 7 do
                    table.insert(addprops,
                        { name = "pig_ruins_pressure_plate", x_offset = depth / 4.5 * dir, z_offset = i * unit })
                    table.insert(addprops,
                        { name = "pig_ruins_pressure_plate", x_offset = depth / 4.5 * dir, z_offset = -i * unit })
                end
            elseif setups[random] == "vert" then
                local unit = 1.5
                table.insert(addprops, { name = "pig_ruins_pressure_plate", z_offset = 0 })
                for i = 1, 3 do
                    table.insert(addprops, { name = "pig_ruins_pressure_plate", x_offset = i * unit, z_offset = 0 })
                    table.insert(addprops, { name = "pig_ruins_pressure_plate", x_offset = -i * unit, z_offset = 0 })
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
                table.insert(addprops, { name = "aporkalypse_clock", x_offset = -1, z_offset = 0 })
                fountain = true
            elseif treasuretype and treasuretype == "secret" then
                local items = {
                    redgem = 30,
                    bluegem = 20,
                    relic_1 = 10,
                    relic_2 = 10,
                    relic_3 = 10,
                    nightsword = 1,
                    ruins_bat = 1,
                    ruinshat = 1,
                    orangestaff = 1,
                    armorruins = 1,
                    multitool_axe_pickaxe = 1,
                }
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
                    table.insert(addprops, { name = relic, x_offset = depth / 2 - 2, addtags = { "trggerdarttraps" } })
                    table.insert(addprops, { name = "pig_ruins_light_beam", x_offset = depth / 2 - 2, z_offset = 0 })
                elseif not southexitopen and northexitopen then
                    table.insert(addprops, { name = relic, x_offset = -depth / 2 + 2, addtags = { "trggerdarttraps" } })
                    table.insert(addprops, { name = "pig_ruins_light_beam", x_offset = -depth / 2 + 2, z_offset = 0 })
                elseif not westexitopen and eastexitopen then
                    table.insert(addprops, { name = relic, z_offset = width / 2 - 2, addtags = { "trggerdarttraps" } })
                    table.insert(addprops, { name = "pig_ruins_light_beam", z_offset = width / 2 - 2 })
                elseif not eastexitopen and westexitopen then
                    table.insert(addprops, { name = relic, z_offset = -width / 2 + 2, addtags = { "trggerdarttraps" } })
                    table.insert(addprops, { name = "pig_ruins_light_beam", z_offset = -width / 2 + 2 })
                else
                    -- Place it in the middle of the room as a fallback.
                    table.insert(addprops, { name = relic, addtags = { "trggerdarttraps" } })
                    table.insert(addprops, { name = "pig_ruins_light_beam", z_offset = 0 })
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
                            table.insert(addprops, { name = "pig_ruins_pressure_plate", x_offset = xoffset, z_offset = yoffset, addtags = { "trap_dart" } })
                        end
                    end
                    if math.random() < 0.5 then
                        local xoffset = x - depth / 16
                        local yoffset = y - width / 16
                        if math.abs(xoffset) < depth / 2 and math.abs(yoffset) < width / 2 then
                            table.insert(addprops, { name = "pig_ruins_pressure_plate", x_offset = xoffset, z_offset = yoffset, addtags = { "trap_dart" } })
                        end
                    end
                    if math.random() < 0.5 then
                        local xoffset = x - depth / 16
                        local yoffset = y + width / 16
                        if math.abs(xoffset) < depth / 2 and math.abs(yoffset) < width / 2 then
                            table.insert(addprops, { name = "pig_ruins_pressure_plate", x_offset = xoffset, z_offset = yoffset, addtags = { "trap_dart" } })
                        end
                    end
                    if math.random() < 0.5 then
                        local xoffset = x + depth / 16
                        local yoffset = y + width / 16
                        if math.abs(xoffset) < depth / 2 and math.abs(yoffset) < width / 2 then
                            table.insert(addprops, { name = "pig_ruins_pressure_plate", x_offset = xoffset, z_offset = yoffset, addtags = { "trap_dart" } })
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
                    table.insert(addprops, { name = "pig_ruins_light_beam", z_offset = -width / 4, addtags = { "localtrap" } })
                    addprops = spawnspeartrapset(addprops, depth, width, 0, 0, nil, true, true, 12)
                    table.insert(addprops, { name = "pig_ruins_light_beam", addtags = { "localtrap" } })
                    addprops = spawnspeartrapset(addprops, depth, width, 0, width / 4, nil, true, true, 12)
                    table.insert(addprops, { name = "pig_ruins_light_beam", z_offset = width / 4, addtags = { "localtrap" } })
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
            table.insert(addprops, { name = "lightrays", z_offset = 0 })
        end
        -- GENERAL RUINS ROOM ART
        if math.random() < 0.8 or roomtype == "lightfires" or roomtype == "darts!" then -- the wall torches get blocked by the big beams
            table.insert(addprops,
                { name = "deco_ruins_cornerbeam" .. room.color, x_offset = -depth / 2, z_offset = -width / 2 })
            table.insert(addprops,
                { name = "deco_ruins_cornerbeam" .. room.color, x_offset = -depth / 2, z_offset = width / 2, flip = true })
            table.insert(addprops,
                { name = "deco_ruins_cornerbeam" .. room.color, x_offset = depth / 2, z_offset = -width / 2 })
            table.insert(addprops,
                { name = "deco_ruins_cornerbeam" .. room.color, x_offset = depth / 2, z_offset = width / 2, flip = true })
        else
            table.insert(addprops,
                { name = "deco_ruins_cornerbeam_heavy" .. room.color, x_offset = -depth / 2, z_offset = -width / 2 })
            table.insert(addprops,
                { name = "deco_ruins_cornerbeam_heavy" .. room.color, x_offset = -depth / 2, z_offset = width / 2, flip = true })
            table.insert(addprops,
                { name = "deco_ruins_beam_heavy" .. room.color, x_offset = depth / 2, z_offset = -width / 2 })
            table.insert(addprops,
                { name = "deco_ruins_beam_heavy" .. room.color, x_offset = depth / 2, z_offset = width / 2, flip = true })
            heavybeams = true
        end
        local prop = math.random() < 0.2 and ("deco_ruins_beam_broken" .. room.color) or ("deco_ruins_beam" .. room.color)
        table.insert(addprops, { name = prop, x_offset = -depth / 2, z_offset = -width / 6 })
        table.insert(addprops, { name = prop, x_offset = -depth / 2, z_offset = width / 6, })
        if room.exits[DIR.NORTH] and room.exits[DIR.NORTH].vined then
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
        if room.exits[DIR.WEST] and room.exits[DIR.WEST].vined then
            table.insert(addprops, { name = "pig_ruins_wall_vines_east", x_offset = -depth / 2 + 0.75, z_offset = -width / 2 })
            table.insert(addprops, { name = "pig_ruins_wall_vines_east", x_offset = -depth / 3 - 0.75, z_offset = -width / 2 })
            table.insert(addprops, { name = "pig_ruins_wall_vines_east", x_offset = -depth / 6 - 0.75, z_offset = -width / 2 })
            table.insert(addprops, { name = "pig_ruins_wall_vines_east", x_offset = depth / 6 + 0.75, z_offset = -width / 2 })
            table.insert(addprops, { name = "pig_ruins_wall_vines_east", x_offset = depth / 3 - 0.75, z_offset = -width / 2 })
            table.insert(addprops, { name = "pig_ruins_wall_vines_east", x_offset = depth / 2 - 0.75, z_offset = -width / 2 })
        end
        if room.exits[DIR.EAST] and room.exits[DIR.EAST].vined then
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
                    table.insert(addprops, { name = "pig_ruins_light_beam", x_offset = depth / 3, z_offset = -width / 3, addtags = { "localtrap" } })
                elseif math.random() < 0.5 then
                    addprops = spawnspeartrapset(addprops, depth, width, 0, -width / 3)
                    table.insert(addprops, { name = "pig_ruins_light_beam", z_offset = -width / 3, addtags = { "localtrap" } })
                else
                    addprops = spawnspeartrapset(addprops, depth, width, -depth / 3, -width / 3)
                    table.insert(addprops,
                        { name = "pig_ruins_light_beam", x_offset = -depth / 3, z_offset = -width / 3, addtags = { "localtrap" } })
                end
                if math.random() < 0.3 then
                    addprops = spawnspeartrapset(addprops, depth, width, -depth / 3, width / 3)
                    table.insert(addprops,
                        { name = "pig_ruins_light_beam", x_offset = -depth / 3, z_offset = width / 3, addtags = { "localtrap" } })
                elseif math.random() < 0.5 then
                    addprops = spawnspeartrapset(addprops, depth, width, 0, width / 3)
                    table.insert(addprops,
                        { name = "pig_ruins_light_beam", z_offset = width / 3, addtags = { "localtrap" } })
                else
                    addprops = spawnspeartrapset(addprops, depth, width, depth / 3, width / 3)
                    table.insert(addprops,
                        { name = "pig_ruins_light_beam", x_offset = depth / 3, z_offset = width / 3, addtags = { "localtrap" } })
                end
                if math.random() < 0.3 then
                    addprops = spawnspeartrapset(addprops, depth, width, -depth / 3, 0)
                    table.insert(addprops,
                        { name = "pig_ruins_light_beam", x_offset = -depth / 3, addtags = { "localtrap" } })
                elseif math.random() < 0.5 then
                    addprops = spawnspeartrapset(addprops, depth, width, 0, 0)
                    table.insert(addprops,
                        { name = "pig_ruins_light_beam", addtags = { "localtrap" } })
                else
                    addprops = spawnspeartrapset(addprops, depth, width, depth / 3, 0)
                    table.insert(addprops,
                        { name = "pig_ruins_light_beam", x_offset = depth / 3, addtags = { "localtrap" } })
                end
            elseif speartraps[random] == "bait" then
                local baits = {
                    { "goldnugget", 5 }, { "rocks", 20 }, { "flint", 20 }, { "redgem", 1 }, { "relic_1", 1 }, { "relic_2", 1 }, { "relic_3", 1 }, { "boneshard", 5 }, { "meat_dried", 5 }, }
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
                        { name = "pig_ruins_pressure_plate", x_offset = 0 + choicex, z_offset = 0 + choicez, addtags = { "trap_spear", "localtrap", "reversetrigger", "startdown" } })
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
                table.insert(addprops, { name = "relic_1", z_offset = 0 })
                table.insert(addprops, { name = "pig_ruins_light_beam", z_offset = 0 })
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
                    { name = "pig_ruins_light_beam", x_offset = depth / 2.5, z_offset = -width / 2.5, addtags = { "localtrap" } })
                addprops = spawnspeartrapset(addprops, depth, width, depth / 6, -width / 2.7, nil, nil, nil, nil, true)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = depth / 6, z_offset = -width / 2.5, addtags = { "localtrap" } })
                --        addprops = spawnspeartrapset(addprops, depth, width, 0, -width/2.5)
                --      table.insert(addprops, { name = "pig_ruins_light_beam",  z_offset =  -width/2.5, addtags={"localtrap"}} )
                addprops = spawnspeartrapset(addprops, depth, width, -depth / 6, -width / 2.7, nil, nil, nil, nil, true)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = -depth / 6, z_offset = -width / 2.5, addtags = { "localtrap" } })
                addprops = spawnspeartrapset(addprops, depth, width, -depth / 2.7, -width / 2.7)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = -depth / 2.5, z_offset = -width / 2.5, addtags = { "localtrap" } })
                addprops = spawnspeartrapset(addprops, depth, width, depth / 2.5, -width / 6, nil, nil, nil, nil, true)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = depth / 2.5, z_offset = -width / 6, addtags = { "localtrap" } })
                addprops = spawnspeartrapset(addprops, depth, width, depth / 6, -width / 6)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = depth / 6, z_offset = -width / 6, addtags = { "localtrap" } })
                addprops = spawnspeartrapset(addprops, depth, width, 0, -width / 6, nil, nil, nil, nil, true)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", z_offset = -width / 6, addtags = { "localtrap" } })
                addprops = spawnspeartrapset(addprops, depth, width, -depth / 6, -width / 6)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = -depth / 6, z_offset = -width / 6, addtags = { "localtrap" } })
                addprops = spawnspeartrapset(addprops, depth, width, -depth / 2.5, -width / 6, nil, nil, nil, nil, true)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = -depth / 2.5, z_offset = -width / 6, addtags = { "localtrap" } })
                --      addprops = spawnspeartrapset(addprops, depth, width, depth/2.5, 0)
                --      table.insert(addprops, { name = "pig_ruins_light_beam", x_offset = depth/2.5, z_offset =  0, addtags={"localtrap"}} )
                addprops = spawnspeartrapset(addprops, depth, width, depth / 6, 0, nil, nil, nil, nil, true)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = depth / 6, addtags = { "localtrap" } })
                addprops = spawnspeartrapset(addprops, depth, width, 0, 0)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", addtags = { "localtrap" } })
                addprops = spawnspeartrapset(addprops, depth, width, -depth / 6, 0, nil, nil, nil, nil, true)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = -depth / 6, addtags = { "localtrap" } })
                --      addprops = spawnspeartrapset(addprops, depth, width, -depth/2.5, 0)
                --      table.insert(addprops, { name = "pig_ruins_light_beam", x_offset = -depth/2.5,  addtags={"localtrap"}} )
                addprops = spawnspeartrapset(addprops, depth, width, depth / 2.5, width / 6, nil, nil, nil, nil, true)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = depth / 2.5, z_offset = width / 6, addtags = { "localtrap" } })
                addprops = spawnspeartrapset(addprops, depth, width, depth / 6, width / 6)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = depth / 6, z_offset = width / 6, addtags = { "localtrap" } })
                addprops = spawnspeartrapset(addprops, depth, width, 0, width / 6, nil, nil, nil, nil, true)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", z_offset = width / 6, addtags = { "localtrap" } })
                addprops = spawnspeartrapset(addprops, depth, width, -depth / 6, width / 6)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = -depth / 6, z_offset = width / 6, addtags = { "localtrap" } })
                addprops = spawnspeartrapset(addprops, depth, width, -depth / 2.5, width / 6, nil, nil, nil, nil, true)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = -depth / 2.5, z_offset = width / 6, addtags = { "localtrap" } })
                addprops = spawnspeartrapset(addprops, depth, width, depth / 2.7, width / 2.7)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = depth / 2.5, z_offset = width / 2.5, addtags = { "localtrap" } })
                addprops = spawnspeartrapset(addprops, depth, width, depth / 6, width / 2.7, nil, nil, nil, nil, true)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = depth / 6, z_offset = width / 2.5, addtags = { "localtrap" } })
                --        addprops = spawnspeartrapset(addprops, depth, width, 0, width/2.5)
                --      table.insert(addprops, { name = "pig_ruins_light_beam",  z_offset = width/2.5, addtags={"localtrap"}} )
                addprops = spawnspeartrapset(addprops, depth, width, -depth / 6, width / 2.7, nil, nil, nil, nil, true)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = -depth / 6, z_offset = width / 2.5, addtags = { "localtrap" } })
                addprops = spawnspeartrapset(addprops, depth, width, -depth / 2.7, width / 2.7)
                table.insert(addprops,
                    { name = "pig_ruins_light_beam", x_offset = -depth / 2.5, z_offset = width / 2.5, addtags = { "localtrap" } })
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
                table.insert(addprops {
                    name = "pig_ruins_pigman_relief_dart" .. math.random(4) .. room.color,
                    x_offset = -depth / 2,
                    z_offset = -width / 3
                })
                if northexitopen then
                    table.insert(addprops,
                        { name = "pig_ruins_pigman_relief_dart" .. math.random(4) .. room.color, x_offset = -depth / 2, z_offset = 0 })
                end
                table.insert(addprops, {
                    name = "pig_ruins_pigman_relief_dart" .. math.random(4) .. room.color,
                    x_offset = -depth / 2,
                    z_offset = width / 3
                })
                table.insert(addprops, {
                    name = "pig_ruins_pigman_relief_leftside_dart" .. room.color,
                    x_offset = -depth / 4 + (math.random() * 1 - 0.5),
                    z_offset = -width / 2
                })
                if westexitopen then
                    table.insert(addprops, {
                        name = "pig_ruins_pigman_relief_leftside_dart" .. room.color,
                        x_offset = 0 + (math.random() * 1 - 0.5),
                        z_offset = -width / 2
                    })
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
                    addtags = { "trap_dart" }
                })
                table.insert(addprops, {
                    name = "pig_ruins_pressure_plate",
                    x_offset = 0 + (math.random(2) - 1),
                    z_offset = 0 + (math.random() * 2 - 1),
                    addtags = { "trap_dart" }
                })
                if southexitopen then
                    table.insert(addprops, {
                        name = "pig_ruins_pressure_plate",
                        x_offset = depth / 6 * 2 + (math.random() * 2 - 1),
                        z_offset = 0 + (math.random() * 2 - 1),
                        addtags = { "trap_dart" }
                    })
                end
                table.insert(addprops, {
                    name = "pig_ruins_pressure_plate",
                    x_offset = -depth / 6 * 2 + (math.random() * 2 - 1),
                    z_offset = -width / 6 * 2 + (math.random() * 2 - 1),
                    addtags = { "trap_dart" }
                })
                table.insert(addprops, {
                    name = "pig_ruins_pressure_plate",
                    x_offset = (math.random() * 2 - 1),
                    z_offset = -width / 6 * 2 + (math.random() * 2 - 1),
                    addtags = { "trap_dart" }
                })
                table.insert(addprops, {
                    name = "pig_ruins_pressure_plate",
                    x_offset = -depth / 6 * 2 + (math.random() * 2 - 1),
                    z_offset = width / 6 * 2 + (math.random() * 2 - 1),
                    addtags = { "trap_dart" }
                })
                table.insert(addprops, {
                    name = "pig_ruins_pressure_plate",
                    x_offset = depth / 6 * 2 + (math.random() * 2 - 1),
                    z_offset = -width / 6 * 2 + (math.random() * 2 - 1),
                    addtags = { "trap_dart" }
                })
                table.insert(addprops, {
                    name = "pig_ruins_pressure_plate",
                    x_offset = (math.random() * 2 - 1),
                    z_offset = width / 6 * 2 + (math.random() * 2 - 1),
                    addtags = { "trap_dart" }
                })
                table.insert(addprops, {
                    name = "pig_ruins_pressure_plate",
                    x_offset = depth / 6 * 2 + (math.random() * 2 - 1),
                    z_offset = width / 6 * 2 + (math.random() * 2 - 1),
                    addtags = { "trap_dart" }
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
                                addtags = { tags }
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
                        flip = true
                    })
                    if eastexitopen then
                        table.insert(addprops, { name = "pig_ruins_torch_sidewall" .. room.color, x_offset = 0 - 0.5, z_offset = width / 2, flip = true })
                    end
                    table.insert(addprops, {
                        name = "pig_ruins_torch_sidewall" .. room.color,
                        x_offset = depth / 3 - 0.5,
                        z_offset = width / 2,
                        flip = true
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
                    { name = "deco_ruins_corner_tree", x_offset = -depth / 2, z_offset = width / 2, flip = true })
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
        props_by_room[room] = { addprops = addprops }
    end

    for i, room in ipairs(rooms) do
        local floortexture = "levels/textures/interiors/ground_ruins_slab.tex"
        local walltexture = "levels/textures/interiors/pig_ruins_panel.tex"
        local minimaptexture = "levels/textures/map_interior/mini_ruins_slab.tex"
        if room.color == "_blue" then
            floortexture = "levels/textures/interiors/ground_ruins_slab_blue.tex"
            walltexture = "levels/textures/interiors/pig_ruins_panel_blue.tex"
            for i, exit in pairs(room.exits) do
                if exit.build == "pig_ruins_door" then
                    exit.build = "pig_ruins_door_blue" --把隔壁房间的门也换成蓝色的
                end
            end
        end

        interior_spawner:CreateRoom("generic_interior", width, nil, depth, dungeondef.name, room.idx,
            props_by_room[room].addprops, room.exits, walltexture, floortexture, minimaptexture, nil,
            "images/colour_cubes/pigshop_interior_cc.tex", nil, nil, "ruins", "RUINS", "STONE")
    end
    return entranceRoom, exitRoom
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
local function refreshImage(inst, push)
    local anim = "idle_closed"
    if inst.stage == 2 then
        anim = "idle_med"
    elseif inst.stage == 1 then
        anim = "idle_low"
    elseif inst.stage == 0 then
        anim = "idle_open"
    end
    if inst:HasTag("top_ornament") then
        inst.AnimState:AddOverrideBuild("pig_ruins_entrance_top_build")
        inst.AnimState:Hide("swap_ornament2")
        inst.AnimState:Hide("swap_ornament3")
        inst.AnimState:Hide("swap_ornament4")
    elseif inst:HasTag("top_ornament2") then
        inst.AnimState:AddOverrideBuild("pig_ruins_entrance_top_build")
        inst.AnimState:Hide("swap_ornament3")
        inst.AnimState:Hide("swap_ornament4")
        inst.AnimState:Hide("swap_ornament")
    elseif inst:HasTag("top_ornament3") then
        inst.AnimState:AddOverrideBuild("pig_ruins_entrance_top_build")
        inst.AnimState:Hide("swap_ornament2")
        inst.AnimState:Hide("swap_ornament4")
        inst.AnimState:Hide("swap_ornament")
    elseif inst:HasTag("top_ornament4") then
        inst.AnimState:AddOverrideBuild("pig_ruins_entrance_top_build")
        inst.AnimState:Hide("swap_ornament2")
        inst.AnimState:Hide("swap_ornament3")
        inst.AnimState:Hide("swap_ornament")
    else
        inst.AnimState:Hide("swap_ornament4")
        inst.AnimState:Hide("swap_ornament3")
        inst.AnimState:Hide("swap_ornament2")
        inst.AnimState:Hide("swap_ornament")
        inst.AnimState:OverrideSymbol("statue_01", "pig_ruins_entrance", "")
        inst.AnimState:OverrideSymbol("swap_ornament", "pig_ruins_entrance", "")
    end
    if push then
        inst.AnimState:PushAnimation(anim, true)
    else
        inst.AnimState:PlayAnimation(anim, true)
    end
end
local function onhit(inst, worker)
    if inst.stage == 3 then
        inst.AnimState:PlayAnimation("hit_closed")
    elseif inst.stage == 2 then
        inst.AnimState:PlayAnimation("hit_med")
    elseif inst.stage == 1 then
        inst.AnimState:PlayAnimation("hit_low")
    end
    refreshImage(inst, true)
end
local function onsave(inst, data)
    data.stage = inst.stage
    data.hackeable = inst.components.hackable.canbehacked
    if inst:HasTag("top_ornament") then
        data.top_ornament = true
    end
    if inst:HasTag("top_ornament2") then
        data.top_ornament2 = true
    end
    if inst:HasTag("top_ornament3") then
        data.top_ornament3 = true
    end
end
local function onload(inst, data)
    if data then
        if data.stage then
            inst.stage = data.stage
        end
        if data.hackable then
            inst.components.hackable.canbehacked = data.hackeable
        end
        if data.top_ornament then
            inst:AddTag("top_ornament")
        end
        if data.top_ornament2 then
            inst:AddTag("top_ornament2")
        end
        if data.top_ornament3 then
            inst:AddTag("top_ornament3")
        end
    end
    refreshImage(inst)
end
local function onhackedfn(inst, hacker, hacksleft)
    if hacksleft <= 0 then
        if inst.stage > 0 then
            inst.stage = inst.stage - 1
            if inst.stage == 0 then
                inst.components.hackable.canbehacked = false
                inst.components.door:checkDisableDoor(false, "vines")
            else
                inst.components.hackable.hacksleft = inst.components.hackable.maxhacks
            end
        end
    end
    local fx = SpawnPrefab("hacking_fx")
    local x, y, z = inst.Transform:GetWorldPosition()
    fx.Transform:SetPosition(x, y + math.random() * 2, z)
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/vine_hack")
    onhit(inst, hacker)
end
local function initmaze(inst, dungeonname)
    if inst.components.entitytracker:GetEntity("interior_center") then
        return
    end
    local dungeondef = {
        name        = dungeonname,
        rooms       = 24,
        lock        = true,
        doorvines   = 0.3,
        deepruins   = true,
        secretrooms = 2,
    }
    if dungeonname == "RUINS_2" then
        dungeondef.rooms = 15
        dungeondef.doorvines = 0.6
    elseif dungeonname == "RUINS_3" then
        dungeondef.rooms = 15
        dungeondef.nosecondexit = true
    elseif dungeonname == "RUINS_4" then
        dungeondef.rooms = 20
        dungeondef.doorvines = 0.4
    elseif dungeonname == "RUINS_5" then
        dungeondef.rooms = 30
        dungeondef.doorvines = 0.6
        dungeondef.nosecondexit = true
    elseif dungeonname == "RUINS_SMALL" then
        local interiorspawner = TheWorld.components.tropical_interiorspawner
        dungeondef.name = "RUINS_SMALL" .. (interiorspawner.count + 1)
        dungeondef.rooms = math.random(6, 8)
        dungeondef.nosecondexit = true
        dungeondef.lock = nil
        dungeondef.doorvines = nil
        dungeondef.deepruins = nil
        dungeondef.secretrooms = 1
        dungeondef.smallsecret = true
    end
    local entranceRoom, exitRoom = mazemaker(dungeondef)
    local interior_spawner = GetWorld().components.interiorspawner
    local exterior_door_def = {
        my_door_id = dungeondef.name .. "_ENTRANCE1",
        target_door_id = dungeondef.name .. "_EXIT1",
        target_interior = entranceRoom.idx,
    }
    interior_spawner:AddDoor(inst, exterior_door_def)
    local exit_door = nil
    for i, ent in pairs(Ents) do
        if ent:HasTag(dungeondef.name .. "_EXIT_TARGET") then
            exit_door = ent
        end
    end
    if exit_door and exitRoom then
        -- CREATE 2nd DOOR
        local exterior_door_def2 = {
            my_door_id = dungeondef.name .. "_ENTRANCE2",
            target_door_id = dungeondef.name .. "_EXIT2",
            target_interior = exitRoom.idx,
        }
        interior_spawner:AddDoor(exit_door, exterior_door_def2)
    end
    refreshImage(inst)
end
local function makefn(build_interiors, dungeonname)
    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddLight()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
        local minimap = inst.entity:AddMiniMapEntity()
        minimap:SetIcon("pig_ruins_entrance.png")
        MakeObstaclePhysics(inst, 1.20)
        inst.AnimState:SetBank("pig_ruins_entrance")
        inst.AnimState:SetBuild("pig_ruins_entrance_build")
        inst.AnimState:PlayAnimation("idle_closed", true)
        if dungeonname == "RUINS_1" then
            inst:AddTag("top_ornament")
        elseif dungeonname == "RUINS_2" then
            inst:AddTag("top_ornament2")
        elseif dungeonname == "RUINS_3" then
            inst:AddTag("top_ornament3")
        elseif dungeonname == "RUINS_4" or dungeonname == "RUINS_5" then
            inst:AddTag("top_ornament4")
        end
        inst:AddTag(dungeonname .. "_EXIT_TARGET")
        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent("hackable")
        inst.components.hackable:SetUp()
        inst.components.hackable.onhackedfn = onhackedfn
        inst.components.hackable.hacksleft = TUNING.RUINS_ENTRANCE_VINES_HACKS
        inst.components.hackable.maxhacks = TUNING.RUINS_ENTRANCE_VINES_HACKS
        inst:AddComponent("shearable")
        inst:AddComponent("inspectable")
        inst.components.inspectable.getstatus = getstatus
        inst:AddComponent("entitytracker")
        build_interiors = false -- TODO 删除
        if build_interiors then
            -- this prefab is the entrance. Makes the maze
            inst.stage = 3
            -- spread out the maze gen for less hiccup at load time.
            inst:DoTaskInTime(0, function()
                initmaze(inst, dungeonname)
            end)
        else
            -- this prefab is an exit. Just set the door and art
            inst.stage = 0
            inst.components.hackable.canbehacked = false
            refreshImage(inst)
        end
        if dungeonname == "RUINS_SMALL" then
            inst.stage = 0
            inst.components.hackable.canbehacked = false
            refreshImage(inst)
        end
        MakeSnowCovered(inst, .01)
        inst.OnSave = onsave
        inst.OnLoad = onload
        return inst
    end
    return fn
end
return Prefab("pig_ruins_entrance", makefn(true, "RUINS_1"), assets, prefabs),
    Prefab("pig_ruins_exit", makefn(false, "RUINS_1"), assets, prefabs),
    Prefab("pig_ruins_entrance2", makefn(true, "RUINS_2"), assets, prefabs),
    Prefab("pig_ruins_exit2", makefn(false, "RUINS_2"), assets, prefabs),
    Prefab("pig_ruins_entrance3", makefn(true, "RUINS_3"), assets, prefabs),
    Prefab("pig_ruins_entrance4", makefn(true, "RUINS_4"), assets, prefabs),
    Prefab("pig_ruins_exit4", makefn(false, "RUINS_4"), assets, prefabs),
    Prefab("pig_ruins_entrance5", makefn(true, "RUINS_5"), assets, prefabs),
    Prefab("pig_ruins_entrance_small", makefn(true, "RUINS_SMALL"), assets, prefabs)
