local assets =
{
    Asset("ANIM", "anim/lavaarena_rhinodrill_basic.zip"),
    Asset("ANIM", "anim/lavaarena_rhinodrill_damaged.zip"),
    Asset("ANIM", "anim/lavaarena_battlestandard.zip"),
    Asset("ANIM", "anim/wilson_fx.zip"),
    Asset("ANIM", "anim/fossilized.zip"),
    Asset("ANIM", "anim/lavaarena_rhinodrill_basic.zip"),
    Asset("ANIM", "anim/lavaarena_rhinodrill_clothed_b_build.zip"),
    Asset("ANIM", "anim/lavaarena_rhinodrill_damaged.zip"),
    Asset("ANIM", "anim/lavaarena_battlestandard.zip"),
    Asset("ANIM", "anim/wilson_fx.zip"),
    Asset("ANIM", "anim/fossilized.zip"),
}


local function DoPulse(inst)
    inst.task = nil
    if inst.level > 0 then
        inst:Show()
        inst.AnimState:PlayAnimation("attack_fx3")
    else
        inst:Remove()
    end
end

local function OnPulseAnimOver(inst)
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
    if inst.level >= 7 then
        inst.AnimState:PlayAnimation("attack_fx3")
    elseif inst.level > 0 then
        inst.task = inst:DoTaskInTime(3.5 - inst.level * .5, DoPulse)
        inst:Hide()
    else
        inst:Remove()
    end
end

local function CreatePulse()
    local inst = CreateEntity()
    inst:AddTag("DECOR") --"FX" will catch mouseover
    inst:AddTag("NOCLICK")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.AnimState:SetBank("lavaarena_battlestandard")
    inst.AnimState:SetBuild("lavaarena_battlestandard")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst:Hide()
    inst.level = 0
    inst.task = inst:DoTaskInTime(1, DoPulse)
    inst:ListenForEvent("animover", OnPulseAnimOver)

    return inst
end

local function OnBuffLevelDirty(inst)
    --Dedicated server does not need to spawn the local fx
    if not TheNet:IsDedicated() then
        if inst.buff_fx ~= nil then
            inst.buff_fx.level = 0
            inst.buff_fx = nil
        end
        if inst.task ~= nil then
            inst.task:Cancel()
            inst.task = nil
        end
        if inst._bufflevel:value() > 0 then
            inst.buff_fx = CreatePulse()
            inst.buff_fx.entity:SetParent(inst.entity)
            inst.buff_fx.level = inst._bufflevel:value()
        end
        local fx = SpawnPrefab("rhinobuff")
        fx.entity:SetParent(inst.entity)
        fx.entity:AddFollower()
        fx.Follower:FollowSymbol(inst.GUID, "head", 0, 0, 0)
        fx.Transform:SetPosition(0, 0, 0)
    end
end

local function SetBuffLevel(inst, level)
    print(inst.bro_stacks)
    level = math.clamp(level, 0, 7)
    inst.bro_stacks = level
    if inst._bufflevel:value() ~= level then
        inst.components.combat:SetDefaultDamage(75 + 25 * inst.bro_stacks)
        inst._bufflevel:set(level)
        OnBuffLevelDirty(inst)
    end
end

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
    if inst.sg:HasStateTag("charging") then
        KnockbackOnHit(inst, target, 2, 2)
    end
end

local function DamagedTrigger(inst)
    inst.components.healthtrigger:RemoveTrigger(0.2)
    inst.AnimState:AddOverrideBuild("lavaarena_rhinodrill_damaged" .. inst.damagedtype)
end

local function IsTrueDeath(inst)
    if inst.bro and inst.bro.components.health and inst.bro.components.health:IsDead() then
        return true, { inst.bro }
    else
        return nil, nil
    end
end

local function ReTarget(inst)
    return FindEntity(inst, 50,
        function(guy)
            return inst.components.combat:CanTarget(guy)
        end,
        { "player" },
        { "smallcreature", "playerghost", "shadow", "INLIMBO", "FX", "NOCLICK" }
    )
end

local brain = require "brains/rhinodrillbrain"

local function Init(inst, alt)
    if not inst.bro or not inst.bro:IsValid() then
        inst.bro = FindEntity(inst, 100, function(ent)
            return ent.prefab == (alt and "rhinodrill" or "rhinodrill2")
        end)
    end
end

local function master_postinit(inst, alt)
    inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = 7

    inst:AddComponent("healthtrigger")
    inst.components.healthtrigger:AddTrigger(0.2, DamagedTrigger)

    inst:AddComponent("bloomer")
    inst:AddComponent("knownlocations")
    inst:AddComponent("inspectable")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(12750)
    inst.components.health.nofadeout = true

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(150)
    inst.components.combat:SetAttackPeriod(3)
    inst.components.combat:SetRetargetFunction(5, ReTarget)
    inst.components.combat:SetRange(4.5)
    inst.components.combat.onhitotherfn = OnHitOther

    inst:AddComponent("sanityaura")
    inst:AddComponent("sleeper")

    inst.attack_charge_ready = true
    inst.cheer_ready = false
    inst.bro_stacks = 0
    inst.damagedtype = ""
    inst.SetBuffLevel = SetBuffLevel
    inst.IsTrueDeath = IsTrueDeath

    inst:DoTaskInTime(0, Init, alt)
    inst:DoTaskInTime(15, function(inst)
        inst.cheer_ready = true
    end)

    MakeHauntablePanic(inst)
    MakeMediumBurnableCharacter(inst, "body")

    inst:SetStateGraph("SGrhinodrill")
    inst:SetBrain(brain)
end

add_event_server_data("lavaarena", "prefabs/lavaarena_rhinodrill", {
    master_postinit = master_postinit,
}, assets)
