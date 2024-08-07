PrefabFiles =
{
    "shipwrecked_boat",
    "shipwrecked_boat_placer",
    "shipwrecked_boat_placer2",

    "turfesvolcanobiome",
    "venom_gland",
    "machetes",
    "antidote",
    "splash_water",
    "debris", --debris_1, debris_2, debris_3, debris_4 espalhar na praia

    "twister_defogo",
    "twister_tornadodefogo",
    "firetwister_spawner",
    "fire_twister_seal",
    "walani",   --角色
    "wilbur",   --角色
    "woodlegs", --角色
    "glass",
    "flood_ice",
    "mushtree_yellow",
    "mushtree_spores_yellow",
    "bishopwater",
    "seacucumber",
    "watercress",
    "pinkman",
    "piggolem",
    "turfshamlet",

    "boatmetal",
    --"bird_swarm",
    "tropicalspawnblocker",
    -- "swfishbait", --热带鱼饵
    "beds",
    "icebearger",
    "icedeerclops",
    "icerockcreatures",
    "cave_exit_vulcao",
    "cave_entrance_vulcao",
    "vidanomar",
    "vidanomarseaworld",
    "boat_raft_rot",
    "piggravestone",
    "mangrovespawner",
    "oxwaterspawner",
    "grasswaterspawner",
    "waterreedspawner",
    "fishinholewaterspawner",
    "bundled_structure",
    "spider_mutators_new",
    "grotto_grub_nest",
    "grotto_grub",
    "grotto_parsnip",
    "grottoqueen",
    -- otter --水獭，废弃
    "icedpad",
    --"yeti",
    "artic_flower",
    "watertree_pillar2",
    "bramble_bush",
    "tidalpoolnew",
    "marsh_tree_new",
    "ligamundo",
    "armor_void_cloak",
    "bat_leather",
    "gorge_portal",
    "volcano_altar_pillar",
    "pollen_item",
    "hatty_piggy_tfc",
    "boarmound",
    "mermhouse_tropical",
    "mermtrader",
    "wildbeaver",
    "wildbeaver_house",
    "wildbeaverguard",
    "beaverskin",
    "beaver_head",
    "beavertorch",
    "obsidianbomb",
    "obsidianbombactive",
    "maxwellendgame",
    "maxwelllight",
    "maxwelllight_flame",
    "maxwellminions",
    "maxwellboss",
    "maxwelllock",
    "maxwellshadowmeteor",
    "maxwellphonograph",
    "maxwellestatua",
    "maxwellshadowheart",
    "tree_forest",
    "tree_forest_deep",
    "tree_forest_rot",
    "tree_forestseed",
    "trapslug",
    "fennel",
    "pig_palace2",
    "pig_palace2_interior",
    "slipstor",
    "slip",
    "slipstor_spawner",
    "pig_shop_spears",
    "crabapple_tree",
    "wildboreking",
    "wildbore_minion",
    "wildborekingstaff",
    "wildboreking_spawner",

    "buffs_tro", -- (Food) Buffs

}

if GetModConfigData("whirlpools") then
    table.insert(PrefabFiles, "whirlpool")
end

if TUNING.tropical.tropicalshards ~= 0 then
    table.insert(PrefabFiles, "porkland_sw_entrance")
end

if GetModConfigData("raftlog") then
    table.insert(PrefabFiles, "boatraft_old")
    table.insert(PrefabFiles, "boatlog_old")
end

---------------lillypad biome------------------------
if GetModConfigData("lilypad") then
    table.insert(PrefabFiles, "hippo_antler")
    table.insert(PrefabFiles, "hippoherd")
    table.insert(PrefabFiles, "hippoptamoose")
    table.insert(PrefabFiles, "lillypad")
    table.insert(PrefabFiles, "lotus")
    table.insert(PrefabFiles, "lotus_flower1")
    table.insert(PrefabFiles, "bill")
    table.insert(PrefabFiles, "bill_quill")
    table.insert(PrefabFiles, "reeds_water")
end
---------------lavaarena volcano---------------------

if TUNING.tropical.hamlet_caves then
    table.insert(PrefabFiles, "topiary")
    table.insert(PrefabFiles, "lawnornaments")
    table.insert(PrefabFiles, "hedge")
    table.insert(PrefabFiles, "clippings")
    table.insert(PrefabFiles, "city_lamp")
    table.insert(PrefabFiles, "hamlet_cones")
    table.insert(PrefabFiles, "securitycontract")
    table.insert(PrefabFiles, "city_hammer")
    table.insert(PrefabFiles, "magnifying_glass")
    table.insert(PrefabFiles, "pigbandit")
    table.insert(PrefabFiles, "banditmap")
    table.insert(PrefabFiles, "pig_shop")
    table.insert(PrefabFiles, "pig_shop_produce_interior")
    table.insert(PrefabFiles, "pig_shop_hoofspa_interior")
    table.insert(PrefabFiles, "pig_shop_general_interior")
    table.insert(PrefabFiles, "pig_shop_florist_interior")
    table.insert(PrefabFiles, "pig_shop_deli_interior")
    table.insert(PrefabFiles, "pig_shop_academy_interior")

    table.insert(PrefabFiles, "pig_shop_cityhall_interior")
    table.insert(PrefabFiles, "pig_shop_cityhall_player_interior")

    table.insert(PrefabFiles, "pig_shop_hatshop_interior")
    table.insert(PrefabFiles, "pig_shop_weapons_interior")
    table.insert(PrefabFiles, "pig_shop_bank_interior")
    table.insert(PrefabFiles, "pig_shop_arcane_interior")
    table.insert(PrefabFiles, "pig_shop_antiquities_interior")
    table.insert(PrefabFiles, "pig_shop_tinker_interior")
    table.insert(PrefabFiles, "pig_palace_interior")
    table.insert(PrefabFiles, "pig_palace")

    table.insert(PrefabFiles, "pigman_shopkeeper_desk")
    table.insert(PrefabFiles, "shop_pedestals")
    table.insert(PrefabFiles, "deed")
    table.insert(PrefabFiles, "playerhouse_city_interior")
    table.insert(PrefabFiles, "playerhouse_city_interior2")
    table.insert(PrefabFiles, "shelf")
    table.insert(PrefabFiles, "shelf_slot")
    table.insert(PrefabFiles, "trinkets_giftshop")
    table.insert(PrefabFiles, "key_to_city")
    table.insert(PrefabFiles, "wallpaper")
    table.insert(PrefabFiles, "player_house_kits")
    table.insert(PrefabFiles, "player_house")

    table.insert(PrefabFiles, "pigman_city")
    table.insert(PrefabFiles, "pighouse_city")
    table.insert(PrefabFiles, "pig_guard_tower")
    table.insert(PrefabFiles, "armor_metal")
    table.insert(PrefabFiles, "reconstruction_project")
    table.insert(PrefabFiles, "water_spray")
    table.insert(PrefabFiles, "water_pipe")
    table.insert(PrefabFiles, "sprinkler1")
    table.insert(PrefabFiles, "alloy")
    table.insert(PrefabFiles, "smelter")
    table.insert(PrefabFiles, "halberd")
    table.insert(PrefabFiles, "oinc")
    table.insert(PrefabFiles, "oinc10")
    table.insert(PrefabFiles, "oinc100")
end

if TUNING.tropical.multiplayerportal == 15 then
    table.insert(PrefabFiles, "porklandintro")
end


if TUNING.tropical.multiplayerportal == 15
    or TUNING.tropical.hamlet_caves
then
    table.insert(PrefabFiles, "rainforesttrees")
    table.insert(PrefabFiles, "rainforesttree_sapling")
    table.insert(PrefabFiles, "meteor_impact")
    table.insert(PrefabFiles, "tuber")
    table.insert(PrefabFiles, "tubertrees")
    table.insert(PrefabFiles, "pangolden")
    table.insert(PrefabFiles, "thunderbird")
    table.insert(PrefabFiles, "thunderbirdnest")
    table.insert(PrefabFiles, "ancient_robots")
    table.insert(PrefabFiles, "ancient_hulk")
    table.insert(PrefabFiles, "ancient_herald")
    table.insert(PrefabFiles, "armor_vortex_cloak")
    table.insert(PrefabFiles, "living_artifact")
    table.insert(PrefabFiles, "rock_basalt")
    table.insert(PrefabFiles, "ancient_robots_assembly")
    table.insert(PrefabFiles, "laser_ring")
    table.insert(PrefabFiles, "laser")
    table.insert(PrefabFiles, "iron")
    table.insert(PrefabFiles, "pheromonestone")

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
    table.insert(PrefabFiles, "collapsed_honeychest")
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
end
