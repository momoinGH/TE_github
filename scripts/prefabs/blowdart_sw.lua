local assets =
{
    Asset("ANIM", "anim/blow_dart.zip"),
    Asset("ANIM", "anim/swap_blowdart.zip"),
    Asset("ANIM", "anim/swap_blowdart_pipe.zip"),
    Asset("ANIM", "anim/swap_blowdart_flup.zip"),
    Asset("ANIM", "anim/blow_dart_sw.zip"),
}

local prefabs =
{
    "impact",
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_blowdart", "swap_blowdart")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onhit(inst, attacker, target)
    local impactfx = SpawnPrefab("impact")
    if impactfx ~= nil and target.components.combat then
        local follower = impactfx.entity:AddFollower()
        follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0)
        if attacker ~= nil and attacker:IsValid() then
            impactfx:FacePoint(attacker.Transform:GetWorldPosition())
        end
    end
    inst:Remove()
end

local function onthrown(inst, data)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    --inst.components.inventoryitem.pushlandedevents = false
end

local function common(anim, tags, removephysicscolliders)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("blow_dart_sw")
    inst.AnimState:SetBuild("blow_dart_sw")
    inst.AnimState:PlayAnimation(anim)
    inst.scrapbook_anim = anim

    inst:AddTag("blowdart")
    inst:AddTag("sharp")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    --projectile (from projectile component) added to pristine state for optimization
    inst:AddTag("projectile")

    if tags ~= nil then
        for i, v in ipairs(tags) do
            inst:AddTag(v)
        end
    end

    if removephysicscolliders then
        RemovePhysicsColliders(inst)
    end

    MakeInventoryFloatable(inst, "small", 0.05, { 0.75, 0.5, 0.75 })

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(8, 10)

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(60)
    inst.components.projectile:SetOnHitFn(onhit)
    inst:ListenForEvent("onthrown", onthrown)
    -------

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("stackable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.equipstack = true

    MakeHauntableLaunch(inst)

    return inst
end


---------------------------------------------------------------------------
local function poisonthrown(inst)
    inst.AnimState:PlayAnimation("dart_poison")
end

local function poisonattack(inst, attacker, target, projectile)
    if not target or not target.components.poisonable then
        return
    end

    if target:HasTag("player") then
        local corpo = target.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
        local cabeca = target.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
        if corpo and corpo.prefab == "armor_seashell" then return end
        if cabeca and cabeca.prefab == "oxhat" then return end
    end

    target.components.poisonable:SetPoison(-4, 5, 120)

    if target.components.combat then
        target.components.combat:SuggestTarget(attacker)
    end
    -- this was commented out as the attack with the spear will do an attacked event. The poison itself doesn't need a second one pushed
    --target:PushEvent("attacked", {attacker = attacker, damage = 0, projectile = projectile})
end

local function poison()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("blow_dart_sw")
    inst.AnimState:SetBuild("blow_dart_sw")
    inst.AnimState:PlayAnimation("idle_poison")
    inst.scrapbook_anim = "idle_poison"

    inst:AddTag("blowdart")
    inst:AddTag("sharp")
    inst:AddTag("aquatic")
    --projectile (from projectile component) added to pristine state for optimization
    inst:AddTag("projectile")

    RemovePhysicsColliders(inst)

    MakeInventoryFloatable(inst, "small", 0.05, { 0.75, 0.5, 0.75 })

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    local swap_data = { sym_build = "swap_blowdart", bank = "blow_dart", anim = "idle_yellow" }
    inst.components.floater:SetBankSwapOnFloat(true, -4, swap_data)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(8, 10)

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(60)
    inst.components.projectile:SetOnHitFn(onhit)
    inst:ListenForEvent("onthrown", onthrown)
    -------

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")


    inst:AddComponent("stackable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.equipstack = true

    MakeHauntableLaunch(inst)

    inst.components.weapon:SetOnAttack(poisonattack)
    inst.components.projectile:SetOnThrownFn(poisonthrown)

    return inst
end


local function flupequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_blowdart_flup", "swap_blowdart_flup")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function flupthrown(inst)
    inst.AnimState:PlayAnimation("dart_flup")
end

local function flup()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("blow_dart_sw")
    inst.AnimState:SetBuild("blow_dart_sw")
    inst.AnimState:PlayAnimation("idle_flup")
    inst.scrapbook_anim = "idle_flup"

    inst:AddTag("blowdart")
    inst:AddTag("sharp")
    inst:AddTag("aquatic")
    --projectile (from projectile component) added to pristine state for optimization
    inst:AddTag("projectile")
    inst:AddTag("flupdart")

    RemovePhysicsColliders(inst)

    MakeInventoryFloatable(inst, "small", 0.05, { 0.75, 0.5, 0.75 })

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.floater:SetBankSwapOnFloat(true, -4, { sym_build = "swap_blowdart_flup" })

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(8, 10)

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(60)
    inst.components.projectile:SetOnHitFn(onhit)
    inst:ListenForEvent("onthrown", onthrown)
    -------

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")


    inst:AddComponent("stackable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.equipstack = true

    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
    inst.components.equippable:SetOnEquip(flupequip)
    inst.components.weapon:SetDamage(20)
    inst.components.projectile:SetOnThrownFn(flupthrown)

    MakeHauntableLaunch(inst)

    return inst
end

-------------------------------------------------------------------------------
return Prefab("blowdart_flup", flup, assets, prefabs),
    Prefab("blowdart_poison", poison, assets, prefabs)
