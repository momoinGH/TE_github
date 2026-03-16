local assets =
{
    Asset("ANIM", "anim/boat_repair_kit.zip"),
}

local function TargetCheck(inst, doer, target)
    return target:HasTag("shipwrecked_boat")
end

local function OnRepair(inst, doer, target)
    if target.components.health and target.components.health:IsHurt() then
        target.components.health:DoDelta(100)
        inst.components.finiteuses:Use(1)
        doer:PushEvent("repair") --可以播放一个音效
        return true
    end
    return false
end

local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("boat_repair_kit")
    inst.AnimState:SetBuild("boat_repair_kit")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst:AddTag("boatrepairkit")
    inst:AddTag("allow_action_on_impassable")
    inst:AddTag("boat_patch")

    inst:AddComponent("tro_componentaction"):InitUSEITEM(TargetCheck, "dolongaction", "REPAIR", OnRepair, { priority = 11 })

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    return inst
end

return Prefab("boatrepairkit", fn, assets)
