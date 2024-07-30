local assets =
{
    Asset("ANIM", "anim/ancient_remnant.zip"),
    Asset("INV_IMAGE", "ancient_remnant"),
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)



    inst:AddTag("ancient_remnant")

    inst.AnimState:SetBank("ancient_remnant")
    inst.AnimState:SetBuild("ancient_remnant")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddTag("cattoy")

    inst:AddComponent("inspectable")

    inst:AddComponent("appeasement")
    inst.components.appeasement.appeasementvalue = TUNING.APPEASEMENT_LARGE

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hamletinventory.xml"


    inst:AddComponent("fuel")
    inst.components.fuel.fueltype = FUELTYPE.ANCIENT_REMNANT
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL * 4 -- Runar: 小小强化一下碎布


    return inst
end

return Prefab("common/inventory/ancient_remnant", fn, assets)
