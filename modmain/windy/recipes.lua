AddIngredientValues({ "full_bottle_green_milk" }, { dairy = 3 })
AddIngredientValues({ "half_bottle_green_milk" }, { dairy = 2 })
AddIngredientValues({ "less_bottle_green_milk" }, { dairy = 1 })
AddIngredientValues({ "full_bottle_green" }, { water = 1 })
AddIngredientValues({ "magicpowder" }, { goddessmagic = 1 })
AddIngredientValues({ "peach" }, { fruit = 1 })
AddIngredientValues({ "grilled_peach" }, { fruit = 1 })
AddIngredientValues({ "peach_juice_bottle_green" }, { peachy = 1 })
AddIngredientValues({ "peachy_meatloaf" }, { loaf = 1 })

local peach_juice =
{
    name = "peach_juice_bottle_green",
    test = function(cooker, names, tags)
        return (names.peach or names.grilled_peach) and
            (names.peach or names.grilled_peach) >= 2 and tags.sweetener and tags.water and not tags.meat and
            not tags.egg and
            not tags.monster
    end,
    priority = 100,
    weight = 1,
    foodtype = FOODTYPE.GOODIES,
    health = 15,
    hunger = 35,
    sanity = 5,
    cooktime = 0.5,
    tags = { "honeyed" },
    card_def = { ingredients = { { "peach", 2 }, { "honey", 1 }, { "full_bottle_green", 1 } } },
}
local potion =
{
    name = "potion_bottle_green",
    test = function(cooker, names, tags)
        return tags.peachy and tags.goddessmagic and tags.loaf and
            (names.peach or names.grilled_peach)
    end,
    priority = 100,
    weight = 1,
    foodtype = FOODTYPE.GOODIES,
    health = 75,
    hunger = 75,
    sanity = 75,
    cooktime = 0.5,
    card_def = { ingredients = { { "peach", 1 }, { "peach_juice_bottle_green", 1 }, { "peachy_meatloaf", 1 }, { "magicpowder", 1 } } },
}
AddCookerRecipe("cookpot", potion)
AddCookerRecipe("cookpot", peach_juice)
AddCookerRecipe("portablecookpot", potion)
AddCookerRecipe("portablecookpot", peach_juice)
--local goddess_tab = AddRecipeTab("Wind Goddess Magic", 969, "windyfan1.tex", nil )
AddRecipe2("magicpowder",
    { Ingredient("goddess_butterflywings", 8), Ingredient(
        "nightmarefuel", 8), Ingredient("cutgreengrass", 8) },
    TECH.GODDESS_TWO,
    { numtogive = 8 }, { "CRAFTING_STATION" })
AddRecipe2("goddess_ribbon",
    { Ingredient("goddess_rabbit_fur", 3), Ingredient("silk", 9),
        Ingredient("magicpowder", 1) }, TECH.GODDESS_TWO,
    { numtogive = 3 }, { "CRAFTING_STATION" })
AddRecipe2("forbidden_fruit",
    { Ingredient("mixed_gem", 1), Ingredient("magicpowder", 8), Ingredient("peach", 1) },
    TECH.GODDESS_TWO, nil, { "CRAFTING_STATION" })
AddRecipe2("glass_bomb",
    { Ingredient("full_bottle_green_dirty", 3), Ingredient(
        "magicpowder", 3), Ingredient("gunpowder", 9) }, TECH.GODDESS_TWO,
    { numtogive = 3 }, { "CRAFTING_STATION" })
AddRecipe2("goddess_hat",
    { Ingredient("eyebrellahat", 1), Ingredient("goddess_feather", 2),
        Ingredient("forbidden_fruit", 1) }, TECH.GODDESS_TWO,
    nil, { "CRAFTING_STATION" })
AddRecipe2("goddess_bowtie",
    { Ingredient("goddess_ribbon", 8), Ingredient("goddess_butterfly", 3), Ingredient("forbidden_fruit", 1) }, TECH.GODDESS_TWO,
    nil, { "CRAFTING_STATION" })
AddRecipe2("usedfan",
    { Ingredient("goddess_feather", 8), Ingredient("goldnugget", 12),
        Ingredient("goose_feather", 8) }, TECH.GODDESS_TWO, nil,
    { "CRAFTING_STATION" })
AddRecipe2("windyfan",
    { Ingredient("usedfan", 1), Ingredient("magicpowder", 8), Ingredient("forbidden_fruit", 1) }, TECH.GODDESS_TWO, nil, { "CRAFTING_STATION" })
AddRecipe2("goddess_sword",
    { Ingredient("magicpowder", 10), Ingredient("nightsword", 3), Ingredient(
        "forbidden_fruit", 1) }, TECH.GODDESS_TWO,
    nil, { "CRAFTING_STATION" })
AddRecipe2("goddess_flute",
    { Ingredient("staff_tornado", 3), Ingredient("cutreeds", 10), Ingredient("forbidden_fruit", 1) }, TECH.GODDESS_TWO,
    nil, { "CRAFTING_STATION" })
AddRecipe2("goddess_bell",
    { Ingredient("goldnugget", 8), Ingredient("steelwool", 8), Ingredient("forbidden_fruit", 1) }, TECH.GODDESS_TWO,
    nil, { "CRAFTING_STATION" })
AddRecipe2("goddess_staff",
    { Ingredient("goldnugget", 8), Ingredient("goddess_ribbon", 8),
        Ingredient("forbidden_fruit", 1) }, TECH.GODDESS_TWO,
    nil, { "CRAFTING_STATION" })
AddRecipe2("goddess_lantern",
    { Ingredient("yellowstaff", 2), Ingredient("goddess_ribbon", 8),
        Ingredient("forbidden_fruit", 1) }, TECH.GODDESS_TWO,
    nil, { "CRAFTING_STATION" })
AddRecipe2("goddess_fountainette",
    { Ingredient("full_bottle_green", 4), Ingredient("moonrocknugget", 15),
        Ingredient("forbidden_fruit", 1) }, TECH.GODDESS_TWO,
    nil, { "CRAFTING_STATION" })
AddRecipe2("goddess_figure",
    { Ingredient("windyfan", 1), Ingredient("marble", 15), Ingredient(
        "forbidden_fruit", 1) }, TECH.GODDESS_TWO,
    nil, { "CRAFTING_STATION" })
AddRecipe2("gem_seeds",
    { Ingredient("mixed_gem", 1), Ingredient("seeds", 3), Ingredient("peach_pit",
        3) }, TECH.GODDESS_TWO,
    { numtogive = 3 }, { "CRAFTING_STATION" })
AddRecipe2("peachy_poop", { Ingredient("guano", 6), Ingredient("peach", 6) },
    TECH.SCIENCE_TWO, { numtogive = 6 }, { "GARDENING" })
