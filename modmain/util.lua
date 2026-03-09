-- 把一个键值表添加到另一个键值表中
function table.promerge(tbl, vs)
    for i, v in pairs(vs) do
        tbl[i] = v
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

function table.prodeep_merge(target, add_table, override)
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

            table.prodeep_merge(target[k], v, override)
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

function table.proinserttable(tab, vs)
    for _, v in pairs(vs) do
        table.insert(tab, v)
    end
end

function table.proinserttable_unique(tab, vs)
    for _, v in pairs(vs) do
        if not table.contains(tab, v) then
            table.insert(tab, v)
        end
    end
end

function table.proremove_components(tbl, vs)
    -- 从后向前遍历 tbl
    for i = #tbl, 1, -1 do
        for k, w in pairs(vs) do
            if tbl[i] == w then
                table.remove(tbl, i)
                break
            end
        end
    end
end

-- 移除数组中指定的值
function table.proremovearrayvalue(t, value)
    for i = #t, 1, -1 do
        if t[i] == value then
            table.remove(t, i)
        end
    end
end

-- 移除数组中给定列表的所有值
function table.proremovearrayvalues(t, vs)
    for _, v in pairs(vs) do
        table.proremovearrayvalue(t, v)
    end
end