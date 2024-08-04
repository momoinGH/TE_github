PrefabFiles = {
    "boatcork",
    "frog_poison",
    -- "frog_poison2",
    "oxherd",
    "oxherd",
    "grass_tall",
    "deep_jungle_fern_noise",
    "vampirebatcave",
    "vampirebatcave_interior",
    "vampitecave_deco",
    "roc_cave_entrance",
    "roc_cave_interior",

  
  
  

    ------------------------------------------------------------------------------------------------

    "roc_leg",
    "roc_head",
    "roc_tail",
    "hippo_antler",
    "hippoherd",
    "hippoptamoose",
    "lillypad",
    "lotus",
    "lotus_flower1",
    "bill",
    "bill_quill",
    "reeds_water",
    "topiary",
    "lawnornaments",
    "hedge",
    "clippings",
    "city_lamp",
    "hamlet_cones",
    "securitycontract",
    "city_hammer",
    "magnifying_glass",
    "pigbandit",
    "banditmap",
    "pig_shop",
    "pig_shop_produce_interior",
    "pig_shop_hoofspa_interior",
    "pig_shop_general_interior",
    "pig_shop_florist_interior",
    "pig_shop_deli_interior",
    "pig_shop_academy_interior",
    "pig_shop_cityhall_interior",
    "pig_shop_cityhall_player_interior",
    "pig_shop_hatshop_interior",
    "pig_shop_weapons_interior",
    "pig_shop_bank_interior",
    "pig_shop_arcane_interior",
    "pig_shop_antiquities_interior",
    "pig_shop_tinker_interior",
    "pig_palace_interior",
    "pig_palace",
    "pigman_shopkeeper_desk",
    "shop_pedestals",
    "deed",
    "playerhouse_city_interior",
    "playerhouse_city_interior2",
    "shelf",
    "shelf_slot",
    "trinkets_giftshop",
    "key_to_city",
    "wallpaper",
    "player_house_kits",
    "player_house",
    "pigman_city",
    "pighouse_city",
    "pig_guard_tower",
    "armor_metal",
    "reconstruction_project",
    "water_spray",
    "water_pipe",
    "sprinkler1",
    "alloy",
    "smelter",
    "halberd",
    "oinc",
    "oinc10",
    "oinc100",
    "porklandintro",
    "rainforesttrees",
    "rainforesttree_sapling",
    "meteor_impact",
    "tuber",
    "tubertrees",
    "pangolden",
    "thunderbird",
    "thunderbirdnest",
    "ancient_robots",
    "ancient_hulk",
    "ancient_herald",
    "armor_vortex_cloak",
    "living_artifact",
    "rock_basalt",
    "ancient_robots_assembly",
    "laser_ring",
    "laser",
    "iron",
    "pheromonestone",
}












if GetModConfigData("luajit") then
    table.insert(PrefabFiles, "pig_ruins_maze_old")
else
    if GetModConfigData("compactruins") then
        table.insert(PrefabFiles, "pig_ruins_mazecompact")
    else
        table.insert(PrefabFiles, "pig_ruins_maze")
    end
end

table.insert(PrefabFiles, "anthill_interior")
table.insert(PrefabFiles, "anthill_lamp")
table.insert(PrefabFiles, "anthill_stalactite")
table.insert(PrefabFiles, "antchest")
table.insert(PrefabFiles, "corkchest")
table.insert(PrefabFiles, "antcombhomecave")
table.insert(PrefabFiles, "giantgrub")
table.insert(PrefabFiles, "antqueen")
table.insert(PrefabFiles, "rocksham")
table.insert(PrefabFiles, "deco_ruins_fountain")

table.insert(PrefabFiles, "pig_ruins_entrance_interior")
table.insert(PrefabFiles, "pig_ruins_entrance")
table.insert(PrefabFiles, "pig_ruins_dart_statue")
table.insert(PrefabFiles, "pig_ruins_dart")
table.insert(PrefabFiles, "pig_ruins_creeping_vines")
table.insert(PrefabFiles, "pig_ruins_pressure_plate")
table.insert(PrefabFiles, "pig_ruins_spear_trap")
table.insert(PrefabFiles, "smashingpot")
table.insert(PrefabFiles, "pig_ruins_light_beam")
table.insert(PrefabFiles, "littlehammer")
table.insert(PrefabFiles, "relics")
table.insert(PrefabFiles, "gascloud")
table.insert(PrefabFiles, "bugrepellent")


table.insert(PrefabFiles, "teatree_nut")
table.insert(PrefabFiles, "teatrees")
table.insert(PrefabFiles, "piko")
table.insert(PrefabFiles, "clawpalmtrees")
table.insert(PrefabFiles, "clawpalmtree_sapling")
table.insert(PrefabFiles, "bugfood")
table.insert(PrefabFiles, "rock_flippable")
table.insert(PrefabFiles, "peagawkfeather")
table.insert(PrefabFiles, "peagawk")
table.insert(PrefabFiles, "aloe")
table.insert(PrefabFiles, "pog")
table.insert(PrefabFiles, "weevole")
table.insert(PrefabFiles, "weevole_carapace")
table.insert(PrefabFiles, "armor_weevole")
table.insert(PrefabFiles, "pugalisk")
table.insert(PrefabFiles, "pugalisk_trap_door")
table.insert(PrefabFiles, "pugalisk_ruins_pillar")
table.insert(PrefabFiles, "pugalisk_fountain")
table.insert(PrefabFiles, "waterdrop")
table.insert(PrefabFiles, "floweroflife")
table.insert(PrefabFiles, "gaze_beam")
table.insert(PrefabFiles, "snake_bone")
table.insert(PrefabFiles, "mandrakehouse")
table.insert(PrefabFiles, "mandrakeman")

table.insert(PrefabFiles, "jungle_border_vine")
table.insert(PrefabFiles, "light_rays_ham")
table.insert(PrefabFiles, "nettle")
table.insert(PrefabFiles, "nettle_plant")
table.insert(PrefabFiles, "rainforesttrees")
table.insert(PrefabFiles, "rainforesttree_sapling")
table.insert(PrefabFiles, "tree_pillar")
table.insert(PrefabFiles, "flower_rainforest")
table.insert(PrefabFiles, "pig_ruins_torch")
table.insert(PrefabFiles, "mean_flytrap")
table.insert(PrefabFiles, "radish")
table.insert(PrefabFiles, "adult_flytrap")
table.insert(PrefabFiles, "antman_warrior_egg")
table.insert(PrefabFiles, "antman_warrior")
table.insert(PrefabFiles, "antman")
table.insert(PrefabFiles, "antlarva")
table.insert(PrefabFiles, "anthill")
table.insert(PrefabFiles, "antsuit")
table.insert(PrefabFiles, "venus_stalk")
table.insert(PrefabFiles, "walkingstick")
table.insert(PrefabFiles, "cloudpuff")
