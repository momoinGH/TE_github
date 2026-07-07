local assets =
{
    Asset("ANIM", "anim/cutnettle.zip"),
    Asset("INV_IMAGE", "cutnettle"),
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("cutnettle")
    inst.AnimState:SetBuild("cutnettle")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("cattoy")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
    inst.components.edible.antihistamine = 200

    inst:AddComponent("tradable")
    inst:AddComponent("inspectable")

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
    --inst.components.burnable:MakeDragonflyBait(3)

    inst:AddComponent("inventoryitem")

    return inst
end

return Prefab("cutnettle", fn, assets)
