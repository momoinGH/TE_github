-- 我希望预制件在CreateEntity后就能通过inst.prefab拿到当前是什么预制件，方便类似AnimState调用hook函数的时候判断
local creating_prefab
local OldSpawnPrefabFromSim = SpawnPrefabFromSim
function _G.SpawnPrefabFromSim(name, ...)
    creating_prefab = name
    local ret = OldSpawnPrefabFromSim(name, ...)
    creating_prefab = nil
    return ret
end

local OldCreateEntity = CreateEntity
function _G.CreateEntity(...)
    local inst = OldCreateEntity(...)
    inst.prefab = inst.prefab or creating_prefab --这里就赋值一下
    creating_prefab = nil
    return inst
end
