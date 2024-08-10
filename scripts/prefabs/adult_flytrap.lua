local assets =
{
    Asset("ANIM", "anim/venus_flytrap_lg_build.zip"),
    Asset("ANIM", "anim/venus_flytrap_planted.zip"),
    Asset("SOUND", "sound/tentacle.fsb"),
    Asset("MINIMAP_IMAGE", "mean_flytrap"),
}

local prefabs =
{
    "mean_flytrap",
    "plantmeat",
    "venus_stalk",
    "vine",
    "nectar_pod",
}

SetSharedLootTable('adult_flytrap', {
    { 'plantmeat',   1.0 },
    { 'plantmeat',   0.5 },
    { 'vine',        1.0 },
    { 'vine',        0.5 },
    { 'venus_stalk', 1.0 },
    { 'nectar_pod',  1.0 },
    { 'nectar_pod',  0.3 },
})

local function grownplant(inst)
    local pt = inst:GetPosition()
    local angle = math.random() * 360
    local radius = 15
    local offset = FindWalkableOffset(pt, angle * DEGREES, radius, 20, true, false) -- try avoiding walls
    if offset then
        if #TheSim:FindEntities(pt.x, pt.y, pt.z, radius, { "flytrap" }) < 5 then
            local plant = SpawnPrefab("mean_flytrap")
            pt = pt + offset
            plant.Transform:SetPosition(pt.x, pt.y, pt.z)
            plant.sg:GoToState("enter")
            inst.sg:GoToState("taunt")
        end
    end

    inst:StartGrowTask()
end

local function StartGrowTask(inst, time)
    time = time or math.random() * TUNING.ADULT_FLYTRAP_GROW_TIME + TUNING.ADULT_FLYTRAP_GROW_TIME

    if inst.growtask then
        inst.growtask:Cancel()
    end
    inst.growtask, inst.growtaskinfo = inst:ResumeTask(time, grownplant)
end


local ATTACK_MUST_TAGS = { "_health", "_combat" }
local ATTACK_ONEOF_TAGS = { "character", "monster", "animal" }
local ATTACK_CANT_TAGS = { "flytrap", "plantkin", "playerghost", "INLIMBO" }
local function retargetfn(inst)
    return FindEntity(inst, TUNING.ADULT_FLYTRAP_ATTACK_DIST, function(guy)
        return not inst.components.combat:CanTarget(guy)
    end, ATTACK_MUST_TAGS, ATTACK_CANT_TAGS, ATTACK_ONEOF_TAGS)
end


local function shouldKeepTarget(inst, target)
    if target and target:IsValid() and target.components.health and not target.components.health:IsDead() then
        local distsq = target:GetDistanceSqToInst(inst)
        return distsq < TUNING.ADULT_FLYTRAP_STOPATTACK_DIST * TUNING.ADULT_FLYTRAP_STOPATTACK_DIST
    else
        return false
    end
end

local function onsave(inst, data)
    if inst.growtaskinfo then
        data.growtask = inst:TimeRemainingInTask(inst.growtaskinfo)
    end
    if inst:HasTag("spawned") then
        data.spawned = true
    end
end

local function onload(inst, data)
    if data then
        if data.growtask then
            StartGrowTask(inst, data.growtask)
        end
        if data.spawned then
            inst:AddTag("spawned")
        end
    end
end

local function onSpawn(inst)
    if not inst:HasTag("spawned") then
        inst.start_scale = 1.4
        inst.inc_scale = (1.8 - 1.4) / 5
        inst.sg:GoToState("grow")
        inst:AddTag("spawned")
    else
        inst.sg:GoToState("idle")
        inst.Transform:SetScale(1.8, 1.8, 1.8)
        inst.Transform:SetRotation(math.random(360))
    end
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddPhysics()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddMiniMapEntity()

    MakeObstaclePhysics(inst, .25)

    inst.Transform:SetFourFaced()

    inst.AnimState:Hide("root")
    inst.AnimState:Hide("leaf")
    inst.AnimState:SetBank("venus_flytrap_planted")
    inst.AnimState:SetBuild("venus_flytrap_lg_build")
    inst.AnimState:PlayAnimation("idle")

    inst.MiniMapEntity:SetIcon("mean_flytrap.png")

    inst:AddTag("character")
    inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("flytrap")
    inst:AddTag("hostile")
    inst:AddTag("animal")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.ADULT_FLYTRAP_HEALTH)

    inst:AddComponent("combat")
    inst.components.combat:SetRange(TUNING.ADULT_FLYTRAP_ATTACK_DIST)
    inst.components.combat:SetDefaultDamage(TUNING.ADULT_FLYTRAP_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.ADULT_FLYTRAP_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(GetRandomWithVariance(2, 0.5), retargetfn)
    inst.components.combat:SetKeepTargetFunction(shouldKeepTarget)

    MakeLargeFreezableCharacter(inst)
    MakeMediumBurnableCharacter(inst, "stem")

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('adult_flytrap')

    inst:SetStateGraph("SGadultflytrap")

    inst.StartGrowTask = StartGrowTask
    StartGrowTask(inst)
    inst.onSpawn = onSpawn

    inst:DoTaskInTime(0, onSpawn)

    inst.OnSave = onsave
    inst.OnLoad = onload

    inst:ListenForEvent("attacked", OnAttacked)

    return inst
end

return Prefab("adult_flytrap", fn, assets, prefabs)
