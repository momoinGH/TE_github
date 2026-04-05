-- TUNING.tropical = {
--     kindofworld      = kindofworld, --世界类型

--     room             = hamlet and true or false,
--     boat             = shipwrecked and true or false,
--     -- windy            = GetModConfigData("windy"),                    --大风平原
--     windy            = false,                                        --TODO 大风平原以后删了
--     sea              = only_sea,                                     --仅海洋世界
--     underwater       = is_custom and GetModConfigData("underwater"), --海底世界
--     hamlet           = hamlet,
--     shipwrecked      = shipwrecked,
--     shipwrecked_plus = shipwrecked_plus,                               --海难plus
--     lavaarena        = GetModConfigData("forge"),                      --熔炉竞技场
--     -- greenworld       = is_custom and GetModConfigData("greenworld"),   --绿色世界
--     greenworld       = false,                                          --以后删了
--     frostisland      = is_custom and GetModConfigData("frost_island"), --冰霜岛屿
--     quagmire         = is_custom and GetModConfigData("gorgeisland"),  --暴食


--     only_hamlet     = only_hamlet,                                      --仅哈姆雷特世界
--     hamlet_caves    = hamlet and GetModConfigData("hamlet_caves"),
--     pinacle         = hamlet and GetModConfigData("pinacle"),           --峰顶
--     anthill         = hamlet and GetModConfigData("anthill"),           --蚁丘
--     pigruins        = hamlet and GetModConfigData("pigruins"),          --古代猪人遗迹
--     hamlet_pigcity1 = hamlet and GetModConfigData("pigcity1") or false, --猪伯利市3
--     hamlet_pigcity2 = hamlet and GetModConfigData("pigcity2") or false, --猪伯利皇城


--     only_shipwrecked = only_shipwrecked,                                     --仅海难世界
--     volcano = shipwrecked and GetModConfigData("volcano"),                   --火山生成
--     volcaniceruption = shipwrecked and GetModConfigData("volcaniceruption"), --火山喷发 TODO 火山和火山喷发是不是应该是同一个
--     sealnado = shipwrecked and GetModConfigData("sealnado"),                 --豹卷风




--     wind                           = GetModConfigData("wind"),                         --飓风
--     hail                           = GetModConfigData("hail"),                         --冰雹
--     megarandomCompatibilityWater   = GetModConfigData("megarandomCompatibilityWater"), --兼容超级随机世界生成
--     springflood                    = GetModConfigData("flood"),                        --洪水
--     waves                          = GetModConfigData("Waves"),                        --海浪
--     tropicalshards                 = GetModConfigData("tropicalshards"),               --多层世界服务器
--     removedark                     = GetModConfigData("removedark"),                   --移除黑暗
--     aporkalypse                    = GetModConfigData("aporkalypse"),                  --大灾变
--     multiplayerportal              = GetModConfigData("startlocation"),                --出生模式
--     greenmod                       = KnownModIndex:IsModEnabled("workshop-1418878027"),
--     fog                            = GetModConfigData("fog"),                          --迷雾
--     hayfever                       = GetModConfigData("hayfever"),                     --花粉症
--     disembarkation                 = GetModConfigData("automatic_disembarkation"),     --自动离船
--     bosslife                       = GetModConfigData("bosslife"),                     --巨兽生命值

--     moon_shipwrecked               = GetModConfigData("moon_shipwrecked"),
--     togethercaves_shipwreckedworld = GetModConfigData("togethercaves_shipwreckedworld"),
--     cherryforest                   = GetModConfigData("cherryforest"),
-- }

print("加载配置项", GetModConfigData("hamlet"))
local hamlet = GetModConfigData("hamlet") == 1


TUNING.tropical = {
    common         = true,
    room           = hamlet,
    hamlet         = hamlet,
    hayfever       = GetModConfigData("hayfever") == 1,       --花粉症
    fog            = GetModConfigData("fog") == 1,            --迷雾
    vampirebatcave = GetModConfigData("vampirebatcave") == 1, --洞穴裂缝
    aporkalypse    = GetModConfigData("aporkalypse") == 1,    --大灾变








    kindofworld      = 15, --世界类型

    boat             = false,
    windy            = false,
    sea              = false, --仅海洋世界
    underwater       = false, --海底世界

    shipwrecked      = false,
    shipwrecked_plus = false, --海难plus
    lavaarena        = false, --熔炉竞技场
    greenworld       = false, --以后删了
    frostisland      = false, --冰霜岛屿
    quagmire         = false, --暴食


    only_hamlet     = false, --仅哈姆雷特世界
    hamlet_caves    = false,
    pinacle         = false, --峰顶
    anthill         = false, --蚁丘
    pigruins        = false, --古代猪人遗迹
    hamlet_pigcity1 = false, --猪伯利市3
    hamlet_pigcity2 = false, --猪伯利皇城


    only_shipwrecked = false, --仅海难世界
    volcano = false,          --火山生成
    volcaniceruption = false, --火山喷发 TODO 火山和火山喷发是不是应该是同一个
    sealnado = false,         --豹卷风



    wind                           = false, --飓风
    hail                           = false, --冰雹
    megarandomCompatibilityWater   = false, --兼容超级随机世界生成
    springflood                    = false, --洪水
    waves                          = false, --海浪
    tropicalshards                 = false, --多层世界服务器
    removedark                     = false, --移除黑暗
    multiplayerportal              = false, --出生模式
    greenmod                       = false,

    disembarkation                 = false, --自动离船
    bosslife                       = 1,     --巨兽生命值

    moon_shipwrecked               = false,
    togethercaves_shipwreckedworld = false,
    cherryforest                   = false,
}

print("打印配置项数据：")
print(PrintTable(TUNING.tropical))
