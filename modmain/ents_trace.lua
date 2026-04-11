--追踪指定预制体名的实体，用于频繁的实体查找，如果只是少量预制体在初始化的查找遍历Ents就行了

-- 要追踪的所有实体
local trace_prefabs = {
    pigking = true,           --猪王
    sharkittenspawner = true, --虎鲨生成器
}

local trace_ents = {}

AddPrefabPostInitAny(function(inst)
    if inst.prefab and trace_prefabs[inst.prefab] then
        trace_ents[inst.prefab] = trace_ents[inst.prefab] or {}
        trace_ents[inst.prefab][inst.GUID] = true
    end
end)

Hooks.FnDecorator(EntityScript, "Remove", function(inst)
    if inst.prefab and trace_ents[inst.prefab] then
        trace_ents[inst.prefab][inst.GUID] = nil
        if not next(trace_ents[inst.prefab]) then
            trace_ents[inst.prefab] = nil
        end
    end
end)

-- 获取所有指定预制体名的实体
function TroGetEntsByPrefab(prefab)
    if not trace_prefabs[prefab] then
        TroErrorHandle("查找的预制体必须是trace_prefabs表里定义过的" .. tostring(prefab))
    end


    local ents = {}
    local guids = trace_ents[prefab]
    if guids then
        for guid, _ in pairs(guids) do
            local ent = Ents[guid]
            if ent then
                table.insert(ents, ent)
            else
                guids[guid] = nil --对象没了，虽然不太可能
            end
        end
    end

    return ents
end

GLOBAL.TroGetEntsByPrefab = TroGetEntsByPrefab

-- 获取任意一个
function TroGetAnyEntByPrefab(prefab)
    if not trace_prefabs[prefab] then
        TroErrorHandle("查找的预制体必须是trace_prefabs表里定义过的" .. tostring(prefab))
    end

    local guids = trace_ents[prefab]
    if guids then
        for guid, _ in pairs(guids) do
            local ent = Ents[guid]
            if ent then
                return ent
            else
                guids[guid] = nil --对象没了，虽然不太可能
            end
        end
    end

    return nil
end

GLOBAL.TroGetAnyEntByPrefab = TroGetAnyEntByPrefab
