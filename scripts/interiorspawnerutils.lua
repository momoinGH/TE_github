-- 为虚空小房子服务

local FN = {}

FN.RADIUS = 16     --小房子半径
FN.BASE_OFF = 1500 --小房子的初始z坐标，需要注意的是这个是小房子中心点的初始z坐标
FN.ROOM_SIZE_MAX = 60
FN.ROW_COUNT = FN.BASE_OFF / FN.ROOM_SIZE_MAX * 2

FN.ROOM_SIZE = {
    SMALL = {               --
        dx = { -5.5, 5.5 }, --上下
        dz = { -8.5, 8.5 }  --左右
    },
    MEDIUM = {
        dx = { -8.5, 8.5 },  --上下
        dz = { -12.5, 12.5 } --左右
    },
}

function FN.GetRoomSizeId(room_size)
    return room_size == FN.ROOM_SIZE.MEDIUM and 1
        or 0
end

function FN.GetRoomSizeById(id)
    return id == 1 and FN.ROOM_SIZE.MEDIUM
        or FN.ROOM_SIZE.SMALL
end

function FN.GetCenterPosByHouse(house)
    local door = house.components.teleporter and house.components.teleporter:GetTarget()
    local center = door and door.components.entitytracker and door.components.entitytracker:GetEntity("interior_center")
    return center and center:GetPosition()
end

--- 当房屋被摧毁时把屋内的掉落物扔出来
--- 如果是remove就移除屋内道具，如果是敲毁就返还材料，只包括lootdropper和inventoryitem
function FN.OnHouseDestroy(house, destroyer, isRemove)
    local centerPos = FN.GetCenterPosByHouse(house)
    if not centerPos then return end

    local dis = FN.RADIUS
    local hx, hy, hz = house.Transform:GetWorldPosition()
    if not isRemove then
        --摧毁室内建筑，生成掉落物
        for _, v in ipairs(TheSim:FindEntities(centerPos.x, centerPos.y, centerPos.z, dis)) do
            if not v:HasTag("interior_center") and v ~= house then --中心点下面再删除
                if v.components.workable then
                    v.components.workable:Destroy(destroyer)       --包括其他的房间
                elseif v.components.health and not v.components.health:IsDead()
                    and ((not v.components.locomotor and v.components.lootdropper) or v:HasTag("only_interior"))
                then
                    if v.components.lootdropper then
                        v.components.lootdropper:DropLoot() --一般是在死亡的sg中生成，我杀死直接移除不会生成额外的掉落物
                    end
                    v.components.health:Kill()
                end
            end
        end
    end

    --传送掉落物，移除地板
    for _, v in ipairs(TheSim:FindEntities(centerPos.x, centerPos.y, centerPos.z, dis)) do
        if not isRemove and v.components.inventoryitem then
            house.components.lootdropper:FlingItem(v) --借用lootdropper组件抛出物品
        elseif v.components.health and v.components.locomotor and not v:HasTag("only_interior") then
            if v:HasTag("player") then
                -- 玩家落水处理
                v.sg:GoToState("sink_fast")
            else
                v.Transform:SetPosition(hx, hy, hz)
            end
        else
            v:Remove()
        end
    end
end

--- 不可见墙，阻挡玩家移动
function FN.SpawnWall(x, z, width, depth)
    local room_dx = depth / 2 + 0.5
    local room_dz = width / 2 + 0.5
    for dx = -room_dx, room_dx do --因为两侧墙角度不一样，所以墙壁并不是对称的
        for dz = -room_dz, room_dz do
            if dx == -room_dx or dx == room_dx or dz == -room_dz or dz == room_dz then
                local part = SpawnPrefab("wall_invisible")
                -- local part = SpawnPrefab("wall_stone") -- 测试阶段先用石墙
                part.Transform:SetPosition(x + dx, 0, z + dz)
            end
        end
    end
end

-- 清理目标区域的空间
-- 虽然房子坐标是累增的，但是防止一些特殊情况，比如mod中途移除再添加导致count重新计数，或者其他mod也有小房子，房子生成位置冲突
function FN.ClearSpace(x, z)
    for _, ent in ipairs(TheSim:FindEntities(x, 0, z, FN.RADIUS)) do
        ent:Remove()
    end
end

function FN.GetHouseCenterPos(target)
    local x, _, z = target.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, 0, z, FN.RADIUS, { "interior_center" })
    if #ents > 0 then
        return ents[1]:GetPosition()
    end
end

---根据目标对象位置计算距离最近的墙面
---side =1 左侧； =2 顶部； =3 右侧； =4 底部
function FN.TestWallOrnamentPos(target, isSetPos, left, top, right, bottom)
    left = left or 7.5
    top = top or 5
    right = right or 7.5

    local pos = target:GetPosition()
    local centerPos = FN.GetHouseCenterPos(target)

    if centerPos then
        local x, y, z = centerPos:Get()
        local dx, dz = pos.x - x, pos.z - z

        -- 寻找距离最近的一侧墙
        local side = 1
        local minDis = math.abs(dz + left) --左

        local tem = math.abs(dx + top)
        if tem < minDis then --中
            minDis = tem
            side = 2
        end

        tem = math.abs(dz - right)
        if tem < minDis then --右
            minDis = tem
            side = 3
        end

        if bottom then
            tem = math.abs(dx - bottom)
            if tem < minDis then --下
                minDis = tem
                side = 4
            end
        end
        -- print("最小距离", minDis, dz + 8.5, dx + 5, dz - 7.5)

        if isSetPos and minDis < 4 then
            if side == 1 then
                target.Transform:SetPosition(pos.x, 0, z - left)
            elseif side == 2 then
                target.Transform:SetPosition(x - top, 0, pos.z)
            elseif side == 3 then
                target.Transform:SetPosition(pos.x, 0, z + right)
            elseif side == 4 then
                target.Transform:SetPosition(x + bottom, 0, pos.z)
            end
        end

        return side, minDis, x, z
    end
end

---判断柱子所在哪个角
function FN.TestBeam(target)
    local pos = target:GetPosition()
    local centerPos = FN.GetHouseCenterPos(target)
    if centerPos then
        local x, y, z = FN.GetHouseCenterPos(target)
        return pos.x < x, pos.z < z --isCorner,isLeft
    end
end

local TNTERIOR_ONE_OF_TAGS = { "player", "hamlet_door" }
--- 递归检测内部是否存在玩家
---@param door Entity 外门
function FN.InterioHasPlayer(door)
    local centerPos = FN.GetCenterPosByHouse(door)

    if not centerPos then return false end

    local doors = {}
    for _, v in ipairs(TheSim:FindEntities(centerPos.x, 0, centerPos.z, FN.RADIUS, nil, nil, TNTERIOR_ONE_OF_TAGS)) do
        if v:HasTag("player") then
            return true
        else
            table.insert(door, v)
        end
    end

    for _, d in ipairs(doors) do
        if FN.InterioHasPlayer(d) then
            return true
        end
    end

    return false
end

---获取门对室内中心的相对位置
function FN.GetDoorRelativePosition(door)
    local centerPos = FN.GetHouseCenterPos(door)
    return centerPos and (door:GetPosition() - centerPos) or nil
end

--- 生成临近的新房间，用于房屋扩展许可证
function FN.SpawnNearHouseInterior(door, room)
    if door.components.teleporter:GetTarget() then return false end --已经有了
    local dpos = FN.GetDoorRelativePosition(door)
    if not dpos or not door.side then return false end              --不可能
    local _, _, center = FN.CreateRoom(room)
    local pos = center:GetPosition()

    -- 还要装一个对应的门
    local doorAnim, newDoorAnim
    local newDoor = SpawnPrefab(door.prefab)
    if door.side == 1 then
        newDoor.side = 3
        newDoor.Transform:SetPosition(pos.x + dpos.x, 0, pos.z + 7.5)
        doorAnim = "_open_east"
        newDoorAnim = "_open_west"
    elseif door.side == 2 then
        newDoor.side = 4
        newDoor.Transform:SetPosition(pos.x + 5.5, 0, pos.z + dpos.z)
        doorAnim = "_open_north"

        newDoorAnim = "_open_south"
    elseif door.side == 3 then
        newDoor.side = 1
        newDoor.Transform:SetPosition(pos.x + dpos.x, 0, pos.z - 7.5)
        doorAnim = "_open_west"
        newDoorAnim = "_open_east"
    elseif door.side == 4 then
        newDoor.side = 2
        newDoor.Transform:SetPosition(pos.x - 5.5, 0, pos.z + dpos.z)
        doorAnim = "_open_south"
        newDoorAnim = "_open_north"
    end

    door.components.tropical_saveanim:Init(nil, nil, door.playAnim .. doorAnim)
    newDoor.components.tropical_saveanim:Init(nil, nil, door.playAnim .. newDoorAnim)

    door:RemoveTag("predoor")
    newDoor:RemoveTag("predoor")
    newDoor:AddTag("hamlet_houseexit")

    door.components.teleporter:Target(newDoor)
    newDoor.components.teleporter:Target(door)

    if door.SoundEmitter then
        door.SoundEmitter:PlaySound("dontstarve/creatures/together/klaus/lock_break")
    end
    return true
end

----------------------------------------------------------------------------------------------------

local function DefaultDoorAbleToAcceptTest(inst, item)
    return inst:HasTag("teleporter")
end

local function DefaultOnDoorAccept(inst, giver, item)
    if not inst.components.teleporter:Activate(item)
        and item.components.inventoryitem --一定有吧
        and giver
    then
        -- 如果传送失败要物品丢出来，不然就跑世界原点了，不过无法传送的话一般也绕不过DefaultDoorAbleToAcceptTest
        local rotation = inst:GetAngleToPoint(giver.Transform:GetWorldPosition())
        local rot = rotation * DEGREES
        local pos = inst:GetPosition()
        local distance = math.min(math.sqrt(inst:GetDistanceSqToInst(giver)), 0.5)
        local spawnPos = pos + Vector3(distance * math.cos(rot), 0, -distance * math.sin(rot))
        item.Transform:SetPosition(spawnPos:Get())
        item.components.inventoryitem:OnDropped()
    end
end

local function OnDoorHaunt(inst, haunter)
    inst.components.teleporter:Activate(haunter)
end

local function OnDoorRemove(inst)
    FN.OnHouseDestroy(inst, nil, true)
end

--- 虚空门的基础代码
--- trader和hauntable用于传送物品，teleporter用来传送玩家
--- teleporter加在所有门上，可以关联传送目的地和判断房间是否已经创建；entitytracker加载虚空内的门上，保存当前所在房间的中心点
---@param bank string
---@param build string
---@param anim string
---@param trader boolean|nil 是否可用于传送物品、交易
---@param interior_door boolean|nil 是否是虚空内部的生成的门，如果是则表示需要记录中心点对象
---@param minimap string|nil 小地图图标
---@param usesound string|nil 使用门的声音，建议"dontstarve/common/pighouse_door"、"dontstarve_DLC003/common/objects/store/door_open"
function FN.MakeBaseDoor(bank, build, anim, trader, interior_door, minimap, usesound)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    if minimap then
        inst.entity:AddMiniMapEntity()
        inst.MiniMapEntity:SetIcon(minimap)
    end
    if bank then
        inst.AnimState:SetBank(bank)
    end
    if build then
        inst.AnimState:SetBuild(build)
    end
    if anim then
        inst.AnimState:PlayAnimation(anim)
    end

    inst.AnimState:SetSortOrder(0)

    inst:AddTag("NOBLOCK")
    inst:AddTag("interior_door")
    if trader then
        inst:AddTag("trader")
        inst:AddTag("alltrader")
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("teleporter")
    inst.components.teleporter.offset = 0
    inst.components.teleporter.travelcameratime = 0
    inst.components.teleporter.travelarrivetime = 0
    -- inst.components.teleporter.onActivate = OnActivate
    -- inst.components.teleporter.OnDoneTeleporting = OnDoneTeleporting

    if trader then
        inst:AddComponent("trader")
        inst.components.trader.acceptnontradable = true
        inst.components.trader.deleteitemonaccept = false
        inst.components.trader:SetAbleToAcceptTest(DefaultDoorAbleToAcceptTest)
        inst.components.trader.onaccept = DefaultOnDoorAccept

        inst:AddComponent("hauntable")
        inst.components.hauntable:SetOnHauntFn(OnDoorHaunt)
    end

    if interior_door then
        inst:AddComponent("entitytracker")
    end

    if usesound then
        inst.usesound = usesound
    end

    inst:ListenForEvent("onremove", OnDoorRemove)

    return inst
end

----------------------------------------------------------------------------------------------------

local lights =
{
    day = { rad = 3, intensity = 0.75, falloff = 0.5, color = { 1, 1, 1 } },
    dusk = { rad = 2, intensity = 0.75, falloff = 0.5, color = { 1 / 1.8, 1 / 1.8, 1 / 1.8 } },
    full = { rad = 2, intensity = 0.75, falloff = 0.5, color = { 0.8 / 1.8, 0.8 / 1.8, 1 / 1.8 } }
}

local function turnoff(inst, light)
    if light then
        light:Enable(false)
    end
end

local phasefunctions =
{
    day = function(inst)
        if not inst:IsInLimbo() then inst.Light:Enable(true) end
        inst.components.lighttweener:StartTween(nil, lights.day.rad, lights.day.intensity, lights.day.falloff,
            { lights.day.color[1], lights.day.color[2], lights.day.color[3] }, 2)
    end,

    dusk = function(inst)
        if not inst:IsInLimbo() then inst.Light:Enable(true) end
        inst.components.lighttweener:StartTween(nil, lights.dusk.rad, lights.dusk.intensity, lights.dusk.falloff,
            { lights.dusk.color[1], lights.dusk.color[2], lights.dusk.color[3] }, 2)
    end,

    night = function(inst)
        if TheWorld.state.isfullmoon then
            inst.components.lighttweener:StartTween(nil, lights.full.rad, lights.full.intensity, lights.full.falloff,
                { lights.full.color[1], lights.full.color[2], lights.full.color[3] }, 4)
        else
            inst.components.lighttweener:StartTween(nil, 0, 0, 1, { 0, 0, 0 }, 6, turnoff)
        end
    end,
}

local function OnPhase(inst, phase)
    if phase == "dusk" then
        if inst:HasTag("timechange_anims") then
            inst.AnimState:PlayAnimation("to_dusk")
            inst.AnimState:PushAnimation("dusk_loop", true)
        end
    elseif phase == "night" then
        if inst:HasTag("timechange_anims") then
            inst.AnimState:PlayAnimation("to_night")
            inst.AnimState:PushAnimation("night_loop", true)
        end
    elseif phase == "day" then
        if inst:HasTag("timechange_anims") then
            inst.AnimState:PlayAnimation("to_day")
            inst.AnimState:PushAnimation("day_loop", true)
        end
    end
    phasefunctions[phase](inst)
end

--- 让门的动画和光照随时段变化
function FN.SetDoorTimeChange(inst)
    inst:AddComponent("lighttweener")
    inst.components.lighttweener:StartTween(inst.entity:AddLight(), lights.day.rad, lights.day.intensity,
        lights.day.falloff, { lights.day.color[1], lights.day.color[2], lights.day.color[3] }, 0)
    inst.Light:Enable(true)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:WatchWorldState("phase", OnPhase)
    OnPhase(inst, TheWorld.state.phase)
end

----------------------------------------------------------------------------------------------------

local EAST  = { x = 1, y = 0, label = "east" }
local WEST  = { x = -1, y = 0, label = "west" }
local NORTH = { x = 0, y = 1, label = "north" }
local SOUTH = { x = 0, y = -1, label = "south" }

function FN.GetNorth()
    return NORTH
end

function FN.GetSouth()
    return SOUTH
end

function FN.GetWest()
    return WEST
end

function FN.GetEast()
    return EAST
end

FN.DIR = {
    EAST,
    WEST,
    NORTH,
    SOUTH,
}

FN.DIR_OPPOSITE =
{
    WEST,
    EAST,
    SOUTH,
    NORTH,
}

function FN.GetOppositeFromDirection(direction)
    if direction == NORTH then
        return FN.GetSouth()
    elseif direction == EAST then
        return FN.GetWest()
    elseif direction == SOUTH then
        return FN.GetNorth()
    else
        return FN.GetEast()
    end
end

-- 房间的配置表，除了name，其他都可省
local newRoom = {
    width = 15,                                --房间宽度，z，用于生成不可见墙体，默认16
    depth = 15,                                --房间深度，x，用于生成不可见墙体，默认10
    addprops = {                               --房间内所有东西配置，包括地板、墙壁和房间门
        {
            name = "",                         --预制件名
            x_offset = 0.5,                    --偏移，x上下偏移，往下增大
            y_offset = 0.5,                    --偏移
            z_offset = 0.5,                    --偏移，z左右偏移，往右增大
            key = "exit",                      --对房间门生效，CreateRoom方法返回的表可以通过这个key获取到对应的门，同时用于连通不同房间的门
            target_door = "",                  --如果需要不同房间的门相互连通，则需要配置target_door = key
            init = function(inst, center) end, --生成后的初始化操作，第二个参数是中心点对象
            startstate = "",                   --有Stategraph的单位初始state

            --该数据通过tropical_saveanim组件保存和加载，因此建议给有这些字段的预制件都添加该组件
            bank = nil,         --支持函数、字符串
            build = nil,        --支持函数、字符串
            anim = nil,         --支持函数、字符串
            scale = { -1, 1 },  --支持函数、表
            rotation = 90,      --Transform的旋转，支持函数、数字
            isloopplay = false, --是否循环播放
            isdelayset = false, --加载时是否进入游戏再设置
        },
    },
}

local INC = 0

---创建房间
---@param room table 房间配置表
---@return doors table 所有的房间门
---@return door_map table 门的key的映射关系
---@return center Entity
function FN.CreateRoom(room)
    local doors = {}
    local door_map = {}
    local x, y, z = TheWorld.components.tropical_interiorspawner:GetPos():Get()

    -- 清除杂物，以防万一
    FN.ClearSpace(x, z)

    local width = room.width or TUNING.ROOM_TINY_WIDTH
    local depth = room.depth or TUNING.ROOM_TINY_DEPTH

    -- 生成中心点
    local center = SpawnPrefab("interior_center")
    center.Transform:SetPosition(x, 0, z)
    center.room_width:set(width)
    center.room_depth:set(depth)

    --生成墙体
    FN.SpawnWall(x, z, width, depth)

    --生产内部物品
    for _, data in ipairs(room.addprops) do
        local p = SpawnPrefab(data.name)

        local x_offset = data.x_offset
        local scale = data.scale

        -- print("创建内部对象", p, p:HasTag("interior_door"), data.key)

        if p:HasTag("interior_door") then
            --门
            assert(p.components.entitytracker, "只要是虚空房间里的门都应该有entitytracker组件，用来记录自己所在房间的中心点")
            p.components.entitytracker:TrackEntity("interior_center", center)
            local key = data.key or INC
            INC = INC + 1 --只要每次创建房间时唯一就行
            doors[key] = p
            door_map[key] = data.target_door
        elseif p:HasTag("interior_floor") then
            --地板自适应缩放，不是直接的线性关系，这里懒得搞什么公式了
            x_offset = x_offset
                or depth == TUNING.ROOM_LARGE_DEPTH and -5.5
                or depth == TUNING.ROOM_MEDIUM_DEPTH and -4.4
                or depth == TUNING.ROOM_SMALL_DEPTH and -3.5
                or depth == TUNING.ROOM_TINY_DEPTH and -3
                or nil
            scale = scale
                or width == TUNING.ROOM_LARGE_WIDTH and { 4.5, 4.5 }
                or width == TUNING.ROOM_MEDIUM_WIDTH and { 3.7, 3.7 }
                or width == TUNING.ROOM_SMALL_WIDTH and { 2.9, 2.9 }
                or width == TUNING.ROOM_TINY_WIDTH and { 2.4, 2.4 }
                or nil
        elseif p:HasTag("interior_wall") then
            -- 墙壁自适应缩放
            x_offset = x_offset
                or depth == TUNING.ROOM_LARGE_DEPTH and -5.5
                or depth == TUNING.ROOM_MEDIUM_DEPTH and -4
                or depth == TUNING.ROOM_SMALL_DEPTH and -3.5
                or depth == TUNING.ROOM_TINY_DEPTH and -2.8
                or nil
            scale = scale
                or width == TUNING.ROOM_LARGE_WIDTH and { 4.6, 4.6 }
                or width == TUNING.ROOM_MEDIUM_WIDTH and { 4.2, 4.2 }
                or width == TUNING.ROOM_SMALL_WIDTH and { 3.5, 3.5 }
                or width == TUNING.ROOM_TINY_WIDTH and { 3, 3 }
                or nil
        end

        p.Transform:SetPosition(x + (x_offset or 0), (data.y_offset or 0), z + (data.z_offset or 0))

        if p.components.tropical_saveanim then
            p.components.tropical_saveanim:Init(data.bank, data.build, data.anim, scale, data.isloopplay, data.isdelayset, data.rotation)
        end

        if data.startstate then
            assert(p.sg and p.sg:HasState(data.startstate), data.name .. "没有sg或者没有state ：" .. data.startstate)
            p.sg:GoToState(data.startstate)
        end

        if data.init then
            data.init(p, center, data)
        end

        p:PushEvent("oninteriorspawn", data)
    end

    return doors, door_map, center
end

---创建很多房间
---@param rooms table 房间配置表
---@return exits table 所有出口门，也就是未关联的房间门
---@return door_map table 门的key的映射关系
---@return centers table
function FN.CreateRooms(rooms)
    local doors = {}
    local door_map = {}
    local centers = {}
    for _, room in ipairs(rooms) do
        local d, map, center = FN.CreateRoom(room)
        doors = MergeMaps(doors, d)
        door_map = MergeMaps(door_map, map)
        table.insert(centers, center)
    end

    -- 关联门
    for key, door in pairs(doors) do
        local target_door = door_map[key] and doors[door_map[key]]
        -- print("构造门", key, door_map[key], door, target_door, door:GetPosition())
        if target_door then
            door.components.teleporter:Target(target_door)
            target_door.components.teleporter:Target(door)
        end
    end

    return doors, door_map, centers
end

function FN.CreateSimpleInterior(inst, room)
    if inst.components.teleporter:GetTarget() then return end

    local doors = FN.CreateRoom(room)
    inst.components.teleporter:Target(doors.exit)
    doors.exit.components.teleporter:Target(inst)
end

return FN
