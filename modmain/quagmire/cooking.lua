AddIngredientValues({ "quagmire_spotspice_ground" }, { spice = 1 }, true, false)
AddIngredientValues({ "quagmire_syrup" }, { sweetener = 2 }, true, false)
AddIngredientValues({ "tomato", "potato", "turnip", "garlic", "onion" }, { veggie = 1 }, true, false)
AddIngredientValues({ "quagmire_flour" }, { flour = 1, }, true, false)
AddIngredientValues({ "rocks" }, { rocks = 1 }, true, false)
AddIngredientValues({ "quagmire_sap" }, {}, true, false)
AddIngredientValues({ "quagmire_goatmilk" }, { dairy = 1, }, true, false)
TroUpdateCookingIngredientTags({ "red_cap", "green_cap", "blue_cap" }, { mushroom = 1, })
TroUpdateCookingIngredientTags({ "smallmeat", "smallmeat_dried", "drumstick", "froglegs" }, { smallmeat = 1, })
TroUpdateCookingIngredientTags({ "meat", "monstermeat" }, { bigmeat = 1, })




AddCookerRecipe("quagmire_pot", {
    name = "quagmire_syrup",
    test = function(cooker, names, tags) return names.sap and names.sap >= 3 end,
    priority = 1,
    weight = 1,
    foodtype = "GENERIC",
    health = 10,
    hunger = 5,
    sanity = 10,
    perishtime = TUNING.PERISH_SLOW,
    cooktime = 2,
    tags = {},
    no_cookbook = true,
})
