local InteriorSpawnerUtils = require("interiorspawnerutils")

local assets =
{
    Asset("ANIM", "anim/pig_shop.zip"),
    Asset("ANIM", "anim/pig_shop_florist.zip"),
    Asset("ANIM", "anim/pig_shop_hoofspa.zip"),
    Asset("ANIM", "anim/pig_shop_produce.zip"),
    Asset("ANIM", "anim/pig_shop_general.zip"),
    Asset("ANIM", "anim/pig_shop_deli.zip"),
    Asset("ANIM", "anim/pig_shop_antiquities.zip"),

    Asset("ANIM", "anim/flag_post_duster_build.zip"),
    Asset("ANIM", "anim/flag_post_wilson_build.zip"),

    Asset("ANIM", "anim/pig_cityhall.zip"),
    Asset("ANIM", "anim/pig_shop_arcane.zip"),
    Asset("ANIM", "anim/pig_shop_weapons.zip"),
    Asset("ANIM", "anim/pig_shop_accademia.zip"),
    Asset("ANIM", "anim/pig_shop_millinery.zip"),
    Asset("ANIM", "anim/pig_shop_bank.zip"),
    Asset("ANIM", "anim/pig_shop_tinker.zip"),

    -- Asset("IMAGE", "images/colour_cubes/pigshop_interior_cc.tex"),

    Asset("MINIMAP_IMAGE", "pig_shop_florist"),
    Asset("MINIMAP_IMAGE", "pig_shop_general"),
    Asset("MINIMAP_IMAGE", "pig_shop_hoofspa"),
    Asset("MINIMAP_IMAGE", "pig_shop_produce"),

    Asset("MINIMAP_IMAGE", "pig_shop_deli"),
    Asset("MINIMAP_IMAGE", "pig_shop_antiquities"),
    Asset("MINIMAP_IMAGE", "pig_shop_cityhall"),

    Asset("MINIMAP_IMAGE", "pig_shop_academy"),
    Asset("MINIMAP_IMAGE", "pig_shop_arcane"),
    Asset("MINIMAP_IMAGE", "pig_shop_hatshop"),
    Asset("MINIMAP_IMAGE", "pig_shop_weapons"),
    Asset("MINIMAP_IMAGE", "pig_shop_bank"),
    Asset("MINIMAP_IMAGE", "pig_shop_tinker"),

    Asset("INV_IMAGE", "pig_shop_antiquities"),
    Asset("INV_IMAGE", "pig_shop_arcane"),
    Asset("INV_IMAGE", "pig_shop_deli"),
    Asset("INV_IMAGE", "pig_shop_florist"),
    Asset("INV_IMAGE", "pig_shop_general"),
    Asset("INV_IMAGE", "pig_shop_hoofspa"),
    Asset("INV_IMAGE", "pig_shop_hatshop"),
    Asset("INV_IMAGE", "pig_shop_produce"),
    Asset("INV_IMAGE", "pig_shop_weapons"),
    Asset("INV_IMAGE", "pig_shop_bank"),
    Asset("INV_IMAGE", "pig_shop_tinker"),
    Asset("INV_IMAGE", "pig_shop_cityhall_player"),

    Asset("SOUND", "sound/pig.fsb"),
}

local prefabs =
{
    "pigman_collector",
    "pigman_banker",
    "pigman_beautician",
    "pigman_florist",
    "pigman_erudite",
    "pigman_professor",
    "pigman_hunter",
    "pigman_hatmaker_shopkeep",
    "pigman_mayor",
    "pigman_mechanic",
    "pigman_storeowner",

    "window_round",
    --  "window_sunlight",
    "deco_wallpaper_rip1",
    "deco_wallpaper_rip2",
    "deco_wallpaper_rip_side1",
    "deco_wallpaper_rip_side2",
    "deco_wallpaper_rip_side3",
    "deco_wallpaper_rip_side4",
    "deco_wood_beam",
    "deco_wood_cornerbeam",
    "wall_light1",
    "swinging_light_floral_bloomer",
    "swinging_light_basic_metal",
    "swinging_light_chandalier_candles",
    "swinging_light_rope_1",
    "swinging_light_rope_2",
    "swinging_light_floral_bulb",
    "swinging_light_pendant_cherries",
    "swinging_light_floral_scallop",
    "swinglightobject",
    "deco_roomglow",
    "light_dust_fx",
    "rug_round",
    "rug_oval",
    "rug_square",
    "rug_rectangle",
    "rug_leather",
    "rug_fur",

    "shelves_wood",
    "shelves_marble",
    "shelves_glass",

    "deco_marble_cornerbeam",
    "deco_marble_beam",
    "deco_valence",
    "wall_light_hoofspa",

    "wall_mirror",

    "deco_chaise",
    "deco_lamp_hoofspa",

    "deed",
    "construction_permit",
    "demolition_permit",
    "securitycontract",
}

local SHOPSOUND_ENTER1 = "dontstarve_DLC003/common/objects/store/door_open"
local SHOPSOUND_ENTER2 = "dontstarve_DLC003/common/objects/store/door_entrance"
local SHOPSOUND_EXIT = "dontstarve_DLC003/common/objects/store/door_close"

local spawnprefabs =
{
    "pig_shop_florist",
    "pig_shop_general",
    "pig_shop_hoofspa",
    "pig_shop_produce",
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

local function getstatus(inst)
    if inst:HasTag("burnt") then
        return "BURNT"
    end
end

local function OnBurntUp(inst)
    inst.components.fixable:AddRecinstructionStageData("burnt", inst.fixbank, inst.AnimState:GetBuild(), 1)
    inst:Remove()
end

local function onhammered(inst, worker)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
    if inst.doortask then
        inst.doortask:Cancel()
        inst.doortask = nil
    end
    if not inst.components.fixable then
        inst.components.lootdropper:DropLoot()
    end

    -- SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_" .. inst.breaksoundsufix)
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        if inst.lightson then
            inst.AnimState:PushAnimation("lit")
        else
            inst.AnimState:PushAnimation("idle")
        end
    end
end

local function OnNight(inst, isnight)
    if inst:HasTag("burnt") then return end

    if inst.doortask then
        inst.doortask:Cancel()
        inst.doortask = nil
    end
    if isnight then
        LightsOff(inst)
        if inst.prefab ~= "pig_shop_cityhall_player" then
            inst.components.teleporter:SetEnabled(false)
        end
    else
        inst.doortask = inst:DoTaskInTime(1, LightsOn)

        if inst.prefab ~= "pig_shop_cityhall_player" then
            inst.components.teleporter:SetEnabled(true)
        end
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle")
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/pighouse/wood_1")
end

local function onsave(inst, data)
    if inst:HasTag("burnt") then
        data.burnt = true
    end
end

local function onload(inst, data)
    if not data then return end

    if data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local width = TUNING.ROOM_TINY_WIDTH
local depth = TUNING.ROOM_TINY_DEPTH

local rooms = {
    pig_shop_academy = {
        width = width,
        depth = depth,
        addprops = {
            { name = "interior_wall_circles", scale = { 2.8, 2.8 } },
            { name = "interior_floor_hexagon" },
            { name = "city_exit_giftshop_door", x_offset = 4.5, key = "exit", },
            { name = "deco_roomglow", },
            { name = "pigman_professor_shopkeep", x_offset = -2.3, z_offset = 4, startstate = "desk" },
            { name = "shelves_midcentury", x_offset = -4.5, z_offset = -3.3, shelfitems = { { 1, "trinket_1" }, { 5, "trinket_2" }, { 6, "trinket_3" } }, },

            { name = "deco_accademy_beam", x_offset = -5, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_accademy_beam", x_offset = -5, z_offset = -width / 2 },
            { name = "deco_accademy_cornerbeam", x_offset = 4.7, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_accademy_cornerbeam", x_offset = 4.7, z_offset = -width / 2 },

            { name = "swinging_light_floral_bulb", x_offset = -3, z_offset = -0 },

            { name = "deco_cityhall_picture1", z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_cityhall_picture2", z_offset = -width / 2 },

            { name = "deco_accademy_pig_king_painting", x_offset = -5, z_offset = 3, scale = { -1, 1 } },

            { name = "deco_accademy_barrier_vert", x_offset = 2, z_offset = -5.5 },
            { name = "deco_accademy_vause", x_offset = 2, z_offset = -6.5 },
            { name = "deco_accademy_barrier_vert", x_offset = -2, z_offset = -5.5 },
            { name = "deco_accademy_graniteblock", x_offset = -2, z_offset = -6.5 },

            { name = "deco_accademy_table_books", z_offset = -3 },

            { name = "deco_accademy_potterywheel_urn", x_offset = -3.5, },
            { name = "deco_accademy_barrier", x_offset = -2.5, },

            { name = "shop_buyer", x_offset = 1, z_offset = 0.5, saleitem = { "oinc10", "relic_1", 1 }, },
            { name = "shop_buyer", x_offset = 1.5, z_offset = 3, saleitem = { "oinc10", "relic_2", 1 }, anim = "idle_stoneslab" },
            { name = "shop_buyer", x_offset = 2, z_offset = 5.5, saleitem = { "oinc10", "relic_3", 1 }, anim = "idle_stoneslab" },
        }
    },
    pig_shop_antiquities = {
        width = width,
        depth = depth,
        addprops = {
            { name = "interior_wall_harlequin", scale = { 2.8, 2.8 } },
            { name = "interior_floor_wood" },
            { name = "city_exit_antiquities_door", x_offset = 4.5, key = "exit" },
            { name = "pigman_collector_shopkeep", x_offset = -3, z_offset = 4, startstate = "desk" },
            { name = "deco_roomglow", },
            { name = "shelves_midcentury", x_offset = -4.5, shelfitems = { { 1, "trinket_1" }, { 5, "trinket_2" }, { 6, "trinket_3" } }, },
            { name = "shelves_cinderblocks", x_offset = -4.5, z_offset = -5 },
            { name = "rug_porcupuss", },
            { name = "deco_antiquities_wallfish", x_offset = -5, z_offset = 3.9 },
            { name = "deco_antiquities_cornerbeam", x_offset = -5, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_antiquities_cornerbeam", x_offset = -5, z_offset = -width / 2 },
            { name = "deco_antiquities_cornerbeam2", x_offset = 4.7, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_antiquities_cornerbeam2", x_offset = 4.7, z_offset = -width / 2 },
            { name = "swinging_light_rope_1", x_offset = -3, z_offset = width / 6 },
            { name = "deco_antiquities_screamcatcher", x_offset = -2, z_offset = -6.5 },
            { name = "deco_antiquities_windchime", x_offset = -2, z_offset = 6.5 },
            { name = "deco_antiquities_beefalo_side", z_offset = width / 2, scale = { -1, 1 } },
            { name = "window_round_curtains_nails", z_offset = -width / 2 },
            { name = "window_round_light", z_offset = -width / 2 },
            { name = "shop_buyer", x_offset = -2, z_offset = (width / 2) - 3, anim = "idle_barrel_dome" },
            { name = "shop_buyer", x_offset = 1.7, z_offset = (width / 2) - 2.5, anim = "idle_barrel_dome" },
            { name = "shop_buyer", x_offset = -2, z_offset = 2, anim = "idle_barrel_dome" },
            { name = "shop_buyer", x_offset = 2.9, z_offset = 3, anim = "idle_barrel_dome" },
            { name = "shop_buyer", x_offset = -2, z_offset = (-width / 2) + 3, anim = "idle_barrel_dome" },
            { name = "shop_buyer", x_offset = 1.9, z_offset = (-width / 2) + 2.5, anim = "idle_barrel_dome" },
            { name = "shop_buyer", x_offset = -2, z_offset = -2, anim = "idle_barrel_dome" },
            { name = "shop_buyer", x_offset = 2.9, z_offset = -3, anim = "idle_barrel_dome" },
        }
    },
    pig_shop_hatshop = {
        width = width,
        depth = depth,
        addprops = {
            { name = "interior_wall_floral", scale = { 2.8, 2.8 } },
            { name = "interior_floor_check2" },
            { name = "city_exit_giftshop_door", x_offset = 4.5, key = "exit", },
            { name = "shelves_floating", x_offset = -5, shelfitems = { { 1, "petals" }, { 2, "petals" }, { 3, "petals" }, { 4, "cutgrass" }, { 5, "cutgrass" }, { 6, "petals" } }, },
            { name = "deco_roomglow", },
            { name = "pigman_hatmaker_shopkeep", x_offset = -3.5, z_offset = 5, startstate = "desk" },
            { name = "shelves_pipe", x_offset = -4.5, z_offset = -3.5 },
            { name = "rug_rectangle", rotation = 90 },
            { name = "hat_lamp_side", x_offset = 2, z_offset = -width / 2 },
            { name = "wall_mirror", x_offset = -1, z_offset = -width / 2 },
            { name = "sewingmachine", x_offset = 4, z_offset = 5.5 },
            { name = "hatbox1", x_offset = -2, z_offset = 6.5, },
            { name = "hatbox1", x_offset = 4, z_offset = -6.5 },
            { name = "hatbox2", x_offset = 4.5, z_offset = -5.75 },
            { name = "deco_millinery_cornerbeam2", x_offset = -5, z_offset = -width / 2 },
            { name = "deco_millinery_beam3", x_offset = 4.7, z_offset = -width / 2 },
            { name = "deco_millinery_beam2", x_offset = 4.7, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_millinery_cornerbeam3", x_offset = -5, z_offset = width / 2, scale = { -1, 1 } },
            { name = "swinging_light_rope_1", x_offset = -3, z_offset = width / 6 },
            { name = "window_round_burlap_backwall", x_offset = -width / 2, z_offset = -5 },
            { name = "window_round_light_backwall", x_offset = -width / 2, z_offset = -5 },
            { name = "window_round_burlap_backwall", x_offset = -width / 2, z_offset = 5 },
            { name = "window_round_light_backwall", x_offset = -width / 2, z_offset = 5 },
            { name = "hat_lamp_side", z_offset = width / 2, scale = { -1, 1 } },
            { name = "picture_1", x_offset = -2.5, z_offset = width / 2, scale = { -1, 1 } },
            { name = "picture_2", x_offset = 2.5, z_offset = width / 2, scale = { -1, 1 } },
            { name = "shop_buyer", x_offset = -1, z_offset = -3.5, anim = "idle_hatbox2" },
            { name = "shop_buyer", x_offset = -1, z_offset = -1, anim = "idle_hatbox4" },
            { name = "shop_buyer", x_offset = -1, z_offset = 1.5, anim = "idle_hatbox2" },
            { name = "shop_buyer", x_offset = 1.5, z_offset = -4.5, anim = "idle_hatbox3" },
            { name = "shop_buyer", x_offset = 1.5, z_offset = -2, anim = "idle_hatbox1" },
            { name = "shop_buyer", x_offset = 1.5, z_offset = 0.5, anim = "idle_hatbox1" },
            { name = "shop_buyer", x_offset = 1.5, z_offset = 3, anim = "idle_hatbox3" },
        }
    },
    pig_shop_weapons = {
        width = width,
        depth = depth,
        addprops = {
            { name = "interior_wall_upholstered", scale = { 2.8, 2.8 } },
            { name = "interior_floor_herringbone" },
            { name = "city_exit_basic_door", x_offset = 4.5, key = "exit", },
            { name = "shelves_midcentury", x_offset = -4.5, z_offset = 4, shelfitems = { { 5, "twigs" }, { 6, "twigs" }, { 3, "twigs" }, { 4, "twigs" } }, },
            { name = "deco_roomglow", },
            { name = "pigman_hunter_shopkeep", x_offset = -3, startstate = "desk" },
            { name = "shield_axes", x_offset = -width / 2, },
            { name = "rug_porcupuss", z_offset = -2, rotation = -90 },
            { name = "rug_fur", x_offset = 2, z_offset = 4, rotation = 90 },
            { name = "rug_catcoon", x_offset = -2, z_offset = 4, rotation = 90 },
            { name = "deco_weapon_beam1", x_offset = -5, z_offset = width / 2, rotation = -90, scale = { -1, 1 } },
            { name = "deco_weapon_beam1", x_offset = -5, z_offset = -width / 2, rotation = -90 },
            { name = "deco_weapon_beam2", x_offset = 4.7, z_offset = width / 2, rotation = -90, scale = { -1, 1 } },
            { name = "deco_weapon_beam2", x_offset = 4.7, z_offset = -width / 2, rotation = -90 },
            { name = "window_square_weapons", x_offset = 1, z_offset = -width / 2, rotation = -90 },
            { name = "swinging_light_basic_metal", x_offset = -2, z_offset = -4.5, rotation = -90 },
            { name = "swinging_light_basic_metal", x_offset = -6, z_offset = 3, rotation = -90 },
            { name = "swinging_light_basic_metal", x_offset = 3, z_offset = 6.5, rotation = -90 },
            { name = "deco_antiquities_beefalo_side", x_offset = -2, z_offset = width / 2, rotation = -90, scale = { -1, 1 } },
            { name = "closed_chest", x_offset = 4.5, z_offset = (-width / 2) + 1.5 },
            { name = "deco_displaycase", x_offset = -4, z_offset = -5.5 },
            { name = "deco_displaycase", x_offset = -4, z_offset = -4 },
            { name = "shop_buyer", x_offset = 2.5, z_offset = -2, anim = "idle_cablespool" },
            { name = "shop_buyer", x_offset = -0.5, z_offset = -2.5, anim = "idle_cablespool" },
            { name = "shop_buyer", x_offset = 1.5, z_offset = -5, anim = "idle_cablespool" },
            { name = "shop_buyer", x_offset = -1.5, z_offset = -5.5, anim = "idle_cablespool" },
            { name = "shop_buyer", z_offset = 3.5, anim = "idle_cablespool" },
            { name = "shop_buyer", x_offset = 3.5, z_offset = 2.5, anim = "idle_cablespool" },
            { name = "shop_buyer", x_offset = 2.5, z_offset = 5.5, anim = "idle_cablespool" },
        }
    },
    pig_shop_arcane = {
        width = width,
        depth = depth,
        addprops = {
            { name = "interior_wall_moroc", scale = { 2.8, 2.8 } },
            { name = "interior_floor_octagon" },
            { name = "city_exit_florist_door", x_offset = 4.5, key = "exit", },
            { name = "pigman_erudite_shopkeep", x_offset = -3, z_offset = 4, startstate = "desk" },
            { name = "deco_roomglow", },
            { name = "shelves_glass", x_offset = -4.5, z_offset = -4, rotation = -90, shelfitems = { { 1, "trinket_1" }, { 5, "trinket_2" }, { 6, "trinket_3" } }, },
            { name = "deco_arcane_bookshelf", x_offset = -4.5, },
            { name = "rug_round", },
            { name = "containers", x_offset = width / 2 - 3, z_offset = -width / 2 + 1.5 },
            { name = "deco_accademy_cornerbeam", x_offset = 4.7, z_offset = width / 2, rotation = -90, scale = { -1, 1 } },
            { name = "deco_accademy_cornerbeam", x_offset = 4.7, z_offset = -width / 2, rotation = -90 },
            { name = "deco_accademy_beam", x_offset = -5, z_offset = width / 2, rotation = -90, scale = { -1, 1 } },
            { name = "deco_accademy_beam", x_offset = -5, z_offset = -width / 2, rotation = -90 },
            { name = "swinging_light_rope_1", x_offset = -3, z_offset = width / 6, rotation = -90 },
            { name = "deco_antiquities_screamcatcher", x_offset = -2, z_offset = -6.5, rotation = -90 },
            { name = "deco_antiquities_windchime", x_offset = -2, z_offset = 6.5, rotation = -90 },
            { name = "deco_antiquities_beefalo_side", z_offset = width / 2, rotation = -90, scale = { -1, 1 } },
            { name = "window_round_arcane", z_offset = -width / 2, rotation = -90 },
            { name = "window_round_light", z_offset = -width / 2, rotation = -90 },
            { name = "shop_buyer", x_offset = -0.5, z_offset = 2.5, anim = "idle_marble" },
            { name = "shop_buyer", x_offset = -0.5, z_offset = -2.5, anim = "idle_marblesilk" },
            { name = "shop_buyer", x_offset = 2.5, z_offset = 2.5, anim = "idle_marble" },
            { name = "shop_buyer", x_offset = 2.5, z_offset = -2.5, anim = "idle_marblesilk" },
            { name = "shop_buyer", x_offset = 0.5, z_offset = (width / 2) - 2.5, anim = "idle_marblesilk" },
            { name = "shop_buyer", x_offset = 0.5, z_offset = (-width / 2) + 2.5, anim = "idle_marble" },
        }
    },
    pig_shop_florist = {
        width = width,
        depth = depth,
        addprops = {
            { name = "interior_wall_sunflower", scale = { 2.8, 2.8 } },
            { name = "interior_floor_wood" },
            { name = "city_exit_florist_door", x_offset = 4.5, key = "exit", },
            { name = "pigman_florist_shopkeep", x_offset = -1, z_offset = 4, startstate = "desk" },
            { name = "deco_roomglow", },
            { name = "shelves_hutch", x_offset = -4.5, z_offset = -2.6, shelfitems = { { 3, "seeds" }, { 4, "seeds" }, { 5, "seeds" }, { 6, "seeds" } }, },
            { name = "rug_rectangle", x_offset = -2.3, z_offset = -width / 4 + 1, rotation = 92 },
            { name = "rug_rectangle", x_offset = 1.5, z_offset = -width / 4 + 0.5, rotation = 86 },
            { name = "deco_wallpaper_florist_rip1", x_offset = -5, },
            { name = "deco_florist_latice_front", x_offset = -4.5, z_offset = 3 },
            { name = "deco_florist_latice_side", z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_florist_pillar_front", x_offset = -4.5, z_offset = -width / 2 + 0.8 },
            { name = "deco_florist_pillar_front", x_offset = -4.5, z_offset = width / 2 - 0.8 },
            { name = "deco_florist_pillar_side", x_offset = 4.3, z_offset = -width / 2 },
            { name = "deco_florist_pillar_side", x_offset = 4.3, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_florist_plantholder", x_offset = 3, z_offset = -width / 2 + 0.8 },
            { name = "deco_florist_vines2", x_offset = -4.5, z_offset = -5 },
            { name = "deco_florist_vines3", x_offset = -3, z_offset = -width / 2 },
            { name = "deco_florist_hangingplant1", x_offset = -1, z_offset = -width / 2 + 2.5 },
            { name = "deco_florist_hangingplant2", x_offset = -1, z_offset = width / 2 - 2 },

            { name = "window_round", z_offset = -width / 2 },
            { name = "window_round_light", z_offset = -width / 2 },

            { name = "swinging_light_floral_scallop", x_offset = -2, z_offset = 2 },

            { name = "shop_buyer", x_offset = -2, z_offset = (-width / 2) + 3.5, anim = "idle_cart" },
            { name = "shop_buyer", x_offset = 1.5, z_offset = (-width / 2) + 3, anim = "idle_cart" },
            { name = "shop_buyer", x_offset = -2, z_offset = -1.5, anim = "idle_traystand" },
            { name = "shop_buyer", x_offset = 1.5, z_offset = -2, anim = "idle_traystand" },
            { name = "shop_buyer", x_offset = 1.5, z_offset = 2, anim = "idle_traystand" },
            { name = "shop_buyer", x_offset = 1.5, z_offset = (width / 2) - 3, anim = "idle_wagon" },
        }
    },
    pig_shop_hoofspa = {
        width = width,
        depth = depth,
        addprops = {
            { name = "interior_wall_marble", scale = { 2.8, 2.8 } },
            { name = "interior_floor_check" },
            { name = "city_exit_hoofspa_door", x_offset = 4.5, key = "exit", },
            { name = "pigman_beautician_shopkeep", x_offset = -3, z_offset = 3, startstate = "desk" },
            { name = "deco_roomglow", },
            { name = "shelves_marble", x_offset = -4.5, z_offset = -3, rotation = -90, shelfitems = { { 3, "petals" }, { 4, "petals" }, { 5, "petals" }, { 6, "petals" } }, },
            { name = "deco_marble_cornerbeam", x_offset = -5, z_offset = -width / 2 },
            { name = "deco_marble_cornerbeam", x_offset = -5, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_marble_beam", x_offset = 4.7, z_offset = -width / 2 + 0.3 },
            { name = "deco_marble_beam", x_offset = 4.7, z_offset = width / 2 - 0.3, scale = { -1, 1 } },
            { name = "deco_chaise", x_offset = -1.4, z_offset = -3.5 },
            { name = "deco_lamp_hoofspa", x_offset = -1.9, z_offset = -5.2 },
            { name = "deco_plantholder_marble", x_offset = -4.6, z_offset = (width / 2) - 2 },
            { name = "deco_valence", x_offset = -5.01, z_offset = -width / 2 },
            { name = "deco_valence", x_offset = -5.01, z_offset = width / 2, scale = { -1, 1 } },
            { name = "wall_mirror", x_offset = -1, z_offset = -width / 2 },
            { name = "swinging_light_floral_bulb", x_offset = -2, },
            { name = "shop_buyer", x_offset = 2.3, z_offset = -4.5, anim = "idle_cakestand" },
            { name = "shop_buyer", x_offset = 2.3, z_offset = -2.6, anim = "idle_cakestand" },
            { name = "shop_buyer", x_offset = -0.5, anim = "idle_marble" },
            { name = "shop_buyer", x_offset = -0.5, z_offset = 3, anim = "idle_marble" },
            { name = "shop_buyer", x_offset = 2, z_offset = 4.4, anim = "idle_marblesilk" },
        }
    },
    pig_shop_general = {
        width = width,
        depth = depth,
        addprops = {
            { name = "interior_wall_wood", scale = { 2.8, 2.8 } },
            { name = "interior_floor_check" },
            { name = "city_exit_general_door", x_offset = 4.5, key = "exit", },
            { name = "pigman_banker_shopkeep", x_offset = -1, z_offset = 4, startstate = "desk" },
            { name = "shelves_wood", x_offset = -4.5, z_offset = -4, shelfitems = { { 3, "rocks" }, { 4, "rocks" }, { 5, "rocks" }, { 6, "rocks" } }, },
            { name = "shelves_wood", x_offset = -4.5, z_offset = 4, shelfitems = { { 3, "cutgrass" }, { 4, "cutgrass" }, { 5, "cutgrass" }, { 6, "cutgrass" } }, },
            { name = "rug_hedgehog", x_offset = -0.2, z_offset = 4, rotation = 90 },
            { name = "deco_roomglow", },
            { name = "deco_wood_cornerbeam", x_offset = -5, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_wood_cornerbeam", x_offset = -5, z_offset = -width / 2 },
            { name = "deco_wood_cornerbeam", x_offset = 5, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_wood_cornerbeam", x_offset = 5, z_offset = -width / 2, },
            { name = "deco_general_hangingpans", z_offset = -width / 2 + 2 },
            { name = "deco_general_hangingscale", x_offset = -2, z_offset = 6 },
            { name = "deco_general_trough", x_offset = 1, z_offset = -width / 2 },
            { name = "deco_general_trough", x_offset = 3, z_offset = -width / 2 },
            { name = "window_round", x_offset = -2, z_offset = -width / 2 },
            { name = "window_round_light", x_offset = -2, z_offset = -width / 2 },
            { name = "window_round", x_offset = 1.5, z_offset = width / 2, rotation = 90 },
            { name = "window_round_light", x_offset = 1.5, z_offset = width / 2, rotation = 90 },
            { name = "swinging_light_chandalier_candles", x_offset = -1.3, },
            { name = "shop_buyer", x_offset = -1.8, z_offset = -4.1, anim = "idle_cablespool" },
            { name = "shop_buyer", x_offset = -1.8, z_offset = -1.9, anim = "idle_barrel" },
            { name = "shop_buyer", x_offset = -2, z_offset = 0.3, anim = "idle_barrel" },
            { name = "shop_buyer", x_offset = 1.1, z_offset = -4.4, anim = "idle_barrel" },
            { name = "shop_buyer", x_offset = 1.3, z_offset = -2.2, anim = "idle_barrel" },
            { name = "shop_buyer", x_offset = 1.1, anim = "idle_cablespool" },
            { name = "shop_buyer", x_offset = 1.5, z_offset = 5, anim = "idle_barrel" },
            { name = "shop_buyer", x_offset = 1.5, z_offset = 2.5, anim = "idle_barrel" },
        }
    },
    pig_shop_produce = {
        width = width,
        depth = depth,
        addprops = {
            { name = "interior_wall_wood", scale = { 2.8, 2.8 } },
            { name = "interior_floor_wood" },
            { name = "city_exit_produce_door", x_offset = 4.5, key = "exit", },
            { name = "pigman_storeowner_shopkeep", x_offset = -2.5, z_offset = 4, startstate = "desk" },
            { name = "rug_rectangle", x_offset = depth / 6 + 1, z_offset = width / 6 + 1, rotation = 95 },
            { name = "rug_rectangle", x_offset = -depth / 6 + 1, z_offset = width / 6 + 1, rotation = 91 },
            { name = "rug_rectangle", x_offset = depth / 6 + 0.5, z_offset = -width / 6, rotation = -95 },
            { name = "rug_rectangle", x_offset = -depth / 6 - 0.5, z_offset = -width / 6, rotation = 91 },
            { name = "deco_roomglow", },
            { name = "deco_general_hangingscale", x_offset = -4, z_offset = 4.7 },
            { name = "deco_produce_stone_cornerbeam", x_offset = -5, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_produce_stone_cornerbeam", x_offset = -5, z_offset = -width / 2 },
            { name = "deco_wood_cornerbeam", x_offset = 5, z_offset = -width / 2, },
            { name = "deco_wood_cornerbeam", x_offset = 5, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_produce_menu_side", z_offset = -width / 2 },
            { name = "deco_produce_menu", x_offset = -depth / 2, z_offset = -width / 6 },
            { name = "deco_produce_menu", x_offset = -depth / 2, z_offset = width / 6 },
            { name = "window_round", x_offset = depth / 6, z_offset = width / 2, rotation = 90 },
            { name = "window_round", x_offset = -depth / 6, z_offset = width / 2, rotation = 90 },
            { name = "window_round_light", x_offset = depth / 6, z_offset = width / 2, rotation = 90 },
            { name = "window_round_light", x_offset = -depth / 6, z_offset = width / 2, rotation = 90 },
            { name = "swinging_light_pendant_cherries", x_offset = -1, z_offset = -width / 6 },
            { name = "shop_buyer", x_offset = -2.5, z_offset = -4.9, anim = "idle_ice_box" },
            { name = "shop_buyer", x_offset = -2.5, z_offset = -2.7, anim = "idle_ice_box" },
            { name = "shop_buyer", x_offset = -2.8, z_offset = -0.5, anim = "idle_ice_box" },
            { name = "shop_buyer", x_offset = -0.3, z_offset = 2.2, anim = "idle_ice_box" },
            { name = "shop_buyer", x_offset = -0.3, z_offset = 4.4, anim = "idle_ice_box" },
            { name = "shop_buyer", x_offset = 1, z_offset = -5.1, anim = "idle_ice_box" },
            { name = "shop_buyer", x_offset = 1, z_offset = -2.7, anim = "idle_ice_box" },
            { name = "shop_buyer", x_offset = 1, z_offset = -0.5, anim = "idle_ice_box" },
            { name = "shop_buyer", x_offset = 2.7, z_offset = 2.2, anim = "idle_ice_box" },
            { name = "shop_buyer", x_offset = 2.7, z_offset = 4.4, anim = "idle_ice_box" },
            { name = "shop_buyer", x_offset = 4, z_offset = -4, anim = "idle_ice_bucket", saleitem = { "ice", "oinc", 1 }, },
        }
    },
    pig_shop_deli = {
        width = width,
        depth = depth,
        addprops = {
            { name = "interior_wall_checkered", scale = { 2.8, 2.8 } },
            { name = "interior_floor_sheet_metal" },
            { name = "city_exit_deli_door", x_offset = 4.5, key = "exit", },
            { name = "pigman_storeowner_shopkeep", x_offset = -1, z_offset = 4, startstate = "desk" },
            { name = "shelves_fridge", x_offset = -4.5, z_offset = -4, rotation = -90, shelfitems = { { 1, "fish_raw_small" }, { 2, "fish_raw_small" }, { 3, "bird_egg" }, { 4, "bird_egg" }, { 5, "froglegs" }, { 6, "froglegs" } }, },
            { name = "deco_general_hangingscale", x_offset = -2, z_offset = 4.7 },
            { name = "deco_roomglow", },
            { name = "deco_wood_cornerbeam", x_offset = -5, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_wood_cornerbeam", x_offset = -5, z_offset = -width / 2 },
            { name = "deco_wood_cornerbeam", x_offset = 5, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_wood_cornerbeam", x_offset = 5, z_offset = -width / 2 },
            { name = "deco_deli_meatrack", z_offset = -width / 2 + 2 },
            { name = "deco_deli_basket", x_offset = 3, z_offset = -width / 2 + 1 },
            { name = "deco_deli_stove_metal_side", x_offset = -3, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_deli_wallpaper_rip_side1", x_offset = -1, z_offset = -width / 2 },
            { name = "deco_deli_wallpaper_rip_side2", x_offset = 2, z_offset = width / 2, scale = { -1, 1 } },
            { name = "window_round_burlap_backwall", x_offset = -5, z_offset = 2 },
            { name = "window_round_light_backwall", x_offset = -5, z_offset = 2 },
            { name = "swinging_light_basic_metal", x_offset = -1.3, z_offset = -width / 6 + 0.5 },
            { name = "shop_buyer", x_offset = -1.8, z_offset = -5.1, anim = "idle_cakestand_dome" },
            { name = "shop_buyer", x_offset = -1.8, z_offset = -2.4, anim = "idle_cakestand_dome" },
            { name = "shop_buyer", x_offset = -2, z_offset = 0.3, anim = "idle_cakestand_dome" },
            { name = "shop_buyer", x_offset = 3.1, z_offset = -5.4, anim = "idle_ice_box" },
            { name = "shop_buyer", x_offset = 1, z_offset = -4.6, anim = "idle_ice_box" },
            { name = "shop_buyer", x_offset = 2.1, z_offset = -2, anim = "idle_ice_bucket" },
            { name = "shop_buyer", x_offset = 2.5, z_offset = 5, anim = "idle_fridge_display" },
            { name = "shop_buyer", x_offset = 2.5, z_offset = 2.5, anim = "idle_fridge_display" },
        }
    },
    pig_shop_cityhall = {
        width = width,
        depth = depth,
        addprops = {
            { name = "interior_wall_mayorsoffice", scale = { 2.8, 2.8 } },
            { name = "interior_floor_plaid_tile" },
            { name = "city_exit_flag_door", x_offset = 4.5, key = "exit", },
            { name = "pigman_mayor_shopkeep", x_offset = -3, z_offset = 4 },
            { name = "deco_roomglow", },
            { name = "deco_cityhall_desk", x_offset = -1.3, },
            { name = "deco_cityhall_bookshelf", x_offset = -depth / 2, z_offset = width / 3 },
            { name = "deco_cityhall_bookshelf", x_offset = -depth / 2, z_offset = -width / 3, scale = { -1, 1 } },
            { name = "deco_cityhall_cornerbeam", x_offset = -4.99, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_cityhall_cornerbeam", x_offset = -4.99, z_offset = -width / 2 },
            { name = "deco_cityhall_pillar", x_offset = 4.7, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_cityhall_pillar", x_offset = 4.7, z_offset = -width / 2 },
            { name = "deco_cityhall_picture1", x_offset = 1.3, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_cityhall_picture2", x_offset = -1.3, z_offset = width / 2, scale = { -1, 1 } },
            { name = "rug_hoofprint", rotation = 90 },
            { name = "rug_cityhall_corners", x_offset = -depth / 2, z_offset = width / 2, rotation = 90 },
            { name = "rug_cityhall_corners", x_offset = depth / 2, z_offset = width / 2, rotation = 180 },
            { name = "rug_cityhall_corners", x_offset = depth / 2, z_offset = -width / 2, rotation = 270 },
            { name = "rug_cityhall_corners", x_offset = -depth / 2, z_offset = -width / 2, rotation = 0 },
            { name = "window_round_light_backwall", x_offset = -5, z_offset = 2 },
            { name = "window_mayorsoffice", x_offset = -depth / 2, rotation = 90 },
            { name = "wall_mirror", x_offset = -1, z_offset = -width / 2 },
            { name = "shop_buyer", x_offset = 1.75, z_offset = width / 2 - 5, saleitem = { "deed", "oinc", 50 }, anim = "idle_globe_bar", justsellonce = true },
            { name = "shop_buyer", x_offset = 3.5, z_offset = width / 2 - 2, saleitem = { "construction_permit", "oinc", 50 }, anim = "idle_globe_bar" },
            { name = "shop_buyer", x_offset = -1, z_offset = width / 2 - 2, saleitem = { "demolition_permit", "oinc", 10 }, anim = "idle_globe_bar" },
            { name = "shop_buyer", x_offset = 2, z_offset = -width / 2 + 3, saleitem = { "securitycontract", "oinc", 10 }, anim = "idle_marble_dome" },
        }
    },
    pig_shop_cityhall_player = {
        width = width,
        depth = depth,
        addprops = {
            { name = "interior_wall_mayorsoffice", scale = { 2.8, 2.8 } },
            { name = "interior_floor_plaid_tile" },
            { name = "city_exit_flag_door", x_offset = 4.5, key = "exit", },
            { name = "deco_roomglow", },
            { name = "deco_cityhall_desk", x_offset = -1.3, },
            { name = "deco_cityhall_bookshelf", x_offset = -depth / 2, z_offset = width / 3 },
            { name = "deco_cityhall_bookshelf", x_offset = -depth / 2, z_offset = -width / 3, scale = { -1, 1 } },
            { name = "deco_cityhall_cornerbeam", x_offset = -4.99, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_cityhall_cornerbeam", x_offset = -4.99, z_offset = -width / 2 },
            { name = "deco_cityhall_pillar", x_offset = 4.7, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_cityhall_pillar", x_offset = 4.7, z_offset = -width / 2 },
            { name = "deco_cityhall_picture1", x_offset = 1.3, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_cityhall_picture2", x_offset = -1.3, z_offset = width / 2, scale = { -1, 1 } },
            { name = "rug_hoofprint", rotation = 90 },
            { name = "rug_cityhall_corners", x_offset = -depth / 2, z_offset = width / 2, rotation = 90 },
            { name = "rug_cityhall_corners", x_offset = depth / 2, z_offset = width / 2, rotation = 180 },
            { name = "rug_cityhall_corners", x_offset = depth / 2, z_offset = -width / 2, rotation = 270 },
            { name = "rug_cityhall_corners", x_offset = -depth / 2, z_offset = -width / 2, rotation = 0 },
            { name = "window_round_light_backwall", x_offset = -5, z_offset = 2 },
            { name = "window_mayorsoffice", x_offset = -depth / 2, rotation = 90 },
            { name = "wall_mirror", x_offset = -1, z_offset = -width / 2 },
        }
    },
    pig_shop_bank = {
        width = width,
        depth = depth,
        addprops = {
            { name = "interior_wall_fullwall_moulding", scale = { 2.8, 2.8 } },
            { name = "interior_floor_hoof_curvy" },
            { name = "city_exit_bank_door", x_offset = 4.5, key = "exit", },
            { name = "pigman_banker_shopkeep", x_offset = -2.5, startstate = "desk" },
            { name = "deco_roomglow", },
            { name = "deco_bank_marble_cornerbeam", x_offset = -4.99, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_bank_marble_cornerbeam", x_offset = -4.99, z_offset = -width / 2 },
            { name = "deco_bank_marble_beam", x_offset = 4.7, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_bank_marble_beam", x_offset = 4.7, z_offset = -width / 2 },
            { name = "deco_bank_clock1_side", x_offset = -depth / 4, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_bank_clock2_side", z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_bank_clock3_side", x_offset = depth / 4, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_bank_clock3_side", x_offset = -depth / 4, z_offset = -width / 2 },
            { name = "deco_bank_clock1_side", z_offset = -width / 2 },
            { name = "deco_bank_clock2_side", x_offset = depth / 4, z_offset = -width / 2 },
            { name = "shop_buyer", x_offset = 2.3, z_offset = -width / 4.5, anim = "idle_marble_dome", saleitem = { "oinc10", "oinc", 10 }, },
            { name = "shop_buyer", x_offset = -1.7, z_offset = -width / 4.5, anim = "idle_marble_dome", saleitem = { "oinc100", "oinc", 100 }, },
            { name = "shop_buyer", x_offset = -1.7, z_offset = width / 4.5, anim = "idle_marble_dome", saleitem = { "goldnugget", "oinc", 10 }, },
            { name = "deco_bank_vault", x_offset = -depth / 2, },
            { name = "deco_accademy_barrier", x_offset = -3, z_offset = -width / 4.5 },
            { name = "deco_accademy_barrier", x_offset = -3, z_offset = width / 4.5 },
            { name = "deco_accademy_barrier_vert", x_offset = -2, z_offset = -5 },
            { name = "deco_accademy_barrier_vert", x_offset = 2.3, z_offset = -5 },
            { name = "deco_accademy_barrier_vert", x_offset = -2, z_offset = 5, scale = { -1, 1 } },
            { name = "deco_accademy_barrier_vert", x_offset = 2.3, z_offset = 5, scale = { -1, 1 } },
            { name = "shelves_displaycase_metal", x_offset = -2, z_offset = -width / 2 + 0.75, rotation = 90, scale = { -1, 1 }, shelfitems = { { 1, "flint" }, { 2, "rocks" }, { 3, "flint" } }, },
            { name = "shelves_displaycase_metal", x_offset = -2, z_offset = width / 2 - 0.75, rotation = 90, shelfitems = { { 1, "rocks" }, { 2, "rocks" }, { 3, "rocks" } }, },
            { name = "shelves_displaycase_metal", x_offset = 2.3, z_offset = -width / 2 + 0.75, rotation = 90, scale = { -1, 1 }, shelfitems = { { 1, "nitre" }, { 2, "nitre" }, { 3, "rocks" } }, },
            { name = "shelves_displaycase_metal", x_offset = 2.3, z_offset = width / 2 - 0.75, rotation = 90, shelfitems = { { 1, "rocks" }, { 2, "charcoal" }, { 3, "charcoal" } }, },
            { name = "swinging_light_bank", x_offset = -1.7, z_offset = -width / 4.5 },
            { name = "swinging_light_bank", x_offset = -1.7, z_offset = width / 4.5 },
        }
    },
    pig_shop_tinker = {
        width = width,
        depth = depth,
        addprops = {
            { name = "interior_wall_bricks", scale = { 2.8, 2.8 } },
            { name = "interior_floor_woodpaneling2" },
            { name = "city_exit_tinker_door", x_offset = 4.5, key = "exit", },
            { name = "pigman_mechanic_shopkeep", x_offset = -2, z_offset = -3, startstate = "desk" },
            { name = "deco_roomglow", },
            { name = "deco_tinker_cornerbeam", x_offset = -4.99, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_tinker_cornerbeam", x_offset = -4.99, z_offset = -width / 2 },
            { name = "deco_tinker_beam", x_offset = 4.7, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_tinker_beam", x_offset = 4.7, z_offset = -width / 2 },
            { name = "deco_bank_clock1_side", x_offset = -depth / 4, z_offset = width / 2, scale = { -1, 1 } },
            { name = "deco_bank_clock2_side", z_offset = -width / 2 },
            { name = "shop_buyer", x_offset = 1.3, z_offset = -width / 6 - 1.75, anim = "idle_metal" },
            { name = "shop_buyer", x_offset = 1.3, z_offset = -1.75, anim = "idle_metal" },
            { name = "shop_buyer", x_offset = -1.7, z_offset = width / 6 + 0.5, anim = "idle_metal" },
            { name = "shop_buyer", x_offset = -1.7, z_offset = 0.5, anim = "idle_metal" },
            { name = "shelves_metal", x_offset = -4.0, z_offset = 4, rotation = -90, shelfitems = { { 3, "charcoal" }, { 4, "nitre" }, { 5, "papyrus" }, { 6, "charcoal" } }, },
            { name = "window_round_backwall", x_offset = -depth / 2, },
            { name = "rug_fur", x_offset = -1.5, z_offset = 2, rotation = 100 },
            { name = "rug_fur", x_offset = 1.5, z_offset = -3, rotation = 90 },
            { name = "swinging_light_bank", x_offset = -3, z_offset = -width / 4.5 + 0.5 },
            { name = "swinging_light_bank", z_offset = width / 4.5 + 2 },
            { name = "deco_rollchest", x_offset = 4, z_offset = -5 },
            { name = "deco_worktable", x_offset = 2.5, z_offset = 4, rotation = 90, scale = { -1, 1 } },
            { name = "deco_filecabinet", x_offset = -2.5, z_offset = -width / 2 },
            { name = "deco_rollholder", x_offset = 2, z_offset = -width / 2 + 0.7 },
            { name = "deco_rollholder", z_offset = width / 2 - 0.7, rotation = 90, scale = { -1, 1 } },
            { name = "deco_rollholder_front", x_offset = -depth / 2 + 0.3, z_offset = -4 },
        }
    }
}

local function creatInterior(inst)
    if inst.components.teleporter:GetTarget() then return end

    local room = rooms[inst.prefab]

    -- 摊位需要知道自己所处的商店
    for _, data in ipairs(room.addprops) do
        if data.name == "shop_buyer" then
            data.shoptype = inst.prefab
        end
    end

    local doors = InteriorSpawnerUtils.CreateRoom(room)
    inst.components.teleporter:Target(doors.exit)
    doors.exit.components.teleporter:Target(inst)
end

local function OnEntityWake(inst) --应该什么时候显示呢
    -- if GetAporkalypse() and GetAporkalypse():GetFiestaActive() then
    --     inst.AnimState:Show("YOTP")
    -- else
    --     inst.AnimState:Hide("YOTP")
    -- end
end

local GUARDS_MUST_TAGS = { "guard", "city_pig" }

--- 当传送玩家时，延迟一段时间把仇视玩家的猪人守卫也传送过去
local function OnTeleporting(inst, doer)
    if not doer:HasTag("player") then return end

    local x, y, z = inst.Transform:GetWorldPosition()
    for _, guard in ipairs(TheSim:FindEntities(x, 0, z, InteriorSpawnerUtils.RADIUS, GUARDS_MUST_TAGS)) do
        if guard.components.combat:TargetIs(doer) then
            guard:DoTaskInTime(math.random(1) + 1, function(guard)
                if inst:IsValid() and inst:HasTag("teleporter") then
                    inst.components.teleporter:Activate(guard)
                    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/store/door_open")
                end
            end)
        end
    end
end

local function makefn(name, build, bank, data)
    data = data or {}

    local function fn()
        local usesound = data.sounds and data.sounds[1] or nil
        local inst = InteriorSpawnerUtils.MakeBaseDoor(bank or "pig_shop", build, "idle", false, false,
            name == "pig_shop_cityhall_player" and "pig_shop_cityhall.png" or name .. ".png", usesound)

        inst.entity:AddLight()
        inst.Light:SetFalloff(1)
        inst.Light:SetIntensity(.5)
        inst.Light:SetRadius(1)
        inst.Light:Enable(false)
        inst.Light:SetColour(180 / 255, 195 / 255, 50 / 255)

        MakeObstaclePhysics(inst, 1.25)

        inst.AnimState:Hide("YOTP")

        inst:AddTag("structure")
        inst:AddTag("city_hammerable")

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.teleporter.onActivate = OnTeleporting

        inst:AddComponent("lootdropper")

        if not data.indestructable then
            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
            inst.components.workable:SetWorkLeft(4)
            inst.components.workable:SetOnFinishCallback(onhammered)
            inst.components.workable:SetOnWorkCallback(onhit)
        end

        inst.components.inspectable.getstatus = getstatus

        if name == "pig_shop_cityhall" then
            inst.AnimState:AddOverrideBuild("flag_post_duster_build")
        elseif name == "pig_shop_cityhall_player" then
            inst.AnimState:AddOverrideBuild("flag_post_wilson_build")
        end

        MakeSnowCovered(inst, .01)

        inst.fixbank = bank or "pig_shop"
        inst:AddComponent("fixable")
        inst.components.fixable:AddRecinstructionStageData("rubble", inst.fixbank, build)
        inst.components.fixable:AddRecinstructionStageData("unbuilt", inst.fixbank, build)

        if not data.unburnable then
            MakeLargeBurnable(inst, nil, nil, true)
            MakeLargePropagator(inst)
            inst:ListenForEvent("burntup", OnBurntUp)
        end

        inst:AddComponent("gridnudger")

        inst:DoTaskInTime(0, creatInterior)

        inst.breaksoundsufix = data.usestonebreaksound and "stone" or "wood"
        inst.OnSave = onsave
        inst.OnLoad = onload
        inst.OnEntityWake = OnEntityWake

        inst:WatchWorldState("isnight", OnNight)
        OnNight(inst, TheWorld.state.isnight)

        inst:ListenForEvent("onbuilt", onbuilt)

        return inst
    end
    return fn
end

local function makeshop(name, build, bank, data)
    return Prefab(name, makefn(name, build, bank, data), assets, prefabs)
end

local function placetestfn(inst)
    inst.AnimState:Hide("YOTP")
    inst.AnimState:Hide("SNOW")

    local pt = inst:GetPosition()
    local tile = GetWorld().Map:GetTileAtPoint(pt.x, pt.y, pt.z)
    if tile == GROUND.INTERIOR then
        return false
    end

    return true
end

return makeshop("pig_shop_deli", "pig_shop_deli", nil, { sounds = { SHOPSOUND_ENTER1, SHOPSOUND_ENTER2 } }),
    makeshop("pig_shop_general", "pig_shop_general", nil, { sounds = { SHOPSOUND_ENTER1, SHOPSOUND_ENTER2 }, usestonebreaksound = true }),
    makeshop("pig_shop_hoofspa", "pig_shop_hoofspa", nil, { sounds = { SHOPSOUND_ENTER1, SHOPSOUND_ENTER2 } }),
    makeshop("pig_shop_produce", "pig_shop_produce", nil, { sounds = { SHOPSOUND_ENTER1, SHOPSOUND_ENTER2 } }),
    makeshop("pig_shop_florist", "pig_shop_florist", nil, { sounds = { SHOPSOUND_ENTER1, SHOPSOUND_ENTER2 } }),
    makeshop("pig_shop_antiquities", "pig_shop_antiquities", nil, { sounds = { SHOPSOUND_ENTER1, SHOPSOUND_ENTER2 }, usestonebreaksound = true }),
    makeshop("pig_shop_academy", "pig_shop_accademia", nil, { sounds = { SHOPSOUND_ENTER1, SHOPSOUND_ENTER2 } }),
    makeshop("pig_shop_arcane", "pig_shop_arcane", nil, { sounds = { SHOPSOUND_ENTER1, SHOPSOUND_ENTER2 } }),
    makeshop("pig_shop_weapons", "pig_shop_weapons", nil, { sounds = { SHOPSOUND_ENTER1, SHOPSOUND_ENTER2 } }),
    makeshop("pig_shop_hatshop", "pig_shop_millinery", nil, { sounds = { SHOPSOUND_ENTER1, SHOPSOUND_ENTER2 } }),
    makeshop("pig_shop_bank", "pig_shop_bank", nil, { sounds = { SHOPSOUND_ENTER1, SHOPSOUND_ENTER2 }, usestonebreaksound = true }),
    makeshop("pig_shop_tinker", "pig_shop_tinker", nil, { sounds = { SHOPSOUND_ENTER1, SHOPSOUND_ENTER2 }, usestonebreaksound = true }),
    makeshop("pig_shop_cityhall", "pig_cityhall", "pig_cityhall", { indestructable = true, unburnable = true, sounds = { SHOPSOUND_ENTER1, SHOPSOUND_ENTER2 } }),
    makeshop("pig_shop_cityhall_player", "pig_cityhall", "pig_cityhall", { unburnable = true, sounds = { SHOPSOUND_ENTER1, SHOPSOUND_ENTER2 }, usestonebreaksound = true }),
    MakePlacer("pig_shop_deli_placer", "pig_shop", "pig_shop_deli", "idle", false, false, true, nil, nil, nil, nil, nil, nil, placetestfn),
    MakePlacer("pig_shop_general_placer", "pig_shop", "pig_shop_general", "idle", false, false, true, nil, nil, nil, nil, nil, nil, placetestfn),
    MakePlacer("pig_shop_hoofspa_placer", "pig_shop", "pig_shop_hoofspa", "idle", false, false, true, nil, nil, nil, nil, nil, nil, placetestfn),
    MakePlacer("pig_shop_produce_placer", "pig_shop", "pig_shop_produce", "idle", false, false, true, nil, nil, nil, nil, nil, nil, placetestfn),
    MakePlacer("pig_shop_florist_placer", "pig_shop", "pig_shop_florist", "idle", false, false, true, nil, nil, nil, nil, nil, nil, placetestfn),
    MakePlacer("pig_shop_antiquities_placer", "pig_shop", "pig_shop_antiquities", "idle", false, false, true, nil, nil, nil, nil, nil, nil, placetestfn),
    MakePlacer("pig_shop_arcane_placer", "pig_shop", "pig_shop_arcane", "idle", false, false, true, nil, nil, nil, nil, nil, nil, placetestfn),
    MakePlacer("pig_shop_weapons_placer", "pig_shop", "pig_shop_weapons", "idle", false, false, true, nil, nil, nil, nil, nil, nil, placetestfn),
    MakePlacer("pig_shop_hatshop_placer", "pig_shop", "pig_shop_millinery", "idle", false, false, true, nil, nil, nil, nil, nil, nil, placetestfn),
    MakePlacer("pig_shop_cityhall_placer", "pig_cityhall", "pig_cityhall", "idle", false, false, true, nil, nil, nil, nil, nil, nil, placetestfn),
    MakePlacer("pig_shop_bank_placer", "pig_shop", "pig_shop_bank", "idle", false, false, true, nil, nil, nil, nil, nil, nil, placetestfn),
    MakePlacer("pig_shop_tinker_placer", "pig_shop", "pig_shop_tinker", "idle", false, false, true, nil, nil, nil, nil, nil, nil, placetestfn)
