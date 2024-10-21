local TechTree = require("techtree")

table.insert(TechTree.AVAILABLE_TECH, "OBSIDIAN_TWO")

TECH.OBSIDIAN_TWO = { OBSIDIAN = 2 }

for i, v in pairs(AllRecipes) do
    v.level.OBSIDIAN_TWO = v.level.OBSIDIAN_TWO or 0
end

AddPrototyperDef("obsidian_workbench", {
    action_str = "OBSIDIANTAB",
    icon_image = "tab_volcano.tex",
    icon_atlas = "images/tabs.xml",
    is_crafting_station = true
})

-- 黑曜石
AddRecipe2("axeobsidian",
    { Ingredient("axe", 1), Ingredient("obsidian", 2, v_atlas), Ingredient("dragoonheart", 1, v_atlas) },
    TECH.OBSIDIAN_TWO, { nounlock = true }, { "OBSIDIAN" })
AddRecipe2("armorobsidian",
    { Ingredient("armorwood", 1), Ingredient("obsidian", 5, v_atlas), Ingredient("dragoonheart", 1, v_atlas) },
    TECH.OBSIDIAN_TWO, { nounlock = true }, { "OBSIDIAN" })
AddRecipe2("obsidianmachete",
    { Ingredient("machete", 1, v_atlas), Ingredient("obsidian", 3, v_atlas), Ingredient("dragoonheart", 1, v_atlas) },
    TECH.OBSIDIAN_TWO, { nounlock = true }, { "OBSIDIAN" })
AddRecipe2("spear_obsidian",
    { Ingredient("spear", 1), Ingredient("obsidian", 3, v_atlas), Ingredient("dragoonheart", 1, v_atlas) },
    TECH.OBSIDIAN_TWO, { nounlock = true }, { "OBSIDIAN" })
AddRecipe2("volcanostaff",
    { Ingredient("firestaff", 1), Ingredient("obsidian", 4, v_atlas), Ingredient("dragoonheart", 1, v_atlas) },
    TECH.OBSIDIAN_TWO, { nounlock = true }, { "OBSIDIAN" })

AddRecipe2("obsidianbomb",
    { Ingredient("coconade", 3, v_atlas), Ingredient("obsidian", 3, v_atlas), Ingredient("dragoonheart", 1, v_atlas) },
    TECH.OBSIDIAN_TWO, { nounlock = true, numtogive = 3 }, { "OBSIDIAN" })
AddRecipe2("woodlegs_boatcannon",
    { Ingredient("obsidian", 6, v_atlas), Ingredient("log", 5), Ingredient("gunpowder", 4) },
    TECH.SEAFARING_TWO, nil, { "OBSIDIAN" })
AddRecipe2("wind_conch",
    { Ingredient("obsidian", 4, v_atlas), Ingredient("purplegem", 1), Ingredient("magic_seal", 1, h_atlas) },
    TECH.OBSIDIAN_TWO, { nounlock = true }, { "OBSIDIAN" })
AddRecipe2("sail_stick",
    { Ingredient("obsidian", 2, v_atlas), Ingredient("nightmarefuel", 3), Ingredient("magic_seal", 1, h_atlas) },
    TECH.OBSIDIAN_TWO, { nounlock = true }, { "OBSIDIAN" })
