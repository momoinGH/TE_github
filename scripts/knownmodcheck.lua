local LANGUAGE = LanguageTranslator.defaultlang

local function en_zh(en, zh)
	return (LANGUAGE == "zh" or LANGUAGE == "zhr" or LANGUAGE == "zht") and zh or en
end

local incompatibleMODs = {
    {
        name = en_zh(" Tropical Adventures|Ship of Theseus", "热带冒险|忒修斯之船"),
        workshop = "2986194136",
        str = en_zh("Tropical Adventures", "热带冒险"),
    },
    {
        workshop = "1467214795",
        str = en_zh("Island Adventures", "岛屿冒险"),
    },
    {
        workshop = "3322803908",
        str = en_zh("Above the Clouds", "云霄国度"),
    },
    {
        workshop = "2823458540",
        str = "富贵险中求",
    },
}

local function warn(mod)
    return string.format(en_zh("Tropical Experience: Don't enable mod \"%s\" at the same time!\n",
                "热带体验：请勿同时启用模组【%s(workshop-%s)】！\n"), mod.str, mod.workshop)
end

function KnownModIndex:GetEnabledServerModNames()
	local names = {}
	for name, modinfo in pairs(self.savedata.known_mods) do
		if not self:GetModInfo(name).client_only_mod and modinfo.enabled then
			names[name] = GetModFancyName(name)
		end
	end
	return names
end

function KnownModIndex:IsInfoModEnable(modinfo)
    return modinfo and (KnownModIndex:IsModEnabledAny("workshop-" .. modinfo.workshop) -- or -- steam workshop
                )
end

-- function EnabledModCheck
print("Finded Mods:")
for k, v in pairs(KnownModIndex:GetEnabledServerModNames()) do
    print(k, v)
end
for _, v in ipairs(incompatibleMODs) do
    assert(KnownModIndex:IsInfoModEnable(v) ~= true, warn(v))
end