local InteriorSpawnerUtils = require("interiorspawnerutils")

local function OnPlayerFar(inst, doer)
    doer:DoTaskInTime(0.5, function(doer)
        doer.tropical_room_event:push()
    end)
end

local function OnPlayerNear(inst, doer)
    -- doer:DoTaskInTime(0.5, function(doer) --从一个房间跳到另一个房间，有可能出现先靠近再远离的调用顺序，这里延迟一下设置摄像机
    --     local center = GetClosestInstWithTag("interior_center", doer, 30)
    --     if center then
    --         doer.tropical_room_event:push()
    --     end
    -- end)
    doer:DoTaskInTime(0.5, function(doer)
        doer.tropical_room_event:push()
    end)
end

local function OnSave(inst, data)
    data.room_width = inst.room_width:value() ~= 0 and inst.room_width:value() or nil
    data.room_depth = inst.room_depth:value() ~= 0 and inst.room_depth:value() or nil
end

local function OnLoad(inst, data)
    if not data then return end

    if data.room_width then
        inst.room_width:set(data.room_width)
    end
    if data.room_depth then
        inst.room_depth:set(data.room_depth)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("interior_center")
    inst:AddTag("NOBLOCK")

    --房间的大小，影响摄像机的缩放
    inst.room_width = net_smallbyte(inst.GUID, "interior_center.room_width")
    inst.room_depth = net_smallbyte(inst.GUID, "interior_center.room_depth")

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

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end



-- 这是虚空小房子的中心点，每个小房子中心位置必有该对象
-- 用对象表示中心点的好处是主客机都能查找到该对象
-- 也可以添加一些网络变量表示各种属性，比如房子的半径
return Prefab("interior_center", fn)
