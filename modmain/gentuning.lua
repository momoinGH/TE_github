local hamlet = GetModConfigData("hamlet") == 1
local shipwrecked = GetModConfigData("shipwrecked") == 1

TUNING.tropical = {
    common           = true,
    bosslife         = GetModConfigData("bosslife"), --巨兽生命值

    hamlet           = hamlet,
    room             = hamlet,
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

    windy            = GetModConfigData("windy") == 1,            --大风平原
    underwater       = GetModConfigData("underwater") == 1,       --海底世界
    shipwrecked_plus = GetModConfigData("shipwrecked_plus") == 1, --海难plus
    lavaarena        = GetModConfigData("lavaarena") == 1,        --熔炉竞技场
    greenworld       = GetModConfigData("greenworld") == 1,       --绿色世界
    frostisland      = GetModConfigData("frostisland") == 1,      --冰霜岛屿
    quagmire         = GetModConfigData("quagmire") == 1,         --暴食

    sea              = false,                                     --仅海洋世界
}

print("打印配置项数据：")
print(PrintTable(TUNING.tropical))
