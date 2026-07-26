local assets =
{
    Asset("ANIM", "anim/venom_gland.zip"),
}

local MAX_VENOM_GLAND_DAMAGE = 80
local MIN_VENOM_GLAND_LEFTOVER = 5

local function oneat(inst, eater)
    if not eater.components.poisonable then return end
    eater.components.poisonable:WearOff(TUNING.TOTAL_DAY_TIME / 2)
    return true
end

local function oneat_gland(inst, eater)
    if not oneat(inst, eater) then return end
    local health = eater.components.health
    if not health then return end
    health:DoDelta(health.currenthealth - MIN_VENOM_GLAND_LEFTOVER < MAX_VENOM_GLAND_DAMAGE and
        MIN_VENOM_GLAND_LEFTOVER - health.currenthealth or -MAX_VENOM_GLAND_DAMAGE, nil, "venomgland")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("venom_gland")
    inst.AnimState:SetBuild("venom_gland")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")

    MakeSmallBurnable(inst, TUNING.TINY_BURNTIME)
    MakeSmallPropagator(inst)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddTag("cattoy")
    inst:AddTag("venomgland")
    inst:AddComponent("tradable")

    local healer = inst:AddComponent("healer")
    healer:SetHealthAmount(0)
    healer:SetOnHealFn(oneat_gland)

    return inst
end

return Prefab("venomgland", fn, assets)
