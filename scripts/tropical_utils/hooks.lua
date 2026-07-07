local FN = {}

---函数装饰器，增强原有函数的时候可以使用
---@param beforeFn function|nil 先于fn执行，参数为fn参数，返回三个值：新返回值表、是否跳过旧函数执行，旧函数执行参数（要求是表，会用unpack解开）
---@param afterFn function|nil 晚于fn执行，第一个参数为前面执行后的返回值表，后续为fn的参数，返回值作为最终返回值（要求是表或nil，会用unpack解开）
---@param isUseBeforeReturn boolean|nil 在没有afterFn却有beforeFn的时候，是否采用beforeFn的返回值作为最终返回值，默认以原函数的返回值作为最终返回值
function FN.FnDecorator(obj, key, beforeFn, afterFn, isUseBeforeReturn)
    if not ((type(obj) == "table") and (beforeFn == nil or type(beforeFn) == "function") and (afterFn == nil or type(afterFn) == "function")) then
        TroErrorHandle(string.trofmt("FN.FnDecorator 参数不合法, obj:{}, beforeFn:{},afterFn:{}", obj, beforeFn, afterFn))
    end

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

local function GetUpValueImpl(fn, upvalueName, level)
    level = level or 5
    local i = 1
    local fns = {}

    -- 先找第一层函数里有没有
    while true do
        local name, value = debug.getupvalue(fn, i)
        print("find", name, value)
        if not name then break end -- 没有更多的upvalue了
        if name == upvalueName then
            return value, i
        end
        if level > 0 and type(value) == "function" then
            table.insert(fns, value)
        end
        i = i + 1
    end

    -- 每个函数里再找下去
    for _, f in ipairs(fns) do
        local value, index = GetUpValueImpl(f, upvalueName, level - 1)
        if value then
            return value, index
        end
    end

    return nil, nil
end

---链式查询上值，找不到就返回nil，这个是链式的
function FN.GetUpValue(fn, ...)
    if type(fn) ~= "function" then
        TroErrorHandle("第一个参数必须是函数")
        return nil, nil, nil
    end

    local val, i, current_fn
    val = fn
    for _, name in ipairs({ ... }) do
        current_fn = val
        val, i = GetUpValueImpl(current_fn, name)
        if i == nil then
            return nil, nil, nil
        end
    end
    return val, current_fn, i
end

--- 替换上值，参数为路径，最后一个参数为要替换的新值
--- 影响是全局的，其他要调用被替换的函数时也会去调用这个新值
function FN.SetUpvalue(fn, ...)
    local args = { ... }
    if not (#args >= 2 and type(fn) == "function") then
        TroErrorHandle("至少需要两个参数并且第一个参数为函数")
        return false
    end

    local newValue = args[#args] -- 最后一个参数是新值
    local pathNames = {}
    for i = 1, #args - 1 do
        table.insert(pathNames, args[i])
    end

    local val, current_fn, i = FN.GetUpValue(fn, unpack(pathNames))
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

-- 根据定义的文件获取事件回调函数，尽量少用，因为文件里定义多个监听时获取的不一定是自己想要的
-- 可以使用require预制件文件用GetUpvalue拿到回调
function FN.GetEventCallback(inst, event, source, source_file, test_fn)
    source = source or inst
    local listener_fns = inst.event_listening and inst.event_listening[event] and inst.event_listening[event][source]
    if not listener_fns then return end

    for _, fn in ipairs(listener_fns) do
        if source_file then
            local info = debug.getinfo(fn, "S")
            if info and (info.source == source_file) and (not test_fn or test_fn(fn)) then
                return fn
            end
        elseif (not test_fn or test_fn(fn)) then
            return fn
        end
    end
end

return FN
