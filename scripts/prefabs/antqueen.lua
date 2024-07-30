require "brains/antqueenbrain"
require "stategraphs/SGantqueen"

local assets =
{
    --Asset("ANIM", "anim/perd_basic.zip"),
    Asset("ANIM", "anim/crickant_queen_basics.zip"),
}

local prefabs =
{
    "antman_warrior",
    "antman_warrior_egg",
    "warningshadow",
    "throne_wall_large",
    "throne_wall",
    "pigcrownhat",
    "royal_jelly",
    "chitin",
    "honey",
}

local loot =
{
    "pigcrownhat",
    "royal_jelly",
    "royal_jelly",
    "royal_jelly",
    "royal_jelly",
    "royal_jelly",
    "royal_jelly",
    "chitin",
    "chitin",
    "chitin",
    "chitin",
    "honey",
    "honey",
    "honey",
    "honey",
    "honey",
    "honeychest_blueprint",
    --"bundlewrap_blueprint",
}

local brain = require "brains/antqueenbrain"

local spawn_positions =
{
    { x = 6, z = -6 },
    { x = 6, z = 6 },
    { x = 6, z = 0 },
}

local function SpawnWarrior(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local random_offset = spawn_positions[math.random(1, #spawn_positions)]

    x = x + random_offset.x + math.random(-1.5, 1.5)
    y = 35
    z = z + random_offset.z + math.random(-1.5, 1.5)

    local egg = SpawnPrefab("antman_warrior_egg")
    egg.queen = inst
    egg.Physics:Teleport(x, y, z)

    egg.start_grounddetection(egg)

    local shadow = SpawnPrefab("warningshadow")
    shadow.Transform:SetPosition(x, 0.2, z)
    shadow:shrink(1.5, 1.5, 0.25)

    --    inst.warrior_count = inst.warrior_count + 1
end

local function WarriorKilled(inst)
    local invader = GetClosestInstWithTag("antmanwarrior", inst, 12)
    --    inst.warrior_count = inst.warrior_count - 1
    if not invader then
        if inst.components.combat then
            inst.components.combat.canattack = true
        end
        --        inst.warrior_count = 0
    end
end

local function OnAttacked(inst, data)
    if inst.components.combat and inst.components.combat.target == nil then
        inst.components.combat.target = data.attacker
        inst.sg:GoToState("wake")
    end

    local attacker = data.attacker
    local x, y, z = inst.Transform:GetWorldPosition()
    local eles = TheSim:FindEntities(x, y, z, 30, { "ant" })
    if attacker then
        for k, guardas in pairs(eles) do
            if guardas.components.combat and guardas.components.combat.target == nil then
                guardas.components.combat
                    :SetTarget(attacker)
            end
        end
    end
end

local function NormalShouldSleep(inst)
    return false
end

local PHASES = { {
    hp = 0.75,
    fn = function(inst)
        inst.summon_count = 4
        inst.min_combat_cooldown = 3
        inst.max_combat_cooldown = 5
    end
}, {
    hp = 0.5,
    fn = function(inst)
        inst.max_sanity_attack_count = 3
        inst.max_jump_attack_count = 3
        inst.min_combat_cooldown = 1
        inst.max_combat_cooldown = 3
    end
}, {
    hp = 0.25,
    function(inst)
        inst.min_combat_cooldown = 1
        inst.max_combat_cooldown = 1
    end
} }

local function OnLoad(inst, data)
    local healthpct = inst.components.health:GetPercent()
    for _, v in ipairs(PHASES) do
        if healthpct <= v.hp then
            v.fn(inst)
        end
    end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    inst.entity:AddNetwork()

    inst.Transform:SetScale(0.9, 0.9, 0.9)

    MakeObstaclePhysics(inst, 2)
    --    MakePoisonableCharacter(inst)

    inst.AnimState:SetBank("crick_crickantqueen")
    inst.AnimState:SetBuild("crickant_queen_basics")
    inst.AnimState:AddOverrideBuild("throne")

    inst:AddTag("antqueen")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- Used in SGantqueen
    inst.jump_count = 1
    inst.jump_attack_count = 0
    inst.max_jump_attack_count = 3
    inst.sanity_attack_count = 0
    inst.max_sanity_attack_count = 2
    inst.summon_count = 3
    inst.current_summon_count = 0
    inst.min_combat_cooldown = 5
    inst.max_combat_cooldown = 7

    inst:AddComponent("locomotor")

    inst:AddComponent("sleeper")
    inst.components.sleeper.onlysleepsfromitems = true
    inst.components.sleeper:SetSleepTest(NormalShouldSleep)

    inst:AddComponent("combat")
    inst.components.combat.canattack = false

    inst:AddComponent("healthtrigger")
    for _, v in ipairs(PHASES) do
        inst.components.healthtrigger:AddTrigger(v.hp, v.fn)
    end

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.ANTQUEEN_HEALTH)
    inst.components.health:StartRegen(1, 4)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)

    inst:AddComponent("inspectable")

    MakeLargeFreezableCharacter(inst, "pig_torso")

    --    inst.warrior_count = 0
    inst.SpawnWarrior = SpawnWarrior
    inst.WarriorKilled = WarriorKilled


    inst:SetStateGraph("SGantqueen")

    inst:SetBrain(brain)

    inst:ListenForEvent("attacked", OnAttacked)

    inst.OnLoad = OnLoad

    return inst
end

local function make_throne_fn(size)
    return function()
        local inst = CreateEntity()
        inst.entity:AddTransform()

        inst:AddTag("throne_wall")
        MakeObstaclePhysics(inst, size)

        return inst
    end
end

local function makethronewall(name, physics_size, assets, prefabs)
    return Prefab("common/objects/" .. name, make_throne_fn(physics_size), assets, prefabs)
end

local respawndays = 80 --revive em 8 dias

local function OnTimerDone(inst, data)
    if data.name == "spawndelay" then
        ReplacePrefab(inst, "antqueen")
    end
end


local function fnrespawnquenn()
    local inst = CreateEntity()

    if not TheWorld.ismastersim then
        --Not meant for client!
        inst:DoTaskInTime(0, inst.Remove)
        return inst
    end

    inst.entity:AddTransform()
    inst:AddTag("CLASSIFIED")

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("spawndelay", 60 * 8 * respawndays)

    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("common/monsters/antqueen", fn, assets, prefabs),
    makethronewall("throne_wall", 0.25, assets, prefabs),
    makethronewall("throne_wall_large", 0.5, assets, prefabs),
    Prefab("antqueen_spawner", fnrespawnquenn, nil, prefabs)
