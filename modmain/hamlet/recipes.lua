local TechTree = require("techtree")

table.insert(TechTree.AVAILABLE_TECH, "HOME") -- 小房子科技

TECH.HOME_TWO = { HOME = 2 }

for i, v in pairs(AllRecipes) do
    v.level.HOME = v.level.HOME or 0
end

RECIPETABS['HOME'] = { str = "HOME", sort = 92, icon = "tab_home_decor.tex", icon_atlas = "images/tabs.xml", crafting_station = true }
AddPrototyperDef("wallrenovation", {
    action_str = "HOME",
    icon_image = "tab_home_decor.tex",
    icon_atlas = "images/tabs.xml",
    is_crafting_station = true
})


-- AddRecipeFilter({ name = "INTERIOR", atlas = tab_atlas, image = "tab_home_decor.tex" })



local h_atlas = "images/inventoryimages/hamletinventory.xml"
local v_atlas = "images/inventoryimages/volcanoinventory.xml"

---@param id number|nil 不填/10/100
local function OincIngredient(val, id)
    return Ingredient("oinc", val, h_atlas, nil, "oinc" .. (id or "") .. ".tex")
end

local function AddHamletRecipe(name, tech, cost, placer, image, data)
    data = data or {}

    local upperName = string.upper(name)
    if not STRINGS.RECIPE_DESC[upperName] then
        local desc = STRINGS.CHARACTERS.GENERIC.DESCRIBE[upperName]
        STRINGS.RECIPE_DESC[upperName] = type(desc) == "table" and next(desc) or desc
    end

    --防止我忘记给某些会生成蓝图配方的预制件起名字，然后就会在生成随机蓝图的时候报错
    assert(data.builder_tag or data.nounlock or STRINGS.NAMES[upperName], "名字缺失: " .. name)

    STRINGS.NAMES[upperName] = STRINGS.NAMES[upperName] or ""

    local ingredients = {}
    if cost and cost > 0 then
        table.insert(ingredients, OincIngredient(cost))
    end
    if data.ingredients then
        ConcatArrays(ingredients, data.ingredients)
    end

    AddRecipe2(name, ingredients, tech, {
        nounlock = data.nounlock,
        no_deconstruction = true,
        description = name,
        placer = placer,
        builder_tag = data.builder_tag,
        min_spacing = data.min_spacing, --最小建造间距
        atlas = data.atlas or h_atlas,
        image = image and (image .. ".tex") or nil
    }, data.filters)
end

local function AddHomeRecipe(name, cost, placer, image, data)
    data = data or {}
    data.filter = { "INTERIOR" }
    data.nounlock = true
    AddHamletRecipe(name, TECH.HOME_TWO, cost, placer, image, data)
end

-- 地板
AddHomeRecipe("interior_floor_wood", 5, nil, "interior_floor_wood")
AddHomeRecipe("interior_floor_marble", 15, nil, "interior_floor_marble")
AddHomeRecipe("interior_floor_check", 7, nil, "interior_floor_check")
AddHomeRecipe("interior_floor_plaid_tile", 10, nil, "interior_floor_plaid_tile")
AddHomeRecipe("interior_floor_sheet_metal", 6, nil, "interior_floor_sheet_metal")
AddHomeRecipe("interior_floor_gardenstone", 10, nil, "interior_floor_gardenstone")
AddHomeRecipe("interior_floor_geometrictiles", 12, nil, "interior_floor_geometrictiles")
AddHomeRecipe("interior_floor_shag_carpet", 6, nil, "interior_floor_shag_carpet")
AddHomeRecipe("interior_floor_transitional", 6, nil, "interior_floor_transitional")
AddHomeRecipe("interior_floor_woodpanels", 10, nil, "interior_floor_woodpanels")
AddHomeRecipe("interior_floor_herringbone", 12, nil, "interior_floor_herringbone")
AddHomeRecipe("interior_floor_hexagon", 12, nil, "interior_floor_hexagon")
AddHomeRecipe("interior_floor_hoof_curvy", 12, nil, "interior_floor_hoof_curvy")
AddHomeRecipe("interior_floor_octagon", 12, nil, "interior_floor_octagon")

-- 墙纸
AddHomeRecipe("interior_wall_wood", 1, nil, "interior_wall_wood")
AddHomeRecipe("interior_wall_checkered", 6, nil, "interior_wall_checkered")
AddHomeRecipe("interior_wall_floral", 6, nil, "interior_wall_floral")
AddHomeRecipe("interior_wall_sunflower", 6, nil, "interior_wall_sunflower")
AddHomeRecipe("interior_wall_harlequin", 10, nil, "interior_wall_harlequin")
AddHomeRecipe("interior_wall_peagawk", 6, nil, "interior_wall_peagawk")
AddHomeRecipe("interior_wall_plain_ds", 4, nil, "interior_wall_plain_ds")
AddHomeRecipe("interior_wall_plain_rog", 4, nil, "interior_wall_plain_rog")
AddHomeRecipe("interior_wall_rope", 6, nil, "interior_wall_rope")
AddHomeRecipe("interior_wall_circles", 10, nil, "interior_wall_circles")
AddHomeRecipe("interior_wall_marble", 15, nil, "interior_wall_marble")
AddHomeRecipe("interior_wall_mayorsoffice", 15, nil, "interior_wall_mayorsoffice")
AddHomeRecipe("interior_wall_fullwall_moulding", 15, nil, "interior_wall_fullwall_moulding")
AddHomeRecipe("interior_wall_upholstered", 8, nil, "interior_wall_upholstered")

-- 窗帘
-- 把单机版没加的窗帘全加上，不过图标可能没有，用其他reno_window_round_burlap的图标替代
AddHomeRecipe("window_round_backwall", 3, "window_round_backwall_placer", "reno_window_round_burlap")
AddHomeRecipe("window_round_burlap_backwall", 3, "window_round_burlap_backwall_placer",
    "reno_window_round_burlap")
AddHomeRecipe("window_small_peaked_backwall", 3, "window_small_peaked_backwall_placer",
    "reno_window_small_peaked")
AddHomeRecipe("window_large_square_backwall", 4, "window_large_square_backwall_placer",
    "reno_window_large_square")
AddHomeRecipe("window_tall_backwall", 4, "window_tall_backwall_placer", "reno_window_tall")
AddHomeRecipe("window_round_arcane_backwall", 4, "window_round_arcane_backwall_placer",
    "reno_window_round_burlap")
AddHomeRecipe("window_small_peaked_curtain_backwall", 3, "window_small_peaked_curtain_backwall_placer",
    "reno_window_small_peaked_curtain")
AddHomeRecipe("window_large_square_curtain_backwall", 5, "window_large_square_curtain_backwall_placer",
    "reno_window_large_square_curtain")
AddHomeRecipe("window_tall_curtain_backwall", 5, "window_tall_curtain_backwall_placer",
    "reno_window_round_burlap")
AddHomeRecipe("window_square_weapons_backwall", 4, "window_square_weapons_backwall_placer",
    "reno_window_tall_curtain")
AddHomeRecipe("window_greenhouse_backwall", 8, "window_greenhouse_backwall_placer",
    "reno_window_greenhouse")

-- 吊灯
AddHomeRecipe("swinging_light_basic_bulb", 5, "swinging_light_basic_bulb_placer", "reno_light_basic_bulb",
    { min_spacing = 0 })
AddHomeRecipe("swinging_light_basic_metal", 6, "swinging_light_basic_metal_placer",
    "reno_light_basic_metal",
    { min_spacing = 0 })
AddHomeRecipe("swinging_light_chandalier_candles", 8, "swinging_light_chandalier_candles_placer",
    "reno_light_chandalier_candles", { min_spacing = 0 })
AddHomeRecipe("swinging_light_rope_1", 1, "swinging_light_rope_1_placer", "reno_light_rope_1",
    { min_spacing = 0 })
AddHomeRecipe("swinging_light_rope_2", 1, "swinging_light_rope_2_placer", "reno_light_rope_2",
    { min_spacing = 0 })
AddHomeRecipe("swinging_light_floral_bulb", 10, "swinging_light_floral_bulb_placer",
    "reno_light_floral_bulb",
    { min_spacing = 0 })
AddHomeRecipe("swinging_light_pendant_cherries", 12, "swinging_light_pendant_cherries_placer",
    "reno_light_pendant_cherries", { min_spacing = 0 })
AddHomeRecipe("swinging_light_floral_scallop", 12, "swinging_light_floral_scallop_placer",
    "reno_light_floral_scallop",
    { min_spacing = 0 })
AddHomeRecipe("swinging_light_floral_bloomer", 12, "swinging_light_floral_bloomer_placer",
    "reno_light_floral_bloomer",
    { min_spacing = 0 })
AddHomeRecipe("swinging_light_tophat", 12, "swinging_light_tophat_placer", "reno_light_tophat",
    { min_spacing = 0 })
AddHomeRecipe("swinging_light_derby", 12, "swinging_light_derby_placer", "reno_light_derby",
    { min_spacing = 0 })

-- 柱子
AddHomeRecipe("deco_wood_cornerbeam", 1, "deco_wood_cornerbeam_placer", "reno_cornerbeam_wood")
AddHomeRecipe("deco_millinery_cornerbeam", 1, "deco_millinery_cornerbeam_placer",
    "reno_cornerbeam_millinery")
AddHomeRecipe("deco_round_cornerbeam", 1, "deco_round_cornerbeam_placer", "reno_cornerbeam_round")
AddHomeRecipe("deco_marble_cornerbeam", 5, "deco_marble_cornerbeam_placer", "reno_cornerbeam_marble")

-- 灯
AddHomeRecipe("deco_lamp_fringe", 8, "deco_lamp_fringe_placer", "reno_lamp_fringe")
AddHomeRecipe("deco_lamp_stainglass", 8, "deco_lamp_stainglass_placer", "reno_lamp_stainglass")
AddHomeRecipe("deco_lamp_downbridge", 8, "deco_lamp_downbridge_placer", "reno_lamp_downbridge")
AddHomeRecipe("deco_lamp_2embroidered", 8, "deco_lamp_2embroidered_placer", "reno_lamp_2embroidered")
AddHomeRecipe("deco_lamp_ceramic", 8, "deco_lamp_ceramic_placer", "reno_lamp_ceramic")
AddHomeRecipe("deco_lamp_glass", 8, "deco_lamp_glass_placer", "reno_lamp_glass")
AddHomeRecipe("deco_lamp_2fringes", 8, "deco_lamp_2fringes_placer", "reno_lamp_2fringes")
AddHomeRecipe("deco_lamp_candelabra", 8, "deco_lamp_candelabra_placer", "reno_lamp_candelabra")
AddHomeRecipe("deco_lamp_elizabethan", 8, "deco_lamp_elizabethan_placer", "reno_lamp_elizabethan")
AddHomeRecipe("deco_lamp_gothic", 8, "deco_lamp_gothic_placer", "reno_lamp_gothic")
AddHomeRecipe("deco_lamp_orb", 8, "deco_lamp_orb_placer", "reno_lamp_orb")
AddHomeRecipe("deco_lamp_bellshade", 8, "deco_lamp_bellshade_placer", "reno_lamp_bellshade")
AddHomeRecipe("deco_lamp_crystals", 8, "deco_lamp_crystals_placer", "reno_lamp_crystals")
AddHomeRecipe("deco_lamp_upturn", 8, "deco_lamp_upturn_placer", "reno_lamp_upturn")
AddHomeRecipe("deco_lamp_2upturns", 8, "deco_lamp_2upturns_placer", "reno_lamp_2upturns")
AddHomeRecipe("deco_lamp_spool", 8, "deco_lamp_spool_placer", "reno_lamp_spool")
AddHomeRecipe("deco_lamp_edison", 8, "deco_lamp_edison_placer", "reno_lamp_edison")
AddHomeRecipe("deco_lamp_adjustable", 8, "deco_lamp_adjustable_placer", "reno_lamp_adjustable")
AddHomeRecipe("deco_lamp_rightangles", 8, "deco_lamp_rightangles_placer", "reno_lamp_rightangles")
AddHomeRecipe("deco_lamp_hoofspa", 8, "deco_lamp_hoofspa_placer", "reno_lamp_hoofspa")

-- 桌子
AddHomeRecipe("deco_table_round", 2, "deco_table_round_placer", "reno_table_round")
-- AddHomeRecipe("deco_table_banker", 4, "deco_table_banker_placer", "reno_table_banker")
AddRecipe2("deco_table_banker", { Ingredient("oinc", 4, h_atlas) }, TECH.HOME_TWO,
    {
        atlas = h_atlas,
        nounlock = true,
        min_spacing = 1,
        placer = "deco_table_banker_placer",
        image =
        "reno_table_banker.tex"
    }, { "INTERIOR" })
AddHomeRecipe("deco_table_diy", 3, "deco_table_diy_placer", "reno_table_diy")
AddHomeRecipe("deco_table_raw", 1, "deco_table_raw_placer", "reno_table_raw")
AddHomeRecipe("deco_table_crate", 1, "deco_table_crate_placer", "reno_table_crate")
AddHomeRecipe("deco_table_chess", 1, "deco_table_chess_placer", "reno_table_chess")

-- 挂墙上的装饰品
AddHomeRecipe("deco_wallornament_photo", 2, "deco_wallornament_photo_placer", "reno_wallornament_photo")
AddHomeRecipe("deco_wallornament_fulllength_mirror", 2, "deco_wallornament_fulllength_mirror_placer",
    "reno_wallornament_fulllength_mirror")
AddHomeRecipe("deco_wallornament_embroidery_hoop", 3, "deco_wallornament_embroidery_hoop_placer",
    "reno_wallornament_embroidery_hoop")
AddHomeRecipe("deco_wallornament_mosaic", 4, "deco_wallornament_mosaic_placer", "reno_wallornament_mosaic")
AddHomeRecipe("deco_wallornament_wreath", 4, "deco_wallornament_wreath_placer", "reno_wallornament_wreath")
AddHomeRecipe("deco_wallornament_axe", 5, "deco_wallornament_axe_placer", "reno_wallornament_axe",
    { ingredients = { Ingredient("axe", 1) } })
AddHomeRecipe("deco_wallornament_hunt", 5, "deco_wallornament_hunt_placer", "reno_wallornament_hunt",
    { ingredients = { Ingredient("spear", 1) } })
AddHomeRecipe("deco_wallornament_periodic_table", 5, "deco_wallornament_periodic_table_placer",
    "reno_wallornament_periodic_table")
AddHomeRecipe("deco_wallornament_gears_art", 8, "deco_wallornament_gears_art_placer",
    "reno_wallornament_gears_art")
AddHomeRecipe("deco_wallornament_cape", 5, "deco_wallornament_cape_placer", "reno_wallornament_cape")
AddHomeRecipe("deco_wallornament_no_smoking", 3, "deco_wallornament_no_smoking_placer",
    "reno_wallornament_no_smoking")
AddHomeRecipe("deco_wallornament_black_cat", 5, "deco_wallornament_black_cat_placer",
    "reno_wallornament_black_cat")
AddHomeRecipe("deco_antiquities_wallfish", 2, "deco_antiquities_wallfish_placer",
    "reno_antiquities_wallfish",
    { ingredients = { Ingredient("fish", 1) } })
AddHomeRecipe("deco_antiquities_beefalo", 10, "deco_antiquities_beefalo_placer", "reno_antiquities_beefalo",
    { ingredients = { Ingredient("horn", 1) } })

--椅子
AddHomeRecipe("deco_chair_classic", 2, "chair_classic_placer", "reno_chair_classic")
AddHomeRecipe("deco_chair_corner", 2, "chair_corner_placer", "reno_chair_corner")
AddHomeRecipe("deco_chair_bench", 2, "chair_bench_placer", "reno_chair_bench")
AddHomeRecipe("deco_chair_horned", 2, "chair_horned_placer", "reno_chair_horned")
AddHomeRecipe("deco_chair_footrest", 2, "chair_footrest_placer", "reno_chair_footrest")
AddHomeRecipe("deco_chair_lounge", 2, "chair_lounge_placer", "reno_chair_lounge")
AddHomeRecipe("deco_chair_massager", 2, "chair_massager_placer", "reno_chair_massager")
AddHomeRecipe("deco_chair_stuffed", 2, "chair_stuffed_placer", "reno_chair_stuffed")
AddHomeRecipe("deco_chair_rocking", 2, "chair_rocking_placer", "reno_chair_rocking")
AddHomeRecipe("deco_chair_ottoman", 2, "chair_ottoman_placer", "reno_chair_ottoman")
AddHomeRecipe("deco_chaise", 15, "deco_chaise_placer", "reno_chair_chaise")

-- 盆栽
AddHomeRecipe("deco_plantholder_basic", 6, "deco_plantholder_basic_placer", "reno_plantholder_basic")
AddHomeRecipe("deco_plantholder_wip", 6, "deco_plantholder_wip_placer", "reno_plantholder_wip")
AddHomeRecipe("deco_plantholder_marble", 6, "deco_plantholder_marble_placer", "reno_plantholder_marble")
AddHomeRecipe("deco_plantholder_bonsai", 6, "deco_plantholder_bonsai_placer", "reno_plantholder_bonsai")
AddHomeRecipe("deco_plantholder_dishgarden", 6, "deco_plantholder_dishgarden_placer",
    "reno_plantholder_dishgarden")
AddHomeRecipe("deco_plantholder_philodendron", 6, "deco_plantholder_philodendron_placer",
    "reno_plantholder_philodendron")
AddHomeRecipe("deco_plantholder_orchid", 6, "deco_plantholder_orchid_placer", "reno_plantholder_orchid")
AddHomeRecipe("deco_plantholder_draceana", 6, "deco_plantholder_draceana_placer",
    "reno_plantholder_draceana")
AddHomeRecipe("deco_plantholder_xerographica", 6, "deco_plantholder_xerographica_placer",
    "reno_plantholder_xerographica")
AddHomeRecipe("deco_plantholder_birdcage", 6, "deco_plantholder_birdcage_placer",
    "reno_plantholder_birdcage")
AddHomeRecipe("deco_plantholder_palm", 6, "deco_plantholder_palm_placer", "reno_plantholder_palm")
AddHomeRecipe("deco_plantholder_zz", 6, "deco_plantholder_zz_placer", "reno_plantholder_zz")
AddHomeRecipe("deco_plantholder_fernstand", 6, "deco_plantholder_fernstand_placer",
    "reno_plantholder_fernstand")
AddHomeRecipe("deco_plantholder_fern", 6, "deco_plantholder_fern_placer", "reno_plantholder_fern")
AddHomeRecipe("deco_plantholder_terrarium", 6, "deco_plantholder_terrarium_placer",
    "reno_plantholder_terrarium")
AddHomeRecipe("deco_plantholder_plantpet", 6, "deco_plantholder_plantpet_placer",
    "reno_plantholder_plantpet")
AddHomeRecipe("deco_plantholder_traps", 6, "deco_plantholder_traps_placer", "reno_plantholder_traps")
AddHomeRecipe("deco_plantholder_pitchers", 6, "deco_plantholder_pitchers_placer",
    "reno_plantholder_pitchers")
AddHomeRecipe("deco_plantholder_winterfeasttreeofsadness", 2,
    "deco_plantholder_winterfeasttreeofsadness_placer",
    "reno_plantholder_winterfeasttreeofsadness", { ingredients = { Ingredient("twigs", 1) } })
AddHomeRecipe("deco_plantholder_winterfeasttree", 50, "deco_plantholder_winterfeasttree_placer",
    "reno_lamp_festivetree")

-- 门
AddHomeRecipe("interior_wood_door", 10, "wood_door_placer", "wood_door")
AddHomeRecipe("interior_stone_door", 10, "stone_door_placer", "stone_door")
AddHomeRecipe("interior_organic_door", 15, "organic_door_placer", "organic_door")
AddHomeRecipe("interior_iron_door", 15, "iron_door_placer", "iron_door")
AddHomeRecipe("interior_curtain_door", 15, "curtain_door_placer", "curtain_door")
AddHomeRecipe("interior_plate_door", 15, "plate_door_placer", "plate_door")
AddHomeRecipe("interior_round_door", 20, "round_door_placer", "round_door")
AddHomeRecipe("interior_pillar_door", 20, "pillar_door_placer", "pillar_door")

-- 地毯
AddHomeRecipe("rug_round", 2, "rug_round_placer", "reno_rug_round", { min_spacing = 0 })
AddHomeRecipe("rug_square", 2, "rug_square_placer", "reno_rug_square", { min_spacing = 0 })
AddHomeRecipe("rug_oval", 2, "rug_oval_placer", "reno_rug_oval", { min_spacing = 0 })
AddHomeRecipe("rug_rectangle", 3, "rug_rectangle_placer", "reno_rug_rectangle", { min_spacing = 0 })
AddHomeRecipe("rug_fur", 5, "rug_fur_placer", "reno_rug_fur", { min_spacing = 0 })
AddHomeRecipe("rug_hedgehog", 5, "rug_hedgehog_placer", "reno_rug_hedgehog", { min_spacing = 0 })
AddHomeRecipe("rug_porcupuss", 10, "rug_porcupuss_placer", "reno_rug_porcupuss", { min_spacing = 0 })
AddHomeRecipe("rug_hoofprint", 5, "rug_hoofprint_placer", "reno_rug_hoofprint", { min_spacing = 0 })
AddHomeRecipe("rug_octagon", 5, "rug_octagon_placer", "reno_rug_octagon", { min_spacing = 0 })
AddHomeRecipe("rug_swirl", 5, "rug_swirl_placer", "reno_rug_swirl", { min_spacing = 0 })
AddHomeRecipe("rug_catcoon", 5, "rug_catcoon_placer", "reno_rug_catcoon", { min_spacing = 0 })
AddHomeRecipe("rug_rubbermat", 5, "rug_rubbermat_placer", "reno_rug_rubbermat", { min_spacing = 0 })
AddHomeRecipe("rug_web", 5, "rug_web_placer", "reno_rug_web", { min_spacing = 0 })
AddHomeRecipe("rug_metal", 5, "rug_metal_placer", "reno_rug_metal", { min_spacing = 0 })
AddHomeRecipe("rug_wormhole", 5, "rug_wormhole_placer", "reno_rug_wormhole", { min_spacing = 0 })
AddHomeRecipe("rug_braid", 5, "rug_braid_placer", "reno_rug_braid", { min_spacing = 0 })
AddHomeRecipe("rug_beard", 5, "rug_beard_placer", "reno_rug_beard", { min_spacing = 0 })
AddHomeRecipe("rug_nailbed", 5, "rug_nailbed_placer", "reno_rug_nailbed", { min_spacing = 0 })
AddHomeRecipe("rug_crime", 5, "rug_crime_placer", "reno_rug_crime", { min_spacing = 0 })
AddHomeRecipe("rug_tiles", 5, "rug_tiles_placer", "reno_rug_tiles", { min_spacing = 0 })

-- 展示柜
AddHomeRecipe("shelves_wood", 2, "shelves_wood_placer", "reno_shelves_wood", { min_spacing = 2 })
AddHomeRecipe("shelves_basic", 2, "shelves_basic_placer", "reno_shelves_basic", { min_spacing = 2 })
AddHomeRecipe("shelves_cinderblocks", 1, "shelves_cinderblocks_placer", "reno_shelves_cinderblocks",
    { min_spacing = 2 })
AddHomeRecipe("shelves_marble", 8, "shelves_marble_placer", "reno_shelves_marble", { min_spacing = 2 })
AddHomeRecipe("shelves_glass", 8, "shelves_glass_placer", "reno_shelves_glass", { min_spacing = 2 })
AddHomeRecipe("shelves_ladder", 8, "shelves_ladder_placer", "reno_shelves_ladder", { min_spacing = 2 })
AddHomeRecipe("shelves_hutch", 8, "shelves_hutch_placer", "reno_shelves_hutch", { min_spacing = 2 })
AddHomeRecipe("shelves_industrial", 8, "shelves_industrial_placer", "reno_shelves_industrial",
    { min_spacing = 2 })
AddHomeRecipe("shelves_adjustable", 8, "shelves_adjustable_placer", "reno_shelves_adjustable",
    { min_spacing = 2 })
AddHomeRecipe("shelves_midcentury", 6, "shelves_midcentury_placer", "reno_shelves_midcentury",
    { min_spacing = 2 })
AddHomeRecipe("shelves_wallmount", 6, "shelves_wallmount_placer", "reno_shelves_wallmount",
    { min_spacing = 2 })
AddHomeRecipe("shelves_aframe", 6, "shelves_aframe_placer", "reno_shelves_aframe", { min_spacing = 2 })
AddHomeRecipe("shelves_crates", 6, "shelves_crates_placer", "reno_shelves_crates", { min_spacing = 2 })
AddHomeRecipe("shelves_fridge", 6, "shelves_fridge_placer", "reno_shelves_fridge", { min_spacing = 2 })
AddHomeRecipe("shelves_floating", 6, "shelves_floating_placer", "reno_shelves_floating",
    { min_spacing = 2 })
AddHomeRecipe("shelves_pipe", 6, "shelves_pipe_placer", "reno_shelves_pipe", { min_spacing = 2 })
AddHomeRecipe("shelves_hattree", 6, "shelves_hattree_placer", "reno_shelves_hattree", { min_spacing = 2 })
AddHomeRecipe("shelves_pallet", 6, "shelves_pallet_placer", "reno_shelves_pallet", { min_spacing = 2 })


AddRecipe2("bed0", { OincIngredient(5) }, TECH.HOME_TWO,
    { atlas = v_atlas, nounlock = true, min_spacing = 1, placer = "bed0_placer" }, { "INTERIOR" })
AddRecipe2("bed1", { OincIngredient(7) }, TECH.HOME_TWO,
    { atlas = v_atlas, nounlock = true, min_spacing = 1, placer = "bed1_placer" }, { "INTERIOR" })
AddRecipe2("bed2", { OincIngredient(10) }, TECH.HOME_TWO,
    { atlas = v_atlas, nounlock = true, min_spacing = 1, placer = "bed2_placer" }, { "INTERIOR" })
AddRecipe2("bed3", { OincIngredient(12) }, TECH.HOME_TWO,
    { atlas = v_atlas, nounlock = true, min_spacing = 1, placer = "bed3_placer" }, { "INTERIOR" })
AddRecipe2("bed4", { OincIngredient(14) }, TECH.HOME_TWO,
    { atlas = v_atlas, nounlock = true, min_spacing = 1, placer = "bed4_placer" }, { "INTERIOR" })
AddRecipe2("bed5", { OincIngredient(16) }, TECH.HOME_TWO,
    { atlas = v_atlas, nounlock = true, min_spacing = 1, placer = "bed5_placer" }, { "INTERIOR" })
AddRecipe2("bed6", { OincIngredient(18) }, TECH.HOME_TWO,
    { atlas = v_atlas, nounlock = true, min_spacing = 1, placer = "bed6_placer" }, { "INTERIOR" })
AddRecipe2("bed7", { OincIngredient(20) }, TECH.HOME_TWO,
    { atlas = v_atlas, nounlock = true, min_spacing = 1, placer = "bed7_placer" }, { "INTERIOR" })
AddRecipe2("bed8", { OincIngredient(22) }, TECH.HOME_TWO,
    { atlas = v_atlas, nounlock = true, min_spacing = 1, placer = "bed8_placer" }, { "INTERIOR" })

    --房屋扩建许可证
AddHomeRecipe("construction_permit", 50)
