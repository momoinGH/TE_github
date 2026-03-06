--[[
mod前缀名：pro_

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

modimport "modmain/dev_utils"                        --开发环境下辅助用的函数
modimport "modmain/data_validator_before"            --校验器，检查不合规或者忘写的数据，防止游戏执行那部分代码时崩溃
modimport "modmain/mods/knownmodcheck"               -- 检测不兼容模组并报错崩溃
modimport "modmain/animstate"                        -- AnimState 增强
modimport "modmain/standardcomponents"
modimport "scripts/prefabs/tropical_farm_plant_defs" --定义新植物
modimport "modmain/sw_fertilizer_nutrient_defs"      --肥料值定义
modimport "modmain/natureskin_variants"              --和自然皮肤切换相关的所有内容
modimport "modmain/wx78_moduledefs"
modimport "modmain/pro_componentaction"              --一个功能比较强大的组件，可以在预制件里定义ACTION的逻辑


modimport "modmain/postinit"          --TODO 拆到各个模块中

modimport "modmain/mods/action_queue" -- 兼容其他mod
modimport "modmain/modules"           --模块导入
----------------------------------------------------------------------------------------------------

for actiontype, components in pairs(TRO_COMPONENT_ACTIONS) do
    for component, fns in pairs(components) do
        AddComponentAction(actiontype, component, function(...)
            for _, fn in ipairs(fns) do fn(...) end
        end)
    end
end
TRO_COMPONENT_ACTIONS = nil
modimport "modmain/data_validator_after" --校验器，检查不合规或者忘写的数据，防止游戏执行那部分代码时崩溃
