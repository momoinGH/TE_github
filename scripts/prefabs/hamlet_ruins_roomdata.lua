local RoomUtils = require("tropical_utils/room_utils")

local Rooms = Class(function(self)
    self.rooms = {}

    local start_room = self:AddRoom(0, 0, nil, { RoomUtils.DIR.north }) --遗迹入口位于0,0
    start_room.is_entrance = true
    start_room.entrance1 = true                                         --表示遗迹出口一所在房间
end)

-- 房间数量
function Rooms:GetCount()
    return #self.rooms
end

-- 房间出口数量
function Rooms:GetRoomExitCount(idx)
    local room = self.rooms[idx]
    local total = table.count(room.exits)
    if room.is_entrance then
        total = total + 1
    end
    return total
end

function Rooms:AddRoom(x, y, exits, blocked_exits)
    local room = {
        x = x,                               --房间坐标
        y = y,
        idx = #self.rooms + 1,               --房间编号，生成房间时会根据这个来判断什么房间相邻，生成对应的门，这里是rooms的索引
        exits = exits or {},                 --表示这个房间可以通向哪些房间
        blocked_exits = blocked_exits or {}, --被堵塞的方向，表示上面不能建造门
        -- is_entrance = nil --这个房间是否是出口
    }
    table.insert(self.rooms, room)
    return room
end

function Rooms:SetRoomExit(from_idx, dir_label, to_idx)
    local from_room = self.rooms[from_idx]
    from_room.exits[RoomUtils.DIR[dir_label]] = {
        room = from_idx,
        target_room = to_idx,
    }
    local to_room = self.rooms[to_idx]
    to_room.exits[RoomUtils.DIR_OPPOSITE[dir_label]] = {
        room = to_idx,
        target_room = from_idx,
    }
end

-- 构建指定数量的房间
function Rooms:CreateRandomRooms(rooms_to_make)
    local DIR = RoomUtils.DIR

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
function Rooms:SelectEntranceRoom(entrance_id)
    local choices = {}
    local min_dist = 0
    for i, room in ipairs(self.rooms) do
        local north_exit_open = not room.exits[RoomUtils.DIR.north]
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

return Rooms
