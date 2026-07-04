require 'prefabutil'

local assets =
{
    Asset("ANIM", "anim/portal_hamlet.zip"),
    Asset("ANIM", "anim/portal_hamlet_build.zip"),
    Asset("ANIM", "anim/portal_shipwrecked.zip"),
    Asset("ANIM", "anim/portal_shipwrecked_build.zip"),
    Asset("ANIM", "anim/portal_stone.zip"),
}

local prefabs =
{
}

local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)
    inst.MiniMapEntity:SetIcon("shipwrecked_exit.png")

    anim:SetBank("boatportal")
    anim:SetBuild("portal_shipwrecked_build")

    inst.AnimState:PlayAnimation("idle_on")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    if TheNet:GetServerIsClientHosted() and not (TheShard:IsMaster() or TheShard:IsSecondary()) then
        --On non-sharded servers we'll make these vanish for now, but still generate them
        --into the world so that they can magically appear in existing saves when sharded
        RemovePhysicsColliders(inst)
        inst.AnimState:SetScale(0, 0)
        inst.MiniMapEntity:SetEnabled(false)
        inst:AddTag("NOCLICK")
        inst:AddTag("CLASSIFIED")
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("worldmigrator")
    inst.components.worldmigrator.id = 1878
    inst.components.worldmigrator.receivedPortal = 1877

    return inst
end

local function fn1(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)
    inst.MiniMapEntity:SetIcon("portal_ham.png")

    anim:SetBank("hamportal")
    anim:SetBuild("portal_hamlet_build")

    inst.AnimState:PlayAnimation("idle_on")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    if TheNet:GetServerIsClientHosted() and not (TheShard:IsMaster() or TheShard:IsSecondary()) then
        --On non-sharded servers we'll make these vanish for now, but still generate them
        --into the world so that they can magically appear in existing saves when sharded
        RemovePhysicsColliders(inst)
        inst.AnimState:SetScale(0, 0)
        inst.MiniMapEntity:SetEnabled(false)
        inst:AddTag("NOCLICK")
        inst:AddTag("CLASSIFIED")
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("worldmigrator")
    inst.components.worldmigrator.id = 1887
    inst.components.worldmigrator.receivedPortal = 1888

    return inst
end

local function fn2(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)
    inst.MiniMapEntity:SetIcon("portal.png")

    anim:SetBank("boatportal")
    anim:SetBuild("portal_shipwrecked_build")

    inst.AnimState:PlayAnimation("idle_on")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    if TheNet:GetServerIsClientHosted() and not (TheShard:IsMaster() or TheShard:IsSecondary()) then
        --On non-sharded servers we'll make these vanish for now, but still generate them
        --into the world so that they can magically appear in existing saves when sharded
        RemovePhysicsColliders(inst)
        inst.AnimState:SetScale(0, 0)
        inst.MiniMapEntity:SetEnabled(false)
        inst:AddTag("NOCLICK")
        inst:AddTag("CLASSIFIED")
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("worldmigrator")
    inst.components.worldmigrator.id = 1877
    inst.components.worldmigrator.receivedPortal = 1878

    return inst
end

local function fn3(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)
    inst.MiniMapEntity:SetIcon("portal_ham.png")

    anim:SetBank("hamportal")
    anim:SetBuild("portal_hamlet_build")

    inst.AnimState:PlayAnimation("idle_on")



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    if TheNet:GetServerIsClientHosted() and not (TheShard:IsMaster() or TheShard:IsSecondary()) then
        --On non-sharded servers we'll make these vanish for now, but still generate them
        --into the world so that they can magically appear in existing saves when sharded
        RemovePhysicsColliders(inst)
        inst.AnimState:SetScale(0, 0)
        inst.MiniMapEntity:SetEnabled(false)
        inst:AddTag("NOCLICK")
        inst:AddTag("CLASSIFIED")
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("worldmigrator")
    inst.components.worldmigrator.id = 1888
    inst.components.worldmigrator.receivedPortal = 1887

    return inst
end

local function fn4(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)
    inst.MiniMapEntity:SetIcon("portal_dst.png")

    anim:SetBank("portal_dst")
    anim:SetBuild("portal_stone")

    inst.AnimState:PlayAnimation("idle_loop", true)



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    if TheNet:GetServerIsClientHosted() and not (TheShard:IsMaster() or TheShard:IsSecondary()) then
        --On non-sharded servers we'll make these vanish for now, but still generate them
        --into the world so that they can magically appear in existing saves when sharded
        RemovePhysicsColliders(inst)
        inst.AnimState:SetScale(0, 0)
        inst.MiniMapEntity:SetEnabled(false)
        inst:AddTag("NOCLICK")
        inst:AddTag("CLASSIFIED")
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("worldmigrator")
    inst.components.worldmigrator.id = 2847
    inst.components.worldmigrator.receivedPortal = 2848

    return inst
end

local function fn5(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)
    inst.MiniMapEntity:SetIcon("portal_dst.png")

    anim:SetBank("portal_dst")
    anim:SetBuild("portal_stone")

    inst.AnimState:PlayAnimation("idle_loop", true)



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    if TheNet:GetServerIsClientHosted() and not (TheShard:IsMaster() or TheShard:IsSecondary()) then
        --On non-sharded servers we'll make these vanish for now, but still generate them
        --into the world so that they can magically appear in existing saves when sharded
        RemovePhysicsColliders(inst)
        inst.AnimState:SetScale(0, 0)
        inst.MiniMapEntity:SetEnabled(false)
        inst:AddTag("NOCLICK")
        inst:AddTag("CLASSIFIED")
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("worldmigrator")
    inst.components.worldmigrator.id = 2848
    inst.components.worldmigrator.receivedPortal = 2847

    return inst
end


return Prefab("dst_to_sw", fn, assets, prefabs),
    Prefab("dst_to_hamlet", fn1, assets, prefabs),
    Prefab("sw_to_dst", fn2, assets, prefabs),
    Prefab("hamlet_to_dst", fn3, assets, prefabs),
    Prefab("lobby_to_dst", fn4, assets, prefabs),
    Prefab("dst_to_lobby", fn5, assets, prefabs)
