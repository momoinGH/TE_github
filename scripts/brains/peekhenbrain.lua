--[[

    Buzzards will only eat food laying on the ground already. They will not harvest food.

    Buzzard spawner looks for food nearby and spawns buzzards on top of it.
    Buzzard spawners also randomly spawn/ call back buzzards so they have a presence in the world.

    When buzzards have food on the ground they'll land on it and consume it, then hang around as a normal creature.
    If the buzzard notices food while wandering the world, it will hop towards the food and eat it.


    If attacked while eating, the buzzard will remain near it's food and defend it.
    If attacked while wandering the world, the buzzard will fly away.

--]]

require("stategraphs/commonstates")
require("behaviours/standandattack")
require("behaviours/wander")

local PeekhenBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local SEE_FOOD_DIST = 15

local ONE_TAGS = { "eyebush" }
local NO_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO" }

local function IsThreatened(inst)
    local busy = inst.sg:HasStateTag("sleeping") or inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("flying")
    if not busy then
        local threat = FindEntity(inst, 7.5, nil, nil, { 'notarget' }, { 'player', 'monster', 'scarytoprey' })
        return threat ~= nil
    end
end

local function DealWithThreat(inst)
    --If you have some food then defend it! Otherwise... cheese it!
    local hasFood = false
    local hasBush = false
    local pt = inst:GetPosition()
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 5.5, nil, NO_TAGS, ONE_TAGS)

    for k, v in pairs(ents) do
        if v and v:IsOnValidGround() and inst.components.eater:CanEat(v)
            and v.components.inventoryitem and not v.components.inventoryitem:IsHeld() then
            hasFood = true
            break
        end
    end

    for k, v in pairs(ents) do
        if v and v:IsOnValidGround() and v:HasTag("eyebush") and not v.prism then
            hasBush = true
            break
        end
    end


    if hasFood or hasBush then
        local threat = FindEntity(inst, 7.5, nil, nil, { 'notarget', 'peekhen' }, { 'player', 'monster', 'scarytoprey' })
        if threat and not inst.components.combat:TargetIs(threat) then
            inst.components.locomotor:Stop()
            inst:ClearBufferedAction()
            inst.components.combat:SetTarget(threat)
        end
    else
        inst.shouldGoAway = true
    end
end

local function PickEyebushAction(inst) --Look for food to eat
    local target = nil
    local action = nil

    if inst.sg:HasStateTag("busy") then
        return
    end

    local pt = inst:GetPosition()
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, SEE_FOOD_DIST, { "eyebush" }, NO_TAGS)

    if not target then
        for k, v in pairs(ents) do
            if v and v:IsOnValidGround() and not v.prism then
                target = v
                break
            end
        end
    end

    if target then
        local action = BufferedAction(inst, target, ACTIONS.PICK)
        return action
    end
end

local FINDFOOD_CANT_TAGS = { "outofreach" }
local function EatFoodAction(inst) --Look for food to eat
    local target = FindEntity(inst,
        SEE_FOOD_DIST,
        function(item)
            return item:GetTimeAlive() >= 8
                and item.prefab ~= "mandrake"
                and item.components.edible ~= nil
                and item:IsOnPassablePoint()
                and inst.components.eater:CanEat(item)
        end,
        nil,
        FINDFOOD_CANT_TAGS
    )
    if target ~= nil then
        return BufferedAction(inst, target, ACTIONS.EAT)
    end
end

local function GoHome(inst)
    if inst.shouldGoAway then
        return BufferedAction(inst, nil, ACTIONS.GOHOME)
    end
end

function PeekhenBrain:OnStart()
    local root = PriorityNode(
        {
            WhileNode(function() return not self.inst.sg:HasStateTag("flying") end, "Not Flying",
                PriorityNode {
                    WhileNode(function() return self.inst.shouldGoAway end, "Go Away",
                        DoAction(self.inst, GoHome)),

                    StandAndAttack(self.inst),
                    IfNode(function() return IsThreatened(self.inst) end, "Threat Near",
                        ActionNode(function() return DealWithThreat(self.inst) end)),
                    DoAction(self.inst, PickEyebushAction),
                    DoAction(self.inst, EatFoodAction),
                    Wander(self.inst, function() return self.inst:GetPosition() end, 5)
                })

        }, .25)

    self.bt = BT(self.inst, root)
end

return PeekhenBrain
