local RoomUtils = require("tropical_utils/room_utils")
local DIR = RoomUtils.DIR
local DIR_OPPOSITE = RoomUtils.DIR_OPPOSITE

---迷宫生成器
---主要维护一个rooms表，并提供一些辅助函数
local MazeBuilder = Class(function(self)
    self.rooms = {}

    -- 支持索引访问rooms里的room，比如room_data[2]就是room_data.rooms[2]
    local mt = getmetatable(self) or {}
    local old_index = mt.__index
    mt.__index = function(t, key)
        if type(key) == "number" then
            if key >= 1 and key <= #t.rooms then
                return t.rooms[key]
            end
            return nil
        else
            -- 回退到原有的 __index
            if type(old_index) == "function" then --虽然我知道class的就是函数
                return old_index(t, key)
            elseif type(old_index) == "table" then
                return old_index[key]
            end
            return nil
        end
    end
    setmetatable(self, mt)

    --房间默认大小
    self.width = TUNING.ROOM_MEDIUM_WIDTH
    self.depth = TUNING.ROOM_MEDIUM_DEPTH

    self.props_radius = {}        --物品半径表，标识物品的占地范围，这个范围内不会塞入其他东西了
    self.rooms_obstacle_grid = {} --每个房间被占用区域

    -- 这里默认第一个房间是出口1，房间位置为0,0
    local start_room = self:AddRoom(0, 0, nil, { DIR.north })
    start_room.is_entrance = true
    start_room.entrance1 = true
end)

function MazeBuilder:SetAllRoomsSize(width, depth)
    self.width = width
    self.depth = depth
    for _, room in ipairs(self.rooms) do
        room.width = width
        room.depth = depth
    end
end

-- 房间数量
function MazeBuilder:GetCount()
    return #self.rooms
end

-- 房间出口数量
function MazeBuilder:GetRoomExitCount(idx)
    local room = self.rooms[idx]
    local total = table.count(room.exits)
    if room.is_entrance then
        total = total + 1
    end
    return total
end

function MazeBuilder:AddRoom(x, y, exits, blocked_exits)
    local room = {
        width = self.width,
        depth = self.depth,
        x = x,                               --房间坐标
        y = y,
        idx = #self.rooms + 1,               --房间编号，生成房间时会根据这个来判断什么房间相邻，生成对应的门，这里是rooms的索引
        exits = exits or {},                 --表示这个房间可以通向哪些房间
        blocked_exits = blocked_exits or {}, --被堵塞的方向，表示上面不能建造门
        addprops = {},
        -- is_entrance = nil --这个房间是否是出口
        -- entrance1 = nil --这个房间是否是出口1，还可以有entrance2、entrance3
    }
    table.insert(self.rooms, room)
    return room
end

function MazeBuilder:SetRoomExit(from_idx, dir_label, to_idx)
    local from_room = self.rooms[from_idx]
    local to_room = self.rooms[to_idx]

    local dir = DIR[dir_label]
    local opposite_dir = DIR_OPPOSITE[dir_label]
    trodevassert(not table.contains(from_room.blocked_exits, dir), string.trofmt("{}门{}方向在阻挡列表里，你却添加了出口\n{}", from_idx, dir_label, PrintTable(from_room)))
    trodevassert(not table.contains(to_room.blocked_exits, opposite_dir), string.trofmt("{}门{}方向在阻挡列表里，你却添加了出口\n{}", to_idx, opposite_dir.label, PrintTable(to_room)))

    from_room.exits[dir] = {
        room = from_idx,
        target_room = to_idx,
    }
    to_room.exits[opposite_dir] = {
        room = to_idx,
        target_room = from_idx,
    }
end

function MazeBuilder:GetRoomExit(idx, dir_label)
    local room = self.rooms[idx]
    return room.exits[DIR[dir_label]]
end

-- 构建指定数量的房间
function MazeBuilder:CreateRandomRooms(rooms_to_make)
    while self:GetCount() < rooms_to_make do
        -- 从现有房间里随机选择一个房间作为前置房间，然后在前置房间随机选择一个方向
        local dir_choice = RoomUtils.GetRandomDir()
        local fromroom = self.rooms[math.random(#self.rooms)]
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
            for i, checkroom in ipairs(self.rooms) do
                if checkroom.x == fromroom.x + DIR[dir_choice].x
                    and checkroom.y == fromroom.y + DIR[dir_choice].y
                then
                    fail = true
                    break
                end
            end
        end
        if not fail then
            local newroom = self:AddRoom(fromroom.x + DIR[dir_choice].x, fromroom.y + DIR[dir_choice].y)
            self:SetRoomExit(fromroom.idx, dir_choice, newroom.idx)
        end
    end
end

-- 遍历所有房间，查找那些顶部没有房间并且距离出口一房间最远的房间，查找结果随机选择一个作为遗迹出口二所在房间
function MazeBuilder:SelectEntranceRoom(entrance_id)
    assert(entrance_id > 1)

    local choices = {}
    local min_dist = 0
    for i, room in ipairs(self.rooms) do
        local north_exit_open = not room.exits[DIR.north]
        local dist = math.abs(room.x) + math.abs(room.y)
        if not room.is_entrance and north_exit_open and dist >= min_dist then
            if dist > min_dist then
                choices = {}
            end
            table.insert(choices, room)
            min_dist = dist
        end
    end
    if #choices > 0 then
        local entrance_room = choices[math.random(#choices)]
        entrance_room["entrance" .. entrance_id] = true
        entrance_room.is_entrance = true
        return entrance_room
    end
    return nil
end

-- 这个坐标是否有空间生成房间
function MazeBuilder:CheckFreeGridPos(x, y)
    for i, room in ipairs(self.rooms) do
        if room.x == x and room.y == y then
            return false
        end
    end
    return true
end

----------------------------------------------------------------------------------------------------
-- 设置prop的半径表，当这个位置有prop时这附近不能生成别的东西了
function MazeBuilder:SetPropsRadius(props_radius)
    self.props_radius = props_radius
end

local GRID_SIZE = 0.5 --0.5长度为一个格子

local function UpdatePropObstacle(self, idx, prop, prop_index)
    local radius = self.props_radius[prop.name]
    if not radius then return end --不算占地

    local room = self.rooms[idx]
    local obstacle_grid = self.rooms_obstacle_grid[idx]
    if not obstacle_grid then
        obstacle_grid = {}
        local cols = math.floor(room.depth / GRID_SIZE)
        local rows = math.floor(room.width / GRID_SIZE)
        for x = 1, cols do
            local row = {}
            for z = 1, rows do
                row[z] = 0
            end
            obstacle_grid[x] = row
        end
        self.rooms_obstacle_grid[idx] = obstacle_grid
    end

    --左下角为坐标原点，映射到grid索引（索引从1开始）
    local vx = (prop.x_offset or 0) + room.depth / 2
    local vz = (prop.z_offset or 0) + room.width / 2

    --直接计算受影响的索引范围，不遍历全网格
    local x_min = math.max(1, math.floor((vx - radius) / GRID_SIZE) + 1)
    local x_max = math.min(#obstacle_grid, math.ceil((vx + radius) / GRID_SIZE))
    local z_min = math.max(1, math.floor((vz - radius) / GRID_SIZE) + 1)
    local z_max = math.min(#obstacle_grid[1], math.ceil((vz + radius) / GRID_SIZE))

    for x = x_min, x_max do
        for z = z_min, z_max do
            obstacle_grid[x][z] = prop_index --这个东西占据了这个格子
        end
    end
end

local function IsInObstacle(self, idx, x_offset, z_offset, radius)
    local obstacle_grid = self.rooms_obstacle_grid[idx]
    if not obstacle_grid then
        return false --还没有障碍物网格，说明没有任何障碍物
    end

    local room = self.rooms[idx]
    radius = radius or 0

    --左下角为坐标原点，映射到grid索引（索引从1开始）
    local vx = (x_offset or 0) + room.depth / 2
    local vz = (z_offset or 0) + room.width / 2

    local x_min = math.max(1, math.floor((vx - radius) / GRID_SIZE) + 1)
    local x_max = math.min(#obstacle_grid, math.ceil((vx + radius) / GRID_SIZE))
    local z_min = math.max(1, math.floor((vz - radius) / GRID_SIZE) + 1)
    local z_max = math.min(#obstacle_grid[1], math.ceil((vz + radius) / GRID_SIZE))

    for x = x_min, x_max do
        for z = z_min, z_max do
            if obstacle_grid[x][z] ~= 0 then
                return true, obstacle_grid[x][z] --返回true和占据该格子的prop索引
            end
        end
    end

    return false
end

-- 房间里加点东西
function MazeBuilder:AddRoomProp(idx, prop)
    local room = self.rooms[idx]
    if type(prop) == "string" then
        prop = { name = prop } --是一个预制件，位于中间
    end
    table.insert(room.addprops, prop)

    -- 更新障碍表
    UpdatePropObstacle(self, idx, prop, #room.addprops)

    return prop
end

-- 房间内部随机位置加点东西
function MazeBuilder:AddRomPropAtInside(idx, prop, count)
    for i = 1, count or 1 do
        local w = self.width - 1 --离墙壁点距离
        local d = self.depth - 1

        local new_prop
        if type(prop) == "string" then
            new_prop = { name = prop }
        else
            new_prop = shallowcopy(prop) --放置后面往prop里塞什么字段
        end

        local x_offset, z_offset
        local attempt_count = 10 --尝试次数
        while true do
            x_offset = (math.random() * d) - (d / 2)
            z_offset = (math.random() * w) - (w / 2)
            if not IsInObstacle(self, idx, x_offset, z_offset, self.props_radius[new_prop.name]) then
                break
            end
            attempt_count = attempt_count - 1
            if attempt_count <= 0 then
                return nil --放置失败了
            end
        end

        new_prop.x_offset = x_offset
        new_prop.z_offset = z_offset
        return self:AddRoomProp(idx, new_prop)
    end
end

-- 房间墙上加点东西
function MazeBuilder:AddRomPropAtWall(idx, prop, dir_label, offset)
    local room = self.rooms[idx]
    local dir = DIR[dir_label]
    assert(room)
    assert(dir)

    offset = offset or 0
    local x_offset = dir.x * room.depth / 2
    local z_offset = dir.y * room.width / 2

    if dir_label == "north" then
        z_offset = offset
    elseif dir_label == "south" then
        z_offset = offset
    elseif dir_label == "west" then
        x_offset = offset
    elseif dir_label == "east" then
        x_offset = offset
    end
    if type(prop) == "string" then
        prop = { name = prop }
    end
    prop.x_offset = x_offset
    prop.z_offset = z_offset
    return self:AddRoomProp(idx, prop)
end

return MazeBuilder
