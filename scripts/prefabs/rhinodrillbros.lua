local prefabs =
{
    "rhinodrill",
    "rhinodrill2",
}

local function bros_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    ------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    ------------------------------------------
    inst:DoTaskInTime(0, function(inst)
        local pos = inst:GetPosition()
        local bro_1 = SpawnPrefab("rhinodrill")
        bro_1.Transform:SetPosition(pos:Get())
        local bro_2 = SpawnPrefab("rhinodrill2")
        bro_2.Transform:SetPosition(pos:Get())
        bro_1.bro = bro_2
        bro_2.bro = bro_1
        inst:Remove()
    end)
    ------------------------------------------
    return inst
end

return Prefab("rhinodrillbros", bros_fn, nil, prefabs)
