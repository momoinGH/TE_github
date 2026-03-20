AddRoomPreInit("OceanCoastal", function(room)
    table.tromerge(room.contents.distributeprefabs,
        {
            messagebottle_sw = 0.1,
            seaweed_planted = 3,
            mussel_farm = 2,
            lobsterhole = 1 / 2,
            ballphinhouse = .1 / 2,
            solofish_spawner = 1 / 2,
            jellyfish_spawner = 1 / 2,
            rainbowjellyfish_spawner = 0.25 / 2,
            bioluminescence_spawner = 0.1,
        })
end)


AddRoomPreInit("OceanSwell", function(room)
    table.tromerge(room.contents.distributeprefabs,
        {
            ballphinhouse = 5,
            redbarrel = 1,
            seagullspawner = 6,
            oceanfog = 2,
            tar_pool = 1,
            bioluminescence_spawner = 5,
        })

    room.contents.countprefabs =
    {
        oceanfish_shoalspawner = 3,
    }
end)


AddRoomPreInit("OceanRough", function(room)
    table.tromerge(room.contents.distributeprefabs,
        {
            redbarrel = 0.1,
            bioluminescence_spawner = .5,
            oceanfog = 0.1,
        })
    room.contents.countprefabs = {
        luggagechest = 4,
        rawling = 1
    }
end)


AddRoomPreInit("OceanHazardous", function(room)
    room.contents.distributepercent = 0.3
    table.tromerge(room.contents.distributeprefabs,
        {
            waterygrave = 5,
            wreck = 4,
            seaweed_planted = 3,

            pirateghost = 4,
            redbarrel = 2,
            bishopwaterfixo = .5,
            rookwater = .5,
            knightboat = .5,

            luggagechest_spawner = .3,
            boatfragment01 = 1,
            boatfragment02 = 1,
            boatfragment03 = 1,
            whale_bluefinal = 1,

        })
    room.contents.countprefabs = {
        kraken = 1,
    }
end)

AddRoomPreInit("OceanBrinepool", function(room)
    table.tromerge(room.contents.distributeprefabs,
        {

            coralreef = 0.5,
            ballphinhouse = .3,
            octohouse = .1,
            seaweed_planted = .5,
            spidercoralhole = 0.1,
            fishinhole = 0.5,
        })
    room.contents.countprefabs = {
        coral_brain_rock = math.random(3, 5),
        octopusking = 1,
    }
end)

AddRoomPreInit("OceanRough", function(room)
    room.contents.countprefabs = room.contents.countprefabs or {}
    table.tromerge(room.contents.countprefabs, {
        rawling = 1,
        tar_pool = 8,
    })
end)
