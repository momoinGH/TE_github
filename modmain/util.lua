-- 把一个键值表添加到另一个键值表中
function table.tromerge(tbl, vs)
    for k, v in pairs(vs) do
        tbl[k] = v
    end
    return tbl
end

local function is_array(t)
    if type(t) ~= "table" or not next(t) then
        return false
    end

    local n = #t
    for i, v in pairs(t) do
        if type(i) ~= "number" or i <= 0 or i > n then
            return false
        end
    end

    return true
end

function table.trodeep_merge(target, add_table, override)
    target = target or {}

    for k, v in pairs(add_table) do
        if type(v) == "table" then
            if not target[k] then
                target[k] = {}
            elseif type(target[k]) ~= "table" then
                if override then
                    target[k] = {}
                else
                    error("Can not override" .. k .. " to a table")
                end
            end

            table.trodeep_merge(target[k], v, override)
        else
            if is_array(target) and not override then
                table.insert(target, v)
            elseif not target[k] or override then
                target[k] = v
            end
        end
    end

    return target
end

function table.troinserttable(tab, vs)
    for _, v in pairs(vs) do
        table.insert(tab, v)
    end
end

function table.troinserttable_unique(tab, vs)
    for _, v in pairs(vs) do
        if not table.contains(tab, v) then
            table.insert(tab, v)
        end
    end
end

-- 移除数组中指定的值
function table.troremovearrayvalue(t, value)
    for i = #t, 1, -1 do
        if t[i] == value then
            table.remove(t, i)
        end
    end
end

-- 移除数组中给定列表的所有值
function table.troremovearrayvalues(t, vs)
    for _, v in pairs(vs) do
        table.troremovearrayvalue(t, v)
    end
end

----------------------------------------------------------------------------------------------------

-- 字符串拼接，相比直接string.format更简洁，并且参数为nil不会报错，需要注意参数少了对不上$个数还是会报错
-- 示例string.trofmt(房子大小x:{},y:{}, 2,3)
function string.trofmt(str, ...)
    local args = { ... }
    for i = 1, select('#', ...) do  --获取所有参数，包括nil
        args[i] = tostring(args[i]) --把表和None都转成字符串，不希望报错
    end
    return string.format(str:gsub("{}", "%%s"), unpack(args))
end

----------------------------------------------------------------------------------------------------
-- 三元运算函数，因为and or不能充当三元
function Ternary(a, b, c)
    if a then
        return b
    else
        return c
    end
end

GLOBAL.Ternary = Ternary
