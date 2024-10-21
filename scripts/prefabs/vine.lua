local assets =
{
    Asset("ANIM", "anim/vine.zip"),
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)



    inst.AnimState:SetBank("vine")
    inst.AnimState:SetBuild("vine")
    inst.AnimState:PlayAnimation("idle")
    inst:AddTag("aquatic")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    --inst:AddComponent("edible")
    --inst.components.edible.foodtype = "WOOD"
    --inst.components.edible.woodiness = 10

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")


    return inst
end

return Prefab("vine", fn, assets)
