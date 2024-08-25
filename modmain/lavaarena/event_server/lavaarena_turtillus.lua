local assets =
{
    Asset("ANIM", "anim/lavaarena_turtillus_basic.zip"),
    Asset("ANIM", "anim/fossilized.zip"),
}

local targetDist = TUNING.SPIKY_TURTLE_TFC.TARGET_DIST
local keepTargetDistSq = TUNING.SPIKY_TURTLE_TFC.KEEPDIST * TUNING.SPIKY_TURTLE_TFC.KEEPDIST

local function OnNewTarget(inst, data)
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local function OnTimerDone(inst, data)
    if data ~= nil and data.name == "slide" then
        inst.canSlide = true
    end
end

local function retargetfn(inst)
    local player = GetClosestInstWithTag("player", inst, 70)
    if player and not inst:HasTag("nohat") then return player end

    local notags = { "player", "smallcreature", "FX", "NOCLICK", "INLIMBO", "wall", "turtle", "structure" }
    return FindEntity(inst, targetDist, function(guy)
        return inst.components.combat:CanTarget(guy)
    end, nil, notags)
end

local function KeepTarget(inst, target)
    return inst.components.combat:CanTarget(target) and inst:GetDistanceSqToInst(target) <= (keepTargetDistSq)
end

local function OnAttacked(inst, data)
    if not inst.components.timer:TimerExists("slide")
        and not inst.canSlide
        and not inst.sg:HasStateTag("slide")
    then
        inst.components.timer:StartTimer("slide", 15)
    end
    inst.components.combat:SetTarget(data.attacker)
    --inst.components.combat:ShareTarget(data.attacker, TUNING.CCW.SNAKE.SHARE_TARGET_DIST, function(dude) return dude:HasTag("snake") and not dude.components.health:IsDead() end, 5)
end

local function SlideTask(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local notags = { "turtle", "shadow", "playerghost", "INLIMBO", "NOCLICK", "FX" }
    local damage = TUNING.SPIKY_TURTLE_TFC.SLIDEDAMAGE
    for _, v in pairs(TheSim:FindEntities(x, y, z, TUNING.SPIKY_TURTLE_TFC.SLIDE_RADIUS, { "_combat" }, notags)) do
        if v ~= inst
            and v:IsValid()
            and v.entity:IsVisible()
            and v.components.combat ~= nil
            and not table.contains(inst.slidehitted, v)
        then
            table.insert(inst.slidehitted, v)
            v.components.combat:GetAttacked(inst, damage)
        end
    end
end

local function GetDebugString(inst)
    return string.format("can slide: %s", tostring(inst.canSlide))
end

local brain = require "brains/turtillusbrain"

local function master_postinit(inst)
    inst:AddComponent("knownlocations")

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = TUNING.SPIKY_TURTLE_TFC.WALKSPEED

    inst:SetStateGraph("SGturtillus")
    inst:SetBrain(brain)

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })
    inst.components.eater:SetCanEatHorrible(false)

    --inst.components.eater.strongstomach = true -- can eat monster meat!

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.SPIKY_TURTLE_TFC.HEALTH)

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.SPIKY_TURTLE_TFC.DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.SPIKY_TURTLE_TFC.ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, retargetfn)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst.components.combat:SetRange(TUNING.SPIKY_TURTLE_TFC.RANGE)

    inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetNocturnal(false)

    inst:AddComponent("timer")

    inst.SlideTask = SlideTask

    inst.canSlide = false
    inst.slides = 0
    inst.slidehitted = {}

    inst:ListenForEvent("attacked", OnAttacked)
    --inst:ListenForEvent("onattackother", OnAttackOther)
    inst:ListenForEvent("newcombattarget", OnNewTarget)
    inst:ListenForEvent("timerdone", OnTimerDone)

    MakeLargeFreezableCharacter(inst, "body")
    MakeMediumBurnableCharacter(inst, "body")

    inst.debugstringfn = GetDebugString
end

add_event_server_data("lavaarena", "prefabs/lavaarena_turtillus", {
    master_postinit = master_postinit
}, assets)
