require "util/textcompleter"
require "stacktrace"
proisdev = not string.starts(modname, "workshop-")
GLOBAL.proisdev = proisdev

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
function ProErrorHandle(msg, has_trace, dev_can_crash)
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
    if proisdev and dev_can_crash then
        error(s)
    else
        print(s)
    end
end

GLOBAL.ProErrorHandle = ProErrorHandle

-- 可以判断是否是开发模式的断言，开发陌生下游戏崩溃，工坊订阅下只会打印堆栈到日志
function prosoftassert(v, ...)
    if proisdev then
        return assert(v, ...)
    end

    -- 工坊订阅，不是开发模式
    if v then
        return v
    end

    ProErrorHandle(..., false, true)
    return v
end

GLOBAL.prosoftassert = prosoftassert
