local Ig = Ingredient
local v_atlas = "images/inventoryimages/inventory_shipwrecked.xml"

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
AddRecipe2("obsidianaxe", { Ig("axe", 1), Ig("obsidian", 2, v_atlas), Ig("dragoonheart", 1, v_atlas) }, TECH.OBSIDIAN_TWO, { nounlock = true }, { "OBSIDIAN" })
AddRecipe2("armorobsidian", { Ig("armorwood", 1), Ig("obsidian", 5, v_atlas), Ig("dragoonheart", 1, v_atlas) }, TECH.OBSIDIAN_TWO, { nounlock = true }, { "OBSIDIAN" })
AddRecipe2("obsidianmachete", { Ig("machete", 1, v_atlas), Ig("obsidian", 3, v_atlas), Ig("dragoonheart", 1, v_atlas) }, TECH.OBSIDIAN_TWO, { nounlock = true }, { "OBSIDIAN" })
AddRecipe2("spear_obsidian", { Ig("spear", 1), Ig("obsidian", 3, v_atlas), Ig("dragoonheart", 1, v_atlas) }, TECH.OBSIDIAN_TWO, { nounlock = true }, { "OBSIDIAN" })
AddRecipe2("volcanostaff", { Ig("firestaff", 1), Ig("obsidian", 4, v_atlas), Ig("dragoonheart", 1, v_atlas) }, TECH.OBSIDIAN_TWO, { nounlock = true }, { "OBSIDIAN" })
AddRecipe2("obsidiancoconade", { Ig("coconade", 3, v_atlas), Ig("obsidian", 3, v_atlas), Ig("dragoonheart", 1, v_atlas) }, TECH.OBSIDIAN_TWO, { nounlock = true, numtogive = 3 },
    { "OBSIDIAN" })
AddRecipe2("obsidian_boatcannon", { Ig("obsidian", 6, v_atlas), Ig("log", 5), Ig("gunpowder", 4) }, TECH.SEAFARING_TWO, nil, { "OBSIDIAN" })
AddRecipe2("wind_conch", { Ig("obsidian", 4, v_atlas), Ig("purplegem", 1), Ig("magic_seal", 1, v_atlas) }, TECH.OBSIDIAN_TWO, { nounlock = true }, { "OBSIDIAN" })
AddRecipe2("sail_stick", { Ig("obsidian", 2, v_atlas), Ig("nightmarefuel", 3), Ig("magic_seal", 1, v_atlas) }, TECH.OBSIDIAN_TWO, { nounlock = true }, { "OBSIDIAN" })

AddRecipe2("porto_sea_yard", { Ig("limestone", 6), Ig("tar", 6), Ig("log", 4) }, TECH.SEAFARING_TWO, nil, { "STRUCTURES", "NAUTICAL" })
AddRecipe2("seatrap", { Ingredient("palmleaf", 4), Ingredient("messagebottleempty_sw", 2), Ingredient("jellyfish", 1) }, TECH.SEAFARING_TWO, nil,
{ "TOOLS", "GARDENING", "NAUTICAL" })
