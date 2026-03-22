local assets =
{
    Asset("ANIM", "anim/hedge.zip"),
    Asset("ANIM", "anim/hedge1_build.zip"),
    Asset("ANIM", "anim/hedge2_build.zip"),
    Asset("ANIM", "anim/hedge3_build.zip"),
}

local prefabs =
{
    "clippings",
    "collapse_small",
}



----------------------------------------------------------------------------------------------------
local function ondeploywall(inst, pt, deployer)
    local wall = SpawnPrefab(inst.deploy_spawn)
    if wall ~= nil then
        local x = math.floor(pt.x) + .5
        local z = math.floor(pt.z) + .5
        wall.Physics:SetCollides(false)
        wall.Physics:Teleport(x, 0, z)
        wall.Physics:SetCollides(true)
        inst.components.stackable:Get():Remove()

        wall.SoundEmitter:PlaySound("dontstarve/common/place_structure_straw")
    end
end

local function OnHammer(inst)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end

    if not inst.components.fixable then
        inst.components.lootdropper:SpawnLootPrefab("clippings")
        inst.components.lootdropper:SpawnLootPrefab("clippings")
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    for i = 1, math.random(5, 10) do
        local fx = SpawnPrefab("robot_leaf_fx")
        fx.Transform:SetPosition(x + (math.random() * 2) - 1, y + math.random() * 0.5, z + (math.random() * 2) - 1)
        if math.random() < 0.5 then
            fx.Transform:SetScale(-1, 1, -1)
        end
    end
    inst:Remove()
end

local function onhit(inst)
    local fx = SpawnPrefab("robot_leaf_fx")
    local x, y, z = inst.Transform:GetWorldPosition()
    fx.Transform:SetPosition(x, y + math.random() * 0.5, z)
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/vine_hack")
end

local function GetGrowTime(inst)
    -- return TUNING.TOTAL_DAY_TIME / 2 + math.random() * TUNING.TOTAL_DAY_TIME
    return 5
end

local stages = {
    {
        name = "1",
        time = GetGrowTime,
        fn = function(inst, stage, stage_data)
            inst.AnimState:PlayAnimation("growth1")
            inst.components.shearable:SetWorkLeft(0)
        end,
    },
    {
        name = "2",
        time = GetGrowTime,
        fn = function(inst, stage, stage_data)
            inst.AnimState:PlayAnimation("growth2", false)
            inst.components.shearable:SetWorkLeft(1)
        end,
        growfn = function(inst)
            inst.AnimState:PlayAnimation("growth1to2")
            inst.AnimState:PushAnimation("growth2", false)
        end
    },
    {
        name = "3",
        time = GetGrowTime,
        fn = function(inst, stage, stage_data)
            inst.AnimState:PlayAnimation("growth3", false)
            inst.components.shearable:SetWorkLeft(1)
        end,
        growfn = function(inst)
            inst.AnimState:PlayAnimation("growth1to2")
            inst.AnimState:PushAnimation("growth2", false)
        end
    },
}

local function OnShear(inst, data)
    local stage = inst.components.growable:GetStage()
    TroSpawnDropItem(inst, "clippings", stage - 1)
    inst.components.growable:SetStage(1)
    inst.AnimState:PlayAnimation("growth" .. stage .. "to1")
    inst.AnimState:PushAnimation("growth1", false)
end

local function MakeHedge(name, data)
    local function item_fn()
        local inst = CreateEntity()
        inst:AddTag("wallbuilder")

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("hedge")
        inst.AnimState:SetBuild(data.build)
        inst.AnimState:PlayAnimation("idle")

        MakeInventoryFloatable(inst)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.deploy_spawn = name

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")

        MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
        MakeSmallPropagator(inst)

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

        inst:AddComponent("deployable")
        inst.components.deployable.ondeploy = ondeploywall
        inst.components.deployable:SetDeployMode(DEPLOYMODE.WALL)

        MakeHauntableLaunch(inst)

        return inst
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst.Transform:SetEightFaced()

        inst.AnimState:SetRayTestOnBB(true)
        inst.AnimState:SetBank("hedge")
        inst.AnimState:SetBuild(data.build)
        inst.AnimState:PlayAnimation("growth1", true)
        MakeObstaclePhysics(inst, .5)

        inst:AddTag("wall")
        inst:AddTag("grass")
        inst:AddTag("hedge")
        inst:AddTag("machetecut")
        inst:AddTag("hedgetoshear")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")
        inst:AddComponent("lootdropper")

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(3)
        inst.components.workable:SetOnFinishCallback(OnHammer)
        inst.components.workable:SetOnWorkCallback(onhit)

        inst:AddComponent("shearable")
        inst.components.shearable:SetMaxWork(1)
        inst:ListenForEvent("onshear", OnShear)
        -- inst.components.shearable:SetProduct("clippings", 2)

        inst:AddComponent("growable")
        inst.components.growable.stages = stages
        inst.components.growable:SetStage(math.random(1, 3))
        inst.components.growable.springgrowth = true
        inst.components.growable:StartGrowing()

        MakeMediumBurnable(inst)
        MakeSmallPropagator(inst)
        MakeHauntableIgnite(inst)

        return inst
    end


    return Prefab(name, fn, assets, prefabs),
        Prefab(name .. "_item", item_fn, assets, prefabs),
        MakePlacer(name .. "_item_placer", "hedge", "hedge1_build", "growth3", false, false, true, nil, nil, "eight")
end


return MakeHedge("hedge_block", { build = "hedge1_build" }),
    MakeHedge("hedge_cone", { build = "hedge2_build" }),
    MakeHedge("hedge_layered", { build = "hedge3_build" })
