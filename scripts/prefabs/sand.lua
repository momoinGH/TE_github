local assets =
{
    Asset("ANIM", "anim/sandhill.zip")
}

local function ongustblowawayfn(inst)
    if not inst.components.inventoryitem or not inst.components.inventoryitem.owner then
        inst:RemoveComponent("inventoryitem")
        inst:RemoveComponent("inspectable")
        inst.SoundEmitter:PlaySound("dontstarve/common/dust_blowaway")
        inst.AnimState:PlayAnimation("disappear")
        inst.persists = false
        inst:ListenForEvent("animover", inst.Remove)
        inst:ListenForEvent("entitysleep", inst.Remove)
    end
end

local function sandfn(Sim)
    local inst = CreateEntity()

    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    anim:SetBuild("sandhill")
    anim:SetBank("sandhill")
    anim:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    -----------------
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    ----------------------

    inst:AddComponent("inventoryitem")

    inst:AddComponent("blowinwindgust")
    inst.components.blowinwindgust:SetWindSpeedThreshold(0.2)
    inst.components.blowinwindgust:SetDestroyChance(0.1)
    inst.components.blowinwindgust:SetDestroyFn(ongustblowawayfn)

    return inst
end

return Prefab("sand", sandfn, assets)
