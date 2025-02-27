local assets =
{
    Asset("ANIM", "anim/pearl_amulet.zip"),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "pearl_amulet", "swap_body")

    if inst.components.fueled then
        inst.components.fueled:StartConsuming()
    end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")

    if inst.components.fueled then
        inst.components.fueled:StopConsuming()
    end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("pearl_amulet")
    inst.AnimState:SetBuild("pearl_amulet")
    inst.AnimState:PlayAnimation("anim")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.NECK or EQUIPSLOTS.BODY -- 适配五格
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    --	inst:AddComponent("dapperness")
    --	inst.components.dapperness.dapperness = TUNING.DAPPERNESS_MED

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/jewlery"
    inst.components.inventoryitem.imagename = "pearl_amulet"

    inst:AddTag("amulet") -- 适配六格

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = "MAGIC"
    inst.components.fueled:InitializeFuelLevel(TUNING.PEARL_AMULET_FUEL)
    inst.components.fueled:SetDepletedFn(inst.Remove)

    inst:AddComponent("oxygensupplier")
    inst.components.oxygensupplier:SetSupplyRate(TUNING.PEARL_AMULET_RATE)

    return inst
end

return Prefab("pearl_amulet", fn, assets)
