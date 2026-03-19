-- 一片海洋，断开两个岛屿的链接
AddRoom("ForceDisconnectedRoom", {
    colour = { r = .45, g = .75, b = .45, a = .50 },
    type = "blank",
    tags = { "ForceDisconnected" },
    value = WORLD_TILES.OCEAN_SWELL,
    contents = {},
})
