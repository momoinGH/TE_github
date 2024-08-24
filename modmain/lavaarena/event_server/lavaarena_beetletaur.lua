local assets =
{
    Asset("ANIM", "anim/lavaarena_beetletaur.zip"),
    Asset("ANIM", "anim/lavaarena_beetletaur_basic.zip"),
    Asset("ANIM", "anim/lavaarena_beetletaur_actions.zip"),
    Asset("ANIM", "anim/lavaarena_beetletaur_block.zip"),
    Asset("ANIM", "anim/lavaarena_beetletaur_fx.zip"),
    Asset("ANIM", "anim/lavaarena_beetletaur_break.zip"),
    Asset("ANIM", "anim/healing_flower.zip"),
    Asset("ANIM", "anim/fossilized.zip"),
}

local brain = require "brains/beetletaurbrain"

--------------------------------------------------------------------------
local function KnockbackOnHit(inst, target, radius, attack_knockback, strength_mult, force_land)
    if target.sg and target.sg.sg.states.knockback then
        target:PushEvent("knockback",
            { knocker = inst, radius = radius, strengthmult = strength_mult, forcelanded = force_land })
    else
        Knockback(inst, target, radius, attack_knockback)
    end
end

local function OnHitOther(inst, target)
    if inst.sg:HasStateTag("slamming") or inst.sg:HasStateTag("knockback") then
        KnockbackOnHit(inst, target, 5, 2)
    end
end

local function CanDestroyObject(inst, ent)
    return ent
        and ent:IsValid()
        and ent.components.workable
        and ent.components.workable:CanBeWorked()
        and ent.components.workable.action ~= ACTIONS.DIG
        and ent.components.workable.action ~= ACTIONS.NET
        and not inst.recentlycharged[ent]
end

local function ClearRecentlyCharged(inst, object)
    inst.recentlycharged[object] = nil
end

local function OnDestroyObject(inst, ent)
    if CanDestroyObject(inst, ent) then
        SpawnPrefab("collapse_small").Transform:SetPosition(ent.Transform:GetWorldPosition())
        ent.components.workable:Destroy(inst)
        inst.recentlycharged[ent] = true
        inst:DoTaskInTime(3, ClearRecentlyCharged, ent)
    end
end

local DESTROY_OBJECT_DELAY = 2 * FRAMES
local function OnCollideDestroyObject(inst, object)
    if CanDestroyObject(inst, object) then
        inst:DoTaskInTime(DESTROY_OBJECT_DELAY, OnDestroyObject, object)
    end
end

--------------------------------------------------------------------------
local function AttackModeTrigger(inst)
    inst.components.healthtrigger:RemoveTrigger(0.9)
    inst.modes.guard = false
    inst.modes.attack = true
    inst.attacks.combo = 2
    inst.attacks.tantrum = true
    inst.guard_timer = inst:DoTaskInTime(12, function(inst)
        inst.guard_timer = nil
    end)
end

local function AttackAndGuardModeTrigger(inst)
    inst.components.healthtrigger:RemoveTrigger(0.8)
    inst.modes.guard = true
    inst.attacks.uppercut = true
    inst.attacks.buff = true
    inst.sg.mem.wants_to_taunt = true
end

local function Combo2Trigger(inst)
    inst.components.healthtrigger:RemoveTrigger(0.5)
    inst.attacks.combo = 4
end

local function InfiniteComboTrigger(inst)
    inst.components.healthtrigger:RemoveTrigger(0.25)
    inst.attacks.combo = 999
end

local function ReTarget(inst)
    return FindEntity(inst, 50,
        function(guy)
            return inst.components.combat:CanTarget(guy)
        end,
        { "player" },
        { "smallcreature", "playerghost", "shadow", "INLIMBO", "FX", "NOCLICK" })
end

local function master_postinit(inst, OnBuffTypeDirty)
    inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = 10
    inst.components.locomotor.walkspeed = 4

    inst:AddComponent("knownlocations")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(42500)

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(200)
    inst.components.combat:SetAttackPeriod(2)
    inst.components.combat:SetRetargetFunction(5, ReTarget)
    inst.components.combat:SetRange(3)

    inst:AddComponent("sanityaura")
    inst:AddComponent("sleeper")

    inst:AddComponent("inspectable")

    inst.attacks = { body_slam = true, combo = 0, uppercut = false, tantrum = false, buff = false }
    inst.modes = { attack = false, guard = true }
    inst.attack_body_slam_ready = true
    inst.is_guarding = false
    inst.avoid_heal_auras = true


    inst:AddComponent("healthtrigger")
    inst.components.healthtrigger:AddTrigger(0.9, AttackModeTrigger)
    inst.components.healthtrigger:AddTrigger(0.8, AttackAndGuardModeTrigger)
    inst.components.healthtrigger:AddTrigger(0.5, Combo2Trigger)
    inst.components.healthtrigger:AddTrigger(0.25, InfiniteComboTrigger)
    ------------------------------------------
    inst.recentlycharged = {}
    inst.Physics:SetCollisionCallback(OnCollideDestroyObject)
    ------------------------------------------
    inst.components.combat.battlecryenabled = false
    inst.components.combat.onhitotherfn = OnHitOther
    ------------------------------------------
    MakeHauntablePanic(inst)
    MakeMediumBurnableCharacter(inst, "body")

    inst:SetStateGraph("SGbeetletaur")
    inst:SetBrain(brain)
end

add_event_server_data("lavaarena", "prefabs/lavaarena_beetletaur", {
    master_postinit = master_postinit,
}, assets)
