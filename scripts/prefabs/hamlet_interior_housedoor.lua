local InteriorSpawnerUtils = require("interiorspawnerutils")

local assets = {
    Asset("ANIM", "anim/acorn.zip"),
    Asset("ANIM", "anim/pig_shop_doormats.zip"),  --出口地毯
    Asset("ANIM", "anim/player_house_doors.zip"), --小屋房间门
}

local function OnActivate(inst, doer)
    if doer:HasTag("player") then
        if doer.components.talker ~= nil then
            doer.components.talker:ShutUp()
        end

        --Sounds are triggered in player's stategraph
    elseif inst.SoundEmitter ~= nil then
        inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
    end
end

local function StartTravelSound(inst, doer)
    inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
end

local function OnHaunt(inst, haunter)
    inst.components.teleporter:Activate(haunter)
end

local function OnHouseSave(inst, data)
    data.side = inst.side
    data.initData = inst.initData
    data.hamlet_houseexit = inst:HasTag("hamlet_houseexit") or nil
end

local function OnHouseLoad(inst, data)
    if data == nil then return end

    inst.side = data.side
    if data.initData then
        InteriorSpawnerUtils.InitHouseInteriorPrefab(inst, data.initData)
        inst.initData = data.initData
    end
    if data.hamlet_houseexit then
        inst:AddTag("hamlet_houseexit") --没有单机版的小地图，目前通过鼠标悬停时的“进入”和“离开”来判断出口
    end
end

----------------------------------------------------------------------------------------------------

local function AbleToAcceptTest(inst, item)
    if inst:HasTag("teleporter")
        or (item.prefab == "construction_permit" and not inst.components.teleporter.targetTeleporter) then
        return true
    end
    return false, "UN_CONSTRUCTION_PERMIT"
end

-- x是上下偏移，往下增大，z是左右偏移，往右增大
local addprops = {
    { name = "wallinteriorplayerhouse",      x_offset = -2.8, },
    { name = "deco_roomglow" },
    { name = "deco_antiquities_cornerbeam",  x_offset = -5,   z_offset = -15 / 2, },
    { name = "deco_antiquities_cornerbeam",  x_offset = -5,   z_offset = 15 / 2,        animdata = { flip = true } },
    { name = "deco_antiquities_cornerbeam2", x_offset = 4.7,  z_offset = -15 / 2 - 0.3, },
    { name = "deco_antiquities_cornerbeam2", x_offset = 4.7,  z_offset = 15 / 2 + 0.3,  animdata = { flip = true } },
    { name = "swinging_light_rope_1",        x_offset = -2,   y_offset = 1,             addtags = { "playercrafted" } },
    { name = "playerhouse_city_floor",       x_offset = -2.4 },
}

local function onaccept(inst, giver, item)
    if item.prefab == "construction_permit" and not inst.components.teleporter.targetTeleporter then
        if InteriorSpawnerUtils.SpawnNearHouseInterior(inst, addprops) then --应该没可能失败
            item:Remove()
        end
    else
        inst.components.teleporter:Activate(item)
    end
end

local function common(bank, build, anim)
    local inst = InteriorSpawnerUtils.MakeBaseDoor(bank, build, anim, true)

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.trader:SetAbleToAcceptTest(AbleToAcceptTest)
    inst.components.trader.onaccept = onaccept

    inst.components.teleporter.onActivate = OnActivate

    inst:ListenForEvent("starttravelsound", StartTravelSound) -- triggered by player stategraph

    inst.components.hauntable:SetOnHauntFn(OnHaunt)

    return inst
end

local function house_city_exit_door_fn()
    local inst = common("pig_shop_doormats", "pig_shop_doormats", "idle_old")
    inst:AddTag("hamlet_houseexit")
    return inst
end

local function OnBuilt(inst)
    inst.side = InteriorSpawnerUtils.TestWallOrnamentPos(inst, false, 7.5, 5, 7.5, 5.5)
    local anim
    if inst.side == 1 then
        anim = "_close_east"
    elseif inst.side == 2 then
        anim = "_close_north"
    elseif inst.side == 3 then
        anim = "_close_west"
    elseif inst.side == 4 then
        anim = "_close_south"
    end
    inst.AnimState:PlayAnimation(inst.playAnim .. anim)
    inst.initData = { animdata = { anim = inst.playAnim .. anim } }
end

local function onhammered(inst, worker)
    local pos = inst:GetPosition()
    SpawnPrefab("collapse_big").Transform:SetPosition(pos:Get())
    InteriorSpawnerUtils.OnHouseDestroy(inst, worker)
    inst:Remove()
end

-- teleporter会紫东阁保存传送目的地的门，但是还需要entitytracker来记录房间的中心位置
local function MakeHouseDoor(name)
    local function fn()
        local inst = common("player_house_doors", "player_house_doors")

        if not TheWorld.ismastersim then
            return inst
        end

        inst.side = nil      --门所在墙边
        inst.playAnim = name --为了兼容，不能通过.prefab选择动画了，得单独存储

        inst:AddComponent("lootdropper")

        inst:AddComponent("entitytracker")

        -- 出口不能敲毁，入口可敲，出口不能敲
        inst:DoTaskInTime(0, function()
            if not inst:HasTag("hamlet_houseexit") then
                inst:AddComponent("workable")
                inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
                inst.components.workable:SetWorkLeft(4)
                inst.components.workable:SetOnFinishCallback(onhammered)
            end
        end)

        inst:ListenForEvent("onbuilt", OnBuilt)

        inst.OnSave = OnHouseSave
        inst.OnLoad = OnHouseLoad

        return inst
    end

    return Prefab(name, fn, assets)
end

----------------------------------------------------------------------------------------------------

local function PlacerOnUpdateTransform(inst)
    local side, minDis = InteriorSpawnerUtils.TestWallOrnamentPos(inst, true, 7.5, 5, 7.5, 5.5)
    local anim
    if side and minDis < 4 then
        if side == 1 then
            anim = "_close_east"
        elseif side == 2 then
            anim = "_close_north"
        elseif side == 3 then
            anim = "_close_west"
        elseif side == 4 then
            anim = "_close_south"
        end
        inst.accept_placement = true
    else
        inst.accept_placement = false
    end

    if anim and anim ~= inst.lastAnim then
        inst.AnimState:PlayAnimation(inst.animName .. anim)
    end
    inst.lastAnim = anim

    if inst.accept_placement then
        -- 我还需要检测旁边是否有门
        local x, y, z = inst.Transform:GetWorldPosition()
        if #TheSim:FindEntities(x, 0, z, 4, { "hamlet_door" }) > 0 then
            inst.accept_placement = false
        end
    end
end

local function placer_override_testfn(inst)
    local can_build, mouse_blocked = true, false
    if inst.components.placer.testfn ~= nil then
        can_build, mouse_blocked = inst.components.placer.testfn(inst:GetPosition(), inst:GetRotation())
    end
    can_build = inst.accept_placement

    return can_build, mouse_blocked
end

local function PostInitPlacer(inst, name)
    inst.lastAnim = nil
    inst.animName = name

    inst.components.placer.onupdatetransform = PlacerOnUpdateTransform
    inst.components.placer.override_build_point_fn = inst.GetPosition
    inst.components.placer.override_testfn = placer_override_testfn
    inst.accept_placement = false
end

local function MakeHouseDoorPlacer(name, build, bank)
    return MakePlacer(name .. "_placer", bank, build, name .. "_open_north", nil, nil,
        nil, nil, nil, nil, function(inst) PostInitPlacer(inst, name) end)
end

return
-- 出口门
-- 不同门之间主要是动画、位置、旋转角度不同，这里合并成一个预制件，其他的做成可设置的属性，这样灵活度更高
-- 动画：idle_old(默认)、idle_giftshop、idle_antiquities、idle_florist、idle_flag、idle_deli、idle_general、idle_hoofspa、idle_produce、idle_basic、idle_tinker
    Prefab("house_city_exit_door", house_city_exit_door_fn, assets),

    -- 室内门
    MakeHouseDoor("wood_door"),
    MakeHouseDoor("stone_door"),
    MakeHouseDoor("organic_door"),
    MakeHouseDoor("iron_door"),
    MakeHouseDoor("pillar_door"),
    MakeHouseDoor("curtain_door"),
    MakeHouseDoor("round_door"),
    MakeHouseDoor("plate_door"),
    MakeHouseDoorPlacer("wood_door", "player_house_doors", "player_house_doors"),
    MakeHouseDoorPlacer("stone_door", "player_house_doors", "player_house_doors"),
    MakeHouseDoorPlacer("organic_door", "player_house_doors", "player_house_doors"),
    MakeHouseDoorPlacer("iron_door", "player_house_doors", "player_house_doors"),
    MakeHouseDoorPlacer("pillar_door", "player_house_doors", "player_house_doors"),
    MakeHouseDoorPlacer("curtain_door", "player_house_doors", "player_house_doors"),
    MakeHouseDoorPlacer("round_door", "player_house_doors", "player_house_doors"),
    MakeHouseDoorPlacer("plate_door", "player_house_doors", "player_house_doors")
