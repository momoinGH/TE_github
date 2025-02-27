local assets =
{
    Asset("ANIM", "anim/feather_peagawk_prism.zip"),
}

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)


    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("feather_peekock_prism")
    inst.AnimState:SetBuild("feather_peagawk_prism")
    inst.AnimState:PlayAnimation("idle", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "ELEMENTAL"
    inst.components.edible.hungervalue = 2
    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    inst:AddComponent("stackable")
    inst:AddComponent("inventoryitem")


    inst:AddComponent("bait")
    inst:AddTag("molebait")
    inst:AddTag("scarerbait")

    return inst
end

return Prefab("peagawkfeather_prism", fn, assets)
