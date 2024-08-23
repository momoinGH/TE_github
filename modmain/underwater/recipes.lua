-- Mod cooking recipes and ingredients
AddIngredientValues({ "fish_fillet" }, { fish = 1, meat = 0.5 }, true, false)
AddIngredientValues({ "sponge_piece" }, { sponge = 1 }, false, false)
AddIngredientValues({ "seagrass_chunk" }, { sea_veggie = 1, veggie = 0.5 }, false, false)
AddIngredientValues({ "trinket_12" }, { tentacle = 1, meat = 0.5 }, false, false)
AddIngredientValues({ "petals" }, { flower = 1 }, false, false)
AddIngredientValues({ "sea_petals" }, { flower = 1 }, false, false)
AddIngredientValues({ "jelly_cap" }, { sea_jelly = 1 }, false, false)
AddIngredientValues({ "saltrock" }, { saltrock = 1 }, false, false)

-- TODO 替换成AddRecipe2

-- Light Tab
AddRecipe("flare",
    { Ingredient("iron_ore", 1, "images/inventoryimages/iron_ore.xml"), Ingredient("twigs", 2) },
    RECIPETABS.LIGHT,
    TECH.SCIENCE_ONE,
    nil,
    nil,
    false,
    1,
    nil,
    "images/inventoryimages/flare.xml")
AddRecipeToFilter("flare", "LIGHT")

AddRecipe("jelly_lantern",
    { Ingredient("twigs", 3), Ingredient("rope", 2), Ingredient("jelly_cap", 1, "images/inventoryimages/jelly_cap.xml") },
    RECIPETABS.LIGHT,
    TECH.SCIENCE_TWO,
    nil,
    nil,
    false,
    1,
    nil,
    "images/inventoryimages/jelly_lantern.xml")
AddRecipeToFilter("jelly_lantern", "LIGHT")
-- Survival tab

AddRecipe("snorkel",
    { Ingredient("tentaclespots", 2), Ingredient("silk", 2), Ingredient("mosquitosack", 4) },
    RECIPETABS.SURVIVAL,
    TECH.SCIENCE_ONE,
    nil,
    nil,
    false,
    1,
    nil,
    "images/inventoryimages/snorkel.xml")
AddRecipeToFilter("snorkel", "TOOLS")

AddRecipe("hat_submarine",
    { Ingredient("tentaclespots", 5), Ingredient("iron_ore", 4, "images/inventoryimages/iron_ore.xml"), Ingredient(
        "mosquitosack", 4) },
    RECIPETABS.SURVIVAL,
    TECH.SCIENCE_TWO,
    nil,
    nil,
    false,
    1,
    nil,
    "images/inventoryimages/creepindedeepinventory.xml")
AddRecipeToFilter("hat_submarine", "TOOLS")

-- Magic tab
AddRecipe("pearl_amulet",
    { Ingredient("pearl", 3, "images/inventoryimages/pearl.xml"), Ingredient("coral_cluster", 3,
        "images/inventoryimages/coral_cluster.xml") },
    RECIPETABS.MAGIC,
    TECH.MAGIC_TWO,
    nil,
    nil,
    nil,
    nil,
    nil,
    "images/inventoryimages/pearl_amulet.xml")
AddRecipeToFilter("pearl_amulet", "MAGIC")

-- Dress tab
AddRecipe("diving_suit_summer",
    { Ingredient("trunk_summer", 1), Ingredient("silk", 8), Ingredient("sponge_piece", 4,
        "images/inventoryimages/sponge_piece.xml") },
    RECIPETABS.DRESS,
    TECH.SCIENCE_ONE,
    nil,
    nil,
    nil,
    nil,
    nil,
    "images/inventoryimages/diving_suit_summer.xml")
AddRecipeToFilter("diving_suit_summer", "CLOTHING")

AddRecipe("diving_suit_winter",
    { Ingredient("trunk_winter", 1), Ingredient("silk", 8), Ingredient("sponge_piece", 4,
        "images/inventoryimages/sponge_piece.xml") },
    RECIPETABS.DRESS,
    TECH.SCIENCE_TWO,
    nil,
    nil,
    nil,
    nil,
    nil,
    "images/inventoryimages/diving_suit_winter.xml")
AddRecipeToFilter("diving_suit_winter", "CLOTHING")

AddRecipe("coral_cluster",
    { Ingredient("cut_orange_coral", 3, "images/inventoryimages/cut_orange_coral.xml"), Ingredient("cut_blue_coral", 3,
        "images/inventoryimages/cut_blue_coral.xml"), Ingredient("cut_green_coral", 3,
        "images/inventoryimages/cut_green_coral.xml") },
    RECIPETABS.REFINE,
    TECH.SCIENCE_ONE,
    nil,
    nil,
    nil,
    nil,
    nil,
    "images/inventoryimages/coral_cluster.xml")
AddRecipeToFilter("coral_cluster", "REFINE")
