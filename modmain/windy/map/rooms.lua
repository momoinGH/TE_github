AddRoomPreInit("BGGrass", function(room)
    room.contents.distributeprefabs.peach_tree1 = 0.012
end)
AddRoomPreInit("BGForest", function(room)
    room.contents.distributeprefabs.peach_tree2 = 0.012
end)
AddRoomPreInit("Clearing", function(room)
    room.contents.distributeprefabs.peach_tree3 = 0.012
end)

AddRoom("goddess_room1", {
    colour = { r = 0.8, g = .8, b = .1, a = .50 },
    value = WORLD_TILES.WINDY,
    tags = { "Chester_Eyebone" },
    required_prefabs = { "goddess_shrine" },
    contents = {
        countprefabs = {
            goddess_flower = 20,
            reeds = 3,
            deciduoustree = 7,
            peach_tree = 5,
            goddess_shrine = 1,
            goddess_gate1 = 1,
            grass = 5,
            goddess_statue3 = 3,
            green_mushroom = 5,
            carrot_planted = 8,
            goddess_deer = 1,
            berrybush2 = 3
        }
    }
})

AddRoom("goddess_room2", {
    colour = { r = .1, g = .9, b = .2, a = .50 },
    value = WORLD_TILES.WINDY,
    tags = { "ExitPiece", "Chester_Eyebone" },
    contents = {
        distributepercent = 0.38,
        distributeprefabs = {
            goddess_flower = 0.3,
            reeds = 0.09,
            deciduoustree = 0.07,
            peach_tree = 0.10,
            goddess_statue2 = 0.015,
            goddess_statue3 = 0.015,
            grass = 0.12,
            berrybush2 = 0.30,
            goddess_rabbithole = 0.18,
            green_mushroom = 0.30,
            carrot_planted = 0.30
        },
    }
})

AddRoom("goddess_room3", {
    colour = { r = .1, g = .9, b = .2, a = .50 },
    value = WORLD_TILES.WINDY,
    tags = { "ExitPiece", "Chester_Eyebone" },
    contents = {
        distributepercent = 0.38,
        distributeprefabs = {
            goddess_flower = 0.32,
            reeds = 0.09,
            deciduoustree = 0.1,
            peach_tree = 0.1,
            goddess_statue2 = 0.02,
            goddess_statue3 = 0.02,
            grass = 0.15,
            berrybush2 = 0.30,
            goddess_rabbithole = 0.18,
            green_mushroom = 0.30,
            carrot_planted = 0.30
        },
    }
})

AddRoom("goddess_room4", {
    colour = { r = 0.8, g = .8, b = .1, a = .50 },
    value = WORLD_TILES.WINDY,
    tags = { "Chester_Eyebone" },
    required_prefabs = { "goddess_lake" },
    contents = {
        countprefabs = {
            goddess_flower = 20,
            goddess_lake = 1,
            goddess_deer_gem = 3
        }
    }
})
