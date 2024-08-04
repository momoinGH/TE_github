local v_atlas = "images/inventoryimages/volcanoinventory.xml"
local h_atlas = "images/inventoryimages/hamletinventory.xml"
local hm_atlas = "map_icons/hamleticon.xml"
local cm_atlas = "map_icons/creepindedeepicon.xml"
local g_atlas = "images/quagmire_food_common_inv_images.xml"
local tab_atlas = "images/tabs.xml"

TECH.OBSIDIAN_TWO = { OBSIDIAN = 2 }

AddRecipe2("axeobsidian",
    { Ingredient("axe", 1), Ingredient("obsidian", 2, v_atlas), Ingredient("dragoonheart", 1, v_atlas) },
    TECH.OBSIDIAN_TWO, { atlas = v_atlas, nounlock = true }, { "OBSIDIAN" })
AddRecipe2("armorobsidian",
    { Ingredient("armorwood", 1), Ingredient("obsidian", 5, v_atlas), Ingredient("dragoonheart", 1, v_atlas) },
    TECH.OBSIDIAN_TWO, { atlas = v_atlas, nounlock = true }, { "OBSIDIAN" })
