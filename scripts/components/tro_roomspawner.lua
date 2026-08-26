local RoomUtils = require("tro_utils/room_utils")

local ROOM_GAP = RoomUtils.ROOM_GAP
-- The engine's default render-culling extents become unreliable for off-map
-- entities at large coordinates and different camera angles. Keep rooms inside
-- a conservative range instead of relying on a single observed cutoff.
local MAX_ROOM_COORD = RoomUtils.MAX_COORD

-- 虚空小房子计数器，计数会一直递增，即便前面生成的房子已经销毁
-- 这是一个主客机都有的组件，主机只需要保存count保证count递增，主客机都会构建rooms结构
local RoomSpawner = Class(function(self, inst)
    self.inst = inst

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
                    local near_room = near_door:TroGetRoomCenter()
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

-- Allocate rooms on a bounded perimeter outside the generated world.  The old
-- layout only moved toward +x/+z, so enough rooms eventually crossed the renderer
-- coordinate range (especially with the world-size multiplier enabled).
function RoomSpawner:GetPos()
    local width, height = TheWorld.Map:GetWorldSize()
    local world_radius = math.max(width, height) / 2 * 4
    local base_off = world_radius + 100
    local max_coord = MAX_ROOM_COORD - ROOM_GAP / 2
    if base_off > max_coord then
        print(string.format("[tro_roomspawner] world edge %.1f exceeds safe coordinate range %.1f", base_off, max_coord))
        base_off = max_coord
    end

    local ring_extent = base_off
    -- Each side excludes its ending corner; the following side owns that corner.
    local side_count = math.floor((ring_extent * 2) / ROOM_GAP)
    local perimeter_count = side_count * 4
    local x, z
    for attempt = 0, perimeter_count - 1 do
        local candidate = (self.count + attempt) % perimeter_count
        local side = math.floor(candidate / side_count) % 4
        local offset = candidate % side_count
        local p = -ring_extent + offset * ROOM_GAP
        if side == 0 then
            x, z = ring_extent, p
        elseif side == 1 then
            x, z = ring_extent - offset * ROOM_GAP, ring_extent
        elseif side == 2 then
            x, z = -ring_extent, ring_extent - offset * ROOM_GAP
        else
            x, z = -ring_extent + offset * ROOM_GAP, -ring_extent
        end

        if #TheSim:FindEntities(x, 0, z, ROOM_GAP * 0.45, { "interior_center" }) <= 0 then
            self.count = self.count + attempt + 1
            return Vector3(x, 0, z)
        end
    end

    print("[tro_roomspawner] no free room position inside the safe coordinate range")
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
