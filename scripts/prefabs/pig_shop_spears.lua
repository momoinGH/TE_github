local RoomUtils = require("tropical_utils/room_utils")
local MakeDoor = require("prefabs/tro_interior_door_defs").MakeDoor

local assets =
{
    Asset("ANIM", "anim/wildbea_house.zip"),
}

local function PlayTravelSound(inst, doer)
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/store/door_close")
end

local function StartSpawning(inst)
    if not inst:HasTag("burnt") and
        inst.components.childspawner ~= nil then
        inst.components.childspawner:StartSpawning()
    end
end

local function StopSpawning(inst)
    if not inst:HasTag("burnt") and inst.components.childspawner ~= nil then
        inst.components.childspawner:StopSpawning()
    end
end

local function OnSpawned(inst, child)
    if not inst:HasTag("burnt") then
        inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
        if TheWorld.state.isday and
            inst.components.childspawner ~= nil and
            inst.components.childspawner:CountChildrenOutside() >= 1 and
            child.components.combat.target == nil then
            StopSpawning(inst)
        end
    end
end

local function OnGoHome(inst, child)
    if not inst:HasTag("burnt") then
        inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
        if inst.components.childspawner ~= nil and
            inst.components.childspawner:CountChildrenOutside() < 1 then
            StartSpawning(inst)
        end
    end
end

local width = TUNING.ROOM_TINY_WIDTH
local depth = TUNING.ROOM_TINY_DEPTH

local room = {
    width = width,
    depth = depth,
    addprops = {
        { name = "city_exit_old_door",             x_offset = 4.7,  z_offset = 0.5,           key = "exit" },
        { name = "interior_wall_upholstered",      x_offset = -2.8 },
        { name = "interior_floor_herringbone" },
        { name = "shelves_midcentury",             x_offset = -4.5, z_offset = 4 },
        { name = "deco_roomglow" },
        { name = "pigman_eskimo_shopkeep",         x_offset = -3,   startstate = "desk" },
        { name = "shield_axes",                    x_offset = -7.5 },
        { name = "rug_porcupuss",                  z_offset = -2 },
        { name = "rug_fur",                        x_offset = 2,    z_offset = 4 },
        { name = "rug_catcoon",                    x_offset = -2,   z_offset = 4 },
        { name = "deco_weapon_beam1",              x_offset = -5,   z_offset = 7.5,           scale = { -1, 1 } },
        { name = "deco_weapon_beam1",              x_offset = -5,   z_offset = -7.5 },
        { name = "deco_weapon_beam2",              x_offset = 4.7,  z_offset = 7.5,           scale = { -1, 1 } },
        { name = "deco_weapon_beam2",              x_offset = 4.7,  z_offset = -7.5 },
        { name = "window_square_weapons_backwall", x_offset = -7.5, z_offset = -4 },
        { name = "swinging_light_basic_metal",     x_offset = -2,   z_offset = -4.5 },
        { name = "swinging_light_basic_metal",     x_offset = 3,    z_offset = 6.5 },
        { name = "deco_antiquities_beefalo_side",  x_offset = -2,   z_offset = 7.5,           scale = { -1, 1 } },
        { name = "closed_chest",                   x_offset = 4.5,  z_offset = -6 },
        { name = "deco_displaycase",               x_offset = -4,   z = -5.5 },
        { name = "deco_displaycase",               x_offset = -4,   z = -4 },
        { name = "shop_buyer",                     x_offset = 2.5,  z_offset = -2,            anim = "idle_cablespool",    shoptype = "pig_shop_spears" },
        { name = "shop_buyer",                     x_offset = -0.5, z_offset = -2.5,          anim = "idle_cablespool",    shoptype = "pig_shop_spears" },
        { name = "shop_buyer",                     x_offset = 1.5,  z_offset = -5,            anim = "idle_cablespool",    shoptype = "pig_shop_spears" },
        { name = "shop_buyer",                     z_offset = 3.5,  anim = "idle_cablespool", shoptype = "pig_shop_spears" },
        { name = "shop_buyer",                     x_offset = 3.5,  z_offset = 2.5,           anim = "idle_cablespool",    shoptype = "pig_shop_spears" },
        { name = "shop_buyer",                     x_offset = 2.5,  z_offset = 5.5,           anim = "idle_cablespool",    shoptype = "pig_shop_spears" },
    }
}

local function CreateInterior(inst)
    RoomUtils.CreateSimpleInterior(inst, room)
end

return MakeDoor("pig_shop_spears", {
    assets = assets,
    bank = "merm_sw_house",
    build = "wildbea_house",
    anim = "idle_hunt1",
    minimap = "pig_lootshop.png",
    trader = true,
    usesound = "dontstarve/common/pighouse_door"
}, function(inst)
    inst:AddTag("structure")
end, function(inst)
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "boards", "boards", "cutstone", "cutstone" })

    inst:AddComponent("workable")

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "pig_eskimo"
    inst.components.childspawner:SetSpawnedFn(OnSpawned)
    inst.components.childspawner:SetGoHomeFn(OnGoHome)
    inst.components.childspawner:SetRegenPeriod(TUNING.TOTAL_DAY_TIME * 4)
    inst.components.childspawner:SetSpawnPeriod(10)
    inst.components.childspawner:SetMaxChildren(1)

    StartSpawning(inst)
    MakeSnowCovered(inst)

    inst:DoTaskInTime(0, CreateInterior)
end)
