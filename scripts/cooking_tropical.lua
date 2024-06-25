-- 物品栏贴图路径
local inventoryitems_atlas_sw = "images/inventoryimages/cookpotfoods_sw.xml"
local inventoryitems_atlas_ham = "images/inventoryimages/cookpotfoods_ham.xml"
local inventoryitems_atlas_creeps = "images/inventoryimages/creepindeep_cuisine.xml"
local inventoryitems_atlas_frost = "images/inventoryimages/volcanoinventory.xml"

local foods_sw = require("preparedfoods_sw")
for k, v in pairs (foods_sw) do
    if v.mod and v.mod == true then
        RegisterInventoryItemAtlas(inventoryitems_atlas_sw, v.name..".tex")
    end
    if v.isMasterfood == nil then -- 不是大厨料理才加入到烹饪锅
        AddCookerRecipe("cookpot", v)
        AddCookerRecipe("archive_cookpot", v)
    end
    AddCookerRecipe("portablecookpot", v)
    if v.card_def then
        AddRecipeCard("cookpot", v)
    end
end

local foods_ham = require("preparedfoods_ham")
for k, v in pairs (foods_ham) do
    if v.mod and v.mod == true then
        RegisterInventoryItemAtlas(inventoryitems_atlas_ham, v.name..".tex")
    end
    AddCookerRecipe("cookpot", v)
    AddCookerRecipe("portablecookpot", v)
    AddCookerRecipe("archive_cookpot", v)
    if v.card_def then
        AddRecipeCard("cookpot", v)
    end
end

local foods_creeps = require("preparedfoods_creeps")
for k, v in pairs (foods_creeps) do
    if v.mod and v.mod == true then
        RegisterInventoryItemAtlas(inventoryitems_atlas_creeps, v.name..".tex")
    end
    AddCookerRecipe("cookpot", v)
    AddCookerRecipe("portablecookpot", v)
    AddCookerRecipe("archive_cookpot", v)
    if v.card_def then
        AddRecipeCard("cookpot", v)
    end
end

local foods_windy = require("preparedfoods_windy")
for k, v in pairs (foods_windy) do
    if v.mod and v.mod == true then
        table.insert(Assets, Asset("ATLAS", "images/inventoryimages/"..k..".xml"))
        table.insert(Assets, Asset("IMAGE", "images/inventoryimages/"..k..".tex" ))
        RegisterInventoryItemAtlas("images/inventoryimages/"..k..".xml", v.name..".tex")
    end
    AddCookerRecipe("cookpot", v)
    AddCookerRecipe("portablecookpot", v)
    AddCookerRecipe("archive_cookpot", v)
    if v.card_def then
        AddRecipeCard("cookpot", v)
    end
end

local foods_frost = require("preparedfoods_frost")
for k, v in pairs (foods_frost) do
    if v.mod and v.mod == true then
        RegisterInventoryItemAtlas(inventoryitems_atlas_frost, v.name..".tex")
    end
    AddCookerRecipe("cookpot", v)
    AddCookerRecipe("portablecookpot", v)
    AddCookerRecipe("archive_cookpot", v)
    if v.card_def then
        AddRecipeCard("cookpot", v)
    end
end

GenerateSpicedFoods(foods_sw)
GenerateSpicedFoods(foods_ham)
GenerateSpicedFoods(foods_creeps)
GenerateSpicedFoods(foods_windy)
GenerateSpicedFoods(foods_frost)
local spicedfoods = require("spicedfoods")
for k, recipe in pairs(spicedfoods) do
    if recipe.mod and recipe.mod == true then
        recipe.official = false
        AddCookerRecipe("portablespicer", recipe)
    end
end

-- 食物属性，仅海难和哈姆
AddIngredientValues({ "butterfly_tropical_wings" }, { decoration = 2 }, true, false)

AddIngredientValues({ "limpets_cooked" }, { fish = 0.5 }, true, false)
AddIngredientValues({ "limpets" }, { fish = 0.5 }, true, false)
AddIngredientValues({ "coconut_cooked", "coconut_halved" }, { fruit = 1, fat = 1 }, true, false)
AddIngredientValues({ "coffeebeans" }, { fruit = .5 }, true, false)
AddIngredientValues({ "coffeebeans_cooked" }, { fruit = 1 }, true, false)
AddIngredientValues({ "sweet_potato" }, { veggie = 1 }, true, false)
AddIngredientValues({ "sweet_potatos_cooked" }, { veggie = 1 }, true, false)
AddIngredientValues({ "fish_med" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "dead_swordfish" }, { fish = 1.5 }, true, false)
AddIngredientValues({ "fish_raw" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish_med_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "quagmire_crabmeat" }, { fish = 0.5, crab = 1 }, true, false)
AddIngredientValues({ "quagmire_crabmeat_cooked" }, { fish = 0.5, crab = 1 }, true, false)
AddIngredientValues({ "lobster_land" }, { meat = 1.0, fish = 1.0 }, true, false)
AddIngredientValues({ "lobster_dead" }, { meat = 1.0, fish = 1.0 }, true, false)
AddIngredientValues({ "lobster_dead_cooked" }, { meat = 1.0, fish = 1.0 }, true, false)
AddIngredientValues({ "fish_dogfish" }, { fish = 1 }, true, false)
AddIngredientValues({ "mussel_cooked" }, { fish = 0.5 }, true, false)
AddIngredientValues({ "mussel" }, { fish = 0.5 }, true, false)
AddIngredientValues({ "shark_fin" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "crab" }, { fish = 0.5 }, true, false)
AddIngredientValues({ "seaweed" }, { veggie = 1 }, true, false)
AddIngredientValues({ "seaweed_cooked" }, { veggie = 1 }, true, false)
AddIngredientValues({ "seaweed_dried" }, { veggie = 1 }, true, false)
AddIngredientValues({ "doydoyegg" }, { egg = 1 }, true, false)
AddIngredientValues({ "dorsalfin" }, { inedible = 1 }, true, false)
AddIngredientValues({ "jellyfish" }, { fish = 1, jellyfish = 1, monster = 1 }, true, false)
AddIngredientValues({ "jellyfish_cooked" }, { fish = 1, jellyfish = 1, monster = 1 }, true, false)
AddIngredientValues({ "jellyfish_dead" }, { fish = 1, jellyfish = 1, monster = 1 }, true, false)
AddIngredientValues({ "jellyjerky" }, { fish = 1, jellyfish = 1, monster = 1 }, true, false)

AddIngredientValues({ "fish2" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish2_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish3" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish3_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish4" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish4_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish5" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish5_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish6" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish6_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish7" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish7_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "salmon" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "salmon_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "coi" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "coi_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "snowitem" }, { meat = 0.5, frozen = 1 }, true, false)

AddIngredientValues({ "roe" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "roe_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "quagmire_spotspice_sprig" }, { veggie = 1 }, true, false)
AddIngredientValues({ "quagmire_sap" }, { sweetener = 1 }, true, false)

AddIngredientValues({ "seataro" }, { veggie = 1, frozen = 1 }, true, false)
AddIngredientValues({ "seataro_cooked" }, { veggie = 1, frozen = 1 }, true, false)

AddIngredientValues({ "blueberries" }, { fruit = 0.5, frozen = 0.25 }, true, false)
AddIngredientValues({ "blueberries_cooked" }, { fruit = 0.75 }, true, false)

AddIngredientValues({ "seacucumber" }, { veggie = 1 }, true, false)
AddIngredientValues({ "seacucumber_cooked" }, { veggie = 1 }, true, false)

AddIngredientValues({ "gooseberry" }, { veggie = 1 }, true, false)
AddIngredientValues({ "gooseberry_cooked" }, { veggie = 1 }, true, false)

AddIngredientValues({ "quagmire_mushrooms" }, { mushroom = 1, veggie = 0.5 }, true, false)
AddIngredientValues({ "quagmire_mushrooms_cooked" }, { mushroom = 1, veggie = 0.5 }, true, false)

AddIngredientValues({ "oceanfish_small_61_inv" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "oceanfish_small_61_inv_cooked" }, { meat = 0.5, fish = 1 }, true, false)

AddIngredientValues({ "oceanfish_small_71_inv" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "oceanfish_small_71_inv_cooked" }, { meat = 0.5, fish = 1 }, true, false)

AddIngredientValues({ "oceanfish_small_81_inv" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "oceanfish_small_81_inv_cooked" }, { meat = 0.5, fish = 1 }, true, false)

AddIngredientValues({ "foliage" }, { veggie = 1 }, true, false)
AddIngredientValues({ "jellybug" }, { bug = 1 }, true, false)
AddIngredientValues({ "jellybug_cooked" }, { bug = 1 }, true, false)
AddIngredientValues({ "slugbug" }, { bug = 1 }, true, false)
AddIngredientValues({ "slugbug_cooked" }, { bug = 1 }, true, false)
AddIngredientValues({ "cutnettle" }, { antihistamine = 1 }, true, false)
AddIngredientValues({ "radish" }, { veggie = 1 }, true, false)
AddIngredientValues({ "radish_cooked" }, { veggie = 1 }, true, false)

AddIngredientValues({ "turnip" }, { veggie = 1 }, true, false)
AddIngredientValues({ "turnip_cooked" }, { veggie = 1 }, true, false)

AddIngredientValues({ "asparagus" }, { veggie = 1 }, true, false)
AddIngredientValues({ "asparagus_cooked" }, { veggie = 1 }, true, false)
AddIngredientValues({ "aloe" }, { veggie = 1 }, true, false)
AddIngredientValues({ "aloe_cooked" }, { veggie = 1 }, true, false)
AddIngredientValues({ "weevole_carapace" }, { inedible = 1 }, true, false)
AddIngredientValues({ "piko_orange" }, { filter = 1 }, true, false)
AddIngredientValues({ "snake_bone" }, { bone = 1 }, true, false)
AddIngredientValues({ "yelow_cap" }, { veggie = 0.5 }, true, false)
AddIngredientValues({ "yelow_cooked" }, { veggie = 0.5 }, true, false)

-- 食物属性，废案预留