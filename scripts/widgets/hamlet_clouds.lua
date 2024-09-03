local UIAnim = require "widgets/uianim"

-- 哈姆雷特雾气
local Clouds = Class(UIAnim, function(self, owner)
    self.owner = owner
    UIAnim._ctor(self)

    self:SetClickable(false)

    self:SetHAnchor(ANCHOR_MIDDLE)
    self:SetVAnchor(ANCHOR_MIDDLE)
    self:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)

    self:GetAnimState():SetBank("vagner_over")
    self:GetAnimState():SetBuild("vagner_over")
    self:GetAnimState():PlayAnimation("foog_loop8", true)

    self:StartUpdating()
    self:Hide()
    self.neblina = 0
end)


function Clouds:OnUpdate(dt)
    if TheWorld.state.iswinter
        and TheWorld.state.precipitationrate > 0
        and (TUNING.tropical.fog == 20 or (TUNING.tropical.fog == 10 and self.owner.components.areaaware and self.owner.components.areaaware:CurrentlyInTag("hamlet")))
    then
        if GetClosestInstWithTag("prevents_hayfever", self.owner, 15) then
            self.neblina = math.max(self.neblina - 2, 0)
        else
            self.neblina = self.neblina + 1
        end

        if self.neblina < 1000 then
            self:Hide()
        else
            if self.neblina < 2000 then
                self:GetAnimState():PlayAnimation("foog_loop8", true)
            elseif self.neblina < 3000 then
                self:GetAnimState():PlayAnimation("foog_loop7", true)
            elseif self.neblina < 4000 then
                self:GetAnimState():PlayAnimation("foog_loop6", true)
            elseif self.neblina < 5000 then
                self:GetAnimState():PlayAnimation("foog_loop5", true)
            elseif self.neblina < 6000 then
                self:GetAnimState():PlayAnimation("foog_loop4", true)
            elseif self.neblina < 7000 then
                self:GetAnimState():PlayAnimation("foog_loop3", true)
            elseif self.neblina < 8000 then
                self:GetAnimState():PlayAnimation("foog_loop2", true)
            elseif self.neblina < 9000 then
                self:GetAnimState():PlayAnimation("foog_loop1", true)
            else
                self:GetAnimState():PlayAnimation("foog_loop", true)
            end
            self:Show()
        end
    end
end

return Clouds
