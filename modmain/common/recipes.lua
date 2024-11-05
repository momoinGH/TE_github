local cooking = require("cooking")
local preparedFoods = require("gorge_foods")
local TechTree = require("techtree")

table.insert(TechTree.AVAILABLE_TECH, "OBSIDIAN")
table.insert(TechTree.AVAILABLE_TECH, "CITY")
table.insert(TechTree.AVAILABLE_TECH, "GODDESS")
table.insert(TechTree.AVAILABLE_TECH, "GORGE")

TECH.OBSIDIAN_ONE = {
    OBSIDIAN = 1,
}

TECH.CITY_ONE = {
    CITY = 1,
}
TECH.CITY_TWO = {
    CITY = 2,
}

TECH.GODDESS_ONE = {
    GODDESS = 1,
}
TECH.GODDESS_TWO = {
    GODDESS = 2,
}

TECH.GORGE_ONE = {
    GORGE = 1,
}
TECH.GORGE_TWO = {
    GORGE = 2,
}

for i, v in pairs(AllRecipes) do
    v.level.OBSIDIAN = v.level.OBSIDIAN or 0
    v.level.CITY = v.level.CITY or 0
    v.level.GODDESS = v.level.GODDESS or 0
    v.level.GORGE = v.level.GORGE or 0
end

RECIPETABS["OBSIDIANTAB"] = {
    str = "OBSIDIANTAB",
    sort = 90,
    icon = "tab_volcano.tex",
    icon_atlas = "images/tabs.xml",
    crafting_station = true,
}

RECIPETABS["CITY"] = {
    str = "CITY",
    sort = 91,
    icon = "tab_city.tex",
    icon_atlas = "images/tabs.xml",
    crafting_station = true,
}
AddPrototyperDef("key_to_city", {
    action_str = "CITY",
    icon_image = "tab_city.tex",
    icon_atlas = "images/tabs.xml",
    is_crafting_station = true,
})

RECIPETABS["GODDESSTAB"] = {
    str = "GODDESSTAB",
    sort = 93,
    icon = "windyfan1.tex",
    crafting_station = true,
}
AddPrototyperDef("goddess_shrine", {
    action_str = "GODDESSTAB",
    icon_image = "windyfan1.tex",
    is_crafting_station = true,
})

RECIPETABS["GORGE"] = {
    str = "GORGE",
    sort = 94,
    icon = "tab_portal_key.tex",
    icon_atlas = "images/tabs.xml",
    crafting_station = true,
}
AddPrototyperDef("quagmire_portal_key", {
    action_str = "GORGE",
    icon_image = "tab_portal_key.tex",
    icon_atlas = "images/tabs.xml",
    is_crafting_station = true,
})

local cookers = {
    grill = {"grill", "grill_small"},
    oven = {"oven"},
    pot = {"pot"},
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

AddIngredientValues({"quagmire_spotspice_ground"}, {
    spice = 1,
}, true, false)
AddIngredientValues({"syrup"}, {
    sweetener = 2,
}, true, false)
-- AddIngredientValues({"crabmeat"}, {fish=0.5, crab=1}, true, false)
-- AddIngredientValues({"tomato", "potato", "turnip", "garlic", "onion"}, {veggie=1}, true, false)
AddIngredientValues({"quagmire_flour"}, {
    flour = 1,
}, true, false)
AddIngredientValues({"rocks"}, {
    rocks = 1,
}, true, false)
AddIngredientValues({"quagmire_sap"}, {}, true, false)
AddIngredientValues({"quagmire_goatmilk"}, {
    dairy = 1,
}, true, false)
UpdateCookingIngredientTags({"red_cap", "green_cap", "blue_cap"}, {
    mushroom = 1,
})
UpdateCookingIngredientTags({"smallmeat", "smallmeat_dried", "drumstick", "froglegs"}, {
    smallmeat = 1,
})
UpdateCookingIngredientTags({"meat", "monstermeat"}, {
    bigmeat = 1,
})

AddCookerRecipe("pot", {
    name = "syrup",
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
})

local GNAW_REWARDS = {}
GLOBAL.GNAW_REWARDS = GNAW_REWARDS

for k, v in pairs(preparedFoods) do
    GNAW_REWARDS[k] = v.reward
    if v.cookers then
        for i, cookertype in ipairs(v.cookers) do
            for i, cookerprefab in ipairs(cookers[cookertype] or {}) do AddCookerRecipe(cookerprefab, v) end
        end
    else
        AddCookerRecipe("cookpot", v)
    end
end

---@param id number|nil 不填/10/100
local function OincIngredient(val, id) return Ingredient("oinc", val, nil, nil, "oinc" .. (id or "") .. ".tex") end

local function SortRecipe(a, b, filter_name, offset)
    local filter = CRAFTING_FILTERS[filter_name]
    if filter and filter.recipes then
        for sortvalue, product in ipairs(filter.recipes) do
            if product == a then
                table.remove(filter.recipes, sortvalue)
                break
            end
        end

        local target_position = #filter.recipes + 1
        for sortvalue, product in ipairs(filter.recipes) do
            if product == b then
                target_position = sortvalue + offset
                break
            end
        end
        table.insert(filter.recipes, target_position, a)
    end
end

local function SortBefore(a, b, filter_name) SortRecipe(a, b, filter_name, 0) end

local function SortAfter(a, b, filter_name) SortRecipe(a, b, filter_name, 1) end

AddRecipeFilter({
    name = "NAUTICAL",
    image = "tab_nautical.tex",
})
AddRecipeFilter({
    name = "LEGACY",
    image = "tab_archaeology.tex",
})
-- 这几个靠近科技站才有物品，平常一直都是空的，不需要额外的过滤器
-- AddRecipeFilter({ name = "OBSIDIAN", atlas = tab_atlas, image = "tab_volcano.tex" })
-- AddRecipeFilter({ name = "CITY", atlas = tab_atlas, image = "tab_city.tex" })
-- AddRecipeFilter({ name = "FORGE", atlas = tab_atlas, image = "tab_forge.tex" })
-- AddRecipeFilter({ name = "GORGE", atlas = tab_atlas, image = "tab_gorge.tex" })

if TUNING.tropical.frost_island ~= 0 then
    AddRecipe2("wildbeaver_house", {Ingredient("beaverskin", 4), Ingredient("boards", 4), Ingredient("cutstone", 3)},
               TECH.SCIENCE_TWO, {
        placer = "wildbeaver_house_placer",
    }, {"STRUCTURES"})
end

if TUNING.tropical.shipwrecked_plus then
    AddRecipe2("pandahouse", {Ingredient("pandaskin", 4), Ingredient("boards", 4), Ingredient("cutstone", 3)},
               TECH.SCIENCE_TWO, {
        placer = "pandahouse_placer",
    }, {"STRUCTURES"})
end

if TUNING.tropical.quagmire or TUNING.tropical.shipwrecked_plus then
    AddRecipe2("galinheiro", {Ingredient("seeds", 6), Ingredient("boards", 4), Ingredient("feather_chicken", 2)},
               TECH.SCIENCE_TWO, {
        placer = "galinheiro_placer",
    }, {"STRUCTURES"})
end

---------------------corrigindo bug estranho-------------
AddRecipe2("campfire", {Ingredient("cutgrass", 3), Ingredient("log", 2)}, TECH.NONE, {
    placer = "campfire_placer",
})

-- CHARACTER--
if not GetModConfigData("disablecharacters") then
    -- Walani
    AddRecipe2("surfboarditem", {Ingredient("boards", 1), Ingredient("seashell", 1)}, TECH.NONE, {
        builder_tag = "walani",
    }, {"CHARACTER"})
    -- Woodlegs
    AddRecipe2("porto_woodlegsboat", {Ingredient("boards", 4), Ingredient("dubloon", 4), Ingredient("boatcannon", 1)},
               TECH.NONE, {
        builder_tag = "woodlegs",
    }, {"CHARACTER"})
    AddRecipe2("woodlegshat", {Ingredient("boneshard", 4), Ingredient("fabric", 3), Ingredient("dubloon", 10)}, TECH.NONE,
               {
        builder_tag = "woodlegs",
    }, {"CHARACTER"})
end

-- Wormwood
AddRecipe2("poisonbalm", {Ingredient("livinglog", 1), Ingredient("venomgland", 1)}, TECH.NONE, {
    builder_tag = "plantkin",
}, {"CHARACTER"})
AddRecipe2("seaweed_stalk",
           {Ingredient("bullkelp_root", 1), Ingredient("seaweed", 3), Ingredient(CHARACTER_INGREDIENT.HEALTH, 10)},
           TECH.NONE, {
    builder_tag = "plantkin",
}, {"CHARACTER"})
-- Wedbber
AddRecipe2("mutator_tropical", {Ingredient("monstermeat", 2), Ingredient("silk", 1), Ingredient("venomgland", 1)},
           TECH.NONE, {
    builder_tag = "spiderwhisperer",
}, {"CHARACTER"})
AddRecipe2("mutator_frost", {Ingredient("monstermeat", 2), Ingredient("silk", 3), Ingredient("ice", 4)}, TECH.NONE, {
    builder_tag = "spiderwhisperer",
}, {"CHARACTER"})
-- Wurt
AddRecipe2("mermfishhouse_crafted", {Ingredient("boards", 5), Ingredient("cutreeds", 3), Ingredient("fish2", 2)},
           TECH.SCIENCE_ONE, {
    builder_tag = "merm_builder",
    placer = "mermfishhouse_crafted_placer",
    image = "mermhouse_fisher.png",
    testfn = function(pt, rot)
        local ground_tile = GLOBAL.TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
        return ground_tile and (ground_tile == GROUND.MARSH or ground_tile == GROUND.TIDALMARSH)
    end,
}, {"CHARACTER"})
AddRecipe2("mermhouse_tropical_crafted", {Ingredient("boards", 5), Ingredient("cutreeds", 3), Ingredient("fish2", 2)},
           TECH.SCIENCE_ONE, {
    builder_tag = "merm_builder",
    placer = "mermhouse_tropical_crafted_placer",
    image = "mermhouse_tropical.png",
    testfn = function(pt, rot)
        local ground_tile = GLOBAL.TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
        return ground_tile and (ground_tile == GROUND.MARSH or ground_tile == GROUND.TIDALMARSH)
    end,
}, {"CHARACTER"})
AddRecipe2("quagmire_merm_house_crafted", {Ingredient("boards", 5), Ingredient("cutstone", 3), Ingredient("salmon", 2)},
           TECH.SCIENCE_ONE, {
    builder_tag = "merm_builder",
    placer = "quagmire_merm_house_crafted_placer",
    testfn = function(pt, rot)
        local ground_tile = GLOBAL.TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
        return ground_tile and (ground_tile == GROUND.MARSH or ground_tile == GROUND.TIDALMARSH)
    end,
}, {"CHARACTER"})
AddRecipe2("mermhouse_crafted", {Ingredient("boards", 4), Ingredient("cutreeds", 3), Ingredient("pondfish", 2)},
           TECH.SCIENCE_ONE, {
    builder_tag = "merm_builder",
    placer = "mermhouse_crafted_placer",
    testfn = function(pt, rot)
        local ground_tile = GLOBAL.TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
        return ground_tile and (ground_tile == GROUND.MARSH or ground_tile == GROUND.TIDALMARSH)
    end,
}, {"CHARACTER"})
AddRecipe2("mermthrone_construction", {Ingredient("boards", 5), Ingredient("rope", 5)}, TECH.SCIENCE_ONE, {
    builder_tag = "merm_builder",
    placer = "mermthrone_construction_placer",
    testfn = function(pt, rot)
        local ground_tile = GLOBAL.TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
        return ground_tile and (ground_tile == GROUND.MARSH or ground_tile == GROUND.TIDALMARSH)
    end,
}, {"CHARACTER"})
AddRecipe2("mermwatchtower", {Ingredient("boards", 5), Ingredient("tentaclespots", 1), Ingredient("spear", 2)},
           TECH.SCIENCE_TWO, {
    builder_tag = "merm_builder",
    placer = "mermwatchtower_placer",
    testfn = function(pt, rot)
        local ground_tile = GLOBAL.TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
        return ground_tile and (ground_tile == GROUND.MARSH or ground_tile == GROUND.TIDALMARSH)
    end,
}, {"CHARACTER"})
--[[
AddRecipe2("offering_pot", { Ingredient("boards", 2), Ingredient("cutreeds", 2) }, TECH.NONE,
    {
        builder_tag = "merm_swampmaster_offeringpot",
        placer = "offering_pot_placer",
        testfn = function(pt, rot)
            local ground_tile = GLOBAL.TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
            return ground_tile and
                (ground_tile == GROUND.MARSH or ground_tile == GROUND.TIDALMARSH or ground_tile == GROUND.QUAGMIRE_PEATFOREST)
        end
    }, { "CHARACTER" })
AddRecipe2("offering_pot_upgraded",
    { Ingredient("boards", 3), Ingredient("cutreeds", 3), Ingredient("tentaclespots", 1) },
    TECH.NONE,
    {
        builder_tag = "merm_swampmaster_offeringpot_upgraded",
        placer = "offering_pot_upgraded_placer",
        testfn = function(
            pt, rot)
            local ground_tile = GLOBAL.TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
            return ground_tile and
                (ground_tile == GROUND.MARSH or ground_tile == GROUND.TIDALMARSH or ground_tile == GROUND.QUAGMIRE_PEATFOREST)
        end
    }, { "CHARACTER" })
AddRecipe2("merm_armory", { Ingredient("boards", 2), Ingredient("log", 5), Ingredient("cutgrass", 5) }, TECH.NONE,
    {
        builder_tag = "merm_swampmaster_mermarmory",
        placer = "merm_armory_placer",
        testfn = function(pt, rot)
            local ground_tile = GLOBAL.TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
            return ground_tile and
                (ground_tile == GROUND.MARSH or ground_tile == GROUND.TIDALMARSH or ground_tile == GROUND.QUAGMIRE_PEATFOREST)
        end
    }, { "CHARACTER" })
AddRecipe2("merm_armory_upgraded",
    { Ingredient("boards", 4), Ingredient("tentaclespots", 1), Ingredient("log", 5), Ingredient("cutgrass", 5) },
    TECH.NONE,
    {
        builder_tag = "merm_swampmaster_mermarmory_upgraded",
        placer = "merm_armory_upgraded_placer",
        testfn = function(pt,
                          rot)
            local ground_tile = GLOBAL.TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
            return ground_tile and
                (ground_tile == GROUND.MARSH or ground_tile == GROUND.TIDALMARSH or ground_tile == GROUND.QUAGMIRE_PEATFOREST)
        end
    }, { "CHARACTER" })
AddRecipe2("merm_toolshed", { Ingredient("boards", 2), Ingredient("twigs", 5), Ingredient("rocks", 5) }, TECH.NONE,
    {
        builder_tag = "merm_swampmaster_mermtoolshed",
        placer = "merm_toolshed_placer",
        testfn = function(pt, rot)
            local ground_tile = GLOBAL.TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
            return ground_tile and
                (ground_tile == GROUND.MARSH or ground_tile == GROUND.TIDALMARSH or ground_tile == GROUND.QUAGMIRE_PEATFOREST)
        end
    }, { "CHARACTER" })
AddRecipe2("merm_toolshed_upgraded",
    { Ingredient("boards", 4), Ingredient("tentaclespots", 1), Ingredient("twigs", 5), Ingredient("rocks", 5) },
    TECH.NONE,
    {
        builder_tag = "merm_swampmaster_mermtoolshed_upgraded",
        placer = "merm_toolshed_upgraded_placer",
        testfn = function(
            pt, rot)
            local ground_tile = GLOBAL.TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
            return ground_tile and
                (ground_tile == GROUND.MARSH or ground_tile == GROUND.TIDALMARSH or ground_tile == GROUND.QUAGMIRE_PEATFOREST)
        end
    }, { "CHARACTER" })]]
-- Maxwell
AddRecipe2("porto_shadowboat",
           {Ingredient("papyrus", 3), Ingredient("nightmarefuel", 4), Ingredient(CHARACTER_INGREDIENT.SANITY, 60)},
           TECH.NONE, {
    builder_tag = "shadowmagic",
}, {"CHARACTER"})
AddRecipe2("shadowmower_builder", {Ingredient("nightmarefuel", 2), Ingredient(GLOBAL.CHARACTER_INGREDIENT.SANITY, 60)},
           TECH.SHADOW_TWO, {
    builder_tag = "shadowmagic",
    nounlock = true,
}, {"CRAFTING_STATION"})
AddRecipe2("shadowlumber_builder", {Ingredient("nightmarefuel", 2),
                                    Ingredient(GLOBAL.CHARACTER_INGREDIENT.MAX_SANITY,
                                               GLOBAL.TUNING.SHADOWWAXWELL_SANITY_PENALTY.SHADOWLUMBER)},
           TECH.SHADOW_TWO, nil, nil, true, nil, "shadowmagic")
AddRecipe2("shadowminer_builder", {Ingredient("nightmarefuel", 2),
                                   Ingredient(GLOBAL.CHARACTER_INGREDIENT.MAX_SANITY,
                                              GLOBAL.TUNING.SHADOWWAXWELL_SANITY_PENALTY.SHADOWMINER)}, TECH.SHADOW_TWO,
           nil, nil, true, nil, "shadowmagic")
AddRecipe2("shadowdigger_builder", {Ingredient("nightmarefuel", 2),
                                    Ingredient(GLOBAL.CHARACTER_INGREDIENT.MAX_SANITY,
                                               GLOBAL.TUNING.SHADOWWAXWELL_SANITY_PENALTY.SHADOWDIGGER)},
           TECH.SHADOW_TWO, nil, nil, true, nil, "shadowmagic")
AddRecipe2("shadowduelist_builder", {Ingredient("nightmarefuel", 2),
                                     Ingredient(GLOBAL.CHARACTER_INGREDIENT.MAX_SANITY,
                                                GLOBAL.TUNING.SHADOWWAXWELL_SANITY_PENALTY.SHADOWDUELIST)},
           TECH.SHADOW_TWO, nil, nil, true, nil, "shadowmagic")
-- Wickerbottom
AddRecipe2("book_meteor", {Ingredient("papyrus", 2), Ingredient("obsidian", 2)}, TECH.SCIENCE_TWO, {
    builder_tag = "bookbuilder",
}, {"CHARACTER"})
-- WX78--
AddRecipe2("wx78module_movespeed_sw", {Ingredient("scandata", 2), Ingredient("crab", 1)}, TECH.ROBOTMODULECRAFT_ONE, {
    builder_tag = "upgrademoduleowner",
    product = "wx78module_movespeed",
}, {"CHARACTER"})
SortAfter("wx78module_movespeed_sw", "wx78module_movespeed", "CHARACTER")
AddRecipe2("wx78module_movespeed_ham", {Ingredient("scandata", 2), Ingredient("piko", 1)}, TECH.ROBOTMODULECRAFT_ONE, {
    builder_tag = "upgrademoduleowner",
    product = "wx78module_movespeed",
}, {"CHARACTER"})
SortAfter("wx78module_movespeed_ham", "wx78module_movespeed_sw", "CHARACTER")
AddRecipe2("wx78module_maxhunger_sw",
           {Ingredient("scandata", 3), Ingredient("shark_gills", 1), Ingredient("wx78module_maxhunger1", 1)},
           TECH.ROBOTMODULECRAFT_ONE, {
    builder_tag = "upgrademoduleowner",
    product = "wx78module_maxhunger",
}, {"CHARACTER"})
SortAfter("wx78module_maxhunger_sw", "wx78module_maxhunger", "CHARACTER")
AddRecipe2("wx78module_taser_ham", {Ingredient("scandata", 5), Ingredient("feather_thunder", 1)},
           TECH.ROBOTMODULECRAFT_ONE, {
    builder_tag = "upgrademoduleowner",
    product = "wx78module_taser",
}, {"CHARACTER"})
SortAfter("wx78module_taser_ham", "wx78module_taser", "CHARACTER")

-- Moon--
AddRecipe2("glassmachete", {Ingredient("twigs", 2), Ingredient("moonglass", 4)}, TECH.CELESTIAL_THREE, {
    nounlock = true,
}, {"CRAFTING_STATION"})

-- OTHER--
AddRecipe2("machete", {Ingredient("flint", 3), Ingredient("twigs", 1)}, TECH.NONE, {
}, {"TOOLS"})
AddRecipe2("goldenmachete", {Ingredient("twigs", 4), Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO, {
}, {"TOOLS"})

AddRecipe2("monkeyball", {Ingredient("cave_banana", 1), Ingredient("snakeskin", 2), Ingredient("rope", 2)},
           TECH.SCIENCE_ONE, {
}, {"TOOLS"})
AddRecipe2("chiminea", {Ingredient("log", 2), Ingredient("limestone", 3), Ingredient("sand", 2)}, TECH.NONE, {
    placer = "chiminea_placer",
}, {"LIGHT", "COOKING", "WINTER"})
AddRecipe2("bottlelantern", {Ingredient("messagebottleempty_sw", 1), Ingredient("bioluminescence", 2)}, TECH.SCIENCE_TWO,
           {
}, {"LIGHT"})

AddRecipe2("porto_sea_chiminea", {Ingredient("sand", 4), Ingredient("tar", 6), Ingredient("limestone", 6)},
           TECH.SCIENCE_ONE, {
    image = "sea_chiminea.tex",
}, {"LIGHT", "COOKING", "WINTER"})
AddRecipe2("tarlamp", {Ingredient("seashell", 1), Ingredient("tar", 1)}, TECH.SCIENCE_ONE, {
}, {"LIGHT"})
AddRecipe2("obsidianfirepit", {Ingredient("log", 3), Ingredient("obsidian", 8)}, TECH.SCIENCE_TWO, {
    placer = "obsidianfirepit_placer",
}, {"LIGHT", "COOKING", "WINTER"})
AddRecipe2("porto_researchlab5", {Ingredient("limestone", 4), Ingredient("sand", 2), Ingredient("transistor", 2)},
           TECH.SCIENCE_ONE, {
    image = "researchlab5.tex",
}, {"PROTOTYPERS", "STRUCTURES"})
AddRecipe2("icemaker", {Ingredient("heatrock", 1), Ingredient("bamboo", 5), Ingredient("transistor", 2)},
           TECH.SCIENCE_TWO, {
    placer = "icemaker_placer",
}, {"COOKING", "SUMMER", "STRUCTURES"})
AddRecipe2("quackendrill", {Ingredient("quackenbeak", 1), Ingredient("gears", 1), Ingredient("transistor", 1)},
           TECH.SCIENCE_TWO, {
}, {"TOOLS"})
AddRecipe2("fabric", {Ingredient("bamboo", 3)}, TECH.SCIENCE_ONE, {
}, {"REFINE"})
AddRecipe2("messagebottleempty_sw", {Ingredient("sand", 3)}, TECH.SCIENCE_TWO, {
}, {"REFINE"})
AddRecipe2("limestone", {Ingredient("coral", 3)}, TECH.SCIENCE_ONE, {
}, {"REFINE"})
AddRecipe2("nubbin", {Ingredient("limestone", 3), Ingredient("corallarve", 1)}, TECH.SCIENCE_ONE, {
}, {"REFINE"})
AddRecipe2("ice", {Ingredient("hail_ice", 4)}, TECH.SCIENCE_ONE, {"REFINE"})
AddRecipe2("goldnugget_sw", {Ingredient("dubloon", 3)}, TECH.SCIENCE_ONE, {
    product = "goldnugget",
}, {"REFINE"})
AddRecipe2("spear_poison", {Ingredient("spear", 1), Ingredient("venomgland", 1)}, TECH.SCIENCE_ONE, {
}, {"WEAPONS"})
AddRecipe2("cutlass", {Ingredient("goldnugget", 2), Ingredient("twigs", 1), Ingredient("dead_swordfish", 1)},
           TECH.SCIENCE_TWO, {
}, {"WEAPONS"})
AddRecipe2("coconade", {Ingredient("coconut", 1), Ingredient("gunpowder", 1), Ingredient("rope", 1)}, TECH.SCIENCE_ONE,
           {
}, {"WEAPONS"})
AddRecipe2("spear_launcher", {Ingredient("bamboo", 3), Ingredient("jellyfish", 1)}, TECH.SCIENCE_TWO, {
}, {"WEAPONS"})
AddRecipe2("blowdart_poison", {Ingredient("cutreeds", 2), Ingredient("venomgland", 1), Ingredient("feather_crow", 1)},
           TECH.SCIENCE_ONE, {
}, {"WEAPONS"})
AddRecipe2("armorseashell", {Ingredient("seashell", 10), Ingredient("rope", 1), Ingredient("seaweed", 2)},
           TECH.SCIENCE_TWO, {
}, {"ARMOUR"})
AddRecipe2("oxhat", {Ingredient("rope", 1), Ingredient("seashell", 4), Ingredient("ox_horn", 1)}, TECH.SCIENCE_ONE, {
}, {"ARMOUR"})
AddRecipe2("armorcactus", {Ingredient("needlespear", 3), Ingredient("armorwood", 1)}, TECH.SCIENCE_TWO, {
}, {"ARMOUR"})
AddRecipe2("snakeskinhat", {Ingredient("boneshard", 1), Ingredient("snakeskin", 1), Ingredient("strawhat", 1)},
           TECH.SCIENCE_TWO, {
}, {"CLOTHING", "RAIN"})
AddRecipe2("armor_snakeskin", {Ingredient("boneshard", 2), Ingredient("snakeskin", 2), Ingredient("vine", 1)},
           TECH.SCIENCE_TWO, {
}, {"CLOTHING", "RAIN", "WINTER"})
AddRecipe2("palmleaf_umbrella", {Ingredient("twigs", 4), Ingredient("petals", 6), Ingredient("palmleaf", 3)}, TECH.NONE,
           {
}, {"CLOTHING", "RAIN", "SUMMER"})
AddRecipe2("double_umbrellahat", {Ingredient("umbrella", 1), Ingredient("shark_gills", 2), Ingredient("strawhat", 2)},
           TECH.SCIENCE_TWO, {
}, {"CLOTHING", "RAIN", "SUMMER"})
AddRecipe2("aerodynamichat", {Ingredient("coconut", 1), Ingredient("shark_fin", 1), Ingredient("vine", 2)},
           TECH.SCIENCE_TWO, {
}, {"CLOTHING"})
AddRecipe2("thatchpack", {Ingredient("palmleaf", 6)}, TECH.NONE, {
}, {"CLOTHING", "CONTAINERS"})

AddRecipe2("tarsuit", {Ingredient("tar", 4), Ingredient("fabric", 2), Ingredient("palmleaf", 2)}, TECH.SCIENCE_ONE, {
}, {"CLOTHING", "RAIN"})
AddRecipe2("blubbersuit", {Ingredient("blubber", 4), Ingredient("fabric", 2), Ingredient("palmleaf", 2)},
           TECH.SCIENCE_TWO, {
}, {"CLOTHING", "RAIN", "WINTER"})
AddRecipe2("brainjellyhat", {Ingredient("coral_brain", 1), Ingredient("jellyfish", 1), Ingredient("rope", 2)},
           TECH.SCIENCE_TWO, {
}, {"CLOTHING", "PROTOTYPERS"})
AddRecipe2("armor_windbreaker", {Ingredient("blubber", 2), Ingredient("fabric", 1), Ingredient("rope", 1)},
           TECH.SCIENCE_TWO, {
}, {"CLOTHING", "RAIN"}) -- CHECK  THIS
AddRecipe2("gashat", {Ingredient("coral", 2), Ingredient("messagebottleempty_sw", 2), Ingredient("jellyfish", 1)},
           TECH.SCIENCE_TWO, {
}, {"CLOTHING"})
AddRecipe2("antivenom", {Ingredient("venomgland", 1), Ingredient("coral", 2), Ingredient("seaweed", 2)},
           TECH.SCIENCE_ONE, {
}, {"RESTORATION"})
AddRecipe2("ox_flute", {Ingredient("ox_horn", 1), Ingredient("nightmarefuel", 2), Ingredient("rope", 1)},
           TECH.MAGIC_TWO, {
}, {"MAGIC"})

AddRecipe2("sand_castle", {Ingredient("sand", 4), Ingredient("palmleaf", 2), Ingredient("seashell", 3)}, TECH.NONE, {
    placer = "sand_castle_placer",
}, {"STRUCTURES", "DECOR"})
AddRecipe2("turf_road", {Ingredient("cutstone", 1), Ingredient("flint", 2)}, TECH.SCIENCE_TWO, {
    numtogive = 4,
}, {"DECOR"})
if TUNING.tropical.only_shipwrecked then -- WHAT?
    AddRecipe2("turf_road", {Ingredient("boards", 1), Ingredient("turf_magmafield", 1)}, TECH.SCIENCE_TWO, {
        numtogive = 4,
    }, {"DECOR"})
end

AddRecipe2("dragoonden", {Ingredient("dragoonheart", 1), Ingredient("rocks", 5), Ingredient("obsidian", 4)},
           TECH.SCIENCE_TWO, {
    placer = "dragoonden_placer",
}, {"STRUCTURES"})
AddRecipe2("wildborehouse", {Ingredient("pigskin", 4), Ingredient("palmleaf", 5), Ingredient("bamboo", 8)},
           TECH.SCIENCE_TWO, {
    placer = "wildborehouse_placer",
}, {"STRUCTURES"})
AddRecipe2("primeapebarrel", {Ingredient("twigs", 10), Ingredient("cave_banana", 3), Ingredient("poop", 4)},
           TECH.SCIENCE_TWO, {
    placer = "primeapebarrel_placer",
}, {"STRUCTURES"})
AddRecipe2("porto_ballphinhouse", {Ingredient("limestone", 4), Ingredient("seaweed", 4), Ingredient("dorsalfin", 2)},
           TECH.SCIENCE_ONE, {
    image = "ballphinhouse.tex",
}, {"STRUCTURES"})
AddRecipe2("sandbag_item", {Ingredient("fabric", 2), Ingredient("sand", 3)}, TECH.SCIENCE_TWO, {
    numtogive = 4,
}, {"STRUCTURES", "DECOR"})
AddRecipe2("doydoynest", {Ingredient("twigs", 8), Ingredient("doydoyfeather", 2), Ingredient("poop", 4)},
           TECH.SCIENCE_TWO, {
    placer = "doydoynest_placer",
}, {"STRUCTURES"})
AddRecipe2("wall_limestone_item", {Ingredient("limestone", 2)}, TECH.SCIENCE_TWO, {
    numtogive = 4,
}, {"STRUCTURES", "DECOR"})
AddRecipe2("wall_enforcedlimestone_item", {Ingredient("limestone", 2), Ingredient("seaweed", 4)}, TECH.SCIENCE_ONE, {
    numtogive = 4,
}, {"STRUCTURES", "DECOR"})
AddRecipe2("seasack", {Ingredient("seaweed", 5), Ingredient("vine", 2), Ingredient("shark_gills", 1)}, TECH.SCIENCE_TWO,
           {
}, {"CONTAINERS", "COOKING", "CLOTHING"})
AddRecipe2("porto_waterchest1", {Ingredient("boards", 4), Ingredient("tar", 1)}, TECH.SCIENCE_ONE, {
    image = "waterchest1.png",
}, {"STRUCTURES", "CONTAINERS"})
AddRecipe2("mussel_stick", {Ingredient("bamboo", 2), Ingredient("vine", 1), Ingredient("seaweed", 1)}, TECH.SCIENCE_ONE,
           {
}, {"GARDENING"})
AddRecipe2("mussel_bed", {Ingredient("mussel", 1), Ingredient("coral", 1)}, TECH.SCIENCE_ONE, {
}, {"GARDENING"})
AddRecipe2("porto_fish_farm", {Ingredient("silk", 2), Ingredient("rope", 2), Ingredient("coconut", 4)},
           TECH.SCIENCE_ONE, {
    image = "fish_farm.tex",
}, {"GARDENING"})
AddRecipe2("tropicalfan", {Ingredient("cutreeds", 2), Ingredient("rope", 2), Ingredient("doydoyfeather", 5)},
           TECH.SCIENCE_TWO, {
}, {"SUMMER", "CLOTHING"})
AddRecipe2("palmleaf_hut", {Ingredient("palmleaf", 4), Ingredient("bamboo", 4), Ingredient("rope", 3)},
           TECH.SCIENCE_TWO, {
    placer = "palmleaf_hut_placer",
}, {"STRUCTURES", "RAIN", "SUMMER"})
-- AddRecipe2("goldnugget",			{Ingredient("dubloon", 3)},  																	            TECH.SCIENCE_ONE, {atlas=h_atlas}, {"REFINE"})
AddRecipe2("armorlimestone", {Ingredient("limestone", 3), Ingredient("rope", 2)}, TECH.SCIENCE_TWO, {
}, {"ARMOUR"})
AddRecipe2("bell1", {Ingredient("glommerwings", 1), Ingredient("glommerflower", 1)}, TECH.MAGIC_TWO, {
}, {"MAGIC"})
AddRecipe2("slow_farmplot", {Ingredient("cutgrass", 8), Ingredient("poop", 4), Ingredient("log", 4)}, TECH.SCIENCE_ONE,
           {
    atlas = TapDefaultAtlas,
    min_spacing = 0,
    placer = "slow_farmplot_placer",
    image = "slow_farmplot.tex",
}, {"GARDENING"})
AddRecipe2("fast_farmplot", {Ingredient("cutgrass", 10), Ingredient("poop", 6), Ingredient("rocks", 4)},
           TECH.SCIENCE_ONE, {
    atlas = TapDefaultAtlas,
    min_spacing = 0,
    placer = "fast_farmplot_placer",
    image = "fast_farmplot.tex",
}, {"GARDENING"})

-- NAUTICAL--
AddRecipe2("sail", {Ingredient("bamboo", 2), Ingredient("vine", 2), Ingredient("palmleaf", 4)}, TECH.SEAFARING_TWO, {
}, {"NAUTICAL"})
AddRecipe2("feathersail", {Ingredient("bamboo", 2), Ingredient("rope", 4), Ingredient("doydoyfeather", 4)},
           TECH.SEAFARING_TWO, {
}, {"NAUTICAL"})
AddRecipe2("clothsail", {Ingredient("bamboo", 2), Ingredient("fabric", 2), Ingredient("rope", 2)}, TECH.SEAFARING_TWO,
           {
}, {"NAUTICAL"})
AddRecipe2("snakeskinsail", {Ingredient("log", 4), Ingredient("rope", 2), Ingredient("snakeskin", 2)},
           TECH.SEAFARING_TWO, {
}, {"NAUTICAL"})
AddRecipe2("malbatrossail",
           {Ingredient("driftwood_log", 4), Ingredient("rope", 2), Ingredient("malbatross_feather", 4)},
           TECH.SEAFARING_TWO, {
}, {"NAUTICAL"})
AddRecipe2("ironwind", {Ingredient("turbine_blades", 1), Ingredient("transistor", 1), Ingredient("goldnugget", 2)},
           TECH.SEAFARING_TWO, {
}, {"NAUTICAL"})
AddRecipe2("boatrepairkit", {Ingredient("boards", 2), Ingredient("stinger", 2), Ingredient("rope", 2)},
           TECH.SEAFARING_TWO, {
}, {"NAUTICAL"})

if TUNING.tropical.only_shipwrecked or GetModConfigData("raftlog") then
    AddRecipe2("porto_lograft_old", {Ingredient("log", 6), Ingredient("cutgrass", 4)}, TECH.NONE, {
    }, {"NAUTICAL"})
    AddRecipe2("porto_raft_old", {Ingredient("bamboo", 4), Ingredient("vine", 3)}, TECH.NONE, {
    }, {"NAUTICAL"})
else
    AddRecipe2("porto_lograft", {Ingredient("log", 6), Ingredient("cutgrass", 4)}, TECH.NONE, {
    }, {"SEAFARING", "NAUTICAL"})
    AddRecipe2("porto_raft", {Ingredient("bamboo", 4), Ingredient("vine", 3)}, TECH.NONE, {
    }, {"SEAFARING", "NAUTICAL"})
end
AddRecipe2("porto_rowboat", {Ingredient("boards", 3), Ingredient("vine", 4)}, TECH.SEAFARING_TWO, {
}, {"NAUTICAL"})
AddRecipe2("porto_cargoboat", {Ingredient("boards", 6), Ingredient("rope", 3)}, TECH.SEAFARING_TWO, {
}, {"NAUTICAL"})
AddRecipe2("porto_armouredboat", {Ingredient("boards", 6), Ingredient("rope", 3), Ingredient("seashell", 10)},
           TECH.SEAFARING_TWO, {
}, {"NAUTICAL"})
AddRecipe2("porto_encrustedboat", {Ingredient("boards", 6), Ingredient("limestone", 4), Ingredient("rope", 3)},
           TECH.SEAFARING_TWO, {
}, {"NAUTICAL"})
AddRecipe2("corkboatitem", {Ingredient("rope", 1), Ingredient("cork", 4)}, TECH.NONE, {
}, {"NAUTICAL"})

AddRecipe2("boat_torch", {Ingredient("torch", 1), Ingredient("twigs", 2)}, TECH.ONE, {
}, {"NAUTICAL", "LIGHT"})
AddRecipe2("boat_lantern",
           {Ingredient("messagebottleempty_sw", 1), Ingredient("twigs", 2), Ingredient("bioluminescence", 1)},
           TECH.SCIENCE_TWO, {
}, {"NAUTICAL", "LIGHT"})
AddRecipe2("porto_buoy",
           {Ingredient("messagebottleempty_sw", 1), Ingredient("bamboo", 4), Ingredient("bioluminescence", 2)},
           TECH.SEAFARING_TWO, {
    image = "buoy.tex",
}, {"LIGHT", "STRUCTURES", "NAUTICAL"})
AddRecipe2("boatcannon", {Ingredient("coconut", 6), Ingredient("log", 5), Ingredient("gunpowder", 4)},
           TECH.SEAFARING_TWO, {
}, {"NAUTICAL"})
AddRecipe2("quackeringram", {Ingredient("quackenbeak", 1), Ingredient("bamboo", 4), Ingredient("rope", 4)},
           TECH.SEAFARING_TWO, {
}, {"NAUTICAL"})
AddRecipe2("trawlnet", {Ingredient("bamboo", 2), Ingredient("rope", 3)}, TECH.SEAFARING_TWO, {
}, {"TOOLS", "FISHING", "NAUTICAL"})
AddRecipe2("seatrap", {Ingredient("palmleaf", 4), Ingredient("messagebottleempty_sw", 2), Ingredient("jellyfish", 1)},
           TECH.SEAFARING_TWO, {
}, {"TOOLS", "GARDENING", "NAUTICAL"})

AddRecipe2("telescope", {Ingredient("goldnugget", 1), Ingredient("pigskin", 1), Ingredient("messagebottleempty_sw", 1)},
           TECH.SEAFARING_TWO, {
}, {"TOOLS", "NAUTICAL"})
AddRecipe2("supertelescope", {Ingredient("telescope", 1), Ingredient("goldnugget", 1), Ingredient("tigereye", 1)},
           TECH.SEAFARING_TWO, {
}, {"TOOLS", "NAUTICAL"})
AddRecipe2("captainhat", {Ingredient("boneshard", 1), Ingredient("seaweed", 1), Ingredient("strawhat", 1)},
           TECH.SCIENCE_TWO, {
}, {"CLOTHING", "NAUTICAL"})
AddRecipe2("piratehat", {Ingredient("boneshard", 2), Ingredient("rope", 1), Ingredient("silk", 2)}, TECH.SCIENCE_TWO, {
}, {"CLOTHING", "NAUTICAL"})
AddRecipe2("armor_lifejacket", {Ingredient("fabric", 2), Ingredient("vine", 2), Ingredient("messagebottleempty_sw", 2)},
           TECH.SEAFARING_TWO, {
}, {"CLOTHING", "NAUTICAL"})
AddRecipe2("porto_tar_extractor", {Ingredient("coconut", 2), Ingredient("bamboo", 4), Ingredient("limestone", 4)},
           TECH.SEAFARING_TWO, {
    image = "tar_extractor.tex",
}, {"STRUCTURES", "NAUTICAL"})
AddRecipe2("porto_sea_yard", {Ingredient("limestone", 6), Ingredient("tar", 6), Ingredient("log", 4)},
           TECH.SEAFARING_TWO, {
    image = "sea_yard.tex",
}, {"STRUCTURES", "NAUTICAL"})

-- SEAFARING--
AddRecipe2("boatmetal_item", {Ingredient("alloy", 4), Ingredient("iron", 4)}, TECH.SEAFARING_TWO, {
}, {"SEAFARING"})

----SW----
if GetModConfigData("Shipwrecked") ~= 1 or TUNING.tropical.multiplayerportal == 10 or TUNING.tropical.only_hamlet then
    AddRecipe2("glass_shards", {Ingredient("sand", 3)}, TECH.SCIENCE_ONE, {
    }, {"REFINE"})
    AddRecipe2("shard_sword", {Ingredient("glass_shards", 3), Ingredient("nightmarefuel", 2), Ingredient("twigs", 2)},
               TECH.MAGIC_TWO, {
    }, {"MAGIC", "WEAPONS"})
    AddRecipe2("shard_beak", {Ingredient("glass_shards", 3), Ingredient("crow", 1), Ingredient("twigs", 2)},
               TECH.MAGIC_TWO, {
    }, {"MAGIC", "WEAPONS"})
    AddRecipe2("piratihatitator", {Ingredient("parrot", 1), Ingredient("boards", 4), Ingredient("piratehat", 1)},
               TECH.SCIENCE_ONE, {
        placer = "piratihatitator_placer",
    }, {"PROTOTYPERS", "MAGIC", "STRUCTURES"})
end

-- HAMLET--
if GetModConfigData("Hamlet") ~= 5 or TUNING.tropical.multiplayerportal == 15 or TUNING.tropical.only_hamlet then -- GetModConfigData("painted_sands")
    AddRecipe2("shears", {Ingredient("twigs", 2), Ingredient("iron", 2)}, TECH.SCIENCE_ONE, {
    }, {"TOOLS"})
    AddRecipe2("bugrepellent", {Ingredient("tuber_crop", 6), Ingredient("venus_stalk", 1)}, TECH.SCIENCE_ONE, {
    }, {"TOOLS"})
    AddRecipe2("bathat", {Ingredient("pigskin", 2), Ingredient("batwing", 1), Ingredient("compass", 1)},
               TECH.SCIENCE_TWO, {
    }, {"LIGHT"})
    AddRecipe2("candlehat", {Ingredient("cork", 4), Ingredient("iron", 2)}, TECH.SCIENCE_ONE, {
    }, {"LIGHT"})
    AddRecipe2("goldnugget_ham", {Ingredient("gold_dust", 6)}, TECH.SCIENCE_ONE, {
        product = "goldnugget",
    }, {"REFINE"})
    AddRecipe2("armor_weevole", {Ingredient("weevole_carapace", 4), Ingredient("chitin", 2)}, TECH.SCIENCE_TWO, {
    }, {"ARMOUR", "RAIN"})
    AddRecipe2("antsuit", {Ingredient("chitin", 5), Ingredient("armorwood", 1)}, TECH.SCIENCE_ONE, {
    }, {"ARMOUR"})
    AddRecipe2("antmaskhat", {Ingredient("chitin", 5), Ingredient("footballhat", 1)}, TECH.SCIENCE_ONE, {
    }, {"ARMOUR"})
    AddRecipe2("metalplatehat", {Ingredient("alloy", 3), Ingredient("cork", 3)}, TECH.SCIENCE_ONE, {
    }, {"ARMOUR"})
    AddRecipe2("armor_metalplate", {Ingredient("alloy", 3), Ingredient("hammer", 1)}, TECH.SCIENCE_ONE, {
    }, {"ARMOUR"})
    AddRecipe2("halberd", {Ingredient("alloy", 1), Ingredient("twigs", 2)}, TECH.SCIENCE_ONE, {
    }, {"WEAPONS", "TOOLS"})
    AddRecipe2("cork_bat", {Ingredient("cork", 3), Ingredient("boards", 1)}, TECH.SCIENCE_ONE, {
    }, {"WEAPONS"})
    AddRecipe2("blunderbuss", {Ingredient("oinc10", 1), Ingredient("boards", 2), Ingredient("gears", 1)},
               TECH.SCIENCE_ONE, {
    }, {"WEAPONS"})
    AddRecipe2("corkchest", {Ingredient("cork", 2), Ingredient("rope", 1)}, TECH.SCIENCE_ONE, {
        min_spacing = 1,
        placer = "corkchest_placer",
    }, {"CONTAINERS", "STRUCTURES"})
    AddRecipe2("roottrunk_child",
               {Ingredient("bramble_bulb", 1), Ingredient("venus_stalk", 2), Ingredient("boards", 2)}, TECH.SCIENCE_ONE,
               {
        min_spacing = 1,
        placer = "roottrunk_child_placer",
    }, {"CONTAINERS", "STRUCTURES"})
    AddRecipe2("basefan", {Ingredient("alloy", 2), Ingredient("transistor", 2), Ingredient("gears", 1)},
               TECH.SCIENCE_TWO, {
        placer = "basefan_placer",
    }, {"STRUCTURES", "SUMMER"})
    AddRecipe2("sprinkler1", {Ingredient("alloy", 2), Ingredient("bluegem", 1), Ingredient("ice", 6)}, TECH.SCIENCE_TWO,
               {
        placer = "sprinkler1_placer",
    }, {"GARDENING"})
    AddRecipe2("smelter", {Ingredient("cutstone", 6), Ingredient("boards", 4), Ingredient("redgem", 1)},
               TECH.SCIENCE_TWO, {
        placer = "smetler_placer",
    }, {"STRUCTURES", "PROTOTYPERS"})
    AddRecipe2("disguisehat", {Ingredient("twigs", 2), Ingredient("pigskin", 1), Ingredient("beardhair", 1)},
               TECH.SCIENCE_TWO, {
    }, {"CLOTHING"})
    AddRecipe2("pithhat", {Ingredient("fabric", 1), Ingredient("vine", 3), Ingredient("cork", 6)}, TECH.SCIENCE_TWO, {
    }, {"CLOTHING"})
    AddRecipe2("thunderhat", {Ingredient("feather_thunder", 1), Ingredient("goldnugget", 1), Ingredient("cork", 2)},
               TECH.SCIENCE_TWO, {
    }, {"CLOTHING"})
    AddRecipe2("gasmaskhat", {Ingredient("peagawkfeather", 4), Ingredient("fabric", 1), Ingredient("pigskin", 1)},
               TECH.SCIENCE_ONE, {
    }, {"CLOTHING"})

    AddRecipe2("bonestaff",
               {Ingredient("pugalisk_skull", 1), Ingredient("boneshard", 1), Ingredient("nightmarefuel", 2)}, TECH.LOST,
               {
    }, {"MAGIC"})
    AddRecipe2("armorvortexcloak", {Ingredient("ancient_remnant", 5), Ingredient("armor_sanity", 1)}, TECH.LOST, {
    }, {"ARMOUR", "MAGIC", "CONTAINERS"})
    AddRecipe2("armorvoidcloak",
               {Ingredient("armorvortexcloak", 1), Ingredient("horrorfuel", 4), Ingredient("voidcloth", 4),
                Ingredient("shadowheart", 1)}, TECH.SHADOWFORGING_TWO, {
        nounlock = true,
    }, {"CRAFTING_STATION"})
    AddRecipe2("living_artifact", {Ingredient("infused_iron", 6), Ingredient("waterdrop", 1)}, TECH.LOST, {
    }, {"MAGIC"})
    AddRecipe2("honeychest", {Ingredient("chitin", 6), Ingredient("beeswax", 1), Ingredient("honey", 3)}, TECH.LOST, {
        min_spacing = 1,
        placer = "honeychest_placer",
    }, {"STRUCTURES", "CONTAINERS", "COOKING", "GARDENING"})
    AddRecipe2("pigskin", {Ingredient("bat_leather", 1)}, TECH.SCIENCE_ONE, {
    }, {"REFINE"})
    AddRecipe2("hogusporkusator",
               {Ingredient("pigskin", 4), Ingredient("boards", 4), Ingredient("feather_robin_winter", 4)},
               TECH.SCIENCE_ONE, {
        placer = "hogusporkusator_placer",
    }, {"PROTOTYPERS", "MAGIC", "STRUCTURES"})

    -- LEGACY--
    AddRecipe2("goldpan", {Ingredient("iron", 2), Ingredient("hammer", 1)}, TECH.SCIENCE_ONE, {
    }, {"TOOLS", "LEGACY"})
    AddRecipe2("ballpein_hammer", {Ingredient("iron", 2), Ingredient("twigs", 1)}, TECH.SCIENCE_ONE, {
    }, {"TOOLS", "LEGACY"})
    AddRecipe2("magnifying_glass", {Ingredient("iron", 1), Ingredient("twigs", 1), Ingredient("bluegem", 1)},
               TECH.SCIENCE_TWO, {
    }, {"TOOLS", "LEGACY"})
end

if TUNING.tropical.only_hamlet then
    AddRecipe2("antler", {Ingredient("hippo_antler", 1), Ingredient("bill_quill", 3), Ingredient("flint", 1)},
               TECH.SCIENCE_ONE, {
    }, {"TOOLS"})
    -- AddRecipe2("antler_corrupted",		{Ingredient("antler", 1), Ingredient("ancient_remnant", 2)},		                        TECH.MAGIC_TWO,   {atlas=h_atlas}, {"TOOLS","MAGIC"})
end

-- CITY--
AddRecipe2("city_hammer", {Ingredient("iron", 2), Ingredient("twigs", 1)}, TECH.CITY_TWO, {
    nounlock = true,
}, {"CITY"})
AddRecipe2("securitycontract", {Ingredient("oinc", 10)}, TECH.CITY_TWO, {
    nounlock = true,
}, {"CITY"})
AddRecipe2("turf_foundation", {Ingredient("cutstone", 1)}, TECH.CITY_TWO, {
    nounlock = true,
    numtogive = 4,
}, {"CITY"})
AddRecipe2("turf_cobbleroad", {Ingredient("cutstone", 2), Ingredient("boards", 1)}, TECH.CITY_TWO, {
    nounlock = true,
    numtogive = 4,
}, {"CITY"})
AddRecipe2("turf_checkeredlawn", {Ingredient("cutgrass", 2), Ingredient("nitre", 1)}, TECH.CITY_TWO, {
    nounlock = true,
    numtogive = 4,
}, {"CITY"})
AddRecipe2("city_lamp", {Ingredient("alloy", 1), Ingredient("transistor", 1), Ingredient("lantern", 1)}, TECH.CITY_TWO,
           {
    nounlock = true,
    min_spacing = 1,
    placer = "city_lamp_placer",
    image = "city_lamp.tex",
}, {"CITY"})
AddRecipe2("playerhouse_city_entrance", {Ingredient("boards", 4), Ingredient("cutstone", 3), Ingredient("oinc", 30)},
           TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "deed_placer",
    image = "pig_house_sale.png",
}, {"CITY"})
AddRecipe2("pighouse_city", {Ingredient("boards", 4), Ingredient("cutstone", 3), Ingredient("pigskin", 4)},
           TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "pighouse_city_placer",
    image = "pighouse_city.tex",
}, {"CITY"})
AddRecipe2("pig_guard_tower", {Ingredient("cutstone", 3), Ingredient("halberd", 1), Ingredient("pigskin", 4)},
           TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "pig_guard_tower_placer",
}, {"CITY"})
AddRecipe2("pig_guard_tower_palace", {Ingredient("cutstone", 5), Ingredient("halberd", 1), Ingredient("pigskin", 4)},
           TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "pig_guard_tower_palace_placer",
    image = "pig_royal_tower.png",
}, {"CITY"})
AddRecipe2("pig_shop_cityhall_player_entrance",
           {Ingredient("boards", 4), Ingredient("goldnugget", 4), Ingredient("pigskin", 4)}, TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "pig_shop_cityhall_placer",
    image = "pig_shop_cityhall.png",
}, {"CITY"})
AddRecipe2("pig_shop_deli_entrance", {Ingredient("boards", 4), Ingredient("honeyham", 1), Ingredient("pigskin", 4)},
           TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "pig_shop_deli_placer",
    image = "pig_shop_deli.png",
}, {"CITY"})
AddRecipe2("pig_shop_general_entrance", {Ingredient("boards", 4), Ingredient("axe", 3), Ingredient("pigskin", 4)},
           TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "pig_shop_general_placer",
    image = "pig_shop_general.png",
}, {"CITY"})
AddRecipe2("pig_shop_hoofspa_entrance", {Ingredient("boards", 4), Ingredient("bandage", 3), Ingredient("pigskin", 4)},
           TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "pig_shop_hoofspa_placer",
    image = "pig_shop_hoofspa.png",
}, {"CITY"})
AddRecipe2("pig_shop_produce_entrance", {Ingredient("boards", 4), Ingredient("eggplant", 3), Ingredient("pigskin", 4)},
           TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "pig_shop_produce_placer",
    image = "pig_shop_produce.png",
}, {"CITY"})
AddRecipe2("pig_shop_florist_entrance", {Ingredient("boards", 4), Ingredient("petals", 12), Ingredient("pigskin", 4)},
           TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "pig_shop_florist_placer",
    image = "pig_shop_florist.png",
}, {"CITY"})
AddRecipe2("pig_antiquities_entrance",
           {Ingredient("boards", 4), Ingredient("ballpein_hammer", 3), Ingredient("pigskin", 4)}, TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "pig_shop_antiquities_placer",
    image = "pig_shop_antiquities.png",
}, {"CITY"})
AddRecipe2("pig_shop_arcane_entrance",
           {Ingredient("boards", 4), Ingredient("nightmarefuel", 1), Ingredient("pigskin", 4)}, TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "pig_shop_arcane_placer",
    image = "pig_shop_arcane.png",
}, {"CITY"})
AddRecipe2("pig_shop_weapons_entrance", {Ingredient("boards", 4), Ingredient("spear", 3), Ingredient("pigskin", 4)},
           TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "pig_shop_weapons_placer",
    image = "pig_shop_weapons.png",
}, {"CITY"})
AddRecipe2("pig_academy_entrance", {Ingredient("boards", 4), Ingredient("cutstone", 3), Ingredient("pigskin", 4)},
           TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "pig_shop_academy_placer",
    image = "pig_shop_academy.png",
}, {"CITY"})
AddRecipe2("hatshop_entrance", {Ingredient("boards", 4), Ingredient("tophat", 2), Ingredient("pigskin", 4)},
           TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "pig_shop_hatshop_placer",
    image = "pig_shop_hatshop.png",
}, {"CITY"})
AddRecipe2("pig_shop_bank_entrance", {Ingredient("cutstone", 4), Ingredient("oinc", 100), Ingredient("pigskin", 4)},
           TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "pig_shop_bank_placer",
    image = "pig_shop_bank.png",
}, {"CITY"})
AddRecipe2("pig_shop_tinker_entrance", {Ingredient("magnifying_glass", 2), Ingredient("pigskin", 4)}, TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "pig_shop_tinker_placer",
    image = "pig_shop_tinker.png",
}, {"CITY"})
AddRecipe2("hedge_block", {Ingredient("clippings", 3), Ingredient("nitre", 1)}, TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "hedge_block_placer",
}, {"CITY"})
AddRecipe2("hedge_cone", {Ingredient("clippings", 3), Ingredient("nitre", 1)}, TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "hedge_cone_placer",
}, {"CITY"})
AddRecipe2("hedge_layered", {Ingredient("clippings", 3), Ingredient("nitre", 1)}, TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "hedge_layered_placer",
}, {"CITY"})
AddRecipe2("lawnornament_1", {Ingredient("cutstone", 2), Ingredient("oinc", 7)}, TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "lawnornament_1_placer",
    image = "lawnornament_1.png",
}, {"CITY"})
AddRecipe2("lawnornament_2", {Ingredient("cutstone", 2), Ingredient("oinc", 7)}, TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "lawnornament_2_placer",
    image = "lawnornament_2.png",
}, {"CITY"})
AddRecipe2("lawnornament_3", {Ingredient("cutstone", 2), Ingredient("oinc", 7)}, TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "lawnornament_3_placer",
    image = "lawnornament_3.png",
}, {"CITY"})
AddRecipe2("lawnornament_4", {Ingredient("cutstone", 2), Ingredient("oinc", 7)}, TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "lawnornament_4_placer",
    image = "lawnornament_4.png",
}, {"CITY"})
AddRecipe2("lawnornament_5", {Ingredient("cutstone", 2), Ingredient("oinc", 7)}, TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "lawnornament_5_placer",
    image = "lawnornament_5.png",
}, {"CITY"})
AddRecipe2("lawnornament_6", {Ingredient("cutstone", 2), Ingredient("oinc", 7)}, TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "lawnornament_6_placer",
    image = "lawnornament_6.png",
}, {"CITY"})
AddRecipe2("lawnornament_7", {Ingredient("cutstone", 2), Ingredient("oinc", 7)}, TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "lawnornament_7_placer",
    image = "lawnornament_7.png",
}, {"CITY"})
AddRecipe2("topiary_1", {Ingredient("cutstone", 2), Ingredient("oinc", 9)}, TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "topiary_1_placer",
    image = "topiary_1.png",
}, {"CITY"})
AddRecipe2("topiary_2", {Ingredient("cutstone", 2), Ingredient("oinc", 9)}, TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "topiary_2_placer",
    image = "topiary_2.png",
}, {"CITY"})
AddRecipe2("topiary_3", {Ingredient("cutstone", 2), Ingredient("oinc", 9)}, TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "topiary_3_placer",
    image = "topiary_3.png",
}, {"CITY"})
AddRecipe2("topiary_4", {Ingredient("cutstone", 2), Ingredient("oinc", 9)}, TECH.CITY_TWO, {
    nounlock = true,
    min_spacing = 1,
    placer = "topiary_4_placer",
    image = "topiary_4.png",
}, {"CITY"})
-- GORGE--
AddRecipe2("quagmire_swampig_house", {Ingredient("boards", 4), Ingredient("rocks", 8), Ingredient("pigskin", 4)},
           TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_swampig_house_placer",
}, {"GORGE"})

--[[AddRecipe2("dubloon",					{Ingredient("quagmire_coin1", 2)}, 	TECH.GORGE_TWO, {nounlock=true}, {"GORGE"})
AddRecipe2("oinc",						{Ingredient("quagmire_coin1", 2)},	TECH.GORGE_TWO, {nounlock=true}, {"GORGE"})
AddRecipe2("quagmire_coin1",			{Ingredient("quagmire_coin2", 1)},	TECH.GORGE_TWO, {nounlock=true}, {"GORGE"})
AddRecipe2("quagmire_coin2",			{Ingredient("quagmire_coin1", 5)},	TECH.GORGE_TWO, {nounlock=true}, {"GORGE"})
AddRecipe2("quagmire_crate_pot_hanger",	{Ingredient("quagmire_coin1", 6)},	TECH.GORGE_TWO, {nounlock=true}, {"GORGE"})
AddRecipe2("quagmire_crate_oven",		{Ingredient("quagmire_coin1", 6)},	TECH.GORGE_TWO, {nounlock=true}, {"GORGE"})
AddRecipe2("quagmire_crate_grill_small",{Ingredient("quagmire_coin1", 6)},	TECH.GORGE_TWO, {nounlock=true}, {"GORGE"})
AddRecipe2("quagmire_crate_grill",		{Ingredient("quagmire_coin1", 8)},	TECH.GORGE_TWO, {nounlock=true}, {"GORGE"})
AddRecipe2("pot_syrup",					{Ingredient("quagmire_coin1", 4)},	TECH.GORGE_TWO, {nounlock=true, image="quagmire_pot_syrup.tex"}, {"GORGE"})
AddRecipe2("pot",						{Ingredient("quagmire_coin2", 4)},	TECH.GORGE_TWO, {nounlock=true, image="quagmire_pot.tex"}, {"GORGE"})
AddRecipe2("casseroledish",				{Ingredient("quagmire_coin1", 4)},	TECH.GORGE_TWO, {nounlock=true, image="quagmire_casseroledish.tex"}, {"GORGE"})
AddRecipe2("plate_silver",				{Ingredient("quagmire_coin2", 3)},	TECH.GORGE_TWO, {atlas=gf_atlas, nounlock=true}, {"GORGE"})
AddRecipe2("bowl_silver",				{Ingredient("quagmire_coin2", 3)}, TECH.GORGE_TWO, {atlas=gf_atlas, nounlock=true}, {"GORGE"})
AddRecipe2("quagmire_key_park",			{Ingredient("quagmire_coin1", 10)},	TECH.GORGE_TWO, {nounlock=true}, {"GORGE"})
AddRecipe2("quagmire_salt_rack_item",	{Ingredient("quagmire_coin1", 8)},	TECH.GORGE_TWO, {nounlock=true}, {"GORGE"})
AddRecipe2("quagmire_slaughtertool",	{Ingredient("quagmire_coin2", 1)},	TECH.GORGE_TWO, {nounlock=true}, {"GORGE"})
AddRecipe2("quagmire_sapbucket",		{Ingredient("quagmire_coin1", 3)},	TECH.GORGE_TWO, {nounlock=true}, {"GORGE"})

AddRecipe2("quagmire_goatmilk",			{Ingredient("quagmire_coin2", 3)},	TECH.GORGE_TWO, {nounlock=true}, {"GORGE"})
AddRecipe2("quagmire_seedpacket_1",		{Ingredient("quagmire_coin1", 1)},	TECH.GORGE_TWO, {nounlock=true}, {"GORGE"})
AddRecipe2("quagmire_seedpacket_2",		{Ingredient("quagmire_coin1", 1)},	TECH.GORGE_TWO, {nounlock=true}, {"GORGE"})
AddRecipe2("quagmire_seedpacket_3",		{Ingredient("quagmire_coin1", 1)},	TECH.GORGE_TWO, {nounlock=true}, {"GORGE"})
AddRecipe2("quagmire_seedpacket_4",		{Ingredient("quagmire_coin1", 1)},	TECH.GORGE_TWO, {nounlock=true}, {"GORGE"})
AddRecipe2("quagmire_seedpacket_5",		{Ingredient("quagmire_coin1", 1)},	TECH.GORGE_TWO, {nounlock=true}, {"GORGE"})
AddRecipe2("quagmire_seedpacket_6",		{Ingredient("quagmire_coin1", 1)},	TECH.GORGE_TWO, {nounlock=true}, {"GORGE"})
AddRecipe2("quagmire_seedpacket_7",		{Ingredient("quagmire_coin1", 1)},	TECH.GORGE_TWO, {nounlock=true}, {"GORGE"})
AddRecipe2("quagmire_seedpacket_mix",	{Ingredient("quagmire_coin1", 1)},	TECH.GORGE_TWO, {nounlock=true}, {"GORGE"})]]

AddRecipe2("quagmire_crabtrap", {Ingredient("twigs", 3), Ingredient("silk", 2)}, TECH.GORGE_TWO, {
    nounlock = true,
    image = "quagmire_crabtrap.tex",
}, {"GORGE"})
AddRecipe2("quagmire_safe", {Ingredient("cutstone", 3), Ingredient("goldnugget", 2)}, TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_safe_placer",
}, {"GORGE"})

AddRecipe2("quagmire_lamp_post", {Ingredient("lantern", 1), Ingredient("cutstone", 1), Ingredient("transistor", 1)},
           TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_lamp_post_placer",
}, {"GORGE"})
AddRecipe2("quagmire_lamp_short", {Ingredient("lantern", 1), Ingredient("cutstone", 1), Ingredient("transistor", 1)},
           TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_lamp_short_placer",
}, {"GORGE"})

AddRecipe2("quagmire_altar_statue1", {Ingredient("redgem", 2), Ingredient("cutstone", 2)}, TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_altar_statue1_placer",
}, {"GORGE"})
AddRecipe2("quagmire_altar_statue2", {Ingredient("redgem", 2), Ingredient("cutstone", 1)}, TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_altar_statue2_placer",
}, {"GORGE"})
AddRecipe2("quagmire_altar_queen", {Ingredient("redgem", 2), Ingredient("purplegem", 1), Ingredient("yellowgem", 1),
                                    Ingredient("cutstone", 4)}, TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_altar_queen_placer",
}, {"GORGE"})
AddRecipe2("quagmire_altar_bollard", {Ingredient("cutstone", 1)}, TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_altar_bollard_placer",
}, {"GORGE"})
AddRecipe2("quagmire_altar_ivy", {Ingredient("cutgrass", 2), Ingredient("cutstone", 1)}, TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_altar_ivy_placer",
}, {"GORGE"})

AddRecipe2("quagmire_park_fountain", {Ingredient("purplegem", 1), Ingredient("cutstone", 1)}, TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_park_fountain_placer",
}, {"GORGE"})
AddRecipe2("quagmire_park_angel", {Ingredient("redgem", 1), Ingredient("cutstone", 2)}, TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_park_angel_placer",
}, {"GORGE"})
AddRecipe2("quagmire_park_angel2", {Ingredient("redgem", 1), Ingredient("cutstone", 2)}, TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_park_angel2_placer",
}, {"GORGE"})
AddRecipe2("quagmire_park_urn", {Ingredient("redgem", 1), Ingredient("cutstone", 2)}, TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_park_urn_placer",
}, {"GORGE"})
AddRecipe2("quagmire_park_obelisk", {Ingredient("cutstone", 3)}, TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_park_obelisk_placer",
}, {"GORGE"})

AddRecipe2("quagmire_rubble_bike", {Ingredient("wagpunk_bits", 3), Ingredient("gears", 1)}, TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_rubble_bike_placer",
}, {"GORGE"})
AddRecipe2("quagmire_rubble_carriage", {Ingredient("boards", 4)}, TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_rubble_carriage_placer",
}, {"GORGE"})
AddRecipe2("quagmire_rubble_cathedral", {Ingredient("cutstone", 3)}, TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_rubble_cathedral_placer",
}, {"GORGE"})
AddRecipe2("quagmire_rubble_chimney", {Ingredient("cutstone", 3)}, TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_rubble_chimney_placer",
}, {"GORGE"})
AddRecipe2("quagmire_rubble_chimney2", {Ingredient("cutstone", 3)}, TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_rubble_chimney2_placer",
}, {"GORGE"})
AddRecipe2("quagmire_rubble_clock", {Ingredient("cutstone", 2), Ingredient("compass", 1)}, TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_rubble_clock_placer",
}, {"GORGE"})
AddRecipe2("quagmire_rubble_clocktower", {Ingredient("cutstone", 3), Ingredient("compass", 1)}, TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_rubble_clocktower_placer",
}, {"GORGE"})
AddRecipe2("quagmire_rubble_door", {Ingredient("cutstone", 2), Ingredient("boards", 1)}, TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_rubble_door_placer",
}, {"GORGE"})
AddRecipe2("quagmire_rubble_house", {Ingredient("cutstone", 3)}, TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_rubble_house_placer",
}, {"GORGE"})
AddRecipe2("quagmire_rubble_pubdoor", {Ingredient("boards", 3)}, TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_rubble_pubdoor_placer",
}, {"GORGE"})
AddRecipe2("quagmire_rubble_roof", {Ingredient("cutstone", 2), Ingredient("boards", 1)}, TECH.GORGE_TWO, {
    nounlock = true,
    placer = "quagmire_rubble_roof_placer",
}, {"GORGE"})

-- TURFS--
-- Sw
AddRecipe2("turf_snakeskinfloor", {Ingredient("snakeskin", 2), Ingredient("fabric", 1)}, TECH.SCIENCE_TWO, {
    numtogive = 4,
}, {"DECOR"})
AddRecipe2("turf_magmafield", {Ingredient("rocks", 2), Ingredient("ash", 1)}, TECH.TURFCRAFTING_ONE, {
    numtogive = 4,
}, {"DECOR"})
AddRecipe2("turf_ash", {Ingredient("ash", 3)}, TECH.TURFCRAFTING_ONE, {
    numtogive = 4,
}, {"DECOR"})
AddRecipe2("turf_jungle", {Ingredient("bamboo", 1), Ingredient("cutgrass", 1)}, TECH.TURFCRAFTING_ONE, {
    numtogive = 4,
}, {"DECOR"})
AddRecipe2("turf_volcano", {Ingredient("nitre", 2), Ingredient("ash", 1)}, TECH.TURFCRAFTING_ONE, {
    numtogive = 4,
}, {"DECOR"})
AddRecipe2("turf_tidalmarsh", {Ingredient("cutgrass", 2), Ingredient("nitre", 1)}, TECH.TURFCRAFTING_ONE, {
    numtogive = 4,
}, {"DECOR"})
AddRecipe2("turf_meadow", {Ingredient("cutgrass", 2)}, TECH.TURFCRAFTING_ONE, {
    numtogive = 4,
}, {"DECOR"})
AddRecipe2("turf_beach", {Ingredient("sand", 2)}, TECH.TURFCRAFTING_ONE, {
    numtogive = 4,
}, {"DECOR"})

-- Ham
AddRecipe2("turf_fields", {Ingredient("turf_rainforest", 1), Ingredient("ash", 1)}, TECH.SCIENCE_TWO, {
    numtogive = 4,
}, {"DECOR"})
AddRecipe2("turf_deeprainforest", {Ingredient("bramble_bulb", 1), Ingredient("cutgrass", 2), Ingredient("ash", 1)},
           TECH.SCIENCE_TWO, {
    numtogive = 4,
}, {"DECOR"})
-- AddRecipe2("turf_suburb", 				{Ingredient("oinc", 1)}, 						                               TECH.TURFCRAFTING_ONE,  {numtogive=4}, {"DECOR"})
-- AddRecipe2("turf_gasjungle", 			{Ingredient("oinc", 1)}, 						      	                           TECH.TURFCRAFTING_ONE,  {numtogive=4}, {"DECOR"})
-- AddRecipe2("turf_checkeredlawn", 		{Ingredient("oinc", 1)}, 						  		                           TECH.TURFCRAFTING_ONE,  {numtogive=4}, {"DECOR"})
-- AddRecipe2("turf_rainforest", 			{Ingredient("oinc", 1)}, 						     	                       TECH.TURFCRAFTING_ONE,  {numtogive=4}, {"DECOR"})
-- AddRecipe2("turf_pigruins", 			{Ingredient("oinc", 1)}, 						       	                           TECH.TURFCRAFTING_ONE,  {numtogive=4}, {"DECOR"})
-- AddRecipe2("turf_antfloor", 			{Ingredient("oinc", 1)}, 						       	                           TECH.TURFCRAFTING_ONE,  {numtogive=4}, {"DECOR"})
-- AddRecipe2("turf_batfloor", 			{Ingredient("oinc", 1)}, 						       	                           TECH.TURFCRAFTING_ONE,  {numtogive=4}, {"DECOR"})
-- AddRecipe2("turf_battleground", 		{Ingredient("oinc", 1)}, 						   		                           TECH.TURFCRAFTING_ONE,  {numtogive=4}, {"DECOR"})
-- AddRecipe2("turf_painted", 				{Ingredient("oinc", 1)}, 						                               TECH.TURFCRAFTING_ONE,  {numtogive=4}, {"DECOR"})
-- AddRecipe2("turf_plains", 				{Ingredient("oinc", 1)}, 						                               TECH.TURFCRAFTING_ONE,  {numtogive=4}, {"DECOR"})
-- AddRecipe2("turf_beardrug", 			{Ingredient("oinc", 1)}, 								                           TECH.TURFCRAFTING_ONE,  {numtogive=4}, {"DECOR"})

-- Gorge
AddRecipe2("turf_quagmire_gateway", {Ingredient("cutgrass", 2), Ingredient("petals", 1)}, TECH.TURFCRAFTING_ONE, {
    numtogive = 4,
}, {"DECOR"})
AddRecipe2("turf_quagmire_citystone", {Ingredient("rocks", 2), Ingredient("nitre", 1)}, TECH.TURFCRAFTING_ONE, {
    numtogive = 4,
}, {"DECOR"})
AddRecipe2("turf_quagmire_parkfield", {Ingredient("cutgrass", 2), Ingredient("quagmire_spotspice_sprig", 1)},
           TECH.TURFCRAFTING_ONE, {
    numtogive = 4,
}, {"DECOR"})
AddRecipe2("turf_quagmire_parkstone", {Ingredient("rocks", 2), Ingredient("quagmire_spotspice_sprig", 1)},
           TECH.TURFCRAFTING_ONE, {
    numtogive = 4,
}, {"DECOR"})
AddRecipe2("turf_quagmire_peatforest", {Ingredient("charcoal", 1), Ingredient("spoiled_food", 2)},
           TECH.TURFCRAFTING_ONE, {
    numtogive = 4,
}, {"DECOR"})

GLOBAL.CONSTRUCTION_PLANS["collapsed_honeychest"] = {Ingredient("chitin", 3), Ingredient("beeswax", 1),
                                                     Ingredient("honey", 2), Ingredient("alterguardianhatshard", 1)}

-- Recipe2 Sort!
SortAfter("hammer", "pitchfork", "TOOLS")
SortBefore("chiminea", "cotl_tabernacle_level1", "LIGHT")
SortBefore("chiminea", "cotl_tabernacle_level1", "COOKING")
SortBefore("chiminea", "cotl_tabernacle_level1", "WINTER")
-- SortAfter("chiminea", "eyebrellahat", "RAIN")
SortAfter("obsidianfirepit", "firepit", "LIGHT")
SortAfter("obsidianfirepit", "firepit", "COOKING")
SortAfter("obsidianfirepit", "firepit", "WINTER")
-- SortAfter("obsidianfirepit", "firepit", "RAIN")
SortAfter("bottlelantern", "lantern", "LIGHT")
SortAfter("porto_sea_chiminea", "chiminea", "LIGHT")
SortAfter("porto_sea_chiminea", "chiminea", "COOKING")
SortAfter("porto_sea_chiminea", "chiminea", "WINTER")
-- SortAfter("porto_sea_chiminea", "chiminea", "RAIN")
SortAfter("porto_waterchest1", "treasurechest", "STRUCTURES")
SortAfter("porto_waterchest1", "treasurechest", "CONTAINERS")
SortAfter("wall_limestone_item", "wall_stone_item", "STRUCTURES")
SortAfter("wall_limestone_item", "wall_stone_item", "DECOR")
SortAfter("wall_enforcedlimestone_item", "wall_limestone_item", "STRUCTURES")
SortAfter("wall_enforcedlimestone_item", "wall_limestone_item", "DECOR")
SortAfter("wildborehouse", "pighouse", "STRUCTURES")
SortAfter("porto_ballphinhouse", "wildborehouse", "STRUCTURES")
SortAfter("primeapebarrel", "porto_ballphinhouse", "STRUCTURES")
SortAfter("dragoonden", "rabbithouse", "STRUCTURES")
SortAfter("turf_snakeskinfloor", "turf_carpetfloor", "DECOR")
SortAfter("sandbag_item", "wall_dreadstone_item", "STRUCTURES")
-- SortAfter("sandbag_item", "lightning_rod", "RAIN")
SortAfter("sandbag_item", "wall_dreadstone_item", "DECOR")
SortAfter("sand_castle", "sisturn", "STRUCTURES")
SortAfter("sand_castle", "endtable", "DECOR")
SortAfter("mussel_stick", "premiumwateringcan", "GARDENING")
SortAfter("slow_farmplot", "seedpouch", "GARDENING")
SortAfter("fast_farmplot", "slow_farmplot", "GARDENING")
SortAfter("porto_fish_farm", "fast_farmplot", "GARDENING")
SortAfter("mussel_bed", "compostwrap", "GARDENING")
SortAfter("monkeyball", "megaflare", "TOOLS")
SortAfter("palmleaf_umbrella", "grass_umbrella", "RAIN")
SortAfter("palmleaf_umbrella", "grass_umbrella", "SUMMER")
SortAfter("palmleaf_umbrella", "grass_umbrella", "CLOTHING")
SortAfter("antivenom", "lifeinjector", "RESTORATION")
SortBefore("thatchpack", "backpack", "CONTAINERS")
SortBefore("thatchpack", "backpack", "CLOTHING")
SortAfter("seasack", "icepack", "CONTAINERS")
SortAfter("seasack", "icepack", "COOKING")
SortAfter("seasack", "icepack", "CLOTHING")
SortAfter("palmleaf_hut", "siestahut", "STRUCTURES")
SortBefore("palmleaf_hut", "lightning_rod", "RAIN")
SortAfter("palmleaf_hut", "siestahut", "SUMMER")
SortAfter("tropicalfan", "featherfan", "SUMMER")
SortAfter("tropicalfan", "featherfan", "CLOTHING")
SortAfter("doydoynest", "rabbithouse", "STRUCTURES")
SortAfter("machete", "axe", "TOOLS")
SortAfter("goldenmachete", "goldenaxe", "TOOLS")
SortAfter("porto_researchlab5", "researchlab2", "PROTOTYPERS")
SortAfter("porto_researchlab5", "researchlab2", "STRUCTURES")
SortBefore("icemaker", "icebox", "COOKING")
SortAfter("icemaker", "firesuppressor", "SUMMER")
SortAfter("icemaker", "smelter", "STRUCTURES")
SortAfter("piratihatitator", "researchlab4", "PROTOTYPERS")
SortAfter("piratihatitator", "researchlab4", "MAGIC")
SortAfter("piratihatitator", "researchlab4", "STRUCTURES")
SortAfter("hogusporkusator", "piratihatitator", "PROTOTYPERS")
SortAfter("hogusporkusator", "piratihatitator", "MAGIC")
SortAfter("hogusporkusator", "piratihatitator", "STRUCTURES")
SortAfter("ox_flute", "panflute", "MAGIC")
-- SortAfter("shipwrecked_entrance", "telebase", "MAGIC")
-- SortAfter("shipwrecked_entrance", "telebase", "STRUCTURES")
SortAfter("fabric", "beeswax", "REFINE")
SortAfter("limestone", "fabric", "REFINE")
SortAfter("nubbin", "limestone", "REFINE")
SortAfter("goldnugget", "nubbin", "REFINE")
SortAfter("ice", "goldnugget", "REFINE")
SortAfter("messagebottleempty", "ice", "REFINE")
SortAfter("spear_poison", "spear", "WEAPONS")
SortAfter("armorseashell", "armorwood", "ARMOUR")
SortAfter("armorlimestone", "armormarble", "ARMOUR")
SortAfter("armorcactus", "armorlimestone", "ARMOUR")
SortAfter("oxhat", "footballhat", "ARMOUR")
SortAfter("blowdart_poison", "blowdart_fire", "WEAPONS")
SortAfter("coconade", "gunpowder", "WEAPONS")
SortAfter("spear_launcher", "spear_wathgrithr_lightning", "WEAPONS")
SortAfter("cutlass", "nightstick", "WEAPONS")
SortAfter("brainjellyhat", "researchlab3", "PROTOTYPERS")
SortAfter("brainjellyhat", "catcoonhat", "CLOTHING")
-- SortAfter("shark_teethhat", "brainjellyhat", "CLOTHING")
SortAfter("snakeskinhat", "rainhat", "CLOTHING")
SortAfter("snakeskinhat", "rainhat", "RAIN")
SortAfter("armor_snakeskin", "raincoat", "CLOTHING")
SortAfter("armor_snakeskin", "raincoat", "RAIN")
SortAfter("armor_snakeskin", "raincoat", "WINTER")
SortAfter("blubbersuit", "armor_snakeskin", "CLOTHING")
SortAfter("blubbersuit", "armor_snakeskin", "RAIN")
SortAfter("blubbersuit", "armor_snakeskin", "WINTER")
SortAfter("tarsuit", "blubbersuit", "CLOTHING")
SortAfter("tarsuit", "blubbersuit", "RAIN")
SortAfter("armor_windbreaker", "tarsuit", "CLOTHING")
SortAfter("armor_windbreaker", "tarsuit", "RAIN")
SortAfter("gashat", "brainjellyhat", "CLOTHING")
SortAfter("aerodynamichat", "gasmaskhat", "CLOTHING")
SortAfter("double_umbrellahat", "eyebrellahat", "CLOTHING")
SortAfter("double_umbrellahat", "eyebrellahat", "RAIN")
SortAfter("double_umbrellahat", "eyebrellahat", "SUMMER")
SortBefore("tarlamp", "lantern", "LIGHT")
SortAfter("boat_torch", "coldfirepit", "LIGHT")
SortAfter("boat_lantern", "boat_torch", "LIGHT")
SortAfter("seatrap", "birdtrap", "TOOLS")
SortAfter("seatrap", "birdtrap", "GARDENING")
SortAfter("trawlnet", "oceanfishingrod", "TOOLS")
SortAfter("trawlnet", "oceanfishingrod", "FISHING")
SortAfter("telescope", "compass", "TOOLS")
SortAfter("supertelescope", "telescope", "TOOLS")
SortAfter("captainhat", "bushhat", "CLOTHING")
SortAfter("piratehat", "captainhat", "CLOTHING")
SortAfter("armor_lifejacket", "armor_windbreaker", "CLOTHING")
SortBefore("porto_buoy", "nightlight", "STRUCTURES")
SortAfter("porto_buoy", "boat_lantern", "LIGHT")
SortAfter("quackendrill", "trawlnet", "TOOLS")
SortAfter("porto_tar_extractor", "icemaker", "STRUCTURES")
SortAfter("porto_sea_yard", "porto_tar_extractor", "STRUCTURES")
SortAfter("turf_jungle", "turf_monkey_ground", "DECOR")
SortAfter("turf_meadow", "turf_jungle", "DECOR")
SortAfter("turf_tidalmarsh", "turf_meadow", "DECOR")
SortAfter("turf_magmafield", "turf_tidalmarsh", "DECOR")
SortAfter("turf_ash", "turf_magmafield", "DECOR")
SortAfter("turf_volcano", "turf_ash", "DECOR")
SortAfter("turf_beach", "turf_volcano", "DECOR")
-- SortAfter("obsidianmachete", "blueprint_craftingset_ruinsglow_builder", "CRAFTING_STATION")
-- SortAfter("obsidianaxe", "obsidianmachete", "CRAFTING_STATION")
-- SortAfter("spear_obsidian", "obsidianaxe", "CRAFTING_STATION")
-- SortAfter("volcanostaff", "spear_obsidian", "CRAFTING_STATION")
-- SortAfter("wind_conch", "obsidiancoconade", "CRAFTING_STATION")
-- SortAfter("windstaff", "wind_conch", "CRAFTING_STATION")
-- SortAfter("woodlegs_boatcannon", "obsidiancoconade", "OBSIDIAN")
-- SortAfter("turf_ruinsbrick_glow_blueprint", "windstaff", "CRAFTING_STATION")
-- SortAfter("chesspiece_kraken_builder", "chesspiece_klaus_builder", "CRAFTING_STATION")--海妖雕塑
-- SortAfter("chesspiece_tigershark_builder", "chesspiece_kraken_builder", "CRAFTING_STATION")--虎鲨雕塑
-- SortAfter("chesspiece_twister_builder", "chesspiece_tigershark_builder", "CRAFTING_STATION")--豹卷风雕塑
-- SortAfter("chesspiece_seal_builder", "chesspiece_twister_builder", "CRAFTING_STATION")--海豹雕塑
SortAfter("surfboarditem", "wx78_scanner_item", "CHARACTER")
-- SortBefore("surfboarditem", "boat_lograft", "SEAFARING")
-- SortAfter("woodlegshat", "piratehat", "SEAFARING")
-- SortAfter("woodlegshat", "mermhat", "CLOTHING")
SortAfter("woodlegshat", "surfboarditem", "CHARACTER")
-- SortAfter("boat_woodlegs", "boat_encrusted", "SEAFARING")
-- SortAfter("boat_woodlegs", "woodlegshat", "CHARACTER")
-- SortAfter("transmute_bamboo", "transmute_twigs", "CHARACTER")--ia改威吊技能树：化藤蔓为竹子。
-- SortAfter("transmute_vine", "transmute_bamboo", "CHARACTER")--ia改威吊技能树：化竹子为藤蔓。
-- SortBefore("transmute_dubloons", "transmute_goldnugget", "CHARACTER")--ia改威吊技能树：化金块为金币。
-- SortAfter("transmute_sand", "transmute_moonrocknugget", "CHARACTER")--ia改威吊技能树：化石灰岩为沙子。
-- SortAfter("transmute_limestone", "transmute_sand", "CHARACTER")--ia改威吊技能树：化沙子为石灰岩。
-- SortAfter("transmute_obsidian", "transmute_opalpreciousgem", "CHARACTER")--ia改威吊技能树：化呆龙心脏为黑曜石。
-- SortAfter("transmute_dragoonheart", "transmute_obsidian", "CHARACTER")--ia改威吊技能树：化黑曜石为呆龙心脏。
-- SortAfter("transmute_jelly", "transmute_smallmeat", "CHARACTER")--ia改威吊技能树：化彩虹水母为水母。
-- SortAfter("transmute_rainbowjelly", "transmute_jelly", "CHARACTER")--ia改威吊技能树：化水母为彩虹水母。
SortAfter("book_meteor", "book_sleep", "CHARACTER")
SortAfter("mutator_tropical", "mutator_warrior", "CHARACTER")
SortAfter("mutator_frost", "mutator_moon", "CHARACTER")
-- SortAfter("poisonbalm", "antivenom", "RESTORATION")
SortAfter("poisonbalm", "livinglog", "CHARACTER")
SortAfter("seaweed_stalk", "wormwood_lureplant", "CHARACTER")
SortAfter("mermfishhouse", "mermwatchtower", "CHARACTER")
-- SortAfter("mermfishhouse", "mermwatchtower", "STRUCTURES")
-- SortAfter("wurt_turf_tidalmarsh", "wurt_turf_marsh", "CHARACTER")
-- SortAfter("slingshotammo_obsidian", "slingshotammo_thulecite", "CHARACTER")--ia沃尔特配方：黑曜石弹
-- SortBefore("slingshotammo_limestone", "slingshotammo_marble", "CHARACTER")--ia沃尔特配方：石灰岩弹
-- SortAfter("slingshotammo_tar", "slingshotammo_poop", "CHARACTER")--ia沃尔特配方：焦油黏弹
SortAfter("shard_sword", "nightsword", "WEAPONS")
SortAfter("shard_beak", "shard_sword", "WEAPONS")
SortAfter("shard_sword", "nightsword", "MAGIC")
SortAfter("shard_beak", "shard_sword", "MAGIC")

SortAfter("shears", "goldenpitchfork", "TOOLS")
SortAfter("halberd", "shears", "TOOLS")
SortAfter("bugrepellent", "reskin_tool", "TOOLS")
SortAfter("goldpan", "bugrepellent", "TOOLS")
SortAfter("ballpein_hammer", "goldpan", "TOOLS")
SortAfter("magnifying_glass", "ballpein_hammer", "TOOLS")

SortAfter("bathat", "molehat", "LIGHT")
SortAfter("candlehat", "cotl_tabernacle_level1", "LIGHT")

SortAfter("smelter", "firesuppressor", "STRUCTURES")
SortAfter("smelter", "wintersfeastoven", "PROTOTYPERS")
SortAfter("basefan", "smelter", "STRUCTURES")
SortAfter("basefan", "icemaker", "SUMMER")

SortAfter("glass_shards", "messagebottleempty", "REFINE")
SortAfter("pigskin", "bearger_fur", "REFINE")

SortAfter("halberd", "boomerang", "WEAPONS")
SortAfter("cork_bat", "halberd", "WEAPONS")
SortAfter("blunderbuss", "shard_beak", "WEAPONS")

SortAfter("armor_weevole", "cookiecutterhat", "ARMOUR")
SortAfter("antsuit", "beehat", "ARMOUR")
SortAfter("antmaskhat", "antsuit", "ARMOUR")
SortAfter("armor_metalplate", "antmaskhat", "ARMOUR")
SortAfter("metalplatehat", "armor_metalplate", "ARMOUR")

SortAfter("disguisehat", "mermhat", "CLOTHING")
SortBefore("pithhat", "snakeskinhat", "CLOTHING")
SortAfter("gasmaskhat", "gashat", "CLOTHING")
SortAfter("thunderhat", "snakeskinhat", "CLOTHING")

SortAfter("bell1", "ox_flute", "MAGIC")
SortAfter("bonestaff", "icestaff", "MAGIC")
SortAfter("armorvortexcloak", "armor_sanity", "ARMOUR")
SortAfter("armorvortexcloak", "armor_sanity", "MAGIC")
SortAfter("armorvortexcloak", "seedpouch", "CONTAINERS")
SortAfter("armorvoidcloak", "voidclothhat", "CRAFTING_STATION")
-- SortAfter("antler_corrupted", "armorvortexcloak", "MAGIC")--噩梦鸟笛(未来)
SortAfter("living_artifact", "armorvortexcloak", "MAGIC")

SortAfter("turf_fields", "turf_beach", "DECOR")
SortAfter("turf_deeprainforest", "turf_fields", "DECOR")
SortAfter("turf_quagmire_gateway", "turf_deeprainforest", "DECOR")
SortAfter("turf_quagmire_citystone", "turf_quagmire_gateway", "DECOR")
SortAfter("turf_quagmire_parkfield", "turf_quagmire_citystone", "DECOR")
SortAfter("turf_quagmire_parkstone", "turf_quagmire_parkfield", "DECOR")
SortAfter("turf_quagmire_peatforest", "turf_quagmire_parkstone", "DECOR")

SortAfter("corkchest", "porto_waterchest1", "STRUCTURES")
SortAfter("corkchest", "porto_waterchest1", "CONTAINERS")
SortAfter("roottrunk_child", "corkchest", "STRUCTURES")
SortAfter("roottrunk_child", "corkchest", "CONTAINERS")
SortBefore("chestupgrade_stacksize", "treasurechest", "CONTAINERS")

SortAfter("honeychest", "saltbox", "STRUCTURES")
SortAfter("honeychest", "saltbox", "CONTAINERS")
SortAfter("honeychest", "saltbox", "COOKING")
SortAfter("honeychest", "beebox", "GARDENING")
SortBefore("sprinkler1", "beebox", "GARDENING")

SortAfter("porto_lograft", "seafaring_prototyper", "SEAFARING")
SortAfter("porto_raft", "porto_lograft", "SEAFARING")
SortAfter("boatmetal_item", "boat_item", "SEAFARING")

SortAfter("armor_weevole", "armor_windbreaker", "RAIN")

SortAfter("seafaring_prototyper", "researchlab3", "PROTOTYPERS")
SortAfter("tacklestation", "seafaring_prototyper", "PROTOTYPERS")
SortAfter("cartographydesk", "tacklestation", "PROTOTYPERS")

SortAfter("porto_shadowboat", "waxwelljournal", "CHARACTER")

SortAfter("mermhouse_tropical_crafted", "mermhouse_crafted", "CHARACTER")
SortAfter("mermfishhouse_crafted", "mermhouse_tropical_crafted", "CHARACTER")
SortAfter("quagmire_merm_house_crafted", "mermfishhouse_crafted", "CHARACTER")
