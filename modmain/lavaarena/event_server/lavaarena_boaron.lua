local assets =
{
    Asset("ANIM", "anim/lavaarena_boaron_basic.zip"),
    Asset("ANIM", "anim/fossilized.zip"),
}

local keepDistSq = TUNING.HATTY_PIGGY_TFC.KEEPDIST * TUNING.HATTY_PIGGY_TFC.KEEPDIST
local shareDist = TUNING.HATTY_PIGGY_TFC.SHARE_DIST
local targetDist = TUNING.SPIKY_TURTLE_TFC.TARGET_DIST

local function OnNewTarget(inst, data)
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local function retargetfn2(inst)
    local player = GetClosestInstWithTag("player", inst, 10)
    if player then return inst.components.combat:SetTarget(player) end
    local notags = { "player", "smallcreature", "FX", "NOCLICK", "INLIMBO" }
    return FindEntity(inst, targetDist, function(guy)
        return inst.components.combat:CanTarget(guy)
    end, { "monster" }, notags)
end

local function KeepTarget(inst, target)
    return inst.components.combat:CanTarget(target) and inst:GetDistanceSqToInst(target) <= (keepDistSq)
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, shareDist,
        function(dude) return dude:HasTag("piggy") and not dude.components.health:IsDead() end, 2)
end

local function SetNoHat(inst)
    inst.AnimState:OverrideSymbol("helmet", "lavaarena_boaron_basic", "")
    inst.AnimState:Hide("hat")

    inst:AddTag("nohat")
end

local function master_postinit(inst)
    inst.SetNoHat = SetNoHat
    inst.chargeLastTime = GetTime()

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = TUNING.HATTY_PIGGY_TFC.RUNSPEED

    -- boat hopping setup
    inst.components.locomotor:SetAllowPlatformHopping(true)
    inst:AddComponent("embarker")

    inst:SetStateGraph("SGhattypiggy_tfc")
    inst:SetBrain(require "brains/hattypiggy_tfcbrain")

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })
    inst.components.eater:SetCanEatHorrible(false)

    --inst.components.eater.strongstomach = true -- can eat monster meat!

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.HATTY_PIGGY_TFC.HEALTH)

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.HATTY_PIGGY_TFC.DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.HATTY_PIGGY_TFC.ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, retargetfn2)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst.components.combat:SetRange(TUNING.HATTY_PIGGY_TFC.RANGE)

    inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
    inst:AddComponent("knownlocations")

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetNocturnal(false)

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("newcombattarget", OnNewTarget)

    MakeLargeFreezableCharacter(inst, "body")
    MakeMediumBurnableCharacter(inst, "body")
end

add_event_server_data("lavaarena", "prefabs/lavaarena_boaron", {
    master_postinit = master_postinit,
}, assets)
