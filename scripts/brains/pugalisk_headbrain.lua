require "behaviours/chaseandattack"
require "behaviours/standstill"
local pu = require("prefabs/pugalisk_util")

local Pugalisk_headBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function customLocomotionTest(inst)
    if not inst.movecommited then
        pu.DetermineAction(inst)
    end
    if inst.movecommited then
        return false
    end
    return true
end

function Pugalisk_headBrain:OnStart()
    local root =
        PriorityNode({ WhileNode(
            function() return customLocomotionTest(self.inst) and not self.inst.sg:HasStateTag("underground") end,
            "Be a head",
            PriorityNode {
                ChaseAndAttack(self.inst),
                StandStill(self.inst)
            }),
        }, 1)

    self.bt = BT(self.inst, root)
end

return Pugalisk_headBrain
