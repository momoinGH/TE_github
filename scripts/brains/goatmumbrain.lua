require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/chattynode"
require "behaviours/findandstay"
require "behaviours/wander"

local function KeepFaceTarget(inst, target)
    return not target:HasTag("notarget") and inst:IsNear(target, 4)
end

local function GetFaceTarget(inst)
    local target = FindClosestPlayerToInst(inst, 4, true)
    return target ~= nil and not target:HasTag("notarget") and target or nil
end


local function GetAltar(inst)
    return TroGetClosestEnt(inst, "quagmire_altar")
end

local function AltarIsGivingReward(inst)
    local altar = GetAltar(inst)
    return altar and altar:HasTag("giving_reward")
end

local function GetHomePos(inst)
    local portal = TroGetClosestEnt(inst, "quagmire_portal")
    if portal then
        return portal:GetPosition()
    end
    return inst.components.knownlocations:GetLocation("spawnpoint")
end

local GoatmumBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function GoatmumBrain:OnStart()
    local root = PriorityNode(
        {
            -- 祭坛在给予奖励
            WhileNode(function() return AltarIsGivingReward(self.inst) end, "WatchCraving", FindAndStay(self.inst, 3.5, GetAltar, true)),
            -- 面向玩家
            FaceEntity(self.inst, GetFaceTarget, KeepFaceTarget),
            -- 漫步
            Wander(self.inst, GetHomePos, 20)
        }, 0.25)
    self.bt = BT(self.inst, root)
end

function GoatmumBrain:OnInitializationComplete()
    self.inst.components.knownlocations:RememberLocation("spawnpoint", self.inst:GetPosition())
end

return GoatmumBrain
