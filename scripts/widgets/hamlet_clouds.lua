local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"

local Clouds = Class(UIAnim, function(self, owner)
    self.owner = owner
    UIAnim._ctor(self)

    self:SetClickable(false)

    self:SetHAnchor(ANCHOR_MIDDLE)
    self:SetVAnchor(ANCHOR_MIDDLE)
    self:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)

    self:GetAnimState():SetBank("vagner_over")
    self:GetAnimState():SetBuild("vagner_over")
    self:GetAnimState():PlayAnimation("polenfraco", true)

    self:StartUpdating()
    self:Hide()
    self.speed = false
    self.hayfever = 0
    self.neblina = 0
    self.ash = false
end)


function Clouds:OnUpdate(dt)
    -- --print(TheWorld.state.wetness)
    -- -------------------------------------fog---------------------------------------------
    -- local fanlimpador = GetClosestInstWithTag("prevents_hayfever", self.owner, 15)
    -- if (TheWorld.state.iswinter and TheWorld.state.precipitationrate > 0 and self.owner and self.owner.components.areaaware and self.owner.components.areaaware:CurrentlyInTag("hamlet") and TUNING.tropical.fog == 10) or
    --     (TheWorld.state.iswinter and TheWorld.state.precipitationrate > 0 and self.owner and self.owner.components.areaaware and self.owner.components.areaaware:GetCurrentArea() ~= nil and TUNING.tropical.fog == 20) then
    --     if fanlimpador then
    --         if self.neblina and self.neblina > 0 then self.neblina = self.neblina - 2 end
    --     else
    --         self.neblina = self.neblina + 1
    --     end
    --     if self.neblina and self.neblina < 1000 then
    --         self:GetAnimState():SetBank("vagner_over")
    --         self:GetAnimState():SetBuild("vagner_over")
    --         self:GetAnimState():PlayAnimation("foog_loop8", true)
    --         self:Hide()
    --     elseif self.neblina and self.neblina < 2000 then
    --         self:GetAnimState():SetBank("vagner_over")
    --         self:GetAnimState():SetBuild("vagner_over")
    --         self:GetAnimState():PlayAnimation("foog_loop8", true)
    --         self:Show()
    --     elseif self.neblina and self.neblina < 3000 then
    --         self:GetAnimState():SetBank("vagner_over")
    --         self:GetAnimState():SetBuild("vagner_over")
    --         self:GetAnimState():PlayAnimation("foog_loop7", true)
    --         self:Show()
    --     elseif self.neblina and self.neblina < 4000 then
    --         self:GetAnimState():SetBank("vagner_over")
    --         self:GetAnimState():SetBuild("vagner_over")
    --         self:GetAnimState():PlayAnimation("foog_loop6", true)
    --         self:Show()
    --     elseif self.neblina and self.neblina < 5000 then
    --         self:GetAnimState():SetBank("vagner_over")
    --         self:GetAnimState():SetBuild("vagner_over")
    --         self:GetAnimState():PlayAnimation("foog_loop5", true)
    --         self:Show()
    --     elseif self.neblina and self.neblina < 6000 then
    --         self:GetAnimState():SetBank("vagner_over")
    --         self:GetAnimState():SetBuild("vagner_over")
    --         self:GetAnimState():PlayAnimation("foog_loop4", true)
    --         self:Show()
    --     elseif self.neblina and self.neblina < 7000 then
    --         self:GetAnimState():SetBank("vagner_over")
    --         self:GetAnimState():SetBuild("vagner_over")
    --         self:GetAnimState():PlayAnimation("foog_loop3", true)
    --         self:Show()
    --     elseif self.neblina and self.neblina < 8000 then
    --         self:GetAnimState():SetBank("vagner_over")
    --         self:GetAnimState():SetBuild("vagner_over")
    --         self:GetAnimState():PlayAnimation("foog_loop2", true)
    --         self:Show()
    --     elseif self.neblina and self.neblina < 9000 then
    --         self:GetAnimState():SetBank("vagner_over")
    --         self:GetAnimState():SetBuild("vagner_over")
    --         self:GetAnimState():PlayAnimation("foog_loop1", true)
    --         self:Show()
    --     elseif self.neblina and self.neblina >= 9000 then
    --         self:GetAnimState():SetBank("vagner_over")
    --         self:GetAnimState():SetBuild("vagner_over")
    --         self:GetAnimState():PlayAnimation("foog_loop", true)
    --         self:Show()
    --     end
    -- end
end

return Clouds
