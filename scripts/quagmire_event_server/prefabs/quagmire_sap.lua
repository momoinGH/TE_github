return {
    master_postinit = function(inst, fresh)
        inst:AddTag("show_spoilage")

        if fresh then
            inst:AddTag("sweetener")
            inst:AddTag("quagmire_stewable")
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")

        inst:AddComponent("edible")
        inst.components.edible.foodtype = FOODTYPE.GENERIC
        inst.components.edible.healthvalue = 0
        inst.components.edible.sanityvalue = 0
        inst.components.edible.hungervalue = 4.7

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.MED_LARGE_FUEL

        MakeHauntableLaunchAndPerish(inst)
        MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
        MakeSmallPropagator(inst)
    end,
}
