local assets =
{
    Asset("ANIM", "anim/lavaarena_boaraudience1.zip"),
    --    Asset("ANIM", "anim/lavaarena_boaraudience1_build_1.zip"),
    --    Asset("ANIM", "anim/lavaarena_boaraudience1_build_2.zip"),
    --    Asset("ANIM", "anim/lavaarena_boaraudience1_build_3.zip"),
    Asset("ANIM", "anim/lavaarena_decor.zip"),
    Asset("ANIM", "anim/lavaarena_banner.zip"),
}

local prefabs =
{
}


local function fn1()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("forgeboar.png")

    inst.Transform:SetFourFaced()
    MakeObstaclePhysics(inst, 1.5, .5)
    inst.Transform:SetRotation(0)


    inst.DynamicShadow:SetSize(10, 5)

    inst.AnimState:SetBuild("lavaarena_boaraudience1")
    inst.AnimState:SetBank("lavaarena_boaraudience1")
    inst.AnimState:PlayAnimation("idle_loop", true)



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("store")
    return inst
end


local function fn2()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("forgeboar.png")

    inst.Transform:SetFourFaced()
    MakeObstaclePhysics(inst, 1.5, .5)
    inst.Transform:SetRotation(270)


    inst.DynamicShadow:SetSize(10, 5)

    inst.AnimState:SetBuild("lavaarena_boaraudience1")
    inst.AnimState:SetBank("lavaarena_boaraudience1")
    inst.AnimState:PlayAnimation("idle_loop", true)



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("store")
    return inst
end

local function fn3()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("forgeboar.png")

    inst.Transform:SetFourFaced()
    MakeObstaclePhysics(inst, 1.5, .5)
    inst.Transform:SetRotation(270)


    inst.DynamicShadow:SetSize(10, 5)

    inst.AnimState:SetBuild("lavaarena_boaraudience1")
    inst.AnimState:SetBank("lavaarena_boaraudience1")
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("store")
    return inst
end

local function fn4()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("forgeboar.png")

    inst.Transform:SetFourFaced()
    MakeObstaclePhysics(inst, 1.5, .5)
    inst.Transform:SetRotation(180)


    inst.DynamicShadow:SetSize(10, 5)

    inst.AnimState:SetBuild("lavaarena_boaraudience1")
    inst.AnimState:SetBank("lavaarena_boaraudience1")
    inst.AnimState:PlayAnimation("idle_loop", true)



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("store")
    return inst
end

local function cerca()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("NOCLICK")
    inst:AddTag("DECOR")

    inst.Transform:SetScale(2, 2, 2)
    inst.Transform:SetEightFaced()

    inst.AnimState:SetBank("lavaarena_decor")
    inst.AnimState:SetBuild("lavaarena_decor")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("blocker")
    local phys = inst.entity:AddPhysics()
    phys:SetMass(0)
    phys:SetCollisionGroup(COLLISION.WORLD)
    phys:ClearCollisionMask()
    phys:CollidesWith(COLLISION.ITEMS)
    phys:CollidesWith(COLLISION.CHARACTERS)
    phys:CollidesWith(COLLISION.GIANTS)
    phys:CollidesWith(COLLISION.FLYERS)
    phys:SetCapsule(0.5, 50)

    inst.entity:SetPristine()


    --    for i, v in ipairs({ "banner1", "banner2", "teeth1", "teeth3", "teeth2", "teeth4" }) do
    inst.AnimState:Hide("banner1")
    inst.AnimState:Hide("banner2")
    --    end

    return inst
end

return
    Prefab("lavaarena_spectator1", fn1, assets, prefabs), --合并成一个
    Prefab("lavaarena_spectator2", fn2, assets, prefabs),
    Prefab("lavaarena_spectator3", fn3, assets, prefabs),
    Prefab("lavaarena_spectator4", fn4, assets, prefabs),
    Prefab("lavaarena_cerca", cerca, assets, prefabs)
