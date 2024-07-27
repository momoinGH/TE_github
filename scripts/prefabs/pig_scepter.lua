local assets =
{
    Asset("ANIM", "anim/pig_scepter.zip"),
    Asset("ANIM", "anim/swap_pig_scepter.zip"),
}

local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_pig_scepter", "swap_pig_scepter")
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
    MakeInventoryPhysics(inst)
    inst.entity:AddNetwork()

    anim:SetBank("pig_scepter")
    anim:SetBuild("pig_scepter")
    anim:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "large", 0.05, { 1.1, 0.5, 1.1 }, true, -9)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.floater:SetBankSwapOnFloat(true, -11, { sym_build = "swap_pig_scepter" })

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hamletinventory.xml"
    inst.caminho = "images/inventoryimages/hamletinventory.xml"

    inst:AddComponent("tradable")

    inst:AddTag("nopunch")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    return inst
end

return Prefab("common/inventory/pig_scepter", fn, assets)
