local assets =
{
    Asset("ANIM", "anim/frog_yellow_build.zip"),
}

local prefabs =
{
    "venomgland",
    "froglegs",
    "frogsplash",
}

local brain = require "brains/poisonfrogbrain"

local function retargetfn(inst)
    if not inst.components.health:IsDead() and not inst.components.sleeper:IsAsleep() then
        return FindEntity(inst, TUNING.FROG_TARGET_DIST, function(guy)
                if not guy.components.health:IsDead() then
                    return guy.components.inventory ~= nil
                end
            end,
            { "_combat", "_health" } -- see entityreplica.lua
        )
    end
end

local function ShouldSleep(inst)
    return false -- frogs either go to their home, or just sit on the ground.
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30,
        function(dude) return dude:HasTag("frog") and not dude.components.health:IsDead() end, 5)
end

local function OnGoingHome(inst)
    SpawnPrefab("frogsplash").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function OnHitOther(inst, other, damage)
    inst.components.thief:StealItem(other)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 1, .3)

    inst.DynamicShadow:SetSize(1.5, .75)
    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("frog")
    inst.AnimState:SetBuild("frog_yellow_build")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("animal")
    inst:AddTag("prey")
    inst:AddTag("hostile")
    inst:AddTag("smallcreature")
    inst:AddTag("frog")
    inst:AddTag("canbetrapped")
    inst:AddTag("scarytoprey")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 4
    inst.components.locomotor.runspeed = 8

    -- boat hopping enable.
    inst.components.locomotor:SetAllowPlatformHopping(true)
    inst:AddComponent("embarker")

    inst:SetStateGraph("SGfrog2")

    inst:SetBrain(brain)

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetSleepTest(ShouldSleep)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.FROG_HEALTH)

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.FROG_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.FROG_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, retargetfn)

    inst.components.combat.onhitotherfn = OnHitOther

    inst:AddComponent("thief")
    inst:AddComponent("poisonous")

    MakeTinyFreezableCharacter(inst, "frogsack")

    MakeHauntablePanic(inst)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:AddChanceLoot("froglegs", 1)
	inst.components.lootdropper:AddChanceLoot("venomgland", 0.5)

    inst:AddComponent("knownlocations")
    inst:AddComponent("inspectable")

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("goinghome", OnGoingHome)

    return inst
end

return Prefab("frog_poison2", fn, assets, prefabs)
