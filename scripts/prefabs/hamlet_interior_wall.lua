local RoomUtils = require("tro_utils/room_utils")

local assets = {
    Asset("ANIM", "anim/wallhamletcity1.zip"),
    Asset("ANIM", "anim/wallhamletcity2.zip"),
    Asset("ANIM", "anim/wallhamletcity3.zip"),
    Asset("ANIM", "anim/wallhamletant.zip"),
    Asset("ANIM", "anim/wallhamletpig.zip"),
}

local function OnBuilt(inst)
    -- 删除之前的
    local old_wall = GetClosestInstWithTag("interior_wall", inst, RoomUtils.RADIUS)
    if not old_wall then
        TroErrorHandle("错误，没有找到房间内墙壁对象" .. tostring(inst), true)
        inst:DoTaskInTime(0, inst.Remove)
        return
    end

    local x, y, z = old_wall.Transform:GetWorldPosition()
    inst.Transform:SetPosition(x, y, z)
    local old_data = old_wall.components.tro_saveanim
    inst.components.tro_saveanim:Init(nil, nil, nil, old_data.scale, nil, nil, old_data.rotation)
    ReplacePrefab(old_wall, "collapse_small")
end

local function OnInteriorSpawn(inst)
    local room = inst:TroGetRoomCenter()
    if room then
        local x, y, z = room.Transform:GetWorldPosition()
        inst.Transform:SetPosition(x + inst.x_offset, 0, z)
    else
        TroErrorHandle(string.trofmt("{}墙壁没有找到房间中心点对象", inst))
    end
end

local function MakeWall(name, bank, build, anim, scale, x_offset)
    local fn = function()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddNetwork()
        inst.entity:AddAnimState()

        inst.AnimState:SetBank(bank)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation(anim, true)
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        inst.AnimState:SetSortOrder(-5)
        inst.AnimState:SetScale(scale[1], scale[2])

        inst:AddTag("NOCLICK")
        inst:AddTag("NOBLOCK")
        inst:AddTag("interior_wall")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.x_offset = x_offset

        inst:AddComponent("tro_saveanim") --还是允许外部重新设置缩放的

        inst:ListenForEvent("onbuilt", OnBuilt)
        inst:ListenForEvent("oninteriorspawn", OnInteriorSpawn)

        return inst
    end
    return Prefab(name, fn, assets)
end

-- 每个预制件有自己对应的大小，无法直接用于其他大小的房间，因为图片本身大小不一样，无法统一的设置缩放系数
return
-- tiny
    MakeWall("interior_wall_wood", "wallhamletcity", "wallhamletcity1", "shop_wall_woodwall", { 2.9, 2.9 }, -2.8),
    MakeWall("interior_wall_checkered", "wallhamletcity", "wallhamletcity1", "shop_wall_checkered_metal", { 2.9, 2.9 }, -2.8),
    MakeWall("interior_wall_sunflower", "wallhamletcity", "wallhamletcity1", "shop_wall_sunflower", { 2.9, 2.9 }, -2.8),
    MakeWall("interior_wall_circles", "wallhamletcity", "wallhamletcity1", "shop_wall_circles", { 2.9, 2.9 }, -2.8),
    MakeWall("interior_wall_marble", "wallhamletcity", "wallhamletcity1", "shop_wall_marble", { 2.9, 2.9 }, -2.8),

    MakeWall("interior_wall_floral", "wallhamletcity", "wallhamletcity2", "shop_wall_floraltrim2", { 2.9, 2.9 }, -2.8),
    MakeWall("interior_wall_harlequin", "wallhamletcity", "wallhamletcity2", "harlequin_panel", { 2.9, 2.9 }, -2.8),
    MakeWall("interior_wall_mayorsoffice", "wallhamletcity", "wallhamletcity2", "wall_mayorsoffice_whispy", { 2.9, 2.9 }, -2.8),
    MakeWall("interior_wall_bricks", "wallhamletcity", "wallhamletcity2", "shop_wall_bricks", { 2.9, 2.9 }, -2.8),
    MakeWall("interior_wall_moroc", "wallhamletcity", "wallhamletcity2", "shop_wall_moroc", { 2.9, 2.9 }, -2.8),

    MakeWall("interior_wall_peagawk", "wallhamletcity", "wallhamletcity3", "wall_peagawk", { 2.9, 2.9 }, -2.8),
    MakeWall("interior_wall_plain_ds", "wallhamletcity", "wallhamletcity3", "wall_plain_DS", { 2.9, 2.9 }, -2.8),
    MakeWall("interior_wall_plain_rog", "wallhamletcity", "wallhamletcity3", "wall_plain_RoG", { 2.9, 2.9 }, -2.8),
    MakeWall("interior_wall_rope", "wallhamletcity", "wallhamletcity3", "wall_rope", { 2.9, 2.9 }, -2.8), --
    MakeWall("interior_wall_fullwall_moulding", "wallhamletcity", "wallhamletcity3", "shop_wall_fullwall_moulding", { 2.9, 2.9 }, -2.8),
    MakeWall("interior_wall_upholstered", "wallhamletcity", "wallhamletcity3", "shop_wall_upholstered", { 2.9, 2.9 }, -2.8),

    ----------------------------------------------------------------------------------------------------
    -- small
    MakeWall("interior_wall_wall_royal_high", "wallhamletpig", "wallhamletpig", "wall_royal_high", { 3.5, 3.5 }, -3.5),
    ----------------------------------------------------------------------------------------------------
    -- medium
    MakeWall("interior_wall_batcave_wall_rock", "wallhamletant", "wallhamletant", "batcave_wall_rock", { 4.2, 4 }, -3.5),

    MakeWall("interior_wall_pig_ruins", "wallhamletpig", "wallhamletpig", "pig_ruins_panel", { 3.7, 3.6 }, -1.6),
    MakeWall("interior_wall_pig_ruins_blue", "wallhamletpig", "wallhamletpig", "pig_ruins_panel_blue", { 3.7, 3.6 }, -1.6),
    ----------------------------------------------------------------------------------------------------
    -- large
    MakeWall("interior_wall_antcave_wall_rock", "wallhamletant", "wallhamletant", "antcave_wall_rock", { 4.6, 4.6 }, -4.5)
