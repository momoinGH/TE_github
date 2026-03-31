-- 参数来自单机interiorspawner组件的ApplyInteriorCameraWithPosition方法
local function GetRoomCameraData(depth, pt)
    local cameraoffset = -2.5 --10x15
    local interior_distance = 23

    if depth == TUNING.ROOM_SMALL_DEPTH then --12x18
        cameraoffset = -2
        interior_distance = 25
    elseif depth == TUNING.ROOM_MEDIUM_DEPTH then --16x24
        cameraoffset = -1.5
        interior_distance = 30
    elseif depth == TUNING.ROOM_LARGE_DEPTH then --18x26
        cameraoffset = -2                        -- -1
        interior_distance = 35
    end

    local interior_currentpos = Vector3(pt.x + cameraoffset, 0, pt.z)
    return interior_distance, interior_currentpos
end

-- 参数来自单机室内摄像机interiorcamera的Apply方法
local function Apply(room)
    local interior_pitch = 35
    local interior_heading = 0 --这个决定方向，下x右z
    local dx = -math.cos(interior_pitch * DEGREES) * math.cos(interior_heading * DEGREES)
    local dy = -math.sin(interior_pitch * DEGREES)
    local dz = -math.cos(interior_pitch * DEGREES) * math.sin(interior_heading * DEGREES)
    TheSim:SetCameraDir(dx, dy, dz)

    local depth = room.room_depth:value()
    local interior_distance, interior_currentpos = GetRoomCameraData(depth, room:GetPosition())
    local px = dx * (-interior_distance) + interior_currentpos.x
    local py = dy * (-interior_distance) + interior_currentpos.y
    local pz = dz * (-interior_distance) + interior_currentpos.z
    TheSim:SetCameraPos(px, py, pz)

    local rx = math.cos((interior_heading + 90) * DEGREES)
    local ry = 0
    local rz = math.sin((interior_heading + 90) * DEGREES)
    local ux, uy, uz = dy * rz - dz * ry, dz * rx - dx * rz, dx * ry - dy * rx
    TheSim:SetCameraUp(ux, uy, uz)

    local interior_fov = 35
    TheSim:SetCameraFOV(interior_fov)
end

local function CameraDefault(inst)
    TheCamera:SetPaused(false)
    TheCamera:SetControllable(true)
    TheCamera:SetDefault()
    if inst._tro_roomcameratask then
        inst._tro_roomcameratask:Cancel()
        inst._tro_roomcameratask = nil
    end
end

local function UpdateRoomCamera(inst)
    TheCamera:SetPaused(true)
    TheCamera:SetControllable(false)
    TheCamera.headingtarget = 0
    local target = inst:TroGetPlayerClassifiedNetVar("tro_curroomcenter")
    if target then --服务器报错的话这个还是会是nil的
        Apply(target)
    else
        if inst._tro_roomcameratask then
            inst._tro_roomcameratask:Cancel()
            inst._tro_roomcameratask = nil
        end
    end
end


-- this is called on client
local function OnPlayerRoomChange(inst)
    local target = inst:TroGetPlayerClassifiedNetVar("tro_curroomcenter")
    if target then
        if not inst._tro_roomcameratask then
            inst._tro_roomcameratask = inst:DoPeriodicTask(0.2, UpdateRoomCamera) --这里刷一下，因为有时候进房间镜头中心会在侧门不在中心，玩家死亡复活镜头也会修改
        end
    else
        CameraDefault(inst)
    end
end

AddPlayerPostInit(function(inst)
    if not TheNet:IsDedicated() then
        inst._tro_roomcameratask = nil
        inst:ListenForEvent("tro_curroomcenter", OnPlayerRoomChange)
    end
end)
