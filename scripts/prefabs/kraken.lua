local assets =
{
    Asset("ANIM", "anim/quacken.zip"),
    Asset("MINIMAP_IMAGE", "quacken"),
}

local prefabs =
{
    "kraken_tentacle",
    "kraken_projectile",
    "krakenchest",
}

SetSharedLootTable('kraken', {
    { "piratepack", 1.00 },
})

local MIN_HEALTH =
{
    0.80,
    0.60,
    0.40,
    0.20,
    0.10,
    -1.0,
}

local max_health = 1000 * TUNING.tropical.bosslife

-- 移动到新的位置
local function MoveToNewSpot(inst)
    local pos = inst:GetPosition()
    local offset = FindSwimmableOffset(pos, math.pi * 2 * math.random(), 40, 30)
    local new_pos = pos + offset
    inst:PushEvent("move", { pos = new_pos })
end

local function OnMinHealth(inst, data)
    if not inst.components.health:IsDead() then
        inst.health_stage = inst.health_stage + 1
        inst.health_stage = math.min(inst.health_stage, #MIN_HEALTH)
        inst.components.health:SetMinHealth(max_health * MIN_HEALTH[inst.health_stage])
        MoveToNewSpot(inst)
    end
end

local RND_OFFSET = 10

local function OnAttack(inst, data)
    local numshots = 3
    if data and data.target then
        local pos = data.target:GetPosition()
        for i = 1, numshots do
            local offset = Vector3(math.random(-RND_OFFSET, RND_OFFSET), math.random(-RND_OFFSET, RND_OFFSET), math.random(-RND_OFFSET, RND_OFFSET))
            local ent = SpawnAt("kraken_projectile", pos)
            ent.components.complexprojectile:Launch(pos + offset, inst)
        end
    end
end

local function Retarget(inst)
    return FindEntity(inst, 40, function(guy)
        return inst.components.combat:CanTarget(guy)
    end, nil, { "prey" }, { "character", "monster", "animal" })
end

local function ShouldKeepTarget(inst, target)
    if target and target:IsValid() and target.components.health and not target.components.health:IsDead() then
        local distsq = target:GetDistanceSqToInst(inst)
        return distsq < 1600
    else
        return false
    end
end

local function SpawnChest(inst)
    inst:DoTaskInTime(3, function()
        inst.SoundEmitter:PlaySound("dontstarve/common/ghost_spawn")

        local chest = SpawnPrefab("krakenchest")
        local pos = inst:GetPosition()
        chest.Transform:SetPosition(pos.x, 0, pos.z)

        SpawnAt("statue_transition_2", inst)
        SpawnAt("statue_transition", inst)

        chest:AddComponent("scenariorunner")
        chest.components.scenariorunner:SetScript("chest_kraken")
        chest.components.scenariorunner:Run()
    end)
end

local function OnRemove(inst)
    inst.components.minionspawner:DespawnAll()
end

local function OnSave(inst, data)
    data.health_stage = inst.health_stage
    data.revelado = inst.revelado
end

local function OnLoad(inst, data)
    if data and data.health_stage then
        inst.health_stage = data.health_stage or inst.health_stage
        inst.components.health:SetMinHealth(max_health * MIN_HEALTH[inst.health_stage])
    end

    if data and data.revelado then
        inst.revelado = data.revelado
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    local minimap = inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("quacken")
    inst.AnimState:SetBuild("quacken")
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst:AddTag("kraken")
    inst:AddTag("nowaves")
    inst:AddTag("epic")
    inst:AddTag("noteleport")
    inst:AddTag("mudacamada")

    MakeCharacterPhysics(inst, 1000, 1)

    minimap:SetIcon("quacken.png")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.health_stage = 1

    inst:AddComponent("inspectable")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(max_health)
    inst.components.health.nofadeout = true
    inst.components.health:SetMinHealth(max_health * MIN_HEALTH[inst.health_stage])

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(0)
    inst.components.combat:SetAttackPeriod(7.5)
    inst.components.combat:SetRange(40, 50)
    inst.components.combat:SetRetargetFunction(1, Retarget)
    inst.components.combat:SetKeepTargetFunction(ShouldKeepTarget)

    inst:AddComponent("sanityaura")
    inst:AddComponent("locomotor")

    inst:AddComponent("minionspawner")
    inst.components.minionspawner.validtiletypes = {
        [WORLD_TILES.OCEAN_COASTAL] = true,
        [WORLD_TILES.OCEAN_WATERLOG] = true,
        [WORLD_TILES.OCEAN_COASTAL_SHORE] = true,
        [WORLD_TILES.OCEAN_SWELL] = true,
        [WORLD_TILES.OCEAN_ROUGH] = true,
        [WORLD_TILES.OCEAN_BRINEPOOL] = true,
        [WORLD_TILES.OCEAN_BRINEPOOL_SHORE] = true,
        [WORLD_TILES.OCEAN_HAZARDOUS] = true,
    }
    inst.components.minionspawner.miniontype = "kraken_tentacle"
    inst.components.minionspawner.distancemodifier = 35
    inst.components.minionspawner.maxminions = 35
    inst.components.minionspawner:RegenerateFreePositions()
    inst.components.minionspawner.shouldspawn = false

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('kraken')

    inst:SetStateGraph("SGkraken")
    local brain = require("brains/krakenbrain")
    inst:SetBrain(brain)

    inst:ListenForEvent("minhealth", OnMinHealth)
    inst:ListenForEvent("death", SpawnChest)
    inst:ListenForEvent("onattackother", OnAttack)
    inst:ListenForEvent("onremove", OnRemove)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("kraken", fn, assets, prefabs)
