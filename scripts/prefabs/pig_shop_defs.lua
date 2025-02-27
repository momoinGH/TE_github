-- The price cannot be random, as it determines the SWAP_SIGN override symbol in shop_pedestals.lua, SetCost function.
-- Available prices: [1, 2, 3, 4, 5, 10, 20, 30, 40, 50, 100, 200, 300, 400, 500]
-- 猪人商店的商品售卖表

-- 货架商品
local SHOPTYPES = {

    DEFAULT = {
        "rocks",
        "flint",
        "goldnugget",
    },

    pig_shop_deli = {
        { "ratatouille", "oinc", 3 },
        { "monsterlasagna", "oinc", 2 },
        { "pumpkincookie", "oinc", 3 },
        { "stuffedeggplant", "oinc", 4 },
        { "frogglebunwich", "oinc", 5 },
        { "honeynuggets", "oinc", 5 },
        { "perogies", "oinc", 10 },
        { "waffles", "oinc", 10 },
        { "meatballs", "oinc", 10 },
        { "honeyham", "oinc", 20 },
        { "turkeydinner", "oinc", 10 },
        { "dragonpie", "oinc", 30 },
    },

    pig_shop_florist = {
        --{ "asparagus_seeds", "oinc", 1 },
        --{ "carrot_seeds", "oinc", 1 },
        { "corn_seeds", "oinc", 1 },
        { "eggplant_seeds", "oinc", 1 },
        { "garlic_seeds", "oinc", 1 },
        { "onion_seeds", "oinc", 1 },
        { "pepper_seeds", "oinc", 1 },
        --{ "potato_seeds", "oinc", 1 },
        { "pumpkin_seeds", "oinc", 1 },
        --{ "tomato_seeds", "oinc", 1 },
        { "dragonfruit_seeds", "oinc", 10 },
        { "durian_seeds", "oinc", 1 },
        { "pomegranate_seeds", "oinc", 1 },
        { "watermelon_seeds", "oinc", 1 },

        --{ "aloe_seeds", "oinc", 1 },
        --{ "radish_seeds", "oinc", 1 },
        --{ "sweet_potato_seeds", "oinc", 1 },
        --{ "turnip_seeds", "oinc", 1 },
        --{ "wheat_seeds", "oinc", 1 },

        { "flowerhat", "oinc", 2 },
        { "acorn", "oinc", 1 },
        { "pinecone", "oinc", 1 },
        { "dug_berrybush2", "oinc", 2 },
        { "dug_berrybush", "oinc", 2 },
    },

    pig_shop_general = {
        { "pitchfork", "oinc", 5 },
        { "shovel", "oinc", 5 },
        { "pickaxe", "oinc", 5 },
        { "axe", "oinc", 5 },
        { "flint", "oinc", 1 },
        { "machete", "oinc", 5 },
        { "minerhat", "oinc", 20 },
        { "razor", "oinc", 3 },
        { "backpack", "oinc", 5 },
        { "umbrella", "oinc", 10 },
        { "fabric", "oinc", 5 },
        { "bugnet", "oinc", 20 },
        { "fishingrod", "oinc", 10 },
    },
    pig_shop_general_fiesta = {
        { "firecrackers", "oinc", 1 },
        { "firecrackers", "oinc", 1 },
        { "firecrackers", "oinc", 1 },
        { "firecrackers", "oinc", 1 },
        { "flint", "oinc", 1 },
        { "minerhat", "oinc", 20 },
        { "backpack", "oinc", 5 },
        { "fabric", "oinc", 5 },
        { "umbrella", "oinc", 10 },
        { "bugnet", "oinc", 20 },
    },

    pig_shop_hoofspa = {
        { "blue_cap", "oinc", 3 },
        { "green_cap", "oinc", 2 },
        { "bandage", "oinc", 5 },
        { "healingsalve", "oinc", 4 },
        { "antivenom", "oinc", 5 },
        { "coffeebeans", "oinc", 2 },
    },

    pig_shop_produce = {
        { "berries", "oinc", 1 },
        { "watermelon", "oinc", 1 },
        { "sweet_potato", "oinc", 1 },
        { "carrot", "oinc", 1 },
        { "drumstick", "oinc", 2 },
        { "eggplant", "oinc", 2 },
        { "corn", "oinc", 2 },
        { "pumpkin", "oinc", 3 },
        { "meat", "oinc", 5 },
        { "pomegranate", "oinc", 1 },
        { "cave_banana", "oinc", 1 },
        { "coconut", "oinc", 3 },
        { "froglegs", "oinc", 2 },
    },

    pig_shop_antiquities = {
        { "silk", "oinc", 5 },
        { "gears", "oinc", 20 },
        { "mandrake", "oinc", 50 },
        { "wormlight", "oinc", 5 },
        { "deerclops_eyeball", "oinc", 50 },
        { "walrus_tusk", "oinc", 50 },
        { "bearger_fur", "oinc", 40 },
        { "goose_feather", "oinc", 10 },
        { "dragon_scales", "oinc", 30 },
        { "houndstooth", "oinc", 5 },
        { "bamboo", "oinc", 3 },
        { "horn", "oinc", 5 },
        { "coontail", "oinc", 4 },
        { "lightninggoathorn", "oinc", 5 },
        { "ox_horn", "oinc", 5 },
    },

    pig_shop_arcane = {
        { "icestaff", "oinc", 30 },
        { "firestaff", "oinc", 30 },
        { "amulet", "oinc", 50 },
        { "blueamulet", "oinc", 30 },
        { "purpleamulet", "oinc", 50 },
        { "livinglog", "oinc", 5 },
        { "armorslurper", "oinc", 20 },
        { "nightsword", "oinc", 50 },
        { "armor_sanity", "oinc", 20 },
        { "onemanband", "oinc", 40 },
    },

    pig_shop_weapons = {
        { "spear", "oinc", 3 },
        { "halberd", "oinc", 10 },
        { "cutlass", "oinc", 50 },
        { "trap_teeth", "oinc", 10 },
        { "birdtrap", "oinc", 20 },
        { "trap", "oinc", 2 },
        { "coconade", "oinc", 20 },
        { "blowdart_pipe", "oinc", 10 },
        { "blowdart_sleep", "oinc", 10 },
        { "boomerang", "oinc", 10 },
    },

    pig_shop_hatshop = {
        { "winterhat", "oinc", 10 },
        { "tophat", "oinc", 10 },
        { "earmuffshat", "oinc", 5 },
        { "walrushat", "oinc", 50 },
        { "molehat", "oinc", 20 },
        { "catcoonhat", "oinc", 10 },
        { "captainhat", "oinc", 20 },
        { "featherhat", "oinc", 5 },
        { "strawhat", "oinc", 3 },
        { "beefalohat", "oinc", 10 },
        { "pithhat", "oinc", 10 },
        { "sewing_kit", "oinc", 50 },
    },

    pig_shop_bank = {
        { "goldnugget", "oinc", 10 },
        { "oinc10", "oinc", 10 },
        { "oinc100", "oinc", 100 },
    },

    pig_shop_tinker = {
        { "eyebrellahat_blueprint", "oinc", 300 },
        { "cane_blueprint", "oinc", 500 },
        { "icepack_blueprint", "oinc", 100 },
        { "staff_tornado_blueprint", "oinc", 100 },
        { "armordragonfly_blueprint", "oinc", 200 },
        { "dragonflychest_blueprint", "oinc", 200 },
        { "molehat_blueprint", "oinc", 30 },
        { "beargervest_blueprint", "oinc", 50 },
        { "ox_flute_blueprint", "oinc", 100 },
        { "trawlnet_blueprint", "oinc", 30 },
    },

    pig_shop_academy = {},
    pig_shop_cityhall = {},
    pig_shop_fishing = {}
}

-- 柜子里的商品
local SHELFS = {
    DEFAULT = {
        "rocks",
        "flint",
        "goldnugget",
    }
}

return { SHOPTYPES = SHOPTYPES, SHELFS = SHELFS }
