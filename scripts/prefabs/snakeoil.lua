local assets =
{
    Asset("ANIM", "anim/snakeoil.zip"),
}

local function oneat(inst, eater)
    if not eater.components.poisonable then return end
    eater.components.poisonable:WearOff(TUNING.TOTAL_DAY_TIME / 2)
    return true
end

local function oneat_oil(inst, eater)
    if not oneat(inst, eater) then return end
    eater.SoundEmitter:PlaySound("dontstarve_DLC002/common/HUD_antivenom_use")
    eater.AnimState:PlayAnimation("research")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("snakeoil")
    inst.AnimState:SetBuild("snakeoil")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = 0

    local healer = inst:AddComponent("healer")
    healer:SetHealthAmount(0)
    healer:SetOnHealFn(oneat_oil)

    return inst
end

return Prefab("common/inventory/snakeoil", fn, assets)
