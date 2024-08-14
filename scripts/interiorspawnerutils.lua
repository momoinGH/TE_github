-- 为虚空小房子服务

local FN = {}

FN.RADIUS = 12     --小房子半径
FN.BASE_OFF = 1500 --小房子的初始z坐标，需要注意的是这个是小房子中心点的初始z坐标
FN.ROOM_SIZE = 60
FN.ROW_COUNT = FN.BASE_OFF / FN.ROOM_SIZE * 2
FN.SPAWN_ORIGIN = {
    dx = { -5.5, 5.5 }, --上下
    dz = { -9, 8 }      --左右
}

--- 当房屋被摧毁时把屋内的掉落物扔出来
--- 如果是remove就移除屋内道具，如果是敲毁就返还材料，只包括lootdropper和inventoryitem
function FN.OnHouseDestroy(house, destroyer, isRemove)
    local center = house.components.entitytracker and house.components.entitytracker:GetEntity("interior_center")
    local centerPos = center and center:GetPosition()
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
                    and not v.components.locomotor and v.components.lootdropper
                then
                    v.components.lootdropper:DropLoot() --一般是在死亡的sg中生成，我杀死直接移除不会生成额外的掉落物
                    v.components.health:Kill()
                end
            end
        end
    end

    --传送掉落物，移除地板
    for _, v in ipairs(TheSim:FindEntities(centerPos.x, centerPos.y, centerPos.z, dis)) do
        if not isRemove and v.components.inventoryitem then
            house.components.lootdropper:FlingItem(v) --借用lootdropper组件抛出物品
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

--- 不可见墙，阻挡玩家移动
function FN.SpawnWall(x, z)
    local origin = FN.SPAWN_ORIGIN
    for dx = origin.dx[1], origin.dx[2] do --因为两侧墙角度不一样，所以墙壁并不是对称的
        for dz = origin.dz[1], origin.dz[2] do
            if dx == origin.dx[1] or dx == origin.dx[2] or dz == origin.dz[1] or dz == origin.dz[2] then
                local part = SpawnPrefab("wall_tigerpond")
                part.Transform:SetPosition(x + dx + 0.5, 0, z + dz + 0.5)
            end
        end
    end
end

---根据格式初始化室内装饰
function FN.InitHouseInteriorPrefab(p, data)
    if data.children then
        p.tempChildrens = data.children
    end
    if data.rotation then
        p.Transform:SetRotation(data.rotation)
    end
    if data.animdata then
        if data.animdata.flip then
            p.AnimState:SetScale(-1, 1)
        end
        if data.animdata.bank then
            p.AnimState:SetBank(data.animdata.bank)
        end
        if data.animdata.build then
            p.AnimState:SetBuild(data.animdata.build)
        end
        if data.animdata.anim then
            p.AnimState:PlayAnimation(data.animdata.anim)
        end
        if data.animdata.background then
            p.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
            -- p.AnimState:SetOrientation(ANIM_ORIENTATION.RotatingBillboard)
            p.AnimState:SetSortOrder(3)
        end
        if data.animdata.scale then
            local scale = data.animdata.scale
            local x, y
            if type(scale) == "number" then
                x = scale
                y = scale
            else
                x = scale[1]
                y = scale[2]
            end
            p.AnimState:SetScale(x, y)
        end
    end

    if data.addtags then
        for _, tag in ipairs(data.addtags) do
            p:AddTag(tag)
        end
    end
end

-- 初始化装饰物的子对象，只需初始化部分数据就行
function FN.InitHouseInteriorPrefabChild(p, data)
    if data.rotation then
        p.Transform:SetRotation(data.rotation)
    end
    if data.animdata and data.animdata.flip then
        p.AnimState:SetScale(-1, 1)
    end
end

-- 清理目标区域的空间
-- 虽然房子坐标是累增的，但是防止一些特殊情况，比如mod中途移除再添加导致count重新计数，或者其他mod也有小房子，房子生成位置冲突
function FN.ClearSpace(x, z)
    for _, ent in ipairs(TheSim:FindEntities(x, 0, z, FN.RADIUS)) do
        ent:Remove()
    end
end

---根据格式初始化室内装饰
function FN.SpawnHouseInteriorPrefabs(x, z, addprops, door)
    FN.ClearSpace(x, z)

    -- 生成中心点
    local center = SpawnPrefab("interior_center")
    center.Transform:SetPosition(x, 0, z)
    door.components.entitytracker:TrackEntity("interior_center", center)

    FN.SpawnWall(x, z)

    for _, data in ipairs(addprops) do
        local p = SpawnPrefab(data.name)
        -- print("生成" .. data.name, p, x + (data.x_offset or 0), z + (data.z_offset or 0))

        if x and z and (data.x_offset or data.z_offset) then
            p.Transform:SetPosition(x + (data.x_offset or 0), data.y_offset or 0, z + (data.z_offset or 0))
        end

        FN.InitHouseInteriorPrefab(p, data)

        p.initData = {
            children = data.children,
            rotation = data.rotation,
            animdata = data.animdata,
            addtags = data.addtags
        }

        if data.init then
            data.init(p, door)
        end
    end
end

---生成室内小房子
---@param door Entity 门或者小房子，要求有entitytracker对象
---@param addprops table
function FN.SpawnHouseInterior(door, addprops)
    assert(door.components.entitytracker, "The door entity object must have entitytracker component")

    local pos = TheWorld.components.tropical_interiorspawner:GetPos()
    FN.SpawnHouseInteriorPrefabs(pos.x, pos.z, addprops, door)
    return pos
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

---传入hamletdoor组件对象，递归检测内部是否存在玩家
local TNTERIOR_ONE_OF_TAGS = { "player", "hamlet_door" }
function FN.InterioHasPlayer(door)
    local center = door.components.entitytracker and door.components.entitytracker:GetEntity("interior_center")
    local centerPos = center and center:GetPosition()

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
function FN.SpawnNearHouseInterior(door, addprops)
    local center = door.components.entitytracker:GetEntity("interior_center")
    if center then return false end                    --不可能
    local dpos = FN.GetDoorRelativePosition(door)
    if not dpos or not door.side then return false end --不可能
    local pos = FN.SpawnHouseInterior(door, addprops)

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

    door.AnimState:PlayAnimation(door.playAnim .. doorAnim)
    door.initData.animdata.anim = door.playAnim .. doorAnim
    newDoor.AnimState:PlayAnimation(door.playAnim .. newDoorAnim)
    newDoor.initData = { animdata = { anim = door.playAnim .. newDoorAnim } }

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

--- 虚空门的基础代码
--- trader和hauntable用于传送物品，teleporter用来传送玩家
--- teleporter可以保存传送目的地的门，entitytracker可以保存目的地小房间的中心点
---@param bank string
---@param build string
---@param anim string
---@param trader boolean|nil 是否可用于传送物品、交易
---@param access_room boolean|nil 是否通向虚空小房间
---@param minimap string|nil 小地图图标
function FN.MakeBaseDoor(bank, build, anim, trader, access_room, minimap)
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
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)

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

    if trader then
        inst:AddComponent("trader")
        inst.components.trader.acceptnontradable = true
        inst.components.trader.deleteitemonaccept = false
        inst.components.trader:SetAbleToAcceptTest(DefaultDoorAbleToAcceptTest)
        inst.components.trader.onaccept = DefaultOnDoorAccept

        inst:AddComponent("hauntable")
        inst.components.hauntable:SetOnHauntFn(OnDoorHaunt)
    end

    if access_room then
        inst:AddComponent("entitytracker")
    end

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

FN.DIR_OPPOSITE2 = {
    NORTH = SOUTH,
    SOUTH = NORTH,
    EAST = WEST,
    WEST = EAST
}

return FN
