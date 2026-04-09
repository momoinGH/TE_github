local prefabs = {
    "seagull_water"
}

local function RemoveShadow(inst, shadow)
    shadow.components.colourtweener:StartTween({ 1, 1, 1, 0 }, 3, function()
        shadow:Remove()
        inst.seagulls[shadow] = nil
    end)
end

local function OnSpawn(inst, child)
    for k, v in pairs(inst.seagulls) do
        if k:IsValid() then
            local dist = v.components.circler.distance
            local angle = v.components.circler.angleRad
            local offset = FindWalkableOffset(inst:GetPosition(), angle, dist, 8, false) or Vector3(0, 0, 0)
            offset.y = 30
            child.Transform:SetPosition((inst:GetPosition() + offset):Get())
            child.sg:GoToState("glide")
            RemoveShadow(inst, k)
            break
        end
    end
end

local function SpawnSeagullShadow(inst)
    local seagull = SpawnPrefab("circlingseagull")
    seagull.components.circler:SetCircleTarget(inst)
    seagull.components.circler:Start()
    inst.seagulls[seagull] = seagull
end

local function OnAddChild(inst, num)
    for i = 1, num or 1 do
        SpawnSeagullShadow(inst)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("seagull.png")

    inst:AddTag("seagullspawner")
    inst:AddTag("NOCLICK")
    inst:AddTag("NOBLOCK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "seagull_water"
    inst.components.childspawner:SetSpawnedFn(OnSpawn)
    inst.components.childspawner:SetOnAddChildFn(OnAddChild)
    inst.components.childspawner:SetMaxChildren(math.random(2, 4))
    inst.components.childspawner:SetSpawnPeriod(math.random(2, 3))
    inst.components.childspawner:SetRegenPeriod(5)

    inst:WatchWorldState("isday", function()
        if not TheWorld.state.iswet then
            inst.components.childspawner:StartSpawning()
            inst.components.childspawner:StopRegen()
        end
    end)

    inst:WatchWorldState("isnight", function()
        inst.components.childspawner:StopSpawning()
        inst.components.childspawner:StartRegen()
    end)

    inst.seagulls = {}

    inst.OnEntityWake = OnEntityWake
    inst.OnEntitySleep = OnEntitySleep

    return inst
end

local function circlingseagullfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    anim:SetBank("seagull_shadow")
    anim:SetBuild("seagull_shadow")
    anim:PlayAnimation("shadow", true)
    anim:SetOrientation(ANIM_ORIENTATION.OnGround)
    anim:SetLayer(LAYER_BACKGROUND)
    anim:SetSortOrder(3)
    inst.AnimState:SetMultColour(1, 1, 1, 0)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("NOBLOCK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("circler")

    inst:AddComponent("colourtweener")
    if not TheWorld.state.isnight then
        inst.components.colourtweener:StartTween({ 1, 1, 1, 1 }, 3)
    end

    inst:WatchWorldState("daytime", function()
        if not TheWorld.state.iswet then
            inst.components.colourtweener:StartTween({ 1, 1, 1, 1 }, 3)
        end
    end)
    inst:WatchWorldState("nighttime", function()
        inst.components.colourtweener:StartTween({ 1, 1, 1, 0 }, 3)
    end)

    inst:TroDoCanSleepPeriodicTask(math.random(3, 5), function()
        if math.random() > 0.66 then
            local numFlaps = math.random(3, 6)
            inst.AnimState:PlayAnimation("shadow_flap_loop")
            for i = 2, numFlaps do
                inst.AnimState:PushAnimation("shadow_flap_loop")
            end
            inst.AnimState:PushAnimation("shadow")
        end
    end)

    inst.persists = false

    return inst
end

return Prefab("seagullspawner", fn, nil, prefabs),
    Prefab("circlingseagull", circlingseagullfn, assets, prefabs)
