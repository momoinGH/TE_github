local assets =
{
    Asset("ANIM", "anim/raft_rot.zip"),
}

local prefabs =
{
    "mast",
    "burnable_locator_medium",
    "steeringwheel",
    "rudder",
    "boatlip",
    "boat_water_fx",
    "boat_leak",
    "fx_boat_crackle",
    "fx_boat_pop",
    "boat_player_collision",
    "boat_item_collision",
    "walkingplank",
}

local function createbanditboat(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local boat = SpawnPrefab("boat_raft_rot")
    if boat then
        boat.Transform:SetPosition(x, y, z)
    end
    local tesouro = SpawnPrefab("buriedtreasure")
    if tesouro then
        tesouro.Transform:SetPosition(x, y, z)
    end
    local bandido = SpawnPrefab("pigbandit")
    if bandido then
        bandido.Transform:SetPosition(x, y, z)
    end
    local bandido = SpawnPrefab("pigbandit")
    if bandido then
        bandido.Transform:SetPosition(x, y, z)
    end
    local bandido = SpawnPrefab("pigbandit")
    if bandido then
        bandido.Transform:SetPosition(x, y, z)
    end
    inst:Remove()
end

local function createmermboat(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local boat = SpawnPrefab("boat_raft_rot")
    if boat then boat.Transform:SetPosition(x, y, z) end


    inst:DoTaskInTime(0.2, function()
        local tesouro = SpawnPrefab("buriedtreasure")
        if tesouro then tesouro.Transform:SetPosition(x, y, z) end
    end)


    inst:DoTaskInTime(0.5, function()
        for i = 1, 4 do
            local merm = SpawnPrefab("mermfisherpirate")
            if merm then
                merm.Transform:SetPosition(x, y, z)
            end
        end
        inst:Remove()
    end)
end

local function banditboatfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:DoTaskInTime(0, createbanditboat)

    return inst
end

local function mermboatfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()


    if not TheWorld.ismastersim then
        return inst
    end

    inst:DoTaskInTime(0, createmermboat)

    return inst
end

return Prefab("banditboat", banditboatfn, assets, prefabs),
    Prefab("mermboat", mermboatfn, assets, prefabs)
