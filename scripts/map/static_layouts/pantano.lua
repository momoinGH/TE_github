return {
    version = "1.1",
    luaversion = "5.1",
    orientation = "orthogonal",
    width = 3,
    height = 3,
    tilewidth = 64,
    tileheight = 64,
    properties = {},
    tilesets = {
        {
            name = "tiles",
            firstgid = 1,
            tilewidth = 64,
            tileheight = 64,
            spacing = 0,
            margin = 0,
            image = "tileset/tiles.png",
            imagewidth = 512,
            imageheight = 128,
            properties = {},
            tiles = {}
        }
    },
    layers = {
        {
            type = "tilelayer",
            name = "BG_TILES",
            x = 0,
            y = 0,
            width = 3,
            height = 3,
            visible = true,
            opacity = 1,
            properties = {},
            encoding = "lua",
            data = {
                6, 6, 6,
                6, 6, 6,
                6, 6, 6
            }
        },
        {
            type = "objectgroup",
            name = "FG_OBJECTS",
            visible = true,
            opacity = 1,
            properties = {},
            objects = {
                -- Reeds: 保留3个 (原15个，减至1/5)
                {
                    id = 1,
                    name = "Reed",
                    type = "reeds",
                    shape = "ellipse",
                    x = 96.3859,
                    y = 48.3669,
                    width = 6,
                    height = 6,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {
                    id = 10,
                    name = "Reed",
                    type = "reeds",
                    shape = "ellipse",
                    x = 77,
                    y = 80,
                    width = 6,
                    height = 6,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {
                    id = 12,
                    name = "Reed",
                    type = "reeds",
                    shape = "ellipse",
                    x = 111,
                    y = 13,
                    width = 6,
                    height = 6,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                -- Mangrovetree: 保留4个独立位置 (原24个，去掉20个重合在100,90的)
                {
                    id = 13,
                    name = "mangrove tree",
                    type = "mangrovetree",
                    shape = "ellipse",
                    x = 105.242,
                    y = 76.6848,
                    width = 6,
                    height = 6,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {
                    id = 14,
                    name = "mangrove tree",
                    type = "mangrovetree",
                    shape = "ellipse",
                    x = 94.0842,
                    y = 34.6226,
                    width = 6,
                    height = 6,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {
                    id = 15,
                    name = "mangrove tree",
                    type = "mangrovetree",
                    shape = "ellipse",
                    x = 71.375,
                    y = 17.2989,
                    width = 6,
                    height = 6,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {
                    id = 16,
                    name = "mangrove tree",
                    type = "mangrovetree",
                    shape = "ellipse",
                    x = 70.3642,
                    y = 114.334,
                    width = 6,
                    height = 6,
                    rotation = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "",
                    type = "fishinhole",
                    shape = "rectangle",
                    x = 100,
                    y = 90,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "",
                    type = "fishinhole",
                    shape = "rectangle",
                    x = 100,
                    y = 90,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "",
                    type = "ox",
                    shape = "rectangle",
                    x = 100,
                    y = 90,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "",
                    type = "ox",
                    shape = "rectangle",
                    x = 100,
                    y = 90,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                -- Grass: 保留1个 (原20个全部重合在100,90，去重)
                {
                    name = "",
                    type = "grass",
                    shape = "rectangle",
                    x = 100,
                    y = 90,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
            }
        }
    }
}
