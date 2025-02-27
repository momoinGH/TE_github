require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/follow"

local BrainCommon              = require "brains/braincommon"

local SEE_PLAYER_DIST          = 5
local SEE_FOOD_DIST            = 10
local MAX_WANDER_DIST          = 15
local MAX_CHASE_TIME           = 10
local MAX_CHASE_DIST           = 20
local RUN_AWAY_DIST            = 5
local STOP_RUN_AWAY_DIST       = 8

local MIN_FOLLOW_DIST          = 1
local TARGET_FOLLOW_DIST       = 5
local MAX_FOLLOW_DIST          = 9

local SEE_TREE_DIST            = 15
local KEEP_CHOPPING_DIST       = 10

local SEE_ROCK_DIST            = 15
local KEEP_MINING_DIST         = 10

local SEE_HAMMER_DIST          = 15
local KEEP_HAMMERING_DIST      = 10

local SEE_THRONE_DISTANCE      = 50

local FACETIME_BASE            = 2
local FACETIME_RAND            = 2

local MERM_TALK_FOLLOWWILSON   = { { "Will come with you.", "Flort glut." }, { "Make Mermfolk strong!", "Blut gloppy Glurtsu!" }, { "You help Mermfolk!", "Glut Glurtsu flopt!" }, { "You okay.", "Florpy flort." } }
local MERM_TALK_HELP_CHOP_WOOD = { { "Will come with you.", "Flort glut." }, { "Make Mermfolk strong!", "Blut gloppy Glurtsu!" }, { "Chop, choppy, chop!", "Grop, groppy, grop!" }, { "Work hard, florp!", "Glort blut, florp!" } }
local MERM_TALK_HELP_MINE_ROCK = { { "Will come with you.", "Flort glut." }, { "Make Mermfolk strong!", "Blut gloppy Glurtsu!" }, { "Break rock, easy!", "Wult wop, florty flort!" }, { "Work hard, florp!", "Glort blut, florp!" } }
local MERM_TALK_HELP_HAMMER    = { { "Will come with you.", "Flort glut." }, { "Make Mermfolk strong!", "Blut gloppy Glurtsu!" }, { "Smash! Smash!", "Florph! Florph!" }, { "Work hard, florp!", "Glort blut, florp!" } }
local MERM_TALK_FIND_FOOD      = { { "Will come with you.", "Flort glut." }, { "Make Mermfolk strong!", "Blut gloppy Glurtsu!" }, { "This do fine.", "Glort grolt flut." }, { "Find something tasty!", "Glurt florpy flut!" } }
local MERM_BATTLECRY           = { { "Glorp! Go away!", "Glorp! Glorpy glup!" }, { "Destroy you!", "Wult glut!" }, }
local MERM_GUARD_BATTLECRY     = { { "To battle!", "Wult flrot!" }, { "For glory of Mermfolk!", "Flort Glurtsu flut!" }, { "ATTAAAACK!!", "GLOT FLOOOORPH!!" }, { "Defend King!", "Glurph Glurtsen!" } }
local MERM_TALK_PANICBOSS      = { { "Something coming!", "Gloppy flort!" }, { "Aaah!! Bad thing! Bad thing!", "Gloooorph!! Glurph glot! Glurph glot!" }, { "It come to destroy us!", "Flort wult Glurtsu!" } }
local MERM_TALK_PANICBOSS_KING = { { "Rally to King!", "Glurtsen blut flort!" }, { "Hurry! Protect kingdom!", "Flurph flrot! Gloppy Glurtsam!" }, { "S-stay brave!!", "G-glop blut flrot!!" } }

local MermBrain                = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GetFaceTargetFn(inst)
    if inst.components.timer:TimerExists("dontfacetime") then
        return nil
    end
    local shouldface = inst.components.follower.leader or FindClosestPlayerToInst(inst, SEE_PLAYER_DIST, true)
    if shouldface and not inst.components.timer:TimerExists("facetime") then
        inst.components.timer:StartTimer("facetime", FACETIME_BASE + math.random() * FACETIME_RAND)
    end
    return shouldface
end

local function KeepFaceTargetFn(inst, target)
    if inst.components.timer:TimerExists("dontfacetime") then
        return nil
    end
    local keepface = (inst.components.follower.leader and inst.components.follower.leader == target) or
    (target:IsValid() and inst:IsNear(target, SEE_PLAYER_DIST))
    if not keepface then
        inst.components.timer:StopTimer("facetime")
    end
    return keepface
end

-----------------------------------------------------------------------------------------------
-- Chop

local function IsDeciduousTreeMonster(guy)
    return guy.monster and guy.prefab == "deciduoustree"
end

local function FindDeciduousTreeMonster(inst)
    return FindEntity(inst, SEE_TREE_DIST / 3, IsDeciduousTreeMonster, { "CHOP_workable" })
end

local function KeepChoppingAction(inst)
    local keep_chopping = inst.tree_target ~= nil
        or (inst.components.follower.leader ~= nil and
            inst:IsNear(inst.components.follower.leader, KEEP_CHOPPING_DIST))
        or FindDeciduousTreeMonster(inst) ~= nil

    return keep_chopping
end

local function StartChoppingCondition(inst)
    local chop_condition = inst.tree_target ~= nil
        or (inst.components.follower.leader ~= nil and
            inst.components.follower.leader.sg ~= nil and
            inst.components.follower.leader.sg:HasStateTag("chopping"))
        or FindDeciduousTreeMonster(inst) ~= nil

    return chop_condition
end

local function FindTreeToChopAction(inst)
    local target = FindEntity(inst, SEE_TREE_DIST, nil, { "CHOP_workable" })
    if target ~= nil then
        if inst.tree_target ~= nil then
            target = inst.tree_target
            inst.tree_target = nil
        else
            target = FindDeciduousTreeMonster(inst) or target
        end

        return BufferedAction(inst, target, ACTIONS.CHOP)
    end
end
-------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Mine

local function KeepMiningAction(inst)
    local keep_mining = (inst.components.follower.leader ~= nil and
        inst:IsNear(inst.components.follower.leader, KEEP_MINING_DIST))

    return keep_mining
end

local function StartMiningCondition(inst)
    local mine_condition = (inst.components.follower.leader ~= nil and
        inst.components.follower.leader.sg ~= nil and
        inst.components.follower.leader.sg:HasStateTag("mining"))

    return mine_condition
end

local function FindRockToMineAction(inst)
    local target = FindEntity(inst, SEE_ROCK_DIST, nil, { "MINE_workable" })
    if target ~= nil then
        return BufferedAction(inst, target, ACTIONS.MINE)
    end
end

------------------------------------------------------------------------------


------------------------------------------------------------------------------
-- Hammer

local function KeepHammeringAction(inst)
    local keep_hammering = (inst.components.follower.leader ~= nil and
        inst:IsNear(inst.components.follower.leader, KEEP_HAMMERING_DIST))

    return keep_hammering
end

local function StartHammeringCondition(inst)
    local hammer_condition = (inst.components.follower.leader ~= nil and
        inst.components.follower.leader.sg ~= nil and
        inst.components.follower.leader.sg:HasStateTag("hammering"))

    return hammer_condition
end

local function FindHammerTargetAction(inst)
    local target = FindEntity(inst, SEE_HAMMER_DIST, nil, { "HAMMER_workable" })
    if target ~= nil then
        return BufferedAction(inst, target, ACTIONS.HAMMER)
    end
end

------------------------------------------------------------------------------

local function EatFoodAction(inst)
    if inst.sg:HasStateTag("waking") then
        return
    end

    local target = nil
    if inst.components.inventory ~= nil and inst.components.eater ~= nil then
        target = inst.components.inventory:FindItem(function(item) return inst.components.eater:CanEat(item) end)
    end
    if target == nil then
        target = FindEntity(inst, SEE_FOOD_DIST, function(item) return inst.components.eater:CanEat(item) end,
            { "edible_VEGGIE" }, { "INLIMBO" })
        --check for scary things near the food
        if target ~= nil and (GetClosestInstWithTag("scarytoprey", target, SEE_PLAYER_DIST) ~= nil or not target:IsOnValidGround()) then -- NOTE this ValidGround check should be removed if merms start swimming
            target = nil
        end
    end
    if target ~= nil then
        local act = BufferedAction(inst, target, ACTIONS.EAT)
        act.validfn = function() return target.components.inventoryitem == nil or
            target.components.inventoryitem.owner == nil or target.components.inventoryitem.owner == inst end
        return act
    end
end


-----------------------------------------------------------------------------------------------
-- Merm king things
local function IsThroneValid(inst)
    if TheWorld.components.mermkingmanager then
        local throne = TheWorld.components.mermkingmanager:GetThrone(inst)
        return throne ~= nil
            and throne:IsValid()
            and not (throne.components.burnable ~= nil and throne.components.burnable:IsBurning())
            and not throne:HasTag("burnt")
            and TheWorld.components.mermkingmanager:ShouldGoToThrone(inst, throne)
    end

    return false
end

local function ShouldGoToThrone(inst)
    if TheWorld.components.mermkingmanager then
        local throne = TheWorld.components.mermkingmanager:GetThrone(inst)
        if throne == nil then
            throne = FindEntity(inst, SEE_THRONE_DISTANCE, nil, { "mermthrone" })
        end

        return throne and TheWorld.components.mermkingmanager:ShouldGoToThrone(inst, throne)
    end

    return false
end

local function GetThronePosition(inst)
    if TheWorld.components.mermkingmanager then
        local throne = TheWorld.components.mermkingmanager:GetThrone(inst)
        if throne then
            return throne:GetPosition()
        end
    end
end

-----------------------------------------------------------------------------------------------

local function GoHomeAction(inst)
    if inst.components.combat.target ~= nil then
        return
    end
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    return home ~= nil
        and home:IsValid()
        and not (home.components.burnable ~= nil and home.components.burnable:IsBurning())
        and not home:HasTag("burnt")
        and BufferedAction(inst, home, ACTIONS.GOHOME)
        or nil
end

local function ShouldGoHome(inst)
    if not TheWorld.state.isday or (inst.components.follower ~= nil and inst.components.follower.leader ~= nil) then
        return false
    end

    --one merm should stay outside
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    return home == nil
        or home.components.childspawner == nil
        or home.components.childspawner:CountChildrenOutside() > 1
end

local function IsHomeOnFire(inst)
    return inst.components.homeseeker
        and inst.components.homeseeker.home
        and inst.components.homeseeker.home.components.burnable
        and inst.components.homeseeker.home.components.burnable:IsBurning()
end

local function GetNoLeaderHomePos(inst)
    if inst.components.follower and inst.components.follower.leader ~= nil then
        return nil
    end

    return inst.components.knownlocations:GetLocation("home")
end

function MermBrain:OnStart()
    local root = PriorityNode(
        {
            IfNode(
                function() return TheWorld.components.mermkingmanager and TheWorld.components.mermkingmanager.king end,
                "panic with king",
                BrainCommon.PanicWhenScared(self.inst, .25, MERM_TALK_PANICBOSS)),
            IfNode(
                function() return not TheWorld.components.mermkingmanager or not TheWorld.components.mermkingmanager
                    .king end, "panic with no king",
                BrainCommon.PanicWhenScared(self.inst, .25, MERM_TALK_PANICBOSS)),
            WhileNode(
            function() return self.inst.components.hauntable ~= nil and self.inst.components.hauntable.panic end,
                "PanicHaunted", Panic(self.inst)),
            WhileNode(function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
            WhileNode(
                function() return self.inst.components.combat.target == nil or
                    not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
                ChaseAndAttack(self.inst, SpringCombatMod(MAX_CHASE_TIME), SpringCombatMod(MAX_CHASE_DIST))),
            WhileNode(
                function() return self.inst.components.combat.target ~= nil and self.inst.components.combat:InCooldown() end,
                "Dodge",
                RunAway(self.inst, function() return self.inst.components.combat.target end, RUN_AWAY_DIST,
                    STOP_RUN_AWAY_DIST)),

            ChattyNode(self.inst, MERM_TALK_FIND_FOOD,
                DoAction(self.inst, EatFoodAction, "Eat Food")),

            WhileNode(function() return ShouldGoToThrone(self.inst) and self.inst.components.combat.target == nil end,
                "ShouldGoToThrone",
                PriorityNode({
                    Leash(self.inst, GetThronePosition, 0.2, 0.2, true),
                    IfNode(function() return IsThroneValid(self.inst) end, "IsThroneValid",
                        ActionNode(function() self.inst:PushEvent("onarrivedatthrone") end)
                    ),
                }, .25)),

            IfNode(function() return StartChoppingCondition(self.inst) end, "chop",
                WhileNode(function() return KeepChoppingAction(self.inst) end, "keep chopping",
                    LoopNode {
                        ChattyNode(self.inst, MERM_TALK_HELP_CHOP_WOOD,
                            DoAction(self.inst, FindTreeToChopAction)) })),

            IfNode(function() return StartMiningCondition(self.inst) end, "mine",
                WhileNode(function() return KeepMiningAction(self.inst) end, "keep mining",
                    LoopNode {
                        ChattyNode(self.inst, MERM_TALK_HELP_MINE_ROCK,
                            DoAction(self.inst, FindRockToMineAction)) })),

            ChattyNode(self.inst, MERM_TALK_FOLLOWWILSON,
                Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST,
                    TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST)),

            IfNode(function() return self.inst.components.follower.leader ~= nil end, "HasLeader",
                ChattyNode(self.inst, MERM_TALK_FOLLOWWILSON,
                    FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn))),


            WhileNode(function() return IsHomeOnFire(self.inst) end, "HomeOnFire", Panic(self.inst)),

            WhileNode(function() return ShouldGoHome(self.inst) end, "ShouldGoHome",
                DoAction(self.inst, GoHomeAction, "Go Home", true)),

            FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
            Wander(self.inst, GetNoLeaderHomePos, MAX_WANDER_DIST),
        }, .25)

    self.bt = BT(self.inst, root)
end

return MermBrain
