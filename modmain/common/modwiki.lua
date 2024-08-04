local Constructor = require("tropical_utils/constructor")
Constructor.SetEnv(env)

-- 默认动画
local function GetDefaultItem()
    return {
        build = "pigman_tribe",
        bank = "pigman_tribe",
        anim = "idle",
        animoffsetbgx = 80,
        animoffsetbgy = 60,
    }
end

local volcanoinventory = "images/inventoryimages/volcanoinventory.xml"
local hamletinventory = "images/inventoryimages/hamletinventory.xml"

Constructor.AddScrapbookWiki("tropical", {
    adult_flytrap = {
        bank = "venus_flytrap_planted",
        build = "venus_flytrap_lg_build",
        anim = "idle",
        health = TUNING.ADULT_FLYTRAP_HEALTH,
        damage = TUNING.ADULT_FLYTRAP_DAMAGE,
        sanityaura = -TUNING.SANITYAURA_MED,
        deps = { "mean_flytrap", "plantmeat", "vine", "venus_stalk", "nectar_pod" },
    },
    alloy = {
        atlas = hamletinventory,
        tex = "alloy.tex",
        bank = "alloy",
        build = "alloy",
        anim = "idle",
        foodtype = FOODTYPE.ELEMENTAL,
        hungervalue = 2,
        fueltype = FUELTYPE.LIVINGARTIFACT,
        fuelvalue = 20
    },
    goldenbar = {
        atlas = volcanoinventory,
        tex = "goldenbar.tex",
        bank = "alloy",
        build = "alloygold",
        anim = "idle",
        foodtype = FOODTYPE.ELEMENTAL,
        hungervalue = 2,
    },
    stonebar = {
        atlas = volcanoinventory,
        tex = "stonebar.tex",
        bank = "alloy",
        build = "alloystone",
        anim = "idle",
        foodtype = FOODTYPE.ELEMENTAL,
        hungervalue = 2,
    },
    aloe_planted = {
        bank = "aloe",
        build = "aloe",
        anim = "planted",
        pickable = true,
        deps = { "aloe" },
    },
    ancient_herald = {
        bank = "ancient_spirit",
        build = "ancient_spirit",
        anim = "idle",
        health = TUNING.ANCIENT_HERALD_HEALTH,
        damage = TUNING.ANCIENT_HERALD_DAMAGE,
        sanityaura = -TUNING.SANITYAURA_HUGE,
        deps = { "ancient_remnant", "nightmarefuel", "armorvortexcloak" },
    },
    ancient_hulk = {
        bank = "metal_hulk",
        build = "metal_hulk_build",
        anim = "idle",
        health = TUNING.ANCIENT_HULK_HEALTH,
        damage = TUNING.ANCIENT_HULK_DAMAGE,
        sanityaura = -TUNING.SANITYAURA_HUGE,
        deps = { "living_artifact" }
    },
    antchest = {
        bank = "ant_chest",
        build = "ant_chest",
        anim = "closed",
        workable = "HAMMER"
    },
    honeychest = {
        bank = "honey_chest",
        build = "honey_chest",
        anim = "closed",
        workable = "HAMMER",
        deps = { "chestupgrade_stacksize" }
    },
    antidote = {
        atlas = volcanoinventory,
        tex = "antidote.tex",
        bank = "poison_antidote",
        build = "poison_antidote",
        anim = "idle",
    },
    antman = {
        bank = "antman",
        build = "antman_translucent_build",
        anim = "idle_loop",
    },
    antman_warrior = {
        bank = "antman",
        build = "antman_guard_build",
        anim = "idle_loop",
    },
    antqueen = {
        bank = "crick_crickantqueen",
        build = "crickant_queen_basics",
        anim = "idle",
        health = TUNING.ANTQUEEN_HEALTH,
        deps = { "antman_warrior", "pigcrownhat", "royal_jelly", "chitin", "honey", "honeychest" }
    },
    antsuit = {
        atlas = hamletinventory,
        tex = "antsuit.tex",
        bank = "antsuit",
        build = "antsuit",
        anim = "anim",
        armor = TUNING.ARMORWOOD,
        absorb_percent = TUNING.ARMORWOOD_ABSORPTION,
        fueledmax = TUNING.RAINCOAT_PERISHTIME,
        fueledtype1 = FUELTYPE.USAGE
    },
    armorcactus = {
        atlas = volcanoinventory,
        tex = "armorcactus.tex",
        bank = "armor_cactus",
        build = "armor_cactus",
        anim = "anim",
        armor = TUNING.ARMORCACTUS,
        absorb_percent = TUNING.ARMORCACTUS_ABSORPTION,
    },
    armor_lifejacket = {
        atlas = volcanoinventory,
        tex = "armor_lifejacket.tex",
        bank = "armor_lifejacket",
        build = "armor_lifejacket",
        anim = "anim",
        burnable = true,
    },
    armorlimestone = {
        atlas = hamletinventory,
        tex = "armorlimestone.tex",
        bank = "armor_limestone",
        build = "armor_limestone",
        anim = "anim",
        armor = TUNING.ARMORLIMESTONE,
        absorb_percent = TUNING.ARMORLIMESTONE_ABSORPTION,
    },
    armor_metalplate = {
        atlas = hamletinventory,
        tex = "armor_metalplate.tex",
        bank = "armor_metalplate",
        build = "armor_metalplate",
        anim = "anim",
        armor = TUNING.ARMORMETAL,
        absorb_percent = TUNING.ARMORMETAL_ABSORPTION,
    },
    armorobsidian = {
        atlas = volcanoinventory,
        tex = "armorobsidian.tex",
        bank = "armor_obsidian",
        build = "armor_obsidian",
        anim = "anim",
        armor = TUNING.ARMORDRAGONFLY,
        absorb_percent = TUNING.ARMORDRAGONFLY_ABSORPTION,
    },
    armor_seashell = {
        atlas = volcanoinventory,
        tex = "armor_seashell.tex",
        bank = "armor_seashell",
        build = "armor_seashell",
        anim = "anim",
        armor = TUNING.ARMORSEASHELL,
        absorb_percent = TUNING.ARMORSEASHELL_ABSORPTION,
    },
    armor_snakeskin = {
        atlas = volcanoinventory,
        tex = "armor_snakeskin.tex",
        bank = "armor_snakeskin",
        build = "armor_snakeskin",
        anim = "anim",
        dapperness = TUNING.DAPPERNESS_SMALL,
        fueledtype1 = FUELTYPE.USAGE,
        fueledmax = TUNING.ARMOR_SNAKESKIN_FUEL,
        waterproofer = TUNING.WATERPROOFNESS_HUGE,
        insulator_type = "winter",
        insulator = TUNING.INSULATION_SMALL,
    },
    armorvoidcloak = {
        atlas = hamletinventory,
        tex = "armorvoidcloak.tex",
        bank = "armor_void_cloak",
        build = "armor_void_cloak",
        anim = "anim",
        armor = TUNING.ARMORVOIDCLOAK,
        absorb_percent = TUNING.ARMORVOIDCLOAK_ABSORPTION,
        fueledtype1 = FUELTYPE.NIGHTMARE,
        fueledtype2 = FUELTYPE.ANCIENT_REMNANT,
        fueledmax = TUNING.ARMORVOIDCLOAK_FUEL,
        armor_planardefense = TUNING.ARMOR_VOIDCLOTH_PLANAR_DEF,
        notes = { shadow_aligned = true },
    },
    armorvortexcloak = {
        atlas = hamletinventory,
        tex = "armorvortexcloak.tex",
        bank = "armor_vortex_cloak",
        build = "armor_vortex_cloak",
        anim = "anim",
        armor = TUNING.ARMORVORTEX,
        absorb_percent = TUNING.ARMORVORTEX_ABSORPTION,
        fueledtype1 = FUELTYPE.NIGHTMARE,
        fueledtype2 = FUELTYPE.ANCIENT_REMNANT,
        fueledmax = TUNING.ARMORVORTEXFUEL,
        notes = { shadow_aligned = true },
    },
    armor_weevole = {
        atlas = hamletinventory,
        tex = "armor_weevole.tex",
        bank = "armor_weevole",
        build = "armor_weevole",
        anim = "anim",
        armor = TUNING.ARMOR_WEEVOLE,
        absorb_percent = TUNING.ARMOR_WEEVOLE_ABSORPTION,
        waterproofer = TUNING.WATERPROOFNESS_MED,
    },
    armor_windbreaker = {
        atlas = hamletinventory,
        tex = "armor_windbreaker.tex",
        bank = "armor_windbreaker",
        build = "armor_windbreaker",
        anim = "anim",
        dapperness = TUNING.DAPPERNESS_SMALL,
        fueledtype1 = FUELTYPE.USAGE,
        fueledmax = TUNING.ARMOR_WINDBREAKER_FUEL,
        waterproofer = TUNING.WATERPROOFNESS_SMALL,
    },










    ------------------------------------------------------------------------------------------------


    mean_flytrap = {
        bank = "venus_flytrap",
        build = "venus_flytrap_sm_build",
        anim = "idle",
    },
    vine = {
        atlas = volcanoinventory,
        tex = "vine.tex",
        bank = "vine",
        build = "vine",
        anim = "idle",
    },
    venus_stalk = {
        atlas = volcanoinventory,
        tex = "venus_stalk.tex",
        bank = "stalk",
        build = "venus_stalk",
        anim = "idle",
    },
    nectar_pod = {
        atlas = hamletinventory,
        tex = "nectar_pod.tex",
        bank = "nectar_pod",
        build = "nectar_pod",
        anim = "idle",
    },
    aloe = {
        atlas = hamletinventory,
        tex = "aloe.tex",
        bank = "moded_seeds",
        build = "moded_seeds",
        anim = "aloe",
        foodtype = "VEGGIE",
    },
    ancient_remnant = {
        atlas = hamletinventory,
        tex = "ancient_remnant.tex",
        bank = "ancient_remnant",
        build = "ancient_remnant",
        anim = "idle",
    },

    living_artifact = {
        atlas = hamletinventory,
        tex = "living_artifact.tex",
        bank = "living_artifact",
        build = "living_artifact",
        anim = "idle",
    },
    pigcrownhat = {
        atlas = hamletinventory,
        tex = "pigcrownhat.tex",
        bank = "pigcrownhat",
        build = "hat_pigcrown",
        anim = "anim",
    },
    chitin = {
        atlas = hamletinventory,
        tex = "chitin.tex",
        bank = "chitin",
        build = "chitin",
        anim = "idle",
    }
})
