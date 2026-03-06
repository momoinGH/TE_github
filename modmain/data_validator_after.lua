--对于忘记写STRINGS.NAMES.XXX的配方，在prefabs/blueprint.lua生成蓝图时会崩溃
local function CanBlueprintRandomRecipe(recipe)
    if recipe.nounlock or recipe.builder_tag ~= nil then
        --Exclude crafting station and character specific
        return false
    end
    local hastech = false
    for k, v in pairs(recipe.level) do
        if v >= 10 then
            --Exclude TECH.LOST
            return false
        elseif v > 0 then
            hastech = true
        end
    end
    --Exclude TECH.NONE
    return hastech
end

AddRecipePostInitAny(function(v)
    if (v.require_special_event == nil or IsSpecialEventActive(v.require_special_event))
        and CanBlueprintRandomRecipe(v)
    then
        local uppername = string.upper(v.name)
        if not STRINGS.NAMES[uppername] then
            STRINGS.NAMES[uppername] = "STRINGS.NAMES." .. uppername .. "未赋值"
            ProErrorHandle("STRINGS.NAMES." .. uppername .. "未赋值，生成蓝图时会报错", false, false)
        end
    end
end)

-- 防止制作栏文本忘记写导致游戏崩溃
for name, _ in ipairs(CRAFTING_FILTERS) do
    if not STRINGS.UI.CRAFTING_FILTERS[name] then
        STRINGS.UI.CRAFTING_FILTERS[name] = "STRINGS.UI.CRAFTING_FILTERS." .. name .. "未赋值"
        ProErrorHandle("STRINGS.UI.CRAFTING_FILTERS." .. name .. "未赋值，点击制作栏时会报错", false, false)
    end
end

----------------------------------------------------------------------------------------------------
-- 对于推送常见事件data的补充，避免有些地方推送事件参数类型不对导致崩溃
if proisdev then
    -- 一些常见的含有data的事件
    local need_data_events = {
        death = true,
        onattackother = true,
        onmissother = true,
        attacked = true,
        itemget = true,
        itemlose = true,
        timerdone = true,
        picked = true,
        worked = true,
        equip = true,
        unequip = true,
        onbuilt = true,
        healthdelta = true,
        sanitydelta = true,
        hungerdelta = true,
        equipped = true,
        unequipped = true,
    }

    local OldPushEvent = EntityScript.PushEvent
    EntityScript.PushEvent = function(inst, event, data, ...)
        if event and need_data_events[event] and not (data == nil or type(data) == "table") then
            ProErrorHandle("事件" .. tostring(event) .. "的参数" .. tostring(data) .. "不是table也不为空，可能导致游戏崩溃", true, true)
        end
        return OldPushEvent(inst, event, data, ...)
    end
end

----------------------------------------------------------------------------------------------------
-- 对象销毁时不能执行定时任务
if proisdev then
    local old_DoTaskInTime = EntityScript.DoTaskInTime
    function EntityScript:DoTaskInTime(...)
        if self.IsValid and not self:IsValid() then
            ProErrorHandle("对象" .. tostring(self) .. "在移除后仍然执行DoTaskInTime，这可能导致游戏崩溃", true, true)
            return
        end
        return old_DoTaskInTime(self, ...)
    end

    local old_DoPeriodicTask = EntityScript.DoPeriodicTask
    function EntityScript:DoPeriodicTask(...)
        if self.IsValid and not self:IsValid() then
            ProErrorHandle("对象" .. tostring(self) .. "在移除后仍然执行DoPeriodicTask，这可能导致游戏崩溃", true, true)
            return
        end
        return old_DoPeriodicTask(self, ...)
    end
end
