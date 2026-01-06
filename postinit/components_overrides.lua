local Util = require "tools/utils"

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
    "bedazzlement",
    "blinkstaff",
    "curseditem",
    "deployable",
    "groundpounder",
    "kramped",
    "lock",
    "locomotor",
    "moisture",
    "oceantrawler",
    "parryweapon",
    "placer",
    "playervision",
    "temperature",
    "terraformer",
    "thief",
    "trap",
}

local LoadComponent = Util.FindUpvalue(EntityScript.AddComponent, "LoadComponent")

for _, name in ipairs(override_components) do
    local orcmp = require("components/overrides/" .. name)
    local cmp = LoadComponent(name)
    for k, v in pairs(orcmp) do
        if v ~= nil then
            cmp[k] = v
        end
    end
end

local override_component_bases = {
    "beargerspawner",
    "caveweather",
    "deerclopsspawner",
    "flotsamgenerator",
    "quaker",
    "penguinspawner",
    "schoolspawner",
    "weather",
    "wildfires",
}

for _, name in ipairs(override_components) do
    package.loaded["components/" .. name] = require("components/overrides/" .. name)
end
