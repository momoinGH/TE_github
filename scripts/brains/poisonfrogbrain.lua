require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/chaseandattack"
require "behaviours/standstill"

local STOP_RUN_DIST = 10
local SEE_PLAYER_DIST = 5
local MAX_WANDER_DIST = 20
local SEE_TARGET_DIST = 6

local MAX_CHASE_DIST = 7
local MAX_CHASE_TIME = 8

local function GoHomeAction(inst)
    if inst.components.homeseeker and
        inst.components.homeseeker.home and
        inst.components.homeseeker.home:IsValid() then
        return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
    end
end

local function ShouldGoHome(inst)
    return TheWorld.state.isday --or TheWorld.state.iswinter
end

local PoisonFrogBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function PoisonFrogBrain:OnStart()
    local root = PriorityNode(
        {
            WhileNode(function() return self.inst.components.hauntable and self.inst.components.hauntable.panic end,
                "PanicHaunted", Panic(self.inst)),
            ChaseAndAttack(self.inst, MAX_CHASE_TIME),
            WhileNode(function() return ShouldGoHome(self.inst) end, "ShouldGoHome",
                DoAction(self.inst, function() return GoHomeAction(self.inst) end, "go home", true)),
            WhileNode(function() return TheWorld and not TheWorld.state.isnight end, "IsNotNight",
                Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end,
                    MAX_WANDER_DIST)),
            StandStill(self.inst, function() return self.inst.sg:HasStateTag("idle") end, nil),
        }, .25)

    self.bt = BT(self.inst, root)
end

return PoisonFrogBrain
