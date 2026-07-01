AddTask("WindyPlains", {
    locks = LOCKS.OUTERTIER,
    keys_given = { KEYS.TIER4, KEYS.TIER5, KEYS.TIER6 },
    room_choices = {
        ["goddess_room1"] = 1,
        ["goddess_room2"] = 4,
        ["goddess_room4"] = 1,
    },
    room_bg = WORLD_TILES.WINDY,
    background_room = "goddess_room3",
    colour = { r = 0, g = 1, b = 1, a = 1 }
})

AddTask("WindyPlainsisland", {
    locks = LOCKS.OUTERTIER,
    keys_given = { KEYS.TIER4, KEYS.TIER5, KEYS.TIER6 },
    region_id = "windyplains",
    room_choices = {
        ["goddess_room1"] = 1,
        ["goddess_room2"] = 4,
        ["goddess_room4"] = 1,
    },
    room_bg = WORLD_TILES.WINDY,
    background_room = "goddess_room3",
    colour = { r = 0, g = 1, b = 1, a = 1 }
})
