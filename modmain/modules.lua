local language = string.lower(GetModConfigData("language"))
WIKI_DATA = {}
trosafemodimport("modmain/languages/strings_en") --英文版本兜底，不使用的台词不应该添加
trosafemodimport("modmain/languages/strings_" .. language)
trosafemodimport("modmain/languages/modwiki_zh") -- 其他语言的wiki先不管




local ALL_PREFAB_FILES = {}
local ALL_ASSETS = {}
PrefabFiles = nil
Assets = nil

--- 导入对应模块的文件，不需要的文件可以不存在
local function Modimport(dirc)
    trosafemodimport("modmain/" .. dirc .. "/tuning")           --定义的变量
    trosafemodimport("modmain/" .. dirc .. "/constants")        --一些全局变量、全局函数
    trosafemodimport("modmain/" .. dirc .. "/prefablist")       --Prefabs中追加预制件
    trosafemodimport("modmain/" .. dirc .. "/assets")           --注册资产
    trosafemodimport("modmain/" .. dirc .. "/containers")       --定义容器
    trosafemodimport("modmain/" .. dirc .. "/character")        --添加角色，角色相关变量定义
    trosafemodimport("modmain/" .. dirc .. "/ui")               --UI相关
    trosafemodimport("modmain/" .. dirc .. "/prefabpost")       --组件、预制件的修改
    trosafemodimport("modmain/" .. dirc .. "/fx")               --特效
    trosafemodimport("modmain/" .. dirc .. "/actions")          --action相关
    trosafemodimport("modmain/" .. dirc .. "/componentactions") --componentactions相关
    trosafemodimport("modmain/" .. dirc .. "/sg")               --Stategraph相关
    trosafemodimport("modmain/" .. dirc .. "/recipes")          --配方相关
    trosafemodimport("modmain/" .. dirc .. "/cooking")          --料理相关
    trosafemodimport("modmain/" .. dirc .. "/rpc")              --RPC的注册
    trosafemodimport("modmain/" .. dirc .. "/input")            --客机操作的监听
    trosafemodimport("modmain/" .. dirc .. "/modwiki")          --图鉴wiki定义
    trosafemodimport("modmain/" .. dirc .. "/skins")            --物品皮肤
    if troisdev then
        trosafemodimport("modmain/" .. dirc .. "/debug")        --注册一些c_指令，用于控制台调试
    end

    if PrefabFiles and #PrefabFiles > 0 then
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
    end
    if Assets and #Assets > 0 then
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
    end
    PrefabFiles = {}
    Assets = {}
end

for _, m in pairs(tro_modules) do
    if TUNING.tropical[m] then
        Modimport(m)
    end
end

PrefabFiles = ALL_PREFAB_FILES
ALL_PREFAB_FILES = nil
Assets = ALL_ASSETS
ALL_ASSETS = nil

-- wiki
table.insert(Assets, Asset("ANIM", "anim/pigman_tribe.zip")) --图鉴wiki默认动画
Constructor.AddScrapbookWiki("tropical", WIKI_DATA)
WIKI_DATA = nil
