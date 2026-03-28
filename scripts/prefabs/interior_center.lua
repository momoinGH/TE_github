local RoomUtils = require("tropical_utils/room_utils")

local function OnSave(inst, data)
    data.room_width = inst.room_width:value() ~= 0 and inst.room_width:value() or nil
    data.room_depth = inst.room_depth:value() ~= 0 and inst.room_depth:value() or nil
    data.room_explored = inst:HasTag("room_explored")
end

local function OnLoad(inst, data)
    if not data then return end

    if data.room_width then
        inst.room_width:set(data.room_width)
    end
    if data.room_depth then
        inst.room_depth:set(data.room_depth)
    end
    if data.room_explored then
        inst:AddTag("room_explored")
    end
end

-- 横向为z右为正，纵向为x下为正
local function IsPointInRoom(inst, x, z)
    local half_width = inst.room_width:value() / 2 + 1 --加一点儿，增加点误差
    local half_depth = inst.room_depth:value() / 2 + 1
    local rx, ry, rz = inst.Transform:GetWorldPosition()
    return z >= rz - half_width
        and z <= rz + half_width
        and x >= rx - half_depth
        and x <= rx + half_depth
end

-- 拿到一侧的门
local function GetRoomDoor(inst, dir)
    local doors = RoomUtils.FindRoomEnts(inst, { "interior_" .. dir .. "_door" })
    if #doors >= 2 then
        TroErrorHandle(string.trofmt("{}这个室内{}方向有{}个门", inst, dir, #doors), true, false)
    end
    return #doors > 0 and doors[1] or nil
end

local function GetNearRoom(inst, dir)
    local door = GetRoomDoor(inst, dir)
    local target_door = door and door.targetdoor and door.targetdoor:value()
    return target_door and target_door:TroGetRoomCenter() or nil
end

-- 查找上下左右的相邻房间
local function GetNearRooms(inst)
    local near_rooms = {}
    for dir, _ in pairs(RoomUtils.DIR) do
        local room = GetNearRoom(inst, dir)
        if room then
            near_rooms[dir] = room
        end
    end
    return near_rooms
end

local function fn()
    local inst = CreateEntity()
    inst.entity:SetCanSleep(false)

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("interior_center")
    inst:AddTag("NOBLOCK")
    -- inst:AddTag("room_explored") --是否探索过，探索过就在地图上绘制

    --房间的大小，影响摄像机的缩放
    inst.room_width = net_smallbyte(inst.GUID, "interior_center.room_width")
    inst.room_depth = net_smallbyte(inst.GUID, "interior_center.room_depth")
    inst.IsPointInRoom = IsPointInRoom
    inst.GetRoomDoor = GetRoomDoor
    inst.GetNearRoom = GetNearRoom
    inst.GetNearRooms = GetNearRooms

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = TUNING.SANITYAURA_SMALL
    local dis = RoomUtils.RADIUS
    inst.components.sanityaura.max_distsq = dis * dis

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end



-- 这是虚空小房子的中心点，每个小房子中心位置必有该对象
-- 用对象表示中心点的好处是主客机都能查找到该对象
-- 也可以添加一些网络变量表示各种属性，比如房子的半径
return Prefab("interior_center", fn)
