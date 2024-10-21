local assets =
{
    Asset("ANIM", "anim/pollen.zip"),
}

local prefabs =
{
    "pollen_cooked",
}
--[[
local function oneaten(inst, eater)
    if eater.components.poisonable then
	eater.components.poisonable:SetPoison(-2, 3, 60)
    end
end
]]


local function commonfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("pollen")
    inst.AnimState:SetBuild("pollen")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)


    inst:AddTag("pollen")
    --inst:AddTag("poisonous")
    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    --inst.components.edible:SetOnEatenFn(oneaten)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

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

    --inst:AddTag("poisonous")

    inst.components.edible.healthvalue = TUNING.HEALING_SMALL
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY
    inst.components.edible.sanityvalue = -TUNING.SANITY_SMALL


    inst:AddComponent("cookable")
    inst.components.cookable.product = "pollen_cooked"

    return inst
end

local function cookedfn()
    local inst = commonfn("cooked")

    if not TheWorld.ismastersim then
        return inst
    end
    --inst:AddTag("poisonous")

    inst.AnimState:PlayAnimation("cooked")
    inst.components.edible.foodstate = "COOKED"
    inst.components.edible.healthvalue = TUNING.HEALING_SMALL
    inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)


    return inst
end

return
    Prefab("pollen_item", defaultfn, assets, prefabs),
    Prefab("pollen_cooked", cookedfn, assets)
