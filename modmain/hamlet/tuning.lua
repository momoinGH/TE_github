local seg_time                       = TUNING.SEG_TIME

-- 呼噜币换算
TUNING.OINCS                         = {
    oinc = 1,
    oinc10 = 10,
    oinc100 = 100,
}

-- 利齿捕蝇草
TUNING.ADULT_FLYTRAP_HEALTH          = 400
TUNING.ADULT_FLYTRAP_DAMAGE          = 30
TUNING.ADULT_FLYTRAP_ATTACK_PERIOD   = 5
TUNING.ADULT_FLYTRAP_ATTACK_DIST     = 4
TUNING.ADULT_FLYTRAP_STOPATTACK_DIST = 6
TUNING.ADULT_FLYTRAP_GROW_TIME       = 480 * 2

-- 远古先驱
TUNING.ANCIENT_HERALD_HEALTH         = 8000 * TUNING.tropical.bosslife
TUNING.ANCIENT_HERALD_DAMAGE         = 50

-- 远古铁巨人
TUNING.ANCIENT_HULK_HEALTH           = 8000 * TUNING.tropical.bosslife
TUNING.ANCIENT_HULK_DAMAGE           = 200
TUNING.ANCIENT_HULK_MINE_DAMAGE      = 100
TUNING.ANCIENT_HULK_MELEE_RANGE      = 5.5
TUNING.ANCIENT_HULK_ATTACK_RANGE     = 5.5
TUNING.ANCIENT_HULK_SPEED            = 60

-- 蚁后
TUNING.ANTQUEEN_HEALTH               = 16000 * TUNING.tropical.bosslife

-- 合金盔甲
TUNING.ARMORMETAL                    = 150 * 8
TUNING.ARMORMETAL_ABSORPTION         = .85
TUNING.ARMORMETAL_SLOW               = 0.90


TUNING.RUINS_ENTRANCE_VINES_HACKS   = 4

TUNING.WILBA_HEALTH                 = 150

TUNING.ROOM_TINY_WIDTH              = 15
TUNING.ROOM_TINY_DEPTH              = 10

TUNING.ROOM_SMALL_WIDTH             = 18
TUNING.ROOM_SMALL_DEPTH             = 12

TUNING.ROOM_MEDIUM_WIDTH            = 24
TUNING.ROOM_MEDIUM_DEPTH            = 16

TUNING.ROOM_LARGE_WIDTH             = 26
TUNING.ROOM_LARGE_DEPTH             = 18

TUNING.ANTMAN_REGEN_TIME            = seg_time * 4
TUNING.ANTMAN_RELEASE_TIME          = seg_time
TUNING.ANTMAN_MIN                   = 3
TUNING.ANTMAN_MAX                   = 4

TUNING.CITY_PIG_GUARD_TARGET_DIST   = 20

TUNING.GROGGINESS_WEAR_OFF_DURATION = 0.5

-- 蜜箱里会刷出和能存放的东西
TUNING.ANTCHEST_PRESERVATION        = {
    honey = true,
    royal_jelly = true,
    nectar_pod = true,
    pollen_item = true,
}
