require "stategraphs/SGcommonfish"
require "brains/commonfishbrain"

local MAX_CHASEAWAY_DIST = 25

local assets =
{
    Asset("ANIM", "anim/commonfish.zip"),
}

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 20, function(dude)
        return dude:HasTag("commonfish") and not dude.components.health:IsDead()
    end, 5)
end

local function KeepTarget(inst, target)
    local homePos = inst.components.knownlocations:GetLocation("herd")
    local targetPos = Vector3(target.Transform:GetWorldPosition())
    return homePos and distsq(homePos, targetPos) < MAX_CHASEAWAY_DIST * MAX_CHASEAWAY_DIST
end

local function OnTimerDone(inst, data)
    if data.name == "vaiembora" then
        local invader = GetClosestInstWithTag("player", inst, 25)
        if not invader then
            inst:Remove()
        else
            inst.components.timer:StartTimer("vaiembora", 10)
        end
    end
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetFourFaced()
    local scale = 1
    inst.Transform:SetScale(scale, scale, scale)

    local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize(1.5, .5)

    MakeGhostPhysics(inst, 1, .5)

    anim:SetBank("commonfish")
    anim:SetBuild("commonfish")

    inst:AddTag("commonfish")
    inst:AddTag("underwater")
    inst:AddTag("prey")
    inst:AddTag("tropicalspawner")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = TUNING.ABIGAIL_SPEED * .6667
    inst.components.locomotor.runspeed = TUNING.ABIGAIL_SPEED * 1.3333
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }

    inst:AddComponent("inspectable")

    inst:AddComponent("combat")
    inst.components.combat.defaultdamage = 8
    inst:ListenForEvent("attacked", OnAttacked)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(120)
    inst.components.health.nofadeout = true

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "fish_fillet" })
    inst.components.lootdropper:AddChanceLoot("saltrock", 0.2)

    inst:AddComponent("knownlocations")

    inst:AddComponent("herdmember")
    inst.components.herdmember.herdprefab = "commonfishschool"

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(1)

    local brain = require "brains/commonfishbrain"
    inst:SetBrain(brain)

    inst:SetStateGraph("SGcommonfish")

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone)
    inst.components.timer:StartTimer("vaiembora", 240)

    return inst
end

return Prefab("commonfish", fn, assets)
