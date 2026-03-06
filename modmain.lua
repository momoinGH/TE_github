--[[
mod前缀名：pro_
TRO_AddComponentAction：添加ComponentAction，允许组件行为重复
]]

----------------------------------------------------------------------------------------------------
GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })
Utils = require("tropical_utils/utils")
Constructor = require("tropical_utils/constructor")
Constructor.SetEnv(env)

local TRO_COMPONENT_ACTIONS = {
    SCENE = {},
    USEITEM = {},
    POINT = {},
    EQUIPPED = {},
    INVENTORY = {}
}

-- 封装的AddComponentAction，同样的type和组件也不会被覆盖
function TRO_AddComponentAction(actiontype, component, fn)
    TRO_COMPONENT_ACTIONS[actiontype][component] = TRO_COMPONENT_ACTIONS[actiontype][component] or {}
    table.insert(TRO_COMPONENT_ACTIONS[actiontype][component], fn)
end

----------------------------------------------------------------------------------------------------

modimport "modmain/dev_utils"             --开发环境下辅助用的函数，与游戏无关
modimport "modmain/data_validator_before" --开发环境校验，检查不合规或者忘写的数据，防止游戏执行那部分代码时崩溃
modimport "modmain/mods/knownmodcheck"    -- 检测不兼容模组并报错崩溃
modimport "modmain/mods/action_queue"     -- 兼容其他mod

-- 共同
modimport "modmain/postinit" --TODO 拆到各个模块中

modimport "modmain/modules"  --模块导入
----------------------------------------------------------------------------------------------------

for actiontype, components in pairs(TRO_COMPONENT_ACTIONS) do
    for component, fns in pairs(components) do
        AddComponentAction(actiontype, component, function(...)
            for _, fn in ipairs(fns) do fn(...) end
        end)
    end
end
TRO_COMPONENT_ACTIONS = nil
modimport "modmain/data_validator_after" --开发环境校验，检查不合规或者忘写的数据，防止游戏执行那部分代码时崩溃
