local assets =
{

}

local prefabs =
{
    "rock_ice_frost",
}

-- 海里生成迷你冰川和冰面、鲸鱼
local objetos =
{
    "rock_ice_frost",
    "rock_ice_frost",
    "rock_ice_frost",
    "rock_ice_frost",
    "rock_ice_frost",
    "rock_ice_frost",
    "rock_ice_frost",
    "icedpad",
    "icedpad",
    "whale_bluefinal",
}


local function SpawnSeataro(spawn_point)
    return SpawnAt(objetos[math.random(#objetos)], spawn_point)
end

local function GetSpawnPoint(pt)
    local function TestSpawnPoint(offset)
        local spawnpoint = pt + offset
        return TheWorld.Map:IsOceanAtPoint(spawnpoint.x, 0, spawnpoint.z)
            and #TheSim:FindEntities(spawnpoint.x, 0, spawnpoint.z, 7, nil, { "FX" }) <= 0 --防止重叠
    end

    local theta = math.random() * TWOPI
    local radius = 24 + math.random(-1, 1) * 4
    local resultoffset = FindValidPositionByFan(theta, radius, 12, TestSpawnPoint)

    if resultoffset ~= nil then
        return pt + resultoffset
    end
end

local function SpawnSeataroPre(inst)
    local pt = inst:GetPosition()
    local spawn_point = GetSpawnPoint(pt)
    if spawn_point ~= nil then
        SpawnSeataro(spawn_point)
        inst:Remove()
    else
        inst.tentativas = inst.tentativas - 1
        if inst.tentativas and inst.tentativas > 1 then
            inst:DoTaskInTime(1, SpawnSeataroPre)
        end
        if inst.tentativas and inst.tentativas < 1 then inst:Remove() end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst.tentativas = 5 --要生成多少个实体

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:DoTaskInTime(1, SpawnSeataroPre)

    return inst
end

return Prefab("rock_ice_frost_spawner", fn, assets, prefabs)
