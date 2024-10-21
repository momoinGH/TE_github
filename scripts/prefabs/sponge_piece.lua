local assets =
{
    Asset("ANIM", "anim/sponge_piece.zip"),
}

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddNetwork()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)

    anim:SetBank("sponge_piece")
    anim:SetBuild("sponge_piece")
    anim:PlayAnimation("anim")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "sponge_piece"

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "SPONGE"

    return inst
end

return Prefab("sponge_piece", fn, assets)
