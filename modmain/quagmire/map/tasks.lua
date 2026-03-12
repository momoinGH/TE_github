AddTask("gorgeisland", {
    locks = {},
    keys_given = {},
    region_id = "gorgeisland",
    room_choices = {
        --			["quagmire"] = 1,
        ["gorgeislandcity"] = 1,
        ["gorgeislandcity2"] = 1,
        ["quagmire2"] = 2,
    },
    room_bg = WORLD_TILES.QUAGMIRE_PARKFIELD,
    background_room = "quagmire2",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("quagmireblue", {
    locks = {},
    keys_given = {},
    region_id = "gorgeisland",
    room_choices = {
        ["quagmireblue"] = 2,
        ["quagmireblueset"] = 1,
    },
    room_bg = WORLD_TILES.QUAGMIRE_PARKFIELD,
    background_room = "quagmireblue",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("quagmirepink", {
    locks = {},
    keys_given = {},
    region_id = "gorgeisland",
    room_choices = {
        ["quagmirepink"] = 2,
        ["quagmirepinkset"] = 1,
    },
    room_bg = WORLD_TILES.QUAGMIRE_PARKFIELD,
    background_room = "quagmirepink",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("gorgeislandchicken", {
    locks = {},
    keys_given = {},
    region_id = "gorgeisland",
    room_choices = {
        ["chickenbiomeset"] = 1,
        ["chickenbiome"] = 2,
    },
    room_bg = WORLD_TILES.SAVANNA,
    background_room = "chickenbiome",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

AddTask("gorgeislandforest", {
    locks = {},
    keys_given = {},
    region_id = "gorgeisland",
    room_choices = {
        ["quagmireswampcity"] = 1,
        ["quagmireswamp"] = function() return 2 + math.random(2) end,
    },
    room_bg = WORLD_TILES.QUAGMIRE_PEATFOREST,
    background_room = "quagmireswamp",
    colour = { r = 1, g = 1, b = 0, a = 1 }
})
