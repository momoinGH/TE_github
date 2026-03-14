PrefabFiles = {
    "fryfocals_charge", --镭射焦点
    "goggles",          --镭射焦点
    "hiddendanger_fx",  --陷阱标记
    "thumper",          --撼地者
    "tro_veggies",      --蔬菜
    "antivenom",        --解毒剂
    "armor_void_cloak", --虚空斗篷








    
    "buffs_tro", -- buff集合

    
    "crabapple_tree",
    "debris",
    "feathers_tro",
    "fennel",
    "firetwister_seal",
    "firetwister",
    "fishinholewaterspawner",
    "flood_ice",
    "glass",
    "gorge_portal",
    "grasswaterspawner",
    "grotto_grub_nest",
    "grotto_grub",
    "grotto_parsnip",
    "grottoqueen",
    "icebearger",
    "icedeerclops",
    "icedpad",
    "icerockcreatures",
    "interior_center",
    "jellyfish",
    "ligamundo",
    "machetes",
    "mangrovespawner",
    "marsh_tree_new",
    "maxwellboss",
    "maxwellendgame",
    "maxwellestatua",
    "maxwelllight_flame",
    "maxwelllight",
    "maxwelllock",
    "maxwellminions",
    "maxwellphonograph",
    "maxwellshadowheart",
    "maxwellshadowmeteor",
    "mermhouse_tropical",
    "mermtrader",
    "mushroom_yellow",
    "mushtree_spores_yellow",
    "mushtree_yellow",
    "obsidiancoconade",
    "obsidiancoconadeactive",
    "oxwaterspawner",
    "pig_palace2",
    "pig_shop_spears",
    "piggolem",
    "piggravestone",
    "pigkingstaff",
    "pinkman",
    "pollen_item",
    "seacucumber",
    "slip",
    "slipstor_spawner",
    "slipstor",
    "spider_mutators_new",
    "splash_water",
    "stick_heads",
    "tidalpoolnew",
    "trapslug",
    "tree_forest_deep",
    "tree_forest_rot",
    "tree_forest",
    "tree_forestseed",
    "tro_treasurechest",
    "tropicalspawnblocker",
    "twister_tornadodefogo",
    "vidanomar",
    "vidanomarseaworld",
    "volcano_altar_pillar",
    "wall_invisible",
    "watercress",
    "waterreedspawner",
    "watertree_pillar2",
    "wildbeaver_house",
    "wildbeaver",
    "wildbeaverguard",
    "wildbore_minion",
    "wildboreking_spawner",
    "wildboreking",
}

if TUNING.tropical.tropicalshards ~= 0 then
    table.insert(PrefabFiles, "porkland_sw_entrance")
end

if TUNING.tropical.boat then
    table.insert(PrefabFiles, "pro_pirate_boat_group")
end
