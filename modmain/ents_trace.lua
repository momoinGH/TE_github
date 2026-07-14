--追踪指定预制体名的实体，用于频繁的实体查找，如果只是少量预制体在初始化的查找遍历Ents就行了

-- 要追踪的所有实体
local trace_prefabs = {
    multiplayer_portal = true,               --绚丽之门
    pigking = true,                          --猪王
    sharkittenspawner = true,                --虎鲨生成器
    cave_exit_roc = true,                    --洞穴出口
    kraken = true,                           --海妖
    octopusking = true,                      --章鱼王
    volcano = true,                          --火山

    anthill_exit = true,                     --蚁巢出口
    frosttocave = true,                      --洞穴隧道
    roc_nest = true,                         --大鹏巢

    lavaarena_portal = true,                 --熔炉传送门
    lavaarena_center = true,                 --角斗容器
    lavaarena_battlestandard_damager = true, --战旗
    lavaarena_battlestandard_shield = true,
    lavaarena_battlestandard_heal = true,

    quagmire_portal = true, --苔藓大门
    quagmire_altar = true,  --饕餮祭坛
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
function _G.TroGetEntsByPrefab(prefab)
    local ents = {}
    if trace_prefabs[prefab] then
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
    else
        --没有定义
        for _, v in pairs(Ents) do
            if v.prefab == prefab then
                table.insert(ents, v)
            end
        end
    end
    return ents
end

-- 获取任意一个
function _G.TroGetAnyEntByPrefab(prefab)
    if trace_prefabs[prefab] then
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
    else
        for _, v in pairs(Ents) do
            if v.prefab == prefab then
                return v
            end
        end
    end
    return nil
end

---查找最近实体
---@param loc Vector3|ent 可以是坐标可以是实体
---@param prefab any
---@return unknown
function _G.TroGetClosestEnt(loc, prefab)
    local pos = (loc.prefab and loc:GetPosition()) or loc
    local min_dist_sq
    local ent
    for _, v in ipairs(TroGetEntsByPrefab(prefab)) do
        local dist_sq = pos:DistSq(v:GetPosition())
        if not ent or dist_sq < min_dist_sq then
            ent = v
            min_dist_sq = dist_sq
        end
    end
    return ent
end
