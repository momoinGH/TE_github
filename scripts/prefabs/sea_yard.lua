local assets =
{
    Asset("ANIM", "anim/sea_yard.zip"),
    Asset("MINIMAP_IMAGE", "sea_yard"),
    Asset("ANIM", "anim/sea_yard_meter.zip"),
}

local prefabs =
{
    "collapse_small",
    "sea_yard_arms_fx"
}

local loot =
{
    "limestone",
    "limestone",
    "limestone",
    "tar",
    "tar",
    "tar",
    "log",
    "log",
}

local SEA_YARD_MAX_FUEL_TIME = 30 * 6

local function stopFixingFn(inst)
    inst.components.fueled:StopConsuming()
    if inst.task_fix then
        inst.task_fix:Cancel()
        inst.task_fix = nil
    end

    inst.AnimState:PlayAnimation("idle", true)

    inst.boat = nil
    if inst.armsfx then
        inst.armsfx:stopfx()
        inst.armsfx = nil
    end
end


local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", true)
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/seagull/chirp_seagull")
end

local function getstatus(inst, viewer)
    if inst.components.fueled and inst.components.fueled.currentfuel <= 0 then
        return "OFF"
    elseif inst.components.fueled and (inst.components.fueled.currentfuel / inst.components.fueled.maxfuel) <= .25 then
        return "LOWFUEL"
    else
        return "ON"
    end
end

local BOAT_MUST_TAGS = { "shipwrecked_boat", "_health" }
local function FindNearbyBoat(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    for _, v in ipairs(TheSim:FindEntities(x, y, z, 5, BOAT_MUST_TAGS)) do
        if v.components.health and v.components.health:IsHurt() then
            return v
        end
    end
end


local function Repair(inst)
    local boat = inst.boat
    if not boat
        or not boat:IsValid()
        or boat:GetDistanceSqToInst(inst) > 25
        or not boat.components.health
        or not boat.components.health:IsHurt()
    then
        stopFixingFn(inst)

        boat = FindNearbyBoat(inst)
        if boat then
            local arms = SpawnPrefab("sea_yard_arms_fx")
            arms.entity:SetParent(boat.entity)
            arms.AnimState:SetFinalOffset(5)
            inst.armsfx = arms
            inst.components.fueled:StartConsuming()
            inst.boat = boat

            inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/seagull/chirp_seagull")
            inst:DoTaskInTime(18 / 30, function() inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/seagull/chirp_seagull") end)

            inst.AnimState:PlayAnimation("enter")
            inst.AnimState:PushAnimation("idle", true)
        end
    end

    if boat then
        inst.task_fix = inst:DoTaskInTime(1, function()
            if boat:IsValid() and boat.components.health then
                boat.components.health:SetPercent(boat.components.health:GetPercent() + 0.05 / 2, true)
            end
        end)
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", true)
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/shipyard/craft")
end

local function OnPercentUsedChange(inst, data)
    inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/machine_fuel")
    local fuelAnim = math.ceil(inst.components.fueled:GetPercent() * 10) .. ""
    inst.AnimState:OverrideSymbol("swap_meter", "sea_yard_meter", fuelAnim)

    if data.percent > 0 then
        if not inst.components.simpleperiodtask:TaskExists("repair") then
            inst.components.simpleperiodtask:DoPeriodicTask("repair", 0.5, Repair)
        end
    else
        inst.components.simpleperiodtask:Cancel("repair")
        stopFixingFn(inst)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetPriority(5)
    inst.MiniMapEntity:SetIcon("sea_yard.png")

    inst:SetPhysicsRadiusOverride(1.5)
    MakeWaterObstaclePhysics(inst, 0.4, 2, 1.25)

    inst.AnimState:SetBank("sea_yard")
    inst.AnimState:SetBuild("sea_yard")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("structure")
    inst:AddTag("nowaves")
    inst:AddTag("seayard")
    inst:AddTag("ignorewalkableplatforms")
    inst.AnimState:OverrideSymbol("swap_meter", "sea_yard_meter", 10)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.task_fix = nil

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("fueled")
    inst.components.fueled.accepting = true
    inst.components.fueled:SetSections(10)
    inst.components.fueled:InitializeFuelLevel(SEA_YARD_MAX_FUEL_TIME)
    inst.components.fueled.bonusmult = 5
    inst.components.fueled.fueltype = FUELTYPE.TAR

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)
    MakeSnowCovered(inst)

    inst:AddComponent("simpleperiodtask")
    inst.components.simpleperiodtask:DoPeriodicTask("repair", 0.5, Repair) --加载范围外不生效

    inst:ListenForEvent("onbuilt", onbuilt)
    inst:ListenForEvent("percentusedchange", OnPercentUsedChange)

    return inst
end

----------------------------------------------------------------------------------------------------
local item_assets = {
    Asset("ANIM", "anim/seafarer_boatsw.zip")
}

local function ondeploysea_yard(inst, pt, deployer)
    local boat = SpawnPrefab("sea_yard")
    if boat ~= nil then
        boat.Transform:SetPosition(pt.x, 0, pt.z)
        inst:Remove()
    end
end

local function item_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("seafarer_boatsw")
    inst.AnimState:SetBuild("seafarer_boatsw")
    inst.AnimState:PlayAnimation("seayard", true)

    inst.overridedeployplacername = "sea_yard_placer"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploysea_yard
    inst.components.deployable:SetDeployMode(DEPLOYMODE.WATER)
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    MakeSmallBurnable(inst, TUNING.TINY_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndIgnite(inst)

    return inst
end

return Prefab("sea_yard", fn, assets, prefabs),
    MakePlacer("sea_yard_placer", "sea_yard", "sea_yard", "placer"),
    Prefab("porto_sea_yard", item_fn, item_assets, prefabs)
