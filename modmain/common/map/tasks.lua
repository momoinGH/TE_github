-- 洞穴地形不想要在主大陆生成时，这个虚空地形就作为基础，其他模块的地形和这个地形相邻，用LAND_DIVIDE_3解锁
AddTask("separavulcao", {
    locks = {
        LOCKS.RUINS,
    },
    keys_given = KEYS.LAND_DIVIDE_3,
    room_choices = {
        ["ForceDisconnectedRoom"] = 10,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = WORLD_TILES.VOLCANO,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})
