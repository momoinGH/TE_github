local assets =
{
    Asset("ANIM", "anim/antman_basic.zip"),
    Asset("ANIM", "anim/antman_attacks.zip"),
    Asset("ANIM", "anim/antman_actions.zip"),

    Asset("ANIM", "anim/antman_translucent_build.zip"),
    Asset("ANIM", "anim/antman_build.zip"),
    Asset("SOUND", "sound/pig.fsb"),
}

local prefabs =
{
    "monstermeat",
    "chitin",
}

local brain = require "brains/antbrain"

local ANTMAN_DAMAGE = 34 * 2 / 3
local ANTMAN_HEALTH = 250
local ANTMAN_ATTACK_PERIOD = 3
local ANTMAN_LOYALTY_MAXTIME = 2.5 * 480

local ANTMAN_RUN_SPEED = 5
local ANTMAN_WALK_SPEED = 3

local ANTMAN_ATTACK_ON_SIGHT_DIST = 4
local ANTMAN_LOYALTY_PER_HUNGER = 480 / 25

local PIG_MIN_POOP_PERIOD = 30 * .5

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 30

local EAT_TYPES = {
    { FOODTYPE.VEGGIE },
    { FOODTYPE.SEEDS },
    { FOODTYPE.WOOD },
    { FOODTYPE.MEAT }
}

local function SetEatType(inst, eattype)
    inst.components.eater:SetDiet(EAT_TYPES[eattype])
end

local function ontalk(inst, script)
    --    if inst.is_complete_disguise(ThePlayer) then
    --        inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/crickant/pick_up")
    --    else
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/crickant/abandon")
    --    end
end

local function CalcSanityAura(inst, observer)
    return inst.components.follower and inst.components.follower.leader == observer and TUNING.SANITYAURA_SMALL or 0
end

local function ShouldAcceptItem(inst, item)
    if inst.components.sleeper:IsAsleep() then
        return false
    end

    if item.components.equippable and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
        return true
    end
    if item.components.edible then
        if (item.components.edible.foodtype == "MEAT" or item.components.edible.foodtype == "HORRIBLE")
            and inst.components.follower.leader
            and inst.components.follower:GetLoyaltyPercent() > 0.9 then
            return false
        end

        if (item.components.edible.foodtype == "VEGGIE" or item.components.edible.foodtype == "RAW") then
            local last_eat_time = inst.components.eater:TimeSinceLastEating()
            if last_eat_time and last_eat_time < PIG_MIN_POOP_PERIOD then
                return false
            end

            if inst.components.inventory:Has(item.prefab, 1) then
                return false
            end
        end

        return true
    end
end

local function OnGetItemFromPlayer(inst, giver, item)
    --I eat food
    if item.components.edible then
        --meat makes us friends
        if inst.components.eater:CanEat(item) then
            --  if item.components.edible.foodtype == "MEAT" or item.components.edible.foodtype == "HORRIBLE" then
            if inst.components.combat.target and inst.components.combat.target == giver then
                inst.components.combat:SetTarget(nil)
            elseif giver.components.leader then
                inst.SoundEmitter:PlaySound("dontstarve/common/makeFriend")
                giver.components.leader:AddFollower(inst)
                inst.components.follower:AddLoyaltyTime(item.components.edible:GetHunger() * ANTMAN_LOYALTY_PER_HUNGER)
            end
        end
        if inst.components.sleeper:IsAsleep() then
            inst.components.sleeper:WakeUp()
        end
    end

    --I wear hats
    if item.components.equippable and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
        local current = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
        if current then
            inst.components.inventory:DropItem(current)
        end

        inst.components.inventory:Equip(item)
        inst.AnimState:Show("hat")
    end
end

local function OnRefuseItem(inst, item)
    inst.sg:GoToState("refuse")
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local SUGGEST_MUST_TAGS = { "_health", "_combat", "antman" }
local function OnAttackedByDecidRoot(inst, attacker)
    local x, y, z = inst.Transform:GetWorldPosition()
    for k, v in pairs(TheSim:FindEntities(x, y, z, SHARE_TARGET_DIST / 2, SUGGEST_MUST_TAGS)) do
        if v ~= inst and not IsEntityDead(v) then
            v:PushEvent("suggest_tree_target", { tree = attacker })
        end
    end
end

local function OnAttacked(inst, data)
    --print(inst, "OnAttacked")
    local attacker = data.attacker
    inst:ClearBufferedAction()

    if attacker.prefab == "deciduous_root" and attacker.owner then
        OnAttackedByDecidRoot(inst, attacker.owner)
    elseif attacker.prefab ~= "deciduous_root" then
        inst.components.combat:SetTarget(attacker)
        inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, function(dude) return dude:HasTag("ant") end,
            MAX_TARGET_SHARES)
    end
end

local builds = { "antman_translucent_build", "antman_build" } -- {"antman_build"}

local function is_complete_disguise(target)
    if not target then return false end
    return target:HasTag("has_antmask") and target:HasTag("has_antsuit") or target:HasTag("antlingual")
end

local function TransformToWarrior(inst)
    local warrior = SpawnPrefab("antman_warrior")
    warrior.Transform:SetPosition(inst.Transform:GetWorldPosition())
    warrior:AddTag("aporkalypse_cleanup")
    inst:Remove()
end

local function CheckForAporkalypse(inst)
    if (TheWorld.components.aporkalypse and TheWorld.components.aporkalypse.aporkalypse_active == true) then
        inst:DoTaskInTime(.2, TransformToWarrior)
    end
end

local ATTACK_MUST_TAGS = { "_health", "_combat" }
local ATTACK_ONEOF_TAGS = { "monster", "player" }
local ATTACK_CANT_TAGS = { "playerghost", "INLIMBO", "ant_disguise" }
local function NormalRetargetFn(inst)
    return FindEntity(inst, TUNING.PIG_TARGET_DIST, function(guy)
        return inst.components.combat:CanTarget(guy) and not is_complete_disguise(guy) and (not guy:HasTag("player")
            or guy:GetDistanceSqToInst(inst) < ANTMAN_ATTACK_ON_SIGHT_DIST * ANTMAN_ATTACK_ON_SIGHT_DIST) --对于玩家需要更近一点儿才攻击
    end, ATTACK_MUST_TAGS, ATTACK_CANT_TAGS, ATTACK_ONEOF_TAGS)
end

local function NormalKeepTargetFn(inst, target)
    --give up on dead guys, or guys in the dark, or werepigs
    return inst.components.combat:CanTarget(target)
        and (not target.LightWatcher or target.LightWatcher:IsInLight())
        and not (target.sg and target.sg:HasStateTag("transform"))
end

local function NormalShouldSleep(inst)
    if inst.components.follower and inst.components.follower.leader then
        local fire = FindEntity(inst, 6, function(ent)
            return ent.components.burnable and ent.components.burnable:IsBurning()
        end, { "campfire" })

        return fire and (not inst.LightWatcher or inst.LightWatcher:IsInLight())
    else
        return true
    end
end

local function getstatus(inst)
    if inst.components.follower.leader ~= nil then
        return "FOLLOWER"
    end
end

local function OnSave(inst, data)
    data.build = inst.build
    data.eattype = inst.eattype
end

local function OnLoad(inst, data)
    if data then
        inst.build = data.build or builds[1]

        inst.AnimState:SetBuild(inst.build)
        inst.eattype = data.eattype
        SetEatType(inst, inst.eattype)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddLightWatcher()
    inst.entity:AddNetwork()

    inst.DynamicShadow:SetSize(1.5, .75)

    inst.Transform:SetFourFaced()
    inst.Transform:SetScale(1.15, 1.15, 1.15)

    inst:AddComponent("talker")
    inst.components.talker.ontalk = ontalk
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    --inst.components.talker.colour = Vector3(133/255, 140/255, 167/255)
    inst.components.talker.offset = Vector3(0, -400, 0)
    inst.components.talker:StopIgnoringAll()

    MakeCharacterPhysics(inst, 50, .5)
    --    MakePoisonableCharacter(inst)

    inst.build = builds[math.random(#builds)]
    inst.AnimState:SetBank("antman")
    inst.AnimState:SetBuild(inst.build)
    inst.AnimState:PlayAnimation("idle_loop")
    inst.AnimState:Hide("hat")

    if math.random() < 0.5 then
        inst.AnimState:OverrideSymbol("antman_arm", "antman_translucent_build", "antman_arm")
        --	inst.AnimState:OverrideSymbol("antman_cheeks", "antman_build", "antman_cheeks")		
        --	inst.AnimState:OverrideSymbol("antman_ear", "antman_build", "antman_ear")	
        --	inst.AnimState:OverrideSymbol("antman_head", "antman_build", "antman_head")	
        --	inst.AnimState:OverrideSymbol("antman_leg", "antman_build", "antman_leg")	
        --	inst.AnimState:OverrideSymbol("antman_tails", "antman_build", "antman_tail")	
        --	inst.AnimState:OverrideSymbol("antman_torso", "antman_build", "antman_torso")	
    end

    inst:AddTag("character")
    inst:AddTag("ant")
    inst:AddTag("insect")
    inst:AddTag("scarytoprey")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.is_complete_disguise = is_complete_disguise

    inst:DoPeriodicTask(3, CheckForAporkalypse)

    inst:AddComponent("locomotor")                          -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = ANTMAN_RUN_SPEED   --5
    inst.components.locomotor.walkspeed = ANTMAN_WALK_SPEED --3
    inst.components.locomotor:SetAllowPlatformHopping(true) -- boat hopping setup

    ------------------------------------------
    inst.eattype = math.random(4)
    inst:AddComponent("eater")
    SetEatType(inst, inst.eattype)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem:SetSinks(true)

    inst.components.eater:SetCanEatHorrible()
    --    table.insert(inst.components.eater.foodprefs, "RAW")
    --    table.insert(inst.components.eater.ablefoods, "RAW")
    inst.components.eater.strongstomach = true -- can eat monster meat!
    ------------------------------------------
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "antman_torso"
    inst.components.combat:SetDefaultDamage(ANTMAN_DAMAGE)
    inst.components.combat:SetAttackPeriod(ANTMAN_ATTACK_PERIOD)
    inst.components.combat:SetKeepTargetFunction(NormalKeepTargetFn)
    inst.components.combat:SetRetargetFunction(3, NormalRetargetFn)

    MakeMediumBurnableCharacter(inst, "antman_torso")
    MakeMediumFreezableCharacter(inst, "antman_torso")

    inst:AddComponent("named")
    inst.components.named.possiblenames = STRINGS.ANTNAMES
    inst.components.named:PickNewName()

    ------------------------------------------
    inst:AddComponent("follower")
    inst.components.follower.maxfollowtime = ANTMAN_LOYALTY_MAXTIME

    ------------------------------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(ANTMAN_HEALTH)
    ------------------------------------------

    inst:AddComponent("inventory")

    ------------------------------------------

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:AddRandomLoot("monstermeat", 3)
    inst.components.lootdropper:AddRandomLoot("chitin", 1)
    inst.components.lootdropper.numrandomloot = 1
    ------------------------------------------

    inst:AddComponent("knownlocations")

    ------------------------------------------

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
    ------------------------------------------

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    ------------------------------------------

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(2)
    inst.components.sleeper:SetSleepTest(NormalShouldSleep)
    ------------------------------------------

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("embarker")

    inst:SetBrain(brain)
    inst:SetStateGraph("SGant")

    inst:ListenForEvent("suggest_tree_target", function(inst, data)
        if data and data.tree and inst:GetBufferedAction() ~= ACTIONS.CHOP then
            inst.tree_target = data.tree
        end
    end)
    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("beginaporkalypse", function()
        if not inst:IsInLimbo() then
            TransformToWarrior(inst, false)
        end
    end, TheWorld)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("antman", fn, assets, prefabs)
