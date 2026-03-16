--[[
mod前缀名：tro_

TroErrorHandle：错误处理，可打印堆栈可设置仅开发环境崩溃
trodevassert：仅开发环境崩溃的断言
trosafemodimport：允许一个文件重复导入，不会崩溃
troimportmodulefile：提供一个模块目录下的相对路径，自动导入启用的所有模块的文件

TroRemapLayoutTile：重新映射layout里地皮id对应的地皮

TroRemapSound：重新映射音效路径

TroRemapOverrideSymbol：对每个预制件的OverrideSymbol的参数重新映射

TUNING.tropical mod设置数据
TUNING.TE_WORLDGEN 世界生成相关数据

每个模块自动导入的文件：
tuning、prefablist、assets、containers、ui、prefabpost、sg、recipes、cooking、rpc、input、skins

]]


----------------------------------------------------------------------------------------------------
GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })
Constructor = require("tropical_utils/constructor")
Constructor.SetEnv(env)

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
TroOnConfigLoaded()
modimport "modmain/knownmodcheck"             -- 检测不兼容模组并报错崩溃
modimport "modmain/mods"                      -- 兼容其他mod
if troisdev then
    modimport "modmain/data_validator_before" --开发环境校验，检查不合规或者忘写的数据，防止游戏执行那部分代码时崩溃
end

modimport "modmain/postinit"  --TODO 拆分一下
modimport "modmain/animstate" -- AnimState 增强
modimport "modmain/soundemitter"

-- 文本
local language = string.lower(GetModConfigData("language"))
trosafemodimport("modmain/languages/strings_en") --英文版本兜底，不使用的台词不应该添加
trosafemodimport("modmain/languages/strings_" .. language)
trosafemodimport("modmain/languages/modwiki_zh") -- 其他语言的wiki先不管


troimportmodulefile("tuning") --定义的常量


modimport("modmain/constants")        --一些全局变量、全局函数
modimport("modmain/actions")          --action相关
modimport("modmain/actions_post")     --修改原版action
modimport("modmain/componentactions") --componentactions相关


--PrefabFiles
local ALL_PREFAB_FILES = PrefabFiles or {}
troimportmodulefile("prefablist", false, function()
    PrefabFiles = {}
end, function()
    -- 检查PrefabFiles里有没有写重复
    -- 不是很实用，因为有些独立的模块可以table.insert(PrefabFiles)来增加自己需要的预制件，这个检查时不时开一下就行
    -- local prefabs_dirty = {}
    -- for _, prefab in ipairs(PrefabFiles) do
    --     if prefabs_dirty[prefab] then
    --         TroErrorHandle(dirc .. "模块的PrefabFiles里预制件写重了，写重的是" .. prefab, false, false)
    --     end
    --     prefabs_dirty[prefab] = true
    -- end

    ALL_PREFAB_FILES = ArrayUnion(ALL_PREFAB_FILES, PrefabFiles)
end)
PrefabFiles = ALL_PREFAB_FILES
ALL_PREFAB_FILES = nil


--注册全局资产
local ALL_ASSETS = Assets or {}
troimportmodulefile("assets", false, function()
    Assets = {}
end, function()
    -- 检查Assets里有没有写重复
    -- local assets_dirty = {}
    -- for _, asset in ipairs(Assets) do
    --     local s = asset.type .. ":" .. asset.file
    --     if assets_dirty[s] then
    --         TroErrorHandle(dirc .. "模块的Assets里预制件写重了，写重的是" .. s, false, false)
    --     end
    --     assets_dirty[s] = true
    -- end
    ConcatArrays(ALL_ASSETS, Assets)
end)
Assets = ALL_ASSETS
ALL_ASSETS = nil


troimportmodulefile("containers") --定义容器
troimportmodulefile("ui")         --UI相关
troimportmodulefile("prefabpost") --组件、预制件的修改
troimportmodulefile("sg")         --Stategraph相关
troimportmodulefile("recipes")    --配方相关
troimportmodulefile("cooking")    --料理相关
troimportmodulefile("rpc")        --RPC的注册
troimportmodulefile("input")      --客机操作的监听
troimportmodulefile("skins")      --物品皮肤


modimport("modmain/scrapbookwiki") -- 图鉴wiki
modimport("modmain/character")     --添加角色，角色相关变量定义
modimport("modmain/fx")            --特效

----------------------------------------------------------------------------------------------------

if troisdev then
    modimport "modmain/data_validator_after" --开发环境校验，检查不合规或者忘写的数据，防止游戏执行那部分代码时崩溃
end

env.modimport = old_modimport
old_modimport = nil
modulename_loaded = nil
