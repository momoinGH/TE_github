require "stacktrace"

--- modimport导入文件，文件不存在不会报错，不过其他错误会打印
local function SafeModImport(filePath)
	local status, err = pcall(modimport, filePath)
	if not status and not string.match(err, "Error in modimport: modmain/.+%.lua not found!") then
		print("导入文件失败：" .. filePath)
		print(StackTrace(err))
	end
end

--- 导入对应模块的文件，不需要的文件可以不存在
local function Modimport(dirc)
	SafeModImport("modmain/" .. dirc .. "/tuning")        --定义的变量
	SafeModImport("modmain/" .. dirc .. "/constants")     --一些全局变量、全局函数
	SafeModImport("modmain/" .. dirc .. "/prefablist")    --Prefabs中追加预制件
	SafeModImport("modmain/" .. dirc .. "/assets")        --注册资产
	SafeModImport("modmain/" .. dirc .. "/language")      --引入语言
	SafeModImport("modmain/" .. dirc .. "/containers")    --定义容器
	SafeModImport("modmain/" .. dirc .. "/character")     --添加角色，角色相关变量定义
	SafeModImport("modmain/" .. dirc .. "/ui")            --UI相关
	SafeModImport("modmain/" .. dirc .. "/prefabpost")    --组件、预制件的修改
	SafeModImport("modmain/" .. dirc .. "/actions")       --action相关
	SafeModImport("modmain/" .. dirc .. "/componentactions") --组件行为相关
	SafeModImport("modmain/" .. dirc .. "/sg")            --Stategraph相关
	SafeModImport("modmain/" .. dirc .. "/recipes")       --配方相关
	SafeModImport("modmain/" .. dirc .. "/rpc")           --RPC的注册
	SafeModImport("modmain/" .. dirc .. "/input")         --客机操作的监听
	SafeModImport("modmain/" .. dirc .. "/modwiki")       --图鉴wiki定义
end

-- 默认
Modimport("common")
-- 大风平原
if TUNING.tropical.windyplains ~= 5 then
	Modimport("windy")
end
-- 海洋、海底
if TUNING.tropical.only_sea or TUNING.tropical.underwater then
	Modimport("sea")
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
if TUNING.tropical.forge then
	Modimport("forge")
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
if TUNING.tropical.gorgeisland then
	Modimport("gorgeisland")
end

PrefabFiles = ArrayUnion(PrefabFiles) --去一下重


modimport "scripts/prefabs/tropical_farm_plant_defs"

AddMinimap()


modimport("scripts/ham_fx")

modimport("scripts/cooking_tropical")
