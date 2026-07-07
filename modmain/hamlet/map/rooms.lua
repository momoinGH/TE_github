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




AddRoom("Hamlet start", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.PLAINS,
    tags = { "tropical", "hamlet" },
    contents = {
        distributepercent = .25,
        distributeprefabs =
        {
            clawpalmtree = 0.5,
            grass_tall = 1,
            sapling = .3,
            flower = 0.05,
            dungpile = 0.03,
            peagawk = 0.01,
            --		randomrelic = 0.0016,
            --randomruin = 0.0025,	
            randomdust = 0.0025,
            rock_flippable = 0.08,
            aloe_planted = 0.08,
            pog = 0.01,
            asparagus_planted = 0.05,
        },
        countstaticlayouts = {
            ["start_ham"] = 1,
        },
        countprefabs =
        {
            --大发慈悲给点必需品吧
            flint = 3,
            twigs = math.random(3, 4)
        },
    }
})
