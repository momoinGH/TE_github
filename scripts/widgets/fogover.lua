local Widget = require "widgets/widget"
local Image = require "widgets/image"

local FogOver = Class(Widget, function(self, owner)
    self.owner = owner
    Widget._ctor(self, "FogOver")
    self:SetClickable(false)

    self.bg2 = self:AddChild(Image("images/overlays/fog.xml", "fog_over.tex"))
    self.bg2:SetVRegPoint(ANCHOR_MIDDLE)
    self.bg2:SetHRegPoint(ANCHOR_MIDDLE)
    self.bg2:SetVAnchor(ANCHOR_MIDDLE)
    self.bg2:SetHAnchor(ANCHOR_MIDDLE)
    self.bg2:SetScaleMode(SCALEMODE_FILLSCREEN)

    self.alpha = 0
    self.alphagoal = 0
    self.transitiontime = 2.0
    self.time = self.transitiontime

    self:Hide()
end)

function FogOver:OnFogStateChange()
    local in_fog = self.owner:TroInHamletFog()
    if in_fog then
        self:StartFog()
    else
        self:StopFog()
    end
end

function FogOver:StartFog()
    if not self.foggy then
        self.time = self.transitiontime
        self.alphagoal = 1
        self.foggy = true

        self:StartUpdating()
        self:Show()
    end
end

-- function FogOver:SetFog()
--     if not self.foggy then
--         self.time = 0
--         self.alphagoal = 1
--         self.foggy = true
--         self.alpha = 1
--         self:StartUpdating()
--         self:Show()
--     end
-- end

function FogOver:StopFog()
    if self.foggy then
        self.time = self.transitiontime
        self.alphagoal = 0
        self.foggy = false
    end
end

function FogOver:UpdateAlpha(dt)
    if self.alphagoal ~= self.alpha then
        if self.time > 0 then
            self.time = math.max(0, self.time - dt)
            if self.alphagoal < self.alpha then
                self.alpha = Remap(self.time, self.transitiontime, 0, 1, 0)
            else
                self.alpha = Remap(self.time, self.transitiontime, 0, 0, 1)
            end
        end
    end
end

function FogOver:OnUpdate(dt)
    self:UpdateAlpha(dt)

    if TroCanResistHamletFog(self.owner) then
        self:Hide()
    else
        self:Show()
    end

    self.bg2:SetTint(1, 1, 1, self.alpha)
    if self.alpha == 0 and self.alphagoal == 0 then
        self:Hide()
        self:StopUpdating()
    end
end

return FogOver
