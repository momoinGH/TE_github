PrefabFiles = {
	"fryfocals_charge",
	"goggles",
	"hiddendanger_fx",
	"thumper",
	"tro_veggies",
    "antitoxins",
    "armor_void_cloak",
    "artic_flower",
    "beaverskin",
    "beavertorch",
    "beds",
    "bishopwater",
    "boat_raft_rot",
    "boatmetal",
    "bramble_bush",
    "buffs_tro", -- (Food) Buffs
    "bundled_structure",
    "cave_entrance_vulcao",
    "cave_exit_vulcao",
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
    "sail",
    "seacucumber",
    "shipwrecked_boat_placer",
    "shipwrecked_boat_placer2",
    "shipwrecked_boat",
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
    "tropical_boatlamp",
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

if GetModConfigData("whirlpools") then
    table.insert(PrefabFiles, "whirlpool")
end

if TUNING.tropical.tropicalshards ~= 0 then
    table.insert(PrefabFiles, "porkland_sw_entrance")
end

---------------lillypad biome------------------------
if GetModConfigData("lilypad") then
    table.insert(PrefabFiles, "bill_quill")
    table.insert(PrefabFiles, "bill")
    table.insert(PrefabFiles, "hippo_antler")
    table.insert(PrefabFiles, "hippoherd")
    table.insert(PrefabFiles, "hippoptamoose")
    table.insert(PrefabFiles, "lillypad")
    table.insert(PrefabFiles, "lotus_flower")
    table.insert(PrefabFiles, "lotus")
    table.insert(PrefabFiles, "reeds_water")
end

---------------lavaarena volcano---------------------
if TUNING.tropical.hamlet_caves then
    table.insert(PrefabFiles, "alloy")
    table.insert(PrefabFiles, "armor_metal")
    table.insert(PrefabFiles, "banditmap")
    table.insert(PrefabFiles, "city_hammer")
    table.insert(PrefabFiles, "city_lamp")
    table.insert(PrefabFiles, "clippings")
    table.insert(PrefabFiles, "deed")
    table.insert(PrefabFiles, "halberd")
    table.insert(PrefabFiles, "hamlet_cones")
    table.insert(PrefabFiles, "hedge")
    table.insert(PrefabFiles, "key_to_city")
    table.insert(PrefabFiles, "lawnornaments")
    table.insert(PrefabFiles, "magnifying_glass")
    table.insert(PrefabFiles, "oinc")
    table.insert(PrefabFiles, "oinc10")
    table.insert(PrefabFiles, "oinc100")
    table.insert(PrefabFiles, "pig_guard_tower")
    table.insert(PrefabFiles, "pig_shop")
    table.insert(PrefabFiles, "pigbandit")
    table.insert(PrefabFiles, "pighouse_city")
    table.insert(PrefabFiles, "pigman_city")
    table.insert(PrefabFiles, "pigman_shopkeeper_desk")
    table.insert(PrefabFiles, "player_house_kits")
    table.insert(PrefabFiles, "player_house")
    table.insert(PrefabFiles, "reconstruction_project")
    table.insert(PrefabFiles, "securitycontract")
    table.insert(PrefabFiles, "shelf_slot")
    table.insert(PrefabFiles, "shelf")
    table.insert(PrefabFiles, "shop_pedestals")
    table.insert(PrefabFiles, "smelter")
    table.insert(PrefabFiles, "sprinkler1")
    table.insert(PrefabFiles, "topiary")
    table.insert(PrefabFiles, "trinkets_giftshop")
    table.insert(PrefabFiles, "water_pipe")
    table.insert(PrefabFiles, "water_spray")
end

if TUNING.tropical.multiplayerportal == 15 then
    table.insert(PrefabFiles, "porklandintro")
end

if TUNING.tropical.multiplayerportal == 15
    or TUNING.tropical.hamlet_caves
then
    table.insert(PrefabFiles, "adult_flytrap")
    table.insert(PrefabFiles, "aloe")
    table.insert(PrefabFiles, "ancient_herald")
    table.insert(PrefabFiles, "ancient_hulk")
    table.insert(PrefabFiles, "ancient_robots_assembly")
    table.insert(PrefabFiles, "ancient_robots")
    table.insert(PrefabFiles, "antchest")
    table.insert(PrefabFiles, "antcombhomecave")
    table.insert(PrefabFiles, "anthill_lamp")
    table.insert(PrefabFiles, "anthill_stalactite")
    table.insert(PrefabFiles, "antlarva")
    table.insert(PrefabFiles, "antman_warrior_egg")
    table.insert(PrefabFiles, "antman_warrior")
    table.insert(PrefabFiles, "antman")
    table.insert(PrefabFiles, "antqueen")
    table.insert(PrefabFiles, "antsuit")
    table.insert(PrefabFiles, "armor_vortex_cloak")
    table.insert(PrefabFiles, "armor_weevole")
    table.insert(PrefabFiles, "bugfood")
    table.insert(PrefabFiles, "bugrepellent")
    table.insert(PrefabFiles, "clawpalmtree_sapling")
    table.insert(PrefabFiles, "clawpalmtrees")
    table.insert(PrefabFiles, "cloudpuff")
    table.insert(PrefabFiles, "collapsed_honeychest")
    table.insert(PrefabFiles, "corkchest")
    table.insert(PrefabFiles, "deco_ruins_fountain")
    table.insert(PrefabFiles, "flower_rainforest")
    table.insert(PrefabFiles, "floweroflife")
    table.insert(PrefabFiles, "gascloud")
    table.insert(PrefabFiles, "gaze_beam")
    table.insert(PrefabFiles, "giantgrub")
    table.insert(PrefabFiles, "iron")
    table.insert(PrefabFiles, "jungle_border_vine")
    table.insert(PrefabFiles, "laser_ring")
    table.insert(PrefabFiles, "laser")
    table.insert(PrefabFiles, "light_rays_ham")
    table.insert(PrefabFiles, "littlehammer")
    table.insert(PrefabFiles, "living_artifact")
    table.insert(PrefabFiles, "mandrakehouse")
    table.insert(PrefabFiles, "mandrakeman")
    table.insert(PrefabFiles, "mean_flytrap")
    table.insert(PrefabFiles, "meteor_impact")
    table.insert(PrefabFiles, "nettle_plant")
    table.insert(PrefabFiles, "nettle")
    table.insert(PrefabFiles, "pangolden")
    table.insert(PrefabFiles, "peagawk")
    table.insert(PrefabFiles, "peagawkfeather")
    table.insert(PrefabFiles, "pheromonestone")
    table.insert(PrefabFiles, "pig_ruins_dart_statue")
    table.insert(PrefabFiles, "pig_ruins_dart")
    table.insert(PrefabFiles, "pig_ruins_light_beam")
    table.insert(PrefabFiles, "pig_ruins_pressure_plate")
    table.insert(PrefabFiles, "pig_ruins_spear_trap")
    table.insert(PrefabFiles, "pig_ruins_torch")
    table.insert(PrefabFiles, "piko")
    table.insert(PrefabFiles, "pog")
    table.insert(PrefabFiles, "pugalisk_fountain")
    table.insert(PrefabFiles, "pugalisk_ruins_pillar")
    table.insert(PrefabFiles, "pugalisk_trap_door")
    table.insert(PrefabFiles, "pugalisk")
    table.insert(PrefabFiles, "radish")
    table.insert(PrefabFiles, "rainforesttree_sapling")
    table.insert(PrefabFiles, "rainforesttree_sapling")
    table.insert(PrefabFiles, "rainforesttrees")
    table.insert(PrefabFiles, "rainforesttrees")
    table.insert(PrefabFiles, "relics")
    table.insert(PrefabFiles, "rock_basalt")
    table.insert(PrefabFiles, "rock_flippable")
    table.insert(PrefabFiles, "rocksham")
    table.insert(PrefabFiles, "smashingpot")
    table.insert(PrefabFiles, "snake_bone")
    table.insert(PrefabFiles, "teatree_nut")
    table.insert(PrefabFiles, "teatrees")
    table.insert(PrefabFiles, "thunderbird")
    table.insert(PrefabFiles, "thunderbirdnest")
    table.insert(PrefabFiles, "tree_pillar")
    table.insert(PrefabFiles, "tuber")
    table.insert(PrefabFiles, "tubertrees")
    table.insert(PrefabFiles, "venus_stalk")
    table.insert(PrefabFiles, "walkingstick")
    table.insert(PrefabFiles, "waterdrop")
    table.insert(PrefabFiles, "weevole_carapace")
    table.insert(PrefabFiles, "weevole")
end
