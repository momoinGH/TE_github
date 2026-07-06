local hamlet = GetModConfigData("hamlet") == 1
local shipwrecked = GetModConfigData("shipwrecked") == 1
local sea = GetModConfigData("sea") == 1

TUNING.tropical = {
    common           = true,
    bosslife         = GetModConfigData("bosslife"),              --巨兽生命值
    ocean_style      = GetModConfigData("ocean_style"),           --海洋风格
    startlocation    = GetModConfigData("startlocation"),         --出生地，就是绚丽之门在哪个地形上

    hamlet           = hamlet and not sea,                        --哈姆雷特
    room             = hamlet and not sea,
    hayfever         = GetModConfigData("hayfever") == 1,         --花粉症
    fog              = GetModConfigData("fog") == 1,              --迷雾
    vampirebatcave   = GetModConfigData("vampirebatcave") == 1,   --洞穴裂缝
    aporkalypse      = GetModConfigData("aporkalypse") == 1,      --大灾变

    shipwrecked      = shipwrecked and not sea,                   --海难
    volcaniceruption = GetModConfigData("volcaniceruption") == 1, --火山喷发
    twister          = GetModConfigData("twister") == 1,          --豹卷风
    hurricane        = GetModConfigData("hurricane") == 1,        --飓风
    springflood      = GetModConfigData("springflood") == 1,      --洪水
    waves            = GetModConfigData("waves") == 1,            --海浪
    boat             = shipwrecked and not sea,

    windy            = GetModConfigData("windy") == 1 and not sea,            --大风平原
    underwater       = GetModConfigData("underwater") == 1 and not sea,       --海底世界
    shipwrecked_plus = GetModConfigData("shipwrecked_plus") == 1 and not sea, --海难plus
    lavaarena        = GetModConfigData("lavaarena") == 1 and not sea,        --熔炉竞技场
    greenworld       = GetModConfigData("greenworld") == 1 and not sea,       --绿色世界
    frostisland      = GetModConfigData("frostisland") == 1 and not sea,      --冰霜岛屿
    quagmire         = GetModConfigData("quagmire") == 1 and not sea,         --暴食
    sea              = sea,                                                   --仅海洋世界
}

print("打印配置项数据：")
print(PrintTable(TUNING.tropical))
