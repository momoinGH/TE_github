local RoomUtils = require("tropical_utils/room_utils")
local Hooks = require("tropical_utils/hooks")

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
    RoomUtils.OnHouseDestroy(inst, nil, true)
end

local function OnDoneTeleporting(inst, obj)
    obj:PushEvent("enterroom", inst) --猪人商人进店要说两句的
end

local function TargetBefore(self, otherTeleporter)
    if self.inst.targetdoor then
        self.inst.targetdoor:set(otherTeleporter)
    end
end

local function GetRoomCenter(inst)
    return inst.room_center and inst.room_center:value() or nil
end

local function OnSave(inst, data)
    local refs = inst._OnSave and inst:_OnSave(data) or nil
    local center = inst:GetRoomCenter()
    if center then
        data.center_guid = center.GUID
        refs = refs or {}
        refs = { center.GUID }
    end
    return refs
end

local function OnLoad(inst, data)
    if inst._OnLoad then
        inst:_OnLoad(data)
    end
end

local function OnLoadPostPass(inst, newents, data)
    if inst._OnLoadPostPass then
        inst:_OnLoadPostPass(newents, data)
    end

    if data and data.center_guid then
        local center = newents[data.center_guid]
        if center and inst.room_center then
            inst.room_center:set(center.entity)
        end
    end

    --加载的时候我需要手动给网络变量赋值
    local targetdoor = inst.components.teleporter:GetTarget()
    if targetdoor and inst.targetdoor then
        inst.targetdoor:set(targetdoor)
    end
end

local function SetDoorOrientation(inst, orientation)
    local anim
    -- 检查当前门动画是不是_closed后缀
    for _, dir in ipairs(RoomUtils.DIR) do
        if inst.AnimState:IsCurrentAnimation(dir.label .. "_closed") then
            anim = orientation .. "_closed"
            break
        end
    end
    if anim then
        inst.AnimState:PlayAnimation(anim)
    end
    inst.door_orientation = orientation
    for _, dir in ipairs(RoomUtils.DIR) do
        inst:RemoveTag("interior_" .. dir.label .. "_door")
    end
    inst:AddTag("interior_" .. orientation .. "_door") --门朝向标签，客户端可获取该标签

    if orientation == "south" then                     --其他方向的门层级放低点
        inst.AnimState:SetLayer(LAYER_WORLD)
    else
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
    end
end

local function GetDoorOrientation(inst)
    if inst.door_orientation then
        return inst.door_orientation
    end

    for _, dir in ipairs(RoomUtils.DIR) do
        if inst:HasTag("interior_" .. dir.label .. "_door") then
            return dir.label
        end
    end
end

-- 根据动画重新刷新门朝向字段
local function OnSetAnimData(inst)
    local anim = inst.components.tro_saveanim.anim
    if not anim then return end

    for _, dir in ipairs(RoomUtils.DIR) do
        if string.starts(anim, dir.label) then
            SetDoorOrientation(inst, dir.label)
        end
    end
end

-- TODO 干掉这个，用MakeDoor代替
--- 虚空门的基础代码
--- trader和hauntable用于传送物品，teleporter用来传送玩家
--- teleporter加在所有门上，可以关联传送目的地和判断房间是否已经创建
---@param bank string
---@param build string
---@param anim string
---@param trader boolean|nil 是否可用于传送物品、交易
---@param interior_door boolean|nil 是否是虚空内部的生成的门，如果是则表示需要记录中心点对象
---@param minimap string|nil 小地图图标
---@param usesound string|nil 使用门的声音，建议"dontstarve/common/pighouse_door"、"dontstarve_DLC003/common/objects/store/door_open"
---@param has_orientation boolean 是否是有四个方向的门
local function MakeBaseDoor(bank, build, anim, trader, interior_door, minimap, usesound, has_orientation)
    local inst = CreateEntity()

    inst.entity:SetCanSleep(false) --休眠会影响网络变量的更新

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

    -- TODO 不知道为什么主机设置了网络变量客机老是获取不到
    --我需要客机拿到目的地房间的位置，用于构建小地图
    inst.targetdoor = net_entity(inst.GUID, "tro_interiordoor.targetdoor")

    if interior_door then
        inst.room_center = net_entity(inst.GUID, "tro_interiordoor.room_center")
    end
    inst.GetRoomCenter = GetRoomCenter

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    if has_orientation then
        inst.door_orientation = nil
        local door_orientation = "north" --默认，不用保存，监听tro_saveanim组件的事件来初始化
        for _, dir in ipairs(RoomUtils.DIR) do
            if string.starts(anim, dir.label) then
                door_orientation = dir.label
                break
            end
        end
        SetDoorOrientation(inst, door_orientation)
        inst.SetDoorOrientation = SetDoorOrientation

        if not inst.components.tro_saveanim then
            inst:AddComponent("tro_saveanim")
            inst:ListenForEvent("tro_saveanimonset", OnSetAnimData)
        end
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("teleporter")
    inst.components.teleporter.offset = 0
    inst.components.teleporter.travelcameratime = 0
    inst.components.teleporter.travelarrivetime = 0
    Hooks.FnDecorator(inst.components.teleporter, "Target", TargetBefore)
    -- inst.components.teleporter.onActivate = OnActivate
    -- inst.components.teleporter.OnDoneTeleporting = OnDoneTeleporting

    if trader then
        inst:AddComponent("trader")
        inst.components.trader.acceptnontradable = true
        inst.components.trader.deleteitemonaccept = false
        inst.components.trader:SetAbleToAcceptTest(DefaultDoorAcceptTest)
        inst.components.trader.onaccept = DefaultOnDoorAccept

        inst:AddComponent("hauntable")
        inst.components.hauntable:SetOnHauntFn(OnDoorHaunt)
    end

    if usesound then
        inst.usesound = usesound
    end

    inst:ListenForEvent("onremove", OnDoorRemove)
    inst:ListenForEvent("doneteleporting", OnDoneTeleporting)

    --外部只能赋值inst._OnSave和inst._OnLoadPostPass
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnLoadPostPass = OnLoadPostPass

    return inst
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
---@param data.door_orientation string 门的初始方向，有值就表示这是一个有四个方向的门
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
        inst:AddTag("interior_door")

        if data.trader then
            inst:AddTag("trader")
            inst:AddTag("alltrader")
        end

        if data.is_inner then
            inst.entity:SetCanSleep(false) --休眠会影响网络变量的更新
            -- TODO 不知道为什么主机设置了网络变量客机老是获取不到
            --我需要客机拿到目的地房间的位置，用于构建小地图
            inst.targetdoor = net_entity(inst.GUID, "tro_interiordoor.targetdoor")
            inst.room_center = net_entity(inst.GUID, "tro_interiordoor.room_center")
        end
        inst.GetRoomCenter = GetRoomCenter

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

        if data.door_orientation then
            inst.door_orientation = nil
            SetDoorOrientation(inst, data.door_orientation)
            inst.SetDoorOrientation = SetDoorOrientation

            if not inst.components.tro_saveanim then
                inst:AddComponent("tro_saveanim")
                inst:ListenForEvent("tro_saveanimonset", OnSetAnimData)
            end
        end


        inst:AddComponent("inspectable")

        inst:AddComponent("teleporter")
        inst.components.teleporter.offset = 0
        inst.components.teleporter.travelcameratime = 0
        inst.components.teleporter.travelarrivetime = 0
        Hooks.FnDecorator(inst.components.teleporter, "Target", TargetBefore)
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

        inst:ListenForEvent("onremove", OnDoorRemove)
        inst:ListenForEvent("doneteleporting", OnDoneTeleporting)

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
    MakeBaseDoor = MakeBaseDoor,
    DefaultOnDoorAccept = DefaultOnDoorAccept
}
