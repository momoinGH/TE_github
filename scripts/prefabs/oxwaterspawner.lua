local assets =
{

}

local prefabs =
{
    "ox",
}

local function SpawnOx(spawn_point)
    local plant = SpawnPrefab("ox")
    plant.Transform:SetPosition(spawn_point.x, spawn_point.y, spawn_point.z)
    return plant
end

local function GetSpawnPoint(pt)
    local theta = math.random() * 2 * PI
    local radius = 48 + math.random(-1, 1) * 4
    local resultoffset = FindValidPositionByFan(theta, radius, 12)

    if resultoffset ~= nil then
        return pt + resultoffset
    end
end

local function SpawnOxPre(inst)
    local pt = inst:GetPosition()
    local spawn_point = GetSpawnPoint(pt)
    if spawn_point ~= nil then
        local plant = SpawnOx(spawn_point)
        inst:Remove()
    else
        inst.tentativas = inst.tentativas - 1
        if inst.tentativas and inst.tentativas > 1 then
            inst:DoTaskInTime(1, SpawnOxPre)
        end
        if inst.tentativas and inst.tentativas < 1 then inst:Remove() end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    --inst:AddTag("CLASSIFIED")
    inst.tentativas = 10

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:DoTaskInTime(1, SpawnOxPre)

    return inst
end

return Prefab("oxwaterspawner", fn, assets, prefabs)
