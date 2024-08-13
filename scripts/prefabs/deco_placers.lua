local InteriorSpawnerUtils = require("interiorspawnerutils")

local PLACER_SNAP_DISTANCE = 6
local function placer_onupdatetransform(inst)
    local pos = inst:GetPosition()
    local ents = TheSim:FindEntities(pos.x, 0, pos.z, PLACER_SNAP_DISTANCE, { "cornerpost" })

    if #ents > 0 then
        local _, isLeft = InteriorSpawnerUtils.TestBeam(inst)
        inst.AnimState:SetScale(not isLeft and -1 or 1, 1)

        local targetpos = ents[1]:GetPosition()
        inst.Transform:SetPosition(targetpos.x, 0, targetpos.z)
        inst.accept_placement = true
    else
        inst.accept_placement = false
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

local function cornerbeam_placer_postinit_fn(inst)
    inst.components.placer.onupdatetransform = placer_onupdatetransform
    inst.components.placer.override_build_point_fn = inst.GetPosition
    inst.components.placer.override_testfn = placer_override_testfn
    inst.accept_placement = false
end

-- 建造时旋转90，是否旋转跟房子固定的摄像头角度有关
local function PostInitRotation90(inst)
    inst.Transform:SetRotation(90)
end

local function PlacerOnRaiseUpdateTransform(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    inst.Transform:SetPosition(x, y + 3, z)
end
-- 吊灯，我需要抬高y值隐藏上部分
local function PostInitRaise(inst)
    inst.components.placer.onupdatetransform = PlacerOnRaiseUpdateTransform
end

local function PlacerOnWallUpdateTransform(inst)
    local side, minDis = InteriorSpawnerUtils.TestWallOrnamentPos(inst, true)
    local bank = ""
    local flip = false
    if side and minDis < 4 then
        if side == 1 then
            bank = "_side"
        elseif side == 3 then
            bank = "_side"
            flip = true
        end
        inst.accept_placement = true
    else
        inst.accept_placement = false
    end

    if side ~= inst.lastSide then
        inst.lastSide = side
        inst.AnimState:SetBank(inst.bank .. bank)
        inst.AnimState:SetScale(flip and -1 or 1, 1)
    end
end

-- 墙壁上的装饰，固定高度，只有三个面可放置
local function PostInitWallOrnament(inst)
    inst.lastSide = nil
    inst.bank = inst.AnimState:GetCurrentBankName()

    inst.components.placer.onupdatetransform = PlacerOnWallUpdateTransform
    inst.components.placer.override_build_point_fn = inst.GetPosition
    inst.components.placer.override_testfn = placer_override_testfn
    inst.accept_placement = false
end

local function PlacerOnLightUpdateTransform(inst)
    local centerPos = InteriorSpawnerUtils.GetHouseCenterPos(inst)
    if centerPos then
        inst.Transform:SetPosition(centerPos.x - 2, 1, centerPos.z)
        inst.accept_placement = true
    else
        inst.accept_placement = false
    end
end

local function PostInitSwingingLight(inst)
    inst.components.placer.onupdatetransform = PlacerOnLightUpdateTransform
    inst.components.placer.override_build_point_fn = inst.GetPosition
    inst.components.placer.override_testfn = placer_override_testfn
    inst.accept_placement = false
end

return
-- 椅子
    MakePlacer("chair_classic_placer", "interior_chair", "interior_chair", "chair_classic"),
    MakePlacer("chair_corner_placer", "interior_chair", "interior_chair", "chair_corner"),
    MakePlacer("chair_bench_placer", "interior_chair", "interior_chair", "chair_bench"),
    MakePlacer("chair_horned_placer", "interior_chair", "interior_chair", "chair_horned"),
    MakePlacer("chair_footrest_placer", "interior_chair", "interior_chair", "chair_footrest"),
    MakePlacer("chair_lounge_placer", "interior_chair", "interior_chair", "chair_lounge"),
    MakePlacer("chair_massager_placer", "interior_chair", "interior_chair", "chair_massager"),
    MakePlacer("chair_stuffed_placer", "interior_chair", "interior_chair", "chair_stuffed"),
    MakePlacer("chair_rocking_placer", "interior_chair", "interior_chair", "chair_rocking"),
    MakePlacer("chair_ottoman_placer", "interior_chair", "interior_chair", "chair_ottoman"),
    MakePlacer("deco_chaise_placer", "interior_floor_decor", "interior_floor_decor", "chaise"),

    -- 展示柜
    MakePlacer("shelves_wood_placer", "bookcase", "room_shelves", "wood"),
    MakePlacer("shelves_basic_placer", "bookcase", "room_shelves", "basic"),
    MakePlacer("shelves_cinderblocks_placer", "bookcase", "room_shelves", "cinderblocks"),
    MakePlacer("shelves_marble_placer", "bookcase", "room_shelves", "marble"),
    MakePlacer("shelves_glass_placer", "bookcase", "room_shelves", "glass"),
    MakePlacer("shelves_ladder_placer", "bookcase", "room_shelves", "ladder"),
    MakePlacer("shelves_hutch_placer", "bookcase", "room_shelves", "hutch"),
    MakePlacer("shelves_industrial_placer", "bookcase", "room_shelves", "industrial"),
    MakePlacer("shelves_adjustable_placer", "bookcase", "room_shelves", "adjustable"),
    MakePlacer("shelves_midcentury_placer", "bookcase", "room_shelves", "midcentury"),
    MakePlacer("shelves_wallmount_placer", "bookcase", "room_shelves", "wallmount"),
    MakePlacer("shelves_aframe_placer", "bookcase", "room_shelves", "aframe"),
    MakePlacer("shelves_crates_placer", "bookcase", "room_shelves", "crates"),
    MakePlacer("shelves_fridge_placer", "bookcase", "room_shelves", "fridge"),
    MakePlacer("shelves_floating_placer", "bookcase", "room_shelves", "floating"),
    MakePlacer("shelves_pipe_placer", "bookcase", "room_shelves", "pipe"),
    MakePlacer("shelves_hattree_placer", "bookcase", "room_shelves", "hattree"),
    MakePlacer("shelves_pallet_placer", "bookcase", "room_shelves", "pallet"),

    -- 地毯
    MakePlacer("rug_round_placer", "rugs", "rugs", "rug_round", true, nil, nil, nil, nil, nil, PostInitRotation90),
    MakePlacer("rug_square_placer", "rugs", "rugs", "rug_square", true, nil, nil, nil, nil, nil,
        PostInitRotation90),
    MakePlacer("rug_oval_placer", "rugs", "rugs", "rug_oval", true, nil, nil, nil, nil, nil, PostInitRotation90),
    MakePlacer("rug_rectangle_placer", "rugs", "rugs", "rug_rectangle", true, nil, nil, nil, nil, nil,
        PostInitRotation90),
    MakePlacer("rug_leather_placer", "rugs", "rugs", "rug_leather", true, nil, nil, nil, nil, nil,
        PostInitRotation90),
    MakePlacer("rug_fur_placer", "rugs", "rugs", "rug_fur", true, nil, nil, nil, nil, nil, PostInitRotation90),
    MakePlacer("rug_circle_placer", "rugs", "rugs", "half_circle", true, nil, nil, nil, nil, nil,
        PostInitRotation90),
    MakePlacer("rug_hedgehog_placer", "rugs", "rugs", "rug_hedgehog", true, nil, nil, nil, nil, nil,
        PostInitRotation90),
    MakePlacer("rug_porcupuss_placer", "rugs", "rugs", "rug_porcupuss", true, nil, nil, nil, nil, nil,
        PostInitRotation90),
    MakePlacer("rug_hoofprint_placer", "rugs", "rugs", "rug_hoofprints", true, nil, nil, nil, nil, nil,
        PostInitRotation90),
    MakePlacer("rug_octagon_placer", "rugs", "rugs", "rug_octagon", true, nil, nil, nil, nil, nil,
        PostInitRotation90),
    MakePlacer("rug_swirl_placer", "rugs", "rugs", "rug_swirl", true, nil, nil, nil, nil, nil, PostInitRotation90),
    MakePlacer("rug_catcoon_placer", "rugs", "rugs", "rug_catcoon", true, nil, nil, nil, nil, nil,
        PostInitRotation90),
    MakePlacer("rug_rubbermat_placer", "rugs", "rugs", "rug_rubbermat", true, nil, nil, nil, nil, nil,
        PostInitRotation90),
    MakePlacer("rug_web_placer", "rugs", "rugs", "rug_web", true, nil, nil, nil, nil, nil, PostInitRotation90),
    MakePlacer("rug_metal_placer", "rugs", "rugs", "rug_metal", true, nil, nil, nil, nil, nil, PostInitRotation90),
    MakePlacer("rug_wormhole_placer", "rugs", "rugs", "rug_wormhole", true, nil, nil, nil, nil, nil,
        PostInitRotation90),
    MakePlacer("rug_braid_placer", "rugs", "rugs", "rug_braid", true, nil, nil, nil, nil, nil, PostInitRotation90),
    MakePlacer("rug_beard_placer", "rugs", "rugs", "rug_beard", true, nil, nil, nil, nil, nil, PostInitRotation90),
    MakePlacer("rug_nailbed_placer", "rugs", "rugs", "rug_nailbed", true, nil, nil, nil, nil, nil,
        PostInitRotation90),
    MakePlacer("rug_crime_placer", "rugs", "rugs", "rug_crime", true, nil, nil, nil, nil, nil, PostInitRotation90),
    MakePlacer("rug_tiles_placer", "rugs", "rugs", "rug_tiles", true, nil, nil, nil, nil, nil, PostInitRotation90),

    -- 灯
    MakePlacer("deco_lamp_fringe_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_fringe"),
    MakePlacer("deco_lamp_stainglass_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_stainglass"),
    MakePlacer("deco_lamp_downbridge_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_downbridge"),
    MakePlacer("deco_lamp_2embroidered_placer", "interior_floorlamp", "interior_floorlamp",
        "floorlamp_2embroidered"),
    MakePlacer("deco_lamp_ceramic_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_ceramic"),
    MakePlacer("deco_lamp_glass_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_glass"),
    MakePlacer("deco_lamp_2fringes_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_2fringes"),
    MakePlacer("deco_lamp_candelabra_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_candelabra"),
    MakePlacer("deco_lamp_elizabethan_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_elizabethan"),
    MakePlacer("deco_lamp_gothic_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_gothic"),
    MakePlacer("deco_lamp_orb_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_orb"),
    MakePlacer("deco_lamp_bellshade_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_bellshade"),
    MakePlacer("deco_lamp_crystals_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_crystals"),
    MakePlacer("deco_lamp_upturn_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_upturn"),
    MakePlacer("deco_lamp_2upturns_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_2upturns"),
    MakePlacer("deco_lamp_spool_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_spool"),
    MakePlacer("deco_lamp_edison_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_edison"),
    MakePlacer("deco_lamp_adjustable_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_adjustable"),
    MakePlacer("deco_lamp_rightangles_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_rightangles"),
    MakePlacer("deco_lamp_hoofspa_placer", "interior_floor_decor", "interior_floor_decor", "lamp"),

    -- 盆栽
    MakePlacer("deco_plantholder_basic_placer", "interior_plant", "interior_plant", "plant_basic"),
    MakePlacer("deco_plantholder_wip_placer", "interior_plant", "interior_plant", "plant_wip"),
    MakePlacer("deco_plantholder_fancy_placer", "interior_plant", "interior_plant", "plant_fancy"),
    MakePlacer("deco_plantholder_bonsai_placer", "interior_plant", "interior_plant", "plant_bonsai"),
    MakePlacer("deco_plantholder_dishgarden_placer", "interior_plant", "interior_plant", "plant_dishgarden"),
    MakePlacer("deco_plantholder_philodendron_placer", "interior_plant", "interior_plant", "plant_philodendron"),
    MakePlacer("deco_plantholder_orchid_placer", "interior_plant", "interior_plant", "plant_orchid"),
    MakePlacer("deco_plantholder_draceana_placer", "interior_plant", "interior_plant", "plant_draceana"),
    MakePlacer("deco_plantholder_xerographica_placer", "interior_plant", "interior_plant", "plant_xerographica"),
    MakePlacer("deco_plantholder_birdcage_placer", "interior_plant", "interior_plant", "plant_birdcage"),
    MakePlacer("deco_plantholder_palm_placer", "interior_plant", "interior_plant", "plant_palm"),
    MakePlacer("deco_plantholder_zz_placer", "interior_plant", "interior_plant", "plant_zz"),
    MakePlacer("deco_plantholder_fernstand_placer", "interior_plant", "interior_plant", "plant_fernstand"),
    MakePlacer("deco_plantholder_fern_placer", "interior_plant", "interior_plant", "plant_fern"),
    MakePlacer("deco_plantholder_terrarium_placer", "interior_plant", "interior_plant", "plant_terrarium"),
    MakePlacer("deco_plantholder_plantpet_placer", "interior_plant", "interior_plant", "plant_plantpet"),
    MakePlacer("deco_plantholder_traps_placer", "interior_plant", "interior_plant", "plant_traps"),
    MakePlacer("deco_plantholder_pitchers_placer", "interior_plant", "interior_plant", "plant_pitchers"),
    MakePlacer("deco_plantholder_winterfeasttreeofsadness_placer", "interior_plant", "interior_plant",
        "plant_winterfeasttreeofsadness"),
    MakePlacer("deco_plantholder_winterfeasttree_placer", "interior_floorlamp", "interior_floorlamp",
        "festivetree_idle"),
    MakePlacer("deco_plantholder_marble_placer", "interior_floor_decor", "interior_floor_decor", "plant"),

    -- 桌子
    MakePlacer("deco_table_banker_placer", "interior_table", "interior_table", "table_banker"),
    MakePlacer("deco_table_round_placer", "interior_table", "interior_table", "table_round"),
    MakePlacer("deco_table_diy_placer", "interior_table", "interior_table", "table_diy"),
    MakePlacer("deco_table_raw_placer", "interior_table", "interior_table", "table_raw"),
    MakePlacer("deco_table_crate_placer", "interior_table", "interior_table", "table_crate"),
    MakePlacer("deco_table_chess_placer", "interior_table", "interior_table", "table_chess"),

    -- 挂墙上的装饰品
    MakePlacer("deco_antiquities_wallfish_placer", "interior_wallornament", "interior_wallornament", "fish", nil,
        nil,
        nil, nil, nil, nil, PostInitWallOrnament),
    MakePlacer("deco_antiquities_beefalo_placer", "interior_wallornament", "interior_wallornament", "beefalo", nil,
        nil,
        nil, nil, nil, nil, PostInitWallOrnament),
    MakePlacer("deco_wallornament_photo_placer", "interior_wallornament", "interior_wallornament", "photo", nil, nil,
        nil, nil, nil, nil, PostInitWallOrnament),
    MakePlacer("deco_wallornament_fulllength_mirror_placer", "interior_wallornament", "interior_wallornament",
        "fulllength_mirror", nil, nil, nil, nil, nil, nil, PostInitWallOrnament),
    MakePlacer("deco_wallornament_embroidery_hoop_placer", "interior_wallornament", "interior_wallornament",
        "embroidery_hoop", nil, nil, nil, nil, nil, nil, PostInitWallOrnament),
    MakePlacer("deco_wallornament_mosaic_placer", "interior_wallornament", "interior_wallornament", "mosaic", nil, nil,
        nil, nil, nil, nil, PostInitWallOrnament),
    MakePlacer("deco_wallornament_wreath_placer", "interior_wallornament", "interior_wallornament", "wreath", nil, nil,
        nil, nil, nil, nil, PostInitWallOrnament),
    MakePlacer("deco_wallornament_axe_placer", "interior_wallornament", "interior_wallornament", "axe", nil, nil, nil,
        nil, nil, nil, PostInitWallOrnament),
    MakePlacer("deco_wallornament_hunt_placer", "interior_wallornament", "interior_wallornament", "hunt", nil, nil, nil,
        nil, nil, nil, PostInitWallOrnament),
    MakePlacer("deco_wallornament_periodic_table_placer", "interior_wallornament", "interior_wallornament",
        "periodic_table", nil, nil, nil, nil, nil, nil, PostInitWallOrnament),
    MakePlacer("deco_wallornament_gears_art_placer", "interior_wallornament", "interior_wallornament", "gears_art", nil,
        nil, nil, nil, nil, nil, PostInitWallOrnament),
    MakePlacer("deco_wallornament_cape_placer", "interior_wallornament", "interior_wallornament", "cape", nil, nil, nil,
        nil, nil, nil, PostInitWallOrnament),
    MakePlacer("deco_wallornament_no_smoking_placer", "interior_wallornament", "interior_wallornament", "no_smoking", nil,
        nil, nil, nil, nil, nil, PostInitWallOrnament),
    MakePlacer("deco_wallornament_black_cat_placer", "interior_wallornament", "interior_wallornament", "black_cat", nil,
        nil, nil, nil, nil, nil, PostInitWallOrnament),

    -- 窗帘
    MakePlacer("window_round_backwall_placer", "interior_window", "interior_window", "day_loop", nil,
        nil, nil, nil, nil, nil, PostInitWallOrnament),
    MakePlacer("window_round_burlap_backwall_placer", "interior_window_burlap", "interior_window_burlap",
        "day_loop", nil,
        nil, nil, nil, nil, nil, PostInitWallOrnament),
    MakePlacer("window_small_peaked_backwall_placer", "interior_window", "interior_window_small", "day_loop", nil,
        nil, nil, nil, nil, nil, PostInitWallOrnament),
    MakePlacer("window_large_square_backwall_placer", "interior_window_large", "interior_window_large", "day_loop",
        nil,
        nil, nil, nil, nil, nil, PostInitWallOrnament),
    MakePlacer("window_tall_backwall_placer", "interior_window_tall", "interior_window_tall", "day_loop", nil,
        nil, nil, nil, nil, nil, PostInitWallOrnament),
    MakePlacer("window_round_arcane_backwall_placer", "interior_window_large", "window_arcane_build", "day_loop",
        nil,
        nil, nil, nil, nil, nil, PostInitWallOrnament),
    MakePlacer("window_small_peaked_curtain_backwall_placer", "interior_window", "interior_window_small",
        "day_loop", nil,
        nil, nil, nil, nil, nil, PostInitWallOrnament),
    MakePlacer("window_large_square_curtain_backwall_placer", "interior_window_large", "interior_window_large",
        "day_loop", nil, nil, nil, nil, nil, nil, PostInitWallOrnament),
    MakePlacer("window_tall_curtain_backwall_placer", "interior_window_tall", "interior_window_tall", "day_loop",
        nil,
        nil, nil, nil, nil, nil, PostInitWallOrnament),
    MakePlacer("window_square_weapons_backwall_placer", "interior_window_large", "window_weapons_build",
        "day_loop", nil,
        nil, nil, nil, nil, nil, PostInitWallOrnament),
    MakePlacer("window_greenhouse_backwall_placer", "interior_window_greenhouse",
        "interior_window_greenhouse_build",
        "day_loop", nil, nil, nil, nil, nil, nil, PostInitWallOrnament),

    -- 吊灯
    MakePlacer("swinging_light_basic_bulb_placer", "ceiling_lights", "ceiling_lights", "light_basic_bulb", nil,
        nil, nil, nil, nil, nil, PostInitSwingingLight),
    MakePlacer("swinging_light_floral_bloomer_placer", "ceiling_lights", "ceiling_lights", "light_floral_bloomer", nil,
        nil, nil, nil, nil, nil, PostInitSwingingLight),
    MakePlacer("swinging_light_basic_metal_placer", "ceiling_lights", "ceiling_lights", "light_basic_metal", nil,
        nil, nil, nil, nil, nil, PostInitSwingingLight),
    MakePlacer("swinging_light_chandalier_candles_placer", "ceiling_lights", "ceiling_lights", "light_chandelier_candles",
        nil, nil, nil, nil, nil, nil, PostInitSwingingLight),
    MakePlacer("swinging_light_rope_1_placer", "ceiling_lights", "ceiling_lights", "light_rope1", nil, nil, nil, nil, nil,
        nil, PostInitSwingingLight),
    MakePlacer("swinging_light_rope_2_placer", "ceiling_lights", "ceiling_lights", "light_rope2", nil, nil, nil, nil, nil,
        nil, PostInitSwingingLight),
    MakePlacer("swinging_light_floral_bulb_placer", "ceiling_lights", "ceiling_lights", "light_floral_bulb", nil, nil,
        nil, nil, nil, nil, PostInitSwingingLight),
    MakePlacer("swinging_light_pendant_cherries_placer", "ceiling_lights", "ceiling_lights", "light_pendant_cherries",
        nil, nil, nil, nil, nil, nil, PostInitSwingingLight),
    MakePlacer("swinging_light_floral_scallop_placer", "ceiling_lights", "ceiling_lights", "light_floral_scallop", nil,
        nil, nil, nil, nil, nil, PostInitSwingingLight),
    MakePlacer("swinging_light_floral_bloomer_placer", "ceiling_lights", "ceiling_lights", "light_floral_bloomer", nil,
        nil, nil, nil, nil, nil, PostInitSwingingLight),
    MakePlacer("swinging_light_tophat_placer", "ceiling_lights", "ceiling_lights", "light_tophat", nil, nil, nil, nil,
        nil, nil, PostInitSwingingLight),
    MakePlacer("swinging_light_derby_placer", "ceiling_lights", "ceiling_lights", "light_derby", nil, nil, nil, nil, nil,
        nil, PostInitSwingingLight),

    -- 柱子
    MakePlacer("deco_wood_cornerbeam_placer", "wall_decals", "interior_wall_decals", "4", nil, nil, nil, nil, nil, nil,
        cornerbeam_placer_postinit_fn),
    MakePlacer("deco_millinery_cornerbeam_placer", "wall_decals_millinery", "interior_wall_decals_millinery",
        "pillar_corner", nil, nil, nil, nil, nil, nil, cornerbeam_placer_postinit_fn),
    MakePlacer("deco_round_cornerbeam_placer", "wall_decals_accademia", "interior_wall_decals_accademia",
        "pillar_round_corner", nil, nil, nil, nil, nil, nil, cornerbeam_placer_postinit_fn),
    MakePlacer("deco_marble_cornerbeam_placer", "wall_decals_hoofspa", "interior_wall_decals_hoofspa",
        "pillar_corner",
        nil, nil, nil, nil, nil, nil, cornerbeam_placer_postinit_fn)


-- WALL ORNAMENTS



--placeTestWallFlatFn
