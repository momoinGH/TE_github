--[[
mod前缀名：tro_

TroErrorHandle：错误处理，可打印堆栈可设置仅开发环境崩溃
trosafemodimport：允许一个文件重复导入，不会崩溃
troimportmodulefile：提供一个模块目录下的相对路径，自动导入启用的所有模块的文件


TroRemapLayoutTile：重新映射layout里地皮id对应的地皮


TroRemapSound：重新映射音效路径


TroRemapOverrideSymbol：对每个预制件的OverrideSymbol的参数重新映射


TroAddRecipe：对AddRecipe2的一层封装，可以进行校验，因此添加配方请用这个，不要用AddRecipe2
TroAddTech：添加新科技
TroAddPrototyperDef：注册原型机的科技
TroUpdateCookingIngredientTags：更新已有食材的标签值


TroAddPlayerClassifiedNetVar：在player_classified上面新增网络变量


constants.lua文件还定义了很多全局函数

TUNING.tropical mod设置数据



每个模块自动导入的文件：
tuning、prefablist、assets、containers、ui、prefabpost、sg、recipes、cooking、rpc、input、skins
不在模块下的内容是公共的部分，最好通过标签或者变量识别功能，减少特定prefab的判断




debug文件定义了很多c_xxx函数，用于控制台调试
默认开启了右键地图传送功能，可通过c_setmaprightteleport(false)关闭


有些方法不得不覆盖写法，这类覆盖的地方加上"#NeedUpdate"注释，方便日后更新时搜索


暴食相关内容通过抄暴食模组1918927570补充
]]


----------------------------------------------------------------------------------------------------
GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

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
modimport "modmain/gentuning"
modimport "modmain/knownmodcheck"         -- 检测不兼容模组并报错崩溃
modimport "modmain/mods"                  -- 兼容其他mod
if troisdev then
    modimport "modmain/main_check_before" --开发环境校验，检查不合规或者忘写的数据，防止游戏执行那部分代码时崩溃
end
modimport "modmain/error_prevent"         --预防一些崩溃情况，正式环境也需要
modimport "modmain/animstate"             -- AnimState 增强
modimport "modmain/minimapentity"
modimport "modmain/soundemitter"
modimport "modmain/ents_trace"            --缓存记录一些需要全局查找的实体
modimport "modmain/player_classified"     --为player_classified添加网络变量提供便捷
modimport "modmain/class"                 --修复class继承上的一些bug
modimport "modmain/cansleep_periodictask" --提供一个TroDoCanSleepPeriodicTask方法可以开启可休眠的周期任务
modimport "modmain/save_tag.lua"          --提供一个EntityScript:TroAddSaveTag方法，该方法添加的标签会自动保存和加载
modimport "modmain/mainfunctions.lua"

-- 文本
local language = string.lower(GetModConfigData("language"))
trosafemodimport("modmain/languages/strings_en") --英文版本兜底，不使用的台词不应该添加
trosafemodimport("modmain/languages/strings_" .. language)
trosafemodimport("modmain/languages/modwiki_zh") -- 其他语言的wiki先不管

modimport("modmain/constants")                   --一些全局变量、全局函数
modimport "modmain/ocean_util"                   --海洋相关的一些全局函数
modimport "modmain/ocean_style"                  --修改海洋地皮风格
modimport("modmain/actions")                     --action相关
modimport("modmain/actions_post")                --修改原版action
modimport("modmain/componentactions")            --componentactions相关

modimport("modmain/preparedfoods_tro")           --注入式生成料理

troimportmodulefile("tuning") --定义的常量

--PrefabFiles 这里直接选择加载全部预制件，因为布局里掺杂其他模块的预制件很常见
local all_prefab_files = PrefabFiles or {}
troimportmodulefile("prefablist", true, function()
    PrefabFiles = {}
end, function()
    all_prefab_files = ArrayUnion(all_prefab_files, PrefabFiles)
end)
PrefabFiles = all_prefab_files
all_prefab_files = nil


--注册全局资产
local all_assets = Assets or {}
troimportmodulefile("assets", false, function()
    Assets = {}
end, function()
    ConcatArrays(all_assets, Assets)
end)
Assets = all_assets
all_assets = nil

troimportmodulefile("simutil")
troimportmodulefile("containers") --定义容器
troimportmodulefile("ui")         --UI相关
troimportmodulefile("prefabpost") --组件、预制件的修改
troimportmodulefile("sg")         --Stategraph相关
troimportmodulefile("recipes")    --配方相关
troimportmodulefile("cooking")    --料理相关


modimport("modmain/rpc")           --RPC的注册
modimport("modmain/skins")         --物品皮肤
modimport("modmain/scrapbookwiki") -- 图鉴wiki
modimport("modmain/character")     --添加角色，角色相关变量定义
modimport("modmain/fx")            --特效

if troisdev then
    modimport "modmain/log_panel"        --新增一个日志面板，按F11打开，并且对一对函数进行安全hook，报错时只打印不让游戏崩溃
    troimportmodulefile("debug")         --方便开发的c_xxx控制台函数
    modimport "modmain/main_check_after" --开发环境校验，检查不合规或者忘写的数据，防止游戏执行那部分代码时崩溃
end

----------------------------------------------------------------------------------------------------
-- 还原、追加到游戏里

TroPlayerClassifiedNetVarEnd()

env.modimport = old_modimport
old_modimport = nil
modulename_loaded = nil

----------------------------------------------------------------------------------------------------
