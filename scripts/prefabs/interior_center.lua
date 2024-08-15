local InteriorSpawnerUtils = require("interiorspawnerutils")

local function OnPlayerFar(inst, doer)
    doer.mynetvarCameraMode:set(0)
end

local function OnPlayerNear(inst, doer)
    doer:DoTaskInTime(0.5, function(doer) --从一个房间跳到另一个房间，有可能出现先靠近再远离的调用顺序，这里延迟一下设置摄像机
        local center = GetClosestInstWithTag("interior_center", doer, 30)
        if center then
            local val = InteriorSpawnerUtils.GetRoomSizeById(inst.room_size:value()) == InteriorSpawnerUtils.ROOM_SIZE.MEDIUM and 5
                or 4
            doer.mynetvarCameraMode:set(val)
        end
    end)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("interior_center")
    inst:AddTag("NOBLOCK")

    inst.room_size = net_tinybyte(inst.GUID, "interior_center.room_size") --房间的大小，影响摄像机的缩放

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = TUNING.SANITYAURA_SMALL
    local dis = InteriorSpawnerUtils.RADIUS
    inst.components.sanityaura.max_distsq = dis * dis

    -- 玩家可能通过其他手段进入和离开房间，我不能通过开关门来判断，只能用这个组件
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetTargetMode(inst.components.playerprox.TargetModes.AllPlayers)
    inst.components.playerprox:SetDist(dis, dis)
    inst.components.playerprox:SetOnPlayerNear(OnPlayerNear)
    inst.components.playerprox:SetOnPlayerFar(OnPlayerFar)

    return inst
end



-- 这是虚空小房子的中心点，每个小房子中心位置必有该对象
-- 用对象表示中心点的好处是主客机都能查找到该对象
-- 也可以添加一些网络变量表示各种属性，比如房子的半径
return Prefab("interior_center", fn)
