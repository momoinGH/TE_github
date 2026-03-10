GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })
-- modworldgenmain.lua文件点击存档时本地调用一下，点击开始游戏主机才会调用
modimport "modmain/util.lua"           --一些表相关的工具函数
Hooks = require "tropical_utils/hooks" ----用来hook的一些函数
modimport "modmain/gentuning"
modimport "modmain/dev_utils"          --开发环境下辅助用的函数，与游戏无关
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

modimport "postinit/map/storygen"
modimport "scripts/map/tro_lockandkey" ----地形锁钥
modimport "scripts/map/city_layouts"   --新的城镇 layouts

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
