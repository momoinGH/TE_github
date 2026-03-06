local ALL_PREFAB_FILES = {}
local ALL_ASSETS = {}
local language = string.lower(GetModConfigData("language"))
WIKI_DATA = {}

--- 导入对应模块的文件，不需要的文件可以不存在
local function Modimport(dirc)
    modimportmodulefile("modmain/" .. dirc .. "/tuning")               --定义的变量
    modimportmodulefile("modmain/" .. dirc .. "/constants")            --一些全局变量、全局函数
    modimportmodulefile("modmain/" .. dirc .. "/prefablist")           --Prefabs中追加预制件
    modimportmodulefile("modmain/" .. dirc .. "/assets")               --注册资产
    modimportmodulefile("modmain/" .. dirc .. "/languages/strings_en") --英文版本兜底，不使用的台词不应该添加
    modimportmodulefile("modmain/" .. dirc .. "/languages/strings_" .. language)
    modimportmodulefile("modmain/" .. dirc .. "/languages/modwiki_zh") -- 其他语言的wiki先不管
    modimportmodulefile("modmain/" .. dirc .. "/containers")           --定义容器
    modimportmodulefile("modmain/" .. dirc .. "/character")            --添加角色，角色相关变量定义
    modimportmodulefile("modmain/" .. dirc .. "/ui")                   --UI相关
    modimportmodulefile("modmain/" .. dirc .. "/prefabpost")           --组件、预制件的修改
    modimportmodulefile("modmain/" .. dirc .. "/fx")                   --特效
    modimportmodulefile("modmain/" .. dirc .. "/actions")              --action相关
    modimportmodulefile("modmain/" .. dirc .. "/componentactions")     --componentactions相关
    modimportmodulefile("modmain/" .. dirc .. "/sg")                   --Stategraph相关
    modimportmodulefile("modmain/" .. dirc .. "/recipes")              --配方相关
    modimportmodulefile("modmain/" .. dirc .. "/cooking")              --料理相关
    modimportmodulefile("modmain/" .. dirc .. "/rpc")                  --RPC的注册
    modimportmodulefile("modmain/" .. dirc .. "/input")                --客机操作的监听
    modimportmodulefile("modmain/" .. dirc .. "/modwiki")              --图鉴wiki定义
    modimportmodulefile("modmain/" .. dirc .. "/skins")                --物品皮肤
    if proisdev then
        modimportmodulefile("modmain/" .. dirc .. "/debug")            --注册一些c_指令，用于控制台调试
    end

    if PrefabFiles and #PrefabFiles > 0 then
        ALL_PREFAB_FILES = ArrayUnion(ALL_PREFAB_FILES, PrefabFiles)
    end
    if Assets and #Assets > 0 then
        ConcatArrays(ALL_ASSETS, Assets)
    end
    PrefabFiles = {}
    Assets = {}
end
----------------------------------------------------------------------------------------------------
-- 共同
Modimport("common")

--小房子，以及在地图外生成相关
Modimport("room")
--海难小船
Modimport("boat")
-- 大风平原
if TUNING.tropical.windyplains ~= 5 then
    Modimport("windy")
end
-- 海洋
if TUNING.tropical.only_sea then
    Modimport("sea")
end
-- 海底
if TUNING.tropical.underwater then
    Modimport("underwater")
end
-- 哈姆雷特
if TUNING.tropical.hamlet then
    Modimport("hamlet")
end
-- 海难
if TUNING.tropical.shipwrecked then
    Modimport("shipwrecked")
end
-- 海难plus
if TUNING.tropical.shipwrecked_plus then
    Modimport("shipwrecked_plus")
end
-- 熔炉竞技场
if TUNING.tropical.lavaarena then
    Modimport("lavaarena")
    modimport("scripts/complementos.lua")
end
-- 绿色世界
if TUNING.tropical.greenworld ~= 5 then
    Modimport("greenworld")
end
-- 冰霜岛屿
if TUNING.tropical.frost_island ~= 5 then
    Modimport("frostisland")
end
-- 暴食
if TUNING.tropical.quagmire then
    Modimport("quagmire")
end

----------------------------------------------------------------------------------------------------

PrefabFiles = ALL_PREFAB_FILES
ALL_PREFAB_FILES = nil
Assets = ALL_ASSETS
ALL_ASSETS = nil

Constructor.AddScrapbookWiki("tropical", WIKI_DATA)
WIKI_DATA = nil
