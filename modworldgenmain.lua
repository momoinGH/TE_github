GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })
-- modworldgenmain.lua文件点击存档时本地调用一下，点击开始游戏主机才会调用
modimport "modmain/util.lua"                  --一些表相关的工具函数
if proisdev then
    modimport "modmain/data_validator_before" --开发环境校验，检查不合规或者忘写的数据，防止游戏执行那部分代码时崩溃
end
Hooks = require "tropical_utils/hooks"        --用来hook的一些函数
modimport "modmain/gentuning"
modimport "modmain/dev_utils"                 --开发环境下辅助用的函数，与游戏无关
modimport "modmain/map/spawnutil.lua"

proimportmodulefile "tiledefs"
proimportmodulefile "tilegroups"
proimportmodulefile "map/lockandkey" --地形锁钥
modimport "modmain/hamlet/map/storygen.lua"
proimportmodulefile "map/tasks"
proimportmodulefile "map/rooms"
proimportmodulefile "map/network"        --地图生成后处理
proimportmodulefile "map/static_layouts" --静态地形


-- TODO
-- if TUNING.tropical.only_hamlet then
--     modimport "modmain/common/map/tasks/hamlet"
-- elseif TUNING.tropical.sea then
--     modimport "modmain/common/map/tasks/sea"
-- else
--     modimport "modmain/common/map/tasks/custom"
-- end

if TUNING.tropical.windy then
    modimport "modmain/common/map/tasks/windyworldgen"
end

if TUNING.tropical.greenworld then
    modimport "modmain/common/map/tasks/greenworldgen"
end
