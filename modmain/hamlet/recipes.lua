local Ig = Ingredient

-- 角色
TroAddRecipe("poisonbalm", { Ig("livinglog", 1), Ig("venomgland", 1) }, TECH.NONE, { builder_tag = "plantkin" }, { "CHARACTER" })


-- OTHER--
TroAddRecipe("machete", { Ig("flint", 3), Ig("twigs", 1) }, TECH.NONE, nil, { "TOOLS" })
TroAddRecipe("goldenmachete", { Ig("twigs", 4), Ig("goldnugget", 2) }, TECH.SCIENCE_TWO, nil, { "TOOLS" })
TroAddRecipe("shears", { Ig("twigs", 2), Ig("iron", 2) }, TECH.SCIENCE_ONE, nil, { "TOOLS" })
TroAddRecipe("bugrepellent", { Ig("tuber_crop", 6), Ig("venus_stalk", 1) }, TECH.SCIENCE_ONE, nil, { "TOOLS" })
TroAddRecipe("antler", { Ig("hippo_antler", 1), Ig("bill_quill", 3), Ig("flint", 1) }, TECH.SCIENCE_ONE, nil, { "TOOLS" })
TroAddRecipe("bathat", { Ig("pigskin", 2), Ig("batwing", 1), Ig("compass", 1) }, TECH.SCIENCE_TWO, nil, { "LIGHT" })
TroAddRecipe("candlehat", { Ig("cork", 4), Ig("iron", 2) }, TECH.SCIENCE_ONE, nil, { "LIGHT" })
TroAddRecipe("goldnugget_ham", { Ig("gold_dust", 6) }, TECH.SCIENCE_ONE, { product = "goldnugget", }, { "REFINE" })
TroAddRecipe("armor_weevole", { Ig("weevole_carapace", 4), Ig("chitin", 2) }, TECH.SCIENCE_TWO, nil, { "ARMOUR", "RAIN" })
TroAddRecipe("antsuit", { Ig("chitin", 5), Ig("armorwood", 1) }, TECH.SCIENCE_ONE, nil, { "ARMOUR" })
TroAddRecipe("antmaskhat", { Ig("chitin", 5), Ig("footballhat", 1) }, TECH.SCIENCE_ONE, nil, { "ARMOUR" })
TroAddRecipe("metalplatehat", { Ig("alloy", 3), Ig("cork", 3) }, TECH.SCIENCE_ONE, nil, { "ARMOUR" })
TroAddRecipe("armor_metalplate", { Ig("alloy", 3), Ig("hammer", 1) }, TECH.SCIENCE_ONE, nil, { "ARMOUR" })
TroAddRecipe("halberd", { Ig("alloy", 1), Ig("twigs", 2) }, TECH.SCIENCE_ONE, nil, { "WEAPONS", "TOOLS" })
TroAddRecipe("cork_bat", { Ig("cork", 3), Ig("boards", 1) }, TECH.SCIENCE_ONE, nil, { "WEAPONS" })
TroAddRecipe("blunderbuss", { Ig("oinc10", 1), Ig("boards", 2), Ig("gears", 1) }, TECH.SCIENCE_ONE, nil, { "WEAPONS" })
TroAddRecipe("corkchest", { Ig("cork", 2), Ig("rope", 1) }, TECH.SCIENCE_ONE, { min_spacing = 1, placer = "corkchest_placer" }, { "CONTAINERS", "STRUCTURES" })
TroAddRecipe("roottrunk_child", { Ig("bramble_bulb", 1), Ig("venus_stalk", 2), Ig("boards", 2) }, TECH.SCIENCE_ONE, { min_spacing = 1, placer = "roottrunk_child_placer" }, { "CONTAINERS", "STRUCTURES" })
TroAddRecipe("basefan", { Ig("alloy", 2), Ig("transistor", 2), Ig("gears", 1) }, TECH.SCIENCE_TWO, { placer = "basefan_placer" }, { "STRUCTURES", "SUMMER" })
TroAddRecipe("sprinkler", { Ig("alloy", 2), Ig("bluegem", 1), Ig("ice", 6) }, TECH.SCIENCE_TWO, { placer = "sprinkler_placer" }, { "GARDENING" })
TroAddRecipe("smelter", { Ig("cutstone", 6), Ig("boards", 4), Ig("redgem", 1) }, TECH.SCIENCE_TWO, { placer = "smetler_placer" }, { "STRUCTURES", "PROTOTYPERS" })
TroAddRecipe("disguisehat", { Ig("twigs", 2), Ig("pigskin", 1), Ig("beardhair", 1) }, TECH.SCIENCE_TWO, nil, { "CLOTHING" })
TroAddRecipe("pithhat", { Ig("fabric", 1), Ig("vine", 3), Ig("cork", 6) }, TECH.SCIENCE_TWO, nil, { "CLOTHING" })
TroAddRecipe("thunderhat", { Ig("feather_thunder", 1), Ig("goldnugget", 1), Ig("cork", 2) }, TECH.SCIENCE_TWO, nil, { "CLOTHING" })
TroAddRecipe("gasmaskhat", { Ig("peagawkfeather", 4), Ig("fabric", 1), Ig("pigskin", 1) }, TECH.SCIENCE_ONE, nil, { "CLOTHING" })

TroAddRecipe("bonestaff", { Ig("pugalisk_skull", 1), Ig("boneshard", 1), Ig("nightmarefuel", 2) }, TECH.LOST, nil, { "MAGIC" })
TroAddRecipe("armorvortexcloak", { Ig("ancient_remnant", 5), Ig("armor_sanity", 1) }, TECH.LOST, nil, { "ARMOUR", "MAGIC", "CONTAINERS" })
TroAddRecipe("armorvoidcloak", { Ig("armorvortexcloak", 1), Ig("horrorfuel", 4), Ig("voidcloth", 4), Ig("shadowheart", 1) }, TECH.SHADOWFORGING_TWO, { nounlock = true }, { "CRAFTING_STATION" })
TroAddRecipe("living_artifact", { Ig("infused_iron", 6), Ig("waterdrop", 1) }, TECH.LOST, nil, { "MAGIC" })
TroAddRecipe("honeychest", { Ig("chitin", 6), Ig("beeswax", 1), Ig("honey", 3) }, TECH.LOST, { min_spacing = 1, placer = "honeychest_placer" }, { "STRUCTURES", "CONTAINERS", "COOKING", "GARDENING" })
TroAddRecipe("hogusporkusator", { Ig("pigskin", 4), Ig("boards", 4), Ig("feather_robin_winter", 4) }, TECH.SCIENCE_ONE, { placer = "hogusporkusator_placer" }, { "PROTOTYPERS", "MAGIC", "STRUCTURES" })
TroAddRecipe("clawpalmtree_cone", { Ig("cork", 1), Ig("poop", 1) }, TECH.SCIENCE_ONE, {}, { "REFINE" })
TroAddRecipe("venomgland", { Ig("froglegs_poison", 3) }, TECH.SCIENCE_TWO, {}, { "REFINE" })

--地皮
TroAddRecipe("turf_fields", { Ig("turf_rainforest", 1), Ig("ash", 1) }, TECH.SCIENCE_TWO, { numtogive = 4 }, { "DECOR" })
TroAddRecipe("turf_deeprainforest_nocanopy", { Ig("bramble_bulb", 1), Ig("cutgrass", 2), Ig("ash", 1) }, TECH.SCIENCE_TWO, { numtogive = 4 }, { "DECOR" })

----------------------------------------------------------------------------------------------------

TroAddTech("CITY", {
    max_level = 1,
    atlas = "images/tabs.xml",
    image = "tab_city.tex"
})

TroAddPrototyperDef("key_to_city", {
    icon_atlas = "images/tabs.xml",
    icon_image = "tab_city.tex",
    is_crafting_station = true,
})

local function AddCityRecipe(name, ingredients, data)
    data = data or {}
    data.nounlock = true --不需要解锁，靠近就能做，远离就不能做
    return TroAddRecipe(name, ingredients, TECH.CITY_ONE, data, { "CITY" })
end


AddCityRecipe("city_hammer", { Ig("iron", 2), Ig("twigs", 1) })
AddCityRecipe("securitycontract", { Ig("oinc", 10) })
AddCityRecipe("turf_foundation", { Ig("cutstone", 1) }, { numtogive = 4 })
AddCityRecipe("turf_cobbleroad", { Ig("cutstone", 2), Ig("boards", 1) }, { numtogive = 4 })
AddCityRecipe("turf_lawn", { Ig("cutgrass", 2), Ig("nitre", 1) }, { numtogive = 4 })
AddCityRecipe("turf_pigruins", { Ig("cutstone", 4), Ig("rocks", 2) }, { numtogive = 4, })
AddCityRecipe("city_lamp", { Ig("alloy", 1), Ig("transistor", 1), Ig("lantern", 1) }, { min_spacing = 1, placer = "city_lamp_placer" })
AddCityRecipe("playerhouse_city_entrance", { Ig("boards", 4), Ig("cutstone", 3), Ig("oinc", 30) }, { min_spacing = 1, placer = "deed_placer", image = "pig_house_sale.png" })
AddCityRecipe("pighouse_city", { Ig("boards", 4), Ig("cutstone", 3), Ig("pigskin", 4) }, { min_spacing = 1, placer = "pighouse_city_placer" })
AddCityRecipe("pig_guard_tower", { Ig("cutstone", 3), Ig("halberd", 1), Ig("pigskin", 4) }, { min_spacing = 1, placer = "pig_guard_tower_placer" })
AddCityRecipe("pig_guard_tower_palace", { Ig("cutstone", 5), Ig("halberd", 1), Ig("pigskin", 4) }, { min_spacing = 1, placer = "pig_guard_tower_palace_placer", image = "pig_royal_tower.png" })
AddCityRecipe("pig_shop_cityhall_player_entrance", { Ig("boards", 4), Ig("goldnugget", 4), Ig("pigskin", 4) }, { min_spacing = 1, placer = "pig_shop_cityhall_placer", image = "pig_shop_cityhall.png" })
AddCityRecipe("pig_shop_deli_entrance", { Ig("boards", 4), Ig("honeyham", 1), Ig("pigskin", 4) }, { min_spacing = 1, placer = "pig_shop_deli_placer", image = "pig_shop_deli.png" })
AddCityRecipe("pig_shop_general_entrance", { Ig("boards", 4), Ig("axe", 3), Ig("pigskin", 4) }, { min_spacing = 1, placer = "pig_shop_general_placer", image = "pig_shop_general.png" })
AddCityRecipe("pig_shop_hoofspa_entrance", { Ig("boards", 4), Ig("bandage", 3), Ig("pigskin", 4) }, { min_spacing = 1, placer = "pig_shop_hoofspa_placer", image = "pig_shop_hoofspa.png" })
AddCityRecipe("pig_shop_produce_entrance", { Ig("boards", 4), Ig("eggplant", 3), Ig("pigskin", 4) }, { min_spacing = 1, placer = "pig_shop_produce_placer", image = "pig_shop_produce.png" })
AddCityRecipe("pig_shop_florist_entrance", { Ig("boards", 4), Ig("petals", 12), Ig("pigskin", 4) }, { min_spacing = 1, placer = "pig_shop_florist_placer", image = "pig_shop_florist.png" })
AddCityRecipe("pig_antiquities_entrance", { Ig("boards", 4), Ig("ballpein_hammer", 3), Ig("pigskin", 4) }, { min_spacing = 1, placer = "pig_shop_antiquities_placer", image = "pig_shop_antiquities.png" })
AddCityRecipe("pig_shop_arcane_entrance", { Ig("boards", 4), Ig("nightmarefuel", 1), Ig("pigskin", 4) }, { min_spacing = 1, placer = "pig_shop_arcane_placer", image = "pig_shop_arcane.png" })
AddCityRecipe("pig_shop_weapons_entrance", { Ig("boards", 4), Ig("spear", 3), Ig("pigskin", 4) }, { min_spacing = 1, placer = "pig_shop_weapons_placer", image = "pig_shop_weapons.png" })
AddCityRecipe("pig_academy_entrance", { Ig("boards", 4), Ig("cutstone", 3), Ig("pigskin", 4) }, { min_spacing = 1, placer = "pig_shop_academy_placer", image = "pig_shop_academy.png" })
AddCityRecipe("hatshop_entrance", { Ig("boards", 4), Ig("tophat", 2), Ig("pigskin", 4) }, { min_spacing = 1, placer = "pig_shop_hatshop_placer", image = "pig_shop_hatshop.png" })
AddCityRecipe("pig_shop_bank_entrance", { Ig("cutstone", 4), Ig("oinc", 100), Ig("pigskin", 4) }, { min_spacing = 1, placer = "pig_shop_bank_placer", image = "pig_shop_bank.png" })
AddCityRecipe("pig_shop_tinker_entrance", { Ig("magnifying_glass", 2), Ig("pigskin", 4) }, { min_spacing = 1, placer = "pig_shop_tinker_placer", image = "pig_shop_tinker.png" })
AddCityRecipe("hedge_block_item", { Ig("clippings", 9), Ig("nitre", 1) }, { numtogive = 3, })
AddCityRecipe("hedge_cone_item", { Ig("clippings", 9), Ig("nitre", 1) }, { numtogive = 3, })
AddCityRecipe("hedge_layered_item", { Ig("clippings", 9), Ig("nitre", 1) }, { numtogive = 3, })
AddCityRecipe("lawnornament_1", { Ig("cutstone", 2), Ig("oinc", 7) }, { min_spacing = 1, placer = "lawnornament_1_placer" })
AddCityRecipe("lawnornament_2", { Ig("cutstone", 2), Ig("oinc", 7) }, { min_spacing = 1, placer = "lawnornament_2_placer" })
AddCityRecipe("lawnornament_3", { Ig("cutstone", 2), Ig("oinc", 7) }, { min_spacing = 1, placer = "lawnornament_3_placer" })
AddCityRecipe("lawnornament_4", { Ig("cutstone", 2), Ig("oinc", 7) }, { min_spacing = 1, placer = "lawnornament_4_placer" })
AddCityRecipe("lawnornament_5", { Ig("cutstone", 2), Ig("oinc", 7) }, { min_spacing = 1, placer = "lawnornament_5_placer" })
AddCityRecipe("lawnornament_6", { Ig("cutstone", 2), Ig("oinc", 7) }, { min_spacing = 1, placer = "lawnornament_6_placer" })
AddCityRecipe("lawnornament_7", { Ig("cutstone", 2), Ig("oinc", 7) }, { min_spacing = 1, placer = "lawnornament_7_placer" })
AddCityRecipe("topiary_1", { Ig("oinc", 10) }, { min_spacing = 1, placer = "topiary_1_placer", atlas = "minimap/minimap_hamlet.xml", image = "topiary_1.png" }) --没图片，拿小地图图片凑合一下
AddCityRecipe("topiary_2", { Ig("oinc", 10) }, { min_spacing = 1, placer = "topiary_2_placer", atlas = "minimap/minimap_hamlet.xml", image = "topiary_2.png" })
AddCityRecipe("topiary_3", { Ig("oinc", 12) }, { min_spacing = 1, placer = "topiary_3_placer", atlas = "minimap/minimap_hamlet.xml", image = "topiary_3.png" })
AddCityRecipe("topiary_4", { Ig("oinc", 12) }, { min_spacing = 1, placer = "topiary_4_placer", atlas = "minimap/minimap_hamlet.xml", image = "topiary_4.png" })


----------------------------------------------------------------------------------------------------

AddRecipeFilter({ name = "ARCHAEOLOGY", atlas = "images/tabs.xml", image = "tab_archaeology.tex" })

--ARCHAEOLOGY--
--TroAddRecipe("disarming_kit",         {Ig("iron", 2), Ig("cutreeds", 2)},                             TECH.NONE, nil,   {"TOOLS", "ARCHAEOLOGY"})--陷阱拆除工具(未来)
TroAddRecipe("goldpan", { Ig("iron", 2), Ig("hammer", 1) }, TECH.SCIENCE_ONE, nil, { "TOOLS", "ARCHAEOLOGY" })
TroAddRecipe("ballpein_hammer", { Ig("iron", 2), Ig("twigs", 1) }, TECH.SCIENCE_ONE, nil, { "TOOLS", "ARCHAEOLOGY" })
TroAddRecipe("magnifying_glass", { Ig("iron", 1), Ig("twigs", 1), Ig("bluegem", 1) }, TECH.SCIENCE_TWO, nil, { "TOOLS", "ARCHAEOLOGY" })



-- SEAFARING--
TroAddRecipe("boatmetal_item", { Ig("alloy", 4), Ig("iron", 4) }, TECH.SEAFARING_TWO, nil, { "SEAFARING" })


----------------------------------------------------------------------------------------------------
-- 小房子科技
TroAddTech("HOME", {
    max_level = 2,
    atlas = "images/tabs.xml",
    image = "tab_home_decor.tex",
    has_filter = true,
})

TroAddPrototyperDef("wallrenovation", {
    icon_image = "tab_home_decor.tex",
    icon_atlas = "images/tabs.xml",
    is_crafting_station = true
})

---@param id number|nil 不填/10/100
local function OincIg(val, id)
    return Ig("oinc", val, nil, nil, "oinc" .. (id or "") .. ".tex")
end

local function AddHomeRecipe(name, cost, placer, image, data)
    data = data or {}
    local ingredients = data.ingredients or {}
    if cost and cost > 0 then
        table.insert(ingredients, OincIg(cost))
    end

    data.nounlock = true
    data.no_deconstruction = true
    data.placer = placer
    data.image = image
    -- data.min_spacing = 0 --最小建造间距

    return TroAddRecipe(name, ingredients, TECH.HOME_TWO, data, { "HOME" })
end

--房屋扩建许可证
AddHomeRecipe("construction_permit", 50)

-- 地板
AddHomeRecipe("interior_floor_wood", 5)
AddHomeRecipe("interior_floor_marble", 15)
AddHomeRecipe("interior_floor_check", 7)
AddHomeRecipe("interior_floor_plaid_tile", 10)
AddHomeRecipe("interior_floor_sheet_metal", 6)
AddHomeRecipe("interior_floor_gardenstone", 10)
AddHomeRecipe("interior_floor_geometrictiles", 12)
AddHomeRecipe("interior_floor_shag_carpet", 6)
AddHomeRecipe("interior_floor_transitional", 6)
AddHomeRecipe("interior_floor_woodpanels", 10)
AddHomeRecipe("interior_floor_herringbone", 12)
AddHomeRecipe("interior_floor_hexagon", 12)
AddHomeRecipe("interior_floor_hoof_curvy", 12)
AddHomeRecipe("interior_floor_octagon", 12)

-- 墙纸
AddHomeRecipe("interior_wall_wood", 1)
AddHomeRecipe("interior_wall_checkered", 6)
AddHomeRecipe("interior_wall_floral", 6)
AddHomeRecipe("interior_wall_sunflower", 6)
AddHomeRecipe("interior_wall_harlequin", 10)
AddHomeRecipe("interior_wall_peagawk", 6)
AddHomeRecipe("interior_wall_plain_ds", 4)
AddHomeRecipe("interior_wall_plain_rog", 4)
AddHomeRecipe("interior_wall_rope", 6)
AddHomeRecipe("interior_wall_circles", 10)
AddHomeRecipe("interior_wall_marble", 15)
AddHomeRecipe("interior_wall_mayorsoffice", 15)
AddHomeRecipe("interior_wall_fullwall_moulding", 15)
AddHomeRecipe("interior_wall_upholstered", 8)

-- 窗帘
-- 把单机版没加的窗帘全加上，不过图标可能没有，用其他reno_window_round_burlap的图标替代
AddHomeRecipe("window_round_backwall", 3, "window_round_backwall_placer", "reno_window_round_burlap.tex")
AddHomeRecipe("window_round_burlap_backwall", 3, "window_round_burlap_backwall_placer", "reno_window_round_burlap.tex")
AddHomeRecipe("window_small_peaked_backwall", 3, "window_small_peaked_backwall_placer", "reno_window_small_peaked.tex")
AddHomeRecipe("window_large_square_backwall", 4, "window_large_square_backwall_placer", "reno_window_large_square.tex")
AddHomeRecipe("window_tall_backwall", 4, "window_tall_backwall_placer", "reno_window_tall.tex")
AddHomeRecipe("window_round_arcane_backwall", 4, "window_round_arcane_backwall_placer", "reno_window_round_burlap.tex")
AddHomeRecipe("window_small_peaked_curtain_backwall", 3, "window_small_peaked_curtain_backwall_placer", "reno_window_small_peaked_curtain.tex")
AddHomeRecipe("window_large_square_curtain_backwall", 5, "window_large_square_curtain_backwall_placer", "reno_window_large_square_curtain.tex")
AddHomeRecipe("window_tall_curtain_backwall", 5, "window_tall_curtain_backwall_placer", "reno_window_round_burlap.tex")
AddHomeRecipe("window_square_weapons_backwall", 4, "window_square_weapons_backwall_placer", "reno_window_tall_curtain.tex")
AddHomeRecipe("window_greenhouse_backwall", 8, "window_greenhouse_backwall_placer", "reno_window_greenhouse.tex")

-- 吊灯
AddHomeRecipe("swinging_light_basic_bulb", 5, "swinging_light_basic_bulb_placer", "reno_light_basic_bulb.tex", { min_spacing = 0 })
AddHomeRecipe("swinging_light_basic_metal", 6, "swinging_light_basic_metal_placer", "reno_light_basic_metal.tex", { min_spacing = 0 })
AddHomeRecipe("swinging_light_chandalier_candles", 8, "swinging_light_chandalier_candles_placer", "reno_light_chandalier_candles.tex", { min_spacing = 0 })
AddHomeRecipe("swinging_light_rope_1", 1, "swinging_light_rope_1_placer", "reno_light_rope_1.tex", { min_spacing = 0 })
AddHomeRecipe("swinging_light_rope_2", 1, "swinging_light_rope_2_placer", "reno_light_rope_2.tex", { min_spacing = 0 })
AddHomeRecipe("swinging_light_floral_bulb", 10, "swinging_light_floral_bulb_placer", "reno_light_floral_bulb.tex", { min_spacing = 0 })
AddHomeRecipe("swinging_light_pendant_cherries", 12, "swinging_light_pendant_cherries_placer", "reno_light_pendant_cherries.tex", { min_spacing = 0 })
AddHomeRecipe("swinging_light_floral_scallop", 12, "swinging_light_floral_scallop_placer", "reno_light_floral_scallop.tex", { min_spacing = 0 })
AddHomeRecipe("swinging_light_floral_bloomer", 12, "swinging_light_floral_bloomer_placer", "reno_light_floral_bloomer.tex", { min_spacing = 0 })
AddHomeRecipe("swinging_light_tophat", 12, "swinging_light_tophat_placer", "reno_light_tophat.tex", { min_spacing = 0 })
AddHomeRecipe("swinging_light_derby", 12, "swinging_light_derby_placer", "reno_light_derby.tex", { min_spacing = 0 })

-- 柱子
AddHomeRecipe("deco_wood_cornerbeam", 1, "deco_wood_cornerbeam_placer", "reno_cornerbeam_wood.tex")
AddHomeRecipe("deco_millinery_cornerbeam", 1, "deco_millinery_cornerbeam_placer", "reno_cornerbeam_millinery.tex")
AddHomeRecipe("deco_round_cornerbeam", 1, "deco_round_cornerbeam_placer", "reno_cornerbeam_round.tex")
AddHomeRecipe("deco_marble_cornerbeam", 5, "deco_marble_cornerbeam_placer", "reno_cornerbeam_marble.tex")

-- 灯
AddHomeRecipe("deco_lamp_fringe", 8, "deco_lamp_fringe_placer", "reno_lamp_fringe.tex")
AddHomeRecipe("deco_lamp_stainglass", 8, "deco_lamp_stainglass_placer", "reno_lamp_stainglass.tex")
AddHomeRecipe("deco_lamp_downbridge", 8, "deco_lamp_downbridge_placer", "reno_lamp_downbridge.tex")
AddHomeRecipe("deco_lamp_2embroidered", 8, "deco_lamp_2embroidered_placer", "reno_lamp_2embroidered.tex")
AddHomeRecipe("deco_lamp_ceramic", 8, "deco_lamp_ceramic_placer", "reno_lamp_ceramic.tex")
AddHomeRecipe("deco_lamp_glass", 8, "deco_lamp_glass_placer", "reno_lamp_glass.tex")
AddHomeRecipe("deco_lamp_2fringes", 8, "deco_lamp_2fringes_placer", "reno_lamp_2fringes.tex")
AddHomeRecipe("deco_lamp_candelabra", 8, "deco_lamp_candelabra_placer", "reno_lamp_candelabra.tex")
AddHomeRecipe("deco_lamp_elizabethan", 8, "deco_lamp_elizabethan_placer", "reno_lamp_elizabethan.tex")
AddHomeRecipe("deco_lamp_gothic", 8, "deco_lamp_gothic_placer", "reno_lamp_gothic.tex")
AddHomeRecipe("deco_lamp_orb", 8, "deco_lamp_orb_placer", "reno_lamp_orb.tex")
AddHomeRecipe("deco_lamp_bellshade", 8, "deco_lamp_bellshade_placer", "reno_lamp_bellshade.tex")
AddHomeRecipe("deco_lamp_crystals", 8, "deco_lamp_crystals_placer", "reno_lamp_crystals.tex")
AddHomeRecipe("deco_lamp_upturn", 8, "deco_lamp_upturn_placer", "reno_lamp_upturn.tex")
AddHomeRecipe("deco_lamp_2upturns", 8, "deco_lamp_2upturns_placer", "reno_lamp_2upturns.tex")
AddHomeRecipe("deco_lamp_spool", 8, "deco_lamp_spool_placer", "reno_lamp_spool.tex")
AddHomeRecipe("deco_lamp_edison", 8, "deco_lamp_edison_placer", "reno_lamp_edison.tex")
AddHomeRecipe("deco_lamp_adjustable", 8, "deco_lamp_adjustable_placer", "reno_lamp_adjustable.tex")
AddHomeRecipe("deco_lamp_rightangles", 8, "deco_lamp_rightangles_placer", "reno_lamp_rightangles.tex")
AddHomeRecipe("deco_lamp_hoofspa", 8, "deco_lamp_hoofspa_placer", "reno_lamp_hoofspa.tex")

-- 桌子
AddHomeRecipe("deco_table_round", 2, "deco_table_round_placer", "reno_table_round.tex")
AddHomeRecipe("deco_table_banker", 4, "deco_table_banker_placer", "reno_table_banker.tex")
AddHomeRecipe("deco_table_diy", 3, "deco_table_diy_placer", "reno_table_diy.tex")
AddHomeRecipe("deco_table_raw", 1, "deco_table_raw_placer", "reno_table_raw.tex")
AddHomeRecipe("deco_table_crate", 1, "deco_table_crate_placer", "reno_table_crate.tex")
AddHomeRecipe("deco_table_chess", 1, "deco_table_chess_placer", "reno_table_chess.tex")

-- 挂墙上的装饰品
AddHomeRecipe("deco_wallornament_photo", 2, "deco_wallornament_photo_placer", "reno_wallornament_photo.tex")
AddHomeRecipe("deco_wallornament_fulllength_mirror", 2, "deco_wallornament_fulllength_mirror_placer", "reno_wallornament_fulllength_mirror.tex")
AddHomeRecipe("deco_wallornament_embroidery_hoop", 3, "deco_wallornament_embroidery_hoop_placer", "reno_wallornament_embroidery_hoop.tex")
AddHomeRecipe("deco_wallornament_mosaic", 4, "deco_wallornament_mosaic_placer", "reno_wallornament_mosaic.tex")
AddHomeRecipe("deco_wallornament_wreath", 4, "deco_wallornament_wreath_placer", "reno_wallornament_wreath.tex")
AddHomeRecipe("deco_wallornament_axe", 5, "deco_wallornament_axe_placer", "reno_wallornament_axe.tex", { ingredients = { Ig("axe", 1) } })
AddHomeRecipe("deco_wallornament_hunt", 5, "deco_wallornament_hunt_placer", "reno_wallornament_hunt.tex", { ingredients = { Ig("spear", 1) } })
AddHomeRecipe("deco_wallornament_periodic_table", 5, "deco_wallornament_periodic_table_placer", "reno_wallornament_periodic_table.tex")
AddHomeRecipe("deco_wallornament_gears_art", 8, "deco_wallornament_gears_art_placer", "reno_wallornament_gears_art.tex")
AddHomeRecipe("deco_wallornament_cape", 5, "deco_wallornament_cape_placer", "reno_wallornament_cape.tex")
AddHomeRecipe("deco_wallornament_no_smoking", 3, "deco_wallornament_no_smoking_placer", "reno_wallornament_no_smoking.tex")
AddHomeRecipe("deco_wallornament_black_cat", 5, "deco_wallornament_black_cat_placer", "reno_wallornament_black_cat.tex")
AddHomeRecipe("deco_antiquities_wallfish", 2, "deco_antiquities_wallfish_placer", "reno_antiquities_wallfish.tex", { ingredients = { Ig("fish", 1) } })
AddHomeRecipe("deco_antiquities_beefalo", 10, "deco_antiquities_beefalo_placer", "reno_antiquities_beefalo.tex", { ingredients = { Ig("horn", 1) } })

--椅子
AddHomeRecipe("deco_chair_classic", 2, "chair_classic_placer", "reno_chair_classic.tex")
AddHomeRecipe("deco_chair_corner", 2, "chair_corner_placer", "reno_chair_corner.tex")
AddHomeRecipe("deco_chair_bench", 2, "chair_bench_placer", "reno_chair_bench.tex")
AddHomeRecipe("deco_chair_horned", 2, "chair_horned_placer", "reno_chair_horned.tex")
AddHomeRecipe("deco_chair_footrest", 2, "chair_footrest_placer", "reno_chair_footrest.tex")
AddHomeRecipe("deco_chair_lounge", 2, "chair_lounge_placer", "reno_chair_lounge.tex")
AddHomeRecipe("deco_chair_massager", 2, "chair_massager_placer", "reno_chair_massager.tex")
AddHomeRecipe("deco_chair_stuffed", 2, "chair_stuffed_placer", "reno_chair_stuffed.tex")
AddHomeRecipe("deco_chair_rocking", 2, "chair_rocking_placer", "reno_chair_rocking.tex")
AddHomeRecipe("deco_chair_ottoman", 2, "chair_ottoman_placer", "reno_chair_ottoman.tex")
AddHomeRecipe("deco_chaise", 15, "deco_chaise_placer", "reno_chair_chaise.tex")

-- 盆栽
AddHomeRecipe("deco_plantholder_basic", 6, "deco_plantholder_basic_placer", "reno_plantholder_basic.tex")
AddHomeRecipe("deco_plantholder_wip", 6, "deco_plantholder_wip_placer", "reno_plantholder_wip.tex")
AddHomeRecipe("deco_plantholder_marble", 6, "deco_plantholder_marble_placer", "reno_plantholder_marble.tex")
AddHomeRecipe("deco_plantholder_bonsai", 6, "deco_plantholder_bonsai_placer", "reno_plantholder_bonsai.tex")
AddHomeRecipe("deco_plantholder_dishgarden", 6, "deco_plantholder_dishgarden_placer", "reno_plantholder_dishgarden.tex")
AddHomeRecipe("deco_plantholder_philodendron", 6, "deco_plantholder_philodendron_placer", "reno_plantholder_philodendron.tex")
AddHomeRecipe("deco_plantholder_orchid", 6, "deco_plantholder_orchid_placer", "reno_plantholder_orchid.tex")
AddHomeRecipe("deco_plantholder_draceana", 6, "deco_plantholder_draceana_placer", "reno_plantholder_draceana.tex")
AddHomeRecipe("deco_plantholder_xerographica", 6, "deco_plantholder_xerographica_placer", "reno_plantholder_xerographica.tex")
AddHomeRecipe("deco_plantholder_birdcage", 6, "deco_plantholder_birdcage_placer", "reno_plantholder_birdcage.tex")
AddHomeRecipe("deco_plantholder_palm", 6, "deco_plantholder_palm_placer", "reno_plantholder_palm.tex")
AddHomeRecipe("deco_plantholder_zz", 6, "deco_plantholder_zz_placer", "reno_plantholder_zz.tex")
AddHomeRecipe("deco_plantholder_fernstand", 6, "deco_plantholder_fernstand_placer", "reno_plantholder_fernstand.tex")
AddHomeRecipe("deco_plantholder_fern", 6, "deco_plantholder_fern_placer", "reno_plantholder_fern.tex")
AddHomeRecipe("deco_plantholder_terrarium", 6, "deco_plantholder_terrarium_placer", "reno_plantholder_terrarium.tex")
AddHomeRecipe("deco_plantholder_plantpet", 6, "deco_plantholder_plantpet_placer", "reno_plantholder_plantpet.tex")
AddHomeRecipe("deco_plantholder_traps", 6, "deco_plantholder_traps_placer", "reno_plantholder_traps.tex")
AddHomeRecipe("deco_plantholder_pitchers", 6, "deco_plantholder_pitchers_placer", "reno_plantholder_pitchers.tex")
AddHomeRecipe("deco_plantholder_winterfeasttreeofsadness", 2, "deco_plantholder_winterfeasttreeofsadness_placer", "reno_plantholder_winterfeasttreeofsadness.tex", { ingredients = { Ig("twigs", 1) } })
AddHomeRecipe("deco_plantholder_winterfeasttree", 50, "deco_plantholder_winterfeasttree_placer", "reno_lamp_festivetree.tex")

-- 门
AddHomeRecipe("wood_door", 10, "wood_door_placer")
AddHomeRecipe("stone_door", 10, "stone_door_placer")
AddHomeRecipe("organic_door", 15, "organic_door_placer")
AddHomeRecipe("iron_door", 15, "iron_door_placer")
AddHomeRecipe("curtain_door", 15, "curtain_door_placer")
AddHomeRecipe("plate_door", 15, "plate_door_placer")
AddHomeRecipe("round_door", 20, "round_door_placer")
AddHomeRecipe("pillar_door", 20, "pillar_door_placer")

-- 地毯
AddHomeRecipe("rug_round", 2, "rug_round_placer", "reno_rug_round.tex", { min_spacing = 0 })
AddHomeRecipe("rug_square", 2, "rug_square_placer", "reno_rug_square.tex", { min_spacing = 0 })
AddHomeRecipe("rug_oval", 2, "rug_oval_placer", "reno_rug_oval.tex", { min_spacing = 0 })
AddHomeRecipe("rug_rectangle", 3, "rug_rectangle_placer", "reno_rug_rectangle.tex", { min_spacing = 0 })
AddHomeRecipe("rug_fur", 5, "rug_fur_placer", "reno_rug_fur.tex", { min_spacing = 0 })
AddHomeRecipe("rug_hedgehog", 5, "rug_hedgehog_placer", "reno_rug_hedgehog.tex", { min_spacing = 0 })
AddHomeRecipe("rug_porcupuss", 10, "rug_porcupuss_placer", "reno_rug_porcupuss.tex", { min_spacing = 0 })
AddHomeRecipe("rug_hoofprint", 5, "rug_hoofprint_placer", "reno_rug_hoofprint.tex", { min_spacing = 0 })
AddHomeRecipe("rug_octagon", 5, "rug_octagon_placer", "reno_rug_octagon.tex", { min_spacing = 0 })
AddHomeRecipe("rug_swirl", 5, "rug_swirl_placer", "reno_rug_swirl.tex", { min_spacing = 0 })
AddHomeRecipe("rug_catcoon", 5, "rug_catcoon_placer", "reno_rug_catcoon.tex", { min_spacing = 0 })
AddHomeRecipe("rug_rubbermat", 5, "rug_rubbermat_placer", "reno_rug_rubbermat.tex", { min_spacing = 0 })
AddHomeRecipe("rug_web", 5, "rug_web_placer", "reno_rug_web.tex", { min_spacing = 0 })
AddHomeRecipe("rug_metal", 5, "rug_metal_placer", "reno_rug_metal.tex", { min_spacing = 0 })
AddHomeRecipe("rug_wormhole", 5, "rug_wormhole_placer", "reno_rug_wormhole.tex", { min_spacing = 0 })
AddHomeRecipe("rug_braid", 5, "rug_braid_placer", "reno_rug_braid.tex", { min_spacing = 0 })
AddHomeRecipe("rug_beard", 5, "rug_beard_placer", "reno_rug_beard.tex", { min_spacing = 0 })
AddHomeRecipe("rug_nailbed", 5, "rug_nailbed_placer", "reno_rug_nailbed.tex", { min_spacing = 0 })
AddHomeRecipe("rug_crime", 5, "rug_crime_placer", "reno_rug_crime.tex", { min_spacing = 0 })
AddHomeRecipe("rug_tiles", 5, "rug_tiles_placer", "reno_rug_tiles.tex", { min_spacing = 0 })

-- 展示柜
AddHomeRecipe("shelves_wood", 2, "shelves_wood_placer", "reno_shelves_wood.tex", { min_spacing = 2 })
AddHomeRecipe("shelves_basic", 2, "shelves_basic_placer", "reno_shelves_basic.tex", { min_spacing = 2 })
AddHomeRecipe("shelves_cinderblocks", 1, "shelves_cinderblocks_placer", "reno_shelves_cinderblocks.tex", { min_spacing = 2 })
AddHomeRecipe("shelves_marble", 8, "shelves_marble_placer", "reno_shelves_marble.tex", { min_spacing = 2 })
AddHomeRecipe("shelves_glass", 8, "shelves_glass_placer", "reno_shelves_glass.tex", { min_spacing = 2 })
AddHomeRecipe("shelves_ladder", 8, "shelves_ladder_placer", "reno_shelves_ladder.tex", { min_spacing = 2 })
AddHomeRecipe("shelves_hutch", 8, "shelves_hutch_placer", "reno_shelves_hutch.tex", { min_spacing = 2 })
AddHomeRecipe("shelves_industrial", 8, "shelves_industrial_placer", "reno_shelves_industrial.tex", { min_spacing = 2 })
AddHomeRecipe("shelves_adjustable", 8, "shelves_adjustable_placer", "reno_shelves_adjustable.tex", { min_spacing = 2 })
AddHomeRecipe("shelves_midcentury", 6, "shelves_midcentury_placer", "reno_shelves_midcentury.tex", { min_spacing = 2 })
AddHomeRecipe("shelves_wallmount", 6, "shelves_wallmount_placer", "reno_shelves_wallmount.tex", { min_spacing = 2 })
AddHomeRecipe("shelves_aframe", 6, "shelves_aframe_placer", "reno_shelves_aframe.tex", { min_spacing = 2 })
AddHomeRecipe("shelves_crates", 6, "shelves_crates_placer", "reno_shelves_crates.tex", { min_spacing = 2 })
AddHomeRecipe("shelves_fridge", 6, "shelves_fridge_placer", "reno_shelves_fridge.tex", { min_spacing = 2 })
AddHomeRecipe("shelves_floating", 6, "shelves_floating_placer", "reno_shelves_floating.tex", { min_spacing = 2 })
AddHomeRecipe("shelves_pipe", 6, "shelves_pipe_placer", "reno_shelves_pipe.tex", { min_spacing = 2 })
AddHomeRecipe("shelves_hattree", 6, "shelves_hattree_placer", "reno_shelves_hattree.tex", { min_spacing = 2 })
AddHomeRecipe("shelves_pallet", 6, "shelves_pallet_placer", "reno_shelves_pallet.tex", { min_spacing = 2 })

-- 床
AddHomeRecipe("bed0", 5, "bed0_placer")
AddHomeRecipe("bed1", 7, "bed1_placer")
AddHomeRecipe("bed2", 10, "bed2_placer")
AddHomeRecipe("bed3", 12, "bed3_placer")
AddHomeRecipe("bed4", 14, "bed4_placer")
AddHomeRecipe("bed5", 16, "bed5_placer")
AddHomeRecipe("bed6", 18, "bed6_placer")
AddHomeRecipe("bed7", 20, "bed7_placer")
AddHomeRecipe("bed8", 22, "bed8_placer")



----------------------------------------------------------------------------------------------------
CONSTRUCTION_PLANS["collapsed_honeychest"] = { Ig("chitin", 3), Ig("beeswax", 1), Ig("honey", 2), Ig("alterguardianhatshard", 1) }
