pro_modules = {
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

local kindofworld = GetModConfigData("kindofworld")

local is_custom = kindofworld == 15

local only_hamlet = kindofworld == 5
local hamlet = only_hamlet and 20
    or is_custom and GetModConfigData("hamlet")
    or false

local only_shipwrecked = kindofworld == 10
local shipwrecked = only_shipwrecked and 20
    or is_custom and GetModConfigData("shipwrecked")
    or false
local shipwrecked_plus = shipwrecked and GetModConfigData("shipwrecked_plus")

local only_sea = kindofworld == 20

TUNING.tropical = {
    kindofworld      = kindofworld, --世界类型

    room             = hamlet and true or false,
    boat             = shipwrecked and true or false,
    -- windy            = GetModConfigData("windy"),                    --大风平原
    windy            = false,                                        --TODO 大风平原以后删了
    sea              = only_sea,                                     --仅海洋世界
    underwater       = is_custom and GetModConfigData("underwater"), --海底世界
    hamlet           = hamlet,
    shipwrecked      = shipwrecked,
    shipwrecked_plus = shipwrecked_plus,                               --海难plus
    lavaarena        = GetModConfigData("forge"),                      --熔炉竞技场
    -- greenworld       = is_custom and GetModConfigData("greenworld"),   --绿色世界
    greenworld       = false,                                          --以后删了
    frostisland      = is_custom and GetModConfigData("frost_island"), --冰霜岛屿
    quagmire         = is_custom and GetModConfigData("gorgeisland"),  --暴食


    only_hamlet     = only_hamlet,                                      --仅哈姆雷特世界
    hamlet_caves    = hamlet and GetModConfigData("hamlet_caves"),
    pinacle         = hamlet and GetModConfigData("pinacle"),           --峰顶
    anthill         = hamlet and GetModConfigData("anthill"),           --蚁丘
    pigruins        = hamlet and GetModConfigData("pigruins"),          --古代猪人遗迹
    hamlet_pigcity1 = hamlet and GetModConfigData("pigcity1") or false, --猪伯利市3
    hamlet_pigcity2 = hamlet and GetModConfigData("pigcity2") or false, --猪伯利皇城


    only_shipwrecked = only_shipwrecked,                                     --仅海难世界
    volcano = shipwrecked and GetModConfigData("volcano"),                   --火山生成
    volcaniceruption = shipwrecked and GetModConfigData("volcaniceruption"), --火山喷发 TODO 火山和火山喷发是不是应该是同一个
    sealnado = shipwrecked and GetModConfigData("sealnado"),                 --豹卷风




    wind                           = GetModConfigData("wind"),                         --飓风
    hail                           = GetModConfigData("hail"),                         --冰雹
    monkeyisland                   = GetModConfigData("monkeyisland"),                 --月亮码头
    megarandomCompatibilityWater   = GetModConfigData("megarandomCompatibilityWater"), --兼容超级随机世界生成
    springflood                    = GetModConfigData("flood"),                        --洪水
    waves                          = GetModConfigData("Waves"),                        --海浪
    tropicalshards                 = GetModConfigData("tropicalshards"),               --多层世界服务器
    removedark                     = GetModConfigData("removedark"),                   --移除黑暗
    aporkalypse                    = GetModConfigData("aporkalypse"),                  --大灾变
    multiplayerportal              = GetModConfigData("startlocation"),                --出生模式
    greenmod                       = KnownModIndex:IsModEnabled("workshop-1418878027"),
    fog                            = GetModConfigData("fog"),                          --迷雾
    hayfever                       = GetModConfigData("hayfever"),                     --花粉症
    disembarkation                 = GetModConfigData("automatic_disembarkation"),     --自动离船
    bosslife                       = GetModConfigData("bosslife"),                     --巨兽生命值

    moon_shipwrecked               = GetModConfigData("moon_shipwrecked"),
    togethercaves_shipwreckedworld = GetModConfigData("togethercaves_shipwreckedworld"),
    cherryforest                   = GetModConfigData("cherryforest")
}


TUNING.MAPEDGE_PADDING = OCEAN_MAPWRAPPER_WARN_RANGE + 10
