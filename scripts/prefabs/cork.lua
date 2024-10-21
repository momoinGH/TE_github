local assets =
{
    Asset("ANIM", "anim/cork.zip"),
    Asset("INV_IMAGE", "cork"),
}

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    --    MakeInventoryFloatable(inst, "idle_water", "idle")


    inst.AnimState:SetBuild("cork")
    inst.AnimState:SetBank("cork")

    inst:AddComponent("tradable")

    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "WOOD"
    inst.components.edible.woodiness = 5


    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL
    inst.components.fuel.fueltype = "CORK"



    MakeSmallBurnable(inst, TUNING.LARGE_BURNTIME)
    MakeSmallPropagator(inst)

    ---------------------

    inst:AddComponent("inspectable")

    inst:AddComponent("repairer")
    inst.components.repairer.repairmaterial = "wood"
    inst.components.repairer.healthrepairvalue = TUNING.REPAIR_LOGS_HEALTH

    inst:AddComponent("inventoryitem")


    return inst
end

return Prefab("cork", fn, assets)
