GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })
_G = GLOBAL

local require = require
local modimport = modimport

require "tools/upvaluehelper"        ----用来hook的一些函数
require "tools/tableutil"            ----一些表相关的工具函数，都在表tableutil里
require "tools/modutil"              ----用来require  scripts之外的文件，读取，修改mod相关配置
require "tools/tileutil"             ----一些关于tile的工具函数
require "tools/spawnutil"            ----地形生成相关工具

modimport "modmain/gentuning"
modimport "tiledefs"

require("map/tasks")
require("map/rooms")
require("map/terrain")
require("map/level")
require("map/room_functions")

modimport "modmain/common/map/spawnutil"
modimport "modmain/common/map/graph"
modimport "modmain/common/map/static_layouts"

local MapTags = { "frost", "hamlet", "shipwrecked", "tropical", "underwater", "folha" }
AddGlobalClassPostConstruct("map/storygen", "Story", function(self)
	for k, v in pairs(MapTags) do
		self.map_tags.Tag[v] = function(tagdata) return "TAG", v end
	end
end)

modimport "modmain/common/map/lockandkey"

-- vai ate 6077
if TUNING.tropical.only_hamlet then
	modimport "modmain/common/map/tasks/hamlet"
elseif TUNING.tropical.only_sea then
	modimport "modmain/common/map/tasks/sea"
else
	modimport "modmain/common/map/tasks/custom"
end

if TUNING.tropical.windyplains ~= 5 then
	modimport "modmain/common/map/tasks/windyworldgen"
end

if TUNING.tropical.greenworld ~= 5 then
	modimport "modmain/common/map/tasks/greenworldgen"
end
