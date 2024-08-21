require "behaviours/wander"
require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/minperiod"
require "behaviours/follow"

local MIN_FOLLOW = 5
local MED_FOLLOW = 15
local MAX_FOLLOW = 30

local ShadowCreatureBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GetClosedPlayer(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local player = FindClosestPlayerInRangeSq(x, y, z, 900, true)
    return player
end

function ShadowCreatureBrain:OnStart()
    local root = PriorityNode(
        {
            ChaseAndAttack(self.inst, 100),
            Follow(self.inst, GetClosedPlayer, MIN_FOLLOW, MED_FOLLOW, MAX_FOLLOW),
            Wander(self.inst,
                function()
                    local player = GetClosedPlayer(self.inst)
                    return player and player:GetPosition() or nil
                end, 20)
        }, .25)

    self.bt = BT(self.inst, root)
end

return ShadowCreatureBrain
