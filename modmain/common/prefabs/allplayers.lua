local Utils = require("tropical_utils/utils")


-- 调试焦点
-- TUNING.TX = 0
-- TUNING.TY = 0

-- 我需要焦点再地板中心再偏下点，参考focalpoint组件的UpdateFocus函数
local function focalPointUpdater(dt, params, parent, dist_sq, x, y)
    local tpos = params.target:GetPosition()
    local ppos = parent:GetPosition()

    local offs = tpos - ppos
    if dist_sq > params.minrange * params.minrange then
        local range = params.maxrange - params.minrange
        offs = offs * (range ~= 0 and ((params.maxrange - math.sqrt(dist_sq)) / range))
    end
    offs.x = offs.x + x
    offs.y = offs.y + y

    -- offs.x = offs.x + TUNING.TX
    -- offs.y = offs.y + TUNING.TY

    TheCamera:SetOffset(offs)
end

-- this is called on client
local function OnDirtyEventCameraStuff(inst)
    if inst ~= ThePlayer then return end

    local x, y, z = inst.Transform:GetWorldPosition()
    local target = TheWorld.Map:TroGetRoomCenter(x, y, z)
    if not target then
        --  默认
        -- TheCamera:SetDefault()
        -- TheCamera:SetTarget(TheFocalPoint)
        TheCamera.controllable = true
        TheCamera.distancetarget = 30 --默认值
        TheCamera:SetHeadingTarget(0) --房间之间穿梭的时候也不用一直转视角了
        TheFocalPoint.components.focalpoint:StopFocusSource(inst, "tropical_inroom")
        TheWorld:PushEvent("underwatercaveexit", TheWorld.state.phase)
        return
    end

    -- TheWorld:PushEvent("underwatercave", "night")
    -- 这里只改距离distancetarget和偏移量x
    local width = target.room_width:value()
    TheCamera.controllable = false
    TheCamera.distancetarget = 21.5 + 0.75 * (width - 16) + GetModConfigData("housewallajust")
    TheCamera:SetHeadingTarget(0)
    TheFocalPoint.components.focalpoint:StartFocusSource(inst, "tropical_inroom",
        target, math.huge, math.huge, 10, {
            UpdateFn = function(dt, params, parent, dist_sq)
                focalPointUpdater(dt, params, parent, dist_sq, -2 + 0.2 * (width - 16), 0)
            end
        })
end



----------------------------------------------------------------------------------------------------

AddPlayerPostInit(function(inst)
    inst.tropical_room_event = net_event(inst.GUID, "player.tropical_room_event")
    inst._isopening = net_bool(inst.GUID, "IsOpening")

    if TheWorld.ismastersim then
        if not inst.components.regionaware then
            print("Adding regionaware to player")
            inst:AddComponent("regionaware")
        end
    end

    if inst.components.infestable == nil then
        inst:AddComponent("infestable")
    end


    if inst.components.drownable == nil then
        inst:AddComponent("drownable")
    end

    if inst.components.shopper == nil then
        inst:AddComponent("shopper")
    end

    if not TheNet:IsDedicated() then
        inst:ListenForEvent("player.tropical_room_event", OnDirtyEventCameraStuff)
    end

    if TheNet:GetIsServer() then
        inst.findpigruinstask = inst:DoPeriodicTask(2, function()
            local x, y, z = inst.Transform:GetWorldPosition()
            if inst.LightWatcher ~= nil and #TheSim:FindEntities(x, y, z, 40, { "pisodaruina" }) > 0 then
                local thresh = TheSim:GetLightAtPoint(10000, 10000, 10000)
                inst.LightWatcher:SetLightThresh(0.075 + thresh)
                inst.LightWatcher:SetDarkThresh(0.05 + thresh)
            else
                inst.LightWatcher:SetLightThresh(0.075)
                inst.LightWatcher:SetDarkThresh(0.05)
            end
        end)
    end
end)
