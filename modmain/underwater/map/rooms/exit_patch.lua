AddRoom("exitPatch2", {
    colour = { r = 0, g = 0, b = 0, a = 0 },
    value = WORLD_TILES.UNDERWATER_SANDY,
    tags = { "RoadPoison" },
    contents = {
        countprefabs = {
            -- 开了海难地上才有入口2，不然就用用第一个地上入口1
            underwater_exit = not TUNING.tropical.shipwrecked and 1 or nil,
            underwater_exit2 = TUNING.tropical.shipwrecked and 1 or nil,
        },
        distributepercent = 0.3,
        distributeprefabs = {
            seagrass = 0.35,
            sandstone_boulder = 0.01,
            bubble_vent = 0.03,
            kelpunderwater = 0.2,
            squidunderwater = 0.001,
            flower_sea = 0.1,
            decorative_shell = 0.05,
            wormplant = 0.1,
            sea_eel = 0.01,
            clam = 0.06,
            sponge = 0.25,
            rainbowjellyfish_underwater = 0.01,
            sea_cucumber = 0.1,
            commonfish = 0.1,
            shrimp = 0.2,
            reeflight_small = 0.2,
            reeflight_tiny = 0.2,
            uw_flowers = 0.1,
        },
    },
})
