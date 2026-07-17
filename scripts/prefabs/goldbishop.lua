local clockwork_common = require "prefabs/clockwork_common"
local RuinsRespawner = require "prefabs/ruinsrespawner"

local assets =
{
    Asset("ANIM", "anim/bishop.zip"),
    Asset("ANIM", "anim/goldbishop_build.zip"),
    Asset("ANIM", "anim/bishop_nightmare.zip"),
    Asset("SOUND", "sound/chess.fsb"),
    Asset("SCRIPT", "scripts/prefabs/clockwork_common.lua"),
    Asset("SCRIPT", "scripts/prefabs/ruinsrespawner.lua"),
}

local prefabs =
{
    "gears",
    "bishop_targeting_fx",
    "bishop_charge2_fx",
    "purplegem",
}

local brain = require "brains/bishopbrain"

SetSharedLootTable('goldbishop',
    {
        { 'gears', 1.0 },
        { 'purplegem', 1.0 },
        { 'goldnugget', 1.0 },
        { 'goldnugget', 1.0 },
        { 'goldnugget', 1.0 },
    })

SetSharedLootTable('bishop',
    {
        { 'gears', 1.0 },
        { 'gears', 1.0 },
        { 'purplegem', 1.0 },
    })

SetSharedLootTable('bishop_nightmare',
    {
        { 'purplegem', 1.0 },
        { 'nightmarefuel', 0.6 },
        { 'thulecite_pieces', 0.5 },
    })

local function ShouldSleep(inst)
    return clockwork_common.ShouldSleep(inst)
end

local function ShouldWake(inst)
    return clockwork_common.ShouldWake(inst)
end

local function Retarget(inst)
    return clockwork_common.Retarget(inst, TUNING.BISHOP_TARGET_DIST)
end

local function KeepTarget(inst, target)
    return clockwork_common.KeepTarget(inst, target)
end

local function OnAttacked(inst, data)
    clockwork_common.OnAttacked(inst, data)
end

local function common_fn(build, tag)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 50, .5)

    inst.DynamicShadow:SetSize(1.5, .75)
    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("bishop")
    inst.AnimState:SetBuild(build)

    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("chess")
    inst:AddTag("bishop")

    inst.shotx = net_float(inst.GUID, "goldbishop.shotx")
    inst.shotz = net_float(inst.GUID, "goldbishop.shotz")
    inst.showshot = net_bool(inst.GUID, "goldbishop.showshot")

    if tag ~= nil then
        inst:AddTag(tag)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.BISHOP_WALK_SPEED
    inst.components.locomotor:SetAllowPlatformHopping(true)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "waist"
    inst.components.combat:SetAttackPeriod(TUNING.BISHOP_ATTACK_PERIOD)
    inst.components.combat:SetRange(TUNING.BISHOP_ATTACK_DIST)
    inst.components.combat:SetRetargetFunction(3, Retarget)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.BISHOP_HEALTH)
    inst.components.combat:SetDefaultDamage(TUNING.BISHOP_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.BISHOP_ATTACK_PERIOD)

    inst:AddComponent("inspectable")
    inst:AddComponent("knownlocations")

    inst:AddComponent("follower")
    inst:AddComponent("embarker")
    inst:AddComponent("drownable")

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetWakeTest(ShouldWake)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetResistance(3)

    MakeMediumBurnableCharacter(inst, "waist")
    MakeMediumFreezableCharacter(inst, "waist")

    MakeHauntablePanic(inst)

    inst:SetStateGraph("SGbishop")
    inst:SetBrain(brain)

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("newcombattarget", clockwork_common.OnNewCombatTarget)

    clockwork_common.InitHomePosition(inst)
    clockwork_common.MakeBefriendable(inst)

    -- SGbishop calls this after firing; gold bishops do not use the beam trail effect.
    inst.StartShotFx = function() end

    return inst
end

local function bishop_fn()
    local inst = common_fn("goldbishop_build")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetChanceLootTable('goldbishop')
    inst.kind = ""
    inst.soundpath = "dontstarve/creatures/bishop/"
    inst.effortsound = "dontstarve/creatures/bishop/idle"
    inst.override_combat_fx_size = "med"

    return inst
end

return Prefab("goldbishop", bishop_fn, assets, prefabs)
