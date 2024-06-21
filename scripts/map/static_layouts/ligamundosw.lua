return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 8,
  height = 8,
  tilewidth = 16,
  tileheight = 16,
  properties = {},
  tilesets = {
    {
      name = "tiles",
      firstgid = 1,
      tilewidth = 64,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      image = "../../../../tools/tiled/dont_starve/tiles.png",
      imagewidth = 512,
      imageheight = 384,
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
      width = 8,
      height = 8,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        9, 9, 9, 9, 9, 9, 9, 9,
        9, 9, 9, 9, 9, 9, 9, 9,
        9, 9, 9, 9, 9, 9, 9, 9,
        9, 9, 9, 9, 9, 9, 9, 9,
        9, 9, 9, 9, 9, 9, 9, 9,
        9, 9, 9, 9, 9, 9, 9, 9,
        9, 9, 9, 9, 9, 9, 9, 9,
        9, 9, 9, 9, 9, 9, 9, 9
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
          type = "ligamundosw",
          shape = "rectangle",
          x = 64,
          y = 64,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "wall_limestone",
          shape = "rectangle",
          x = 8,
          y = 8,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "wall_limestone",
          shape = "rectangle",
          x = 24,
          y = 8,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "wall_limestone",
          shape = "rectangle",
          x = 8,
          y = 24,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        --[[
          name = "",
          type = "wall_limestone",
          shape = "rectangle",
          x = 8,
          y = 40,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },]]
        {
          name = "",
          type = "wall_limestone",
          shape = "rectangle",
          x = 40,
          y = 8,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },

        {
          name = "",
          type = "wall_limestone",
          shape = "rectangle",
          x = 120,
          y = 120,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "wall_limestone",
          shape = "rectangle",
          x = 104,
          y = 120,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        --[[{
        name = "",
        type = "wall_limestone",
        shape = "rectangle",
        x = 120,
        y = 104,
        width = 0,
        height = 0,
        visible = true,
        properties = {}
        },
        {
          name = "",
          type = "wall_limestone",
          shape = "rectangle",
          x = 120,
          y = 88,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },]]
        {
          name = "",
          type = "wall_limestone",
          shape = "rectangle",
          x = 88,
          y = 120,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },

        {
          name = "",
          type = "wall_limestone",
          shape = "rectangle",
          x = 8,
          y = 120,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "wall_limestone",
          shape = "rectangle",
          x = 24,
          y = 120,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        --[[{
          name = "",
          type = "wall_limestone",
          shape = "rectangle",
          x = 40,
          y = 120,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "wall_limestone",
          shape = "rectangle",
          x = 8,
          y = 104,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "wall_limestone",
          shape = "rectangle",
          x = 8,
          y = 88,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },

        {
          name = "",
          type = "wall_limestone",
          shape = "rectangle",
          x = 120,
          y = 8,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "wall_limestone",
          shape = "rectangle",
          x = 104,
          y = 8,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "wall_limestone",
          shape = "rectangle",
          x = 88,
          y = 8,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "wall_limestone",
          shape = "rectangle",
          x = 120,
          y = 24,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "wall_limestone",
          shape = "rectangle",
          x = 120,
          y = 40,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },]]
      }
    }
  }
}
