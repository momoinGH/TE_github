local function StopWind(inst)
    inst._tro_wind_task = nil
    if not inst.components.pickable:CanBePicked() then
        return
    end

    inst.AnimState:PlayAnimation("blown_pst", false)
    inst.AnimState:PushAnimation("idle", true)
    if math.random() > 0.99 then
        inst.components.lootdropper:SpawnLootPrefab("twigs")
        inst.components.pickable:Pick(inst)
        inst.SoundEmitter:PlaySound("dontstarve/forest/treefall") --nao se pq isso nao ta funcionando
    end
end

-- 海难飓风
local function TroTryWind(inst)
    if inst._tro_wind_task then
        return
    end

    if not inst.components.pickable:CanBePicked() then
        return
    end

    inst.AnimState:PlayAnimation("blown_pre", false)
    inst.AnimState:PushAnimation(math.random() > 0.5 and "blown_loop1" or "blown_loop2", true)
    inst._tro_wind_task = inst:DoTaskInTime(5.5, StopWind)
end

AddPrefabPostInit("sapling", function(inst)
    if not TheWorld.ismastersim then return end

    inst._tro_wind_task = nil
    inst.TroTryWind = TroTryWind
end)
