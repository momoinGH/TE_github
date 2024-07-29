local Utils = require("tropical_utils/utils")

local SCHOOL_SIZE = {
    TINY = { min = 1, max = 3 },
    SMALL = { min = 2, max = 5 },
    MEDIUM = { min = 4, max = 6 },
    LARGE = { min = 6, max = 10 },
}

local SCHOOL_AREA = {
    TINY = 2,
    SMALL = 3,
    MEDIUM = 6,
    LARGE = 10,
}

local WANDER_DIST = {
    SHORT = { min = 5, max = 15 },
    MEDIUM = { min = 15, max = 30 },
    LONG = { min = 20, max = 40 },
}

local ARRIVE_DIST = {
    CLOSE = 3,
    MEDIUM = 8,
    FAR = 12,
}

local WANDER_DELAY = {
    SHORT = { min = 0, max = 10 },
    MEDIUM = { min = 10, max = 30 },
    LONG = { min = 30, max = 60 },
}

local SEG = 30
local DAY = SEG * 16

local SCHOOL_WORLD_TIME = {
    SHORT = { min = SEG * 8, max = SEG * 16 },
    MEDIUM = { min = DAY, max = DAY * 2 },
    LONG = { min = DAY * 2, max = DAY * 4 },
}

local LOOT = {
    TINY            = { "fishmeat_small" },
    SMALL           = { "fishmeat_small" },
    SMALL_COOKED    = { "fishmeat_small_cooked" },
    MEDIUM          = { "fishmeat" },
    LARGE           = { "fishmeat" },
    HUGE            = { "fishmeat" },
    CORN            = { "corn" },
    POPCORN         = { "corn_cooked" },
    ICE             = { "fishmeat", "ice", "ice" },
    PLANTMEAT       = { "plantmeat" },
    MEDIUM_YOT      = { "fishmeat", "lucky_goldnugget", "lucky_goldnugget" },

    --### 追加内容
    FISH2           = { "fish2" },
    FISH3           = { "fish3" },
    FISH4           = { "fish4" },
    FISH5           = { "fish5" },
    FISH6           = { "fish6" },
    FISH7           = { "fish7" },
    COI             = { "coi" },
    SALMON          = { "salmon" },
    BALLPHIN        = { "ballphinocean" },
    MECFISH         = { "gears" },
    GOLDFISH        = { "goldnugget" },
    SWORDFISHOCEAN  = { "swordfishjocean" },
    SWORDFISHOCEAN2 = { "swordfishjocean2" },
    DOGFISHOCEAN    = { "dogfishocean" },
    WHALEBLUEOCEAN  = { "whaleblueocean" },
    SHARXOCEAN      = { "sharxocean" },
}
local PERISH = {
    TINY = "fishmeat_small",
    SMALL = "fishmeat_small",
    MEDIUM = "fishmeat",
    LARGE = "fishmeat", -- Unused.
    HUGE = "fishmeat",  -- Unused.
    CORN = "corn",
    POPCORN = "corn_cooked",
    PLANTMEAT = "spoiled_food",
}

local COOKING_PRODUCT = {
    TINY = "fishmeat_small_cooked",
    SMALL = "fishmeat_small_cooked",
    MEDIUM = "fishmeat_cooked",
    LARGE = "fishmeat_cooked", -- Unused.
    HUGE = "fishmeat_cooked",  -- Unused.
    CORN = "corn_cooked",
    PLANTMEAT = "plantmeat_cooked",
}

local function MEDIUM_YOT_ONCOOKED_FN(inst, cooker, chef)
    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SpawnLootPrefab("lucky_goldnugget")
        inst.components.lootdropper:SpawnLootPrefab("lucky_goldnugget")
    end
end

local DIET = {
    OMNI = { caneat = { FOODGROUP.OMNI } }, --, preferseating = { FOODGROUP.OMNI } },
    VEGGIE = { caneat = { FOODGROUP.VEGETARIAN } },
    MEAT = { caneat = { FOODTYPE.MEAT } },
    BERRY = { caneat = { FOODTYPE.BERRY } },
}

-- crokpot values
COOKER_INGREDIENT_SMALL = { meat = .5, fish = .5 }
COOKER_INGREDIENT_MEDIUM = { meat = 1, fish = 1 }
COOKER_INGREDIENT_MEDIUM_ICE = { meat = 1, fish = 1, frozen = 1 }

EDIBLE_VALUES_SMALL_MEAT = {
    health = TUNING.HEALING_TINY,
    hunger = TUNING.CALORIES_SMALL,
    sanity = 0,
    foodtype = FOODTYPE.MEAT,
}
EDIBLE_VALUES_MEDIUM_MEAT = {
    health = TUNING.HEALING_MEDSMALL,
    hunger = TUNING.CALORIES_MED,
    sanity = 0,
    foodtype =
        FOODTYPE.MEAT
}
EDIBLE_VALUES_SMALL_VEGGIE = {
    health = TUNING.HEALING_SMALL,
    hunger = TUNING.CALORIES_SMALL,
    sanity = 0,
    foodtype =
        FOODTYPE.VEGGIE
}
EDIBLE_VALUES_MEDIUM_VEGGIE = {
    health = TUNING.HEALING_SMALL,
    hunger = TUNING.CALORIES_MED,
    sanity = 0,
    foodtype =
        FOODTYPE.VEGGIE
}
EDIBLE_VALUES_PLANTMEAT = {
    health = 0,
    hunger = TUNING.CALORIES_SMALL,
    sanity = -TUNING.SANITY_SMALL,
    foodtype =
        FOODTYPE.MEAT
}

-- how long the player has to set the hook before it escapes
local SET_HOOK_TIME_SHORT = { base = 1, var = 0.5 }
local SET_HOOK_TIME_MEDIUM = { base = 2, var = 0.5 }

local BREACH_FX_SMALL = { "ocean_splash_small1", "ocean_splash_small2" }
local BREACH_FX_MEDIUM = { "ocean_splash_med1", "ocean_splash_med2" }

local SHADOW_SMALL = { 1, .75 }
local SHADOW_MEDIUM = { 1.5, 0.75 }

----------------------------------------------------------------------------------------------------

local oceanfishdef = require("prefabs/oceanfishdef")
local FISH_DEFS = oceanfishdef.fish
local SCHOOL_WEIGHTS = oceanfishdef.school

----------------------------------------------------------------------------------------------------

--[[
	-- large school
	oceanfish_antchovy = {
		prefab = "oceanfish_antchovy",
		bank = "antchovy",
		build = "antchovy",
	  	weight_min = WEIGHTS.TINY.min,
	  	weight_max = WEIGHTS.TINY.max,

	  	schoolmin = SCHOOL_SIZE.LARGE.min,
	  	schoolmax = SCHOOL_SIZE.LARGE.max,
	  	schoolrange = SCHOOL_AREA.MEDIUM,	
	  	schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
	  	schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,	  	

	  	herdwandermin = WANDER_DIST.MEDIUM.min,
	  	herdwandermax = WANDER_DIST.MEDIUM.max,
	  	herdarrivedist = ARRIVE_DIST.MEDIUM,		
	  	herdwanderdelaymin = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax = WANDER_DELAY.SHORT.max,

		set_hook_time = SET_HOOK_TIME_MEDIUM,
		breach_fx = BREACH_FX_SMALL,
		loot = LOOT.TINY,
		cooking_product = COOKING_PRODUCT.TINY,
	},
]]

FISH_DEFS.oceanfish_small_61 = {
    prefab = "oceanfish_small_61",
    bank = "fish2",
    build = "fish2",
    oceanbuild = "oceanfish_small_2",
    weight_min = 48.34,
    weight_max = 60.30,

    walkspeed = 1.2,
    runspeed = 2.5,
    stamina =
    {
        drain_rate      = 1.0,
        recover_rate    = 0.1,
        struggle_times  = { low = 5, r_low = 1, high = 5, r_high = 3 },
        tired_times     = { low = 2, r_low = 2, high = 2, r_high = 1 },
        tiredout_angles = { has_tention = 60, low_tention = 90 },
    },

    schoolmin = SCHOOL_SIZE.MEDIUM.min,
    schoolmax = SCHOOL_SIZE.MEDIUM.max,
    schoolrange = SCHOOL_AREA.SMALL,
    schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
    schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

    herdwandermin = WANDER_DIST.MEDIUM.min,
    herdwandermax = WANDER_DIST.MEDIUM.max,
    herdarrivedist = ARRIVE_DIST.MEDIUM,
    herdwanderdelaymin = WANDER_DELAY.LONG.min,
    herdwanderdelaymax = WANDER_DELAY.LONG.max,

    set_hook_time = SET_HOOK_TIME_SHORT,
    breach_fx = BREACH_FX_SMALL,
    loot = LOOT.FISH2,
    cooking_product = "fish_cooked",
    perish_product = PERISH.SMALL,
    fishtype = "meat",

    lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
    diet = DIET.OMNI,
    cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
    edible_values = EDIBLE_VALUES_SMALL_MEAT,

    dynamic_shadow = SHADOW_MEDIUM,
}

FISH_DEFS.oceanfish_small_71 = {
    prefab = "oceanfish_small_71",
    bank = "fish3",
    build = "fish3",
    oceanbuild = "oceanfish_small_5",
    weight_min = 150.49,
    weight_max = 190.20,

    walkspeed = 1.2,
    runspeed = 2.5,
    stamina =
    {
        drain_rate      = 0.05,
        recover_rate    = 0.1,
        struggle_times  = { low = 2, r_low = 1, high = 6, r_high = 1 },
        tired_times     = { low = 3, r_low = 1, high = 2, r_high = 1 },
        tiredout_angles = { has_tention = 80, low_tention = 120 },
    },

    schoolmin = SCHOOL_SIZE.MEDIUM.min,
    schoolmax = SCHOOL_SIZE.MEDIUM.max,
    schoolrange = SCHOOL_AREA.SMALL,
    schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
    schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

    herdwandermin = WANDER_DIST.MEDIUM.min,
    herdwandermax = WANDER_DIST.MEDIUM.max,
    herdarrivedist = ARRIVE_DIST.MEDIUM,
    herdwanderdelaymin = WANDER_DELAY.LONG.min,
    herdwanderdelaymax = WANDER_DELAY.LONG.max,

    set_hook_time = SET_HOOK_TIME_SHORT,
    breach_fx = BREACH_FX_SMALL,
    loot = LOOT.FISH3,
    cooking_product = "fish3_cooked",
    perish_product = PERISH.SMALL,
    fishtype = "meat",

    lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
    diet = DIET.OMNI,
    cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
    edible_values = EDIBLE_VALUES_SMALL_MEAT,

    dynamic_shadow = SHADOW_MEDIUM,
}

FISH_DEFS.oceanfish_small_81 = {
    prefab = "oceanfish_small_81",
    bank = "fish4",
    build = "fish4",
    oceanbuild = "oceanfish_small_5",
    weight_min = 30.55,
    weight_max = 57.62,

    walkspeed = 1.2,
    runspeed = 2.5,
    stamina =
    {
        drain_rate      = 0.1,
        recover_rate    = 0.1,
        struggle_times  = { low = 1, r_low = 2, high = 3, r_high = 2 },
        tired_times     = { low = 1, r_low = 2, high = 1, r_high = 1 },
        tiredout_angles = { has_tention = 80, low_tention = 120 },
    },

    schoolmin = SCHOOL_SIZE.MEDIUM.min,
    schoolmax = SCHOOL_SIZE.MEDIUM.max,
    schoolrange = SCHOOL_AREA.SMALL,
    schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
    schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

    herdwandermin = WANDER_DIST.MEDIUM.min,
    herdwandermax = WANDER_DIST.MEDIUM.max,
    herdarrivedist = ARRIVE_DIST.MEDIUM,
    herdwanderdelaymin = WANDER_DELAY.LONG.min,
    herdwanderdelaymax = WANDER_DELAY.LONG.max,

    set_hook_time = SET_HOOK_TIME_SHORT,
    breach_fx = BREACH_FX_SMALL,
    loot = LOOT.FISH4,
    cooking_product = "fish4_cooked",
    perish_product = PERISH.SMALL,
    fishtype = "meat",

    lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
    diet = DIET.OMNI,
    cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
    edible_values = EDIBLE_VALUES_SMALL_MEAT,

    dynamic_shadow = SHADOW_MEDIUM,
}

FISH_DEFS.oceanfish_small_91 = {
    prefab = "oceanfish_small_91",
    bank = "fish5",
    build = "fish5",
    oceanbuild = "oceanfish_small_5",
    weight_min = 40.80,
    weight_max = 64.44,

    walkspeed = 1.2,
    runspeed = 2.5,
    stamina =
    {
        drain_rate      = 0.5,
        recover_rate    = 0.8,
        struggle_times  = { low = 3, r_low = 0, high = 3, r_high = 1 },
        tired_times     = { low = 5, r_low = 1, high = 3, r_high = 1 },
        tiredout_angles = { has_tention = 80, low_tention = 120 },
    },

    schoolmin = SCHOOL_SIZE.MEDIUM.min,
    schoolmax = SCHOOL_SIZE.MEDIUM.max,
    schoolrange = SCHOOL_AREA.SMALL,
    schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
    schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

    herdwandermin = WANDER_DIST.MEDIUM.min,
    herdwandermax = WANDER_DIST.MEDIUM.max,
    herdarrivedist = ARRIVE_DIST.MEDIUM,
    herdwanderdelaymin = WANDER_DELAY.LONG.min,
    herdwanderdelaymax = WANDER_DELAY.LONG.max,

    set_hook_time = SET_HOOK_TIME_SHORT,
    breach_fx = BREACH_FX_SMALL,
    loot = LOOT.FISH5,
    cooking_product = "fish5_cooked",
    perish_product = PERISH.SMALL,
    fishtype = "meat",

    lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
    diet = DIET.OMNI,
    cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
    edible_values = EDIBLE_VALUES_SMALL_MEAT,

    dynamic_shadow = SHADOW_MEDIUM,
}

FISH_DEFS.oceanfish_small_10 = {
    prefab = "oceanfish_small_10",
    bank = "coi",
    build = "coi",
    oceanbuild = "oceanfish_small_1",
    weight_min = 260.40,
    weight_max = 310.36,

    walkspeed = 0.8,
    runspeed = 2.5,
    stamina =
    {
        drain_rate      = 0.05,
        recover_rate    = 0.10,
        struggle_times  = { low = 3, r_low = 1, high = 8, r_high = 1 },
        tired_times     = { low = 4, r_low = 1, high = 2, r_high = 1 },
        tiredout_angles = { has_tention = 80, low_tention = 120 },
    },

    schoolmin = SCHOOL_SIZE.LARGE.min,
    schoolmax = SCHOOL_SIZE.LARGE.max,
    schoolrange = SCHOOL_AREA.TINY,
    schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
    schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

    herdwandermin = WANDER_DIST.SHORT.min,
    herdwandermax = WANDER_DIST.SHORT.max,
    herdarrivedist = ARRIVE_DIST.MEDIUM,
    herdwanderdelaymin = WANDER_DELAY.SHORT.min,
    herdwanderdelaymax = WANDER_DELAY.SHORT.max,

    set_hook_time = SET_HOOK_TIME_SHORT,
    breach_fx = BREACH_FX_SMALL,
    loot = LOOT.COI,
    cooking_product = "coi_cooked",
    perish_product = PERISH.SMALL,
    fishtype = "meat",

    lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
    diet = DIET.OMNI,
    cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
    edible_values = EDIBLE_VALUES_SMALL_MEAT,

    dynamic_shadow = SHADOW_MEDIUM,
}

FISH_DEFS.oceanfish_small_11 = {
    prefab = "oceanfish_small_11",
    bank = "salmon",
    build = "salmon",
    oceanbuild = "oceanfish_small_5",
    weight_min = 90.71,
    weight_max = 146.25,

    walkspeed = 0.8,
    runspeed = 2.5,
    stamina =
    {
        drain_rate      = 0.05,
        recover_rate    = 0.1,
        struggle_times  = { low = 2, r_low = 1, high = 6, r_high = 1 },
        tired_times     = { low = 3, r_low = 1, high = 2, r_high = 1 },
        tiredout_angles = { has_tention = 80, low_tention = 120 },
    },

    schoolmin = SCHOOL_SIZE.LARGE.min,
    schoolmax = SCHOOL_SIZE.LARGE.max,
    schoolrange = SCHOOL_AREA.TINY,
    schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
    schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

    herdwandermin = WANDER_DIST.SHORT.min,
    herdwandermax = WANDER_DIST.SHORT.max,
    herdarrivedist = ARRIVE_DIST.MEDIUM,
    herdwanderdelaymin = WANDER_DELAY.SHORT.min,
    herdwanderdelaymax = WANDER_DELAY.SHORT.max,

    set_hook_time = SET_HOOK_TIME_SHORT,
    breach_fx = BREACH_FX_SMALL,
    loot = LOOT.SALMON,
    cooking_product = "salmon_cooked",
    perish_product = PERISH.SMALL,
    fishtype = "meat",

    lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
    diet = DIET.OMNI,
    cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
    edible_values = EDIBLE_VALUES_SMALL_MEAT,

    dynamic_shadow = SHADOW_MEDIUM,
}

FISH_DEFS.oceanfish_small_12 = {
    prefab = "oceanfish_small_12",
    bank = "ballphinocean",
    build = "ballphinocean",
    oceanbuild = "oceanfish_small_5",
    golfinho = true,
    weight_min = 320.77,
    weight_max = 380.10,

    walkspeed = 3.0,
    runspeed = 4.0,
    stamina =
    {
        drain_rate      = 0.02,
        recover_rate    = 0.10,
        struggle_times  = { low = 8, r_low = 2, high = 9, r_high = 2 },
        tired_times     = { low = 1.8, r_low = 1, high = 1.7, r_high = 0 },
        tiredout_angles = { has_tention = 45, low_tention = 90 },
    },

    schoolmin = SCHOOL_SIZE.MEDIUM.min,
    schoolmax = SCHOOL_SIZE.MEDIUM.max,
    schoolrange = SCHOOL_AREA.SMALL,
    schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
    schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

    herdwandermin = WANDER_DIST.MEDIUM.min,
    herdwandermax = WANDER_DIST.MEDIUM.max,
    herdarrivedist = ARRIVE_DIST.MEDIUM,
    herdwanderdelaymin = WANDER_DELAY.SHORT.min,
    herdwanderdelaymax = WANDER_DELAY.SHORT.max,

    set_hook_time = SET_HOOK_TIME_SHORT,
    breach_fx = BREACH_FX_MEDIUM,
    loot = LOOT.BALLPHIN,
    cooking_product = COOKING_PRODUCT.MEDIUM,
    perish_product = PERISH.SMALL,
    fishtype = "meat",

    lures = { swfish = 1.00 },
    diet = DIET.OMNI,
    cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
    edible_values = EDIBLE_VALUES_SMALL_MEAT,

    dynamic_shadow = SHADOW_MEDIUM,
}

FISH_DEFS.oceanfish_small_13 = {
    prefab = "oceanfish_small_13",
    bank = "mecfish",
    build = "mecfish",
    oceanbuild = "oceanfish_small_5",
    weight_min = 246.77,
    weight_max = 302.32,

    walkspeed = 2.2,
    runspeed = 3.5,
    stamina =
    {
        drain_rate      = 0.1,
        recover_rate    = 0.25,
        struggle_times  = { low = 4, r_low = 2, high = 6, r_high = 2 },
        tired_times     = { low = 1, r_low = 1, high = 1, r_high = 0 },
        tiredout_angles = { has_tention = 45, low_tention = 90 },
    },

    schoolmin = SCHOOL_SIZE.MEDIUM.min,
    schoolmax = SCHOOL_SIZE.MEDIUM.max,
    schoolrange = SCHOOL_AREA.SMALL,
    schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
    schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

    herdwandermin = WANDER_DIST.MEDIUM.min,
    herdwandermax = WANDER_DIST.MEDIUM.max,
    herdarrivedist = ARRIVE_DIST.MEDIUM,
    herdwanderdelaymin = WANDER_DELAY.SHORT.min,
    herdwanderdelaymax = WANDER_DELAY.SHORT.max,

    set_hook_time = SET_HOOK_TIME_SHORT,
    breach_fx = BREACH_FX_MEDIUM,
    loot = LOOT.MECFISH,
    cooking_product = "gears",
    perish_product = PERISH.MEDIUM,
    fishtype = "meat",

    lures = TUNING.OCEANFISH_LURE_PREFERENCE.MEAT,
    diet = DIET.MEAT,
    cooker_ingredient_value = COOKER_INGREDIENT_MEDIUM,
    edible_values = EDIBLE_VALUES_MEDIUM_MEAT,

    dynamic_shadow = SHADOW_MEDIUM,
}

FISH_DEFS.oceanfish_small_14 = {
    prefab = "oceanfish_small_14",
    bank = "goldfish",
    build = "goldfish",
    oceanbuild = "oceanfish_small_5",
    weight_min = 250.77,
    weight_max = 423.32,

    walkspeed = 2.2,
    runspeed = 3.5,
    stamina =
    {
        drain_rate      = 0.1,
        recover_rate    = 0.25,
        struggle_times  = { low = 4, r_low = 2, high = 6, r_high = 2 },
        tired_times     = { low = 1, r_low = 1, high = 1, r_high = 0 },
        tiredout_angles = { has_tention = 45, low_tention = 90 },
    },

    schoolmin = SCHOOL_SIZE.MEDIUM.min,
    schoolmax = SCHOOL_SIZE.MEDIUM.max,
    schoolrange = SCHOOL_AREA.SMALL,
    schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
    schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

    herdwandermin = WANDER_DIST.MEDIUM.min,
    herdwandermax = WANDER_DIST.MEDIUM.max,
    herdarrivedist = ARRIVE_DIST.MEDIUM,
    herdwanderdelaymin = WANDER_DELAY.SHORT.min,
    herdwanderdelaymax = WANDER_DELAY.SHORT.max,

    set_hook_time = SET_HOOK_TIME_SHORT,
    breach_fx = BREACH_FX_MEDIUM,
    loot = LOOT.GOLDFISH,
    cooking_product = "goldnugget",
    perish_product = PERISH.MEDIUM,
    fishtype = "meat",

    lures = TUNING.OCEANFISH_LURE_PREFERENCE.MEAT,
    diet = DIET.MEAT,
    cooker_ingredient_value = COOKER_INGREDIENT_MEDIUM,
    edible_values = EDIBLE_VALUES_MEDIUM_MEAT,

    dynamic_shadow = SHADOW_MEDIUM,
}

FISH_DEFS.oceanfish_small_15 = {
    prefab = "oceanfish_small_15",
    bank = "whaleblueocean",
    build = "whaleblueocean",
    oceanbuild = "oceanfish_small_5",
    tamanho = 2,
    weight_min = 48.34,
    weight_max = 60.30,

    walkspeed = 0.8,
    runspeed = 2.5,
    stamina =
    {
        drain_rate      = 1.0,
        recover_rate    = 0.1,
        struggle_times  = { low = 2, r_low = 1, high = 5, r_high = 1 },
        tired_times     = { low = 6, r_low = 1, high = 4, r_high = 1 },
        tiredout_angles = { has_tention = 45, low_tention = 80 },
    },

    schoolmin = SCHOOL_SIZE.LARGE.min,
    schoolmax = SCHOOL_SIZE.LARGE.max,
    schoolrange = SCHOOL_AREA.TINY,
    schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
    schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

    herdwandermin = WANDER_DIST.SHORT.min,
    herdwandermax = WANDER_DIST.SHORT.max,
    herdarrivedist = ARRIVE_DIST.MEDIUM,
    herdwanderdelaymin = WANDER_DELAY.SHORT.min,
    herdwanderdelaymax = WANDER_DELAY.SHORT.max,

    set_hook_time = SET_HOOK_TIME_SHORT,
    breach_fx = BREACH_FX_SMALL,
    loot = LOOT.WHALEBLUEOCEAN,
    cooking_product = COOKING_PRODUCT.MEDIUM,
    perish_product = PERISH.SMALL,
    fishtype = "meat",

    lures = { swfish = 1.00 },
    diet = DIET.OMNI,
    cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
    edible_values = EDIBLE_VALUES_SMALL_MEAT,

    dynamic_shadow = SHADOW_MEDIUM,
}

FISH_DEFS.oceanfish_small_16 = {
    prefab = "oceanfish_small_16",
    bank = "dogfishocean",
    build = "dogfishocean",
    oceanbuild = "oceanfish_small_5",
    dogfish = true,
    weight_min = 70.11,
    weight_max = 130.99,

    walkspeed = 1.6,
    runspeed = 2.5,
    stamina =
    {
        drain_rate      = 0.01,
        recover_rate    = 0.6,
        struggle_times  = { low = 5, r_low = 1, high = 12, r_high = 6 },
        tired_times     = { low = 3, r_low = 1, high = 1.7, r_high = 1 },
        tiredout_angles = { has_tention = 60, low_tention = 90 },
    },

    schoolmin = SCHOOL_SIZE.LARGE.min,
    schoolmax = SCHOOL_SIZE.LARGE.max,
    schoolrange = SCHOOL_AREA.TINY,
    schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
    schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

    herdwandermin = WANDER_DIST.SHORT.min,
    herdwandermax = WANDER_DIST.SHORT.max,
    herdarrivedist = ARRIVE_DIST.MEDIUM,
    herdwanderdelaymin = WANDER_DELAY.SHORT.min,
    herdwanderdelaymax = WANDER_DELAY.SHORT.max,

    set_hook_time = SET_HOOK_TIME_SHORT,
    breach_fx = BREACH_FX_SMALL,
    loot = LOOT.DOGFISHOCEAN,
    cooking_product = COOKING_PRODUCT.MEDIUM,
    perish_product = PERISH.SMALL,
    fishtype = "meat",

    lures = { swfish = 1.00 },
    diet = DIET.OMNI,
    cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
    edible_values = EDIBLE_VALUES_SMALL_MEAT,

    dynamic_shadow = SHADOW_MEDIUM,
}

FISH_DEFS.oceanfish_small_17 = {
    prefab = "oceanfish_small_17",
    bank = "fish7",
    build = "fish7",
    oceanbuild = "oceanfish_small_5",
    weight_min = 48.34,
    weight_max = 60.30,

    walkspeed = 0.8,
    runspeed = 2.5,
    stamina =
    {
        drain_rate      = 1.0,
        recover_rate    = 0.1,
        struggle_times  = { low = 2, r_low = 1, high = 5, r_high = 1 },
        tired_times     = { low = 6, r_low = 1, high = 4, r_high = 1 },
        tiredout_angles = { has_tention = 45, low_tention = 80 },
    },

    schoolmin = SCHOOL_SIZE.LARGE.min,
    schoolmax = SCHOOL_SIZE.LARGE.max,
    schoolrange = SCHOOL_AREA.TINY,
    schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
    schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

    herdwandermin = WANDER_DIST.SHORT.min,
    herdwandermax = WANDER_DIST.SHORT.max,
    herdarrivedist = ARRIVE_DIST.MEDIUM,
    herdwanderdelaymin = WANDER_DELAY.SHORT.min,
    herdwanderdelaymax = WANDER_DELAY.SHORT.max,

    set_hook_time = SET_HOOK_TIME_SHORT,
    breach_fx = BREACH_FX_SMALL,
    loot = LOOT.FISH7,
    cooking_product = "fish7_cooked",
    perish_product = PERISH.SMALL,
    fishtype = "meat",

    lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
    diet = DIET.OMNI,
    cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
    edible_values = EDIBLE_VALUES_SMALL_MEAT,

    dynamic_shadow = SHADOW_MEDIUM,
}

FISH_DEFS.oceanfish_small_18 = {
    prefab = "oceanfish_small_18",
    bank = "fish6",
    build = "fish6",
    oceanbuild = "oceanfish_small_5",
    weight_min = 48.34,
    weight_max = 60.30,

    walkspeed = 0.8,
    runspeed = 2.5,
    stamina =
    {
        drain_rate      = 1.0,
        recover_rate    = 0.1,
        struggle_times  = { low = 2, r_low = 1, high = 5, r_high = 1 },
        tired_times     = { low = 6, r_low = 1, high = 4, r_high = 1 },
        tiredout_angles = { has_tention = 45, low_tention = 80 },
    },

    schoolmin = SCHOOL_SIZE.LARGE.min,
    schoolmax = SCHOOL_SIZE.LARGE.max,
    schoolrange = SCHOOL_AREA.TINY,
    schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
    schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

    herdwandermin = WANDER_DIST.SHORT.min,
    herdwandermax = WANDER_DIST.SHORT.max,
    herdarrivedist = ARRIVE_DIST.MEDIUM,
    herdwanderdelaymin = WANDER_DELAY.SHORT.min,
    herdwanderdelaymax = WANDER_DELAY.SHORT.max,

    set_hook_time = SET_HOOK_TIME_SHORT,
    breach_fx = BREACH_FX_SMALL,
    loot = LOOT.FISH6,
    cooking_product = "fish6_cooked",
    perish_product = PERISH.SMALL,
    fishtype = "meat",

    lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
    diet = DIET.OMNI,
    cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
    edible_values = EDIBLE_VALUES_SMALL_MEAT,

    dynamic_shadow = SHADOW_MEDIUM,
}

FISH_DEFS.oceanfish_small_19 = {
    prefab = "oceanfish_small_19",
    bank = "swordfishjocean",
    build = "swordfishjocean",
    oceanbuild = "oceanfish_small_5",
    peixeespada = true,
    tamanho = 1.3,
    weight_min = 270.32,
    weight_max = 320.97,

    walkspeed = 3.0,
    runspeed = 4.0,
    stamina =
    {
        drain_rate      = 0.1,
        recover_rate    = 0.8,
        struggle_times  = { low = 4, r_low = 2, high = 6, r_high = 2 },
        tired_times     = { low = 1, r_low = 1, high = 1, r_high = 0 },
        tiredout_angles = { has_tention = 45, low_tention = 90 },
    },

    schoolmin = SCHOOL_SIZE.MEDIUM.min,
    schoolmax = SCHOOL_SIZE.MEDIUM.max,
    schoolrange = SCHOOL_AREA.SMALL,
    schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
    schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

    herdwandermin = WANDER_DIST.MEDIUM.min,
    herdwandermax = WANDER_DIST.MEDIUM.max,
    herdarrivedist = ARRIVE_DIST.MEDIUM,
    herdwanderdelaymin = WANDER_DELAY.SHORT.min,
    herdwanderdelaymax = WANDER_DELAY.SHORT.max,

    set_hook_time = SET_HOOK_TIME_SHORT,
    breach_fx = BREACH_FX_MEDIUM,
    loot = LOOT.SWORDFISHOCEAN,
    cooking_product = COOKING_PRODUCT.MEDIUM,
    perish_product = PERISH.SMALL,
    fishtype = "meat",

    lures = { swfish = 1.00 },
    diet = DIET.OMNI,
    cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
    edible_values = EDIBLE_VALUES_SMALL_MEAT,

    dynamic_shadow = SHADOW_MEDIUM,
}

FISH_DEFS.oceanfish_small_20 = {
    prefab = "oceanfish_small_20",
    bank = "swordfishjocean2",
    build = "swordfishjocean2",
    oceanbuild = "oceanfish_small_5",
    peixeespada = true,
    tamanho = 1.3,
    weight_min = 140.74,
    weight_max = 187.52,

    walkspeed = 3.0,
    runspeed = 4.0,
    stamina =
    {
        drain_rate      = 0.02,
        recover_rate    = 0.10,
        struggle_times  = { low = 8, r_low = 2, high = 9, r_high = 2 },
        tired_times     = { low = 1.8, r_low = 1, high = 1.7, r_high = 0 },
        tiredout_angles = { has_tention = 45, low_tention = 90 },
    },

    schoolmin = SCHOOL_SIZE.LARGE.min,
    schoolmax = SCHOOL_SIZE.LARGE.max,
    schoolrange = SCHOOL_AREA.TINY,
    schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
    schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

    herdwandermin = WANDER_DIST.SHORT.min,
    herdwandermax = WANDER_DIST.SHORT.max,
    herdarrivedist = ARRIVE_DIST.MEDIUM,
    herdwanderdelaymin = WANDER_DELAY.SHORT.min,
    herdwanderdelaymax = WANDER_DELAY.SHORT.max,

    set_hook_time = SET_HOOK_TIME_SHORT,
    breach_fx = BREACH_FX_SMALL,
    loot = LOOT.SWORDFISHOCEAN2,
    cooking_product = COOKING_PRODUCT.MEDIUM,
    perish_product = PERISH.SMALL,
    fishtype = "meat",

    lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
    diet = DIET.OMNI,
    cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
    edible_values = EDIBLE_VALUES_SMALL_MEAT,

    dynamic_shadow = SHADOW_MEDIUM,
}

FISH_DEFS.oceanfish_small_21 = {
    prefab = "oceanfish_small_21",
    bank = "sharxocean",
    build = "sharxocean",
    oceanbuild = "oceanfish_small_5",
    sharx = true,
    tamanho = 1.5,
    weight_min = 175.72,
    weight_max = 249.12,

    walkspeed = 3.0,
    runspeed = 4.5,
    stamina =
    {
        drain_rate      = 0.3,
        recover_rate    = 0.10,
        struggle_times  = { low = 4.6, r_low = 1, high = 4.2, r_high = 0.2 },
        tired_times     = { low = 0.3, r_low = 0.2, high = 0.7, r_high = 0.07 },
        tiredout_angles = { has_tention = 45, low_tention = 80 },
    },

    schoolmin = SCHOOL_SIZE.LARGE.min,
    schoolmax = SCHOOL_SIZE.LARGE.max,
    schoolrange = SCHOOL_AREA.TINY,
    schoollifetimemin = SCHOOL_WORLD_TIME.MEDIUM.min,
    schoollifetimemax = SCHOOL_WORLD_TIME.MEDIUM.max,

    herdwandermin = WANDER_DIST.SHORT.min,
    herdwandermax = WANDER_DIST.SHORT.max,
    herdarrivedist = ARRIVE_DIST.MEDIUM,
    herdwanderdelaymin = WANDER_DELAY.SHORT.min,
    herdwanderdelaymax = WANDER_DELAY.SHORT.max,

    set_hook_time = SET_HOOK_TIME_SHORT,
    breach_fx = BREACH_FX_SMALL,
    loot = LOOT.SHARXOCEAN,
    cooking_product = COOKING_PRODUCT.MEDIUM,
    perish_product = PERISH.SMALL,
    fishtype = "meat",

    lures = { swfish = 1.00 },
    diet = DIET.OMNI,
    cooker_ingredient_value = COOKER_INGREDIENT_SMALL,
    edible_values = EDIBLE_VALUES_SMALL_MEAT,

    dynamic_shadow = SHADOW_MEDIUM,
}

----------------------------------------------------------------------------------------------------
local SCHOOL_VERY_COMMON     = 4
local SCHOOL_COMMON          = 2
local SCHOOL_UNCOMMON        = 1
local SCHOOL_RARE            = 0.25


Utils.AppendKVArray(SCHOOL_WEIGHTS[SEASONS.AUTUMN][WORLD_TILES.OCEAN_COASTAL], {
    oceanfish_small_61 = SCHOOL_COMMON,
    oceanfish_small_71 = SCHOOL_COMMON,
    oceanfish_small_81 = SCHOOL_RARE,
    oceanfish_small_91 = SCHOOL_RARE,
})
SCHOOL_WEIGHTS[SEASONS.AUTUMN][WORLD_TILES.OCEAN_COASTAL_SHORE] = {}
SCHOOL_WEIGHTS[SEASONS.AUTUMN][WORLD_TILES.OCEAN_BRINEPOOL_SHORE] = {}
Utils.AppendKVArray(SCHOOL_WEIGHTS[SEASONS.AUTUMN][WORLD_TILES.OCEAN_SWELL], {
    oceanfish_small_61 = SCHOOL_RARE,
    oceanfish_small_71 = SCHOOL_RARE,
    oceanfish_small_81 = SCHOOL_COMMON,
    oceanfish_small_91 = SCHOOL_COMMON,
})
Utils.AppendKVArray(SCHOOL_WEIGHTS[SEASONS.AUTUMN][WORLD_TILES.OCEAN_ROUGH], {
    oceanfish_small_10 = SCHOOL_UNCOMMON,
    oceanfish_small_11 = SCHOOL_UNCOMMON,
})
Utils.AppendKVArray(SCHOOL_WEIGHTS[SEASONS.AUTUMN][WORLD_TILES.OCEAN_BRINEPOOL], {
    oceanfish_small_13 = SCHOOL_UNCOMMON,
    oceanfish_small_14 = SCHOOL_UNCOMMON,
})
Utils.AppendKVArray(SCHOOL_WEIGHTS[SEASONS.AUTUMN][WORLD_TILES.OCEAN_HAZARDOUS], {
    oceanfish_small_17 = SCHOOL_UNCOMMON,
    oceanfish_small_18 = SCHOOL_UNCOMMON,
})
Utils.AppendKVArray(SCHOOL_WEIGHTS[SEASONS.AUTUMN][WORLD_TILES.OCEAN_WATERLOG], {
    oceanfish_small_17 = SCHOOL_UNCOMMON,
    oceanfish_small_18 = SCHOOL_UNCOMMON,
})

----------------------------------------------------------------------------------------------------

-- 源代码
SCHOOL_WEIGHTS[SEASONS.WINTER] = deepcopy(SCHOOL_WEIGHTS[SEASONS.AUTUMN])
SCHOOL_WEIGHTS[SEASONS.SPRING] = deepcopy(SCHOOL_WEIGHTS[SEASONS.AUTUMN])
SCHOOL_WEIGHTS[SEASONS.SUMMER] = deepcopy(SCHOOL_WEIGHTS[SEASONS.AUTUMN])


-- Seasonal Fish
SCHOOL_WEIGHTS[SEASONS.AUTUMN][GROUND.OCEAN_SWELL].oceanfish_small_6 = SCHOOL_UNCOMMON
SCHOOL_WEIGHTS[SEASONS.WINTER][GROUND.OCEAN_SWELL].oceanfish_medium_8 = SCHOOL_UNCOMMON
SCHOOL_WEIGHTS[SEASONS.SPRING][GROUND.OCEAN_COASTAL].oceanfish_small_7 = SCHOOL_UNCOMMON
SCHOOL_WEIGHTS[SEASONS.AUTUMN][GROUND.OCEAN_WATERLOG].oceanfish_small_6 = SCHOOL_COMMON
SCHOOL_WEIGHTS[SEASONS.SPRING][GROUND.OCEAN_WATERLOG].oceanfish_small_7 = SCHOOL_COMMON
SCHOOL_WEIGHTS[SEASONS.SUMMER][GROUND.OCEAN_SWELL].oceanfish_small_8 = SCHOOL_UNCOMMON
