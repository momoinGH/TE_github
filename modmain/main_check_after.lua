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
            TroErrorHandle("STRINGS.NAMES." .. uppername .. "未赋值，生成蓝图时会报错", false)
        end
    end
end)

-- 防止制作栏文本忘记写导致游戏崩溃
for name, _ in ipairs(CRAFTING_FILTERS) do
    if not STRINGS.UI.CRAFTING_FILTERS[name] then
        STRINGS.UI.CRAFTING_FILTERS[name] = "STRINGS.UI.CRAFTING_FILTERS." .. name .. "未赋值"
        TroErrorHandle("STRINGS.UI.CRAFTING_FILTERS." .. name .. "未赋值，点击制作栏时会报错", false)
    end
end

----------------------------------------------------------------------------------------------------
-- 对于推送常见事件data的补充，避免有些地方推送事件参数类型不对导致崩溃
-- 一些常见的含有data的事件
-- local need_data_events = {
--     death = true,
--     onattackother = true,
--     onmissother = true,
--     attacked = true,
--     itemget = true,
--     itemlose = true,
--     timerdone = true,
--     picked = true,
--     worked = true,
--     equip = true,
--     unequip = true,
--     onbuilt = true,
--     healthdelta = true,
--     sanitydelta = true,
--     hungerdelta = true,
--     equipped = true,
--     unequipped = true,
-- }

-- -- 这些都是科雷会销毁的
-- local ignore_remove_events = {
--     entitysleep = true,
--     animover = true,
--     timerdone = true,
--     animqueueover = true,
--     on_landed = true,
-- }

-- local OldPushEvent = EntityScript.PushEvent
-- function EntityScript:PushEvent(event, data, ...)
--     if event and need_data_events[event] and not (data == nil or type(data) == "table") then
--         TroErrorHandle("事件" .. tostring(event) .. "的参数" .. tostring(data) .. "不是table也不为空，可能导致游戏崩溃", true)
--     end

--     -- 不能在事件毁掉里销毁实体
--     local is_valid_before = self.IsValid and self:IsValid()
--     local res = OldPushEvent(self, event, data, ...)
--     if event and not ignore_remove_events[event] and is_valid_before and not (self.IsValid and self:IsValid()) and TheWorld and TheWorld.ismastersim then
--         TroErrorHandle(string.trofmt("{}对象在{}事件中被销毁，这容易导致游戏崩溃，请使用DoTaskIntime(0,inst.Remove)来销毁", self, event), true)
--     end
--     return res
-- end

----------------------------------------------------------------------------------------------------
-- 检查状态机的重复注册
for _, name in ipairs({
    "wilson",
    "wilson_client"
}) do
    AddStategraphPostInit(name, function(self)
        local actions = {}
        for k, modhandlers in pairs(ModManager:GetPostInitData("StategraphActionHandler", self.name)) do
            for i, v in ipairs(modhandlers) do
                if actions[v.action] then
                    TroErrorHandle(name .. "状态机对ACTIONS." .. v.action.id .. "重复注册，会导致相互覆盖，请hook对应的函数", true)
                end
                actions[v.action] = true
            end
        end

        local events = {}
        for k, modhandlers in pairs(ModManager:GetPostInitData("StategraphEvent", self.name)) do
            for i, v in ipairs(modhandlers) do
                if events[v.name] then
                    TroErrorHandle(name .. "状态机对事件" .. v.name .. "重复注册，会导致相互覆盖，请hook对应的函数", true)
                end
                events[v.name] = true
            end
        end

        local states = {}
        for k, modhandlers in pairs(ModManager:GetPostInitData("StategraphState", self.name)) do
            for i, v in ipairs(modhandlers) do
                if states[v.name] then
                    TroErrorHandle(name .. "状态机对状态" .. v.name .. "重复注册，会导致相互覆盖，请hook对应的函数", true)
                end
                states[v.name] = true
            end
        end
    end)
end

----------------------------------------------------------------------------------------------------

for _, m in pairs(tro_modules) do
    assert(TUNING.tropical[m] ~= nil, "你忘了给TUNING.tropical." .. m .. "变量赋值了，这个值用来决定模块的启用状态")
end
