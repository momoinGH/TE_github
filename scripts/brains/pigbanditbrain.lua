require "behaviours/wander"
require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/chattynode"

local MAX_CHASE_TIME = 10
local MAX_CHASE_DIST = 30
local SEE_FOOD_DIST = 10
local RUN_AWAY_DIST = 5
local STOP_RUN_AWAY_DIST = 8
local SEE_STOLEN_ITEM_DIST = 10
local MAX_WANDER_DIST = 20



local function FindRandomOffscreenPoint(inst)
    local OFFSET = 70

    local pt = inst:GetPosition()

    local theta = math.random() * TWOPI
    local radius = OFFSET
    local offset = FindWalkableOffset(pt, theta, radius, 12, true) --12
    if offset then
        return pt + offset
    end
    print("FAILED!!!!!!")
    return nil
end


local function GoHomeAction(inst)
    local position = FindRandomOffscreenPoint(inst)

    if not inst.components.homeseeker:HasHome() then
        --家没了
        local exit = SpawnPrefab("pigbanditexit")
        exit.Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst.components.homeseeker:SetHome(exit)
    end

    if position and inst.components.homeseeker and inst.components.homeseeker.home then
        inst.components.homeseeker.home.Transform:SetPosition(position.x, position.y, position.z)
        --if inst.components.homeseeker and inst.components.homeseeker:HasHome() then
        return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
        --end
    end
end

local function OincNearby(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local WALKABLE_PLATFORM_TAGS = { "walkableplatform" }
    local plataforma = false
    local entities = TheSim:FindEntities(x, y, z, TUNING.MAX_WALKABLE_PLATFORM_RADIUS, WALKABLE_PLATFORM_TAGS)
    for i, v in ipairs(entities) do
        local walkable_platform = v.components.walkableplatform
        if walkable_platform ~= nil then
            plataforma = true
        end
    end

    if not TheWorld.Map:IsVisualGroundAtPoint(x, y, z) then
        if inst and inst.components.health and plataforma == false and inst.sg:HasStateTag("moving") then
            inst.components.health:Kill()
        end
    end
    return FindEntity(inst, SEE_STOLEN_ITEM_DIST, function(item)
        local x, y, z = item.Transform:GetWorldPosition()
        local isValidPosition = x and y and z
        local isValidPickupItem =
            isValidPosition and
            item.components.inventoryitem and
            not item.components.inventoryitem:IsHeld() and
            item.components.inventoryitem.canbepickedup and
            item:IsOnValidGround() and
            not item:HasTag("trap") and
            item:HasTag("oinc")     -- bandits only steal money
        return isValidPickupItem
    end)
end

local function PickupAction(inst)
    local target = OincNearby(inst)

    if target then
        return BufferedAction(inst, target, ACTIONS.PICKUP)
    end
end

local PigBanditBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GetPlayerPos(inst)
    local invader = GetClosestInstWithTag("player", inst, 40)
    if invader then
        return invader:GetPosition()
    else
        return inst:GetPosition()
    end
end

function PigBanditBrain:OnStart()
    local root =
        PriorityNode(
            {
                WhileNode(function() return self.inst.components.health.takingfiredamage end, "OnFire",
                    ChattyNode(self.inst, STRINGS.PIG_TALK_PANICFIRE, Panic(self.inst))),
                WhileNode(
                    function()
                        return (self.inst.attacked or (self.inst.components.inventory:NumItems() > 1 and not OincNearby(self.inst))) and
                            not self.inst.sg:HasStateTag("busy")
                    end, "run off with prize",
                    DoAction(self.inst, GoHomeAction, "disappear", true)),

                WhileNode(function() return not self.inst.attacked end, "run off with prize",
                    DoAction(self.inst, PickupAction, "searching for prize", true)),
                ChattyNode(self.inst, STRINGS.BANDIT_TALK_FIGHT,
                    WhileNode(
                        function()
                            return self.inst.components.combat.target == nil or
                                not self.inst.components.combat:InCooldown()
                        end, "AttackMomentarily",
                        ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST))),
                RunAway(self.inst,
                    function(guy)
                        return guy:HasTag("pig") and guy.components.combat and
                            guy.components.combat.target == self.inst
                    end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST),
                Wander(self.inst, GetPlayerPos, MAX_WANDER_DIST)
            }, .5)

    self.bt = BT(self.inst, root)
end

return PigBanditBrain
