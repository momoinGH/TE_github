require "behaviours/standstill"
require "behaviours/runaway"
require "behaviours/panic"
require "behaviours/chaseandattack"

local START_FACE_DIST = 15
local KEEP_FACE_DIST = 25
local GO_HOME_DIST = 1
local MAX_CHASE_TIME = 10
local MAX_CHASE_DIST = 20
local RUN_AWAY_DIST = 10
local STOP_RUN_AWAY_DIST = 20

local KnightBoatBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GoHomeAction(inst)
    local homePos = inst.components.knownlocations:GetLocation("home")
    if homePos and
        not inst.components.combat.target then
        return BufferedAction(inst, nil, ACTIONS.WALKTO, nil, homePos, nil, 0.2)
    end
end

local function GetFaceTargetFn(inst)
    local target = GetClosestInstWithTag("player", inst, START_FACE_DIST)
    if target and not target:HasTag("notarget") then
        return target
    end
end

local function KeepFaceTargetFn(inst, target)
    return inst:GetDistanceSqToInst(target) <= KEEP_FACE_DIST * KEEP_FACE_DIST and not target:HasTag("notarget")
end

local function ShouldGoHome(inst)
    if (inst.components.follower and inst.components.follower.leader) then
        return false
    end

    local homePos = inst.components.knownlocations:GetLocation("home")
    return (homePos and distsq(homePos, inst:GetPosition()) > GO_HOME_DIST * GO_HOME_DIST)
end

function KnightBoatBrain:OnStart()
    local root = PriorityNode(
        {
            WhileNode(function() return self.inst.components.health.takingfiredamage end,
                "OnFire", Panic(self.inst)),

            WhileNode(
                function() return self.inst.components.combat.target == nil or
                    not self.inst.components.combat:InCooldown() end,
                "AttackMomentarily", ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST)),

            WhileNode(
                function() return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end,
                "Dodge",
                RunAway(self.inst, function(inst) return self.inst.components.combat.target end, RUN_AWAY_DIST,
                    STOP_RUN_AWAY_DIST)),

            -- WhileNode(function() return ShouldGoHome(self.inst) end,
            --     "ShouldGoHome", DoAction(self.inst, GoHomeAction, "Go Home", true)),

            FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),

            StandStill(self.inst),
        }, .25)

    self.bt = BT(self.inst, root)
end

return KnightBoatBrain
