--追踪指定预制体名的实体，减少全局查找的消耗

-- 要追踪的所有实体
local trace_prefabs = {
    pigking = true
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
local function GetEnts(prefab)
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

local function GetAnyEnt(prefab)
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

return {
    GetEnts = GetEnts,
    GetAnyEnt = GetAnyEnt
}
