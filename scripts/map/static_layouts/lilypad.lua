return {
    version = "1.1",
    luaversion = "5.1",
    orientation = "orthogonal",
    width = 10,
    height = 10,
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
            image = "../../../../../tools/tiled/dont_starve/tiles.png",
            imagewidth = 512,
            imageheight = 512,
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
            width = 10,
            height = 10,
            visible = true,
            opacity = 1,
            properties = {},
            encoding = "lua",
            -- 哈姆雷特的海洋和联机海洋风格太大，这里用陆地地皮围起来，防止两个海洋接壤
            data = {
                61, 61, 61, 61, 61, 61, 61, 61, 61, 61,
                61, 61, 58, 58, 58, 58, 58, 58, 61, 61,
                61, 58, 58, 58, 58, 58, 58, 58, 58, 61,
                61, 58, 58, 58, 58, 58, 58, 58, 58, 61,
                61, 61, 58, 58, 58, 58, 58, 58, 58, 61,
                61, 58, 58, 58, 58, 58, 58, 58, 61, 61,
                61, 58, 58, 58, 58, 58, 58, 58, 58, 61,
                61, 58, 58, 58, 58, 58, 58, 58, 58, 61,
                61, 58, 61, 61, 61, 58, 58, 58, 58, 61,
                61, 61, 61, 61, 61, 61, 61, 61, 61, 61,
            }
        },
        {
            type = "objectgroup",
            name = "FG_OBJECTS",
            visible = true,
            opacity = 1,
            properties = {},
            objects = {
                {
                    name = "",
                    type = "lilypad",
                    shape = "rectangle",
                    x = 83,
                    y = 145,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "",
                    type = "reeds_water",
                    shape = "rectangle",
                    x = 218,
                    y = 80,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "",
                    type = "reeds_water",
                    shape = "rectangle",
                    x = 111,
                    y = 204,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "",
                    type = "reeds_water",
                    shape = "rectangle",
                    x = 531,
                    y = 250,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "",
                    type = "lilypad",
                    shape = "rectangle",
                    x = 172,
                    y = 90,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "",
                    type = "lotus",
                    shape = "rectangle",
                    x = 516,
                    y = 205,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "",
                    type = "lotus",
                    shape = "rectangle",
                    x = 270,
                    y = 86,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "",
                    type = "hippopotamoose",
                    shape = "rectangle",
                    x = 75,
                    y = 152,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "",
                    type = "lotus",
                    shape = "rectangle",
                    x = 160,
                    y = 218,
                    width = 15,
                    height = 59,
                    visible = true,
                    properties = {}
                },
                {
                    name = "",
                    type = "lotus",
                    shape = "rectangle",
                    x = 71,
                    y = 319,
                    width = 58,
                    height = 23,
                    visible = true,
                    properties = {}
                },
                {
                    name = "",
                    type = "lotus",
                    shape = "rectangle",
                    x = 550,
                    y = 275,
                    width = 15,
                    height = 59,
                    visible = true,
                    properties = {}
                },
                {
                    name = "",
                    type = "reeds_water",
                    shape = "rectangle",
                    x = 527,
                    y = 357,
                    width = 15,
                    height = 59,
                    visible = true,
                    properties = {}
                },
                {
                    name = "",
                    type = "reeds_water",
                    shape = "rectangle",
                    x = 560,
                    y = 387,
                    width = 34,
                    height = 27,
                    visible = true,
                    properties = {}
                },
            }
        }
    }
}
