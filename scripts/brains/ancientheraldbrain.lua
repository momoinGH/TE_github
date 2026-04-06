require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/attackwall"
require "behaviours/panic"
require "behaviours/minperiod"


local SEE_DIST = 40

local CHASE_DIST = 32
local CHASE_TIME = 20

local SUMMON_COOLDOWN = 15
local TAUNT_COOLDOWN = 100

-- 我希望围着玩家转悠
local function GetHomePos(inst)
    -- return inst.components.knownlocations:GetLocation("spawnpoint")
    local x, y, z = inst.Transform:GetWorldPosition()
    local player = FindClosestPlayer(x, y, z, true)
    return player and player:GetPosition() or nil
end

local function ShoudSummonEntities(inst)
    local player = GetClosestInstWithTag("player", inst, 30)
    if player then
        local x, y, z = player.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 20, { "aporkalypse_cleanup" })
        return #ents < 12
    else
        return false
    end
end

local function CanSummon(inst)
    return not inst.components.health:IsDead() and GetTime() - inst.summon_time > SUMMON_COOLDOWN and
        (inst.components.combat.target and inst.components.combat.target:HasTag("player")) and ShoudSummonEntities(inst)
end

local function PerformSummon(inst)
    inst.sg:GoToState("summon")
    inst.summon_time = GetTime()
end

local function CanTaunt(inst)
    return not inst.components.health:IsDead() and GetTime() - inst.taunt_time > TAUNT_COOLDOWN and
        (inst.components.combat.target and inst.components.combat.target:HasTag("player")) and math.random() < 0.1
end

local function PerformTaunt(inst)
    inst.sg:GoToState("taunt")
    inst.taunt_time = GetTime()
end


local AncientHeraldBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function AncientHeraldBrain:OnStart()
    local root =
        PriorityNode(
            {
                -- 嘲讽（100秒冷却，10 % 概率）
                IfNode(function() return CanTaunt(self.inst) end, "CanTaunt",
                    DoAction(self.inst, function() PerformTaunt(self.inst) end)),
                -- 召唤怪物（15秒冷却）
                IfNode(function() return CanSummon(self.inst) end, "CanSummon",
                    DoAction(self.inst, function() PerformSummon(self.inst) end)),
                -- 追击并攻击玩家
                WhileNode(
                    function()
                        return self.inst.components.combat.target == nil or
                            not self.inst.components.combat:InCooldown()
                    end, "AttackMomentarily",
                    ChaseAndAttack(self.inst, CHASE_TIME, CHASE_DIST)),
                -- 游荡
                Wander(self.inst, GetHomePos, CHASE_DIST),
            }, 1)

    self.bt = BT(self.inst, root)
end

-- function AncientHeraldBrain:OnInitializationComplete()
--     self.inst.components.knownlocations:RememberLocation("spawnpoint", self.inst:GetPosition())
-- end

return AncientHeraldBrain
