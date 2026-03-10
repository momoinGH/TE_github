local FN = {}

---排除浮点数比较的误差
FN.EPSILON = 1e-10

---获取配置用的
function FN.GetVal(tab, k, default, getDefaultFn)
    if not tab or tab[k] == nil then
        return getDefaultFn and getDefaultFn() or default
    end
    return tab[k]
end

---根据当前朝向和前进距离计算最终落点
function FN.GetPositionForward(inst, distance)
    if inst == nil then
        return nil
    end

    local rot = inst:GetRotation() * DEGREES
    local pos = inst:GetPosition()
    return pos + Vector3(distance * math.cos(rot), 0, -distance * math.sin(rot)) --z轴需要反过来
end

function FN.IsHUDScreen()
    return TheFrontEnd:GetActiveScreen() and type(TheFrontEnd:GetActiveScreen().name) == "string" and
        TheFrontEnd:GetActiveScreen().name == "HUD"
end

---玩家是否可以做其他事，当前是否处于游戏界面非幽灵非打字
function FN.IsDefaultScreen()
    return FN.IsHUDScreen()
        -- 非幽灵
        and ThePlayer and not ThePlayer:HasTag("playerghost")
        -- 非打字
        and not ThePlayer.HUD:IsChatInputScreenOpen() and not ThePlayer.HUD.writeablescreen
        -- 非制作栏搜索
        and not ThePlayer.HUD:HasInputFocus()
    --非骑行
    --and not (ThePlayer.replica.rider and ThePlayer.replica.rider:IsRiding())
end



---在StateGraph中根据timline的time获取timeline对应的索引，通过time来查找自己要替换的TimeEvent比直接翻源码查索引要好一点儿，因为别的mod可能会中间插入其他的TimeEvent
---@param timeline table sg的timeline表
---@param time number TimeEvent的time，一般是 数字*FRAMES
---@return integer|nil
function FN.GetStateTimelineIndex(timeline, time)
    for i, timeEvent in ipairs(timeline) do
        if timeEvent.time - time < FN.EPSILON then
            return i
        end
    end
end

local function Chronological(a, b)
    return a.time < b.time
end

---- 为已有的timeline添加新的timeline并排序
function FN.AddStateTimeline(timeline, data)
    for _, tl in ipairs(data) do
        table.insert(timeline, tl)
        table.sort(timeline, Chronological)
    end
end

----------------------------------------------------------------------------------------------------

---把秒数换算成分秒，例如 121 -> 2:01
---@param seconds number
---@return string
function FN.FormatTime(seconds)
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = seconds % 60
    return string.format("%d:%02d", minutes, remainingSeconds)
end

----------------------------------------------------------------------------------------------------
---打印table
---@param count number|nil 递归层数，如果表的层级较高，控制这个数值来决定打印的层级，默认1
---@param current nil 不用填，递归需要
function FN.PT(tab, count, current)
    count = count or 1
    current = current or 1
    if current == 1 then
        print("{")
    end

    if type(tab) ~= "table" then
        return tab
    end

    for k, v in pairs(tab) do
        if current == 1 then
            io.write("  ")
        end

        if type(k) == "table" and current < count then
            io.write("{")
            FN.PT(k, count, current + 1)
            io.write("}")
        else
            if type(k) == "number" then
                io.write("[" .. tostring(k) .. "]")
            else
                io.write(tostring(k))
            end
        end
        io.write(" = ")

        if type(v) == "table" and current < count then
            io.write("{")
            FN.PT(v, count, current + 1)
            io.write("}")
        else
            io.write(tostring(v))
        end

        io.write(", ")
        if current == 1 then
            io.write("\n")
        end
    end
    if current == 1 then
        print("}")
    end
end

--- 两个数字是否相等，参数不能为nil
function FN.NumberEquals(num1, num2)
    return math.abs(num1 - num2) < FN.EPSILON
end

---从数值表中随机选取num个元素
---@param tab table 数值表
---@param num number|nil 需要的元素个数
---@param isRepeatable boolean|nil 是否可重复选择同一个索引处的元素，如果不能重复并且表的长度不够num的话选择表的所有元素
function FN.GetRandomList(tab, num, isRepeatable)
    local res = {}
    local len = #tab
    if not isRepeatable and num >= len then
        return shallowcopy(tab)
    end

    if isRepeatable then
        for i = 1, num do
            local index = math.random(1, len)
            table.insert(res, tab[index])
        end
    else
        local shuffled = shallowcopy(tab)
        for i = 1, num do
            local j = math.random(i, len)
            shuffled[i], shuffled[j] = shuffled[j], shuffled[i] --洗牌
            table.insert(res, shuffled[i])
        end
    end
    return res
end

---根据权重选出不重复的
---@param choices table
---@param num_choices number
---@param isRepeatable boolean|nil
---@return table
function FN.WeightedRandomChoices(choices, num_choices, isRepeatable)
    local picks = {}

    local totalWeight = 0
    local count = 0
    local copyChoices = {}

    for k, weight in pairs(choices) do
        totalWeight = totalWeight + weight
        count = count + 1
        copyChoices[k] = weight
    end

    -- 数量不够并且不能重复
    if not isRepeatable and count <= num_choices then
        for k, _ in pairs(choices) do
            table.insert(picks, k)
            return picks
        end
    end

    for i = 1, num_choices do
        local pick, w
        local threshold = math.random() * totalWeight
        for choice, weight in pairs(copyChoices) do
            threshold = threshold - weight
            pick = choice
            w = weight
            if threshold <= 0 then
                break
            end
        end

        totalWeight = totalWeight - w
        choices[pick] = nil
        table.insert(picks, pick)
    end

    return picks
end

return FN
