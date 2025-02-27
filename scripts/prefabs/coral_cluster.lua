local assets =
{
    Asset("ANIM", "anim/coral_cluster.zip"),
}

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)

    inst.Transform:SetScale(2, 2, 2)
    inst.AnimState:SetBank("coral_cluster")
    inst.AnimState:SetBuild("coral_cluster")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("tradable")
    inst:AddComponent("inspectable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "coral_cluster"


    return inst
end

return Prefab("coral_cluster", fn, assets)
