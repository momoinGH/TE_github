GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

modimport "modmain/util.lua" --一些表相关的工具函数

pro_modules = modinfo.pro_modules

pro_languages = {
    "pt",
    "zh",
    "it",
    "ru",
    "sp",
    "ko",
    "hun",
    "fr"
}

modimport "modmain/dev_utils"                 --开发环境下辅助用的函数，与游戏无关
Hooks = require "tropical_utils/hooks"        --用来hook的一些函数
-- modimport "modmain/gentuning"
modimport "modmain/map/customize.lua"         --世界生成选项
if proisdev then
    modimport "modmain/worldgen_check_before" --开发环境校验，检查不合规或者忘写的数据，防止游戏执行那部分代码时崩溃
end
modimport "modmain/map/spawnutil.lua"


-- 当配置项加载好后，才能访问TUNING.tropical检查哪些模块启用了
function ProOnConfigLoaded()
    modimport "modmain/gentuning"
    proimportmodulefile "map/terrain" --植物生成地形限制
    proimportmodulefile "tiledefs"    --定义新地皮
    proimportmodulefile "tilegroups"  --地皮分组
end

-- TODO
-- if TUNING.tropical.only_hamlet then
--     modimport "modmain/common/map/tasks/hamlet"
-- elseif TUNING.tropical.sea then
--     modimport "modmain/common/map/tasks/sea"
-- else
--     modimport "modmain/common/map/tasks/custom"
-- end

-- if TUNING.tropical.windy then
--     modimport "modmain/common/map/tasks/windyworldgen"
-- end

-- if TUNING.tropical.greenworld then
--     modimport "modmain/common/map/tasks/greenworldgen"
-- end

--生成世界需要用到的内容
local is_worldgen = rawget(_G, "WORLDGEN_MAIN") ~= nil
if is_worldgen then
    ProOnConfigLoaded()

    modimport "modmain/map/storygen.lua"     --标签处理函数
    proimportmodulefile "map/lockandkey"     --地形锁钥
    proimportmodulefile "map/static_layouts" --静态布局
    proimportmodulefile "map/rooms"
    proimportmodulefile "map/tasks"
    proimportmodulefile "map/network" --地图生成后处理
end
