GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

modimport "modmain/util.lua" --一些表相关的工具函数

pro_modules = {
    "common",
    "room",
    "boat",
    "windy",
    "sea",
    "underwater",
    "hamlet",
    "shipwrecked",
    "shipwrecked_plus",
    "lavaarena",
    "greenworld",
    "frostisland",
    "quagmire"
}

local is_worldgen = rawget(_G, "WORLDGEN_MAIN") ~= nil
print("调用modworldgenmain", is_worldgen)
if not is_worldgen then
    --点击存档时本地调用，进行世界设置
    proimportmodulefile("map/customize", true) --世界设置
else
    --生成世界时调用
    Hooks = require "tropical_utils/hooks"        --用来hook的一些函数
    modimport "modmain/gentuning"
    modimport "modmain/dev_utils"                 --开发环境下辅助用的函数，与游戏无关
    if proisdev then
        modimport "modmain/worldgen_check_before" --开发环境校验，检查不合规或者忘写的数据，防止游戏执行那部分代码时崩溃
    end
    modimport "modmain/map/spawnutil.lua"
    proimportmodulefile "map/terrain"        --世界生成地形限制
    proimportmodulefile "tiledefs"           --定义新地皮
    proimportmodulefile "tilegroups"         --地皮分组
    proimportmodulefile "map/lockandkey"     --地形锁钥

    modimport "modmain/map/storygen.lua"     --标签处理函数
    proimportmodulefile "map/static_layouts" --静态布局
    proimportmodulefile "map/rooms"
    proimportmodulefile "map/tasks"
    proimportmodulefile "map/network" --地图生成后处理


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
end
