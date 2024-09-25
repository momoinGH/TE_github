local assets =
{
    Asset("ANIM", "anim/quagmire_slaughtertool.zip"),
}

local function TargetCheck(inst, doer, target)
    return target:HasTag("canbeslaughtered")
end

local function ConsumableState(inst, doer)
    return doer:HasTag("quagmire_fasthands") and "domediumaction" or "dolongaction"
end

local function OnUse(inst, doer, target)
    if target.components.health and target.components.lootdropper then
        if doer.prefab == "wigfrid" then
            target.components.lootdropper:DropLoot()
        end
        target.components.health.invincible = false
        inst.components.finiteuses:Use(1)
        target.components.health:Kill()
        return true
    end
    return false
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("quagmire_slaughtertool")
    inst.AnimState:SetBuild("quagmire_slaughtertool")
    inst.AnimState:PlayAnimation("idle")

    inst:AddComponent("pro_componentaction"):InitUSEITEM(TargetCheck, ConsumableState, "KILLSOFTLY", OnUse)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    if TheNet:GetServerGameMode() ~= "quagmire" then
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(TUNING.TRAP_USES)
        inst.components.finiteuses:SetUses(TUNING.TRAP_USES)
        inst.components.finiteuses:SetOnFinished(inst.Remove)
    end

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("quagmire_slaughtertool", fn, assets)
