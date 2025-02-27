local assets =
{
    Asset("ANIM", "anim/city_hammer.zip"),
    Asset("ANIM", "anim/swap_city_hammer.zip"),
}

local prefabs =
{
    "collapse_small",
    "collapse_big",
}


local function onfinished(inst)
    inst:Remove()
end


local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_city_hammer", "swap_city_hammer")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "small", 0.05, { 1.2, 0.75, 1.2 })

    anim:SetBank("city_hammer")
    anim:SetBuild("city_hammer")
    anim:PlayAnimation("idle")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.floater:SetBankSwapOnFloat(true, -10, { sym_build = "swap_city_hammer" })

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.HAMMER_DAMAGE)
    inst:AddTag("hammer")
    inst:AddTag("fixable_crusher")


    -----
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.HAMMER)
    inst.components.tool.tagrequirements = { "fixable" }
    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.HAMMER_USES)
    inst.components.finiteuses:SetUses(TUNING.HAMMER_USES)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")


    inst:AddComponent("equippable")

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    return inst
end


return Prefab("city_hammer", fn, assets, prefabs)
