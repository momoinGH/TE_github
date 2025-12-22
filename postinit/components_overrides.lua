local package_loaded = {}
--- import files outside the script folder or even from other mods
---@diagnostic disable-next-line: lowercase-global
modrequire = function(modulename, newenv)
    local rootpath
    local env = env
    rootpath = env.MODROOT
    modulename = string.gsub(modulename, "%.lua$", "")
    print("modimport (strings file): " .. rootpath .. modulename .. ".lua")
    if package_loaded[modulename] == nil then
        ---@diagnostic disable-next-line: undefined-global
        local result = kleiloadlua(rootpath .. modulename .. ".lua")
        if result == nil then
            print("Error in custom import: Stringsfile " .. modulename .. " not found!")
        elseif type(result) == "string" then
            print("Error in custom import: importing/" .. modulename .. "!\n" .. result)
        else
            setfenv(result, newenv or env) -- in case we use mod data
            package_loaded[modulename] = { result() }
        end
    end
    return package_loaded[modulename] and unpack(package_loaded[modulename])
end

local override_components = {
    "ambientlighting",
    "aoespell",
    "aoeweapon_leap",
    "aoeweapon_lunge",
    "armor",
    "autoterraformer",
    "beargerspawner",
    "bedazzlement",
    "blinkstaff",
    "caveweather",
    "curseditem",
    "deerclopsspawner",
    "deployable",
    "flotsamgenerator",
    "groundpounder",
    "kramped",
    "lock",
    "locomotor",
    "moisture",
    "oceantrawler",
    "parryweapon",
    "penguinspawner",
    "placer",
    "playervision",
    "quaker",
    "schoolspawner",
    "temperature",
    "terraformer",
    "thief",
    "trap",
    "weather",
    "wildfires",
}

for _, name in ipairs(override_components) do
    pcall(function()
        local orcmp = modrequire("components/override/" .. name)
        local cmp = require("components/" .. name)
        for k, v in pairs(orcmp) do
            cmp[k] = v
        end
    end)
end
