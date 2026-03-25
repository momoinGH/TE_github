-- 动态加载开发，功能开发完再删掉
print("加载小地图文件")

local Widget = require "widgets/widget"
local Image = require "widgets/image"
local MINIMAP_DEFS = require("tro_roomminimapdefs")
local RoomUtils = require("tropical_utils/room_utils")

-- 拟定的房子大小
local WORLD_TO_MAP_SCALE = 10
local function AddImage(root, atlas, tex, x, y, scale_x, scale_y)
    local img = root:AddChild(Image(atlas, tex))
    img:SetHAnchor(ANCHOR_MIDDLE)
    img:SetVAnchor(ANCHOR_MIDDLE)
    img:SetPosition(x * WORLD_TO_MAP_SCALE, y * WORLD_TO_MAP_SCALE)
    img._tro_pos = Vector3(x * WORLD_TO_MAP_SCALE, y * WORLD_TO_MAP_SCALE, 0)
    if scale_x or scale_y then
        img:SetScale(scale_x or 1, scale_y, 1)
    end
    return img
end

-- 绘制房间和房间间的箭头
local function DrawPassage(self, door, width, depth, room_offset_x, room_offset_y)
    local ratio = width / depth
    local dir = door.GetDoorOrientation and door:GetDoorOrientation()
    if dir then
        local dx, dy, rotate
        local d = RoomUtils.DIR[dir]
        dx = d.y * (depth / 2 * ratio + 12)
        dy = -d.x * (width / 2 + 6)
        if dir == "north" or dir == "south" then
            rotate = 90
        end

        local passage = AddImage(self, "levels/textures/tro_map_interior/passage.xml", "passage.tex", room_offset_x + dx, room_offset_y + dy)
        if rotate then
            passage:SetRotation(rotate)
        end
    else
        TroErrorHandle("有个门没有方向，无法显示小地图" .. tostring(door), false, false)
    end
end

local AppendRoomTexture

-- 绘制附近的房间
local function DrawNearbyRoom(self, door, near_room, width, depth, room_offset_x, room_offset_y)
    local ratio = width / depth
    local dir = door.GetDoorOrientation and door:GetDoorOrientation()
    if dir then
        local d = RoomUtils.DIR[dir]

        local new_room_offset_x = room_offset_x + d.y * (depth * ratio + 24)
        local nw_room_offset_y = room_offset_y - d.x * (width + 12)
        local nearroom_root = AppendRoomTexture(self, near_room, new_room_offset_x, nw_room_offset_y)
    end
end

--- BFS绘制房间
--- 以相对坐标决定绘制的坐标，需要注意的是x差值和z差值对应的是image的y和x，而且使用RoomUtils.DIR时别忘了房子的坐标轴和image坐标轴的转换
AppendRoomTexture = function(self, start_room, room_offset_x, room_offset_y)
    local width = start_room.room_width:value() --z
    local depth = start_room.room_depth:value() --x
    local ratio = width / depth                 --长宽比，小房子会更长点
    local room_grid, start_x, start_y = RoomUtils.GetCurrentRoomsGrid(start_room)
    for grid_x, row in ipairs(room_grid) do
        for grid_y, room in ipairs(row) do
            if room then
                room_offset_x = (grid_y - start_y) * (width * ratio + 24)
                room_offset_y = (start_x - grid_x) * (depth + 20)


                local rx, _, rz = room.Transform:GetWorldPosition()

                local room_root = self:AddChild(Widget("ROOT"))
                self._tro_houseimags[room] = room_root
                -- room_node:SetPosition(room_offset_x, room_offset_y)--修改父对象坐标好像不会影响子坐标

                --地板
                for j = -1, 1 do
                    for i = -1, 1 do
                        AddImage(room_root, "levels/textures/tro_map_interior/mini_ruins_slab.xml", "mini_ruins_slab.tex",
                            room_offset_x + j * 6.4 * ratio, room_offset_y + i * 6.4,
                            1.02 * ratio, 1.02)
                    end
                end

                --房间边框
                AddImage(room_root, "levels/textures/tro_map_interior/frame.xml", "frame.tex", room_offset_x, room_offset_y, ratio, 1)
                -- frame.inst.ImageWidget:SetBlendMode(BLENDMODE.Additive)

                --把房间里所有有小地图图标的画出来
                local player_image = {}
                local room_ents = RoomUtils.FindRoomEnts(room)
                for _, v in ipairs(room_ents) do
                    local icon = v.tro_minimap_icon
                    local atlas = icon and GetMinimapAtlas(icon) --找到图集才显示
                    if atlas then
                        local vx, _, vz = v.Transform:GetWorldPosition()
                        local x = room_offset_x + (vz - rz) * ratio * 1.4 --稍微远离中心点一点
                        local y = room_offset_y + (rx - vx) * 1.4
                        local image = AddImage(room_root, atlas, icon, x, y)
                        if v:HasTag("player") then
                            table.insert(player_image, image)
                        end
                    end
                end
                for _, image in ipairs(player_image) do
                    image:MoveToFront() --玩家图片要放在最前面
                end

                -- TODO 接口不知道房间连通性
                --上
                local up_room = room_grid[grid_x - 1] and room_grid[grid_x - 1][grid_y]
                if up_room then
                    -- DrawPassage(self, v, width, depth, room_offset_x, room_offset_y)
                end


                --检查该房间的门，构建其他房间图片
                -- for _, v in ipairs(room_ents) do
                --     if v:HasTag("interior_door") then
                --         local targetdoor = v.targetdoor and v.targetdoor:value()
                --         local near_room = targetdoor and targetdoor:GetRoomCenter()
                --         print("检查房间的门", room, v, targetdoor, near_room)
                --         if near_room and not self._tro_houseimags[near_room] then --应该不可能
                --             -- 绘制旁边的房间
                --             DrawNearbyRoom(self, v, near_room, width, depth, room_offset_x, room_offset_y)

                --             -- 绘制房间和房间间的箭头
                --             DrawPassage(self, v, width, depth, room_offset_x, room_offset_y)
                --         end
                --     end
                -- end
            end
        end
    end
end



return AppendRoomTexture


--[[
-- 动态加载开发，功能开发完再删掉
print("加载小地图文件")

local Widget = require "widgets/widget"
local Image = require "widgets/image"
local MINIMAP_DEFS = require("tro_roomminimapdefs")
local RoomUtils = require("tropical_utils/room_utils")

-- 拟定的房子大小
local WORLD_TO_MAP_SCALE = 10
local function AddImage(root, atlas, tex, x, y, scale_x, scale_y)
    local img = root:AddChild(Image(atlas, tex))
    img:SetHAnchor(ANCHOR_MIDDLE)
    img:SetVAnchor(ANCHOR_MIDDLE)
    img:SetPosition(x * WORLD_TO_MAP_SCALE, y * WORLD_TO_MAP_SCALE)
    img._tro_pos = Vector3(x * WORLD_TO_MAP_SCALE, y * WORLD_TO_MAP_SCALE, 0)
    if scale_x or scale_y then
        img:SetScale(scale_x or 1, scale_y, 1)
    end
    return img
end

-- 绘制房间和房间间的箭头
local function DrawPassage(self, door, width, depth, room_offset_x, room_offset_y)
    local ratio = width / depth
    local dir = door.GetDoorOrientation and door:GetDoorOrientation()
    if dir then
        local dx, dy, rotate
        local d = RoomUtils.DIR[dir]
        dx = d.y * (depth / 2 * ratio + 12)
        dy = -d.x * (width / 2 + 6)
        if dir == "north" or dir == "south" then
            rotate = 90
        end

        local passage = AddImage(self, "levels/textures/tro_map_interior/passage.xml", "passage.tex", room_offset_x + dx, room_offset_y + dy)
        if rotate then
            passage:SetRotation(rotate)
        end
    else
        TroErrorHandle("有个门没有方向，无法显示小地图" .. tostring(door), false, false)
    end
end

local AppendRoomTexture

-- 绘制附近的房间
local function DrawNearbyRoom(self, door, near_room, width, depth, room_offset_x, room_offset_y)
    local ratio = width / depth
    local dir = door.GetDoorOrientation and door:GetDoorOrientation()
    if dir then
        local d = RoomUtils.DIR[dir]

        local new_room_offset_x = room_offset_x + d.y * (depth * ratio + 24)
        local nw_room_offset_y = room_offset_y - d.x * (width + 12)
        local nearroom_root = AppendRoomTexture(self, near_room, new_room_offset_x, nw_room_offset_y)
    end
end

--- BFS绘制房间
--- 以相对坐标决定绘制的坐标，需要注意的是x差值和z差值对应的是image的y和x，而且使用RoomUtils.DIR时别忘了房子的坐标轴和image坐标轴的转换
AppendRoomTexture = function(self, room, room_offset_x, room_offset_y)
    room_offset_x = room_offset_x or 0
    room_offset_y = room_offset_y or 0

    local width = room.room_width:value() --z
    local depth = room.room_depth:value() --x
    local ratio = width / depth           --长宽比，小房子会更长点

    local rx, _, rz = room.Transform:GetWorldPosition()

    local room_root = self:AddChild(Widget("ROOT"))
    self._tro_houseimags[room] = room_root
    -- room_node:SetPosition(room_offset_x, room_offset_y)--修改父对象坐标好像不会影响子坐标

    --地板
    for j = -1, 1 do
        for i = -1, 1 do
            AddImage(room_root, "levels/textures/tro_map_interior/mini_ruins_slab.xml", "mini_ruins_slab.tex",
                room_offset_x + j * 6.4 * ratio, room_offset_y + i * 6.4,
                1.02 * ratio, 1.02)
        end
    end

    --房间边框
    AddImage(room_root, "levels/textures/tro_map_interior/frame.xml", "frame.tex", room_offset_x, room_offset_y, ratio, 1)
    -- frame.inst.ImageWidget:SetBlendMode(BLENDMODE.Additive)

    --把房间里所有有小地图图标的画出来
    local player_image = {}
    local room_ents = RoomUtils.FindRoomEnts(room)
    for _, v in ipairs(room_ents) do
        local icon = v.tro_minimap_icon
        local atlas = icon and GetMinimapAtlas(icon) --找到图集才显示
        if atlas then
            local vx, _, vz = v.Transform:GetWorldPosition()
            local x = room_offset_x + (vz - rz) * ratio * 1.4 --稍微远离中心点一点
            local y = room_offset_y + (rx - vx) * 1.4
            local image = AddImage(room_root, atlas, icon, x, y)
            if v:HasTag("player") then
                table.insert(player_image, image)
            end
        end
    end
    for _, image in ipairs(player_image) do
        image:MoveToFront() --玩家图片要放在最前面
    end

    --检查该房间的门，构建其他房间图片
    for _, v in ipairs(room_ents) do
        if v:HasTag("interior_door") then
            local targetdoor = v.targetdoor and v.targetdoor:value()
            local near_room = targetdoor and targetdoor:TroGetRoomCenter()
            print("检查房间的门", room, v, targetdoor, near_room)
            if near_room and not self._tro_houseimags[near_room] then --应该不可能
                -- 绘制旁边的房间
                DrawNearbyRoom(self, v, near_room, width, depth, room_offset_x, room_offset_y)

                -- 绘制房间和房间间的箭头
                DrawPassage(self, v, width, depth, room_offset_x, room_offset_y)
            end
        end
    end

    return room_root
end



return AppendRoomTexture

]]
