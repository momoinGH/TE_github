local brain = require "brains/birdbrain"

local function ShouldSleep(inst)
    return DefaultSleepTest(inst) and not inst.sg:HasStateTag("flight")
end

local BIRD_TAGS = { "bird" }
local function OnAttacked(inst, data)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 30, BIRD_TAGS)
    local num_friends = 0
    local maxnum = 5
    for _, v in pairs(ents) do
        if v ~= inst then
            v:PushEvent("gohome")
            num_friends = num_friends + 1
        end
        if num_friends > maxnum then
            return
        end
    end
end

local function OnTrapped(inst, data)
    if data and data.trapper and data.trapper.settrapsymbols then
        data.trapper.settrapsymbols(inst.trappedbuild)
    end
end

local function OnPutInInventory(inst)
    inst.sg:GoToState("idle")
end

local function OnDropped(inst)
    inst.sg:GoToState("stunned")
end

local function ChooseItem()
    local mercy_items = { "flint", "flint", "flint", "twigs", "twigs", "cutgrass" }
    return mercy_items[math.random(#mercy_items)]
end

local function ChooseSeeds()
    return not TheWorld.state.iswinter and "seeds" or nil
end

local function SpawnPrefabChooser(inst)
    if TheWorld.state.cycles <= 3 then
        return ChooseSeeds()
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    local players = FindPlayersInRange(x, y, z, 20, true)

    local oldestplayer = -1
    for i, player in ipairs(players) do
        if player.components.age ~= nil then
            local playerage = player.components.age:GetAgeInDays()
            if playerage > oldestplayer then
                oldestplayer = playerage
            end
        end
    end

    if oldestplayer >= 3 then
        local year = TheWorld.state.autumnlength + TheWorld.state.winterlength + TheWorld.state.springlength + TheWorld.state.summerlength
        if oldestplayer <= TheWorld.state.autumnlength then
            return ChooseSeeds()
        elseif oldestplayer <= year then
            return math.random() <= GetEntitiesLuckChance(players, TUNING.BIRD_DROP_SEEDS_CHANCE_ONEYEAR, LuckFormulas.BirdDropItem) and ChooseSeeds() or nil
        else
            return math.random() <= GetEntitiesLuckChance(players, TUNING.BIRD_DROP_SEEDS_CHANCE_PASTONEYEAR, LuckFormulas.BirdDropItem) and ChooseSeeds() or nil
        end
    end

    return oldestplayer >= 0
        and math.random() <= GetEntitiesLuckChance(players, TUNING.BIRD_DROP_ITEM_BASE_CHANCE - oldestplayer * .1, LuckFormulas.BirdDropItem)
        and ChooseItem()
        or ChooseSeeds()
end

---创建鸟类
---data参数：
---assets 额外资源（可选，会追加默认资源）
---sounds 音效表
---feather_name 羽毛名称（默认name）
---bank 动画bank（默认"crow"）
---water_bank 水中动画bank（可选）
---eater_diet 饮食类型（默认{FOODTYPE.SEEDS}）
---eater_candiet 可食类型（默认{FOODTYPE.SEEDS}）
local function MakeBird(name, data, common_post, master_post)
    data = data or {}

    local sounds = data.sounds or {
        takeoff = "dontstarve/birds/takeoff",
        chirp = "dontstarve/birds/chirp",
        flyin = "dontstarve/birds/flyin",
        death = "dontstarve/birds/death",
    }
    local feather_name = data.feather_name or name
    local bank = data.bank or "crow"
    local water_bank = data.water_bank

    local assets = {
        Asset("ANIM", "anim/crow.zip"),
        Asset("ANIM", "anim/" .. name .. "_build.zip"),
        Asset("SOUND", "sound/birds.fsb"),
    }

    if data.assets then
        table.troinserttable(assets, data.assets)
    else
        if bank ~= "crow" then
            table.insert(assets, Asset("ANIM", "anim/" .. bank .. ".zip"))
        end
        if water_bank ~= nil then
            table.insert(assets, Asset("ANIM", "anim/" .. water_bank .. ".zip"))
        end
    end

    local prefabs = {
        "seeds",
        "smallmeat",
        "cookedsmallmeat",
        "feather_" .. feather_name,
        "feather_crow",
        "birdcorpse",
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddPhysics()
        inst.entity:AddAnimState()
        inst.entity:AddDynamicShadow()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
        if water_bank ~= nil then
            inst.Physics:SetCollisionMask(COLLISION.GROUND)
        else
            inst.Physics:SetCollisionMask(COLLISION.WORLD)
        end
        inst.Physics:SetMass(1)
        inst.Physics:SetSphere(1)

        inst:AddTag("bird")
        inst:AddTag(name)
        inst:AddTag("smallcreature")
        inst:AddTag("likewateroffducksback")
        inst:AddTag("stunnedbybomb")
        inst:AddTag("noember")
        inst:AddTag("cookable")

        inst.Transform:SetTwoFaced()

        inst.AnimState:SetBank(bank)
        inst.AnimState:SetBuild(name .. "_build")
        inst.AnimState:PlayAnimation("idle")

        inst.DynamicShadow:SetSize(1, .75)
        inst.DynamicShadow:Enable(false)

        MakeFeedableSmallLivestockPristine(inst)

        if water_bank ~= nil then
            MakeInventoryFloatable(inst, nil, .07)
        end

        if common_post then
            common_post(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.lunar_mutation_chance = TUNING.BIRD_PRERIFT_MUTATION_SPAWN_CHANCE
        inst.gestalt_possession_chance = TUNING.BIRD_RIFT_POSSESSION_SPAWN_CHANCE

        inst.sounds = sounds
        inst.trappedbuild = name .. "_build"

        inst.spawn_lunar_mutated_tuning = "SPAWN_MUTATED_BIRDS"
        inst.spawn_gestalt_mutated_tuning = "SPAWN_MUTATED_BIRDS_GESTALT"

        inst:AddComponent("locomotor")
        inst.components.locomotor:EnableGroundSpeedMultiplier(false)
        inst.components.locomotor:SetTriggersCreep(false)
        inst:SetStateGraph("SGbird")

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:AddRandomLoot("feather_" .. feather_name, 1)
        inst.components.lootdropper:AddRandomLoot("smallmeat", 1)
        inst.components.lootdropper.numrandomloot = 1

        inst:AddComponent("occupier")

        inst:AddComponent("eater")
        local diet = data.eater_diet or { FOODTYPE.SEEDS }
        local candiet = data.eater_candiet or { FOODTYPE.SEEDS }
        inst.components.eater:SetDiet(diet, candiet)

        inst:AddComponent("halloweenmoonmutable")
        inst.components.halloweenmoonmutable:SetPrefabMutated(function()
            return math.random() < 0.8 and "bird_mutant" or "bird_mutant_spitter"
        end)

        inst:AddComponent("sleeper")
        inst.components.sleeper.watchlight = true
        inst.components.sleeper:SetSleepTest(ShouldSleep)

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.nobounce = true
        inst.components.inventoryitem.canbepickedup = false
        inst.components.inventoryitem.canbepickedupalive = true
        if water_bank == nil then
            inst.components.inventoryitem:SetSinks(true)
        end

        inst:AddComponent("cookable")
        inst.components.cookable.product = "cookedsmallmeat"

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(TUNING.BIRD_HEALTH)
        inst.components.health.murdersound = "dontstarve/wilson/hit_animal"

        inst:AddComponent("inspectable")

        if water_bank ~= nil then
            inst.flyawaydistance = TUNING.WATERBIRD_SEE_THREAT_DISTANCE
        else
            inst.flyawaydistance = TUNING.BIRD_SEE_THREAT_DISTANCE
        end

        inst:AddComponent("combat")
        inst.components.combat.hiteffectsymbol = "crow_body"

        MakeSmallBurnableCharacter(inst, "crow_body")
        MakeTinyFreezableCharacter(inst, "crow_body")

        inst:SetBrain(brain)

        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
        inst.components.hauntable.panicable = true

        inst:AddComponent("periodicspawner")
        inst.components.periodicspawner:SetPrefab("seeds")
        inst.components.periodicspawner:SetDensityInRange(20, 2)
        inst.components.periodicspawner:SetMinimumSpacing(8)

        inst:ListenForEvent("ontrapped", OnTrapped)
        inst:ListenForEvent("attacked", OnAttacked)

        local birdspawner = TheWorld.components.birdspawner
        if birdspawner ~= nil then
            inst:ListenForEvent("onremove", birdspawner.StopTrackingFn)
            inst:ListenForEvent("enterlimbo", birdspawner.StopTrackingFn)
            inst:ListenForEvent("death", birdspawner.StopTrackingFn)
            birdspawner:StartTracking(inst)
        end

        MakeFeedableSmallLivestock(inst, TUNING.BIRD_PERISH_TIME, OnPutInInventory, OnDropped)

        if water_bank ~= nil then
            inst:ListenForEvent("floater_startfloating", function(inst) inst.AnimState:SetBank(water_bank) end)
            inst:ListenForEvent("floater_stopfloating", function(inst) inst.AnimState:SetBank(bank) end)
        end

        if master_post then
            master_post(inst)
        end

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

return {
    MakeBird = MakeBird,
    SpawnPrefabChooser = SpawnPrefabChooser,
}
