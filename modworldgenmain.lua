GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

modimport "modmain/util.lua" --一些表相关的工具函数

tro_modules = modinfo.tro_modules

tro_languages = {
    "pt",
    "zh",
    "it",
    "ru",
    "sp",
    "ko",
    "hun",
    "fr"
}

modimport "modmain/dev_utils"             --开发环境下辅助用的函数，与游戏无关
Hooks = require "tropical_utils/hooks"    --用来hook的一些函数
if TheFrontEnd then
    modimport "modmain/map/customize.lua" --世界生成选项
end
if troisdev then
    modimport "modmain/worldgen_check_before" --开发环境校验，检查不合规或者忘写的数据，防止游戏执行那部分代码时崩溃
end


-- 当配置项加载好后，才能访问TUNING.tropical检查哪些模块启用了
function TroOnConfigLoaded()
    modimport "modmain/gentuning"
    troimportmodulefile "map/terrain" --植物生成地形限制
    troimportmodulefile "tiledefs"    --定义新地皮
    troimportmodulefile "tilegroups"  --地皮分组
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
    TroOnConfigLoaded()

    modimport "modmain/map/storygen.lua"     --地形标签处理函数
    troimportmodulefile "map/lockandkey"     --地形锁钥
    troimportmodulefile "map/static_layouts" --静态布局
    troimportmodulefile "map/rooms"
    troimportmodulefile "map/tasks"
    troimportmodulefile "map/mapadd" --hook生成函数、真正把地图数据加入原有地形数据中
end