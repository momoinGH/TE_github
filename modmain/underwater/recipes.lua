-- Mod cooking recipes and ingredients
AddIngredientValues({ "fish_fillet" }, { fish = 1, meat = 0.5 }, true, false)
AddIngredientValues({ "sponge_piece" }, { sponge = 1 }, false, false)
AddIngredientValues({ "seagrass_chunk" }, { sea_veggie = 1, veggie = 0.5 }, false, false)
AddIngredientValues({ "trinket_12" }, { tentacle = 1, meat = 0.5 }, false, false)
AddIngredientValues({ "petals" }, { flower = 1 }, false, false)
AddIngredientValues({ "sea_petals" }, { flower = 1 }, false, false)
AddIngredientValues({ "jelly_cap" }, { sea_jelly = 1 }, false, false)
AddIngredientValues({ "saltrock" }, { saltrock = 1 }, false, false)

AddRecipe2("flare", { Ingredient("iron_ore", 1), Ingredient("twigs", 2) }, TECH.SCIENCE_ONE, nil, { "LIGHT" })
AddRecipe2("jelly_lantern", { Ingredient("twigs", 3), Ingredient("rope", 2), Ingredient("jelly_cap", 1) },
    TECH.SCIENCE_TWO, nil, { "LIGHT" })
AddRecipe2("snorkel", { Ingredient("tentaclespots", 2), Ingredient("silk", 2), Ingredient("mosquitosack", 4) },
    TECH.SCIENCE_ONE, nil, { "TOOLS" })
AddRecipe2("hat_submarine", { Ingredient("tentaclespots", 5), Ingredient("iron_ore", 4), Ingredient("mosquitosack", 4) },
    TECH.SCIENCE_TWO, nil, { "TOOLS" })
AddRecipe2("pearl_amulet", { Ingredient("pearl", 3), Ingredient("coral_cluster", 3) },
    TECH.MAGIC_TWO, nil, { "MAGIC" })
AddRecipe2("diving_suit_summer", { Ingredient("trunk_summer", 1), Ingredient("silk", 8), Ingredient("sponge_piece", 4) },
    TECH.SCIENCE_ONE, nil, { "CLOTHING" })
AddRecipe2("diving_suit_winter", { Ingredient("trunk_winter", 1), Ingredient("silk", 8), Ingredient("sponge_piece", 4) },
    TECH.SCIENCE_TWO, nil, { "CLOTHING" })
AddRecipe2("coral_cluster", { Ingredient("cut_orange_coral", 3), Ingredient("cut_blue_coral", 3), Ingredient("cut_green_coral", 3) },
    TECH.SCIENCE_ONE, nil, { "REFINE" })
