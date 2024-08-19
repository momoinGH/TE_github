local InteriorSpawnerUtils = require("interiorspawnerutils")

local assets =
{
    Asset("ANIM", "anim/pig_house_sale.zip"),
    Asset("ANIM", "anim/player_small_house1.zip"),
    Asset("ANIM", "anim/player_large_house1.zip"),
    Asset("ANIM", "anim/player_large_house1_manor_build.zip"),
    Asset("ANIM", "anim/player_large_house1_villa_build.zip"),
    Asset("ANIM", "anim/player_small_house1_cottage_build.zip"),
    Asset("ANIM", "anim/player_small_house1_tudor_build.zip"),
    Asset("ANIM", "anim/player_small_house1_gothic_build.zip"),
    Asset("ANIM", "anim/player_small_house1_brick_build.zip"),
    Asset("ANIM", "anim/player_small_house1_turret_build.zip"),
}

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle")
    end
end

-- 如果屋里有玩家则房子不可燃，可以通过递归查询来检查是否有玩家在里面
local function OnIgniteFn(inst)
    if InteriorSpawnerUtils.InterioHasPlayer(inst) then
        inst:DoTaskInTime(0, function()
            if inst.components.burnable then
                inst.components.burnable:Extinguish()
            end
        end)
    end
end

local function AddCraftTag(inst)
    inst:AddTag("playercrafted")
end

local room = {
    addprops = {
        { name = "city_exit_old_door", x_offset = 4.7, key = "exit", },
        { name = "interior_wall_wood" },
        { name = "interior_floor_wood" },
        { name = "deco_roomglow" },
        { name = "shelves_cinderblocks", x_offset = -4.5, z_offset = -15 / 3.5 + 0.7, init = AddCraftTag },
        { name = "deco_antiquities_wallfish", x_offset = -5, z_offset = 3.9, init = AddCraftTag },
        { name = "deco_antiquities_cornerbeam", x_offset = -5, z_offset = -15 / 2, },
        { name = "deco_antiquities_cornerbeam", x_offset = -5, z_offset = 15 / 2, scale = { -1, 1 } },
        { name = "deco_antiquities_cornerbeam2", x_offset = 4.7, z_offset = -15 / 2 - 0.3, },
        { name = "deco_antiquities_cornerbeam2", x_offset = 4.7, z_offset = 15 / 2 + 0.3, scale = { -1, 1 } },
        { name = "swinging_light_rope_1", x_offset = -2, y_offset = 1, init = AddCraftTag },
        { name = "charcoal", x_offset = -3, z_offset = -2 },
        { name = "charcoal", x_offset = 2, z_offset = 3 },

        -- { name = "window_round_curtains_nails_backwall",  z_offset = 15 / 2, init = AddCraftTag, children = { "window_round_light" } },
        { name = "window_round", z_offset = 15 / 2, scale = { -1, 1 }, init = AddCraftTag },
        { name = "wallrenovation", x_offset = -2.5, z_offset = -5 },
        { name = "wallrenovation", x_offset = -2.5 },
        { name = "wallrenovation", x_offset = -2.5, z_offset = 5 },
        { name = "wallrenovation", x_offset = 2.5, z_offset = -5 },
        { name = "wallrenovation", x_offset = 2.5 },
        { name = "wallrenovation", x_offset = 2.5, z_offset = 5 },
    }
}

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle")
    inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")

    local doors, _, center = InteriorSpawnerUtils.CreateRoom(room)
    inst.components.teleporter:Target(doors.exit)
    doors.exit.components.teleporter:Target(inst)
    center:AddTag("playercrafted")
end



local function OnSave(inst, data)
    if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end

    data.build = inst.build
    data.bank = inst.bank
    data.name = inst.name
    data.houseminimap = inst.houseminimap
end

local function OnLoad(inst, data)
    if not data then return end

    if data.burnt then
        inst.components.burnable.onburnt(inst)
    end

    if data.build then
        inst.build = data.build
        inst.AnimState:SetBuild(data.build)
    end
    if data.bank then
        inst.AnimState:SetBank(data.bank)
        inst.bank = data.bank
    end
    if data.name then
        inst.name = data.name
        inst.name = STRINGS.NAMES[string.upper(data.name)]
    end
    if data.minimapicon then
        inst.minimapicon = data.minimapicon
        inst.MiniMapEntity:SetIcon(data.minimapicon)
    end
end

local function OnActivateByOther(inst, source, doer)
    if doer ~= nil and doer.Physics ~= nil then
        doer.Physics:CollidesWith(COLLISION.WORLD)
    end
end

local function OnActivate(inst, doer)
    if doer:HasTag("player") then
        --Sounds are triggered in player's stategraph
    elseif inst.SoundEmitter ~= nil then
        inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
    end
end

local function ShouldAcceptItem(inst, item)
    return item:HasTag("decoradordecasa")
end

local function OnGetItemFromPlayer(inst, giver, item)
    inst.bank = item.housebank
    inst.build = item.housebuild
    inst.minimapicon = item.minimapicon
    inst.MiniMapEntity:SetIcon(item.minimapicon)
    inst.name = STRINGS.NAMES[string.upper(item.housename)]
    inst.AnimState:SetBuild(inst.build)
    inst.AnimState:SetBank(inst.bank)

    local fx = SpawnPrefab("explode_reskin")
    fx.Transform:SetScale(2, 2, 2)
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function onhammered(inst, worker)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end

    local pos = inst:GetPosition()
    SpawnPrefab("collapse_big").Transform:SetPosition(pos:Get())
    InteriorSpawnerUtils.OnHouseDestroy(inst, worker)
    inst:Remove()
end

local function fn()
    local inst = InteriorSpawnerUtils.MakeBaseDoor("pig_house_sale", "pig_house_sale", "idle", true, false, "pig_house_sale.png")

    inst.entity:AddLight()

    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(1)
    inst.Light:Enable(false)
    inst.Light:SetColour(180 / 255, 195 / 255, 50 / 255)

    MakeObstaclePhysics(inst, 1.25)

    inst.AnimState:Hide("boards")

    inst:AddTag("structure")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(8)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    MakeMediumBurnable(inst, nil, nil, true)
    inst.components.burnable:SetOnIgniteFn(OnIgniteFn)

    -- 移除后可以修复，就是用锤子锤后可以再用锤子修回来
    -- inst:AddComponent("fixable")

    MakeSnowCovered(inst, .01)
    MakeLargePropagator(inst)

    -- 控制玩家是否可以进房，只有买了之后才能进
    -- inst:AddComponent("door")

    inst.components.teleporter.onActivate = OnActivate
    inst.components.teleporter.onActivateByOther = OnActivateByOther

    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

return Prefab("playerhouse_city", fn, assets),
    MakePlacer("playerhouse_city_placer", "pig_house_sale", "pig_house_sale", "idle")
