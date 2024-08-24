local assets =
{
    Asset("ANIM", "anim/lavaarena_boarrior_basic.zip"),
    Asset("ANIM", "anim/fossilized.zip"),
}

local brain = require "brains/bossboarbrainte"

SetSharedLootTable("boarrior",
    {
        { "meat", 1.0 },
        { "meat", 1.0 },
        { "meat", 1.0 },
        { "meat", 1.0 },
        { "meat", 1.0 },
        { "meat", 1.0 },
        { "meat", 1.0 },
        { "meat", 1.0 },
        { "meat", 1.0 },
        { "meat", 1.0 },
        { "meat", 1.0 },
        { "fireballstaff", 0.5 },
        { "healingstaff", 1.0 },
        { "spear_gungnir", 0.5 },
        { "hammer_mjolnir", 0.5 },
    })

local function OnTimerDone(inst, data)
    if data.name == "regen_bossboar" then
        if inst._spawntask ~= nil then
            inst._spawntask:Cancel()
            inst._spawntask = nil
        end
        inst:Show()
        inst.DynamicShadow:Enable(true)
        GFSoftColourChange(inst, { 0, 0, 0, 1 }, { 0, 0, 0, 0 }, 2, 0.1)
        inst:DoTaskInTime(2, function(inst) GFSoftColourChange(inst, { 1, 1, 1, 1 }, { 0, 0, 0, 1 }, 2, 0.1) end)
        inst:DoTaskInTime(4, function(inst)
            inst.brain:Start()
            inst:SetEngaged()
            inst:ReTarget()
        end)
    end
end

local function OnAttacked(inst, data)
    if data == nil or data.attacker == nil or data.attacker:HasTag("boar") then return end
    if inst.components.combat.target == nil or not inst.components.combat.target:HasTag("player") then
        inst.components.combat:SetTarget(data.attacker)
    end
    if not inst.engaged then
        inst:SetEngaged(inst)
    end
end

local function OnHitOther(inst)
    inst.rage = inst.rage + 1
    --("rage", inst.rage)
end

local function ReTarget(inst)
    if not inst.engaged then return nil end

    local newtarget = FindEntity(inst, 50,
        function(guy)
            return inst.components.combat:CanTarget(guy)
        end,
        { "_combat" },
        { "smallcreature", "playerghost", "shadow", "INLIMBO", "FX", "NOCLICK" }
    )

    if newtarget then
        return newtarget
    end
end

local function SetEngaged(inst)
    if not inst.engaged then
        --		inst.components.health:SetMaxHealth(13000)
        inst.engaged = true
    end
end

local function SetEvaded(inst)
    if inst.engaged then
        --		inst.components.health:SetPercent(1)
    end
end

local function OnSave(inst, data)
    data.engaged = inst.engaged
end

local function OnLoad(inst, data)
    if data ~= nil then
        if data.engaged then
            inst:DoTaskInTime(0, SetEngaged)
        end
    end
end

local function master_postinit(inst)
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = 14

    inst:SetStateGraph("SGboarrior")
    inst:SetBrain(brain)

    inst:AddComponent("knownlocations")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(34000)

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(75) --(100)
    inst.components.combat:SetAttackPeriod(1.5)
    inst.components.combat:SetRetargetFunction(5, ReTarget)
    --inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst.components.combat:SetRange(6)
    inst.components.combat.battlecryenabled = false

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("boarrior")

    inst:AddComponent("inspectable")
    inst:AddComponent("sanityaura")
    inst:AddComponent("explosiveresist")

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(4)
    inst.components.sleeper.diminishingreturns = true

    inst:AddComponent("timer")

    inst.rage = 0
    inst._fireburstHitted = {}

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.ReTarget = ReTarget
    --pull/evade
    inst.engaged = false
    inst.SetEngaged = SetEngaged
    inst.SetEvaded = SetEvaded

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("timerdone", OnTimerDone)
    inst:ListenForEvent("onhitother", OnHitOther)
end

add_event_server_data("lavaarena", "prefabs/lavaarena_boarrior", {
    master_postinit = master_postinit
}, assets)
