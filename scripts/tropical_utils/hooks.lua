local FN = {}

---函数装饰器，增强原有函数的时候可以使用
---@param beforeFn function|nil 先于fn执行，参数为fn参数，返回三个值：新返回值表、是否跳过旧函数执行，旧函数执行参数（要求是表，会用unpack解开）
---@param afterFn function|nil 晚于fn执行，第一个参数为前面执行后的返回值表，后续为fn的参数，返回值作为最终返回值（要求是表或nil，会用unpack解开）
---@param isUseBeforeReturn boolean|nil 在没有afterFn却有beforeFn的时候，是否采用beforeFn的返回值作为最终返回值，默认以原函数的返回值作为最终返回值
function FN.FnDecorator(obj, key, beforeFn, afterFn, isUseBeforeReturn)
    assert(type(obj) == "table")
    assert(beforeFn == nil or type(beforeFn) == "function", "beforeFn must be nil or a function")
    assert(afterFn == nil or type(afterFn) == "function", "afterFn must be nil or a function")

    local oldVal = obj[key]

    obj[key] = function(...)
        local retTab, isSkipOld, newParam, r
        if beforeFn then
            retTab, isSkipOld, newParam = beforeFn(...)
        end

        if type(oldVal) == "function" and not isSkipOld then
            if newParam ~= nil then
                r = { oldVal(unpack(newParam)) }
            else
                r = { oldVal(...) }
            end
            if not isUseBeforeReturn then
                retTab = r
            end
        end

        if afterFn then
            retTab = afterFn(retTab, ...)
        end

        if retTab == nil then
            return nil
        end
        return unpack(retTab)
    end
end

local function GetUpValue(fn, upvalueName)
    local i = 1
    while true do
        local name, value = debug.getupvalue(fn, i)
        if not name then break end -- 没有更多的upvalue了
        if name == upvalueName then
            return value, i
        end
        i = i + 1
    end
    return nil, nil
end

---链式查询上值，找不到就返回nil，应该比上面那个更常用，因为这个是链式的
function FN.FindUpvalue(fn, ...)
    assert(type(fn) == "function", "第一个参数必须是函数")

    local current_fn = fn
    local val, i
    for _, name in ipairs({ ... }) do
        val, i = GetUpValue(current_fn, name)
        if i == nil then
            return nil, nil, nil
        end
        current_fn = val
    end
    return val, current_fn, i
end

--- 替换上值，参数为路径，最后一个参数为要替换的新值
function FN.SetUpvalue(fn, ...)
    local args = { ... }
    assert(#args >= 2, "至少需要两个参数：函数和要设置的路径")
    assert(type(fn) == "function", "第一个参数必须是函数")

    local newValue = args[#args] -- 最后一个参数是新值
    local pathNames = {}
    for i = 1, #args - 1 do
        table.insert(pathNames, args[i])
    end

    local val, current_fn, i = FN.FindUpvalue(fn, unpack(pathNames))
    if i == nil then
        return false
    end
    debug.setupvalue(current_fn, i, newValue)
    return true
end

local function FunctionTest(fn, file, test, source, listener)
    if fn and type(fn) ~= "function" then return false end
    local data = debug.getinfo(fn)
    if file and type(file) == "string" then --文件名判定
        local matchstr = "/" .. file .. ".lua"
        if not data.source or not data.source:match(matchstr) then
            return false
        end
    end
    if test and type(test) == "function" and not test(data, source, listener) then return false end --测试通过
    return true
end

function FN.GetEventHandle(inst, event, file, test)
    if type(inst) == "table" then
        if inst.event_listening and inst.event_listening[event] then --遍历他在监听的事件 我在监听谁
            local listenings = inst.event_listening[event]
            for listening, fns in pairs(listenings) do               --遍历被监听者
                if fns and type(fns) == "table" then
                    for _, fn in pairs(fns) do
                        if FunctionTest(fn, file, test, listening, inst) then --寻找成功就返回
                            return fn
                        end
                    end
                end
            end
        end

        if inst.event_listeners and inst.event_listeners[event] then --遍历监听他的事件的    谁在监听我
            local listeners = inst.event_listeners[event]
            for listener, fns in pairs(listeners) do                 --遍历监听者
                if fns and type(fns) == "table" then
                    for _, fn in pairs(fns) do
                        if FunctionTest(fn, file, test, inst, listener) then --寻找成功就返回
                            return fn
                        end
                    end
                end
            end
        end
    end
end

--花花写的
function FN.GetWorldHandle(inst, var, file) --补充一下风铃草大佬没写的关于世界监听函数,随便写的,感觉太菜就憋着别说 --咸鱼说的
    if type(inst) == "table" then
        local watchings = inst.worldstatewatching and inst.worldstatewatching[var] or nil
        if watchings then
            for _, fn in pairs(watchings) do
                if FunctionTest(fn, file) then --寻找成功就返回
                    return fn
                end
            end
        end
        --另一个获取的路径是 TheWorld.components.worldstate,不过没差了
    end
end

return FN
