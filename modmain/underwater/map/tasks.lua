AddTask("task_secretcave1", {
    locks = LOCKS.WILD_JUNGLE_DEPTH_1,
    keys_given = KEYS.WILD_JUNGLE_DEPTH_1,
    room_choices = {
        ["cave_underwater1_part1"] = 1,
    },
    level_set_piece_blocker = true,
    room_bg = WORLD_TILES.IMPASSABLE,
    background_room = "cave_underwater_base",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})
AddTask("UnderwaterStart", {
    locks = LOCKS.LAND_DIVIDE_4,
    keys_given = { KEYS.JUNGLE_DEPTH_1, KEYS.JUNGLE_DEPTH_2, KEYS.JUNGLE_DEPTH_3, },

    room_choices = {
        ["SandyBottom"] = math.random(2),
        ["SandyBottomCoralPatch"] = (math.random() > 0.5 and 1) or 0,
        ["startPatch"] = 1,
    },
    level_set_piece_blocker = true,
    room_bg = WORLD_TILES.UNDERWATER_SANDY,
    background_room = "bg_SandyBottom",
    colour = { r = 0, g = 0, b = 0, a = 0 },
})

AddTask("SandyBiome", {
    locks = LOCKS.JUNGLE_DEPTH_1,
    keys_given = { KEYS.OTHER_JUNGLE_DEPTH_1 },

    room_choices = {
        ["SandyBottom"] = math.random(2),
        ["SandyBottomTreasureTrove"] = (math.random() > 0.5 and 1) or 0,
        ["SandyBottomCoralPatch"] = 1,
    },
    level_set_piece_blocker = true,
    room_bg = WORLD_TILES.UNDERWATER_SANDY,
    background_room = "bg_SandyBottom",
    colour = { r = 0, g = 0, b = 0, a = 0 },
})
AddTask("ReefBiome", {
    locks = LOCKS.JUNGLE_DEPTH_2,
    keys_given = { KEYS.OTHER_JUNGLE_DEPTH_2 },

    room_choices = {
        ["CoralReef"] = math.random(2),
        ["CoralReefLight"] = (math.random() > 0.5 and 1) or 0,
        ["CoralReefJunked"] = 1,
    },
    level_set_piece_blocker = true,
    room_bg = WORLD_TILES.UNDERWATER_SANDY,
    background_room = "bg_CoralReef",
    colour = { r = 0, g = 0, b = 0, a = 0 },
})
AddTask("KelpBiome", {
    locks = LOCKS.JUNGLE_DEPTH_3,
    keys_given = { KEYS.LOST_JUNGLE_DEPTH_2 },

    room_choices = {
        ["KelpForest"] = math.random(2),
        ["KelpForestInfested"] = (math.random() > 0.5 and 1) or 0,
        ["KelpForestLight"] = 1,
    },
    level_set_piece_blocker = true,
    room_bg = WORLD_TILES.UNDERWATER_SANDY,
    background_room = "bg_KelpForest",
    colour = { r = 0, g = 0, b = 0, a = 0 },
})
AddTask("RockyBiome", {
    locks = LOCKS.OTHER_JUNGLE_DEPTH_1,
    keys_given = { KEYS.PINACLE },

    room_choices = {
        ["RockyBottom"] = math.random(2),
        ["RockyBottomBroken"] = 1,
    },
    level_set_piece_blocker = true,
    room_bg = WORLD_TILES.UNDERWATER_ROCKY,
    background_room = "bg_RockyBottom",
    colour = { r = 0, g = 0, b = 0, a = 0 },
})

AddTask("MoonBiome", {
    locks = LOCKS.PINACLE,
    keys_given = { KEYS.WILD_JUNGLE_DEPTH_2 },

    room_choices = {
        ["LunnarBottom"] = 2,
        ["LunnarBottomBroken"] = 1,
        ["Lunnarrocks"] = 1,
        ["Lunnarrocksgnar"] = 1,
    },
    level_set_piece_blocker = true,
    room_bg = WORLD_TILES.PEBBLEBEACH,
    background_room = "bg_LunnarBottom",
    colour = { r = 0, g = 0, b = 0, a = 0 },
})
AddTask("OpenWaterBiome", {
    locks = LOCKS.OTHER_JUNGLE_DEPTH_1,
    keys_given = { KEYS.PINACLE },

    entrance_room = "TidalZoneEntrance",
    room_choices = {
        ["TidalZone"] = math.random(2),
    },
    level_set_piece_blocker = true,
    room_bg = WORLD_TILES.UNDERWATER_SANDY,
    background_room = "bg_TidalZone",
    colour = { r = 0, g = 0, b = 0, a = 0 },
})
AddTask("task_underground_beach", {
    locks = LOCKS.OTHER_JUNGLE_DEPTH_2,
    keys_given = { KEYS.CIVILIZATION_1 },
    room_choices = {
        ["beach1"] = 1,
        ["beach2"] = 1,
        ["beach_crab"] = 1,
    },
    level_set_piece_blocker = true,
    room_bg = WORLD_TILES.UNDERWATER_SANDY,
    background_room = "beach_bg",
    colour = { r = 0, g = 1, b = 0, a = 1 }
})
AddTask("task_underwaterothers", {
    locks = LOCKS.LOST_JUNGLE_DEPTH_2,
    keys_given = { KEYS.CIVILIZATION_2 },
    room_choices = {
        ["underwaterothers_lobster"] = 1,
        ["underwaterothers_basic"] = 2,
    },
    level_set_piece_blocker = true,
    room_bg = WORLD_TILES.UNDERWATER_SANDY,
    background_room = "underwaterothers_bg",
    colour = { r = 0, g = 1, b = 0, a = 1 }
})
AddTask("task_underwater_kraken_zone", {
    locks = LOCKS.CIVILIZATION_1,
    keys_given = { KEYS.OTHER_CIVILIZATION_1 },
    room_choices = {
        ["kraken_zone"] = 1,
        ["kraken_zone_basic"] = 2,
    },
    level_set_piece_blocker = true,
    room_bg = WORLD_TILES.IMPASSABLE,
    background_room = "kraken_zone_bg",
    colour = { r = 0, g = 1, b = 0, a = 1 }
})
AddTask("secretcavedivisor", {
    locks = LOCKS.OTHER_CIVILIZATION_1,
    keys_given = KEYS.WILD_JUNGLE_DEPTH_1,
    room_choices = {
        ["ForceDisconnectedRoom"] = 6,
    },
    level_set_piece_blocker = true,
    entrance_room = "cave_underwater1_entrance",
    room_bg = WORLD_TILES.UNDERWATER_ROCKY,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
})
AddTask("atlantidaExitRoom", {
    locks = { LOCKS.ENTRANCE_INNER, LOCKS.ENTRANCE_OUTER },
    keys_given = {},
    room_choices =
    {
        ["atlantidaExitRoom"] = 1,
    },
    room_bg = WORLD_TILES.MANGROVE,
    background_room = "BGSinkhole",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})
AddTask("task_underwaterlavarock", {
    locks = LOCKS.LOST_JUNGLE_DEPTH_2,
    keys_given = { KEYS.CIVILIZATION_2 },
    room_choices = {
        ["underwaterlavarock"] = 3,
    },
    level_set_piece_blocker = true,
    room_bg = WORLD_TILES.UNDERWATER_ROCKY,
    background_room = "underwaterlavarock",
    colour = { r = 0, g = 1, b = 0, a = 1 }
})
AddTask("task_underwatermagmafield", {
    locks = LOCKS.OTHER_JUNGLE_DEPTH_2,
    keys_given = { KEYS.CIVILIZATION_1 },
    room_choices = {
        ["underwatermagmafield1"] = 2,
        ["underwatermagmafield"] = 1,
    },
    level_set_piece_blocker = true,
    room_bg = WORLD_TILES.UNDERWATER_ROCKY,
    background_room = "underwatermagmafield",
    colour = { r = 0, g = 1, b = 0, a = 1 }
})
AddTask("task_underwaterwatercoral", {
    locks = LOCKS.CIVILIZATION_2,
    keys_given = { KEYS.OTHER_CIVILIZATION_2 },
    room_choices = {
        ["underwaterwatercoral_octopus"] = 1,
        ["underwaterwatercoral"] = 2,

    },
    level_set_piece_blocker = true,
    room_bg = WORLD_TILES.PAINTED,
    background_room = "underwaterwatercoral_bg",
    colour = { r = 0, g = 1, b = 0, a = 1 }
})

AddTask("UnderwaterExit2", {
    locks = LOCKS.OTHER_CIVILIZATION_2,
    keys_given = { KEYS.OTHER_CIVILIZATION_2, },

    room_choices = {
        ["SandyBottom"] = math.random(2),
        ["SandyBottomCoralPatch"] = (math.random() > 0.5 and 1) or 0,
        ["exitPatch2"] = 1,
    },
    level_set_piece_blocker = true,
    room_bg = WORLD_TILES.UNDERWATER_SANDY,
    background_room = "bg_SandyBottom",
    colour = { r = 0, g = 0, b = 0, a = 0 },
})

AddTask("underwaterdivide", {
    locks = { LOCKS.LAND_DIVIDE_3 },
    keys_given = { KEYS.LAND_DIVIDE_4 },
    room_choices = {
        ["ForceDisconnectedRoom"] = 10,
    },
    level_set_piece_blocker = true,
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 1, g = 1, b = 1, a = 0.3 }
})

-- 地上入口
AddTask("EntranceToReef", {
    locks = { LOCKS.SPIDERS_DEFEATED },
    keys_given = { KEYS.SPIDERS },

    room_choices = {
        ["UnderwaterEntrance"] = 1,
    },
    room_bg = GROUND.FOREST,
    background_room = "BGGrass",
    colour = { r = 0, g = 0, b = 0, a = 0 },
})
