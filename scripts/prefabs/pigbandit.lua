require "stategraphs/SGpigbandit"

local brain = require "brains/pigbanditbrain"

local assets =
{
    Asset("ANIM", "anim/pig_bandit.zip"),
    Asset("ANIM", "anim/townspig_basic.zip"),
    Asset("ANIM", "anim/townspig_actions.zip"),
    Asset("ANIM", "anim/townspig_attacks.zip"),
    Asset("ANIM", "anim/townspig_sneaky.zip"),
    Asset("SOUND", "sound/pig.fsb"),
}

local prefabs =
{
    "meat",
    "monstermeat",
    "poop",
    "tophat",
    "strawhat",
    "pigskin",
    "pigbanditexit",
    "banditmap",
    "bandittreasure",
    "bandithat",
}

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 30
local PIG_BANDIT_DAMAGE = 33
local PIG_BANDIT_ATTACK_PERIOD = 3
local PIG_BANDIT_TARGET_DIST = 16
local PIG_BANDIT_RUN_SPEED = 7
local PIG_BANDIT_WALK_SPEED = 3
local PIG_LOYALTY_MAXTIME = 2.5 * 480

local function OnTalk(inst, script)
    inst.SoundEmitter:PlaySound("dontstarve/pig/grunt")
end

local function OnAttacked(inst, data)
    print("ON ATTACKED")
    inst:ClearBufferedAction()
    inst.attacked = true
    local attacker = data and data.attacker
    inst.components.combat:SetTarget(attacker)
end

local function OnNewTarget(inst, data)
    if inst:HasTag("werepig") then
        inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST,
            function(dude) return dude:HasTag("werepig") end, MAX_TARGET_SHARES)
    end
end

local function FindOincs(inst)
    if inst.components.inventory then
        return inst.components.inventory:FindItems(function(item) return item:HasTag("oinc") end)
    end
end

local function Retarget(inst)
    local dist = PIG_BANDIT_TARGET_DIST

    return FindEntity(inst, dist,
        function(guy)
            if inst.components.combat:CanTarget(guy) and guy.components.inventory and ((guy:HasTag("player")) or (guy.prefab == "pigman")) then
                local oinks = guy.components.inventory:FindItem(function(item) return item:HasTag("oinc") end)
                return oinks
            end

            return false
        end)
end

local function KeepTarget(inst, target)
    return inst.components.combat:CanTarget(target)
end

local function onsave(inst, data)
    if inst.attacked then
        data.attacked = inst.attacked
    end
end

local function onload(inst, data)
    if data and data.attacked then
        inst.attacked = data.attacked
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    local shadow = inst.entity:AddDynamicShadow()
    inst.entity:AddLightWatcher()
    inst.entity:AddNetwork()

    shadow:SetSize(1.5, .75)

    anim:SetBank("townspig")
    anim:SetBuild("pig_bandit")
    anim:PlayAnimation("idle", true)
    anim:Hide("hat")
    anim:Hide("ARM_carry")

    MakeCharacterPhysics(inst, 50, .5)

    inst:AddComponent("talker")
    inst.components.talker.ontalk = OnTalk
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.offset = Vector3(0, -400, 0)

    inst.Transform:SetFourFaced()

    inst:AddTag("character")
    inst:AddTag("pig")
    inst:AddTag("scarytoprey")
    inst:AddTag("monster") -- this is a cheap way to get the pigs to attack on sight.
    inst:AddTag("sneaky")
    inst:AddTag("pigbandit")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = PIG_BANDIT_RUN_SPEED
    inst.components.locomotor.walkspeed = PIG_BANDIT_WALK_SPEED

    -- boat hopping setup
    inst.components.locomotor:SetAllowPlatformHopping(true)
    inst:AddComponent("embarker")

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })

    MakeMediumBurnableCharacter(inst, "pig_torso")

    inst:AddComponent("homeseeker")

    inst:AddComponent("follower")
    inst.components.follower.maxfollowtime = PIG_LOYALTY_MAXTIME

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(PIG_BANDIT_DAMAGE)
    inst.components.combat:SetAttackPeriod(PIG_BANDIT_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, Retarget)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst.components.combat.hiteffectsymbol = "chest"

    inst.components.combat.onhitotherfn = function(inst, other, damage)
        local oincs = FindOincs(other)
        while oincs and (#oincs > 0) do
            for i, oinc in ipairs(oincs) do
                inst.components.thief:StealItem(other, oinc, nil, nil, 4)
            end
            oincs = FindOincs(other)
        end
    end

    inst:AddComponent("thief")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.PIG_HEALTH)

    inst:AddComponent("inventory")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "bandithat", "banditmap" })

    inst:AddComponent("inspectable")

    MakeMediumFreezableCharacter(inst, "pig_torso")

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("newcombattarget", OnNewTarget)

    inst:SetBrain(brain)
    inst:SetStateGraph("SGpigbandit")

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

return Prefab("pigbandit", fn, assets, prefabs)
