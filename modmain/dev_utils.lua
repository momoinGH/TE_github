require "util/textcompleter"
require "stacktrace"

--用这个字段判断是不是开发模式
_G.troisdev = not string.starts(modname, "workshop-")

if troisdev then
    require("debugcommands")  --允许控制台直接调用d_xxx函数
    require "consolecommands" --允许控制台直接调用c_xxx函数
end

OnTroErrorHandle = nil

---错误处理
---@param msg string 错误消息
---@param has_trace boolean 是否打印堆栈，默认true
function _G.TroErrorHandle(msg, has_trace, level)
    if has_trace == nil then
        has_trace = true
    end

    local res = { msg }
    if has_trace then
        res = getdebugstack(res, 2)
    end
    print(table.concat(res, "\n"))

    if OnTroErrorHandle then
        OnTroErrorHandle(msg, has_trace, level)
    end
end

----------------------------------------------------------------------------------------------------
--- 科雷modmain的定义抄过来，不过文件不存在时不会报错
function trosafemodimport(modulename, has_print)
    if has_print == nil then
        has_print = true
    end

    if string.sub(modulename, #modulename - 3, #modulename) ~= ".lua" then
        modulename = modulename .. ".lua"
    end
    local result = kleiloadlua(env.MODROOT .. modulename)
    if result == nil then
        -- error("Error in modimport: " .. modulename .. " not found!")
    elseif type(result) == "string" then
        error("Error in modimport: " .. ModInfoname(modname) .. " importing " .. modulename .. "!\n" .. result)
    else
        if has_print then
            print("modimport: " .. env.MODROOT .. modulename)
        end
        setfenv(result, env.env)
        result()
    end
end

----------------------------------------------------------------------------------------------------

function troimportmodulefile(path, is_load_all, load_before_fn, load_after_fn)
    assert(type(path) == "string" and not string.starts(path, "modmain"), "path需要是模块下的相对路径！path：" .. tostring(path))

    if not string.starts(path, "/") then
        path = "/" .. path
    end
    for _, m in pairs(tro_modules) do
        if is_load_all or m == tro_modules.common or TUNING.tropical[m] then --根据配置项决定是否读取
            if load_before_fn then
                load_before_fn(m)
            end
            trosafemodimport("modmain/" .. m .. path)
            if load_after_fn then
                load_after_fn(m)
            end
        end
    end
end

----------------------------------------------------------------------------------------------------

---全局的locale只在modinfo中存在，在servercreationmain中需要用translator
local locale = LanguageTranslator.defaultlang

local lang = "en"
function proenzh(en, zh) -- Other languages don't work
    local chinese_languages =
    {
        zh = "zh",      -- Chinese for Steam
        zhr = "zh",     -- Chinese for WeGame
        ch = "zh",      -- Chinese mod
        chs = "zh",     -- Chinese mod
        chinese = "zh", -- Chinese mod
        sc = "zh",      -- simple Chinese
        zht = "zh",     -- traditional Chinese for Steam
        tc = "zh",      -- traditional Chinese
        cht = "zh",     -- Chinese mod
    }

    if chinese_languages[locale] ~= nil then
        lang = chinese_languages[locale]
    end

    return lang == "zh" and zh or en
end
