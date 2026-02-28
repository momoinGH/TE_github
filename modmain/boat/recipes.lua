AddRecipe2("porto_armouredboat", { Ingredient("boards", 6), Ingredient("rope", 3), Ingredient("seashell", 10) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
AddRecipe2("porto_cargoboat", { Ingredient("boards", 6), Ingredient("rope", 3) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
AddRecipe2("porto_encrustedboat", { Ingredient("boards", 6), Ingredient("limestone", 4), Ingredient("rope", 3) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
AddRecipe2("porto_rowboat", { Ingredient("boards", 3), Ingredient("vine", 4) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
AddRecipe2("porto_woodlegsboat", { Ingredient("boards", 4), Ingredient("dubloon", 4), Ingredient("boatcannon", 1) }, TECH.NONE, { builder_tag = "woodlegs" }, { "CHARACTER" })

AddRecipe2("corkboatitem", { Ingredient("rope", 1), Ingredient("cork", 4) }, TECH.NONE, nil, { "NAUTICAL" })
AddRecipe2("surfboard_item", { Ingredient("boards", 1), Ingredient("seashell", 1) }, TECH.NONE, { builder_tag = "walani" }, { "CHARACTER" })

if TUNING.tropical.only_shipwrecked or GetModConfigData("raftlog") then
    AddRecipe2("porto_lograft_old", { Ingredient("log", 6), Ingredient("cutgrass", 4) }, TECH.NONE, nil, { "NAUTICAL" })
    AddRecipe2("porto_raft_old", { Ingredient("bamboo", 4), Ingredient("vine", 3) }, TECH.NONE, nil, { "NAUTICAL" })
else
    AddRecipe2("porto_lograft", { Ingredient("log", 6), Ingredient("cutgrass", 4) }, TECH.NONE, nil, { "SEAFARING", "NAUTICAL" })
    AddRecipe2("porto_raft", { Ingredient("bamboo", 4), Ingredient("vine", 3) }, TECH.NONE, nil, { "SEAFARING", "NAUTICAL" })
end

-- 小船配件
AddRecipe2("boatcannon", { Ingredient("coconut", 6), Ingredient("log", 5), Ingredient("gunpowder", 4) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
AddRecipe2("quackeringram", { Ingredient("quackenbeak", 1), Ingredient("bamboo", 4), Ingredient("rope", 4) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })

AddRecipe2("sail", { Ingredient("bamboo", 2), Ingredient("vine", 2), Ingredient("palmleaf", 4) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
AddRecipe2("feathersail", { Ingredient("bamboo", 2), Ingredient("rope", 4), Ingredient("doydoyfeather", 4) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
AddRecipe2("clothsail", { Ingredient("bamboo", 2), Ingredient("fabric", 2), Ingredient("rope", 2) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
AddRecipe2("snakeskinsail", { Ingredient("log", 4), Ingredient("rope", 2), Ingredient("snakeskin", 2) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
AddRecipe2("malbatrossail", { Ingredient("driftwood_log", 4), Ingredient("rope", 2), Ingredient("malbatross_feather", 4) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })
AddRecipe2("ironwind", { Ingredient("turbine_blades", 1), Ingredient("transistor", 1), Ingredient("goldnugget", 2) }, TECH.SEAFARING_TWO, nil, { "NAUTICAL" })

AddRecipe2("trawlnet", { Ingredient("bamboo", 2), Ingredient("rope", 3) }, TECH.SEAFARING_TWO, nil, { "TOOLS", "FISHING", "NAUTICAL" })

AddRecipe2("tarlamp", { Ingredient("seashell", 1), Ingredient("tar", 1) }, TECH.SCIENCE_ONE, nil, { "LIGHT" })
AddRecipe2("boat_lantern", { Ingredient("messagebottleempty_sw", 1), Ingredient("twigs", 2), Ingredient("bioluminescence", 1) }, TECH.SCIENCE_TWO, nil, { "NAUTICAL", "LIGHT" })
AddRecipe2("boat_torch", { Ingredient("torch", 1), Ingredient("twigs", 2) }, TECH.ONE, nil, { "NAUTICAL", "LIGHT" })



















-- SortAfter("surfboard_item", "wx78_scanner_item", "CHARACTER")
-- SortAfter("woodlegshat", "surfboard_item", "CHARACTER")
-- SortAfter("trawlnet", "oceanfishingrod", "TOOLS")
-- SortAfter("trawlnet", "oceanfishingrod", "FISHING")
-- SortBefore("tarlamp", "lantern", "LIGHT")
-- SortAfter("boat_lantern", "boat_torch", "LIGHT")
-- SortAfter("boat_torch", "coldfirepit", "LIGHT")