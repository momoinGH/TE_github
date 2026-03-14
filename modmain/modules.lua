local ALL_PREFAB_FILES = {}
local ALL_ASSETS = {}
local language = string.lower(GetModConfigData("language"))
WIKI_DATA = {}

--- 导入对应模块的文件，不需要的文件可以不存在
local function Modimport(dirc)
    prosafemodimport("modmain/" .. dirc .. "/tuning")               --定义的变量
    prosafemodimport("modmain/" .. dirc .. "/constants")            --一些全局变量、全局函数
    prosafemodimport("modmain/" .. dirc .. "/prefablist")           --Prefabs中追加预制件
    prosafemodimport("modmain/" .. dirc .. "/assets")               --注册资产
    prosafemodimport("modmain/" .. dirc .. "/languages/strings_en") --英文版本兜底，不使用的台词不应该添加
    prosafemodimport("modmain/" .. dirc .. "/languages/strings_" .. language)
    prosafemodimport("modmain/" .. dirc .. "/languages/modwiki_zh") -- 其他语言的wiki先不管
    prosafemodimport("modmain/" .. dirc .. "/containers")           --定义容器
    prosafemodimport("modmain/" .. dirc .. "/character")            --添加角色，角色相关变量定义
    prosafemodimport("modmain/" .. dirc .. "/ui")                   --UI相关
    prosafemodimport("modmain/" .. dirc .. "/prefabpost")           --组件、预制件的修改
    prosafemodimport("modmain/" .. dirc .. "/fx")                   --特效
    prosafemodimport("modmain/" .. dirc .. "/actions")              --action相关
    prosafemodimport("modmain/" .. dirc .. "/componentactions")     --componentactions相关
    prosafemodimport("modmain/" .. dirc .. "/sg")                   --Stategraph相关
    prosafemodimport("modmain/" .. dirc .. "/recipes")              --配方相关
    prosafemodimport("modmain/" .. dirc .. "/cooking")              --料理相关
    prosafemodimport("modmain/" .. dirc .. "/rpc")                  --RPC的注册
    prosafemodimport("modmain/" .. dirc .. "/input")                --客机操作的监听
    prosafemodimport("modmain/" .. dirc .. "/modwiki")              --图鉴wiki定义
    prosafemodimport("modmain/" .. dirc .. "/skins")                --物品皮肤
    if proisdev then
        prosafemodimport("modmain/" .. dirc .. "/debug")            --注册一些c_指令，用于控制台调试
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

for _, m in pairs(pro_modules) do
    if TUNING.tropical[m] then
        Modimport(m)
    end
end

PrefabFiles = ALL_PREFAB_FILES
ALL_PREFAB_FILES = nil
Assets = ALL_ASSETS
ALL_ASSETS = nil

Constructor.AddScrapbookWiki("tropical", WIKI_DATA)
WIKI_DATA = nil
