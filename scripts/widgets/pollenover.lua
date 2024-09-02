local UIAnim = require "widgets/uianim"

--- 花粉症
local Pollenover = Class(UIAnim, function(self, owner)
    self.owner = owner
    UIAnim._ctor(self, "Pollenover")

    self:SetHAnchor(ANCHOR_MIDDLE)
    self:SetVAnchor(ANCHOR_MIDDLE)
    self:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)

    self:GetAnimState():SetBank("vagner_over")
    self:GetAnimState():SetBuild("vagner_over")
    self:Hide()

    owner:ListenForEvent("leveldirty", function() self:OnLevelDirty() end)
end)

function Pollenover:OnLevelDirty()
    local level = self.owner.replica.hayfever and self.owner.replica.hayfever:GetLevel() or 0
    local anim = level == 1 and "polenfraco"
        or level == 2 and "polenfraco1"
        or level == 3 and "polenfraco2"
        or level == 4 and "polenforte"
        or nil

    if anim then
        self:GetAnimState():PlayAnimation(anim, true)
        self:Show()
    else
        self:Hide()
    end
end

return Pollenover
