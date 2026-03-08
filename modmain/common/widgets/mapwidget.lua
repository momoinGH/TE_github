local Image = require "widgets/image"
local ANCHOR_MIDDLE = 0
local SCALEMODE_FILLSCREEN = 1

local BLENDMODE = {
    Disabled = 0,
    AlphaBlended = 1,
    Additive = 2,
    Premultiplied = 3,
    InverseAlpha = 4,
    AlphaAdditive = 5,
    VFXTest = 6,
}

local MAP_CONFIG = {
    shipwrecked = {
        bg_xml = "images/mapstyle/hud_shipwrecked.xml",
        bg_tex = "map_shipwrecked.tex"
    },
    hamlet = {
        bg_xml = "images/mapstyle/hud_hamlet.xml",
        bg_tex = "map_hamlet.tex"
    }, --[[
    [REGIONS.pigcity] = {
        bg_xml = "images/mapstyle/hud_pigcity.xml",
        bg_tex = "images/mapstyle/map_pigcity.tex"
    },]]
}

local function GetRegionMapBorder(player)
    if player:IsInShipwreckedArea() then
        return MAP_CONFIG.shipwrecked
    elseif player:IsInHamletArea() then
        return MAP_CONFIG.hamlet
    end
    return nil
end

--根据玩家所在区域修改地图边框
AddClassPostConstruct("widgets/mapwidget", function(self)
    local config = GetRegionMapBorder(ThePlayer)
    if not config then return end

    if self.bg then
        self.bg:Kill()
    end
    self.bg = self:AddChild(Image(config.bg_xml, config.bg_tex))
    self.bg:SetVRegPoint(ANCHOR_MIDDLE)
    self.bg:SetHRegPoint(ANCHOR_MIDDLE)
    self.bg:SetVAnchor(ANCHOR_MIDDLE)
    self.bg:SetHAnchor(ANCHOR_MIDDLE)
    self.bg:SetScaleMode(SCALEMODE_FILLSCREEN)
    self.bg.inst.ImageWidget:SetBlendMode(BLENDMODE.Premultiplied)

    self.minimap = TheWorld.minimap.MiniMap
    self.img = self:AddChild(Image())
    self.img:SetHAnchor(ANCHOR_MIDDLE)
    self.img:SetVAnchor(ANCHOR_MIDDLE)
    self.img.inst.ImageWidget:SetBlendMode(BLENDMODE.Additive)

    self.lastpos = nil
    self.minimap:ResetOffset()
    self:StartUpdating()
end)
