local assets =
{
    Asset("ANIM", "anim/quagmire_sapbucket.zip"),
}

local function TargetCheck(inst, doer, target)
    return target:HasTag("tappable") and not target:HasTag("tapped") and not target:HasTag("stump")
end

local function ConsumableState(inst, doer)
    return doer:HasTag("quagmire_fasthands") and "domediumaction" or "dolongaction"
end

local function OnUse(inst, doer, target)
    if target.components.sappy then
        target.components.sappy:Tap(inst)
        return true
    end
    return false
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("quagmire_sapbucket")
    inst.AnimState:SetBuild("quagmire_sapbucket")
    inst.AnimState:PlayAnimation("idle")

    inst:AddComponent("pro_componentaction"):InitUSEITEM(TargetCheck, ConsumableState, "TAPSUGARTREE", OnUse)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "quagmire_sapbucket"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("inspectable")
    return inst
end

return Prefab("quagmire_sapbucket", fn, assets, prefabs)
