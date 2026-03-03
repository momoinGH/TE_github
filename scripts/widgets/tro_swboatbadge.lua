local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"

-- 海难小船血条
local SWBoatBadge = Class(Badge, function(self, owner)
    Badge._ctor(self, "boat_health", owner)

    self.boat = nil
    self.health_percent = nil
    self.on_boat_healthchange_fn = function(boat) self:OnBoatHealthChange() end

    self.boatarrow = self.underNumber:AddChild(UIAnim())
    self.boatarrow:GetAnimState():SetBank("sanity_arrow")
    self.boatarrow:GetAnimState():SetBuild("sanity_arrow")
    self.boatarrow:GetAnimState():PlayAnimation("neutral")
    self.boatarrow:SetClickable(false)

    self.num:SetSize(40)

    self:SetScale(1.3)
end)

function SWBoatBadge:OnBoatHealthChange()
    local new_health_percent = self.boat.components.healthsyncer:GetPercent()
    local max_health = self.boat.components.healthsyncer.max_health
    self:SetPercent(new_health_percent, max_health)

    if self.health_percent then
        if new_health_percent > self.health_percent then
            self:PulseGreen()
        elseif new_health_percent < self.health_percent then
            self:PulseRed()
        end
    end
    self.health_percent = new_health_percent

    if new_health_percent <= .25 then
        self:StartWarning()
    else
        self:StopWarning()
    end
end

function SWBoatBadge:SetBoat(boat)
    local old_boat = self.boat
    if old_boat and old_boat:IsValid() then
        self.inst:RemoveEventCallback("healthpctdirty", self.on_boat_healthchange_fn, old_boat)
        self:StopUpdating()
    end

    self.boat = boat
    self.health_percent = nil
    if boat then
        self:StartUpdating()
        self.inst:ListenForEvent("healthpctdirty", self.on_boat_healthchange_fn, boat)
        self:OnBoatHealthChange()
    end
end

local RATE_SCALE_ANIM =
{
    [RATE_SCALE.INCREASE_HIGH] = "arrow_loop_increase_most",
    [RATE_SCALE.INCREASE_MED] = "arrow_loop_increase_more",
    [RATE_SCALE.INCREASE_LOW] = "arrow_loop_increase",
    [RATE_SCALE.DECREASE_HIGH] = "arrow_loop_decrease_most",
    [RATE_SCALE.DECREASE_MED] = "arrow_loop_decrease_more",
    [RATE_SCALE.DECREASE_LOW] = "arrow_loop_decrease",
}

function SWBoatBadge:OnUpdate(dt)
    local ratescale = self.boat.components.healthsyncer:GetOverTime() or 0
    local anim = "neutral"
    if ratescale == RATE_SCALE.INCREASE_LOW or
        ratescale == RATE_SCALE.INCREASE_MED or
        ratescale == RATE_SCALE.INCREASE_HIGH then
        anim = RATE_SCALE_ANIM[ratescale]
    elseif ratescale == RATE_SCALE.DECREASE_LOW or
        ratescale == RATE_SCALE.DECREASE_MED or
        ratescale == RATE_SCALE.DECREASE_HIGH then
        anim = RATE_SCALE_ANIM[ratescale]
    end

    if anim and self.arrowdir ~= anim then
        self.arrowdir = anim
        self.boatarrow:GetAnimState():PlayAnimation(anim, true)
    end
end

return SWBoatBadge
