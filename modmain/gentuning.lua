local kindofworld = GetModConfigData("kindofworld")

local function Ternary(a, b, c)
    if a then
        return b
    else
        return c
    end
end

TUNING.tropical = {
    wind                         = GetModConfigData("wind"),                                  --飓风
    hail                         = GetModConfigData("hail"),                                  --冰雹
    kindofworld                  = kindofworld,                                               --世界类型
    windyplains                  = GetModConfigData("windyplains"),                           --大风平原
    quagmire                     = kindofworld == 15 and GetModConfigData("gorgeisland"),     --暴食
    greenworld                   = kindofworld == 15 and GetModConfigData("greenworld") or 5, --绿色世界
    only_hamlet                  = kindofworld == 5,                                          --仅哈姆雷特世界
    only_shipwrecked             = kindofworld == 10,                                         --仅海难世界
    only_sea                     = kindofworld == 20,                                         --仅海洋世界
    underwater                   = kindofworld == 15 and GetModConfigData("underwater"),      --海底世界
    monkeyisland                 = GetModConfigData("monkeyisland"),                          --月亮码头
    megarandomCompatibilityWater = GetModConfigData("megarandomCompatibilityWater"),          --兼容超级随机世界生成
    springflood                  = GetModConfigData("flood"),                                 --洪水
    waves                        = GetModConfigData("Waves"),                                 --海浪
    tropicalshards               = GetModConfigData("tropicalshards"),                        --多层世界服务器
    removedark                   = GetModConfigData("removedark"),                            --移除黑暗
    aporkalypse                  = GetModConfigData("aporkalypse"),                           --大灾变
    multiplayerportal            = GetModConfigData("startlocation"),                         --出生模式
    greenmod                     = KnownModIndex:IsModEnabled("workshop-1418878027"),
    lavaarena                    = GetModConfigData("forge"),                                 --熔炉竞技场
    fog                          = GetModConfigData("fog"),                                   --迷雾
    hayfever                     = GetModConfigData("hayfever"),                              --花粉症
    disembarkation               = GetModConfigData("automatic_disembarkation"),              --自动离船
    bosslife                     = GetModConfigData("bosslife"),                              --巨兽生命值
}
--哈姆雷特洞穴
TUNING.tropical.hamlet_caves = TUNING.tropical.only_hamlet and GetModConfigData("hamlet_caves")
    or TUNING.tropical.only_shipwrecked and GetModConfigData("hamlet_caves2")
    or kindofworld == 15 and GetModConfigData("hamlet_caves3")
    or false
--哈姆雷特
TUNING.tropical.hamlet = TUNING.tropical.hamlet_caves
    or TUNING.tropical.only_hamlet
    or (kindofworld == 15 and GetModConfigData("Hamlet") ~= 5)
--峰顶
TUNING.tropical.pinacle = TUNING.tropical.hamlet and GetModConfigData("pinacle")
--蚁丘
TUNING.tropical.anthill = TUNING.tropical.hamlet and GetModConfigData("anthill")
--古代猪人遗迹
TUNING.tropical.pigruins = TUNING.tropical.hamlet and GetModConfigData("pigruins")
--海难
TUNING.tropical.shipwrecked = TUNING.tropical.only_shipwrecked
    or (kindofworld == 15 and GetModConfigData("Shipwrecked") ~= 5)
--火山生成
TUNING.tropical.volcano = TUNING.tropical.shipwrecked and GetModConfigData("Volcano")
--猪伯利市
TUNING.tropical.hamlet_pigcity1 = TUNING.tropical.hamlet and GetModConfigData("pigcity1") or 5
--猪伯利皇城
TUNING.tropical.hamlet_pigcity2 = TUNING.tropical.hamlet and GetModConfigData("pigcity2") or 5
--冰霜岛屿
TUNING.tropical.frost_island = TUNING.tropical.only_shipwrecked and GetModConfigData("frost_island")
    or kindofworld == 15 and GetModConfigData("frost_island2")
    or 5
--海难plus
TUNING.tropical.shipwrecked_plus = Ternary(TUNING.tropical.only_shipwrecked, GetModConfigData("shipwrecked_plus"),
    kindofworld == 15 and GetModConfigData("shipwrecked_plus2"))
--豹卷风
TUNING.tropical.sealnado = TUNING.tropical.shipwrecked and GetModConfigData("sealnado") or false
--火山喷发
TUNING.tropical.volcaniceruption = TUNING.tropical.shipwrecked and GetModConfigData("volcaniceruption")

TUNING.MAPWRAPPER_WARN_RANGE = 14
TUNING.MAPEDGE_PADDING = TUNING.MAPWRAPPER_WARN_RANGE + 10
