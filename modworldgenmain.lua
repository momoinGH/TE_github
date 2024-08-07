GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })
_G = GLOBAL

modimport "modmain/gentuning"

require("map/tasks")
require("map/rooms")
require("map/terrain")
require("map/level")
require("map/room_functions")

modimport 'tileadder.lua'
AddTiles()

modimport "modmain/common/map/spawnutil"
modimport "modmain/common/map/graph"
modimport "modmain/common/map/static_layouts"

local MapTags = { "frost", "hamlet", "tropical", "underwater", "folha" }
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
