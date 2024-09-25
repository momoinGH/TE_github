local function makeobstacle(inst)
    inst.Physics:SetActive(true)
    inst._ispathfinding:set(true)
end

local function OnIsPathFindingDirty(inst)
    if inst._ispathfinding:value() then
        if inst._pfpos == nil and inst:GetCurrentPlatform() == nil then
            inst._pfpos = inst:GetPosition()
            TheWorld.Pathfinder:AddWall(inst._pfpos:Get())
        end
    elseif inst._pfpos ~= nil then
        TheWorld.Pathfinder:RemoveWall(inst._pfpos:Get())
        inst._pfpos = nil
    end
end

local function InitializePathFinding(inst)
    inst:ListenForEvent("onispathfindingdirty", OnIsPathFindingDirty)
    OnIsPathFindingDirty(inst)
end

local function onremove(inst)
    inst._ispathfinding:set_local(false)
    OnIsPathFindingDirty(inst)
end

local function onload(inst, data)
    if data and data.gridnudge then --用于生成地图时使用
        local function normalize(coord)
            local temp = coord % 0.5
            coord = coord + 0.5 - temp

            if coord % 1 == 0 then
                coord = coord - 0.5
            end

            return coord
        end

        local pt = Vector3(inst.Transform:GetWorldPosition())
        pt.x = normalize(pt.x)
        pt.z = normalize(pt.z)
        inst.Transform:SetPosition(pt.x, pt.y, pt.z)
    end
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:SetDeploySmartRadius(0.5) --DEPLOYMODE.WALL assumes spacing of 1

    MakeObstaclePhysics(inst, .5)
    inst.Physics:SetDontRemoveOnSleep(true)
    inst.Physics:SetCollisionGroup(COLLISION.WORLD) --阻挡所有单位，包括飞行单位

    inst:AddTag("wall")
    inst:AddTag("NOCLICK")
    inst:AddTag("blocker")
    inst:AddTag("NOBLOCK")

    inst._pfpos = nil
    inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
    makeobstacle(inst)
    --Delay this because makeobstacle sets pathfinding on by default
    --but we don't to handle it until after our position is set
    inst:DoTaskInTime(0, InitializePathFinding)

    inst.OnRemoveEntity = onremove

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.OnLoad = onload

    return inst
end

-- 无敌的不可见墙体
return Prefab("wall_invisible", fn)
