-- 为虚空小房子服务

local FN     = {}

FN.RADIUS    = 16   --小房子最大半径，包括width和depth
FN.BASE_OFF  = 1400 --小房子的初始z坐标
FN.ROOM_GAP  = 60
FN.ROW_COUNT = (FN.BASE_OFF + 100) / FN.ROOM_GAP * 2

--[[
房间坐标轴朝向
          |
          |
-------------------> 东
          |
          |
          v
          x

width：z轴
depth：x轴
虽然坐标轴有些反直觉，但是单机是这样的
]]


FN.DIR           = {
    north = { x = -1, y = 0, label = "north" }, --上
    south = { x = 1, y = 0, label = "south" },  --下
    west = { x = 0, y = -1, label = "west" },   --左
    east = { x = 0, y = 1, label = "east" },    --右
}

FN.DIR_OPPOSITE  =
{
    north = FN.DIR.south,
    south = FN.DIR.north,
    east = FN.DIR.west,
    west = FN.DIR.east,
}

local dir_labels = { "east", "west", "north", "south" }
function FN.GetRandomDir()
    return dir_labels[math.random(1, #dir_labels)]
end

----------------------------------------------------------------------------------------------------
local function OnBuiltDestroyNear(inst, radius)
    local x, y, z = inst.Transform:GetWorldPosition()
    for _, v in ipairs(TheSim:FindEntities(x, y, z, radius or 2)) do
        if v.components.workable then
            v.components.workable:Destroy(inst)
        end
    end
end

function FN.GetCenterPosByHouse(house)
    local door = house.components.teleporter and house.components.teleporter:GetTarget()
    local center = door and door:TroGetRoomCenter()
    return center and center:GetPosition()
end

--- 当房间被摧毁时把屋内的掉落物扔出来
--- 如果是remove就移除屋内道具，如果是敲毁就返还材料，只包括lootdropper和inventoryitem
function FN.OnRoomDestroy(room_center, out_ent, destroyer, is_remove)
    if not is_remove then
        --摧毁室内建筑，生成掉落物
        for _, v in ipairs(FN.FindRoomEnts(room_center)) do
            if not v:HasTag("interior_center") then          --中心点下面再删除
                if v.components.workable then
                    v.components.workable:Destroy(destroyer) --包括其他的房间
                elseif v.components.health and not v.components.health:IsDead()
                    and (not v.components.locomotor and v.components.lootdropper)
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
    local hx, hy, hz = out_ent.Transform:GetWorldPosition()
    for _, v in ipairs(FN.FindRoomEnts(room_center)) do
        if not is_remove and v.components.inventoryitem then
            if out_ent.components.lootdropper then
                out_ent.components.lootdropper:FlingItem(v) --借用lootdropper组件抛出物品
            else
                v.Transform:SetPosition(hx, hy, hz)
                v.components.inventoryitem:OnDropped(true)
            end
        elseif v.components.health and v.components.locomotor then
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

--- 当房屋被摧毁时把屋内的掉落物扔出来
--- 只针对更靠近外面的门
--- 如果是remove就移除屋内道具，如果是敲毁就返还材料，只包括lootdropper和inventoryitem
function FN.OnHouseDestroy(house, destroyer, isRemove)
    local inner_door = house.components.teleporter and house.components.teleporter:GetTarget()
    local room_center = inner_door and inner_door:IsValid() and inner_door:TroGetRoomCenter()
    if room_center then
        FN.OnRoomDestroy(room_center, house, destroyer, isRemove)
    end
end

--- 不可见墙，阻挡玩家移动
function FN.SpawnWall(x, z, width, depth)
    local room_dx = depth / 2 + 0.5
    local room_dz = width / 2 + 0.5
    for dx = -room_dx, room_dx do
        for dz = -room_dz, room_dz do
            if dx == -room_dx or dx == room_dx or dz == -room_dz or dz == room_dz then
                -- if troisdev then
                --     local part = SpawnPrefab("wall_stone")  --测试使用石墙
                -- end
                local part = SpawnPrefab("wall_invisible")
                part.Transform:SetPosition(x + dx, 0, z + dz)
            end
        end
    end
end

local cant_remove_tags = { "CLASSIFIED", "INLIMBO", "player", "irreplaceable" }
-- 清理目标区域的空间
-- 虽然房子坐标是累增的，但是防止一些特殊情况，比如mod中途移除再添加导致count重新计数，或者其他mod也有小房子，房子生成位置冲突
function FN.ClearSpace(x, z)
    for _, ent in ipairs(TheSim:FindEntities(x, 0, z, FN.RADIUS, nil, cant_remove_tags)) do
        ent:Remove()
    end
end

---根据目标对象位置计算距离最近的墙面
---@param target Entity
---@param is_set_pos boolean 是否设置实体坐标吸附到墙面
---@param limit_center boolean 是否限制实体必须在墙面的中心位置
---@return string side 哪个方向的墙
---@return number minDis 距离
function FN.TestWallOrnamentPos(target, is_set_pos, limit_center)
    local pos = target:GetPosition()
    local room_center = target:TroGetRoomCenter()
    if not room_center then
        return nil, nil --target不在房间里
    end

    local half_width = room_center.room_width:value() / 2
    local half_depth = room_center.room_depth:value() / 2
    local x, _, z = room_center.Transform:GetWorldPosition()

    local min_dist = 99999
    local dir_label
    for label, data in pairs(FN.DIR) do
        if data.x ~= 0 then
            local dist = math.abs(x + data.x * half_depth - pos.x)
            if dist < min_dist then
                min_dist = dist
                dir_label = label
            end
        elseif data.y ~= 0 then
            local dist = math.abs(z + data.y * half_width - pos.z)
            if dist < min_dist then
                min_dist = dist
                dir_label = label
            end
        end
    end

    if is_set_pos and min_dist < 4 then
        local wall_x, wall_z = x + FN.DIR[dir_label].x * half_depth, z + FN.DIR[dir_label].y * half_width
        if limit_center then
            target.Transform:SetPosition(wall_x, 0, wall_z)
        else
            local nx, nz = pos.x, pos.z
            if FN.DIR[dir_label].x ~= 0 then
                nx = wall_x
            else
                nz = wall_z
            end
            target.Transform:SetPosition(nx, 0, nz)
        end
    end

    return dir_label, min_dist
end

---判断柱子所在哪个角
function FN.TestBeam(target)
    local pos = target:GetPosition()
    local room_center = target:TroGetRoomCenter()
    if room_center then
        local x, y, z = room_center.Transform:GetWorldPosition()
        return pos.x < x, pos.z < z --isCorner,isLeft
    end
end

local TNTERIOR_ONE_OF_TAGS = { "player", "interior_door" }
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

----------------------------------------------------------------------------------------------------

local function IsInRoom(width, depth, room_x, room_z, x, z)
    return math.abs(x - room_x) <= depth / 2 + 1 and math.abs(z - room_z) <= width / 2 + 1 --在房间里，加1稍微放大一点儿考虑边界情况
end

-- 房间的配置表，除了name，其他都可省
-- local newRoom = {
--     width = 15,                                --房间宽度，z，用于生成不可见墙体，默认16
--     depth = 15,                                --房间深度，x，用于生成不可见墙体，默认10
--     addprops = {                               --房间内所有东西配置，包括地板、墙壁和房间门
--         {
--             name = "",                         --预制件名
--             x_offset = 0.5,                    --偏移，x上下偏移，往下增大
--             y_offset = 0.5,                    --偏移
--             z_offset = 0.5,                    --偏移，z左右偏移，往右增大
--             key = "exit",                      --对房间门生效，CreateRoom方法返回的表可以通过这个key获取到对应的门，同时用于连通不同房间的门
--             target_door = "",                  --如果需要不同房间的门相互连通，则需要配置target_door = key
--             init = function(inst, center) end, --生成后的初始化操作，第二个参数是中心点对象
--             startstate = "",                   --有Stategraph的单位初始state

--             --该数据通过tro_saveanim组件保存和加载，因此建议给有这些字段的预制件都添加该组件
--             bank = nil,         --支持函数、字符串
--             build = nil,        --支持函数、字符串
--             anim = nil,         --支持函数、字符串
--             scale = { -1, 1 },  --支持函数、表
--             rotation = 90,      --Transform的旋转，支持函数、数字
--             isloopplay = false, --是否循环播放
--             isdelayset = false, --加载时是否进入游戏再设置
--         },
--     },
-- }

---创建房间
---@param room table 房间配置表
---@param door_key_start number 门的key的起始值，默认1，注意不能和定义过的key重叠
---@return table doors  所有的房间门
---@return table door_map 门的key的映射关系
---@return Entity center
function FN.CreateRoom(room, door_key_start)
    door_key_start = door_key_start or 100000 --从一个很大值开始，遗迹从1开始应该也达不到这个值
    local doors = {}
    local door_map = {}
    local x, y, z = TheWorld.components.tro_roomspawner:GetPos():Get()

    -- 清除杂物，以防万一
    FN.ClearSpace(x, z)

    local width = room.width or TUNING.ROOM_TINY_WIDTH
    local depth = room.depth or TUNING.ROOM_TINY_DEPTH

    -- 生成中心点
    local center = SpawnPrefab("interior_center")
    center.Transform:SetPosition(x, 0, z)
    center:SetRoomSize(width,depth)

    if room.night_room then
        center:AddTag("night_room")
    end

    print(string.trofmt("生成房间，房子中心对象{}，房间大小：{},{}", center, width, depth))

    --生成墙体
    FN.SpawnWall(x, z, width, depth)

    --生产内部物品
    for _, data in ipairs(room.addprops) do
        local p = SpawnPrefab(data.name)
        if p then
            local x_offset = data.x_offset
            local scale = data.scale

            -- print(string.trofmt("创建内部对象：{}, key：{}", p, data.key))

            if room.cityID then --城镇标签
                p:TroAddSaveTag("city" .. room.cityID)
            end

            if p:HasTag("interior_door") then
                --门
                local key
                if data.key then
                    key = data.key
                else
                    key = door_key_start
                    door_key_start = door_key_start + 1
                end
                if doors[key] then
                    TroErrorHandle(string.trofmt("房间门的key重叠，是不是door_key_start变量给的值小了？key:{}", key), true)
                end
                doors[key] = p
                door_map[key] = data.target_door
            elseif p:HasTag("interior_floor") then
                --地板自适应缩放，但不是直接的线性关系，这里懒得搞什么公式了
                -- c_findtag("interior_floor").AnimState:SetScale()可在控制台不断调整
                scale = scale
                    or width == TUNING.ROOM_LARGE_WIDTH and { 2.8, 4 }
                    or width == TUNING.ROOM_MEDIUM_WIDTH and { 2.5, 3.6 }
                    or width == TUNING.ROOM_SMALL_WIDTH and { 2.9, 2.9 }
                    or width == TUNING.ROOM_TINY_WIDTH and { 1.6, 2.3 }
                    or nil
            elseif p:HasTag("interior_wall") then
                p.x_offset = x_offset or p.x_offset --设置一下，在后面的事件里别重新修改了
            end

            p.Transform:SetPosition(x + (x_offset or 0), (data.y_offset or 0), z + (data.z_offset or 0))
            if troisdev and not IsInRoom(width, depth, x, z, x + (x_offset or 0), z + (data.z_offset or 0)) then
                TroErrorHandle(string.trofmt("对象{}不在房间内生成，是不是坐标填错了？，x:{}, z:{}", p, x + (x_offset or 0), z + (data.z_offset or 0)), true)
            end

            if p.components.tro_saveanim then
                p.components.tro_saveanim:Init(data.bank, data.build, data.anim, scale, data.isloopplay, data.isdelayset, data.rotation)
            elseif scale then
                TroErrorHandle(string.trofmt("对象{}没有tro_saveanim组件，但是有缩放参数，是不是忘了加组件？", p), false)
            end

            if data.startstate then
                assert(p.sg and p.sg:HasState(data.startstate), data.name .. "没有sg或者没有state ：" .. data.startstate)
                p.sg:GoToState(data.startstate)
            end

            if data.init then
                data.init(p, center, data)
            end

            p:PushEvent("oninteriorspawn", data)
        else
            TroErrorHandle(data.name .. "预制件不存在", false)
        end
    end

    return doors, door_map, center
end

---创建很多房间
---@param rooms table 房间配置表
---@return table doors 所有出口门，也就是未关联的房间门
---@return table door_map 门的key的映射关系
---@return table centers
function FN.CreateRooms(rooms)
    local doors = {}
    local door_map = {}
    local centers = {}

    for _, room in ipairs(rooms) do
        local d, map, center = FN.CreateRoom(room)
        table.tromerge(doors, d)
        table.tromerge(door_map, map)
        table.insert(centers, center)
    end

    -- 关联门
    for key, door in pairs(doors) do
        local target_door = door_map[key] and doors[door_map[key]]
        print(string.trofmt("key为{}的门{}对应连接key为{}的门{}", key, door, door_map[key], target_door))
        if target_door then
            door.components.teleporter:Target(target_door)
            target_door.components.teleporter:Target(door)
        else
            --如果有门没有连接到其他门，打印一下
            if troisdev and door.prefab ~= "wallcrack_ruins" then
                door:DoTaskInTime(0, function(inst)
                    if inst.components.teleporter and not inst.components.teleporter:GetTarget() then
                        TroErrorHandle(string.trofmt("门{}的key为{}，没有关联到目标", door, key), false)
                    end
                end)
            end
        end
    end

    return doors, door_map, centers
end

-- 还要装一个对应的门
local function SpawnNearDoor(door, near_room)
    local pos = near_room:GetPosition()
    local new_door = SpawnPrefab(door.prefab)

    local opp_dir = FN.DIR_OPPOSITE[door.door_orientation]
    new_door:SetDoorOrientation(opp_dir.label)
    print(string.trofmt("生成新房间门：{}，位置：{},{},{}", new_door, pos.x + opp_dir.x * 5, 0, pos.z * 7.5))
    new_door.Transform:SetPosition(pos.x + opp_dir.x * 5, 0, pos.z + opp_dir.y * 7.5)

    door.components.tro_saveanim:Init(nil, nil, door.prefab .. "_open_" .. door.door_orientation)
    new_door.components.tro_saveanim:Init(nil, nil, door.prefab .. "_open_" .. new_door.door_orientation)

    door.components.teleporter:Target(new_door)
    new_door.components.teleporter:Target(door)

    if door.SoundEmitter then
        door.SoundEmitter:PlaySound("dontstarve/creatures/together/klaus/lock_break")
    end

    OnBuiltDestroyNear(new_door)
    return new_door
end

--- 生成临近的新房间，用于房屋扩展许可证
function FN.SpawnNearHouseInterior(door, room, dir)
    if door.components.teleporter:GetTarget() then
        print("生成新房间失败，该门已经有传送目标了", door)
        return false
    end
    local _, _, center = FN.CreateRoom(room)
    SpawnNearDoor(door, center)
    center:AddTag("room_explored")
    return true
end

-- 门生成时如果该方向已经有房间了直接连通
function FN.OnDoorBuiltCheckNearRoom(door)
    local x, y, z = door.Transform:GetWorldPosition()
    local room_grid, room_x, room_y = FN.GetCurrentRoomsGrid(x, y, z)
    local dir = door.door_orientation
    local near_room_data = room_grid[FN.DIR[dir].x + room_x] and room_grid[FN.DIR[dir].x + room_x][FN.DIR[dir].y + room_y]
    if near_room_data then
        SpawnNearDoor(door, near_room_data.ent)
    end
end

function FN.CreateSimpleInterior(inst, room)
    if inst.components.teleporter:GetTarget() then return end

    local doors = FN.CreateRoom(room)
    inst.components.teleporter:Target(doors.exit)
    doors.exit.components.teleporter:Target(inst)
end

-- 获取该房间内的实体
function FN.FindRoomEnts(room, musttags, canttags, mustoneoftags)
    local width = room.room_width:value() --z
    local depth = room.room_depth:value() --x
    local ents = {}
    local x, y, z = room.Transform:GetWorldPosition()
    local r = math.sqrt(depth * depth + width * width) / 2
    for _, v in ipairs(TheSim:FindEntities(x, 0, z, r, musttags, canttags, mustoneoftags)) do
        local vx, _, vz = v.Transform:GetWorldPosition()
        if IsInRoom(width, depth, x, z, vx, vz) then
            table.insert(ents, v)
        end
    end
    return ents
end

----------------------------------------------------------------------------------------------------

-- 获得指定位置当前室内布局网格，用于地图绘制和室内新门构建
function FN.GetCurrentRoomsGrid(rx, ry, rz)
    local room_grid = {}

    local start_room
    if type(rx) == "table" and rx.prefab then
        start_room = rx
    else
        start_room = TheWorld.Map:TroGetRoomCenter(rx, ry, rz)
    end
    if not start_room then
        return room_grid
    end

    local start_x, start_y

    local min_x, max_x, min_y, max_y = 0, 0, 0, 0
    local room_poses = { [start_room] = { x = 0, y = 0 } }

    local function dfs(room)
        local cur_x = room_poses[room].x
        local cur_y = room_poses[room].y
        for dir, near_room in pairs(room:GetNearRooms()) do
            room_poses[room][dir] = true
            if not room_poses[near_room] then
                local x = cur_x + FN.DIR[dir].x
                local y = cur_y + FN.DIR[dir].y
                room_poses[near_room] = { x = x, y = y }
                min_x = math.min(min_x, x)
                max_x = math.max(max_x, x)
                min_y = math.min(min_y, y)
                max_y = math.max(max_y, y)
                dfs(near_room)
            end
        end
    end
    dfs(start_room)

    for i = min_x, max_x do
        local row = {}
        for j = min_y, max_y do
            table.insert(row, false) --空的位置填充false
        end
        table.insert(room_grid, row)
    end

    for room, pos in pairs(room_poses) do
        local x = pos.x - min_x + 1
        local y = pos.y - min_y + 1
        room_grid[x][y] = { ent = room }
        for dir, _ in pairs(FN.DIR) do
            if pos[dir] then
                room_grid[x][y][dir] = true --房间之间连通性
            end
        end
        if room == start_room then
            start_x = x
            start_y = y
        end
    end

    if troisdev then
        print("打印指定位置房间网格", rx, ry, rz)
        for x = 1, #room_grid do
            local s = ""
            for y = 1, #room_grid[x] do
                local room = room_grid[x][y] and room_grid[x][y].ent
                local is_start = room == start_room
                s = s .. (not room and " 000000 " or (is_start and ("[" .. tostring(room.GUID) .. "]") or (" " .. tostring(room.GUID) .. " "))) .. "  "
            end
            print(s)
        end
    end

    return room_grid, start_x, start_y
end

return FN
