for _, r in ipairs({
    "terrain_battleground",
    "terrain_city",
    "terrain_cultivated",
    "terrain_deeprainforest",
    "terrain_painted",
    "terrain_pinacle",
    "terrain_plains",
    "terrain_rainforest",
    "terrain_suburb"
}) do
    modimport("modmain/hamlet/map/rooms/" .. r)
end
