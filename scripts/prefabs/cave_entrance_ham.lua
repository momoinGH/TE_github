require("worldsettingsutil")

local assets =
{
    --Asset("ANIM", "anim/cave_entrance_ham.zip"),
    Asset("ANIM", "anim/pig_ruins_ground_entrance.zip"),
    Asset("ANIM", "anim/ruins_entrance.zip"),
    Asset("MINIMAP_IMAGE", "cave_closed"),
    Asset("MINIMAP_IMAGE", "cave_open"),
    Asset("MINIMAP_IMAGE", "cave_no_access"),
    Asset("MINIMAP_IMAGE", "cave_overcapacity"),
    Asset("MINIMAP_IMAGE", "ruins_closed"),
}

local prefabs =
{
    "bat",
    "rock_break_fx",
}

local function fn_ham1(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1.5)
    inst.MiniMapEntity:SetIcon("pig_ruins_ground_entrance.png")

    anim:SetBank("pig_ruins_ground_entrance")
    anim:SetBuild("pig_ruins_ground_entrance")

    inst.AnimState:PlayAnimation("idle_open")



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
    inst.components.worldmigrator.id = 1272
    inst.components.worldmigrator.receivedPortal = 1271

    if TUNING.tropical.tropicalshards == 5 or TUNING.tropical.tropicalshards == 10 or TUNING.tropical.tropicalshards == 20 or TUNING.tropical.tropicalshards == 30 then
        inst.components.worldmigrator.auto = false
        inst.components.worldmigrator.linkedWorld = "2"
    end

    return inst
end

local function fn_ham2(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1.5)
    inst.MiniMapEntity:SetIcon("pig_ruins_ground_entrance.png")

    anim:SetBank("pig_ruins_ground_entrance")
    anim:SetBuild("pig_ruins_ground_entrance")

    inst.AnimState:PlayAnimation("idle_open")



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
    inst.components.worldmigrator.id = 1372
    inst.components.worldmigrator.receivedPortal = 1371

    if TUNING.tropical.tropicalshards == 5 or TUNING.tropical.tropicalshards == 10 or TUNING.tropical.tropicalshards == 20 or TUNING.tropical.tropicalshards == 30 then
        inst.components.worldmigrator.auto = false
        inst.components.worldmigrator.linkedWorld = "2"
    end

    return inst
end

local function fn_ham3(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1.5)
    inst.MiniMapEntity:SetIcon("pig_ruins_ground_entrance.png")

    anim:SetBank("pig_ruins_ground_entrance")
    anim:SetBuild("pig_ruins_ground_entrance")

    inst.AnimState:PlayAnimation("idle_open")



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
    inst.components.worldmigrator.id = 1472
    inst.components.worldmigrator.receivedPortal = 1471

    if TUNING.tropical.tropicalshards == 5 or TUNING.tropical.tropicalshards == 10 or TUNING.tropical.tropicalshards == 20 or TUNING.tropical.tropicalshards == 30 then
        inst.components.worldmigrator.auto = false
        inst.components.worldmigrator.linkedWorld = "2"
    end

    return inst
end

return
    Prefab("cave_entrance_ham1", fn_ham1, assets, prefabs),
    Prefab("cave_entrance_ham2", fn_ham2, assets, prefabs),
    Prefab("cave_entrance_ham3", fn_ham3, assets, prefabs)
