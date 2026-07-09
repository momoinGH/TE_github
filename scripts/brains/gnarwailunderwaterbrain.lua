require "behaviours/chaseandattack"
require "behaviours/follow"
require "behaviours/leash"
require "behaviours/panicandavoid"
require "behaviours/wander"

local MAX_BOAT_FOLLOW_DIST = TUNING.MAX_WALKABLE_PLATFORM_RADIUS + 13
local TRADE_DISTANCE = MAX_BOAT_FOLLOW_DIST + 3

local function GetTrader(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local players = FindPlayersInRange(x, y, z, TRADE_DISTANCE, true)
    for _, v in ipairs(players) do
        if inst.components.trader:IsTryingToTradeWithMe(v) then
            return v
        end
    end
    return nil
end



local function esquece(inst)
    if inst.sg:HasStateTag("hide") then inst.sg:GoToState("idle") end
    if inst.components.combat and inst.components.combat.target then
        local x, y, z = inst.components.combat.target:GetPosition():Get()
        local dir = inst.components.combat.target:GetPosition() - inst:GetPosition()
        print(dir)
        if dir.x > 15 or dir.x < -15 or dir.z > 15 or dir.z < -15 then
            inst.components.combat:SetTarget(nil)
            print("3")
        end
    end
end

local function FindFoodAction(inst)
    local alvomorto = FindEntity(inst, 4,
        function(item)
            return inst.components.eater:CanEat(item)
        end, nil, nil) --and item:GetTimeAlive() <= 12
    if alvomorto ~= nil then
        if inst.sg:HasStateTag("hide") then inst.sg:GoToState("idle") end

        local x, y, z = alvomorto:GetPosition():Get()
        y = .1
        alvomorto.Physics:Teleport(x, y, z)
        local dir = alvomorto:GetPosition() - inst:GetPosition()
        local angle = math.atan2(-dir.z, -dir.x)
        if dir.x > 1 or dir.x < -1 or dir.z > 1 or dir.z < -1 then
            inst.sg:GoToState("sugacomida", alvomorto)
            alvomorto.Physics:SetVel(math.cos(angle) * 3, 0, math.sin(angle) * 3)
        else
            local bact = BufferedAction(inst, alvomorto, ACTIONS.EAT)
            bact.validfn = function()
                return alvomorto.components.inventoryitem == nil or
                    (alvomorto.components.inventoryitem.is_landed and not alvomorto.components.inventoryitem:IsHeld())
            end
            return bact
        end
    end

    if not inst.sg:HasStateTag("hide") and math.random(1, 10) == 1 then
        inst:PushEvent("timetohide")
    end

    if not inst.sg:HasStateTag("hide") then
        return
    end

    local target = FindEntity(inst, 1.5, nil, { "tropicalspawner" })

    if target ~= nil then
        if target.prefab == "fish2_alive" or
            target.prefab == "fish3_alive" or
            target.prefab == "fish4_alive" or
            target.prefab == "fish5_alive" or
            target.prefab == "quagmire_salmom_alive" or
            target.prefab == "fish6_alive" or
            target.prefab == "fish7_alive" or
            target.prefab == "oceanfish_small_underwater_1" or
            target.prefab == "oceanfish_small_underwater_2" or
            target.prefab == "oceanfish_small_underwater_3" or
            target.prefab == "oceanfish_small_underwater_4" or
            target.prefab == "oceanfish_small_underwater_5" or
            target.prefab == "oceanfish_small_underwater_6" or
            target.prefab == "oceanfish_small_underwater_7" or
            target.prefab == "oceanfish_small_underwater_8" or
            target.prefab == "oceanfish_small_underwater_9" or
            target.prefab == "oceanfish_medium_underwater_1" or
            target.prefab == "oceanfish_medium_underwater_2" or
            target.prefab == "oceanfish_medium_underwater_3" or
            target.prefab == "oceanfish_medium_underwater_4" or
            target.prefab == "oceanfish_medium_underwater_5" or
            target.prefab == "oceanfish_medium_underwater_6" or
            target.prefab == "oceanfish_medium_underwater_7" or
            target.prefab == "oceanfish_medium_underwater_8" then
            inst.sg:GoToState("body_slam_hide", target)
        end
    end
end

local GnarwailunderwaterBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)
local function GetFaceTargetFn(inst)
    local target = GetClosestInstWithTag("character", inst, 5)
    if target then
        return target
    end
end

local function KeepFaceTargetFn(inst, target)
    return inst:GetDistanceSqToInst(target) <= 6 * 6
end


function GnarwailunderwaterBrain:OnStart()
    local root = PriorityNode(
        {
            WhileNode(
                function()
                    return GetTrader(self.inst) == nil and not self.inst.sg:HasStateTag("busy") or
                        self.inst.sg:HasStateTag("hide")
                end,
                "ActionsWhenNotEating",
                PriorityNode({
                    --                RunAway(self.inst, {tags=BOAT_TAGS}, MIN_BOAT_FOLLOW_DIST, BOAT_TARGET_DISTANCE, nil, nil, nil, true),
                    IfNode(function() return not self.inst.components.combat:HasTarget() end,
                        "FindFoodIfNotInCombat",
                        DoAction(self.inst, FindFoodAction)
                    ),


                    IfNode(function() return self.inst.components.combat:HasTarget() end,
                        "FindFoodIfNotInCombat",
                        DoAction(self.inst, esquece)
                    ),
                }, 0.30)
            ),

            WhileNode(function() return self.inst.components.combat and self.inst.components.combat.target ~= nil end,
                "a ballphinfriend",
                ChaseAndAttack(self.inst, 100)),
            FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        }, 0.30)

    self.bt = BT(self.inst, root)
end

return GnarwailunderwaterBrain
