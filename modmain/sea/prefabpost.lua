local Utils = require("tropical_utils/utils")

AddPrefabPostInitAny(function(inst)
    if not TheWorld.ismastersim then return end

    if inst.components.workable or inst.components.health then
        inst:AddComponent("deathbubbles")
    end
end)

AddPlayerPostInit(function(inst)
    inst:AddComponent("oxygen")
    if TUNING.PLAYER_OXYGEN[string.upper(inst.prefab)] then
        inst.components.oxygen.max = TUNING.PLAYER_OXYGEN[string.upper(inst.prefab)]
    end

    inst:ListenForEvent("startdrowning", function(inst, data)
        if inst.HUD then
            inst.HUD.bloodover:UpdateState()
        end
    end, inst)

    inst:ListenForEvent("stopdrowning", function(inst, data)
        if inst.HUD then
            inst.HUD.bloodover:UpdateState()
        end
    end, inst)

    if not TheWorld.ismastersim then return end

    inst:AddComponent("bubbleblower") ------- Blow bubble underwater to players

    inst:ListenForEvent("runningoutofoxygen", function(inst, data)
        inst.components.talker:Say("Low Oxygen")
    end)
end)


AddPrefabPostInit("cave", function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("underwaterspawner")
end)
