require "util/textcompleter"
require "stacktrace"
troisdev = not string.starts(modname, "workshop-")
GLOBAL.troisdev = troisdev

if troisdev then
    require("debugcommands")  --允许控制台直接调用d_xxx函数
    require "consolecommands" --允许控制台直接调用c_xxx函数
end

-- 自定义打印函数，就是简单的把内容拼接在一起，和科雷不同的事不会在每个元素之间加空格
function conprint(...)
    local result = ""
    for i, arg in ipairs({ ... }) do
        result = result .. tostring(arg)
    end
    print(result)
end

GLOBAL.conprint = conprint

---错误处理
---@param msg string 错误消息
---@param has_trace boolean 是否打印堆栈，默认true
---@param dev_can_crash boolean 开发模式下是否可以崩溃，默认true
function TroErrorHandle(msg, has_trace, dev_can_crash)
    if has_trace == nil then
        has_trace = true
    end
    if dev_can_crash == nil then
        dev_can_crash = true
    end

    local s = "错误（注意这里不是崩溃原因）："
    if has_trace then
        s = s .. StackTrace(msg)
    else
        s = s .. tostring(msg) .. "\nLUA ERROR stack traceback:（方便搜索）" --方便搜索
    end
    if troisdev then
        if dev_can_crash then
            error(s)
        else
            c_announce(s) --公告提示一下
            print(s)
        end
    else
        print(s)
    end
end

GLOBAL.TroErrorHandle = TroErrorHandle

-- 可以判断是否是开发模式的断言，开发陌生下游戏崩溃，工坊订阅下只会打印堆栈到日志
function trodevassert(v, ...)
    if troisdev then
        return assert(v, ...)
    end

    -- 工坊订阅，不是开发模式
    if v then
        return v
    end

    TroErrorHandle(..., false, true)
    return v
end

GLOBAL.trodevassert = trodevassert

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

function troimportmodulefile(path, is_load_all)
    assert(type(path) == "string" and not string.starts(path, "modmain"), "path需要是模块下的相对路径！path：" .. tostring(path))

    if not string.starts(path, "/") then
        path = "/" .. path
    end
    for _, m in pairs(tro_modules) do
        if is_load_all or m == tro_modules.common or TUNING.tropical[m] then --根据配置项决定是否读取
            trosafemodimport("modmain/" .. m .. path)
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
