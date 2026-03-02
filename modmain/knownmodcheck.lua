local LANGUAGE = LanguageTranslator.defaultlang

local function en_zh(en, zh)
    return (LANGUAGE == "zh" or LANGUAGE == "zhr" or LANGUAGE == "zht") and zh or en
end

local incompatibleMODs = {
    {
        workshop = "2986194136",
        str = en_zh("Tropical Adventures", "热带冒险"),
    },
    {
        workshop = "3435352667",
        str = "Island Adventures - Core",
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

for _, v in ipairs(incompatibleMODs) do
    assert(not KnownModIndex:IsModEnabled("workshop-" .. v.workshop), warn(v))
end
