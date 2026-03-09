--==<[[ СЕРДЦЕ МОДА ]]>==--

-- Ссылки и сокращения --

FULL_CHARACTERLIST = {}
for _, t in pairs({ DST_CHARACTERLIST, MODCHARACTERLIST }) do
    for _, v in pairs(t) do table.insert(FULL_CHARACTERLIST, v) end
end

--TheConfiguration = {}
--local config, temp_options = KnownModIndex:GetModConfigurationOptions_Internal(modname)
--if config and type(config) == "table" then
--	if temp_options then
--		TheConfiguration = config
--	else
--		for i,v in pairs(config) do
--			local value = v.default
--			if v.saved ~= nil then
--				value = v.saved
--			end
--			TheConfiguration[v.name] = value
--		end
--	end
--end
--TheConfiguration = TheConfiguration

--==[ ПРИВАТНЫЕ ФУНКЦИИ ]==--

--< ОСНОВНОЕ >--

local function cutpath(path_string)
    local path = {}
    for sub in path_string:gmatch("([%w_]+)") do
        table.insert(path, sub)
    end
    return path
end
local dummyfn = function() end

local Tools =
{
    -- 1. Система --

    GetPath = function(root, path)
        local t = root
        for _, v in pairs(cutpath(path)) do
            if t[v] == nil then
                t[v] = {}
            end
            t = t[v]
        end
        return t
    end,

    -- 2. Игровой процесс --

    Valid = function(inst)
        return inst ~= nil and inst:IsValid()
    end,

    ReturnChild = function(root, path)
        local t = root
        for _, v in pairs(cutpath(path)) do
            if type(t) ~= "table" then
                return
            end
            t = t[v]
            if t == nil then
                return
            end
        end
        return t
    end,

    AddChild = function(inst, child)
        inst:AddChild(child)
        child.entity:SetParent(nil)
        return child
    end,

    DoHauntFlick = function(inst, time)
        inst.AnimState:SetHaunted(true)
        inst:DoTaskInTime(time or 1, function()
            inst.AnimState:SetHaunted(false)
        end)
    end,

    --	PushFakeShadow = function(inst, time, ...)
    --		local function ReturnToNormal()
    --			if inst.DynamicShadowFake ~= nil then
    --				inst.DynamicShadowFake:Remove()
    --				inst.DynamicShadowFake = nil
    --			end
    --			inst.DynamicShadow:Enable(true)
    --		end
    --					
    --		local shadow = SpawnPrefab("dynamicshadow")
    --		shadow:Hook(inst, ...)
    --			
    --		ReturnToNormal()
    --		inst.DynamicShadow:Enable(false)
    --		inst.DynamicShadowFake = shadow
    --		
    --		inst:DoTaskInTime(time or 1, ReturnToNormal)
    --	end,

    SpawnBundle = function(prefab, data)
        local bundle = SpawnPrefab(prefab)
        bundle.components.unwrappable:WrapItems(data)

        for _, v in pairs(data) do
            v:Remove()
        end

        return bundle
    end,

    PlayCharacterSound = function(inst, name)
        inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/") ..
            (inst.soundsname or inst.prefab) .. "/" .. name)
    end,

    -- 3. Утилиты --

    ReplicateDummyFn = function(root, fn, rep, ...)
        local save = nil
        if root ~= nil then
            save = root[fn]
            root[fn] = dummyfn
        end

        rep(...)

        if save ~= nil then
            root[fn] = save
        end
    end,

    SequenceFn = function(root, fn, exp)
        local old = root[fn]
        root[fn] = function(self, ...)
            local data = { old(self, ...) }
            return exp(#data > 1 and data or data[1], ...)
        end
    end,

    ReplaceFn = function(root, fn, replace)
        if replace ~= nil then
            root["__" .. fn] = root[fn]
            root[fn] = replace
        elseif root["__" .. fn] ~= nil then
            root[fn] = root["__" .. fn]
            root["__" .. fn] = nil
        end
    end,
}

if TECH.WAFFLES1 ~= nil then
    for name, fn in pairs(Tools) do
        TECH.WAFFLES1[name] = fn
    end
else
    TECH.WAFFLES1 = Tools
end

Waffles1 = TECH.WAFFLES1

--< ДОПОЛНЕНИЯ >--

-- 1. Общее --

Waffles1.AddCharacterQuotes = function(path, key, quotes)
    local t = Waffles1.GetPath(_G, "STRINGS/CHARACTERS")
    for character, quote in pairs(quotes) do
        if key then
            Waffles1.GetPath(t, string.format("%s/%s", character, path))[key] = quote
        else
            Waffles1.GetPath(t, character)[path] = quote
        end
    end
end
