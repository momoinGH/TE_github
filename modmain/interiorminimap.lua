local Utils = require("tropical_utils/utils")
local Image = require "widgets/image"
local MINIMAP_DEFS = require("tro_minimapdefs")
local InteriorSpawnerUtils = require("interiorspawnerutils")
local Widget = require "widgets/widget"

-- 拟定的房子大小
local WORLD_TO_MAP_SCALE = 10

local function AddImage(self, atlas, tex, x, y, scale_x, scale_y)
    local img = self:AddChild(Image(atlas, tex))
    img:SetHAnchor(ANCHOR_MIDDLE)
    img:SetVAnchor(ANCHOR_MIDDLE)
    img:SetPosition(x * WORLD_TO_MAP_SCALE, y * WORLD_TO_MAP_SCALE)
    img._tro_pos = Vector3(x * WORLD_TO_MAP_SCALE, y * WORLD_TO_MAP_SCALE, 0)
    if scale_x or scale_y then
        img:SetScale(scale_x or 1, scale_y, 1)
    end
    table.insert(self._tro_houseimags, img)
    return img
end

local function AppendRoomTexture(self, room)
    local width = room.room_width:value() --z
    local depth = room.room_depth:value() --x
    local ratio = width / depth           --长宽比，小房子会更长点

    local x, _, z = ThePlayer.Transform:GetWorldPosition()
    local rx, _, rz = room.Transform:GetWorldPosition()

    --地板
    for j = -1, 1 do
        for i = -1, 1 do
            AddImage(self, "levels/textures/tro_map_interior/mini_ruins_slab.xml", "mini_ruins_slab.tex",
                rz - z + j * 6.4 * ratio, rx - x + i * 6.4,
                1.02 * ratio, 1.02)
        end
    end

    --房间边框
    AddImage(self, "levels/textures/tro_map_interior/frame.xml", "frame.tex", rz - z, rx - x, ratio, 1)
    -- frame.inst.ImageWidget:SetBlendMode(BLENDMODE.Additive)

    --把房间里所有有小地图图标的画出来
    for _, v in ipairs(TheSim:FindEntities(rx, 0, rz, math.sqrt(depth * depth + width * width) / 2)) do
        local icon = MINIMAP_DEFS[v.prefab]
        if icon then
            local vx, _, vz = v.Transform:GetWorldPosition()
            if math.abs(vx - rx) <= depth / 2 and math.abs(vz - rz) <= width / 2 then              --在房间里
                AddImage(self, icon.atlas, icon.tex, (vz - rz) * ratio + rz - z, rx - vx + rx - x) --相对房子偏移
            end
        end
    end

    --检查该房间的门，构建其他房间图片
    for _, v in ipairs(TheSim:FindEntities(rx, 0, rz, math.sqrt(depth * depth + width * width) / 2, { "interior_door" })) do
        local targetdoor = v.targetdoor and v.targetdoor:value()
        local nearroom = targetdoor and targetdoor.interior_center and targetdoor.interior_center:value()
        print("构建相邻房间", v, targetdoor, nearroom)
        if nearroom and nearroom ~= room then  --应该不可能
            AppendRoomTexture(self, nearroom)
        end
    end
end

local function UpdateTextureBefore(self)
    if not ThePlayer then return end
    local x, y, z = ThePlayer.Transform:GetWorldPosition()
    if z < InteriorSpawnerUtils.BASE_OFF then return end --TODO

    self._tro_pos = self._tro_pos or Vector3(x, y, z)

    -- 清除之前的图片
    for _, v in ipairs(self._tro_houseimags) do
        v:Kill()
    end
    self._tro_houseimags = {}

    -- 从玩家所在房间开始计算
    local room = TheWorld.Map:TroGetRoomCenter(x, y, z)
    if room then
        AppendRoomTexture(self, room)
    end

    return nil, true
end


----------------------------------------------------------------------------------------------------
-- 拖拽

local function OnControlBefore(self, control, down)
    if control == CONTROL_ACCEPT then
        if down then
            self:StartDrag()
        else
            self:EndDrag()
        end
    end
end

TUNING.TT = 6
local function SetDragPosition(self, x, y, z)
    local pos
    if type(x) == "number" then
        pos = Vector3(x, y, 0)
    else
        pos = x
    end
    pos = pos + self.dragPosDiff
    for _, v in ipairs(self._tro_houseimags) do
        v:SetPosition(v._tro_pos + pos)
    end
end

local function StartDrag(self)
    if not self.followhandler then
        local mousepos = TheInput:GetScreenPosition()
        self.dragPosDiff = (self:GetPosition() - mousepos)
        self.followhandler = TheInput:AddMoveHandler(function(x, y)
            self:SetDragPosition(x, y)
        end)
        self:SetDragPosition(mousepos)
    end
end

local function EndDrag(self)
    if self.followhandler then
        self.followhandler:Remove()
    end
    self.followhandler = nil
    self.dragPosDiff = nil

    for _, v in ipairs(self._tro_houseimags) do
        v._tro_pos = v:GetPosition()
    end
end


AddClassPostConstruct("widgets/mapwidget", function(self)
    self._tro_houseimags = {}
    self._tro_offset = { 0, 0 }

    Utils.FnDecorator(self, "UpdateTexture", UpdateTextureBefore)

    Utils.FnDecorator(self, "OnControl", OnControlBefore)
    self.SetDragPosition = SetDragPosition
    self.StartDrag = StartDrag
    self.EndDrag = EndDrag
end)
