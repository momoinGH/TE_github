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

for _, m in ipairs(pro_modules) do
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
        prosafemodimport("modmain/" .. m .. "/languages/strings_" .. language, false)
    end
end
local other_language_strings = STRINGS
GLOBAL.STRINGS = deepcopy(old_strings)

for _, m in ipairs(pro_modules) do
    prosafemodimport("modmain/" .. m .. "/languages/strings_en", false)
end

-- 比较
LanguageStringCompare(STRINGS, other_language_strings, "STRINGS")

print(string.format("台词比对完成，耗时: %.6f 秒", os.clock() - startTime))
GLOBAL.STRINGS = old_strings

----------------------------------------------------------------------------------------------------
-- 检查ACTIONS是否重复定义
Hooks.FnDecorator(env, "AddAction", function(id)
    if type(id) == "table" then
        id = id.id
    end
    prodevassert(not ACTIONS[id], "重复定义了ACTIONS." .. tostring(id))
end)

----------------------------------------------------------------------------------------------------
-- 检查预制件重复定义的，或者和科雷重名的
local mod_prefab_files = {}
local prefab_filepaths = {}
Hooks.FnDecorator(GLOBAL, "LoadPrefabFile", nil, function(retTab, filename, async_batch_validation, search_asset_first_path)
    if not search_asset_first_path then --有值表示是mod文件
        return retTab
    end
    if not string.find(search_asset_first_path, modname) then --只检查当前mod
        return retTab
    end
    if mod_prefab_files[filename] then --文件加载过了
        return retTab
    end

    local ret = retTab[1]
    for _, prefab in ipairs(ret) do
        local path = search_asset_first_path .. "/" .. filename
        prodevassert(not Prefabs[prefab.name],
            "预制件" .. tostring(prefab.name) .. "已经定义过了，文件路径：" .. path .. ", 最早定义文件：" .. tostring(prefab_filepaths[prefab.name]))
        -- if Prefabs[prefab.name] then --仅打印
        --     ProErrorHandle("预制件" .. tostring(prefab.name) .. "已经定义过了，文件路径：" .. path
        --         .. ", 最早定义文件：" .. tostring(prefab_filepaths[prefab.name]), false, false)
        -- end
        mod_prefab_files[filename] = true
        prefab_filepaths[prefab.name] = path
    end
    return retTab
end)

----------------------------------------------------------------------------------------------------
-- 检查ActionHandler的ACTION是否定义
local OldAddStategraphActionHandler = env.AddStategraphActionHandler
env.AddStategraphActionHandler = function(stategraph, handler, ...)
    prodevassert(handler and handler.action and ACTIONS[handler.action.id], "发现没有定义的ACTION，你应该先在actions.lua文件中定义ACTION")
    return OldAddStategraphActionHandler(stategraph, handler, ...)
end