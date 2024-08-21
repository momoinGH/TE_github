local InteriorSpawnerUtils = require("interiorspawnerutils")

local assets =
{
    Asset("ANIM", "anim/wildbea_house.zip"),
}

local prefabs =
{
    "trinket_giftshop_1",
    "trinket_giftshop_3",
    "trinket_giftshop_4",
}



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

local room = {
    width = 16,
    depth = 10,
    addprops = {
        { name = "city_exit_general_door", x_offset = 4.7, z_offset = 0.5, key = "exit" },
        { name = "interior_wall_wood", x_offset = -2.8 },
        { name = "interior_floor_check", x_offset = -2.5 },
        { name = "pigman_eskimo_shopkeep", x_offset = -1, z_offset = 4, startstate = "desk" },
        { name = "deco_roomglow" },
        { name = "shelves_wood", x_offset = -4.5, z_offset = -4 },
        { name = "shelves_wood2", x_offset = -4.5, z_offset = 4 },
        { name = "rug_hedgehog", x_offset = -2, z_offset = 4 },
        { name = "deco_wood_cornerbeam", x_offset = -5, z_offset = 7.5 },
        { name = "deco_wood_cornerbeam", x_offset = -5, z_offset = -7.5 },
        { name = "deco_wood_cornerbeam", x_offset = 5, z_offset = 7.5 },
        { name = "deco_wood_cornerbeam", x_offset = 5, z_offset = -7.5 },
        { name = "deco_general_hangingpans", z_offset = -5.5 },
        { name = "deco_general_hangingscale", x_offset = -2, z_offset = 6 },
        { name = "swinging_light_chandalier_candles", x_offset = -1.3 },
        { name = "deco_general_trough", x_offset = 1, z_offset = -7.5 },
        { name = "deco_general_trough", x_offset = 3, z_offset = -7.5 },
        { name = "window_round", x_offset = -2, z_offset = -7.5 },
        { name = "window_round", x_offset = 1.5, z_offset = 7.5, scale = { -1, 1 } },
        { name = "shop_buyer", x_offset = -1.8, z = -4.1, anim = "idle_barrel_dome", saleitem = { "swbait", "oinc", 5 } },
        { name = "shop_buyer", x_offset = -1.8, z_offset = -1.9, anim = "idle_barrel_dome", shoptype = "pig_shop_fishing" },
        { name = "shop_buyer", x_offset = 1.1, z_offset = -4.4, anim = "idle_barrel_dome", shoptype = "pig_shop_fishing" },
        { name = "shop_buyer", x_offset = 1.3, z_offset = -2.2, anim = "idle_barrel_dome", shoptype = "pig_shop_fishing" },
        { name = "shop_buyer", x_offset = 1.1, anim = "idle_barrel_dome", shoptype = "pig_shop_fishing" },
        { name = "shop_buyer", x_offset = 1.5, z_offset = 5, anim = "idle_barrel_dome", shoptype = "pig_shop_fishing" },
        { name = "shop_buyer", x_offset = 1.5, z_offset = 2.5, anim = "idle_barrel_dome", shoptype = "pig_shop_fishing" },
        { name = "shop_buyer", x_offset = 4, z_offset = 5, anim = "idle_barrel_dome", shoptype = "pig_shop_fishing" },
        { name = "shop_buyer", x_offset = 4, z_offset = 2.5, anim = "idle_barrel_dome", saleitem = { "boat_item", "oinc", 5 } },
        { name = "shop_buyer", x_offset = 4, z_offset = -2.2, anim = "idle_barrel_dome", saleitem = { "oar", "oinc", 1 } },
        { name = "shop_buyer", x_offset = 4, z_offset = -4.4, anim = "idle_barrel_dome", saleitem = { "oceanfishingrod", "oinc", 5 } },
    }
}

local function CreateInterior(inst)
    InteriorSpawnerUtils.CreateSimpleInterior(inst, room)
end

local function fn()
    local inst = InteriorSpawnerUtils.MakeBaseDoor("merm_sw_house", "wildbea_house", "idle_fish1", true, false, "pig_fishingshop.png", "dontstarve/common/teleportworm/swallow")

    inst.entity:AddLight()
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(1)
    inst.Light:Enable(false)
    inst.Light:SetColour(180 / 255, 195 / 255, 50 / 255)

    MakeObstaclePhysics(inst, 1.0)

    inst:AddTag("structure")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")

    inst.components.inspectable.getstatus = getstatus

    MakeSnowCovered(inst, .01)

    inst:DoTaskInTime(0, CreateInterior)

    return inst
end

return Prefab("pig_palace2", fn, assets, prefabs)
