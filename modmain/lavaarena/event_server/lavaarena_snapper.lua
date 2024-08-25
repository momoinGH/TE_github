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

local targetDist = TUNING.LIZARDMAN_TFC.TARGET_DIST
local keepDistSq = TUNING.LIZARDMAN_TFC.KEEP_TARGET_DIST * TUNING.LIZARDMAN_TFC.KEEP_TARGET_DIST
local shareDist = TUNING.LIZARDMAN_TFC.SHARE_TARGET_DIST
local tornsRange = TUNING.LIZARDMAN_TFC.ATTACK_RANGE
local tornsDamage = TUNING.LIZARDMAN_TFC.TORNS_DAMAGE


local function Retarget(inst)
    local player = GetClosestInstWithTag("player", inst, 70)
    if player then return player end

    return FindEntity(inst, targetDist, function(guy)
        return inst.components.combat:CanTarget(guy)
    end, nil, { "FX", "NOCLICK", "INLIMBO", "lizardman", "player" })
end

local function OnAttacked(inst, data)
    local function IsArmored()
        return data.attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
            and data.attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
    end

    if data.attacker == nil
        or data.attacker.components.combat == nil
        or data.attacker.components.health == nil
    then
        return
    end

    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, shareDist,
        function(dude)
            return dude:HasTag("lizardman")
                and not dude.components.health:IsDead()
        end, 5)

    if data.attacker:IsNear(inst, tornsRange) then
        if data.attacker.components.inventory == nil then
            data.attacker.components.health:DoDelta(tornsDamage, false, nil, false, inst, false)
            data.attacker:PushEvent("thorns")
        elseif not IsArmored() then
            data.attacker.components.health:DoDelta(tornsDamage, false, nil, false, inst, false)
            data.attacker:PushEvent("thorns")
        end
    end
end

local function MakeWeapon(inst)
    if inst.components.inventory ~= nil then
        local weapon = CreateEntity()
        weapon.entity:AddTransform()
        MakeInventoryPhysics(weapon)
        weapon:AddComponent("weapon")
        weapon.components.weapon:SetDamage(TUNING.LIZARDMAN_TFC.DAMAGE) --TUNING.SPIDER_SPITTER_DAMAGE_RANGED)
        weapon.components.weapon:SetRange(TUNING.LIZARDMAN_TFC.DIST_ATTACK_RANGE,
            TUNING.LIZARDMAN_TFC.DIST_ATTACK_RANGE + 4)
        weapon.components.weapon:SetProjectile("lizardman_spit_tfc")
        weapon:AddComponent("inventoryitem")
        weapon.persists = false
        weapon.components.inventoryitem:SetOnDroppedFn(weapon.Remove)
        weapon:AddComponent("equippable")
        inst.weapon = weapon
        inst.components.inventory:Equip(inst.weapon)
        inst.components.inventory:Unequip(EQUIPSLOTS.HANDS)
    end
end

-- 应该根据回合决定
local flags = {
    "lavaarena_battlestandard_damager",
    "lavaarena_battlestandard_shield",
    "lavaarena_battlestandard_heal"
}

local function PlaceBanner(inst)
    SpawnPrefab(flags[math.random(#flags)]).Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function GetDebugString(inst)
    return string.format("last banner %i", GetTime() - inst.bannerLastTime)
end

local brain = require "brains/snapperbrain"

local function snapper_postinit(inst)
    inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = TUNING.LIZARDMAN_TFC.SPEED

    inst:SetStateGraph("SGsnapper")
    inst:SetBrain(brain)

    inst:AddComponent("knownlocations")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.LIZARDMAN_TFC.HEALTH)

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.LIZARDMAN_TFC.DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.LIZARDMAN_TFC.ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(5, Retarget)
    inst.components.combat:SetRange(TUNING.LIZARDMAN_TFC.DIST_ATTACK_RANGE)
    inst.components.combat.battlecryenabled = false

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("lizardman")

    inst:AddComponent("inspectable")
    inst:AddComponent("inventory")

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODGROUP.LIZARDMAN }, { FOODTYPE.MEAT })
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater:SetCanEatRaw()
    inst.components.eater.strongstomach = true

    inst:AddComponent("sleeper")

    MakeMediumFreezableCharacter(inst, "body")
    MakeMediumBurnableCharacter(inst, "body")

    inst:ListenForEvent("attacked", OnAttacked)
    MakeWeapon(inst)

    inst.bannerLastTime = GetTime()

    inst.PlaceBanner = PlaceBanner
    inst.debugstringfn = GetDebugString
end

----------------------------------------------------------------------------------------------------
local function OnThrown(inst)
    inst:Show()
    inst.AnimState:PlayAnimation("idle_loop")
end

local function OnHit(inst)
    inst.AnimState:PlayAnimation("blast")
    inst:ListenForEvent("animover", function(inst) inst:Remove() end)
end

local function OnMiss(inst)
    inst.AnimState:PlayAnimation("disappear")
    inst:ListenForEvent("animover", function(inst) inst:Remove() end)
end

local function goospit_postinit(inst)
    inst:Show()
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst.persists = false

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(40)
    inst.components.projectile:SetHoming(false)
    inst.components.projectile:SetHitDist(1.0)
    inst.components.projectile:SetOnHitFn(OnHit)
    inst.components.projectile:SetOnMissFn(OnMiss)
    inst.components.projectile:SetOnThrownFn(OnThrown)
    inst.components.projectile:SetLaunchOffset(Vector3(2, 0.7, 2))
end

add_event_server_data("lavaarena", "prefabs/lavaarena_snapper", {
    snapper_postinit = snapper_postinit,
    goospit_postinit = goospit_postinit
}, assets)
