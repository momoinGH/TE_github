require "stategraphs/SGshrimp"
require "brains/shrimpbrain"

local assets =
{
    Asset("ANIM", "anim/shrimp.zip"),
    --Asset("SOUND", "sound/shrimp.fsb"),
}

local prefabs =
{
    "shrimp_tail",
}

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
    inst.entity:AddNetwork()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    inst.Transform:SetTwoFaced()
    MakeGhostPhysics(inst, 1, .5)

    local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize(1.5, .5)

    anim:SetBank("shrimp")
    anim:SetBuild("shrimp")

    inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("shrimp")
    inst:AddTag("underwater")
    inst:AddTag("tropicalspawner")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 5
    inst.components.locomotor.runspeed = 7

    inst:AddComponent("inspectable")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(20)

    inst:AddComponent("combat")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "shrimp_tail" })
    inst.components.lootdropper:AddChanceLoot("saltrock", 0.1)

    inst:AddComponent("knownlocations")
    inst:DoTaskInTime(1 * FRAMES,
        function()
            inst.components.knownlocations:RememberLocation("home", inst:GetPosition(),
                true)
        end)

    inst:SetStateGraph("SGshrimp")

    local brain = require "brains/shrimpbrain"
    inst:SetBrain(brain)

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone)
    inst.components.timer:StartTimer("vaiembora", 240)

    return inst
end

return Prefab("shrimp", fn, assets)
