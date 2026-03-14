--[[
mod前缀名：pro_

ProErrorHandle：错误处理，可打印堆栈可设置仅开发环境崩溃
prodevassert：仅开发环境崩溃的断言
prosafemodimport：允许一个文件重复导入，不会崩溃
proimportmodulefile：提供一个模块目录下的相对路径，自动导入启用的所有模块的文件

TRO_AddComponentAction：添加ComponentAction，允许组件行为重复

RemapLayoutTile：重新映射layout里地皮id对应的地皮

RemapSound：重新映射音效路径

TUNING.tropical mod设置数据
TUNING.TE_WORLDGEN 世界生成相关数据
]]

print("执行modmain", GetModConfigData("vampirebatcave"))


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

-- 允许一个文件重复导入，这样多个模块导入同一个文件就不会执行多次了
local modulename_loaded = {}
local old_modimport = env.modimport
env.modimport = function(modulename, ...)
    if string.sub(modulename, #modulename - 3, #modulename) ~= ".lua" then
        modulename = modulename .. ".lua"
    end
    if modulename_loaded[modulename] then
        return
    end
    modulename_loaded[modulename] = true
    return old_modimport(modulename, ...)
end

----------------------------------------------------------------------------------------------------
modimport "modmain/knownmodcheck"             -- 检测不兼容模组并报错崩溃
modimport "modmain/mods"                      -- 兼容其他mod
if proisdev then
    modimport "modmain/data_validator_before" --开发环境校验，检查不合规或者忘写的数据，防止游戏执行那部分代码时崩溃
end

-- 共同
modimport "modmain/postinit" --TODO 拆到各个模块中

modimport "modmain/soundemitter"
modimport "modmain/modules" --模块导入
----------------------------------------------------------------------------------------------------

if proisdev then
    modimport "modmain/data_validator_after" --开发环境校验，检查不合规或者忘写的数据，防止游戏执行那部分代码时崩溃
end

for actiontype, components in pairs(TRO_COMPONENT_ACTIONS) do
    for component, fns in pairs(components) do
        AddComponentAction(actiontype, component, function(...)
            for _, fn in ipairs(fns) do fn(...) end
        end)
    end
end
TRO_COMPONENT_ACTIONS = nil

env.modimport = old_modimport
old_modimport = nil
modulename_loaded = nil
