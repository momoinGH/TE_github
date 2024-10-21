local assets =
{
    Asset("ANIM", "anim/peach.zip"),
}

local prefabs =
{
    "spoiled_food",
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("peach")
    inst.AnimState:SetBank("peach")
    inst.AnimState:PlayAnimation("idle", false)

    local s = 1
    inst.Transform:SetScale(s, s, s)

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.hungervalue = 150
    inst.components.edible.foodtype = FOODTYPE.PEACHY
    inst.components.edible.healthvalue = 150

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = 10

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    MakeHauntableLaunchAndPerish(inst)

    return inst
end

return Prefab("peachy_treat", fn, assets, prefabs)
