local InteriorSpawnerUtils = require("interiorspawnerutils")

local assets = {
    Asset("ANIM", "anim/pisohamlet.zip")
}

local prefabs = {
    "interior_center",
    "collapse_small"
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

local function OnBuilt(inst)
    local oldFloor = GetClosestInstWithTag("interior_floor", inst, InteriorSpawnerUtils.RADIUS)
    if oldFloor then
        local x, y, z = oldFloor.Transform:GetWorldPosition()
        inst.Transform:SetPosition(x, y, z)
        SpawnPrefab("collapse_small").Transform:SetPosition(x, y, z)
        oldFloor:Remove()
    end
end

local function OnSave(inst, data)
    data.initData = data.initData
end

local function OnLoad(inst, data)
    if not data then return end

    if data.initData then
        inst.initData = data.initData
        InteriorSpawnerUtils.InitHouseInteriorPrefab(inst, data.initData)
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
    inst.AnimState:SetScale(4.5, 4.5)
    inst.AnimState:PlayAnimation(anim)

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

    inst:ListenForEvent("onbuilt", OnBuilt)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

local function MakeFloor(name, anim)
    local function fn() return common(anim) end
    return Prefab(name, fn, assets, prefabs)
end

return MakeFloor("playerhouse_city_floor", "noise_woodfloor"),
    MakeFloor("interior_floor_marble", "shop_floor_marble"),
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
    MakeFloor("interior_floor_marble_royal_small", "floor_marble_royal_small"),
    MakeFloor("interior_floor_ground_ruins_slab", "ground_ruins_slab"),
    MakeFloor("interior_floor_ground_ruins_slab_blue", "ground_ruins_slab_blue"),
    MakeFloor("interior_floor_batcave", "batcave_floor")
