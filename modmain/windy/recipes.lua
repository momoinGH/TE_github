local Ig = Ingredient

TroAddTech("GODDESS", {
    max_level = 2,
    atlas = "minimap/minimap_windy.xml",
    image = "windyfan1.tex"
})

TroAddPrototyperDef("goddess_shrine", {
    action_str = "GODDESS",
    icon_atlas = "minimap/minimap_windy.xml",
    icon_image = "windyfan1.tex",
    is_crafting_station = true,
})

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

AddRecipe2("peachy_poop", { Ig("guano", 6), Ig("peach", 6) }, TECH.SCIENCE_TWO, { numtogive = 6 }, { "GARDENING" })

----------------------------------------------------------------------------------------------------
AddRecipe2("magicpowder", { Ig("goddess_butterflywings", 8), Ig("nightmarefuel", 8), Ig("cutgrass", 8) }, TECH.GODDESS_TWO, { numtogive = 8, nounlock = true })
AddRecipe2("goddess_ribbon", { Ig("goddess_rabbit_fur", 3), Ig("silk", 9), Ig("magicpowder", 1) }, TECH.GODDESS_TWO, { numtogive = 3, nounlock = true })
AddRecipe2("forbidden_fruit", { Ig("mixed_gem", 1), Ig("magicpowder", 8), Ig("peach", 1) }, TECH.GODDESS_TWO, { nounlock = true })
AddRecipe2("glass_bomb", { Ig("full_bottle_green_dirty", 3), Ig("magicpowder", 3), Ig("gunpowder", 9) }, TECH.GODDESS_TWO, { numtogive = 3, nounlock = true })
AddRecipe2("goddess_hat", { Ig("eyebrellahat", 1), Ig("goddess_feather", 2), Ig("forbidden_fruit", 1) }, TECH.GODDESS_TWO, { nounlock = true })
AddRecipe2("goddess_bowtie", { Ig("goddess_ribbon", 8), Ig("goddess_butterfly", 3), Ig("forbidden_fruit", 1) }, TECH.GODDESS_TWO, { nounlock = true })
AddRecipe2("usedfan", { Ig("goddess_feather", 8), Ig("goldnugget", 12), Ig("goose_feather", 8) }, TECH.GODDESS_TWO, { nounlock = true })
AddRecipe2("windyfan", { Ig("usedfan", 1), Ig("magicpowder", 8), Ig("forbidden_fruit", 1) }, TECH.GODDESS_TWO, { nounlock = true })
AddRecipe2("goddess_sword", { Ig("magicpowder", 10), Ig("nightsword", 3), Ig("forbidden_fruit", 1) }, TECH.GODDESS_TWO, { nounlock = true })
AddRecipe2("goddess_flute", { Ig("staff_tornado", 3), Ig("cutreeds", 10), Ig("forbidden_fruit", 1) }, TECH.GODDESS_TWO, { nounlock = true })
AddRecipe2("goddess_bell", { Ig("goldnugget", 8), Ig("steelwool", 8), Ig("forbidden_fruit", 1) }, TECH.GODDESS_TWO, { nounlock = true })
AddRecipe2("goddess_staff", { Ig("goldnugget", 8), Ig("goddess_ribbon", 8), Ig("forbidden_fruit", 1) }, TECH.GODDESS_TWO, { nounlock = true })
AddRecipe2("goddess_lantern", { Ig("yellowstaff", 2), Ig("goddess_ribbon", 8), Ig("forbidden_fruit", 1) }, TECH.GODDESS_TWO, { nounlock = true })
AddRecipe2("goddess_fountainette", { Ig("full_bottle_green", 4), Ig("moonrocknugget", 15), Ig("forbidden_fruit", 1) }, TECH.GODDESS_TWO, { nounlock = true })
AddRecipe2("goddess_figure", { Ig("windyfan", 1), Ig("marble", 15), Ig("forbidden_fruit", 1) }, TECH.GODDESS_TWO, { nounlock = true })
AddRecipe2("gem_seeds", { Ig("mixed_gem", 1), Ig("seeds", 3), Ig("peach_pit", 3) }, TECH.GODDESS_TWO, { numtogive = 3, nounlock = true })
