local assets =
{
    Asset("ANIM", "anim/gorge_merm_house.zip"),
}

local prefabs =
{
    "merm",
    "collapse_big",

    --loot:
    "boards",
    "cutstone",
    "oceanfish_small_11_inv",
}

local loot =
{
    "boards",
    "cutstone",
    "cutstone",
    "oceanfish_small_11_inv",
}

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst:RemoveComponent("childspawner")
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        if inst.components.childspawner ~= nil then
            inst.components.childspawner:ReleaseAllChildren(worker)
        end
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle")
    end
end

local function StartSpawning(inst)
    if not inst:HasTag("burnt") and
        not TheWorld.state.iswinter and
        inst.components.childspawner ~= nil then
        inst.components.childspawner:StartSpawning()
    end
end

local function StopSpawning(inst)
    if not inst:HasTag("burnt") and inst.components.childspawner ~= nil then
        inst.components.childspawner:StopSpawning()
    end
end

local function OnSpawned(inst, child)
    if not inst:HasTag("burnt") then
        inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
        if TheWorld.state.isday and
            inst.components.childspawner ~= nil and
            inst.components.childspawner:CountChildrenOutside() >= 1 and
            child.components.combat.target == nil then
            StopSpawning(inst)
        end
    end
end

local function OnGoHome(inst, child)
    if not inst:HasTag("burnt") then
        inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
        if inst.components.childspawner ~= nil and
            inst.components.childspawner:CountChildrenOutside() < 1 then
            StartSpawning(inst)
        end
    end
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local function onignite(inst)
    if inst.components.childspawner ~= nil then
        inst.components.childspawner:ReleaseAllChildren()
    end
end

local function onburntup(inst)
    inst.AnimState:PlayAnimation("burnt")
end

local function OnIsDay(inst, isday)
    if isday then
        StopSpawning(inst)
    elseif not inst:HasTag("burnt") then
        if not TheWorld.state.iswinter then
            inst.components.childspawner:ReleaseAllChildren()
        end
        StartSpawning(inst)
    end
end

local function OnHaunt(inst)
    if inst.components.childspawner == nil or
        not inst.components.childspawner:CanSpawn() or
        math.random() > TUNING.HAUNT_CHANCE_HALF then
        return false
    end

    local target = FindEntity(inst, 25, nil, { "character" }, { "merm", "playerghost", "INLIMBO" })
    if target == nil then
        return false
    end

    onhit(inst, target)
    return true
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)

    inst.MiniMapEntity:SetIcon("quagmire_merm_house.png")

    inst.AnimState:SetBank("gorge_merm_house")
    inst.AnimState:SetBuild("gorge_merm_house")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("structure")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "merm1"
    inst.components.childspawner:SetSpawnedFn(OnSpawned)
    inst.components.childspawner:SetGoHomeFn(OnGoHome)
    inst.components.childspawner:SetRegenPeriod(TUNING.TOTAL_DAY_TIME * 4)
    inst.components.childspawner:SetSpawnPeriod(20)
    inst.components.childspawner:SetMaxChildren(3)

    inst.components.childspawner.emergencychildname = "merm2"
    inst.components.childspawner:SetEmergencyRadius(TUNING.MERMHOUSE_EMERGENCY_RADIUS)
    inst.components.childspawner:SetMaxEmergencyChildren(TUNING.MERMHOUSE_EMERGENCY_MERMS)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
    inst.components.hauntable:SetOnHauntFn(OnHaunt)

    inst:WatchWorldState("isday", OnIsDay)

    StartSpawning(inst)

    MakeMediumBurnable(inst, nil, nil, true)
    MakeLargePropagator(inst)
    inst:ListenForEvent("onignite", onignite)
    inst:ListenForEvent("burntup", onburntup)

    inst:AddComponent("inspectable")

    MakeSnowCovered(inst)

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

local function onbuilt(inst)
    inst.SoundEmitter:PlaySound("dontstarve/characters/wurt/merm/hut/place")
    inst.AnimState:PlayAnimation("hit")
end

local function fn1()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)

    inst.MiniMapEntity:SetIcon("quagmire_merm_house.png")

    inst.AnimState:SetBank("gorge_merm_house")
    inst.AnimState:SetBuild("gorge_merm_house")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("structure")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
    --inst.components.lootdropper:SetLoot(loot)
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "merm2"
    inst.components.childspawner:SetSpawnedFn(OnSpawned)
    inst.components.childspawner:SetGoHomeFn(OnGoHome)
    inst.components.childspawner:SetRegenPeriod(TUNING.TOTAL_DAY_TIME * 4)
    inst.components.childspawner:SetSpawnPeriod(20)
    inst.components.childspawner:SetMaxChildren(1)
    --[[
    inst.components.childspawner.emergencychildname = "merm2"
    inst.components.childspawner:SetEmergencyRadius(TUNING.MERMHOUSE_EMERGENCY_RADIUS)
    inst.components.childspawner:SetMaxEmergencyChildren(TUNING.MERMHOUSE_EMERGENCY_MERMS)
]]
    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
    inst.components.hauntable:SetOnHauntFn(OnHaunt)

    inst:WatchWorldState("isday", OnIsDay)

    StartSpawning(inst)

    MakeMediumBurnable(inst, nil, nil, true)
    MakeLargePropagator(inst)
    inst:ListenForEvent("onignite", onignite)
    inst:ListenForEvent("burntup", onburntup)
    inst:ListenForEvent("onbuilt", onbuilt)

    inst:AddComponent("inspectable")

    MakeSnowCovered(inst)

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

return Prefab("quagmire_merm_house", fn, assets, prefabs),
    Prefab("quagmire_merm_house_crafted", fn1, assets, prefabs),
    MakePlacer("quagmire_merm_house_crafted_placer", "gorge_merm_house", "gorge_merm_house", "idle")
