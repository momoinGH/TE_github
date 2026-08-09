local RoomUtils = require("tro_utils/room_utils")

local function DefaultDoorAcceptTest(inst, item)
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
    local cur_room = inst:TroGetRoomCenter() --可以为空，外面的门就没有这个
    if cur_room and cur_room.destroyed then
        return
    end
    local to_door = inst.components.teleporter and inst.components.teleporter:GetTarget()
    if not to_door then
        return
    end
    local to_room = to_door:TroGetRoomCenter()
    if not to_room then
        return --不管
    end
    -- 这里作简单判断，只考虑一个出口，如果目标房间除了该门没有其他出口则把里面的房间全部销毁，如果有则表示当前的房间还是更靠内的房间
    if inst:HasTag("interior_toexitdoor") then
        -- 更靠内的门被销毁了
        if to_door:IsValid() then
            if to_door.components.workable then
                to_door.components.workable:Destroy(inst)
            else
                to_door:Remove()
            end
        end
        return
    end
    -- 更靠外的门被销毁了
    if not to_door:HasTag("interior_toexitdoor") then
        return --不应该
    end
    -- 收集里面要删除的房间
    local queue = { to_room }
    local del_rooms = { [to_room] = true }
    while #queue > 0 do
        local room = table.remove(queue, 1)
        local rooms = room:GetNearRooms()
        for _, r in pairs(rooms) do
            if r ~= cur_room and not del_rooms[r] then
                del_rooms[r] = true
                table.insert(queue, r)
            end
        end
    end

    for room, _ in pairs(del_rooms) do
        room.destroyed = true
        RoomUtils.OnRoomDestroy(room, inst, inst)
    end
end

-- 在门生成时，根据位置自动设置方向
local function OnInteriorSpawn(inst, data)
    if inst.SetDoorOrientation then
        local dir_label = RoomUtils.TestWallOrnamentPos(inst)
        inst:SetDoorOrientation(dir_label)
    end
end

local function OnDoneTeleporting(inst, obj)
    obj:PushEvent("enterroom", inst) --猪人商人进店要说两句的
end

local function OnTeleportTargetChange(inst, target)
    if inst.targetdoor then
        inst.targetdoor:set(target)
    end

    if target and not target:TroIsWorldOut() then
        inst:AddTag("interior_houseexit")  --表示这是一个出口
        inst:AddTag("interior_toexitdoor") --表示这是通向出口的门
    else
        inst:RemoveTag("interior_houseexit")
    end
end

local function OnSave(inst, data)
    local refs = inst._OnSave and inst:_OnSave(data) or nil
    data.door_orientation = inst.door_orientation
    -- data.interior_houseexit = inst:HasTag("interior_houseexit") --这个不需要，加载的时候设置目标就会恢复
    data.interior_toexitdoor = inst:HasTag("interior_toexitdoor")
    data._tro_interior_created = inst._tro_interior_created --是否已经创建过虚空房间
    return refs
end

local function OnLoad(inst, data)
    if inst._OnLoad then
        inst:_OnLoad(data)
    end

    if data then
        if data.interior_toexitdoor then
            inst:AddTag("interior_toexitdoor")
        end
    end
    if data and data.door_orientation and inst.SetDoorOrientation then
        inst:SetDoorOrientation(data.door_orientation)
    end
    inst._tro_interior_created = data._tro_interior_created or inst._tro_interior_created
end

local function OnLoadPostPass(inst, newents, data)
    if inst._OnLoadPostPass then
        inst:_OnLoadPostPass(newents, data)
    end
end

local function SetDoorOrientation(inst, orientation)
    inst.door_orientation = orientation
    for _, dir in pairs(RoomUtils.DIR) do
        inst:RemoveTag("interior_" .. dir.label .. "_door")
    end
    inst:AddTag("interior_" .. orientation .. "_door") --门朝向标签，客户端可获取该标签

    if orientation == "south" then                     --其他方向的门层级放低点
        inst.AnimState:SetLayer(LAYER_WORLD)
    else
        -- inst.AnimState:SetLayer(LAYER_BACKGROUND)
        inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    end
end

local function GetDoorOrientation(inst)
    if inst.door_orientation then
        return inst.door_orientation
    end

    for _, dir in pairs(RoomUtils.DIR) do
        if inst:HasTag("interior_" .. dir.label .. "_door") then
            return dir.label
        end
    end

    return RoomUtils.TestWallOrnamentPos(inst)
end

---虚空门
---@param data.assets table
---@param data.prefabs table
---@param data.bank string
---@param data.build string
---@param data.anim string
---@param data.minimap string
---@param data.trader boolean 是否可用于传送物品、交易
---@param data.is_inner boolean 是否是虚空内部的生成的门，如果是则表示需要记录中心点对象
---@param data.door_orientation string 门的初始方向，有值就表示这是一个有四个方向的门，在上面的门就是north，左边的门就是west
---@param data.usesound string 使用门时播放的音效
local function MakeDoor(name, data, common_post_fn, master_post_fn)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        if data.bank then
            inst.AnimState:SetBank(data.bank)
        end
        if data.build then
            inst.AnimState:SetBuild(data.build)
        end
        if data.anim then
            inst.AnimState:PlayAnimation(data.anim)
        end

        if data.minimap then
            inst.entity:AddMiniMapEntity()
            inst.MiniMapEntity:SetIcon(data.minimap)
        end

        inst:AddTag("NOBLOCK")
        inst:AddTag("interior_door") --这个表示是可以通向其他房间的门

        if data.trader then
            inst:AddTag("trader")
            inst:AddTag("alltrader")
        end

        inst.entity:SetCanSleep(false) --休眠会影响网络变量的同步，而且客户端没有休眠的门实体
        if data.is_inner then
            --我需要客机拿到目的地房间的位置，用于构建小地图
            inst.targetdoor = net_entity(inst.GUID, "tro_interiordoor.targetdoor")
        end

        if data.door_orientation then
            inst.GetDoorOrientation = GetDoorOrientation
        end

        if common_post_fn then
            common_post_fn(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.OnDoorRemove = OnDoorRemove --门被销毁时默认逻辑，清空里面所有东西，并且掉出来

        if data.door_orientation then
            inst.door_orientation = nil
            SetDoorOrientation(inst, data.door_orientation)
            inst.SetDoorOrientation = SetDoorOrientation

            if not inst.components.tro_saveanim then
                inst:AddComponent("tro_saveanim")
            end
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("teleporter")
        inst.components.teleporter.offset = 0
        inst.components.teleporter.travelcameratime = 0
        inst.components.teleporter.travelarrivetime = 0
        inst:ListenForEvent("tro_onteleportertargetchange", OnTeleportTargetChange)
        -- inst.components.teleporter.onActivate = OnActivate
        -- inst.components.teleporter.OnDoneTeleporting = OnDoneTeleporting


        if data.trader then
            inst:AddComponent("trader")
            inst.components.trader.acceptnontradable = true
            inst.components.trader.deleteitemonaccept = false
            inst.components.trader:SetAbleToAcceptTest(DefaultDoorAcceptTest)
            inst.components.trader.onaccept = DefaultOnDoorAccept

            inst:AddComponent("hauntable")
            inst.components.hauntable:SetOnHauntFn(OnDoorHaunt)
        end

        if data.usesound then
            inst.usesound = data.usesound
        end

        inst:ListenForEvent("doneteleporting", OnDoneTeleporting)
        inst:ListenForEvent("oninteriorspawn", OnInteriorSpawn)
        inst:ListenForEvent("onremove", function(inst)
            if inst.OnDoorRemove then
                inst:OnDoorRemove()
            end
        end)

        if master_post_fn then
            master_post_fn(inst)
        end

        inst._OnSave = inst.OnSave
        inst._OnLoad = inst.OnLoad
        inst._OnLoadPostPass = inst.OnLoadPostPass
        inst.OnSave = OnSave
        inst.OnLoad = OnLoad
        inst.OnLoadPostPass = OnLoadPostPass

        return inst
    end

    return Prefab(name, fn, data.assets, data.prefabs)
end

return {
    MakeDoor = MakeDoor,
    DefaultOnDoorAccept = DefaultOnDoorAccept
}
