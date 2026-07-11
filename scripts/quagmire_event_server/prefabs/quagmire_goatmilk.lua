return {
    master_postinit = function(inst)
        inst:AddComponent("edible")
        inst.components.edible.healthvalue = TUNING.HEALING_SMALL
        inst.components.edible.hungervalue = TUNING.CALORIES_MED

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(TUNING.PERISH_FASTISH)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"

        inst:AddComponent("tradable")
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

        MakeHauntableLaunchAndPerish(inst)
    end
}
