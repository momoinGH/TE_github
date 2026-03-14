local quagmire_crabmeat_assets =
{
    Asset("ANIM", "anim/quagmire_crabmeat.zip"),
}

SetSharedLootTable('spoiled_fish_large_loot', {
    { 'boneshard', 1.0 },
    { 'boneshard', 1.0 },
    { 'spoiled_food', 0.5 },
})

local function quagmire_crabmeat_fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddAnimState()

    inst.AnimState:SetBank("quagmire_crabmeat")
    inst.AnimState:SetBuild("quagmire_crabmeat")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst:AddTag("catfood")
    inst:AddTag("packimfood")
    inst:AddTag("meat")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages2.xml"
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("edible")
    inst.components.edible.ismeat = true
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.edible.hungervalue = TUNING.CALORIES_SMALL

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERFAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
    --inst.components.tradable.dubloonvalue = TUNING.DUBLOON_VALUES.SEAFOOD
    inst.data = {}

    inst:AddComponent("cookable")
    inst.components.cookable.product = "quagmire_crabmeat_cooked"

    inst:AddComponent("dryable")
    inst.components.dryable:SetProduct("fishmeat_small_dried")
    inst.components.dryable:SetDryTime(TUNING.DRY_FAST)

    inst:AddComponent("bait")

    MakeHauntableLaunchAndPerish(inst)

    return inst
end

local function quagmire_crabmeat_cooked_fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddAnimState()

    inst.AnimState:SetBank("quagmire_crabmeat")
    inst.AnimState:SetBuild("quagmire_crabmeat")
    inst.AnimState:PlayAnimation("cooked", true)

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst:AddTag("meat")
    inst:AddTag("catfood")
    inst:AddTag("packimfood")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages2.xml"
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("edible")
    inst.components.edible.ismeat = true
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.foodstate = "COOKED"
    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.edible.hungervalue = TUNING.CALORIES_SMALL

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
    --inst.components.tradable.dubloonvalue = TUNING.DUBLOON_VALUES.SEAFOOD
    inst.data = {}

    inst:AddComponent("bait")

    MakeHauntableLaunchAndPerish(inst)

    return inst
end

return Prefab("quagmire_crabmeat", quagmire_crabmeat_fn, quagmire_crabmeat_assets),
    Prefab("quagmire_crabmeat_cooked", quagmire_crabmeat_cooked_fn, quagmire_crabmeat_assets)
