local quagmire_assets =
{
    Asset("ANIM", "anim/quagmire_meat_small.zip"),
}

local quagmire_prefabs =
{
    "quagmire_cookedsmallmeat",
}

local function OnSpawnedFromHaunt(inst, data)
    Launch(inst, data.haunter, TUNING.LAUNCH_SPEED_SMALL)
end

local function common(bank, build, anim, tags)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation(anim)
    --inst.scrapbook_anim = anim

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    --inst.pickupsound = "squidgy"

    inst:AddTag("meat")
    inst:AddTag("dryable")
    inst:AddTag("lureplant_bait")
    inst:AddTag("cookable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst:AddComponent("stackable")

    inst.components.floater:SetScale(0.9)

    inst:AddComponent("edible")
    inst.components.edible.ismeat = true
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("bait")

    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)
    inst:ListenForEvent("spawnedfromhaunt", OnSpawnedFromHaunt)

    return inst
end

local function quagmire_smallmeat()
    local inst = common("quagmire_meat_small", "quagmire_meat_small", "raw", { "catfood", "rawmeat" })

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
    inst.components.edible.sanityvalue = -TUNING.SANITY_SMALL

    inst:AddComponent("dryable")
    inst.components.dryable:SetProduct("smallmeat_dried")
    inst.components.dryable:SetDryTime(TUNING.DRY_FAST)

    inst:AddComponent("cookable")
    inst.components.cookable.product = "quagmire_cookedsmallmeat"

    return inst
end

local function quagmire_cookedsmallmeat()
    local inst = common("quagmire_meat_small", "quagmire_meat_small", "cooked")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
    inst.components.edible.sanityvalue = 0

    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)

    return inst
end

return Prefab("quagmire_smallmeat", quagmire_smallmeat, quagmire_assets, quagmire_prefabs),
    Prefab("quagmire_cookedsmallmeat", quagmire_cookedsmallmeat, quagmire_assets)
