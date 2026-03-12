AddTask("pandatask", {
    locks = {},
    keys_given = {},
    region_id = "eldorado1",
    room_choices = {
        ["pandajungle1"] = 1,
        ["pandajungle2"] = 1,
        ["pandajungle3"] = 1,
        ["pandajungle4"] = 1,
        ["pandajungle5"] = 1,
        ["pandajungle6"] = 1,
    },
    --	entrance_room = "seatarolake",
    room_bg = WORLD_TILES.MEADOW,
    background_room = "BGpandajungle",
    colour = { 1, .5, .5, .2 },
})

AddTask("pandataskjunto", {
    locks = { LOCKS.CAVE },
    keys_given = { KEYS.CAVE },
    region_id = "junto",
    room_choices = {
        ["pandajungle1"] = 1,
        ["pandajungle2"] = 1,
        ["pandajungle3"] = 1,
        ["pandajungle4"] = 1,
        ["pandajungle5"] = 1,
        ["pandajungle6"] = 1,
    },
    --	entrance_room = "seatarolake",
    room_bg = WORLD_TILES.MEADOW,
    background_room = "BGpandajungle",
    colour = { 1, .5, .5, .2 },
})

AddTask("pantanojunto", {
    locks = {},
    keys_given = {},
    level_set_range = 0.5,
    region_id = "junto",
    room_choices = {
        ["poolox1"] = 1,
        ["Marshpool"] = 1,
        ["poolox"] = 1,
        ["swambpool2"] = 1,
        ["poolox2"] = 1,
        ["poolox3"] = 1,
        ["MermySwamp1"] = 1,
    },
    entrance_room = "swambpool1",
    room_bg = WORLD_TILES.MARSH,
    WORLD_TILES.OCEAN_COASTAL_SHORE,
    background_room = "Marshpool",
    colour = { r = .05, g = .05, b = .05, a = 1 }
})
