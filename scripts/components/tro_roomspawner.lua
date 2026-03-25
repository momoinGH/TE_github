local RoomUtils = require("tropical_utils/room_utils")

local BASE_OFF = RoomUtils.BASE_OFF + 100
local ROOM_GAP = RoomUtils.ROOM_GAP
local ROW_COUNT = RoomUtils.ROW_COUNT

local function OnRoomDoorCreate(inst, door)
    local room_center = door:GetRoomCenter()
    if not room_center then
        return
    end

    local self = inst.components.tro_roomspawner
    self:UpdateRoom(room_center)
end

local function OnRoomDoorRemove(inst, door)
    local self = inst.components.tro_roomspawner
    local room_center = door:GetRoomCenter()
    if room_center then
        self:UpdateRoom(room_center)
    end
end

local function OnRoomCreate(inst, room_center)
    local self = inst.components.tro_roomspawner
    self:UpdateRoom(room_center)
end

local function OnRoomRemove(inst, room_center)
    local self = inst.components.tro_roomspawner
    self:UpdateRoom(room_center)
end

-- 虚空小房子计数器，计数会一直递增，即便前面生成的房子已经销毁
-- 这是一个主客机都有的组件，主机只需要保存count保证count递增，主客机都会构建rooms结构
local RoomSpawner = Class(function(self, inst)
    self.inst = inst

    --所有房子结构图，记录每个房间各个方向通向哪里，主要用于新房间生成和地图显示，不应该太依赖这个，可能会更新不及时
    self.rooms = {
        -- [102707] = {
        --     north = 102707,
        --     south = 102707,
        --     west = 102707,
        --     east = 102707,
        --     entrance_door = 102707, 连通外部的入口
        -- }
    }

    inst:ListenForEvent("tro_onroomcreate", OnRoomCreate)
    inst:ListenForEvent("tro_onroomremove", OnRoomRemove)
    inst:ListenForEvent("tro_onroomdoorcreate", OnRoomDoorCreate)
    inst:ListenForEvent("tro_onroomdoorremove", OnRoomDoorRemove)

    if not TheWorld.ismastersim then return end

    self.count = 0 --小房子坐标计数器，主机数据
end)

function RoomSpawner:UpdateRoom(room)
    -- 房间被销毁
    if not room:IsValid() then
        self.rooms[room.GUID] = nil

        -- 检查和这个房间相连的
        for room_guid, data in pairs(self.rooms) do
            for dir, _ in pairs(RoomUtils.DIR) do
                if data[dir] == room.GUID then
                    data[dir] = nil
                end
                if data.entrance == room.GUID then
                    data.entrance = nil
                end
            end
        end
        return
    end

    self.rooms[room.GUID] = {} --重新计算

    --搜索这个房间内的所有门，检查这些门的对面有没有房间
    for _, door in ipairs(RoomUtils.FindRoomEnts(room, { "interior_door" })) do
        local near_door = door.targetdoor:value()
        if near_door then
            local nx, ny, nz = near_door.Transform:GetWorldPosition()
            if TheWorld.Map:TroIsWorldOut(nx, ny, nz) then
                -- 地图外的门
                local dir = door:GetDoorOrientation()
                if dir then
                    local near_room = near_door:GetRoomCenter()
                    if near_room then
                        self.rooms[room.GUID][dir] = near_room.GUID
                        self.rooms[near_room.GUID] = self.rooms[near_room.GUID] or {}
                        self.rooms[near_room.GUID][RoomUtils.DIR_OPPOSITE[dir].label] = room.GUID
                    end
                end
            else
                --在地图内的门，视为出口
                self.rooms[room.GUID].entrance_door = door.GUID
            end
        end
    end
end

function RoomSpawner:GetPos()
    local x = (self.count % ROW_COUNT) * ROOM_GAP - BASE_OFF
    local z = BASE_OFF + math.ceil(self.count / ROW_COUNT) * ROOM_GAP
    self.count = self.count + 1
    return Vector3(x, 0, z)
end

function RoomSpawner:OnSave()
    return {
        count = self.count,
    }
end

function RoomSpawner:OnLoad(data)
    if not data then return end
    self.count = data.count or self.count
end

local function group_rooms(rooms)
    local visited = {} -- 记录已访问的房间
    local groups = {}  -- 存储分组结果

    -- 递归DFS遍历连通分量
    local function dfs(room_id, group)
        visited[room_id] = true
        table.insert(group, room_id)

        local room = rooms[room_id]

        -- 检查四个方向
        for dir, _ in pairs(RoomUtils.DIR) do
            local neighbor = room[dir]
            if neighbor and neighbor ~= room_id then -- 如果邻居存在且不是自身（自环表示无连接）
                if not visited[neighbor] then
                    dfs(neighbor, group)
                end
            end
        end
    end

    -- 遍历所有房间，对每个未访问的房间启动DFS
    for room_id, _ in pairs(rooms) do
        if not visited[room_id] then
            local group = {}
            dfs(room_id, group)
            table.insert(groups, group)
        end
    end

    return groups
end

local function set_room_pos(self, room_group)
    local min_x, max_x, min_y, max_y = 0, 0, 0, 0
    local room_poses = { [room_group[1]] = { 0, 0 } }

    local function dfs(room_guid)
        local data = self.rooms[room_guid]
        local cur_x = room_poses[room_guid][1]
        local cur_y = room_poses[room_guid][2]
        for dir, _ in pairs(RoomUtils.DIR) do
            if data[dir] then
                if not room_poses[data[dir]] then
                    local x = cur_x + RoomUtils.DIR[dir].x
                    local y = cur_y + RoomUtils.DIR[dir].y
                    room_poses[data[dir]] = { x, y }
                    min_x = math.min(min_x, x)
                    max_x = math.max(max_x, x)
                    min_y = math.min(min_y, y)
                    max_y = math.max(max_y, y)
                    dfs(data[dir])
                end
            end
        end
    end
    dfs(room_group[1])

    local tab = {}
    for i = min_x, max_x do
        local row = {}
        for j = min_y, max_y do
            table.insert(row, 0)
        end
        table.insert(tab, row)
    end

    for room_guid, pos in pairs(room_poses) do
        local x = pos[1] - min_x + 1
        local y = pos[2] - min_y + 1
        tab[x][y] = room_guid
    end
    return tab
end

function RoomSpawner:GetDebugString()
    local room_groups = group_rooms(self.rooms)

    for i, room_group in ipairs(room_groups) do
        print("房间" .. i)
        local tab = set_room_pos(self, room_group)
        for x = 1, #tab do
            local s = ""
            for y = 1, #tab[x] do
                local guid = tab[x][y]
                local is_entrance = self.rooms[guid] and self.rooms[guid].entrance_door ~= nil
                s = s .. (guid == 0 and " 000000 " or (is_entrance and ("[" .. tostring(guid) .. "]") or (" " .. tostring(guid) .. " "))) .. "  "
            end
            print(s)
        end
    end
    return ""
end

return RoomSpawner
