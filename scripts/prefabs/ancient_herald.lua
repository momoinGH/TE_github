local brain = require "brains/ancientheraldbrain"

local assets =
{
    Asset("ANIM", "anim/ancient_spirit.zip"),
}

local prefabs =
{
    "ancient_remnant",
    "nightmarefuel",
    "armorvortexcloak",
    "armorvortexcloak_blueprint",
}

local function CalcSanityAura(inst, observer)
    return inst.components.combat.target and -TUNING.SANITYAURA_HUGE or -TUNING.SANITYAURA_LARGE
end

local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
end

local function oncollide(inst, other)
    if not other:HasTag("tree") then return end

    local v1 = Vector3(inst.Physics:GetVelocity())
    if v1:LengthSq() < 1 then return end

    inst:DoTaskInTime(2 * FRAMES, function()
        if other and other.components.workable and other.components.workable.workleft > 0 then
            SpawnPrefab("collapse_small").Transform:SetPosition(other:GetPosition():Get())
            other.components.workable:Destroy(inst)
        end
    end)
end

SetSharedLootTable('ancientherald', {
    { 'ancient_remnant',            1.00 },
    { 'ancient_remnant',            1.00 },
    { 'ancient_remnant',            1.00 },
    { 'ancient_remnant',            1.00 },
    { 'ancient_remnant',            1.00 },
    { 'nightmarefuel',              1.00 },
    { 'nightmarefuel',              1.00 },
    { 'nightmarefuel',              0.33 },

    { 'armorvortexcloak_blueprint', 1 },
})

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(1.25, 1.25, 1.25)
    inst.Transform:SetSixFaced()

    MakeCharacterPhysics(inst, 1000, .5)

    inst:AddTag("epic")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("ancient")
    inst:AddTag("shadow")
    inst:AddTag("scarytoprey")
    inst:AddTag("largecreature")
    inst:AddTag("laser_immune")
    --    inst:AddTag("notarget")
    inst:AddTag("ancient_herald")

    inst.AnimState:SetBank("ancient_spirit")
    inst.AnimState:SetBuild("ancient_spirit")
    inst.AnimState:PlayAnimation("idle", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    ------------------------------------------

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = TUNING.GHOST_SPEED
    inst.components.locomotor.runspeed = TUNING.GHOST_SPEED
    --inst.components.locomotor.directdrive = true

    ------------------------------------------

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    ------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.ANCIENT_HERALD_HEALTH)

    ------------------

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.ANCIENT_HERALD_DAMAGE)
    inst.components.combat:SetAttackPeriod(2)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    ------------------------------------------

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('ancientherald')

    ------------------------------------------
    inst:SetStateGraph("SGancientherald")
    inst:SetBrain(brain)

    ------------------------------------------
    inst:AddComponent("inspectable")
    ------------------------------------------

    inst:ListenForEvent("attacked", OnAttacked)

    inst:AddComponent("knownlocations")

    inst:ListenForEvent("endaporkalypse", function()
        inst:Remove()
    end, TheWorld)

    -- TODO 似乎是技能冷却的，能用timer代替吗
    inst.summon_time = GetTime()
    inst.taunt_time = GetTime()

    return inst
end

return Prefab("ancient_herald", fn, assets, prefabs)
