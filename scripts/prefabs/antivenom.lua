local assets =
{
    Asset("ANIM", "anim/poison_antidote.zip"),
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

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("poison_antidote")
    inst.AnimState:SetBuild("poison_antidote")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("healer")
    inst.components.healer:SetHealthAmount(0)
    inst.components.healer:SetOnHealFn(oneat_anti)

    return inst
end

return Prefab("antivenom", fn, assets)
