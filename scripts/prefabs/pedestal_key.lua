local assets =
{
    Asset("ANIM", "anim/pedestal_key.zip"),
}

-- 皇家画廊钥匙
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("pedestal_key")
    inst.AnimState:SetBuild("pedestal_key")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("key")
    inst.components.key.keytype = "royal gallery"

    inst:AddComponent("inspectable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inventoryitem")
    inst:AddComponent("tradable")

    return inst
end

return Prefab("pedestal_key", fn, assets)
