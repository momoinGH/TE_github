local brain = require "brains/pebblecrabbrain"

return {
    master_postinit = function(inst)
        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(TUNING.RABBIT_HEALTH)

        inst:AddComponent("eater")
        inst.components.eater:SetDiet({ FOODTYPE.VEGGIE }, { FOODTYPE.VEGGIE })

        inst:AddComponent("locomotor")
        inst.components.locomotor.runspeed = 1
        inst.components.locomotor.walkspeed = 1

        inst:AddComponent("inspectable")
        inst:AddComponent("knownlocations")
        inst:AddComponent("homeseeker")

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot({ "quagmire_crabmeat" })

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.nobounce = true
        inst.components.inventoryitem.canbepickedup = false
        inst.components.inventoryitem.canbepickedupalive = true
        inst.components.inventoryitem:SetSinks(true)

        MakeFeedableSmallLivestock(inst, TUNING.RABBIT_PERISH_TIME, nil)

        inst:SetBrain(brain)
        inst:SetStateGraph("SGpebblecrab")
    end
}
