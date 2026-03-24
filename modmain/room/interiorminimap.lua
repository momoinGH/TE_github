for _, asset in ipairs({
    -- 虚空小地图使用
    Asset("ATLAS", "levels/textures/tro_map_interior/exit.xml"),
    Asset("ATLAS", "levels/textures/tro_map_interior/frame.xml"),
    Asset("ATLAS", "levels/textures/tro_map_interior/passage_blocked.xml"),
    Asset("ATLAS", "levels/textures/tro_map_interior/passage_unknown.xml"),
    Asset("ATLAS", "levels/textures/tro_map_interior/passage.xml"),

    Asset("ATLAS", "levels/textures/tro_map_interior/mini_antcave_floor.xml"),
    Asset("ATLAS", "levels/textures/tro_map_interior/mini_floor_marble_royal.xml"),
    Asset("ATLAS", "levels/textures/tro_map_interior/mini_ruins_slab.xml"),
    Asset("ATLAS", "levels/textures/tro_map_interior/mini_vamp_cave_noise.xml"),
}) do
    table.insert(Assets, asset)
end


----------------------------------------------------------------------------------------------------
local RoomUtils = require("tropical_utils/room_utils")

local function UpdateTextureBefore(self)
    if not ThePlayer then return end
    local x, y, z = ThePlayer.Transform:GetWorldPosition()
    if z < RoomUtils.BASE_OFF then return end --TODO

    self._tro_pos = self._tro_pos or Vector3(x, y, z)

    -- 清除之前的图片
    for _, v in pairs(self._tro_houseimags) do
        v:Kill()
    end
    self._tro_houseimags = {}

    -- 从玩家所在房间开始计算
    local room = TheWorld.Map:TroGetRoomCenter(x, y, z)
    if room then
        package.loaded.tt = nil
        local AppendRoomTexture = require("tt")
        AppendRoomTexture(self, room)
        -- local x, _, z = ThePlayer.Transform:GetWorldPosition()
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

local function SetDragPosition(self, x, y, z)
    local pos
    if type(x) == "number" then
        pos = Vector3(x, y, 0)
    else
        pos = x
    end
    pos = pos + self.dragPosDiff
    for _, v in pairs(self._tro_houseimags) do
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

    for _, v in pairs(self._tro_houseimags) do
        v._tro_pos = v:GetPosition()
    end
end


AddClassPostConstruct("widgets/mapwidget", function(self)
    self._tro_houseimags = {}
    self._tro_offset = { 0, 0 }

    Hooks.FnDecorator(self, "UpdateTexture", UpdateTextureBefore)

    -- Hooks.FnDecorator(self, "OnControl", OnControlBefore)
    -- self.SetDragPosition = SetDragPosition
    -- self.StartDrag = StartDrag
    -- self.EndDrag = EndDrag
end)
