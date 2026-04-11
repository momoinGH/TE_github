require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/minperiod"

local SEE_FOOD_DIST = 15
local SEE_STRUCTURE_DIST = 30

local NO_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO", "AQUATIC" }

local VALID_FOODS =
{
    "berries",
    "cave_banana",
    "carrot",
    "blue_cap",
    "green_cap",
    "seeds"
}


local function ItemIsInList(item, list)
    for k, v in pairs(list) do
        if v == item or k == item then
            return true
        end
    end
end

local FINDFOOD_CANT_TAGS = { "outofreach" }
local function EatFoodAction(inst) --Look for food to eat
    if inst.sg:HasStateTag("busy") and not
        inst.sg:HasStateTag("wantstoeat") then
        return
    end

    if inst.components.inventory and inst.components.eater then
        local target = inst.components.inventory:FindItem(function(item) return inst.components.eater:CanEat(item) end)
        if target then
            return BufferedAction(inst, target, ACTIONS.EAT)
        end
    end

    local target = FindEntity(inst,
        SEE_FOOD_DIST,
        function(item)
            return item:GetTimeAlive() >= 5
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

local function StealFoodAction(inst) --Look for things to take food from (EatFoodAction handles picking up/ eating)
    -- Food On Ground > Pots = Farms = Drying Racks > Plants

    local target = nil

    if inst.sg:HasStateTag("busy") or
        (inst.components.inventory and inst.components.inventory:IsFull()) then
        return
    end

    local pt = inst:GetPosition()
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, SEE_STRUCTURE_DIST, nil, NO_TAGS)
    --Look for crop/ cookpots/ drying rack, harvest them.
    if not target then
        for k, item in pairs(ents) do
            if (item.components.stewer and item.components.stewer:IsDone()) or
                (item.components.dryer and item.components.dryer:IsDone()) or
                (item.components.crop and item.components.crop:IsReadyForHarvest()) then
                target = item
            end
        end
    end

    if target then
        return BufferedAction(inst, target, ACTIONS.HARVEST)
    end

    --Berrybushes, carrots etc.
    if not target then
        for k, item in pairs(ents) do
            if item.components.pickable and
                item.components.pickable.caninteractwith and
                item.components.pickable:CanBePicked() and
                ItemIsInList(item.components.pickable.product, VALID_FOODS) then
                target = item
                break
            end
        end
    end

    if target then
        return BufferedAction(inst, target, ACTIONS.PICK)
    end
end

local function MateAction(inst)
    local partner = inst.components.mateable:GetPartner()
    if partner and not partner.sg:HasStateTag("sleeping") then --不能在睡觉
        return BufferedAction(inst, partner, ACTIONS.MATE, nil, nil, nil, TUNING.DOYDOY_MATING_DANCE_DIST)
    end
end

local DoydoyBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function DoydoyBrain:OnStart()
    local eatnode =
        PriorityNode(
            {
                DoAction(self.inst, StealFoodAction),
            }, 2)

    local root =
        PriorityNode(
            {
                DoAction(self.inst, function() return MateAction(self.inst) end, "Mate", true),

                WhileNode(function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
                DoAction(self.inst, EatFoodAction),
                MinPeriod(self.inst, math.random(4, 6), true, eatnode),
                Wander(self.inst, nil, 15),
            }, 1)

    self.bt = BT(self.inst, root)
end

return DoydoyBrain
