-- 检测英文不存在但是其他语种存在的台词，判断是否需要补充，没有必要可以在ignore_print_strings中添加前缀不再提醒
-- 可以忽视的台词前缀，这种不写也不会导致游戏崩溃
local ignore_print_strings = {
    "STRINGS.CHARACTERS.GENERIC.DESCRIBE"
}

print("开始比对英文和其他语言台词：")
local startTime = os.clock()
local function LanguageStringCompare(en_tab, other_tab, prefix)
    for k, v in pairs(other_tab) do
        if type(v) ~= type(en_tab[k]) then
            local should_ignore = false
            for _, p in ipairs(ignore_print_strings) do
                if string.starts(prefix, p) then
                    should_ignore = true
                    break
                end
            end
            if not should_ignore then
                ProErrorHandle("英文台词缺失：" .. prefix .. "." .. k, false, false)
            end
        elseif type(v) == "table" then
            LanguageStringCompare(en_tab[k], v, prefix .. "." .. k)
        end
    end
end

local old_strings = STRINGS
GLOBAL.STRINGS = deepcopy(old_strings)

local modules = {
    "room",
    "boat",
    "windy",
    "sea",
    "underwater",
    "hamlet",
    "shipwrecked",
    "shipwrecked_plus",
    "lavaarena",
    "greenworld",
    "frostisland",
    "quagmire"
}

for _, m in ipairs(modules) do
    for _, language in ipairs({
        "pt",
        "zh",
        "it",
        "ru",
        "sp",
        "ko",
        "hun",
        "fr"
    }) do
        modimportmodulefile("modmain/" .. m .. "/languages/strings_" .. language, false)
    end
end
local other_language_strings = STRINGS
GLOBAL.STRINGS = deepcopy(old_strings)

for _, m in ipairs(modules) do
    modimportmodulefile("modmain/" .. m .. "/languages/strings_en", false)
end

-- 比较
LanguageStringCompare(STRINGS, other_language_strings, "STRINGS")

print(string.format("台词比对完成，耗时: %.6f 秒", os.clock() - startTime))
GLOBAL.STRINGS = old_strings

----------------------------------------------------------------------------------------------------

Utils.FnDecorator(env, "AddAction", function(id)
    prodevassert(not ACTIONS[id], "重复定义了ACTIONS: " .. id)
end)
