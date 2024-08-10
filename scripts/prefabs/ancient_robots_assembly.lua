local UPDATETIME = 5

local assets =
{
    Asset("ANIM", "anim/metal_hulk_merge.zip"),
    Asset("MINIMAP_IMAGE", "metal_spider"),
}

local prefabs =
{
    "iron",
    "sparks_fx",
    "sparks_green_fx",
    "laser_ring",
}

local function spawnpart(inst, prefab, x, y, z, rotation)
    local part = SpawnPrefab(prefab)
    part.Transform:SetPosition(x, y, z)
    part.spawned = true
    part.Transform:SetRotation(rotation)
    part:DoTaskInTime(math.random() * 0.6, function()
        part:PushEvent("shock")
        part.lifetime = 20 + (math.random() * 20) --120
        if not part.updatetask then
            part.updatetask = part:DoPeriodicTask(part.UPDATETIME, part.periodicupdate)
        end
    end)

    part.sg:GoToState("separate")
end

local function breakapart(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local down = TheCamera:GetDownVec()
    local angle = math.atan2(down.z, down.x) / DEGREES

    if inst.head == 1 then
        spawnpart(inst, "ancient_robot_head", x + down.x, y, z + down.z, math.random() * 360)
    end
    if inst.spine == 1 then
        spawnpart(inst, "ancient_robot_ribs", x - down.x, y, z - down.z, math.random() * 360)
    end

    if inst.arms > 0 then
        for i = 1, inst.arms do
            print("spawning arm")

            local sx = x - down.x
            local sz = z + down.z
            local sy = y
            local rotation = angle + 90

            if i == 2 then
                sx = x + down.x
                sz = z - down.z
                rotation = angle - 90
            end

            spawnpart(inst, "ancient_robot_claw", sx, sy, sz, rotation)
        end
    end
    if inst.legs > 0 then
        for i = 1, inst.legs do
            local sx = x - (2 * down.x)
            local sz = z + down.z
            local sy = y
            local rotation = angle + 90

            if i == 2 then
                sx = x + down.x
                sz = z - (2 * down.z)
                rotation = angle - 90
            end

            spawnpart(inst, "ancient_robot_leg", sx, sy, sz, rotation)
        end
    end
end

local function onmerge(inst)
    inst.refreshart(inst)
    inst.AnimState:PlayAnimation("merge")
    inst.AnimState:PushAnimation("idle", true)
    TheWorld:PushEvent("ms_sendlightningstrike", inst:GetPosition())
    SpawnPrefab("laserhit"):SetTarget(inst)

    if inst.head == 1 and inst.arms > 1 and inst.legs > 1 and inst.spine == 1 then
        local hulk = SpawnPrefab("ancient_hulk")
        local x, y, z = inst.Transform:GetWorldPosition()
        hulk.Transform:SetPosition(x, y, z)
        hulk:PushEvent("activate")
        inst:Remove()
    end
end

local function OnLightning(inst, data)

end

local function refreshart(inst)
    local anim = inst.AnimState
    if inst.legs == 0 then
        anim:Hide("leg01")
        anim:Hide("leg02")
    elseif inst.legs == 1 then
        anim:Show("leg01")
        anim:Hide("leg02")
    else
        anim:Show("leg01")
        anim:Show("leg02")
    end
    if inst.arms == 0 then
        anim:Hide("arm01")
        anim:Hide("arm02")
    elseif inst.arms == 1 then
        anim:Show("arm01")
        anim:Hide("arm02")
    else
        anim:Show("arm01")
        anim:Show("arm02")
    end
    if inst.head == 0 then
        anim:Hide("head")
    else
        anim:Show("head")
    end
    if inst.spine == 0 then
        anim:Hide("spine")
    else
        anim:Show("spine")
    end
    if inst.spine == 1 and inst.head == 1 then
        anim:Show("spine_head")
    else
        anim:Hide("spine_head")
    end
end

local function OnAttacked(inst, data)
    inst.hits = inst.hits + 1

    if inst.hits > 2 then
        if math.random() * inst.hits >= 2 then
            local x, y, z = inst.Transform:GetWorldPosition()
            inst.components.lootdropper:SpawnLootPrefab("iron", Vector3(x, y, z))
            inst.hits = 0

            if math.random() < 0.6 then
                inst.breakapart(inst)
                inst:Remove()
            end
        end
    end

    inst.AnimState:PlayAnimation("merge")
    inst.AnimState:PushAnimation("idle", true)

    local fx = SpawnPrefab("sparks_green_fx")
    local x, y, z = inst.Transform:GetWorldPosition()
    fx.Transform:SetPosition(x, y + 1, z)
end

local function OnSave(inst, data)
    data.hits = inst.hits
    data.head = inst.head
    data.spine = inst.spine
    data.arms = inst.arms
    data.legs = inst.legs
end

local function OnLoad(inst, data)
    if data then
        inst.hits = data.hits or inst.hits
        inst.head = data.head
        inst.spine = data.spine
        inst.arms = data.arms
        inst.legs = data.legs

        inst.refreshart(inst)
    end
end

local function OnLoadPostPass(inst, data)
    if inst.spawned then
        if inst.spawntask then
            inst.spawntask:Cancel()
            inst.spawntask = nil
        end
    end
end

local function OnWorked(inst, worker, workleft)
    OnAttacked(inst, { attacker = worker })
    inst.components.workable:SetWorkLeft(1)
    inst:PushEvent("attacked")
end

local function commonfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.Transform:SetFourFaced()

    inst.MiniMapEntity:SetIcon("metal_spider.png")

    MakeObstaclePhysics(inst, 2)

    inst:AddTag("lightningrod")
    inst:AddTag("laser_immune")
    inst:AddTag("ancient_robot")
    inst:AddTag("mech")
    inst:AddTag("monster")
    inst:AddTag("ancient_robots_assembly")

    inst.AnimState:SetBank("metal_hulk_merge")
    inst.AnimState:SetBuild("metal_hulk_merge")
    inst.AnimState:PlayAnimation("idle", true)

    inst.Light:SetIntensity(.6)
    inst.Light:SetRadius(5)
    inst.Light:SetFalloff(3)
    inst.Light:SetColour(1, 0, 0)
    inst.Light:Enable(false)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("timer")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnWorkCallback(OnWorked)

    inst:AddComponent("inspectable")

    inst:AddComponent("knownlocations")

    inst:AddComponent("lootdropper")

    inst.lightningpriority = 1
    inst.UPDATETIME = UPDATETIME
    inst.hits = 0
    inst.head = 0
    inst.spine = 0
    inst.arms = 0
    inst.legs = 0
    inst.refreshart = refreshart
    inst.breakapart = breakapart

    refreshart(inst)

    --  inst:ListenForEvent("beginaporkalypse", function(world) OnLightning(inst) end, GetWorld())
    inst:ListenForEvent("lightningstrike", OnLightning)
    inst:ListenForEvent("merge", onmerge)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnLoadPostPass = OnLoadPostPass

    return inst
end

return Prefab("ancient_robots_assembly", commonfn, assets, prefabs)
