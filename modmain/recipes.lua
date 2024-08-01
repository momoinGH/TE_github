local cooking = require("cooking")
local preparedFoods = require("gorge_foods")

local cookers =
{
    grill = { "grill", "grill_small" },
    oven = { "oven" },
    pot = { "pot" },
}

function UpdateCookingIngredientTags(names, newtags)
    for _, name in ipairs(names) do
        --		print(name)
        for tag, value in pairs(newtags) do
            cooking.ingredients[name].tags[tag] = value
            if cooking.ingredients[name .. "_cooked"] ~= nil then
                cooking.ingredients[name .. "_cooked"].tags[tag] = value
            end
        end
    end
end

AddIngredientValues({ "quagmire_spotspice_ground" }, { spice = 1 }, true, false)
AddIngredientValues({ "syrup" }, { sweetener = 2 }, true, false)
--AddIngredientValues({"crabmeat"}, {fish=0.5, crab=1}, true, false)
--AddIngredientValues({"tomato", "potato", "turnip", "garlic", "onion"}, {veggie=1}, true, false)
AddIngredientValues({ "quagmire_flour" }, { flour = 1 }, true, false)
AddIngredientValues({ "rocks" }, { rocks = 1 }, true, false)
AddIngredientValues({ "sap" }, {}, true, false)
AddIngredientValues({ "quagmire_goatmilk" }, { dairy = 1 }, true, false)
UpdateCookingIngredientTags({ "red_cap", "green_cap", "blue_cap" }, { mushroom = 1 })
UpdateCookingIngredientTags({ "smallmeat", "smallmeat_dried", "drumstick", "froglegs" }, { smallmeat = 1 })
UpdateCookingIngredientTags({ "meat", "monstermeat" }, { bigmeat = 1 })

AddCookerRecipe(
    "pot",
    {
        name = "syrup",
        test = function(cooker, names, tags)
            return names.sap and names.sap >= 3
        end,
        priority = 1,
        weight = 1,
        foodtype = "GENERIC",
        health = 10,
        hunger = 5,
        sanity = 10,
        perishtime = TUNING.PERISH_SLOW,
        cooktime = 2,
        tags = {},
    }
)

local GNAW_REWARDS = {}
GLOBAL.GNAW_REWARDS = GNAW_REWARDS

for k, v in pairs(preparedFoods) do
    GNAW_REWARDS[k] = v.reward
    if v.cookers then
        for i, cookertype in ipairs(v.cookers) do
            for i, cookerprefab in ipairs(cookers[cookertype] or {}) do
                AddCookerRecipe(cookerprefab, v)
            end
        end
    else
        AddCookerRecipe("cookpot", v)
    end
end
