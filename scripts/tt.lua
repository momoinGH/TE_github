-- 动态加载开发
print("加载小地图文件")

local Widget = require "widgets/widget"
local Image = require "widgets/image"
local MINIMAP_DEFS = require("tro_minimapdefs")
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
local function DrawPassage(self, door, width, depth)
    local ratio = width / depth
    local dir = door.GetDoorOrientation and door:GetDoorOrientation()
    if dir then
        local dx, dy, rotate
        local d = RoomUtils.GetOrientationByLabel(dir)
        dx = d.x * (depth / 2 * ratio + 12)
        dy = d.y * (width / 2 + 6)
        if dir == "north" or dir == "south" then
            rotate = 90
        end

        local passage = AddImage(self, "levels/textures/tro_map_interior/passage.xml", "passage.tex", dx, dy)
        if rotate then
            passage:SetRotation(rotate)
        end
    else
        TroErrorHandle("有个门没有方向，无法显示小地图" .. tostring(door), false, false)
    end
end

local function AppendRoomTexture(self, room)
    local width = room.room_width:value() --z
    local depth = room.room_depth:value() --x
    local ratio = width / depth           --长宽比，小房子会更长点

    local rx, _, rz = room.Transform:GetWorldPosition()

    local room_node = self:AddChild(Widget("ROOT"))
    self._tro_houseimags[room] = room_node
    -- room_node:SetPosition(rz - z, rx - x)

    --地板
    for j = -1, 1 do
        for i = -1, 1 do
            print("地板位置", j * 6.4 * ratio, i * 6.4)
            AddImage(room_node, "levels/textures/tro_map_interior/mini_ruins_slab.xml", "mini_ruins_slab.tex",
                j * 6.4 * ratio, i * 6.4,
                1.02 * ratio, 1.02)
        end
    end

    --房间边框
    AddImage(room_node, "levels/textures/tro_map_interior/frame.xml", "frame.tex", 0, 0, ratio, 1)
    -- frame.inst.ImageWidget:SetBlendMode(BLENDMODE.Additive)

    --把房间里所有有小地图图标的画出来
    local room_ents = RoomUtils.FindRoomEnts(room)
    for _, v in ipairs(room_ents) do
        local icon = MINIMAP_DEFS[v.prefab]
        if icon then
            local vx, _, vz = v.Transform:GetWorldPosition()
            if math.abs(vx - rx) <= depth / 2 and math.abs(vz - rz) <= width / 2 then --在房间里
                AddImage(room_node, icon.atlas, icon.tex, (vz - rz) * ratio, rx - vx) --相对房子偏移
            end
        end
    end

    --检查该房间的门，构建其他房间图片
    for _, v in ipairs(room_ents) do
        if v:HasTag("interior_door") then
            local targetdoor = v.targetdoor and v.targetdoor:value()
            local nearroom = targetdoor and targetdoor:GetRoomCenter()
            print("检查房间的门", room, v, targetdoor, nearroom)
            if nearroom and not self._tro_houseimags[nearroom] then --应该不可能
                -- 绘制旁边的房间
                local dir = v.GetDoorOrientation and v:GetDoorOrientation()
                if dir then
                    local nearroom_node = AppendRoomTexture(self, nearroom)
                    local d = RoomUtils.GetOrientationByLabel(dir)
                    -- nearroom_node:SetPosition(d.x * ratio * 20, d.y * 20)
                    for _, c in pairs(nearroom_node.children) do
                        local ox, oy = c:GetPositionXYZ()
                        c:SetPosition(ox + d.x * (depth * ratio + 20) * WORLD_TO_MAP_SCALE, oy + d.y * (width + 12) * WORLD_TO_MAP_SCALE)
                    end
                end

                -- 绘制房间和房间间的箭头
                DrawPassage(self, v, width, depth)
            end
        end
    end

    return room_node
end



return AppendRoomTexture
