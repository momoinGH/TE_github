local tro_bird_utils = require "prefabs/tro_bird_utils"
local MakeBird = tro_bird_utils.MakeBird

local parrot_sounds = {
    takeoff = "dontstarve_DLC002/creatures/parrot/takeoff",
    chirp = "dontstarve_DLC002/creatures/parrot/chirp",
    flyin = "dontstarve/birds/flyin",
}

local parrot_pirate_sounds = {
    takeoff = "dontstarve_DLC002/creatures/parrot/takeoff",
    chirp = "dontstarve_DLC002/creatures/parrot/chirp",
    flyin = "dontstarve/birds/flyin",
}

local toucan_sounds = {
    takeoff = "dontstarve_DLC002/creatures/toucan/takeoff",
    chirp = "dontstarve_DLC002/creatures/toucan/chirp",
    flyin = "dontstarve/birds/flyin",
}

local seagull_sounds = {
    takeoff = "dontstarve_DLC002/creatures/seagull/takeoff_seagull",
    chirp = "dontstarve_DLC002/creatures/seagull/chirp_seagull",
    flyin = "dontstarve/birds/flyin",
}

local cormorant_sounds = {
    takeoff = "dontstarve_DLC003/creatures/king_fisher/take_off",
    chirp = "dontstarve_DLC003/creatures/king_fisher/chirp",
    flyin = "dontstarve/birds/flyin",
    land = "dontstarve_DLC002/creatures/cormorant/landwater",
}

-- parrot_pirate客户端设置
local function parrot_pirate_common(inst)
    inst:AddComponent("talker")
    inst.components.talker.fontsize = 28
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.colour = Vector3(.9, .4, .4, 1)
    inst:ListenForEvent("donetalking", function() inst.SoundEmitter:KillSound("talk") end)
    inst:ListenForEvent("ontalk", function()
        inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/parrot/chirp", "talk")
    end)
end

-- parrot_pirate服务端设置
local function parrot_pirate_master(inst)
    inst.components.inspectable.nameoverride = "PARROT"
    inst.components.health.canmurder = false

    inst:AddComponent("named")
    inst.components.named.possiblenames = STRINGS.PARROTNAMES
    inst.components.named:PickNewName()

    inst:AddComponent("talkingbird")

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = TUNING.SANITYAURA_SMALL

    -- 覆盖掉落物
    inst.components.lootdropper:SetLoot({})
    inst.components.lootdropper:AddRandomLoot("feather_robin", 1)
    inst.components.lootdropper:AddRandomLoot("smallmeat", 1)
    inst.components.lootdropper.numrandomloot = 1

    -- 覆盖周期生成物
    inst.components.periodicspawner:SetPrefab("dubloon")
end

return MakeBird("parrot", {
        sounds = parrot_sounds,
        feather_name = "robin",
    }),
    MakeBird("parrot_pirate", {
        sounds = parrot_pirate_sounds,
        feather_name = "robin",
    }, parrot_pirate_common, parrot_pirate_master),
    MakeBird("toucan", {
        sounds = toucan_sounds,
        feather_name = "crow",
    }),
    MakeBird("cormorant", {
        sounds = cormorant_sounds,
        feather_name = "crow",
        bank = "seagull",
        water_bank = "cormorant_water",
        eater_diet = { FOODGROUP.OMNI },
        eater_candiet = { FOODGROUP.OMNI },
    }, nil, function(inst)
        inst.Transform:SetScale(0.85, 0.85, 0.85)
        inst.components.periodicspawner:SetPrefab(function(inst)
            return math.random() < 0.1 and "roe" or "seeds"
        end)
    end),
    MakeBird("seagull", {
        sounds = seagull_sounds,
        feather_name = "robin_winter",
        bank = "seagull",
        water_bank = "cormorant_water",
        eater_diet = { FOODGROUP.OMNI },
        eater_candiet = { FOODGROUP.OMNI },
    })
