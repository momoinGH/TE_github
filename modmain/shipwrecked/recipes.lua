local Ig = Ingredient
local v_atlas = "images/inventoryimages/inventory_shipwrecked.xml"
local tab_atlas = "images/tabs.xml"

--火山
TroAddTech("OBSIDIAN", {
    max_level = 1,
    atlas = tab_atlas,
    image = "tab_volcano.tex",
    has_filter = true
})

-- 原型机指定交互和侧边栏
TroAddPrototyperDef("obsidian_workbench", {
    icon_atlas = tab_atlas,
    icon_image = "tab_volcano.tex",
    is_crafting_station = true --是不是一个制作站，如果是就在单独的tab里显示配方
})

--航海过滤器菜单
AddRecipeFilter({ name = "NAUTICAL", atlas = tab_atlas, image = "tab_nautical.tex" })

----------------------------------------------------------------------------------------------------

TroAddRecipe("seaweed_stalk", { Ig("bullkelp_root", 1), Ig("seaweed", 3), Ig(CHARACTER_INGREDIENT.HEALTH, 10) }, TECH.NONE, { builder_tag = "plantkin" }, { "CHARACTER" })
-- WX78--
TroAddRecipe("wx78module_movespeed_sw", { Ig("scandata", 2), Ig("crab", 1) }, TECH.ROBOTMODULECRAFT_ONE, { builder_tag = "upgrademoduleowner", product = "wx78module_movespeed", }, { "CHARACTER" })
-- Moon--
TroAddRecipe("glassmachete", { Ig("twigs", 2), Ig("moonglass", 4) }, TECH.CELESTIAL_THREE, { nounlock = true }, { "CRAFTING_STATION" })


-- OTHER--
TroAddRecipe("machete", { Ig("flint", 3), Ig("twigs", 1) }, TECH.NONE, nil, { "TOOLS" })
TroAddRecipe("goldenmachete", { Ig("twigs", 4), Ig("goldnugget", 2) }, TECH.SCIENCE_TWO, nil, { "TOOLS" })


-- 黑曜石
TroAddRecipe("obsidianaxe", { Ig("axe", 1), Ig("obsidian", 2, v_atlas), Ig("dragoonheart", 1, v_atlas) }, TECH.OBSIDIAN_ONE, { nounlock = true }, { "OBSIDIAN" })
TroAddRecipe("armorobsidian", { Ig("armorwood", 1), Ig("obsidian", 5, v_atlas), Ig("dragoonheart", 1, v_atlas) }, TECH.OBSIDIAN_ONE, { nounlock = true }, { "OBSIDIAN" })
TroAddRecipe("obsidianmachete", { Ig("machete", 1, v_atlas), Ig("obsidian", 3, v_atlas), Ig("dragoonheart", 1, v_atlas) }, TECH.OBSIDIAN_ONE, { nounlock = true }, { "OBSIDIAN" })
TroAddRecipe("spear_obsidian", { Ig("spear", 1), Ig("obsidian", 3, v_atlas), Ig("dragoonheart", 1, v_atlas) }, TECH.OBSIDIAN_ONE, { nounlock = true }, { "OBSIDIAN" })
TroAddRecipe("volcanostaff", { Ig("firestaff", 1), Ig("obsidian", 4, v_atlas), Ig("dragoonheart", 1, v_atlas) }, TECH.OBSIDIAN_ONE, { nounlock = true }, { "OBSIDIAN" })
TroAddRecipe("obsidiancoconade", { Ig("coconade", 3, v_atlas), Ig("obsidian", 3, v_atlas), Ig("dragoonheart", 1, v_atlas) }, TECH.OBSIDIAN_ONE, { nounlock = true, numtogive = 3 }, { "OBSIDIAN" })
TroAddRecipe("obsidian_boatcannon", { Ig("obsidian", 6, v_atlas), Ig("log", 5), Ig("gunpowder", 4) }, TECH.OBSIDIAN_ONE, nil, { "OBSIDIAN" })
TroAddRecipe("wind_conch", { Ig("obsidian", 4, v_atlas), Ig("purplegem", 1), Ig("magic_seal", 1, v_atlas) }, TECH.OBSIDIAN_ONE, { nounlock = true }, { "OBSIDIAN" })
TroAddRecipe("sail_stick", { Ig("obsidian", 2, v_atlas), Ig("nightmarefuel", 3), Ig("magic_seal", 1, v_atlas) }, TECH.OBSIDIAN_ONE, { nounlock = true }, { "OBSIDIAN" })

TroAddRecipe("porto_sea_yard", { Ig("limestone", 6), Ig("tar", 6), Ig("log", 4) }, TECH.SEAFARING_TWO, nil, { "STRUCTURES", "NAUTICAL" })
TroAddRecipe("seatrap", { Ig("palmleaf", 4), Ig("messagebottleempty_sw", 2), Ig("jellyfish", 1) }, TECH.SEAFARING_TWO, nil, { "TOOLS", "GARDENING", "NAUTICAL" })
TroAddRecipe("woodlegshat", { Ig("boneshard", 4), Ig("fabric", 3), Ig("dubloon", 10) }, TECH.NONE, { builder_tag = "woodlegs" }, { "CHARACTER" })
TroAddRecipe("goldnugget_sw", { Ig("dubloon", 3) }, TECH.SCIENCE_ONE, { product = "goldnugget", }, { "REFINE" })
TroAddRecipe("book_meteor", { Ig("papyrus", 2), Ig("obsidian", 2) }, TECH.SCIENCE_TWO, { builder_tag = "bookbuilder", }, { "CHARACTER" })
TroAddRecipe("obsidianfirepit", { Ig("log", 3), Ig("obsidian", 8) }, TECH.SCIENCE_TWO, { placer = "obsidianfirepit_placer" }, { "LIGHT", "COOKING", "WINTER" })
TroAddRecipe("dragoonden", { Ig("dragoonheart", 1), Ig("rocks", 5), Ig("obsidian", 4) }, TECH.SCIENCE_TWO, { placer = "dragoonden_placer" }, { "STRUCTURES" })


----------------------------------------------------------------------------------------------------

-- 小船
TroAddRecipe("porto_armouredboat", { Ig("boards", 6), Ig("rope", 3), Ig("seashell", 10) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
TroAddRecipe("porto_cargoboat", { Ig("boards", 6), Ig("rope", 3) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
TroAddRecipe("porto_encrustedboat", { Ig("boards", 6), Ig("limestone", 4), Ig("rope", 3) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
TroAddRecipe("porto_rowboat", { Ig("boards", 3), Ig("vine", 4) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
TroAddRecipe("porto_woodlegsboat", { Ig("boards", 4), Ig("dubloon", 4), Ig("boatcannon", 1) }, TECH.NONE, { builder_tag = "woodlegs" }, { "CHARACTER" })
TroAddRecipe("porto_shadowboat", { Ig("papyrus", 3), Ig("nightmarefuel", 4), Ig(CHARACTER_INGREDIENT.SANITY, 60) }, TECH.NONE, { builder_tag = "shadowmagic" }, { "CHARACTER" })
TroAddRecipe("corkboatitem", { Ig("rope", 1), Ig("cork", 4) }, TECH.NONE, nil, { "NAUTICAL" })
TroAddRecipe("surfboard_item", { Ig("boards", 1), Ig("seashell", 1) }, TECH.NONE, { builder_tag = "walani" }, { "CHARACTER" })

if TUNING.tropical.only_shipwrecked or GetModConfigData("raftlog") then
    TroAddRecipe("porto_lograft_old", { Ig("log", 6), Ig("cutgrass", 4) }, TECH.NONE, nil, { "NAUTICAL" })
    TroAddRecipe("porto_raft_old", { Ig("bamboo", 4), Ig("vine", 3) }, TECH.NONE, nil, { "NAUTICAL" })
else
    TroAddRecipe("porto_lograft", { Ig("log", 6), Ig("cutgrass", 4) }, TECH.NONE, nil, { "SEAFARING", "NAUTICAL" })
    TroAddRecipe("porto_raft", { Ig("bamboo", 4), Ig("vine", 3) }, TECH.NONE, nil, { "SEAFARING", "NAUTICAL" })
end

-- 小船配件
TroAddRecipe("boatcannon", { Ig("coconut", 6), Ig("log", 5), Ig("gunpowder", 4) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
TroAddRecipe("quackeringram", { Ig("quackenbeak", 1), Ig("bamboo", 4), Ig("rope", 4) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })

TroAddRecipe("sail", { Ig("bamboo", 2), Ig("vine", 2), Ig("palmleaf", 4) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
TroAddRecipe("feathersail", { Ig("bamboo", 2), Ig("rope", 4), Ig("doydoyfeather", 4) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
TroAddRecipe("clothsail", { Ig("bamboo", 2), Ig("fabric", 2), Ig("rope", 2) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
TroAddRecipe("snakeskinsail", { Ig("log", 4), Ig("rope", 2), Ig("snakeskin", 2) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
TroAddRecipe("malbatrossail", { Ig("driftwood_log", 4), Ig("rope", 2), Ig("malbatross_feather", 4) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
TroAddRecipe("ironwind", { Ig("turbine_blades", 1), Ig("transistor", 1), Ig("goldnugget", 2) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })

TroAddRecipe("trawlnet", { Ig("bamboo", 2), Ig("rope", 3) }, TECH.SEAFARING_TWO, nil, { "TOOLS", "FISHING", "NAUTICAL" })

TroAddRecipe("tarlamp", { Ig("seashell", 1), Ig("tar", 1) }, TECH.SCIENCE_ONE, nil, { "LIGHT" })
TroAddRecipe("boat_lantern", { Ig("messagebottleempty_sw", 1), Ig("twigs", 2), Ig("bioluminescence", 1) }, TECH.SCIENCE_TWO, nil, { "NAUTICAL", "LIGHT" })
TroAddRecipe("boat_torch", { Ig("torch", 1), Ig("twigs", 2) }, TECH.ONE, nil, { "NAUTICAL", "LIGHT" })

-- NAUTICAL--
TroAddRecipe("boatrepairkit", { Ig("boards", 2), Ig("stinger", 2), Ig("rope", 2) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
TroAddRecipe("porto_buoy", { Ig("messagebottleempty_sw", 1), Ig("bamboo", 4), Ig("bioluminescence", 2) }, TECH.SEAFARING_TWO, { image = "buoy.tex" }, { "LIGHT", "STRUCTURES", "NAUTICAL" })
TroAddRecipe("telescope", { Ig("goldnugget", 1), Ig("pigskin", 1), Ig("messagebottleempty_sw", 1) }, TECH.SEAFARING_TWO, nil, { "TOOLS", "NAUTICAL" })
TroAddRecipe("supertelescope", { Ig("telescope", 1), Ig("goldnugget", 1), Ig("tigereye", 1) }, TECH.SEAFARING_TWO, nil, { "TOOLS", "NAUTICAL" })
TroAddRecipe("captainhat", { Ig("boneshard", 1), Ig("seaweed", 1), Ig("strawhat", 1) }, TECH.SCIENCE_TWO, nil, { "CLOTHING", "NAUTICAL" })
TroAddRecipe("piratehat", { Ig("boneshard", 2), Ig("rope", 1), Ig("silk", 2) }, TECH.SCIENCE_TWO, nil, { "CLOTHING", "NAUTICAL" })
TroAddRecipe("armor_lifejacket", { Ig("fabric", 2), Ig("vine", 2), Ig("messagebottleempty_sw", 2) }, TECH.SEAFARING_TWO, nil, { "CLOTHING", "NAUTICAL" })
TroAddRecipe("porto_tar_extractor", { Ig("coconut", 2), Ig("bamboo", 4), Ig("limestone", 4) }, TECH.SEAFARING_TWO, { image = "tar_extractor.tex" }, { "STRUCTURES", "NAUTICAL" })

TroAddRecipe("monkeyball", { Ig("cave_banana", 1), Ig("snakeskin", 2), Ig("rope", 2) }, TECH.SCIENCE_ONE, nil, { "TOOLS" })
TroAddRecipe("chiminea", { Ig("log", 2), Ig("limestone", 3), Ig("sand", 2) }, TECH.NONE, { placer = "chiminea_placer" }, { "LIGHT", "COOKING", "WINTER" })
TroAddRecipe("bottlelantern", { Ig("messagebottleempty_sw", 1), Ig("bioluminescence", 2) }, TECH.SCIENCE_TWO, nil, { "LIGHT" })
TroAddRecipe("porto_sea_chiminea", { Ig("sand", 4), Ig("tar", 6), Ig("limestone", 6) }, TECH.SCIENCE_ONE, { image = "sea_chiminea.tex" }, { "LIGHT", "COOKING", "WINTER" })
TroAddRecipe("porto_researchlab5", { Ig("limestone", 4), Ig("sand", 2), Ig("transistor", 2) }, TECH.SCIENCE_ONE, { image = "researchlab5.tex" }, { "PROTOTYPERS", "STRUCTURES" })
TroAddRecipe("icemaker", { Ig("heatrock", 1), Ig("bamboo", 5), Ig("transistor", 2) }, TECH.SCIENCE_TWO, { placer = "icemaker_placer" }, { "COOKING", "SUMMER", "STRUCTURES" })
TroAddRecipe("quackendrill", { Ig("quackenbeak", 1), Ig("gears", 1), Ig("transistor", 1) }, TECH.SCIENCE_TWO, nil, { "TOOLS" })
TroAddRecipe("fabric", { Ig("bamboo", 3) }, TECH.SCIENCE_ONE, nil, { "REFINE" })
TroAddRecipe("messagebottleempty_sw", { Ig("sand", 3) }, TECH.SCIENCE_TWO, nil, { "REFINE" })
TroAddRecipe("limestone", { Ig("coral", 3) }, TECH.SCIENCE_ONE, nil, { "REFINE" })
TroAddRecipe("nubbin", { Ig("limestone", 3), Ig("corallarve", 1) }, TECH.SCIENCE_ONE, nil, { "REFINE" })
TroAddRecipe("ice", { Ig("hail_ice", 4) }, TECH.SCIENCE_ONE, nil, { "REFINE" })
TroAddRecipe("spear_poison", { Ig("spear", 1), Ig("venomgland", 1) }, TECH.SCIENCE_ONE, nil, { "WEAPONS" })
TroAddRecipe("cutlass", { Ig("goldnugget", 2), Ig("twigs", 1), Ig("dead_swordfish", 1) }, TECH.SCIENCE_TWO, nil, { "WEAPONS" })
TroAddRecipe("coconade", { Ig("coconut", 1), Ig("gunpowder", 1), Ig("rope", 1) }, TECH.SCIENCE_ONE, nil, { "WEAPONS" })
TroAddRecipe("spear_launcher", { Ig("bamboo", 3), Ig("jellyfish", 1) }, TECH.SCIENCE_TWO, nil, { "WEAPONS" })
TroAddRecipe("blowdart_poison", { Ig("cutreeds", 2), Ig("venomgland", 1), Ig("feather_crow", 1) }, TECH.SCIENCE_ONE, nil, { "WEAPONS" })
TroAddRecipe("armorseashell", { Ig("seashell", 10), Ig("rope", 1), Ig("seaweed", 2) }, TECH.SCIENCE_TWO, nil, { "ARMOUR" })
TroAddRecipe("oxhat", { Ig("rope", 1), Ig("seashell", 4), Ig("ox_horn", 1) }, TECH.SCIENCE_ONE, nil, { "ARMOUR" })
TroAddRecipe("armorcactus", { Ig("needlespear", 3), Ig("armorwood", 1) }, TECH.SCIENCE_TWO, nil, { "ARMOUR" })
TroAddRecipe("snakeskinhat", { Ig("boneshard", 1), Ig("snakeskin", 1), Ig("strawhat", 1) }, TECH.SCIENCE_TWO, nil, { "CLOTHING", "RAIN" })
TroAddRecipe("armor_snakeskin", { Ig("boneshard", 2), Ig("snakeskin", 2), Ig("vine", 1) }, TECH.SCIENCE_TWO, nil, { "CLOTHING", "RAIN", "WINTER" })
TroAddRecipe("palmleaf_umbrella", { Ig("twigs", 4), Ig("petals", 6), Ig("palmleaf", 3) }, TECH.NONE, nil, { "CLOTHING", "RAIN", "SUMMER" })
TroAddRecipe("double_umbrellahat", { Ig("umbrella", 1), Ig("shark_gills", 2), Ig("strawhat", 2) }, TECH.SCIENCE_TWO, nil, { "CLOTHING", "RAIN", "SUMMER" })
TroAddRecipe("aerodynamichat", { Ig("coconut", 1), Ig("shark_fin", 1), Ig("vine", 2) }, TECH.SCIENCE_TWO, nil, { "CLOTHING" })
TroAddRecipe("thatchpack", { Ig("palmleaf", 6) }, TECH.NONE, nil, { "CLOTHING", "CONTAINERS" })
TroAddRecipe("tarsuit", { Ig("tar", 4), Ig("fabric", 2), Ig("palmleaf", 2) }, TECH.SCIENCE_ONE, nil, { "CLOTHING", "RAIN" })
TroAddRecipe("blubbersuit", { Ig("blubber", 4), Ig("fabric", 2), Ig("palmleaf", 2) }, TECH.SCIENCE_TWO, nil, { "CLOTHING", "RAIN", "WINTER" })
TroAddRecipe("brainjellyhat", { Ig("coral_brain", 1), Ig("jellyfish", 1), Ig("rope", 2) }, TECH.SCIENCE_TWO, nil, { "CLOTHING", "PROTOTYPERS" })
TroAddRecipe("armor_windbreaker", { Ig("blubber", 2), Ig("fabric", 1), Ig("rope", 1) }, TECH.SCIENCE_TWO, nil, { "CLOTHING", "RAIN" }) -- CHECK  THIS
TroAddRecipe("gashat", { Ig("coral", 2), Ig("messagebottleempty_sw", 2), Ig("jellyfish", 1) }, TECH.SCIENCE_TWO, nil, { "CLOTHING" })
TroAddRecipe("antivenom", { Ig("venomgland", 1), Ig("coral", 2), Ig("seaweed", 2) }, TECH.SCIENCE_ONE, nil, { "RESTORATION" })
TroAddRecipe("ox_flute", { Ig("ox_horn", 1), Ig("nightmarefuel", 2), Ig("rope", 1) }, TECH.MAGIC_TWO, nil, { "MAGIC" })
TroAddRecipe("sand_castle", { Ig("sand", 4), Ig("palmleaf", 2), Ig("seashell", 3) }, TECH.NONE, { placer = "sand_castle_placer" }, { "STRUCTURES", "DECOR" })
TroAddRecipe("turf_road", { Ig("cutstone", 1), Ig("flint", 2) }, TECH.SCIENCE_TWO, { numtogive = 4 }, { "DECOR" }) --要先加个卵石路下面改的海难卵石路才能生效吗？
TroAddRecipe("wildborehouse", { Ig("pigskin", 4), Ig("palmleaf", 5), Ig("bamboo", 8) }, TECH.SCIENCE_TWO, { placer = "wildborehouse_placer" }, { "STRUCTURES" })
TroAddRecipe("primeapebarrel", { Ig("twigs", 10), Ig("cave_banana", 3), Ig("poop", 4) }, TECH.SCIENCE_TWO, { placer = "primeapebarrel_placer" }, { "STRUCTURES" })
TroAddRecipe("porto_ballphinhouse", { Ig("limestone", 4), Ig("seaweed", 4), Ig("dorsalfin", 2) }, TECH.SCIENCE_ONE, { image = "ballphinhouse.tex" }, { "STRUCTURES" })
TroAddRecipe("sandbag_item", { Ig("fabric", 2), Ig("sand", 3) }, TECH.SCIENCE_TWO, { numtogive = 4 }, { "STRUCTURES", "DECOR" })
TroAddRecipe("doydoynest", { Ig("twigs", 8), Ig("doydoyfeather", 2), Ig("poop", 4) }, TECH.SCIENCE_TWO, { placer = "doydoynest_placer" }, { "STRUCTURES" })
TroAddRecipe("wall_limestone_item", { Ig("limestone", 2) }, TECH.SCIENCE_TWO, { numtogive = 4 }, { "STRUCTURES", "DECOR" })
TroAddRecipe("wall_enforcedlimestone_item", { Ig("limestone", 2), Ig("seaweed", 4) }, TECH.SCIENCE_ONE, { numtogive = 4 }, { "STRUCTURES", "DECOR" })
TroAddRecipe("seasack", { Ig("seaweed", 5), Ig("vine", 2), Ig("shark_gills", 1) }, TECH.SCIENCE_TWO, nil, { "CONTAINERS", "COOKING", "CLOTHING" })
TroAddRecipe("porto_waterchest", { Ig("boards", 4), Ig("tar", 1) }, TECH.SCIENCE_ONE, { image = "waterchest.tex" }, { "STRUCTURES", "CONTAINERS" })
TroAddRecipe("mussel_stick", { Ig("bamboo", 2), Ig("vine", 1), Ig("seaweed", 1) }, TECH.SCIENCE_ONE, nil, { "GARDENING" })
TroAddRecipe("mussel_bed", { Ig("mussel", 1), Ig("coral", 1) }, TECH.SCIENCE_ONE, nil, { "GARDENING" })
TroAddRecipe("porto_fish_farm", { Ig("silk", 2), Ig("rope", 2), Ig("coconut", 4) }, TECH.SCIENCE_ONE, { image = "fish_farm.tex" }, { "GARDENING" })
TroAddRecipe("tropicalfan", { Ig("cutreeds", 2), Ig("rope", 2), Ig("doydoyfeather", 5) }, TECH.SCIENCE_TWO, nil, { "SUMMER", "CLOTHING" })
TroAddRecipe("palmleaf_hut", { Ig("palmleaf", 4), Ig("bamboo", 4), Ig("rope", 3) }, TECH.SCIENCE_TWO, { placer = "palmleaf_hut_placer" }, { "STRUCTURES", "RAIN", "SUMMER" })
TroAddRecipe("armorlimestone", { Ig("limestone", 3), Ig("rope", 2) }, TECH.SCIENCE_TWO, nil, { "ARMOUR" })
TroAddRecipe("bell", { Ig("glommerwings", 1), Ig("glommerflower", 1) }, TECH.MAGIC_TWO, nil, { "MAGIC" })

TroAddRecipe("glass_shards", { Ig("sand", 3) }, TECH.SCIENCE_ONE, nil, { "REFINE" })
TroAddRecipe("shard_sword", { Ig("glass_shards", 3), Ig("nightmarefuel", 2), Ig("twigs", 2) }, TECH.MAGIC_TWO, nil, { "MAGIC", "WEAPONS" })
TroAddRecipe("shard_beak", { Ig("glass_shards", 3), Ig("crow", 1), Ig("twigs", 2) }, TECH.MAGIC_TWO, nil, { "MAGIC", "WEAPONS" })
TroAddRecipe("piratihatitator", { Ig("parrot", 1), Ig("boards", 4), Ig("piratehat", 1) }, TECH.SCIENCE_ONE, { placer = "piratihatitator_placer" }, { "PROTOTYPERS", "MAGIC", "STRUCTURES" })

-- 地皮
TroAddRecipe("turf_snakeskinfloor", { Ig("snakeskin", 2), Ig("fabric", 1) }, TECH.SCIENCE_TWO, { numtogive = 4 }, { "DECOR" })
TroAddRecipe("turf_magmafield", { Ig("rocks", 2), Ig("ash", 1) }, TECH.TURFCRAFTING_ONE, { numtogive = 4 }, { "DECOR" })
TroAddRecipe("turf_ash", { Ig("ash", 3) }, TECH.TURFCRAFTING_ONE, { numtogive = 4 }, { "DECOR" })
TroAddRecipe("turf_jungle", { Ig("bamboo", 1), Ig("cutgrass", 1) }, TECH.TURFCRAFTING_ONE, { numtogive = 4 }, { "DECOR" })
TroAddRecipe("turf_volcano", { Ig("nitre", 2), Ig("ash", 1) }, TECH.TURFCRAFTING_ONE, { numtogive = 4 }, { "DECOR" })
TroAddRecipe("turf_tidalmarsh", { Ig("cutgrass", 2), Ig("nitre", 1) }, TECH.TURFCRAFTING_ONE, { numtogive = 4 }, { "DECOR" })
TroAddRecipe("turf_meadow", { Ig("cutgrass", 2) }, TECH.TURFCRAFTING_ONE, { numtogive = 4 }, { "DECOR" })
TroAddRecipe("turf_beach", { Ig("sand", 2) }, TECH.TURFCRAFTING_ONE, { numtogive = 4 }, { "DECOR" })
