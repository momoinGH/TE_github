local DecoCreator = require "prefabs/deco_util"
local InteriorSpawnerUtils = require("interiorspawnerutils")

local floorAssets =
{
    Asset("ANIM", "anim/pisohamlet.zip"), --地板
}

local prefabs = {
    "wallrenovation"
}

local function ChangeFocal(doer)
    doer.mynetvarCameraMode:set(4)
end

local function OnPlayerFar(inst, doer)
    doer.mynetvarCameraMode:set(0)
end

local function OnPlayerNear(inst, doer)
    if doer.mynetvarCameraMode:value() ~= 0 then --从一个房间跳到另一个房间，有可能出现先靠近再远离的调用顺序，这里延迟一下设置摄像机
        OnPlayerFar(nil, doer)
        doer:DoTaskInTime(0.5, function(doer)
            if GetClosestInstWithTag("interior_center", doer, 30) then ChangeFocal(doer) end
        end)
    else
        ChangeFocal(doer)
    end
end
local function OnSave(inst, data)
    data.initData = inst.initData
end


local function OnLoad(inst, data)
    if data == nil then return end

    if data.initData then
        inst.initData = data.initData
        InteriorSpawnerUtils.InitHouseInteriorPrefab(inst, inst.initData)
    end
end

local function floorFn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("pisohamlet")
    inst.AnimState:SetBuild("pisohamlet")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(5)
    inst.AnimState:SetScale(4.5, 4.5, 4.5)
    inst.AnimState:PlayAnimation("noise_woodfloor")

    inst:AddTag("NOCLICK")
    inst:AddTag("NOBLOCK")
    inst:AddTag("shadecanopy") --附近不会有月亮雨石头掉下来
    inst:AddTag("interior_floor")

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

    inst:DoTaskInTime(0, function()
        local x, y, z = inst.Transform:GetWorldPosition()
        x = x + 2.8
        --原型机组件并不提供范围的变量，只能修改builder的方法查找半径，我不喜欢覆盖的做法
        SpawnPrefab("wallrenovation").Transform:SetPosition(x - 2.5, y, z - 5)
        SpawnPrefab("wallrenovation").Transform:SetPosition(x - 2.5, y, z)
        SpawnPrefab("wallrenovation").Transform:SetPosition(x - 2.5, y, z + 5)
        SpawnPrefab("wallrenovation").Transform:SetPosition(x + 2.5, y, z - 5)
        SpawnPrefab("wallrenovation").Transform:SetPosition(x + 2.5, y, z)
        SpawnPrefab("wallrenovation").Transform:SetPosition(x + 2.5, y, z + 5)
    end)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

----------------------------------------------------------------------------------------------------
local wallAssets = {
    Asset("ANIM", "anim/wallhamletcity1.zip"),
    Asset("ANIM", "anim/wallhamletcity2.zip"),
    Asset("ANIM", "anim/wallhamletcity3.zip"),
}

local function wall_common()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddAnimState()

    inst.AnimState:SetBank("wallhamletcity")
    inst.AnimState:SetBuild("wallhamletcity1")
    inst.AnimState:PlayAnimation("shop_wall_woodwall", true)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:SetScale(2.8, 2.8, 2.8)

    inst:AddTag("NOCLICK")
    inst:AddTag("NOBLOCK")
    inst:AddTag("interior_wall")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

local FLOOR_TAG = { "interior_floor" }
local WALL_TAG = { "interior_wall" }

return
-- 地板
    Prefab("playerhouse_city_floor", floorFn, floorAssets, prefabs),
    DecoCreator:CreateDecoProxy("interior_floor_marble", nil, nil, "shop_floor_marble", FLOOR_TAG),
    DecoCreator:CreateDecoProxy("interior_floor_marble", nil, nil, "shop_floor_marble", FLOOR_TAG),
    DecoCreator:CreateDecoProxy("interior_floor_check", nil, nil, "shop_floor_checker", FLOOR_TAG),
    DecoCreator:CreateDecoProxy("interior_floor_check2", nil, nil, "shop_floor_checkered", FLOOR_TAG),
    DecoCreator:CreateDecoProxy("interior_floor_plaid_tile", nil, nil, "floor_cityhall", FLOOR_TAG),
    DecoCreator:CreateDecoProxy("interior_floor_sheet_metal", nil, nil, "shop_floor_sheetmetal", FLOOR_TAG),
    DecoCreator:CreateDecoProxy("interior_floor_wood", nil, nil, "noise_woodfloor", FLOOR_TAG),
    DecoCreator:CreateDecoProxy("interior_floor_gardenstone", nil, nil, "floor_gardenstone", FLOOR_TAG),
    DecoCreator:CreateDecoProxy("interior_floor_geometrictiles", nil, nil, "floor_geometrictiles", FLOOR_TAG),
    DecoCreator:CreateDecoProxy("interior_floor_shag_carpet", nil, nil, "floor_shag_carpet", FLOOR_TAG),
    DecoCreator:CreateDecoProxy("interior_floor_transitional", nil, nil, "floor_transitional", FLOOR_TAG),
    DecoCreator:CreateDecoProxy("interior_floor_woodpanels", nil, nil, "floor_woodpanels", FLOOR_TAG),
    DecoCreator:CreateDecoProxy("interior_floor_herringbone", nil, nil, "shop_floor_herringbone", FLOOR_TAG),
    DecoCreator:CreateDecoProxy("interior_floor_hexagon", nil, nil, "shop_floor_hexagon", FLOOR_TAG),
    DecoCreator:CreateDecoProxy("interior_floor_hoof_curvy", nil, nil, "shop_floor_hoof_curvy", FLOOR_TAG),
    DecoCreator:CreateDecoProxy("interior_floor_octagon", nil, nil, "shop_floor_octagon", FLOOR_TAG),
    DecoCreator:CreateDecoProxy("interior_floor_woodpaneling2", nil, nil, "shop_floor_woodpaneling2", FLOOR_TAG),
    DecoCreator:CreateDecoProxy("interior_floor_antcave", nil, nil, "antcave_floor", FLOOR_TAG),
    DecoCreator:CreateDecoProxy("interior_floor_marble_royal", nil, nil, "floor_marble_royal", FLOOR_TAG),
    DecoCreator:CreateDecoProxy("interior_floor_marble_royal_small", nil, nil, "floor_marble_royal_small", FLOOR_TAG),
    DecoCreator:CreateDecoProxy("interior_floor_ground_ruins_slab", nil, nil, "ground_ruins_slab", FLOOR_TAG),
    DecoCreator:CreateDecoProxy("interior_floor_ground_ruins_slab_blue", nil, nil, "ground_ruins_slab_blue", FLOOR_TAG),
    DecoCreator:CreateDecoProxy("interior_floor_batcave", nil, nil, "batcave_floor", FLOOR_TAG),


    -- 虽然我很想自定义一张，但是想要不突兀就需要一张长宽比特别大的壁纸，超宽屏壁纸也只够中间那个面，可能得花钱让人画
    -- 墙壁
    Prefab("wallinteriorplayerhouse", wall_common, wallAssets, prefabs),
    DecoCreator:CreateDecoProxy("interior_wall_wood", "wallhamletcity1", nil, "shop_wall_woodwall", WALL_TAG),
    DecoCreator:CreateDecoProxy("interior_wall_checkered", "wallhamletcity1", nil, "shop_wall_checkered_metal", WALL_TAG),
    DecoCreator:CreateDecoProxy("interior_wall_sunflower", "wallhamletcity1", nil, "shop_wall_sunflower", WALL_TAG),
    DecoCreator:CreateDecoProxy("interior_wall_circles", "wallhamletcity1", nil, "shop_wall_circles", WALL_TAG),
    DecoCreator:CreateDecoProxy("interior_wall_marble", "wallhamletcity1", nil, "shop_wall_marble", WALL_TAG),
    DecoCreator:CreateDecoProxy("interior_wall_floral", "wallhamletcity2", nil, "shop_wall_floraltrim2", WALL_TAG),
    DecoCreator:CreateDecoProxy("interior_wall_harlequin", "wallhamletcity2", nil, "harlequin_panel", WALL_TAG),
    DecoCreator:CreateDecoProxy("interior_wall_mayorsoffice", "wallhamletcity2", nil, "wall_mayorsoffice_whispy",
        WALL_TAG),
    DecoCreator:CreateDecoProxy("interior_wall_bricks", "wallhamletcity2", nil, "shop_wall_bricks", WALL_TAG),
    DecoCreator:CreateDecoProxy("interior_wall_moroc", "wallhamletcity2", nil, "shop_wall_moroc", WALL_TAG),
    DecoCreator:CreateDecoProxy("interior_wall_peagawk", "wallhamletcity3", nil, "wall_peagawk", WALL_TAG),
    DecoCreator:CreateDecoProxy("interior_wall_plain_ds", "wallhamletcity3", nil, "wall_plain_DS", WALL_TAG),
    DecoCreator:CreateDecoProxy("interior_wall_plain_rog", "wallhamletcity3", nil, "wall_plain_RoG", WALL_TAG),
    DecoCreator:CreateDecoProxy("interior_wall_rope", "wallhamletcity3", nil, "wall_rope", WALL_TAG),
    DecoCreator:CreateDecoProxy("interior_wall_fullwall_moulding", "wallhamletcity3", nil, "shop_wall_fullwall_moulding",
        WALL_TAG),
    DecoCreator:CreateDecoProxy("interior_wall_upholstered", "wallhamletcity3", nil, "shop_wall_upholstered", WALL_TAG)
