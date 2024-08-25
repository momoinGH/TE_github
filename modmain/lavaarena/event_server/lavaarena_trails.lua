local assets =
{
    Asset("ANIM", "anim/lavaarena_trails_basic.zip"),
    Asset("ANIM", "anim/fossilized.zip"),
}

local targetDist = TUNING.SPIKY_MONKEY_TFC.TARGET_DIST
local keepDistSq = TUNING.SPIKY_MONKEY_TFC.KEEP_TARGET_DIST * TUNING.SPIKY_MONKEY_TFC.KEEP_TARGET_DIST
local slamRadius = TUNING.SPIKY_MONKEY_TFC.SLAM_RADIUS
local slamDamage = TUNING.SPIKY_MONKEY_TFC.SLAM_DAMAGE

local function Retarget(inst)
    local player = GetClosestInstWithTag("player", inst, 70)
    if player and not inst:HasTag("nohat") then return player end

    return FindEntity(inst, targetDist, function(guy)
        return inst.components.combat:CanTarget(guy)
    end, { "monster" }, { "FX", "NOCLICK", "INLIMBO" })
end

local function OnAttacked(inst, data)
    if data.attacker == nil and inst.components.combat:CanTarget(data.attacker) then
        return
    end

    inst.components.combat:SetTarget(data.attacker)
end

local function SlamAttack(inst)
    local notags = { "shadow", "playerghost", "INLIMBO", "NOCLICK", "FX" }
    local x, y, z = inst.Transform:GetWorldPosition()
    for _, v in pairs(TheSim:FindEntities(x, y, z, slamRadius, { "_combat" }, notags)) do
        if v ~= inst
            and v:IsValid()
            and v.entity:IsVisible()
            and v.components.combat ~= nil
        then
            v.components.combat:GetAttacked(inst, slamDamage)
            if v:HasTag("player") then
                v.sg:GoToState("knockback", { knocker = inst, radius = 5 })
            end
        end
    end
    inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/turtillus/grunt")
    inst.components.combat.laststartattacktime = GetTime()
    inst.lastTimeSlam = GetTime()
end

local brain = require "brains/trailsbrain"

local function master_postinit(inst)
    inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = TUNING.SPIKY_MONKEY_TFC.SPEED

    inst:SetStateGraph("SGtrails")
    inst:SetBrain(brain)

    inst:AddComponent("knownlocations")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.SPIKY_MONKEY_TFC.HEALTH)

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.SPIKY_MONKEY_TFC.DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.SPIKY_MONKEY_TFC.ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(5, Retarget)
    inst.components.combat:SetRange(TUNING.SPIKY_MONKEY_TFC.ATTACK_RANGE)
    inst.components.combat.battlecryenabled = true

    inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
    inst:AddComponent("inventory")

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater:SetCanEatRaw()
    inst.components.eater.strongstomach = true

    inst:AddComponent("sleeper")

    MakeMediumFreezableCharacter(inst, "body")
    MakeMediumBurnableCharacter(inst, "body")

    inst.lastTimeSlam = GetTime()

    inst.SlamAttack = SlamAttack

    inst:ListenForEvent("attacked", OnAttacked)
end

add_event_server_data("lavaarena", "prefabs/lavaarena_trails", {
    master_postinit = master_postinit,
}, assets)
