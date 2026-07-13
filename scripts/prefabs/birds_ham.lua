local tro_bird_utils = require "prefabs/tro_bird_utils"
local MakeBird = tro_bird_utils.MakeBird

local toucan_hamlet_sounds = {
    takeoff = "dontstarve_DLC002/creatures/toucan/takeoff",
    chirp = "dontstarve_DLC002/creatures/toucan/chirp",
    flyin = "dontstarve/birds/flyin",
}

local pigeon_sounds = {
    takeoff = "dontstarve_DLC003/creatures/pigeon/takeoff",
    chirp = "dontstarve_DLC003/creatures/pigeon/chirp",
    flyin = "dontstarve/birds/flyin",
}

local parrot_blue_sounds = {
    takeoff = "dontstarve_DLC002/creatures/parrot/takeoff",
    chirp = "dontstarve_DLC002/creatures/parrot/chirp",
    flyin = "dontstarve/birds/flyin",
}

local kingfisher_sounds = {
    takeoff = "dontstarve_DLC003/creatures/king_fisher/take_off",
    chirp = "dontstarve_DLC003/creatures/king_fisher/chirp",
    flyin = "dontstarve/birds/flyin",
}

return MakeBird("toucan_hamlet", {
        sounds = toucan_hamlet_sounds,
        feather_name = "robin",
    }),
    MakeBird("pigeon", {
        sounds = pigeon_sounds,
        feather_name = "robin_winter",
    }),
    MakeBird("parrot_blue", {
        sounds = parrot_blue_sounds,
        feather_name = "robin_winter",
    }, nil, function(inst)
        -- 覆盖周期生成物
        inst.components.periodicspawner:SetPrefab("oinc")
    end),
    MakeBird("kingfisher", {
        assets = {},
        sounds = kingfisher_sounds,
        feather_name = "robin_winter",
        water_bank = "cormorant_water",
        eater_diet = { FOODTYPE.SEEDS },
        eater_candiet = { FOODTYPE.MEAT },
    }, nil, function(inst)
        inst.components.periodicspawner:SetPrefab(function(inst)
            return math.random() < 0.1 and "coi" or "seeds"
        end)
    end)
