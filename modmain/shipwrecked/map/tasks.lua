local salasvolcano =
{
    [1] = "VolcanoRock",
    [2] = "VolcanoAsh",
    [3] = "VolcanoObsidian",
    [4] = "VolcanoRock",
    [5] = "VolcanoRock",
}

local salasbeach =
{
    [1] = "BeachSkull",
    [2] = "BeachShells",
    [3] = "BeachShells1",
    [4] = "BeachNoCrabbits",
    [5] = "BeachNoLimpets",
    [6] = "BeachFlowers",
    [7] = "BeachNoFlowers",
    [8] = "BeachSpider",
    [9] = "BeachLimpety",
    [10] = "BeachRocky",
    [11] = "BeachSappy",
    [12] = "BeachGrassy",
    [13] = "BeachDunes",
    [14] = "BeachCrabTown",
    [15] = "BeesBeach",
    [16] = "BeachPiggy",
    [17] = "BeachPalmForest",
    [18] = "BeachWaspy",
    [19] = "DoydoyBeach",
    [20] = "BeachSinglePalmTreeHome",
    [21] = "BeachGravel",
    [22] = "BeachUnkeptDubloon",
    [23] = "BeachUnkept",
    [24] = "BeachSand",
}

local salasjungle =
{
    [1] = "JungleEyeplant",
    [2] = "JungleFrogSanctuary",
    [3] = "JungleBees",
    [4] = "JungleDenseVery",
    [5] = "JungleClearing",
    [6] = "Jungle",
    [7] = "JungleSparse",
    [8] = "JungleSparseHome",
    [9] = "JungleDense",
    [10] = "JungleDenseHome",
    [11] = "JungleDenseMed",
    [12] = "JungleDenseBerries",
    [13] = "JungleDenseMedHome",
    [14] = "JunglePigGuards",
    [15] = "JungleFlower",
    [16] = "JungleSpidersDense",
    [17] = "JungleSpiderCity",
    [18] = "JungleBamboozled",
    [19] = "JungleMonkeyHell",
    [20] = "JungleCritterCrunch",
    [21] = "JungleDenseCritterCrunch",
    [22] = "JungleShroomin",
    [23] = "JungleRockyDrop",
    [24] = "JungleGrassy",
    [25] = "JungleSappy",
    [26] = "JungleEvilFlowers",
    [27] = "JungleParrotSanctuary",
    [28] = "JungleNoBerry",
    [29] = "JungleNoRock",
    [30] = "JungleNoMushroom",
    [31] = "JungleNoFlowers",
    [32] = "JungleMorePalms",
    [33] = "JungleSkeleton",
}

local salastidal =
{
    [1] = "TidalMarsh",
    [2] = "TidalMarsh1",
    [3] = "TidalMermMarsh",
    [4] = "ToxicTidalMarsh",
}

local salasmeadow =
{
    [1] = "NoOxMeadow",
    [2] = "MeadowOxBoon",
    [3] = "MeadowFlowery",
    [4] = "MeadowBees",
    [5] = "MeadowCarroty",
    [6] = "MeadowSappy",
    [7] = "MeadowSpider",
    [8] = "MeadowRocky",
    [9] = "MeadowMandrake",
}

AddTask("HomeIsland", {
    locks = { LOCKS.HARD },
    keys_given = { KEYS.HARD },
    room_choices = {
        ["JungleDenseMedHome"] = 1,
        [salasjungle[math.random(1, 24)]] = 1,
        [salasjungle[math.random(1, 24)]] = 1,
        ["BeachUnkept"] = 1,
        -- ["BeachPalmCasino"] = 1,---抽奖机和醍醐
        [salasbeach[math.random(1, 24)]] = 1,
        [salasbeach[math.random(1, 24)]] = 1,
    },
    room_bg = WORLD_TILES.JUNGLE,
    background_room = "BeachSandHome",
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("RockyGold", {
    locks = { LOCKS.CAVE },
    keys_given = { KEYS.EASY },
    room_choices = {
        ["MagmaGold"] = 2,
        ["MagmaGoldBoon"] = 1,
    },
    room_bg = WORLD_TILES.MAGMAFIELD,
    background_room = "Magma",
    colour = { 1, .5, .5, .2 },
})

AddTask("BoreKing", {
    locks = { LOCKS.EASY },
    keys_given = { KEYS.EASY },
    room_choices = {
        ["PigVillagesw"] = 1,
        ["JungleDenseBerries"] = 1,
        ["BeachShark"] = 1,
    },
    room_bg = WORLD_TILES.JUNGLE,
    background_room = "JungleDenseMed",
    colour = { 1, .5, .5, .2 },
})

AddTask("RockyTallJungle", {
    locks = { LOCKS.EASY },
    keys_given = { KEYS.EASY },
    room_choices = {
        ["MagmaTallBird"] = 1,
        -- ["MagmaGoldBoon"] = 1,
    },
    room_bg = WORLD_TILES.MAGMAFIELD,
    background_room = "BeachDunes",
    colour = { 1, .5, .5, .2 },
})

AddTask("BeachSkull", {
    locks = { LOCKS.INNERTIER },
    keys_given = { KEYS.MEDIUM },
    room_choices = {
        [salasjungle[math.random(1, 24)]] = 1,
        ["JungleRockSkull"] = 1,
        [salasjungle[math.random(1, 24)]] = 1,
    },
    room_bg = WORLD_TILES.JUNGLE,
    background_room = salasjungle[math.random(1, 24)],
    colour = { 1, .5, .5, .2 },
})

AddTask("MagmaJungle", {
    locks = { LOCKS.MEDIUM },
    keys_given = { KEYS.MEDIUM },
    room_choices = {
        ["MagmaForest"] = 1, -- MR went from 1-3
        ["JungleDense"] = 1,
        ["JunglePigs"] = 1,
    },
    room_bg = WORLD_TILES.JUNGLE,
    background_room = "JungleDense",
    colour = { 1, .5, .5, .2 },
})

AddTask("JungleMarshy", {
    locks = { LOCKS.OUTERTIER },
    keys_given = { KEYS.HARD },
    level_set_piece_blocker = true,
    room_choices = {
        ["TidalMermMarsh"] = 3,
        [salasbeach[math.random(1, 24)]] = 1,
        ["BeachSappy"] = 1,
        ["WaterMangrove"] = 2,
    },
    room_bg = WORLD_TILES.JUNGLE,
    background_room = "BeachSand",
    colour = { 1, .5, .5, .2 },
})

AddTask("JungleBushy", {
    locks = { LOCKS.HARD },
    keys_given = { KEYS.HARD },
    room_choices = {
        [salasjungle[math.random(1, 24)]] = 1,
        [salasbeach[math.random(1, 24)]] = 1,

    },
    room_bg = WORLD_TILES.JUNGLE,
    background_room = "BeachUnkept",
    colour = { 1, .5, .5, .2 },
})

AddTask("JungleBeachy", {
    locks = { LOCKS.HARD },
    keys_given = { KEYS.HARD },
    room_choices = {
        ["JungleDenseMed"] = 1,
        [salasbeach[math.random(1, 24)]] = 1,
        [salasbeach[math.random(1, 24)]] = 1,
    },
    room_bg = WORLD_TILES.JUNGLE,
    background_room = "BeachSand",
    "BeachUnkept",
    colour = { 1, .5, .5, .2 },
})
AddTask("JungleMonkey", {
    locks = { LOCKS.LIGHT },
    keys_given = { KEYS.BLUE },
    level_set_piece_blocker = true,
    room_choices = {
        [salasjungle[math.random(1, 33)]] = 1,
        ["JungleMonkeyHell"] = 2,
        ["WaterMangrove"] = 2,
    },
    room_bg = WORLD_TILES.JUNGLE,
    background_room = "TidalMarsh",
    colour = { 1, .5, .5, .2 },
})
AddTask("BeachMarshy", {
    locks = { LOCKS.BLUE },
    keys_given = { KEYS.BLUE },
    level_set_piece_blocker = true,
    room_choices = {
        [salastidal[math.random(1, 4)]] = 2,
        [salastidal[math.random(1, 4)]] = 3,
        ["WaterMangrove"] = 2,
    },
    room_bg = WORLD_TILES.BEACH,
    background_room = "BeachUnkept",
    colour = { 1, .5, .5, .2 },
})
AddTask("MoonRocky", {
    locks = { LOCKS.BLUE },
    keys_given = { KEYS.BLUE },
    room_choices = {
        ["Magma"] = 1,        -- MR went from 1-3
        ["MagmaGoldmoon"] = 1,
        ["Volcano"] = 1,      --火山
        ["VolcanoAltar"] = 1, -- 火山祭坛
    },
    room_bg = WORLD_TILES.BEACH,
    background_room = "MagmaGold",
    "MagmaHomeBoon",
    colour = { 1, .5, .5, .2 },
})
AddTask("TigerSharky", {
    locks = { LOCKS.FUNGUS },
    keys_given = { KEYS.RED },
    room_choices = {
        ["TidalSharkHome"] = 1,
    },
    room_bg = WORLD_TILES.JUNGLE,
    background_room = "JungleRockyDrop",
    colour = { 1, .5, .5, .2 },
})

AddTask("Verdent", {
    locks = { LOCKS.RED },
    keys_given = { KEYS.RED },
    room_choices = {
        ["Beaverkinghome"] = 1,
        ["Beaverkingcity"] = 1,
        [salasmeadow[math.random(1, 9)]] = 1,
    },
    room_bg = WORLD_TILES.MEADOW,
    background_room = "MeadowFlowery",
    colour = { 1, .5, .5, .2 },
})
AddTask("Casino", {
    locks = {},
    keys_given = { KEYS.MUSHROOM, KEYS.RABBIT, KEYS.AREA, KEYS.CAVERN, KEYS.SINKHOLE, KEYS.PASSAGE },
    room_choices = {
        ["BeachPalmCasino"] = 1,
        [salasbeach[math.random(1, 24)]] = 1,
    },
    room_bg = WORLD_TILES.BEACH,
    background_room = salasbeach[math.random(1, 24)],
    colour = { 1, .5, .5, .2 },
})
AddTask("BeachBeachy", {
    locks = { LOCKS.RED },
    keys_given = { KEYS.RED },
    room_choices = {
        [salasbeach[math.random(1, 24)]] = 1,
        [salasbeach[math.random(1, 24)]] = 1, --CM was 5 +
        ["BeachShark"] = 1,
    },
    room_bg = WORLD_TILES.BEACH,
    background_room = "BeachSand",
    colour = { 1, .5, .5, .2 },
})
AddTask("BeachPiggy", {
    locks = { LOCKS.LABYRINTH },
    keys_given = { KEYS.GREEN },
    room_choices = {
        ["BeachSand"] = 1,
        ["BeachPiggy"] = 1,
    },
    room_bg = WORLD_TILES.JUNGLE,
    background_room = "JungleDenseMed",
    colour = { 1, .5, .5, .2 },
})
AddTask("DoyDoyM", {
    locks = { LOCKS.GREEN },
    keys_given = { KEYS.GREEN },
    room_choices = {
        [salasjungle[math.random(1, 24)]] = 1,
        ["DoyDoyM"] = 1,
        [salasjungle[math.random(1, 24)]] = 1,
    },
    room_bg = WORLD_TILES.JUNGLE,
    background_room = "Jungle",
    colour = { 1, .5, .5, .2 },
})
AddTask("DoyDoyF", {
    locks = { LOCKS.GREEN },
    keys_given = { KEYS.GREEN },
    room_choices = {
        [salasjungle[math.random(1, 24)]] = 1,
        ["DoyDoyF"] = 1,
        [salasjungle[math.random(1, 24)]] = 1,
    },
    room_bg = WORLD_TILES.JUNGLE,
    background_room = "Jungle",
    colour = { 1, .5, .5, .2 },
})

AddTask("VolcanoDivide", {
    locks = { LOCKS.LAND_DIVIDE_3 },
    keys_given = { KEYS.VOLCANO_DIVIDE },
    room_choices = {
        ["ForceDisconnectedRoom"] = 5,
    },
    level_set_piece_blocker = true,
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

-- 火山世界，生成在洞穴里
AddTask("Volcano ground", {
    locks = { LOCKS.VOLCANO_DIVIDE },
    keys_given = { KEYS.MEDIUM },
    room_tags = { "volcano" },
    room_choices = {
        ["VolcanoStart"] = 1, --出口
        [salasvolcano[math.random(1, 5)]] = 1,
        [salasvolcano[math.random(1, 5)]] = 1,
        [salasvolcano[math.random(1, 5)]] = 1,
        ["VolcanoAsh"] = 1,
        ["VolcanoObsidian"] = 3,
        ["VolcanoRock"] = 2,
        ["VolcanoObsidianBench"] = 1, --工作台
        ["VolcanoCage"] = 1,          --海盗船长
    },
    room_bg = WORLD_TILES.VOLCANO,
    background_room = "VolcanoNoise",
    cove_room_name = "VolcanoNoise",
    make_loop = true,
    cove_room_chance = 1,
    cove_room_max_edges = 10,
    crosslink_factor = 10,
    colour = { 1, .5, .5, .2 },
})
