local InteriorSpawnerUtils = require("interiorspawnerutils")

local assets = {
    Asset("ANIM", "anim/pisohamlet.zip")
}

local prefabs = {
    "interior_center",
    "collapse_small"
}

local function OnBuilt(inst)
    local oldFloor = GetClosestInstWithTag("interior_floor", inst, InteriorSpawnerUtils.RADIUS)
    if oldFloor then
        local x, y, z = oldFloor.Transform:GetWorldPosition()
        inst.Transform:SetPosition(x, y, z)
        SpawnPrefab("collapse_small").Transform:SetPosition(x, y, z)
        oldFloor:Remove()
    end
end

local function common(anim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("pisohamlet")
    inst.AnimState:SetBuild("pisohamlet")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(5)
    inst.AnimState:PlayAnimation(anim)

    inst:AddTag("NOCLICK")
    inst:AddTag("NOBLOCK")
    inst:AddTag("shadecanopy") --附近不会有月亮雨石头掉下来
    inst:AddTag("interior_floor")

    -- 小地图图标和地板走路声音，以后如果有需求再写，需要客机找到地板
    -- inst.minimap = ""
    -- inst.groundsound = ""

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("tropical_saveanim")

    inst:ListenForEvent("onbuilt", OnBuilt)

    return inst
end

local function MakeFloor(name, anim)
    local function fn() return common(anim) end
    return Prefab(name, fn, assets, prefabs)
end

return MakeFloor("interior_floor_marble", "shop_floor_marble"),
    MakeFloor("interior_floor_marble", "shop_floor_marble"),
    MakeFloor("interior_floor_check", "shop_floor_checker"),
    MakeFloor("interior_floor_check2", "shop_floor_checkered"),
    MakeFloor("interior_floor_plaid_tile", "floor_cityhall"),
    MakeFloor("interior_floor_sheet_metal", "shop_floor_sheetmetal"),
    MakeFloor("interior_floor_wood", "noise_woodfloor"),
    MakeFloor("interior_floor_gardenstone", "floor_gardenstone"),
    MakeFloor("interior_floor_geometrictiles", "floor_geometrictiles"),
    MakeFloor("interior_floor_shag_carpet", "floor_shag_carpet"),
    MakeFloor("interior_floor_transitional", "floor_transitional"),
    MakeFloor("interior_floor_woodpanels", "floor_woodpanels"),
    MakeFloor("interior_floor_herringbone", "shop_floor_herringbone"),
    MakeFloor("interior_floor_hexagon", "shop_floor_hexagon"),
    MakeFloor("interior_floor_hoof_curvy", "shop_floor_hoof_curvy"),
    MakeFloor("interior_floor_octagon", "shop_floor_octagon"),
    MakeFloor("interior_floor_woodpaneling2", "shop_floor_woodpaneling2"),
    MakeFloor("interior_floor_antcave", "antcave_floor"),
    MakeFloor("interior_floor_marble_royal", "floor_marble_royal"),
    MakeFloor("interior_floor_ground_ruins_slab", "ground_ruins_slab"),
    MakeFloor("interior_floor_ground_ruins_slab_blue", "ground_ruins_slab_blue"),
    MakeFloor("interior_floor_batcave", "batcave_floor")
