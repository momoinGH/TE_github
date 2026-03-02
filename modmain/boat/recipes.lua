local Ig = Ingredient

AddRecipe2("armouredboat", { Ig("boards", 6), Ig("rope", 3), Ig("seashell", 10) }, TECH.SEAFARING_TWO, { placer = "armouredboat_placer" }, { "NAUTICAL" })
AddRecipe2("cargoboat", { Ig("boards", 6), Ig("rope", 3) }, TECH.SEAFARING_TWO, { placer = "cargoboat_placer" }, { "NAUTICAL" })
AddRecipe2("encrustedboat", { Ig("boards", 6), Ig("limestone", 4), Ig("rope", 3) }, TECH.SEAFARING_TWO, { placer = "encrustedboat_placer" }, { "NAUTICAL" })
AddRecipe2("rowboat", { Ig("boards", 3), Ig("vine", 4) }, TECH.SEAFARING_TWO, { placer = "rowboat_placer" }, { "NAUTICAL" })
AddRecipe2("porto_woodlegsboat", { Ig("boards", 4), Ig("dubloon", 4), Ig("boatcannon", 1) }, TECH.NONE, { builder_tag = "woodlegs" }, { "CHARACTER" })
AddRecipe2("shadowboat", { Ig("papyrus", 3), Ig("nightmarefuel", 4), Ig(CHARACTER_INGREDIENT.SANITY, 60) }, TECH.NONE, { placer = "shadowboat_placer", builder_tag = "shadowmagic" },
    { "CHARACTER" })

AddRecipe2("corkboatitem", { Ig("rope", 1), Ig("cork", 4) }, TECH.NONE, nil, { "NAUTICAL" })
AddRecipe2("surfboard_item", { Ig("boards", 1), Ig("seashell", 1) }, TECH.NONE, { builder_tag = "walani" }, { "CHARACTER" })

if TUNING.tropical.only_shipwrecked or GetModConfigData("raftlog") then
    AddRecipe2("lograft_old", { Ig("log", 6), Ig("cutgrass", 4) }, TECH.NONE, { placer = "lograft_old_placer" }, { "NAUTICAL" })
    AddRecipe2("raft_old", { Ig("bamboo", 4), Ig("vine", 3) }, TECH.NONE, { placer = "raft_old_placer" }, { "NAUTICAL" })
else
    AddRecipe2("lograft", { Ig("log", 6), Ig("cutgrass", 4) }, TECH.NONE, { placer = "lograft_placer" }, { "SEAFARING", "NAUTICAL" })
    AddRecipe2("raft", { Ig("bamboo", 4), Ig("vine", 3) }, TECH.NONE, { placer = "raft_placer" }, { "SEAFARING", "NAUTICAL" })
end

-- 小船配件
AddRecipe2("boatcannon", { Ig("coconut", 6), Ig("log", 5), Ig("gunpowder", 4) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
AddRecipe2("quackeringram", { Ig("quackenbeak", 1), Ig("bamboo", 4), Ig("rope", 4) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })

AddRecipe2("sail", { Ig("bamboo", 2), Ig("vine", 2), Ig("palmleaf", 4) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
AddRecipe2("feathersail", { Ig("bamboo", 2), Ig("rope", 4), Ig("doydoyfeather", 4) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
AddRecipe2("clothsail", { Ig("bamboo", 2), Ig("fabric", 2), Ig("rope", 2) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
AddRecipe2("snakeskinsail", { Ig("log", 4), Ig("rope", 2), Ig("snakeskin", 2) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
AddRecipe2("malbatrossail", { Ig("driftwood_log", 4), Ig("rope", 2), Ig("malbatross_feather", 4) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
AddRecipe2("ironwind", { Ig("turbine_blades", 1), Ig("transistor", 1), Ig("goldnugget", 2) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })

AddRecipe2("trawlnet", { Ig("bamboo", 2), Ig("rope", 3) }, TECH.SEAFARING_TWO, nil, { "TOOLS", "FISHING", "NAUTICAL" })

AddRecipe2("tarlamp", { Ig("seashell", 1), Ig("tar", 1) }, TECH.SCIENCE_ONE, nil, { "LIGHT" })
AddRecipe2("boat_lantern", { Ig("messagebottleempty_sw", 1), Ig("twigs", 2), Ig("bioluminescence", 1) }, TECH.SCIENCE_TWO, nil, { "NAUTICAL", "LIGHT" })
AddRecipe2("boat_torch", { Ig("torch", 1), Ig("twigs", 2) }, TECH.ONE, nil, { "NAUTICAL", "LIGHT" })



















-- SortAfter("surfboard_item", "wx78_scanner_item", "CHARACTER")
-- SortAfter("woodlegshat", "surfboard_item", "CHARACTER")
-- SortAfter("trawlnet", "oceanfishingrod", "TOOLS")
-- SortAfter("trawlnet", "oceanfishingrod", "FISHING")
-- SortBefore("tarlamp", "lantern", "LIGHT")
-- SortAfter("boat_lantern", "boat_torch", "LIGHT")
-- SortAfter("boat_torch", "coldfirepit", "LIGHT")
