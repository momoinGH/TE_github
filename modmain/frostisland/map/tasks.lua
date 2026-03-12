AddTask("FrostIsland_icelake", {
    locks = {},
    keys_given = { KEYS.ISLAND_TIER2 },
    region_id = "frostisland",
    level_set_piece_blocker = true,
    room_tags = { "RoadPoison", "not_mainland", "frost" },
    room_choices =
    {
        ["FrostIsland_icelake"] = 2,
        ["FrostIsland_deeclop"] = 1,
        ["FrostIsland_icelake_cave"] = 1,
        ["FrostIsland_icelake_beager"] = 1,
        ["rock_ice_frost_lake"] = 1,
    },
    room_bg = WORLD_TILES.ICELAND,
    background_room = "FrostIsland_icelake",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("FrostIsland_Wildbeaver", {
    locks = {},
    keys_given = { KEYS.ISLAND_TIER2 },
    region_id = "frostisland",
    level_set_piece_blocker = true,
    room_tags = { "RoadPoison", "not_mainland", "frost" },
    room_choices =
    {
        ["strange_island_canada2"] = 2,
        ["strange_island_canada"] = 2,
        ["strange_island_canada3"] = 1,
        ["Empty_Cove"] = 2,
        ["rock_ice_frost_lake"] = 1,
    },
    room_bg = WORLD_TILES.SNOWLAND,
    background_room = "Empty_Cove",
    cove_room_name = "Blank",
    make_loop = true,
    crosslink_factor = 2,
    cove_room_chance = 1,
    cove_room_max_edges = 2,
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("FrostIsland_Beach", {
    locks = { LOCKS.ISLAND_TIER2 },
    keys_given = { KEYS.ISLAND_TIER3 },
    region_id = "frostisland",
    level_set_piece_blocker = true,
    room_tags = { "RoadPoison", "not_mainland", "frost" },
    --    entrance_room = "FrostIsland_Blank",
    room_choices =
    {
        ["FrostIsland_Beach"] = 2,
        ["rock_ice_frost_lake"] = 1,
    },
    room_bg = WORLD_TILES.SNOWLAND,
    background_room = "Empty_Cove",
    cove_room_name = "Empty_Cove",
    cove_room_chance = 1,
    make_loop = true,
    cove_room_max_edges = 2,
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("FrostIsland_palace", {
    locks = { LOCKS.ISLAND_TIER2 },
    keys_given = { KEYS.ISLAND_TIER3 },
    region_id = "frostisland",
    level_set_piece_blocker = true,
    room_tags = { "RoadPoison", "not_mainland", "frost" },
    entrance_room = "FrostIsland_Beach",
    room_choices =
    {
        ["frost_island_palace_set"] = 1,
        ["frost_island_palace_city"] = 1,
        ["frost_island_palace"] = 1,
        ["rock_ice_frost_lake"] = 1,
    },
    room_bg = WORLD_TILES.SNOWLAND,
    background_room = "Empty_Cove",
    cove_room_name = "Empty_Cove",
    cove_room_chance = 1,
    make_loop = true,
    cove_room_max_edges = 2,
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("FrostIsland_deciduoustree", {
    locks = { LOCKS.ISLAND_TIER4 },
    keys_given = {},
    region_id = "frostisland",
    level_set_piece_blocker = true,
    room_tags = { "RoadPoison", "not_mainland", "frost" },
    room_choices =
    {
        ["FrostIsland_deciduoustree"] = 3,
        ["rock_ice_frost_lake"] = 1,
    },
    room_bg = WORLD_TILES.SNOWLAND,
    background_room = "Empty_Cove",
    cove_room_name = "Empty_Cove",
    crosslink_factor = 1,
    cove_room_chance = 1,
    cove_room_max_edges = 2,
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("FrostIsland_maxwell", {
    locks = { LOCKS.ISLAND_TIER4 },
    keys_given = {},
    region_id = "frostisland",
    level_set_piece_blocker = true,
    room_tags = { "RoadPoison", "not_mainland", "frost" },
    room_choices =
    {
        ["strange_island_maxwell"] = 1,
        ["strange_island_maxwell_set"] = 1,
        ["rock_ice_frost_lake"] = 1,
    },
    room_bg = WORLD_TILES.SNOWLAND,
    background_room = "Empty_Cove",
    cove_room_name = "Empty_Cove",
    crosslink_factor = 1,
    cove_room_chance = 1,
    cove_room_max_edges = 2,
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("FrostIsland_Mine", {
    locks = { LOCKS.ISLAND_TIER4 },
    keys_given = {},
    region_id = "frostisland",
    level_set_piece_blocker = true,
    room_tags = { "RoadPoison", "not_mainland", "frost" },
    room_choices = {
        ["FrostIsland_Mine"] = 2,
        ["FrostIsland_Mineboss"] = 1,
    },
    room_bg = WORLD_TILES.SNOWLAND,
    background_room = "Empty_Cove",
    cove_room_name = "Empty_Cove",
    cove_room_chance = 1,
    cove_room_max_edges = 2,
    colour = { r = .05, g = .5, b = .05, a = 1 },
})

AddTask("FrostIsland_Mammoth", {
    locks = { LOCKS.ISLAND_TIER3 },
    keys_given = { KEYS.ISLAND_TIER4 },
    region_id = "frostisland",
    level_set_piece_blocker = true,
    room_tags = { "RoadPoison", "not_mainland", "frost" },
    room_choices =
    {
        ["FrostIsland_Mammoth"] = 2,
        ["FrostIsland_Meadows"] = 2,
        ["rock_ice_frost_lake"] = 1,
    },
    room_bg = WORLD_TILES.SNOWLAND,
    background_room = "FrostIsland_Meadows",
    cove_room_name = "Empty_Cove",
    cove_room_chance = 1,
    cove_room_max_edges = 2,
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})
