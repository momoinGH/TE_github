local hamlet = GetModConfigData("hamlet") == 1
local shipwrecked = GetModConfigData("shipwrecked") == 1
local frostisland = GetModConfigData("frostisland") == 1
local startlocation = GetModConfigData("startlocation")
if (startlocation == "hamlet" and not hamlet) or (startlocation == "shipwrecked" and not shipwrecked) then
    startlocation = "default" --没开就不能换出生点
end

TUNING.tropical = {
    common           = true,
    bosslife         = GetModConfigData("bosslife"),              --巨兽生命值
    ocean_style      = GetModConfigData("ocean_style"),           --海洋风格
    startlocation    = startlocation,                             --出生地，就是绚丽之门在哪个地形上

    hamlet           = hamlet,                                    --哈姆雷特
    room             = hamlet or frostisland,                     --虚空房子相关逻辑
    hayfever         = GetModConfigData("hayfever") == 1,         --花粉症
    fog              = GetModConfigData("fog") == 1,              --迷雾
    vampirebatcave   = GetModConfigData("vampirebatcave") == 1,   --洞穴裂缝
    aporkalypse      = GetModConfigData("aporkalypse") == 1,      --大灾变

    shipwrecked      = shipwrecked,                               --海难
    volcaniceruption = GetModConfigData("volcaniceruption") == 1, --火山喷发
    twister          = GetModConfigData("twister") == 1,          --豹卷风
    hurricane        = GetModConfigData("hurricane") == 1,        --飓风
    springflood      = GetModConfigData("springflood") == 1,      --洪水
    waves            = GetModConfigData("waves") == 1,            --海浪
    boat             = shipwrecked,

    underwater       = GetModConfigData("underwater") == 1,                       --海底世界
    shipwrecked_plus = shipwrecked and GetModConfigData("shipwrecked_plus") == 1, --海难plus
    frostisland      = frostisland,                                               --冰霜岛屿
    quagmire         = GetModConfigData("quagmire") == 1,                         --暴食


    -- 这几个不要的
    windy      = false, --大风平原
    lavaarena  = false, --熔炉竞技场
    greenworld = false, --绿色世界
    sea        = false, --仅海洋世界
}

print("打印配置项数据：")
print(PrintTable(TUNING.tropical))
