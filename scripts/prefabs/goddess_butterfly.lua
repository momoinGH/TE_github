local assets =
{
    Asset("ANIM", "anim/goddess_butterfly_basic.zip"),
}

local prefabs =
{
    "goddess_butterflywings",
    "butter",
    "flower",
}

local brain = require "brains/butterflybrain"

SetSharedLootTable('goddess_butterfly',
    {
        { 'butter',                 0.01 },
        { 'goddess_butterflywings', 0.20 },
        { 'goddess_butterflywings', 0.75 },
    })

local function OnDropped(inst)
    inst.sg:GoToState("idle")
    if inst.butterflyspawner ~= nil then
        inst.butterflyspawner:StartTracking(inst)
    end
    if inst.components.workable ~= nil then
        inst.components.workable:SetWorkLeft(1)
    end
    if inst.components.stackable ~= nil then
        while inst.components.stackable:StackSize() > 1 do
            local item = inst.components.stackable:Get()
            if item ~= nil then
                if item.components.inventoryitem ~= nil then
                    item.components.inventoryitem:OnDropped()
                end
                item.Physics:Teleport(inst.Transform:GetWorldPosition())
            end
        end
    end
end

local function OnPickedUp(inst)
    if inst.butterflyspawner ~= nil then
        inst.butterflyspawner:StopTracking(inst)
    end
end

local function OnWorked(inst, worker)
    if worker.components.inventory ~= nil then
        if inst.butterflyspawner ~= nil then
            inst.butterflyspawner:StopTracking(inst)
        end
        worker.components.inventory:GiveItem(inst, nil, inst:GetPosition())
        worker.SoundEmitter:PlaySound("dontstarve/common/butterfly_trap")
    end
end

local function CanDeploy(inst)
    return true
end

local function OnDeploy(inst, pt)
    local flower = SpawnPrefab("goddess_flower")
    if flower then
        flower:PushEvent("growfrombutterfly")
        flower.Transform:SetPosition(pt:Get())
        inst.components.stackable:Get():Remove()
    end
end

local function fn()
    local inst = CreateEntity()

    --Core components
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddDynamicShadow()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    --Initialize physics
    MakeCharacterPhysics(inst, 1, .5)
    inst.Physics:SetCollisionGroup(COLLISION.FLYERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)

    MakeInventoryFloatable(inst)

    inst:AddTag("goddess_butterfly")
    inst:AddTag("butterfly")
    inst:AddTag("flying")
    inst:AddTag("insect")
    inst:AddTag("smallcreature")
    inst:AddTag("cattoyairborne")
    inst:AddTag("wildfireprotected")

    inst.Transform:SetTwoFaced()

    inst.AnimState:SetBuild("goddess_butterfly_basic")
    inst.AnimState:SetBank("butterfly")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetRayTestOnBB(true)

    inst.DynamicShadow:SetSize(.8, .5)

    MakeFeedableSmallLivestockPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    ---------------------
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor:SetTriggersCreep(false)
    inst:SetStateGraph("SGbutterfly")

    ---------------------
    inst:AddComponent("stackable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.canbepickedupalive = true
    inst.components.inventoryitem.nobounce = true

    ------------------
    inst:AddComponent("pollinator")

    ------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(1)

    ------------------
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "butterfly_body"

    ------------------
    inst:AddComponent("knownlocations")

    MakeSmallBurnableCharacter(inst, "butterfly_body")
    MakeTinyFreezableCharacter(inst, "butterfly_body")

    ------------------
    inst:AddComponent("inspectable")

    ------------------
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('goddess_butterfly')

    ------------------
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.NET)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(OnWorked)

    ------------------
    inst:AddComponent("tradable")

    ------------------
    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = OnDeploy
    inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)

    MakeHauntablePanicAndIgnite(inst)

    inst:SetBrain(brain)

    inst.butterflyspawner = TheWorld.components.butterflyspawner
    if inst.butterflyspawner ~= nil then
        inst.components.inventoryitem:SetOnPickupFn(inst.butterflyspawner.StopTrackingFn)
        inst:ListenForEvent("onremove", inst.butterflyspawner.StopTrackingFn)
        inst.butterflyspawner:StartTracking(inst)
    end

    MakeFeedableSmallLivestock(inst, TUNING.BUTTERFLY_PERISH_TIME, OnPickedUp, OnDropped)

    return inst
end

return Prefab("goddess_butterfly", fn, assets, prefabs),
    MakePlacer("goddess_butterfly_placer", "flowers", "flowers", "f1")
