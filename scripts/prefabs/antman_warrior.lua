require "brains/antwarriorbrain"
require "stategraphs/SGwarriorant"
require "brains/antwarriorbrain_egg"

local assets =
{
    Asset("ANIM", "anim/antman_basic.zip"),
    Asset("ANIM", "anim/antman_attacks.zip"),
    Asset("ANIM", "anim/antman_actions.zip"),
    Asset("ANIM", "anim/antman_egghatch.zip"),
    Asset("ANIM", "anim/antman_guard_build.zip"),
    Asset("ANIM", "anim/antman_warpaint_build.zip"),
    Asset("ANIM", "anim/antman_translucent_build.zip"),
}

local prefabs =
{
    "antman",
    "monstermeat",
    "chitin",
    "antman_warrior_egg"
}

local brain = require "brains/antwarriorbrain"

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 30
local ANTMAN_WARRIOR_DAMAGE = 34 * 1.25
local ANTMAN_WARRIOR_HEALTH = 300
local ANTMAN_WARRIOR_ATTACK_PERIOD = 3
local ANTMAN_WARRIOR_TARGET_DIST = 16

local ANTMAN_WARRIOR_RUN_SPEED = 7
local ANTMAN_WARRIOR_WALK_SPEED = 3.5

local ANTMAN_WARRIOR_ATTACK_ON_SIGHT_DIST = 8

local function ontalk(inst, script)
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/crickant/abandon")
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

local builds = { "antman_translucent_build" } -- {"antman_build"}
local ATTACK_MUST_TAGS = { "_health", "_combat" }
local ATTACK_ONEOF_TAGS = { "monster", "player" }
local ATTACK_CANT_TAGS = { "playerghost", "INLIMBO", "antlingual" }
local function NormalRetargetFn(inst)
    return FindEntity(inst, ANTMAN_WARRIOR_TARGET_DIST, function(guy)
        return inst.components.combat:CanTarget(guy) and (not guy:HasTag("player")
            or guy:GetDistanceSqToInst(inst) < ANTMAN_WARRIOR_ATTACK_ON_SIGHT_DIST * ANTMAN_WARRIOR_ATTACK_ON_SIGHT_DIST) --对于玩家需要更近一点儿才攻击
    end, ATTACK_MUST_TAGS, ATTACK_CANT_TAGS, ATTACK_ONEOF_TAGS)
end

local function NormalKeepTargetFn(inst, target)
    --give up on dead guys, or guys in the dark, or werepigs
    return inst.components.combat:CanTarget(target)
        and (not target.LightWatcher or target.LightWatcher:IsInLight())
        and not (target.sg and target.sg:HasStateTag("transform"))
end

local function TransformToNormal(inst)
    local normal = SpawnPrefab("antman")
    normal.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function SetAporkalypse(inst, enabled)
    local player = GetClosestInstWithTag("player", inst, 30)
    if player and enabled then
        inst.Light:Enable(true)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.build = "antman_warpaint_build"
        inst.AnimState:SetBuild(inst.build)
        inst.components.health:SetMaxHealth(ANTMAN_WARRIOR_HEALTH + 100)
    else
        inst.Light:Enable(false)
        inst.AnimState:SetBloomEffectHandle("")
        inst.build = "antman_guard_build"
        inst.AnimState:SetBuild(inst.build)
    end

    inst.AnimState:SetBuild(inst.build)
end

local function Init(inst)
    if TheWorld.components.aporkalypse and TheWorld.components.aporkalypse.aporkalypse_active == true then
        inst.Light:Enable(true)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.build = "antman_warpaint_build"
        inst.AnimState:SetBuild(inst.build)
    else
        inst.Light:Enable(false)
        inst.AnimState:SetBloomEffectHandle("")
        inst.build = "antman_guard_build"
        inst.AnimState:SetBuild(inst.build)
    end
end

local function OnSave(inst, data)
    data.build = inst.build

    if inst.queen then
        data.queen_guid = inst.queen.GUID
    end
end

local function OnLoad(inst, data)
    if data then
        inst.build = data.build or builds[1]
        inst.AnimState:SetBuild(inst.build)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddLight()
    inst.entity:AddLightWatcher()
    inst.entity:AddNetwork()

    inst.DynamicShadow:SetSize(1.5, .75)

    inst.Light:SetFalloff(.35)
    inst.Light:SetIntensity(.25)
    inst.Light:SetRadius(1)
    inst.Light:SetColour(120 / 255, 120 / 255, 120 / 255)
    inst.Light:Enable(false)

    inst.Transform:SetFourFaced()
    inst.Transform:SetScale(1.15, 1.15, 1.15)

    inst:AddComponent("talker")
    inst.components.talker.ontalk = ontalk
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.offset = Vector3(0, -400, 0)

    MakeCharacterPhysics(inst, 50, .5)

    inst.build = "antman_guard_build"

    inst.AnimState:SetBank("antman")
    inst.AnimState:SetBuild(inst.build)
    inst.AnimState:PlayAnimation("idle_loop")
    inst.AnimState:Hide("hat")

    inst:AddTag("character")
    inst:AddTag("antmanwarrior")
    inst:AddTag("ant")
    inst:AddTag("scarytoprey")
    inst:AddTag("quaker_immune") --地震伤害免疫

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor")                                  -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = ANTMAN_WARRIOR_RUN_SPEED   --5
    inst.components.locomotor.walkspeed = ANTMAN_WARRIOR_WALK_SPEED --3
    inst.components.locomotor:SetAllowPlatformHopping(true)         -- boat hopping setup

    inst:AddComponent("embarker")

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "antman_torso"
    inst.components.combat:SetRetargetFunction(3, NormalRetargetFn)
    inst.components.combat:SetDefaultDamage(ANTMAN_WARRIOR_DAMAGE)
    inst.components.combat:SetAttackPeriod(ANTMAN_WARRIOR_ATTACK_PERIOD)
    inst.components.combat:SetKeepTargetFunction(NormalKeepTargetFn)

    MakeMediumBurnableCharacter(inst, "antman_torso")

    inst:AddComponent("named")
    inst.components.named.possiblenames = STRINGS.ANTWARRIORNAMES
    inst.components.named:PickNewName()

    ------------------------------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(ANTMAN_WARRIOR_HEALTH)

    inst:AddComponent("inventory")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({})
    inst.components.lootdropper:AddRandomLoot("monstermeat", 3)
    inst.components.lootdropper:AddRandomLoot("chitin", 1)
    inst.components.lootdropper.numrandomloot = 1

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem:SetSinks(true)

    inst:AddComponent("knownlocations")

    inst:AddComponent("sleeper")

    inst:AddComponent("inspectable")
    ------------------------------------------
    MakeMediumFreezableCharacter(inst, "antman_torso")
    ------------------------------------------

    inst.SetAporkalypse = SetAporkalypse

    inst:SetBrain(brain)
    inst:SetStateGraph("SGwarriorant")

    inst:DoTaskInTime(0.2, Init)

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("antqueenbattle", function() inst:SetAporkalypse(true) end, TheWorld)
    inst:ListenForEvent("beginaporkalypse", function()
        inst.Light:Enable(true)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.build = "antman_warpaint_build"
        inst.AnimState:SetBuild(inst.build)
    end, TheWorld)

    inst:ListenForEvent("endaporkalypse", function() ReplacePrefab(inst, "antman") end, TheWorld)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("antman_warrior", fn, assets, prefabs)
