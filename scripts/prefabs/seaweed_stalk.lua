local assets =
{
    Asset("ANIM", "anim/seaweed_seed.zip"),
}


local prefabs =
{
    "seaweed_planted",
}

local function ondeploy(inst, pt)
    inst = inst.components.stackable:Get()
    inst:Remove()
    --local timeToGrow = GetRandomWithVariance(TUNING.PINECONE_GROWTIME.base, TUNING.PINECONE_GROWTIME.random)
    local stalk = SpawnPrefab("seaweed_planted")
    stalk.Transform:SetPosition(pt:Get())
    stalk.components.pickable:MakeEmpty()
    stalk.AnimState:PlayAnimation("picked")
end

local function fnseaweed(sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("seaweed_seed")
    inst.AnimState:SetBuild("seaweed_seed")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("aquatic")
    inst:AddTag("deployedplant")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    MakeSmallBurnable(inst, TUNING.TINY_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndIgnite(inst)

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable:SetDeployMode(DEPLOYMODE.WATER)
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.NONE)


    inst:AddComponent("inventoryitem")


    return inst
end

return Prefab("seaweed_stalk", fnseaweed, assets, prefabs),
    MakePlacer("seaweed_stalk_placer", "seaweed_seed", "seaweed_seed", "idle_plant", false, false, false)
