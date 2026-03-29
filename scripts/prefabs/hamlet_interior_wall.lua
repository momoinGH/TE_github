local RoomUtils = require("tropical_utils/room_utils")

local assets = {
    Asset("ANIM", "anim/wallhamletcity1.zip"),
    Asset("ANIM", "anim/wallhamletcity2.zip"),
    Asset("ANIM", "anim/wallhamletcity3.zip"),
    Asset("ANIM", "anim/wallhamletant.zip"),
    Asset("ANIM", "anim/wallhamletpig.zip"),
}

local function OnBuilt(inst)
    local oldWall = GetClosestInstWithTag("interior_wall", inst, RoomUtils.RADIUS)
    if oldWall then
        local x, y, z = oldWall.Transform:GetWorldPosition()
        inst.Transform:SetPosition(x, y, z)
        SpawnPrefab("collapse_small").Transform:SetPosition(x, y, z)
        oldWall:Remove()
    end
end

local function MakeWall(name, bank, build, anim, img_size)
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

        inst:AddTag("NOCLICK")
        inst:AddTag("NOBLOCK")
        inst:AddTag("interior_wall")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        --墙壁的缩放是在room_utils.lua里根据房间大小统一设置的，但是动画文件这里有的图片大小不一致，这里增加个基础缩放系数
        img_size = img_size or { 1170, 672 } --这个作为图片基础大小
        inst.basic_scale = { img_size[1] / 1170, img_size[2] / 672 }

        inst:AddComponent("tro_saveanim")

        inst:ListenForEvent("onbuilt", OnBuilt)

        return inst
    end
    return Prefab(name, fn, assets)
end

return
    MakeWall("interior_wall_wood", "wallhamletcity", "wallhamletcity1", "shop_wall_woodwall"),
    MakeWall("interior_wall_checkered", "wallhamletcity", "wallhamletcity1", "shop_wall_checkered_metal"),
    MakeWall("interior_wall_sunflower", "wallhamletcity", "wallhamletcity1", "shop_wall_sunflower"),
    MakeWall("interior_wall_circles", "wallhamletcity", "wallhamletcity1", "shop_wall_circles"),
    MakeWall("interior_wall_marble", "wallhamletcity", "wallhamletcity1", "shop_wall_marble"),

    MakeWall("interior_wall_floral", "wallhamletcity", "wallhamletcity2", "shop_wall_floraltrim2"),
    MakeWall("interior_wall_harlequin", "wallhamletcity", "wallhamletcity2", "harlequin_panel"),
    MakeWall("interior_wall_mayorsoffice", "wallhamletcity", "wallhamletcity2", "wall_mayorsoffice_whispy"),
    MakeWall("interior_wall_bricks", "wallhamletcity", "wallhamletcity2", "shop_wall_bricks"),
    MakeWall("interior_wall_moroc", "wallhamletcity", "wallhamletcity2", "shop_wall_moroc"),

    MakeWall("interior_wall_peagawk", "wallhamletcity", "wallhamletcity3", "wall_peagawk"),
    MakeWall("interior_wall_plain_ds", "wallhamletcity", "wallhamletcity3", "wall_plain_DS"),
    MakeWall("interior_wall_plain_rog", "wallhamletcity", "wallhamletcity3", "wall_plain_RoG"),
    MakeWall("interior_wall_rope", "wallhamletcity", "wallhamletcity3", "wall_rope"),
    MakeWall("interior_wall_fullwall_moulding", "wallhamletcity", "wallhamletcity3", "shop_wall_fullwall_moulding"),
    MakeWall("interior_wall_upholstered", "wallhamletcity", "wallhamletcity3", "shop_wall_upholstered"),

    MakeWall("interior_wall_antcave_wall_rock", "wallhamletant", "wallhamletant", "antcave_wall_rock", { 1366, 682 }),
    MakeWall("interior_wall_batcave_wall_rock", "wallhamletant", "wallhamletant", "batcave_wall_rock", { 1366, 682 }),

    MakeWall("interior_wall_pig_ruins", "wallhamletpig", "wallhamletpig", "pig_ruins_panel", { 1366, 648 }),
    MakeWall("interior_wall_pig_ruins_blue", "wallhamletpig", "wallhamletpig", "pig_ruins_panel_blue", { 1366, 648 }),
    MakeWall("interior_wall_wall_royal_high", "wallhamletpig", "wallhamletpig", "wall_royal_high", { 1366, 696 })
