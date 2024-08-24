local assets =
{
    Asset("ANIM", "anim/lavaarena_elemental_basic.zip"),
}

local brain = require "brains/tfwp_elementalbrain"

local function MakeWeapon(inst)
    local weapon = CreateEntity()

    weapon.entity:AddTransform()

    weapon:AddComponent("weapon")
    weapon.components.weapon:SetDamage(25)
    weapon.components.weapon:SetRange(TUNING.TFWP_ELEMENTAL.RANGE, TUNING.TFWP_ELEMENTAL.RANGE + 2)
    weapon.components.weapon:SetProjectile("fireball_projectile")

    weapon:AddComponent("inventoryitem")
    weapon.components.inventoryitem:SetOnDroppedFn(weapon.Remove)
    weapon:AddComponent("equippable")

    weapon.persists = false
    inst.weapon = weapon
    inst.components.inventory:Equip(inst.weapon)
end

local function master_postinit(inst)
    inst.voumorrer = 0

    inst:SetStateGraph("SGtfwp_elemetal")
    inst:SetBrain(brain)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(800)

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(25)
    inst.components.combat:SetAttackPeriod(TUNING.TFWP_ELEMENTAL.ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, retargetfn)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst.components.combat:SetRange(TUNING.TFWP_ELEMENTAL.RANGE * 1.3)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventory")

    MakeWeapon(inst)

    inst.persists = false
end

add_event_server_data("lavaarena", "prefabs/lavaarena_elemental", {
    master_postinit = master_postinit
}, assets)
