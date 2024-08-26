--[[
命名建议：
- tro_作为公共模块前缀
- 其他模块的东西用模块名或者模块名前三个字母再或者tro_作为前缀




]]



----------------------------------------------------------------------------------------------------

--- 科雷modmain的定义抄过来，不过文件不存在时不提醒
local function SafeModImport(modulename)
	print("modimport: " .. env.MODROOT .. modulename)
	if string.sub(modulename, #modulename - 3, #modulename) ~= ".lua" then
		modulename = modulename .. ".lua"
	end
	local result = kleiloadlua(env.MODROOT .. modulename)
	if result == nil then
		-- error("Error in modimport: " .. modulename .. " not found!")
	elseif type(result) == "string" then
		error("Error in modimport: " .. ModInfoname(modname) .. " importing " .. modulename .. "!\n" .. result)
	else
		setfenv(result, env.env)
		result()
	end
end

local ALL_PREFAB_FILES = {}
local ALL_ASSETS = {}
local language = string.lower(GetModConfigData("language"))
GLOBAL.WIKI_DATA = {}


--- 导入对应模块的文件，不需要的文件可以不存在
local function Modimport(dirc)
	SafeModImport("modmain/" .. dirc .. "/tuning")            --定义的变量
	SafeModImport("modmain/" .. dirc .. "/constants")         --一些全局变量、全局函数
	SafeModImport("modmain/" .. dirc .. "/prefablist")        --Prefabs中追加预制件
	SafeModImport("modmain/" .. dirc .. "/assets")            --注册资产
	SafeModImport("modmain/" .. dirc .. "/languages/strings_en") --英文版本兜底，不使用的台词不应该添加
	SafeModImport("modmain/" .. dirc .. "/languages/strings_" .. language)
	SafeModImport("modmain/" .. dirc .. "/languages/modwiki_zh") -- 其他语言的wiki先不管
	SafeModImport("modmain/" .. dirc .. "/containers")        --定义容器
	SafeModImport("modmain/" .. dirc .. "/character")         --添加角色，角色相关变量定义
	SafeModImport("modmain/" .. dirc .. "/ui")                --UI相关
	SafeModImport("modmain/" .. dirc .. "/prefabpost")        --组件、预制件的修改
	SafeModImport("modmain/" .. dirc .. "/fx")                --特效
	SafeModImport("modmain/" .. dirc .. "/actions")           --action相关
	SafeModImport("modmain/" .. dirc .. "/sg")                --Stategraph相关
	SafeModImport("modmain/" .. dirc .. "/recipes")           --配方相关
	SafeModImport("modmain/" .. dirc .. "/rpc")               --RPC的注册
	SafeModImport("modmain/" .. dirc .. "/input")             --客机操作的监听
	SafeModImport("modmain/" .. dirc .. "/modwiki")           --图鉴wiki定义

	if PrefabFiles and #PrefabFiles > 0 then
		ALL_PREFAB_FILES = ArrayUnion(ALL_PREFAB_FILES, PrefabFiles)
	end
	if Assets and #Assets > 0 then
		ConcatArrays(ALL_ASSETS, Assets)
	end
	PrefabFiles = {}
	Assets = {}
end

-- 默认
Modimport("common")
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

PrefabFiles = ALL_PREFAB_FILES
ALL_PREFAB_FILES = nil
Assets = ALL_ASSETS
ALL_ASSETS = nil

local Constructor = require("tropical_utils/constructor")
Constructor.SetEnv(env)
Constructor.AddScrapbookWiki("tropical", WIKI_DATA)
GLOBAL.WIKI_DATA = nil


----------------------------------------------------------------------------------------------------

modimport "modmain/componentactions" --AddComponentAction比较特殊，如果mod的分开写就会前后覆盖
modimport "scripts/prefabs/tropical_farm_plant_defs"

AddMinimap()

modimport("scripts/cooking_tropical")
