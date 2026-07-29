modimport "modmain/underwater/components/burnable.lua"

-- 注册 oxygen 主客机分离（component + replica）
AddReplicableComponent("oxygen")

AddPrefabPostInitAny(function(inst)
    if not TheWorld.ismastersim then return end

    if inst.components.workable or inst.components.health then
        inst:AddComponent("und_deathbubbles")
    end
end)

AddPlayerPostInit(function(inst)
    -- HUD 相关事件：主客机都需要监听（客机由 replica dirty 推送）
    inst:ListenForEvent("startdrowning", function(inst, data)
        if inst.HUD then
            inst.HUD.bloodover:UpdateState()
        end
    end)

    inst:ListenForEvent("stopdrowning", function(inst, data)
        if inst.HUD then
            inst.HUD.bloodover:UpdateState()
        end
    end)

    if not TheWorld.ismastersim then return end

    inst:AddComponent("oxygen")
    local max_oxygen = TUNING.PLAYER_OXYGEN[string.upper(inst.prefab)]
    if max_oxygen then
        inst.components.oxygen:SetMax(max_oxygen)
    end

    inst:AddComponent("und_bubbleblower") ------- Blow bubble underwater to players

    inst:ListenForEvent("runningoutofoxygen", function(inst, data)
        if inst.components.talker then
            inst.components.talker:Say("Low Oxygen")
        end
    end)
end)


AddPrefabPostInit("cave", function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("underwaterspawner")
end)
