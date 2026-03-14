local assets =
{
    Asset("ANIM", "anim/poison_salve.zip"),
}

local function oneat(inst, eater)
    if not eater.components.poisonable then return end
    eater.components.poisonable:WearOff(TUNING.TOTAL_DAY_TIME / 2)
    return true
end

local function oneat_anti(inst, eater)
    if not oneat(inst, eater) or not eater:HasTag("player") then return end
    eater.AnimState:PlayAnimation("research")
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "idle_water", "idle")

    inst.AnimState:SetBank("poison_salve")
    inst.AnimState:SetBuild("poison_salve")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    local healer = inst:AddComponent("healer")
    healer:SetHealthAmount(0)
    healer:SetOnHealFn(oneat_anti)

    return inst
end

return Prefab("poisonbalm", fn, assets)
