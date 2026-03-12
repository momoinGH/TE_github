AddRoomPreInit("OceanCoastal", function(room)
    room.contents.countprefabs = room.contents.countprefabs or {}
    room.contents.countprefabs.mermboat = 4

    room.contents.countstaticlayouts["lilypadnovo"] = 2
    room.contents.countstaticlayouts["lilypadnovograss"] = 1
end)
