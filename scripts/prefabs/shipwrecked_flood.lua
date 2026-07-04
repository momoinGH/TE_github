local assets =
{
    Asset("ANIM", "anim/flood.zip"),
}

local function Kill(inst)
    inst.AnimState:PlayAnimation("sai")
    inst:DoTaskInTime(2, inst.Remove)
end

local function QueueRemove(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local sandbags = TheSim:FindEntities(x, y, z, 10, { "sandbag" })
    if #sandbags > 3 then Kill(inst) end

    if TheWorld.state.wetness < 1 then
        Kill(inst)
    end

    -- 有概率生成毒蚊子
    if math.random() < 0.10 then
        local invader = GetClosestInstWithTag("player", inst, 25)
        local outrobicho = GetClosestInstWithTag("mosquito", inst, 20)
        if invader and not outrobicho then
            local bicho = SpawnPrefab("mosquito_poison")
            bicho.Transform:SetPosition(x, y, z)
        end
    end
end


local function OnEntityWake(inst)
    inst.components.ripplespawner:Start()
end

local function OnEntitySleep(inst)
    inst.components.ripplespawner:Stop()
end

local function Init(inst)
    if TheWorld.components.sw_floodspawner then
        TheWorld.components.sw_floodspawner:OnFloodSpawn()
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    for _, v in ipairs(TheSim:FindEntities(x, 0, z, 10, nil, { "flooded" })) do
        if v.components.floodable then
            v.components.floodable:StartFlooded()
        end
    end
end

local function OnRemove(inst)
    if TheWorld.components.sw_floodspawner then
        TheWorld.components.sw_floodspawner:OnFloodRemove()
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    for _, v in ipairs(TheSim:FindEntities(x, 0, z, 10, { "flooded" })) do
        if v.components.floodable then
            local flood = FindEntity(v, 10, nil, { "sw_flood" })
            if not flood or flood ~= inst then
                v.components.floodable:StopFlooded()
            end
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("flood")
    inst.AnimState:SetBuild("flood")
    inst.AnimState:PlayAnimation("chega")
    inst.AnimState:PushAnimation("idle", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(1)

    inst.Transform:SetScale(1.5, 1.5, 1.5)

    inst:AddTag("NOCLICK")
    inst:AddTag("NOBLOCK")
    inst:AddTag("sw_flood")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:DoTaskInTime(0, Init)

    inst:AddComponent("ripplespawner")
    inst.components.ripplespawner.range = 8
    inst.components.ripplespawner:Start()

    inst:WatchWorldState("startday", QueueRemove)
    inst:WatchWorldState("stopday", QueueRemove)

    inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake

    inst:ListenForEvent("onremove", OnRemove)

    return inst
end

return Prefab("shipwrecked_flood", fn, assets)
