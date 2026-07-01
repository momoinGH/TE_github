local Ig = Ingredient

TroAddTech("GORGE", {
    max_level = 2,
    atlas = "images/tabs.xml",
    image = "tab_portal_key.tex"
})

TroAddPrototyperDef("quagmire_portal_key", {
    action_str = "GORGE",
    icon_image = "tab_portal_key.tex",
    icon_atlas = "images/tabs.xml",
})


-- GORGE--
AddRecipe2("quagmire_swampig_house", { Ingredient("boards", 4), Ingredient("rocks", 8), Ingredient("pigskin", 4) },
    TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_swampig_house_placer" }, { "GORGE" })
AddRecipe2("quagmire_flour", { Ingredient("wheat", 2) }, TECH.FOODPROCESSING_ONE, { nounlock = true },
    { "REFINE", "COOKING" })
AddRecipe2("quagmire_spotspice_ground", { Ingredient("quagmire_spotspice_sprig", 3) }, TECH.FOODPROCESSING_ONE,
    { nounlock = true }, { "REFINE", "COOKING" })

AddRecipe2("quagmire_crabtrap", { Ingredient("twigs", 3), Ingredient("silk", 2) }, TECH.GORGE_TWO,
    { nounlock = true, image = "quagmire_crabtrap.tex", }, { "GORGE" })
AddRecipe2("quagmire_safe", { Ingredient("cutstone", 3), Ingredient("goldnugget", 2) }, TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_safe_placer", }, { "GORGE" })

AddRecipe2("quagmire_lamp_post", { Ingredient("lantern", 1), Ingredient("cutstone", 1), Ingredient("transistor", 1) },
    TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_lamp_post_placer" }, { "GORGE" })
AddRecipe2("quagmire_lamp_short", { Ingredient("lantern", 1), Ingredient("cutstone", 1), Ingredient("transistor", 1) },
    TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_lamp_short_placer", }, { "GORGE" })

AddRecipe2("quagmire_altar_statue1", { Ingredient("redgem", 2), Ingredient("cutstone", 2) }, TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_altar_statue1_placer", },
    { "GORGE" })
AddRecipe2("quagmire_altar_statue2", { Ingredient("redgem", 2), Ingredient("cutstone", 1) }, TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_altar_statue2_placer", },
    { "GORGE" })
AddRecipe2("quagmire_altar_queen", { Ingredient("redgem", 2), Ingredient("purplegem", 1),
    Ingredient("yellowgem", 1), Ingredient("cutstone", 4) }, TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_altar_queen_placer", }, { "GORGE" })
AddRecipe2("quagmire_altar_bollard", { Ingredient("cutstone", 1) }, TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_altar_bollard_placer", }, { "GORGE" })
AddRecipe2("quagmire_altar_ivy", { Ingredient("cutgrass", 2), Ingredient("cutstone", 1) }, TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_altar_ivy_placer", }, { "GORGE" })

AddRecipe2("quagmire_park_fountain", { Ingredient("purplegem", 1), Ingredient("cutstone", 1) }, TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_park_fountain_placer", },
    { "GORGE" })
AddRecipe2("quagmire_park_angel", { Ingredient("redgem", 1), Ingredient("cutstone", 2) }, TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_park_angel_placer", }, { "GORGE" })
AddRecipe2("quagmire_park_angel2", { Ingredient("redgem", 1), Ingredient("cutstone", 2) }, TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_park_angel2_placer", }, { "GORGE" })
AddRecipe2("quagmire_park_urn", { Ingredient("redgem", 1), Ingredient("cutstone", 2) }, TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_park_urn_placer", }, { "GORGE" })
AddRecipe2("quagmire_park_obelisk", { Ingredient("cutstone", 3) }, TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_park_obelisk_placer", }, { "GORGE" })

AddRecipe2("quagmire_rubble_bike", { Ingredient("wagpunk_bits", 3), Ingredient("gears", 1) }, TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_rubble_bike_placer", },
    { "GORGE" })
AddRecipe2("quagmire_rubble_carriage", { Ingredient("boards", 4) }, TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_rubble_carriage_placer", }, { "GORGE" })
AddRecipe2("quagmire_rubble_cathedral", { Ingredient("cutstone", 3) }, TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_rubble_cathedral_placer", }, { "GORGE" })
AddRecipe2("quagmire_rubble_chimney", { Ingredient("cutstone", 3) }, TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_rubble_chimney_placer", }, { "GORGE" })
AddRecipe2("quagmire_rubble_chimney2", { Ingredient("cutstone", 3) }, TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_rubble_chimney2_placer", }, { "GORGE" })
AddRecipe2("quagmire_rubble_clock", { Ingredient("cutstone", 2), Ingredient("compass", 1) }, TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_rubble_clock_placer", },
    { "GORGE" })
AddRecipe2("quagmire_rubble_clocktower", { Ingredient("cutstone", 3), Ingredient("compass", 1) }, TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_rubble_clocktower_placer", },
    { "GORGE" })
AddRecipe2("quagmire_rubble_door", { Ingredient("cutstone", 2), Ingredient("boards", 1) }, TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_rubble_door_placer", }, { "GORGE" })
AddRecipe2("quagmire_rubble_house", { Ingredient("cutstone", 3) }, TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_rubble_house_placer", }, { "GORGE" })
AddRecipe2("quagmire_rubble_pubdoor", { Ingredient("boards", 3) }, TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_rubble_pubdoor_placer", }, { "GORGE" })
AddRecipe2("quagmire_rubble_roof", { Ingredient("cutstone", 2), Ingredient("boards", 1) }, TECH.GORGE_TWO,
    { nounlock = true, placer = "quagmire_rubble_roof_placer", }, { "GORGE" })


-- Gorge
AddRecipe2("turf_quagmire_gateway", { Ingredient("cutgrass", 2), Ingredient("petals", 1) }, TECH.TURFCRAFTING_ONE,
    { numtogive = 4 }, { "DECOR" })
AddRecipe2("turf_quagmire_citystone", { Ingredient("rocks", 2), Ingredient("saltrock", 1) }, TECH.TURFCRAFTING_ONE,
    { numtogive = 4 }, { "DECOR" })
AddRecipe2("turf_quagmire_parkfield", { Ingredient("cutgrass", 2), Ingredient("quagmire_spotspice_sprig", 1) },
    TECH.TURFCRAFTING_ONE, { numtogive = 4 }, { "DECOR" })
AddRecipe2("turf_quagmire_parkstone", { Ingredient("rocks", 2), Ingredient("quagmire_spotspice_sprig", 1) },
    TECH.TURFCRAFTING_ONE, { numtogive = 4 }, { "DECOR" })
AddRecipe2("turf_quagmire_peatforest", { Ingredient("charcoal", 1), Ingredient("spoiled_food", 2) },
    TECH.TURFCRAFTING_ONE, { numtogive = 4 }, { "DECOR" })

----------------------------------------------------------------------------------------------------

-- Wurt
TroAddRecipe("mermhouse_fisher_crafted", { Ig("boards", 5), Ig("cutreeds", 3), Ig("oceanfish_small_61_inv", 2) },
    TECH.SCIENCE_ONE,
    {
        builder_tag = "merm_builder",
        placer = "mermhouse_fisher_crafted_placer",
        testfn = function(pt, rot)
            local ground_tile = TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
            return ground_tile and
            (ground_tile == WORLD_TILES.MARSH or ground_tile == WORLD_TILES.TIDALMARSH or ground_tile == WORLD_TILES.QUAGMIRE_PEATFOREST)
        end
    }, { "CHARACTER" })
TroAddRecipe("mermhouse_tropical_crafted", { Ig("boards", 5), Ig("cutreeds", 3), Ig("oceanfish_small_61_inv", 2) },
    TECH.SCIENCE_ONE,
    {
        builder_tag = "merm_builder",
        placer = "mermhouse_tropical_crafted_placer",
        testfn = function(pt, rot)
            local ground_tile = TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
            return ground_tile and
            (ground_tile == WORLD_TILES.MARSH or ground_tile == WORLD_TILES.TIDALMARSH or ground_tile == WORLD_TILES.QUAGMIRE_PEATFOREST)
        end
    }, { "CHARACTER" })
TroAddRecipe("quagmire_merm_house_crafted", { Ig("boards", 5), Ig("cutstone", 3), Ig("oceanfish_small_11_inv", 2) },
    TECH.SCIENCE_ONE,
    {
        builder_tag = "merm_builder",
        placer = "quagmire_merm_house_crafted_placer",
        testfn = function(pt, rot)
            local ground_tile = TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
            return ground_tile and
            (ground_tile == WORLD_TILES.MARSH or ground_tile == WORLD_TILES.TIDALMARSH or ground_tile == WORLD_TILES.QUAGMIRE_PEATFOREST)
        end
    }, { "CHARACTER" })

TroAddRecipe("mermhouse_crafted", { Ig("boards", 4), Ig("cutreeds", 3), Ig("pondfish", 2) }, TECH.SCIENCE_ONE,
    {
        builder_tag = "merm_builder",
        placer = "mermhouse_crafted_placer",
        testfn = function(pt, rot)
            local ground_tile = TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
            return ground_tile and
            (ground_tile == WORLD_TILES.MARSH or ground_tile == WORLD_TILES.TIDALMARSH or ground_tile == WORLD_TILES.QUAGMIRE_PEATFOREST)
        end
    }, { "CHARACTER" })
TroAddRecipe("mermthrone_construction", { Ig("boards", 5), Ig("rope", 5) }, TECH.SCIENCE_ONE,
    {
        builder_tag = "merm_builder",
        placer = "mermthrone_construction_placer",
        testfn = function(pt, rot)
            local ground_tile = TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
            return ground_tile and
            (ground_tile == WORLD_TILES.MARSH or ground_tile == WORLD_TILES.TIDALMARSH or ground_tile == WORLD_TILES.QUAGMIRE_PEATFOREST)
        end
    }, { "CHARACTER" })
TroAddRecipe("mermwatchtower", { Ig("boards", 5), Ig("tentaclespots", 1), Ig("spear", 2) }, TECH.SCIENCE_TWO,
    {
        builder_tag = "merm_builder",
        placer = "mermwatchtower_placer",
        testfn = function(pt, rot)
            local ground_tile = TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
            return ground_tile and
            (ground_tile == WORLD_TILES.MARSH or ground_tile == WORLD_TILES.TIDALMARSH or ground_tile == WORLD_TILES.QUAGMIRE_PEATFOREST)
        end
    }, { "CHARACTER" })
--TroAddRecipe("offering_pot",			{Ingredient("boards", 2),Ig("cutreeds", 2)},											            TECH.NONE,		  {builder_tag="merm_swampmaster_offeringpot",      placer="offering_pot_placer",           testfn=function(pt, rot) local ground_tile = TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z) return ground_tile and (ground_tile == WORLD_TILES.MARSH or ground_tile == WORLD_TILES.TIDALMARSH or ground_tile == WORLD_TILES.QUAGMIRE_PEATFOREST) end}, {"CHARACTER"})
--TroAddRecipe("offering_pot_upgraded",	{Ingredient("boards", 3),Ig("cutreeds", 3),Ingredient("tentaclespots", 1)},			            TECH.NONE,		  {builder_tag="merm_swampmaster_offeringpot_upgraded", placer="offering_pot_upgraded_placer", testfn=function(pt, rot) local ground_tile = TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z) return ground_tile and (ground_tile == WORLD_TILES.MARSH or ground_tile == WORLD_TILES.TIDALMARSH or ground_tile == WORLD_TILES.QUAGMIRE_PEATFOREST) end}, {"CHARACTER"})
--TroAddRecipe("merm_armory",			    {Ingredient("boards", 2),Ig("log", 5),Ig("cutgrass", 5)},						            TECH.NONE,		  {builder_tag="merm_swampmaster_mermarmory",           placer="merm_armory_placer",           testfn=function(pt, rot) local ground_tile = TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z) return ground_tile and (ground_tile == WORLD_TILES.MARSH or ground_tile == WORLD_TILES.TIDALMARSH or ground_tile == WORLD_TILES.QUAGMIRE_PEATFOREST) end}, {"CHARACTER"})
--TroAddRecipe("merm_armory_upgraded",	{Ingredient("boards", 4),Ig("tentaclespots", 1),Ig("log", 5),Ig("cutgrass", 5)},	TECH.NONE,		  {builder_tag="merm_swampmaster_mermarmory_upgraded",  placer="merm_armory_upgraded_placer",  testfn=function(pt, rot) local ground_tile = TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z) return ground_tile and (ground_tile == WORLD_TILES.MARSH or ground_tile == WORLD_TILES.TIDALMARSH or ground_tile == WORLD_TILES.QUAGMIRE_PEATFOREST) end}, {"CHARACTER"})
--TroAddRecipe("merm_toolshed",		    {Ingredient("boards", 2),Ig("twigs", 5),Ig("rocks", 5)},						            TECH.NONE,		  {builder_tag="merm_swampmaster_mermtoolshed",         placer="merm_toolshed_placer",         testfn=function(pt, rot) local ground_tile = TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z) return ground_tile and (ground_tile == WORLD_TILES.MARSH or ground_tile == WORLD_TILES.TIDALMARSH or ground_tile == WORLD_TILES.QUAGMIRE_PEATFOREST) end}, {"CHARACTER"})
--TroAddRecipe("merm_toolshed_upgraded",  {Ingredient("boards", 4),Ig("tentaclespots", 1),Ig("twigs", 5),Ig("rocks", 5)},	TECH.NONE,	      {builder_tag="merm_swampmaster_mermtoolshed_upgraded",placer="merm_toolshed_upgraded_placer",testfn=function(pt, rot) local ground_tile = TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z) return ground_tile and (ground_tile == WORLD_TILES.MARSH or ground_tile == WORLD_TILES.TIDALMARSH or ground_tile == WORLD_TILES.QUAGMIRE_PEATFOREST) end}, {"CHARACTER"})


----------------------------------------------------------------------------------------------------

local cookers = {
    grill = { "grill", "grill_small" },
    oven = { "oven" },
    pot = { "pot" },
}
local preparedFoods = require("gorge_foods")
for k, v in pairs(preparedFoods) do
    if v.cookers then
        for _, cookertype in ipairs(v.cookers) do
            for _, cookerprefab in ipairs(cookers[cookertype] or {}) do
                AddCookerRecipe(cookerprefab, v)
            end
        end
    else
        AddCookerRecipe("cookpot", v)
    end
end

----------------------------------------------------------------------------------------------------
