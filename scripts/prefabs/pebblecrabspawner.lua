local prefabs = {
    "quagmire_pebblecrab"
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    --[[Non-networked entity]]

    inst:AddTag("CLASSIFIED")

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "quagmire_pebblecrab"
    inst.components.childspawner:SetMaxChildren(2)
    inst.components.childspawner:SetSpawnPeriod(math.random(TUNING.MIN_TUMBLEWEED_SPAWN_PERIOD,
        TUNING.MAX_TUMBLEWEED_SPAWN_PERIOD))
    inst.components.childspawner:SetRegenPeriod(TUNING.TUMBLEWEED_REGEN_PERIOD)
    inst.components.childspawner.spawnoffscreen = true
    inst:DoTaskInTime(0, function(inst)
        inst.components.childspawner:ReleaseAllChildren()
        inst.components.childspawner:StartSpawning()
    end)

    return inst
end

return Prefab("pebblecrabspawner", fn, nil, prefabs)
