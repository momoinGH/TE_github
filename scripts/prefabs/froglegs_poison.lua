local assets =
{
    Asset("ANIM", "anim/frog_legs_tree.zip"),
}

local prefabs =
{
    "froglegs_poison_cooked",
}

local function oneaten(inst, eater)
    if eater.components.poisonable then
        eater.components.poisonable:SetPoison(-2, 3, 60)
    end
end

local function commonfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("frog_legs")
    inst.AnimState:SetBuild("frog_legs_tree")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)


    inst:AddTag("smallmeat")
    inst:AddTag("fishmeat")
    inst:AddTag("catfood")
    inst:AddTag("rawmeat")

    inst:AddTag("poisonous")
    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible:SetOnEatenFn(oneaten)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("bait")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    MakeHauntableLaunchAndPerish(inst)

    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = 0

    return inst
end

local function defaultfn()
    local inst = commonfn()
    inst.AnimState:PlayAnimation("idle")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddTag("poisonous")

    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.edible.sanityvalue = -TUNING.SANITY_SMALL


    inst:AddComponent("cookable")
    inst.components.cookable.product = "froglegs_poison_cooked"
    inst:AddComponent("dryable")
    inst.components.dryable:SetProduct("smallmeat_dried")
    inst.components.dryable:SetDryTime(TUNING.DRY_FAST)
    return inst
end

local function cookedfn()
    local inst = commonfn("cooked")

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddTag("poisonous")

    inst.AnimState:PlayAnimation("cooked")
    inst.components.edible.foodstate = "COOKED"
    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)


    return inst
end

return
    Prefab("froglegs_poison", defaultfn, assets, prefabs),
    Prefab("froglegs_poison_cooked", cookedfn, assets)
