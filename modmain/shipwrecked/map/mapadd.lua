modimport "modmain/shipwrecked/map/network.lua"


-- 沿海地形
AddRoomPreInit("OceanCoastal", function(room)
    room.contents.countprefabs = room.contents.countprefabs or {}
    room.contents.countprefabs.mermboat = 4 --鱼人海盗船
end)
