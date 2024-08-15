local Utils = require("tropical_utils/utils")
local InteriorSpawnerUtils = require("interiorspawnerutils")

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

    TheCamera:SetOffset(offs)
end

local function focalPointUpdater4(dt, params, parent, dist_sq)
    focalPointUpdater(dt, params, parent, dist_sq, 0, 1.5)
end

local function focalPointUpdater6(dt, params, parent, dist_sq)
    focalPointUpdater(dt, params, parent, dist_sq, 1, 1.5)
end

local function OnDirtyEventCameraStuff(inst) -- this is called on client, if the server does inst.mynetvarCameraMode:set(...)
    local val = inst.mynetvarCameraMode:value()

    if val == 1 then -- for jumping(OnActive) function
        TheCamera.controllable = false
        TheCamera.cutscene = true
        TheCamera.headingtarget = 0
        TheCamera.distancetarget = 20 + GetModConfigData("housewallajust")
        TheCamera.targetoffset = Vector3(-2.3, 1.7, 0)
    elseif val == 2 then
        TheCamera:SetDistance(12)
    elseif val == 4 then
        -- 哈姆雷特小房子
        local target = GetClosestInstWithTag("interior_center", inst, 30)
        if target then
            TheCamera.controllable = false
            TheCamera.distancetarget = 21.5 + GetModConfigData("housewallajust")
            TheCamera:SetHeadingTarget(0)
            TheFocalPoint.components.focalpoint:StartFocusSource(inst, "tropical_inroom",
                target, math.huge, math.huge, 10, { UpdateFn = focalPointUpdater4 })
        end
    elseif val == 5 then --for player prox
        -- 遗迹
        local target = GetClosestInstWithTag("interior_center", inst, 30)
        if target then
            TheCamera.controllable = false
            print("检查", GetModConfigData("housewallajust"))
            TheCamera.distancetarget = 25 + GetModConfigData("housewallajust")
            TheCamera:SetHeadingTarget(0)
            TheFocalPoint.components.focalpoint:StartFocusSource(inst, "tropical_inroom",
                target, math.huge, math.huge, 10, { UpdateFn = focalPointUpdater6 })

            TheWorld:PushEvent("underwatercave", "night")
        end
    elseif val == 6 then --for player prox
        TheCamera:SetDefault()
        TheCamera:SetTarget(TheFocalPoint)

        local fasedodia = "night"
        if TheWorld.state.isday then fasedodia = "day" end
        if TheWorld.state.isdusk then fasedodia = "dusk" end
        if TheWorld.state.isnight then fasedodia = "night" end
        TheWorld:PushEvent("underwatercaveexit", fasedodia)
        TheFocalPoint.SoundEmitter:KillSound("storemusic")
    elseif val == 7 then --for player prox
        TheCamera.controllable = false
        TheCamera.cutscene = true
        TheCamera.headingtarget = 0
        TheCamera.distancetarget = 28 + GetModConfigData("housewallajust")
        TheCamera:SetTarget(GetClosestInstWithTag("pisointeriorpalace", inst, 30))
        TheCamera.targetoffset = Vector3(5, 1.5, 0)
    elseif val == 8 then --for player prox
        TheCamera.controllable = false
        TheCamera.cutscene = true
        TheCamera.headingtarget = 0
        TheCamera.distancetarget = 25 + GetModConfigData("housewallajust")
        TheCamera:SetTarget(GetClosestInstWithTag("pisointerioruins", inst, 30)) --inst = ThePlayer
        TheCamera.targetoffset = Vector3(6, 1.5, 0)
    else
        --  默认
        -- TheCamera:SetDefault()
        -- TheCamera:SetTarget(TheFocalPoint)
        TheCamera.controllable = true
        TheCamera.distancetarget = 30  --默认值
        TheCamera:SetHeadingTarget(45) --默认值
        TheFocalPoint.components.focalpoint:StopFocusSource(inst, "tropical_inroom")
    end
end

-- PlayFootstep函数使用，我需要玩家在室内走路时有声音，但是因为没有地皮，只能覆盖函数，这里使用木板地皮的声音
local function GetCurrentTileTypeBefore(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    if z > InteriorSpawnerUtils.BASE_OFF - 100 then
        return { WORLD_TILES.WOODFLOOR, GetTileInfo(WORLD_TILES.WOODFLOOR) }, true
    end
end

AddPlayerPostInit(function(inst)
    inst.mynetvarCameraMode = net_tinybyte(inst.GUID, "BakuStuffNetStuff", "DirtyEventCameraStuff")
    inst.mynetvarCameraMode:set(0)

    inst._isopening = net_bool(inst.GUID, "IsOpening")

    if not TheNet:IsDedicated() then
        inst:ListenForEvent("DirtyEventCameraStuff", OnDirtyEventCameraStuff)
    end


    inst:AddComponent("shopper")

    inst:AddComponent("infestable")

    if TUNING.tropical.only_shipwrecked then
        inst:AddComponent("mapwrapper")
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

    Utils.FnDecorator(inst, "GetCurrentTileType", GetCurrentTileTypeBefore)

    if not TheWorld.ismastersim then return end

    inst:AddComponent("tropical_noequipactivator")
end)
