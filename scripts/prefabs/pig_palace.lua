local InteriorSpawnerUtils = require("interiorspawnerutils")

local assets =
{
    Asset("ANIM", "anim/palace.zip"),
    Asset("ANIM", "anim/pig_shop_doormats.zip"),
    Asset("ANIM", "anim/palace_door.zip"),
    Asset("ANIM", "anim/interior_wall_decals_palace.zip"),
    Asset("MINIMAP_IMAGE", "pig_palace"),
    Asset("MINIMAP_IMAGE", "pig_shop_florist"),
    Asset("SOUND", "sound/pig.fsb"),
}

local prefabs =
{
    "trinket_giftshop_1",
    "trinket_giftshop_3",
    "trinket_giftshop_4",
    "city_hammer",
}

local function LightsOn(inst)
    if not inst:HasTag("burnt") then
        inst.Light:Enable(true)
        inst.AnimState:PlayAnimation("lit", true)
        inst.SoundEmitter:PlaySound("dontstarve/pig/pighut_lighton")
        inst.lightson = true
    end
end

local function LightsOff(inst)
    if not inst:HasTag("burnt") then
        inst.Light:Enable(false)
        inst.AnimState:PlayAnimation("idle", true)
        inst.SoundEmitter:PlaySound("dontstarve/pig/pighut_lightoff")
        inst.lightson = false
    end
end

local function onfar(inst)
    if not inst:HasTag("burnt") then
        if inst.components.spawner and inst.components.spawner:IsOccupied() then
            LightsOn(inst)
        end
    end
end

local function getstatus(inst)
    if inst:HasTag("burnt") then
        return "BURNT"
    elseif inst.components.spawner and inst.components.spawner:IsOccupied() then
        if inst.lightson then
            return "FULL"
        else
            return "LIGHTSOUT"
        end
    end
end

local function onnear(inst)
    if not inst:HasTag("burnt") then
        if inst.components.spawner and inst.components.spawner:IsOccupied() then
            LightsOff(inst)
        end
    end
end

local function onwere(child)
    if child.parent and not child.parent:HasTag("burnt") then
        child.parent.SoundEmitter:KillSound("pigsound")
        child.parent.SoundEmitter:PlaySound("dontstarve/pig/werepig_in_hut", "pigsound")
    end
end

local function onnormal(child)
    if child.parent and not child.parent:HasTag("burnt") then
        child.parent.SoundEmitter:KillSound("pigsound")
        child.parent.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/pig_in_house_LP", "pigsound")
    end
end

local function onoccupied(inst, child)
    if not inst:HasTag("burnt") then
        inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/pig_in_house_LP", "pigsound")
        inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")

        if inst.doortask then
            inst.doortask:Cancel()
            inst.doortask = nil
        end

        -- inst.doortask = inst:DoTaskInTime(1, function() if not inst.components.playerprox:IsPlayerClose() then LightsOn(inst) end end)
        inst.doortask = inst:DoTaskInTime(1, function() LightsOn(inst) end)

        if child then
            inst:ListenForEvent("transformwere", onwere, child)
            inst:ListenForEvent("transformnormal", onnormal, child)
        end
    end
end

local function onvacate(inst, child)
    if not inst:HasTag("burnt") then
        if inst.doortask then
            inst.doortask:Cancel()
            inst.doortask = nil
        end

        inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
        inst.SoundEmitter:KillSound("pigsound")

        if child then
            inst:RemoveEventCallback("transformwere", onwere, child)
            inst:RemoveEventCallback("transformnormal", onnormal, child)

            if child.components.werebeast then
                child.components.werebeast:ResetTriggers()
            end

            if child.components.health then
                child.components.health:SetPercent(1)
            end
        end
    end
end


local function onhammered(inst, worker)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end

    if inst.doortask then
        inst.doortask:Cancel()
        inst.doortask = nil
    end

    if inst.components.spawner then inst.components.spawner:ReleaseChild() end

    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:Remove()
end

local function ongusthammerfn(inst)
    onhammered(inst, nil)
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle")
    end
end

local function OnIsDay(inst, isday)
    if isday and not inst:HasTag("burnt") and inst.components.spawner:IsOccupied() then
        LightsOff(inst)

        if inst.doortask then
            inst.doortask:Cancel()
        end
        inst.doortask = inst:DoTaskInTime(1 + math.random() * 2, function() inst.components.spawner:ReleaseChild() end)
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle")
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local rooms = { {
    width    = 26,
    depth    = 18,
    addprops = {
        { name = "interior_floor_marble_royal", x_offset = -5.5 },
        { name = "interior_wall_rope", x_offset = -5, scale = { 5.2, 5.2 } },
        { name = "interior_palace_south_door", x_offset = 9, key = "exit" },
        { name = "deco_roomglow_large", },
        { name = "interior_palace_west_door", key = "door1a", target_door = "door1b", z_offset = -26 / 2, scale = { -1, 1 }, },
        { name = "deco_palace_beam_room_tall_corner", x_offset = -18 / 2, z_offset = -26 / 2, scale = { -1, 1 } },
        { name = "deco_palace_beam_room_tall_corner", x_offset = -18 / 2, z_offset = 26 / 2, },
        { name = "deco_palace_beam_room_tall_corner_front", x_offset = 18 / 2, z_offset = -26 / 2, scale = { -1, 1 } },
        { name = "deco_palace_beam_room_tall_corner_front", x_offset = 18 / 2, z_offset = 26 / 2, },
        { name = "deco_palace_beam_room_tall", x_offset = -18 / 2, z_offset = -26 / 6 - 1, scale = { -1, 1 } },
        { name = "deco_palace_beam_room_tall", x_offset = -18 / 2, z_offset = 26 / 6 + 1, },
        { name = "deco_palace_beam_room_tall_lights", x_offset = -18 / 6, z_offset = -26 / 6 - 1, scale = { -1, 1 } },
        { name = "deco_palace_beam_room_tall_lights", x_offset = -18 / 6, z_offset = 26 / 6 + 1, },
        { name = "deco_palace_beam_room_tall_lights", x_offset = 18 / 6, z_offset = -26 / 6 - 1, scale = { -1, 1 } },
        { name = "deco_palace_beam_room_tall_lights", x_offset = 18 / 6, z_offset = 26 / 6 + 1, },
        { name = "deco_palace_banner_big_front", x_offset = -18 / 6, z_offset = -26 / 3 - 0.5, },
        { name = "deco_palace_banner_big_front", x_offset = -18 / 6, z_offset = 26 / 3 + 0.5, },
        { name = "deco_palace_banner_big_front", x_offset = 18 / 6, z_offset = -26 / 3 - 0.5, },
        { name = "deco_palace_banner_big_front", x_offset = 18 / 6, z_offset = 26 / 3 + 0.5, },
        { name = "deco_palace_banner_small_front", x_offset = -18 / 2, z_offset = -26 / 18 - 3, },
        { name = "deco_palace_banner_small_front", x_offset = -18 / 2, z_offset = 26 / 18 + 3, },
        { name = "deco_palace_banner_small_front", x_offset = -18 / 2, z_offset = -26 / 18 - 26 / 3, },
        { name = "deco_palace_banner_small_front", x_offset = -18 / 2, z_offset = 26 / 18 - 26 / 3, },
        { name = "deco_palace_banner_small_sidewall", x_offset = -18 / 14, z_offset = -26 / 2, scale = { -1, 1 } },
        { name = "deco_palace_banner_small_sidewall", x_offset = -18 / 14, z_offset = 26 / 2, },
        { name = "deco_palace_banner_small_sidewall", x_offset = 18 / 14, z_offset = -26 / 2, scale = { -1, 1 } },
        { name = "deco_palace_banner_small_sidewall", x_offset = 18 / 14, z_offset = 26 / 2, },
        { name = "deco_palace_banner_small_sidewall", x_offset = -18 / 14 * 3, z_offset = -26 / 2, scale = { -1, 1 } },
        { name = "deco_palace_banner_small_sidewall", x_offset = -18 / 14 * 3, z_offset = 26 / 2, },
        { name = "deco_palace_banner_small_sidewall", x_offset = 18 / 14 * 3, z_offset = -26 / 2, scale = { -1, 1 } },
        { name = "deco_palace_banner_small_sidewall", x_offset = 18 / 14 * 3, z_offset = 26 / 2, },
        { name = "deco_palace_banner_small_sidewall", x_offset = -18 / 14 * 5, z_offset = -26 / 2, scale = { -1, 1 } },
        { name = "deco_palace_banner_small_sidewall", x_offset = -18 / 14 * 5, z_offset = 26 / 2, },
        { name = "deco_palace_banner_small_sidewall", x_offset = 18 / 14 * 5, z_offset = -26 / 2, scale = { -1, 1 } },
        { name = "deco_palace_banner_small_sidewall", x_offset = 18 / 14 * 5, z_offset = 26 / 2, },
        { name = "deco_palace_beam_room_tall_corner", x_offset = -18 / 6, z_offset = -26 / 2, scale = { -1, 1 } },
        { name = "deco_palace_beam_room_tall_corner", x_offset = 18 / 6, z_offset = -26 / 2, scale = { -1, 1 } },
        { name = "deco_palace_beam_room_tall_corner", x_offset = -18 / 6, z_offset = 26 / 2, },
        { name = "deco_palace_beam_room_tall_corner", x_offset = 18 / 6, z_offset = 26 / 2, },
        { name = "deco_palace_plant", x_offset = -18 / 2 + 0.3, z_offset = -26 / 6.5, scale = { -1, 1 } },
        { name = "deco_palace_plant", x_offset = -18 / 2 + 0.3, z_offset = 26 / 6.5, },
        { name = "wall_mirror", x_offset = 18 / 3, z_offset = -26 / 2, rotation = -90 },
        { name = "wall_mirror", x_offset = -18 / 3, z_offset = -26 / 2, rotation = -90 },
        { name = "deco_cityhall_picture1", x_offset = 18 / 3, z_offset = 26 / 2, scale = { -1, 1 } },
        { name = "deco_cityhall_picture2", x_offset = -0.5, z_offset = 26 / 2, scale = { -1, 1 } },
        { name = "deco_cityhall_picture1", x_offset = -18 / 3, z_offset = 26 / 2, scale = { -1, 1 } },
        { name = "pigman_queen", x_offset = -3, },
        { name = "deco_palace_throne", x_offset = -6, },
        -- floor corner pieces
        { name = "rug_palace_corners", x_offset = -18 / 2, z_offset = 26 / 2, },
        { name = "rug_palace_corners", x_offset = 18 / 2, z_offset = 26 / 2, rotation = 180 },
        { name = "rug_palace_corners", x_offset = 18 / 2, z_offset = -26 / 2, rotation = 270 },
        { name = "rug_palace_corners", x_offset = -18 / 2, z_offset = -26 / 2, rotation = 0 }, --被墙壁挡住看不见了
        -- front wall floor lights
        { name = "swinglightobject", x_offset = 18 / 2, z_offset = -26 / 3, rotation = -90 },
        { name = "swinglightobject", x_offset = 18 / 2, z_offset = 26 / 3, rotation = -90 },
        -- back wall lights and floor lights
        { name = "window_round_light_backwall", x_offset = -18 / 2, z_offset = -26 / 3, rotation = -90 },
        { name = "window_palace", x_offset = -18 / 2, z_offset = -26 / 3, },
        { name = "window_round_light_backwall", x_offset = -18 / 2, z_offset = 26 / 3, rotation = -90 },
        { name = "window_palace", x_offset = -18 / 2, z_offset = 26 / 3, },
        { name = "window_round_light_backwall", x_offset = -18 / 2, rotation = -90 },
        { name = "window_palace_stainglass", x_offset = -18 / 2, },
        -- aisle rug
        { name = "rug_palace_runner", x_offset = -3.38, },
        { name = "rug_palace_runner", x_offset = -3.38 * 2, },
        { name = "rug_palace_runner", },
        { name = "rug_palace_runner", x_offset = 3.38, },
        { name = "rug_palace_runner", x_offset = 3.38 * 2, },
    }
}, {
    width    = 18,
    depth    = 12,
    addprops = {
        { name = "interior_floor_marble_royal", x_offset = -3.5, scale = { 2.9, 2.9 } },
        { name = "interior_wall_rope", x_offset = -3.5, scale = { 3.6, 3.6 } },
        { name = "deco_roomglow", },
        { name = "interior_palace_east_door", z_offset = 18 / 2, key = "door1b", target_door = "door1a" },
        { name = "interior_palace_west_door", z_offset = -18 / 2, key = "door2a", target_door = "door2b" },
        { name = "rug_palace_corners", x_offset = -12 / 2, z_offset = 18 / 2, rotation = 90 },
        { name = "rug_palace_corners", x_offset = 12 / 2, z_offset = 18 / 2, rotation = 180 },
        { name = "rug_palace_corners", x_offset = 12 / 2, z_offset = -18 / 2, rotation = 270 },
        { name = "rug_palace_corners", x_offset = -12 / 2, z_offset = -18 / 2 },
        { name = "window_round_light_backwall", x_offset = -12 / 2, z_offset = -18 / 3, rotation = -90 },
        { name = "window_palace", x_offset = -12 / 2, z_offset = -18 / 3, },
        { name = "window_round_light_backwall", x_offset = -18 / 2, z_offset = 26 / 3, rotation = -90 },
        { name = "window_palace", x_offset = -12 / 2, z_offset = 18 / 3, },
        { name = "deco_palace_beam_room_tall_corner", x_offset = -12 / 2, z_offset = -18 / 2, scale = { -1, 1 } },
        { name = "deco_palace_beam_room_tall_corner", x_offset = -12 / 2, z_offset = 18 / 2, },
        { name = "deco_palace_beam_room_tall_corner_front", x_offset = 12 / 2, z_offset = -18 / 2, scale = { -1, 1 } },
        { name = "deco_palace_beam_room_tall_corner_front", x_offset = 12 / 2, z_offset = 18 / 2, },
        { name = "deco_palace_beam_room_tall", x_offset = -12 / 6, z_offset = -18 / 6, scale = { -1, 1 } },
        { name = "deco_palace_beam_room_tall", x_offset = -12 / 6, z_offset = 18 / 6, },
        { name = "deco_palace_beam_room_tall", x_offset = 12 / 6, z_offset = -18 / 6, scale = { -1, 1 } },
        { name = "deco_palace_beam_room_tall", x_offset = 12 / 6, z_offset = 18 / 6, },
        { name = "shelves_queen_display_1", x_offset = -12 / 4, z_offset = -18 / 3, shelfitems = { { 1, "key_to_city" } } },
        { name = "shelves_queen_display_2", shelfitems = { { 1, "trinket_giftshop_4" } } },
        { name = "shelves_queen_display_3", x_offset = -12 / 4, z_offset = 18 / 3, scale = { -1, 1 }, shelfitems = { { 1, "city_hammer" } } },
        { name = "deco_palace_banner_small_sidewall", x_offset = -12 / 14 * 3, z_offset = -18 / 2, scale = { -1, 1 } },
        { name = "deco_palace_banner_small_sidewall", x_offset = -12 / 14 * 3, z_offset = 18 / 2, },
        { name = "deco_palace_banner_small_sidewall", x_offset = 12 / 14 * 3, z_offset = -18 / 2, scale = { -1, 1 } },
        { name = "deco_palace_banner_small_sidewall", x_offset = 12 / 14 * 3, z_offset = 18 / 2, },
        { name = "shelves_marble", x_offset = -12 / 2, shelfitems = { { 5, "trinket_20" }, { 6, "trinket_14" }, { 3, "trinket_4" }, { 4, "trinket_2" } } },
    }
}, {
    width    = 15,
    depth    = 10,
    addprops = {
        { name = "interior_floor_marble_royal", x_offset = -3, scale = { 2.5, 2.5 } },
        { name = "interior_wall_rope", x_offset = -3.5, scale = { 3.1, 3.1 } },
        { name = "deco_roomglow", },
        { name = "city_exit_giftshop_door", x_offset = 10 / 2, key = "exit2" },
        { name = "interior_palace_east_door", key = "door2b", target_door = "door2a", z_offset = 15 / 2, },
        { name = "rug_palace_corners", x_offset = -10 / 2, z_offset = 15 / 2, },
        { name = "rug_palace_corners", x_offset = 10 / 2, z_offset = 15 / 2, rotation = 180 },
        { name = "rug_palace_corners", x_offset = 10 / 2, z_offset = -15 / 2, rotation = 270 },
        { name = "rug_palace_corners", x_offset = -10 / 2, z_offset = -15 / 2, rotation = 0 },
        { name = "deco_palace_beam_room_short_corner_lights", x_offset = -10 / 2, z_offset = -15 / 2, scale = { -1, 1 } },
        { name = "deco_palace_beam_room_short_corner_lights", x_offset = -10 / 2, z_offset = 15 / 2, },
        { name = "deco_palace_beam_room_short_corner_front_lights", x_offset = 10 / 2, z_offset = -15 / 2, scale = { -1, 1 } },
        { name = "deco_palace_beam_room_short_corner_front_lights", x_offset = 10 / 2, z_offset = 15 / 2, },
        { name = "deco_cityhall_picture2", x_offset = -10 / 5, z_offset = -15 / 2 },
        { name = "deco_cityhall_picture1", x_offset = 10 / 5, z_offset = -15 / 2 },
        { name = "shelves_wood", x_offset = -10 / 2, z_offset = -15 / 5, shelfitems = { { 1, "trinket_giftshop_3" }, { 2, "trinket_giftshop_3" }, { 3, "trinket_giftshop_3" }, { 5, "trinket_giftshop_3" }, { 6, "trinket_giftshop_3" } } },
        { name = "shelves_wood", x_offset = -10 / 2, z_offset = 15 / 5, shelfitems = { { 1, "trinket_giftshop_3" }, { 3, "trinket_giftshop_3" }, { 4, "trinket_giftshop_3" }, { 5, "trinket_giftshop_3" }, { 6, "trinket_giftshop_3" } } },
        { name = "swinging_light_floral_bloomer", },
        { name = "shelves_displaycase", x_offset = -10 / 5, z_offset = -15 / 3, scale = { -1, 1 }, shelfitems = { { 1, "trinket_giftshop_1" }, { 2, "trinket_giftshop_1" }, { 3, "trinket_giftshop_1" } } },
        { name = "shelves_displaycase", x_offset = 10 / 5, z_offset = 15 / 3, shelfitems = { { 1, "trinket_giftshop_1" }, { 3, "trinket_giftshop_1" } } },
        { name = "shelves_displaycase", x_offset = 10 / 5, z_offset = -15 / 3, scale = { -1, 1 }, shelfitems = { { 2, "trinket_giftshop_1" }, { 3, "trinket_giftshop_1" } } },
        { name = "shelves_displaycase", x_offset = -10 / 5, z_offset = 15 / 3, shelfitems = { { 1, "trinket_giftshop_1" }, { 2, "trinket_giftshop_1" } } },
    }
} }

local function creatInterior(inst)
    if inst.components.teleporter:GetTarget() then return end

    local doors = InteriorSpawnerUtils.CreateRooms(rooms)
    inst.components.teleporter:Target(doors.exit)
    doors.exit.components.teleporter:Target(inst)
    doors.exit2.components.teleporter:Target(inst) --两个出口
end

local function OnIgnite(inst)
    if inst.components.spawner then
        inst.components.spawner:ReleaseChild()
    end
end

local function fn()
    local inst = InteriorSpawnerUtils.MakeBaseDoor("palace", "palace", "idle", true, false, "pig_palace.png")

    inst.entity:AddLight()
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(1)
    inst.Light:Enable(false)
    inst.Light:SetColour(180 / 255, 195 / 255, 50 / 255)

    MakeObstaclePhysics(inst, 1.25)

    inst:AddTag("structure")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("spawner")
    inst.components.spawner:Configure("pigman_banker", TUNING.TOTAL_DAY_TIME * 4)
    inst.components.spawner.onoccupied = onoccupied
    inst.components.spawner.onvacate = onvacate

    inst.components.inspectable.getstatus = getstatus

    MakeSnowCovered(inst, .01)

    inst.OnSave = onsave
    inst.OnLoad = onload

    inst:DoTaskInTime(0, creatInterior)

    inst:ListenForEvent("burntup", inst.Remove)
    inst:ListenForEvent("onignite", OnIgnite)
    inst:ListenForEvent("onbuilt", onbuilt)
    inst:WatchWorldState("isday", OnIsDay)
    OnIsDay(inst, TheWorld.state.isday)

    return inst
end

return Prefab("pig_palace", fn, assets, prefabs)
