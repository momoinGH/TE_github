local InteriorSpawnerUtils = require("interiorspawnerutils")

local assets = {
    Asset("ANIM", "anim/wallhamletcity1.zip"),
    Asset("ANIM", "anim/wallhamletcity2.zip"),
    Asset("ANIM", "anim/wallhamletcity3.zip"),
    Asset("ANIM", "anim/wallhamletant.zip"),
}

local function OnBuilt(inst)
    local oldWall = GetClosestInstWithTag("interior_wall", inst, InteriorSpawnerUtils.RADIUS)
    if oldWall then
        local x, y, z = oldWall.Transform:GetWorldPosition()
        inst.Transform:SetPosition(x, y, z)
        SpawnPrefab("collapse_small").Transform:SetPosition(x, y, z)
        oldWall:Remove()
    end
end

local function common(bank, build, anim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddAnimState()

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation(anim, true)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)

    inst:AddTag("NOCLICK")
    inst:AddTag("NOBLOCK")
    inst:AddTag("interior_wall")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("tropical_saveanim")

    inst:ListenForEvent("onbuilt", OnBuilt)

    return inst
end

local function MakeWall(name, bank, build, anim)
    local fn = function() return common(bank, build, anim) end
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
    MakeWall("interior_wall_antcave_wall_rock", "wallhamletant", "wallhamletant", "antcave_wall_rock"),
    MakeWall("interior_wall_batcave_wall_rock", "wallhamletant", "wallhamletant", "batcave_wall_rock"),
    MakeWall("interior_wall_pig_ruins", "wallhamletpig", "wallhamletpig", "pig_ruins_panel"),
    MakeWall("interior_wall_pig_ruins_blue", "wallhamletpig", "wallhamletpig", "pig_ruins_panel_blue")

--有些墙没有
-- levels/textures/interiors/wall_royal_high.tex"
