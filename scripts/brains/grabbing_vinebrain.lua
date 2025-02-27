require "behaviours/doaction"
require "behaviours/standandattack"
require "behaviours/standstill"

local GO_HOME_DIST = 1
local EAT_DIST = 0.5

local function GoHomeAction(inst)
    local homePos = inst.components.knownlocations:GetLocation("home")
    if homePos then
        return BufferedAction(inst, nil, ACTIONS.WALKTO, nil, homePos, nil, 0.2)
    end
end

local function ShouldGoHome(inst)
    local homePos = inst.components.knownlocations:GetLocation("home")
    return (homePos and distsq(homePos, inst:GetPosition()) > GO_HOME_DIST * GO_HOME_DIST) and not inst:HasTag("up")
end

local GrabbingvineBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local FINDFOOD_CANT_TAGS = { "outofreach" }
local function FoodNear(inst)
    return FindEntity(inst, 5, function(item)
            return item:GetTimeAlive() >= 8
                and item.components.edible ~= nil
                and item:IsOnPassablePoint()
                and inst.components.eater:CanEat(item)
        end,
        nil,
        FINDFOOD_CANT_TAGS
    )
end

local function GoEatFood(inst)
    if not inst:HasTag("up") then
        local target = inst.foodtarget
        if not target or not target:IsInLimbo() then
            target = FoodNear(inst)
        end
        if target and not target:IsInLimbo() then
            inst.foodtarget = target
            if targetpos and inst:GetDistanceSqToInst(target) > EAT_DIST * EAT_DIST then
                return BufferedAction(inst, nil, ACTIONS.WALKTO, nil, targetpos, nil, 0.2)
            else
                return BufferedAction(inst, target, ACTIONS.EAT)
            end
        end
    end
    return false
end

function GrabbingvineBrain:OnStart()
    --local clock = GetClock()

    local root = PriorityNode(
        {
            WhileNode(
                function()
                    return ((self.inst.foodtarget and not self.inst.foodtarget:IsInLimbo()) or FoodNear(self.inst)) and
                        not self.inst:HasTag("up")
                end, "GoEatFood",
                DoAction(self.inst, function() return GoEatFood(self.inst) end, "eat food", true)),
            WhileNode(function() return not self.inst:HasTag("up") end, "StandAndAttack",
                StandAndAttack(self.inst)),
            WhileNode(function() return ShouldGoHome(self.inst) end, "ShouldGoHome",
                DoAction(self.inst, function() return GoHomeAction(self.inst) end, "go home", true)),
            StandStill(self.inst, function() return self.inst.sg:HasStateTag("idle") end, nil),
        }, .25)

    self.bt = BT(self.inst, root)
end

return GrabbingvineBrain
