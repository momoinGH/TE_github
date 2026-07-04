local function en_zh_zht(en, zh, zht)
    if locale == "zh" or locale == "zhr" or locale == "chs" or locale == "ch" then
        return zh or en        -- 简体中文
    elseif locale == "zht" or locale == "tc" or locale == "cht" then
        return zht or zh or en -- 繁体中文
    else
        return en
    end -- 英文
end

folder_name = folder_name or "workshop-"

local isdev = not folder_name:find("workshop-")

local function pub_dev(pub, dev)
    return isdev and dev or pub
end

name = pub_dev(
    en_zh_zht("Tropical Experience | SW HAM Biomes : From Beyond", "热带体验 | 海难哈姆雷特生态：来自域外", "熱帶體驗 | 船難哈姆雷特生態：來自域外"),
    en_zh_zht("Tropical Experience | DEV", "热带体验 | 开发版", "熱帶體驗 | 開發版"))

description = en_zh_zht([[
version：3.83
Attention: We added a complement to this mod.
In it will have several changes to improve the experience of the game.
Visit only the main mod page and download.
Tropical Experience| Complement",
]], [[
版本：3.83
注意：我们为此模组添加了一些内容补充
其中包含了多项改进游戏体验的玩法变化，请访问此模组创意工坊进行下载
多种生态群系体验 | 补充内容
添加饥荒单机版的海难DLC、哈姆雷特DLC内容

集成多个生态群系模组内容：
冰霜岛屿与冰霜洞穴 - 灵感来源永不妥协(Uncompromising Mode)
海底世界(Creeps in the Deeps)
绿色世界(Green World)
大风平原(Windy Plains)

兼容樱花林(Cherry Forest)",
]], [[
版本：3.83
注意：我們爲此模組添加了一些內容補充
其中包含了多項改進遊戲體驗的玩法變化，請訪問此模組創意工坊進行下載
多種生態羣系體驗 | 補充內容
添加饑荒單機版的海難DLC、哈姆雷特DLC內容

集成多個生態羣系模組內容：
冰霜島嶼與冰霜洞穴 - 靈感來源永不妥協(Uncompromising Mode)
海底世界(Creeps in the Deeps)
綠色世界(Green World)
大風平原(Windy Plains)

兼容櫻花林(Cherry Forest)
]])

author = "Vagner da Rocha Santos."
version = "3.83"
forumthread = ""
api_version = 10
priority = -20

dst_compatible = true
dont_starve_compatible = false
all_clients_require_mod = true
client_only_mod = false
reign_of_giants_compatible = false
server_filter_tags = { "shipwrecked", "tropical experience", "Hamlet", "Economy", "itens", "biome", "world", "gen",
    "money", "coins", "house", "home", "boats", "light", "hats", "boss", "companion", "endless", "ruins", "gun", "hard",
    "trade", "vagner", "三合一", "热带体验" }

icon_atlas = "modicon.xml"
icon = "modicon.tex"

-- 标题，如果配置了参数group，这个就会作为世界生成里的大标题
local function title(label, group)
    local opt = {
        name = "",
        label = label,
        hover = "",
        options = { { description = "", data = false }, },
        default = false,
    }
    if group then
        opt.world_gen = {
            group = group,
        }
    end
    return opt
end

local function options_enable()
    return {
        { description = "禁用", data = 0 },
        { description = "启用", data = 1 },
    }
end

local hamlet_atlas = "images/scrapbook_tropical/scrapbook_hamlet.xml"
local shipwrecked_atlas = "images/scrapbook_tropical/scrapbook_shipwrecked.xml"

local LEVELCATEGORY = {
    SETTINGS = "SETTINGS", --世界规则里显示
    WORLDGEN = "WORLDGEN", --世界生成里显示
}

tro_modules = {
    common           = "common",           -- 包含单机巨人国以及原版内容的一些hook
    room             = "room",             --小房子，以及在地图外生成相关
    boat             = "boat",             --海难小船
    windy            = "windy",            -- 大风平原
    sea              = "sea",              -- 海洋
    underwater       = "underwater",       -- 海底
    hamlet           = "hamlet",           -- 哈姆雷特
    shipwrecked      = "shipwrecked",      -- 海难
    shipwrecked_plus = "shipwrecked_plus", -- 海难plus
    lavaarena        = "lavaarena",        -- 熔炉竞技场
    greenworld       = "greenworld",       -- 绿色世界
    frostisland      = "frostisland",      -- 冰霜岛屿
    quagmire         = "quagmire"          -- 暴食
}

-- mod配置数据，同样用于世界生成设置里显示，有world_gen字段的就会在世界生成显示
-- 因为世界生成字段不支持布尔值，为了统一这里规定data不能是布尔值
configuration_options =
{
    {
        name = "language",
        label = en_zh_zht("Language/Idioma", "选择语言", "選擇語言"),
        hover = "EN/PT/ZH/IT/RU/ES/KR/HU/FR",
        options =
        {
            { description = "English", data = "en" },
            { description = "Português", data = "pt" },
            { description = "中文", data = "zh" },
            { description = "Italian", data = "it" },
            { description = "Russian", data = "ru" },
            { description = "Spanish", data = "sp" },
            { description = "한국어", data = "ko" },
            { description = "Magyar", data = "hun" },
            { description = "Français", data = "fr" },
        },
        default = en_zh_zht("en", "zh"),
    },

    -- 添加到世界生成中的使用示例
    -- {
    --     name = "hamlet",
    --     label = "哈姆雷特",
    --     options = options_enable(),
    --     default = 1,                               --默认值
    --     world_gen = {
    --         category = { LEVELCATEGORY.WORLDGEN }, --世界规则还世界生成
    --         group = tro_modules.hamlet,            --在哪个组
    --         world = { "forest","cave" },                  --在世界和洞穴的世界规则中显示
    --         -- atlas = nil, --用的的图集，需要在modservercreationmain.lua里面定义并加载资源
    --         -- image = "liefs.tex", --图片
    --         order = -1, --优先级，越小越在前面
    --     }
    -- },

    title(en_zh_zht("<热带体验>", "<热带体验>", "<热带体验>"), tro_modules.common),
    {
        name = "world_size_multi",
        label = "世界面积乘数",
        hover = "可以让世界变得更大，在世界大小上乘以该倍率",
        options = {
            { description = "Default, 1×",   data = 1 },
            { description = "Larger, 1.25×", data = 1.25 },
            { description = "Huger, 1.5×",   data = 1.5 },
            { description = "xHuger, 2×",    data = 2 },
        },
        default = 1,
        world_gen = {
            category = { LEVELCATEGORY.WORLDGEN },
            group = tro_modules.common,
            world = { "forest" },
            image = "world_size.tex"
        }
    },
    {
        name = "bosslife",
        label = en_zh_zht("Bosses Life", "巨兽生命值", "巨獸生命值"),
        hover = en_zh_zht(
            "Determines how much health mod bosses will have",
            "巨兽不行？不够撸？\n那就提升巨兽的生命值吧！",
            "巨獸不行？不夠擼？\n那就提升巨獸的生命值吧！"),
        options = {
            { description = "25%", data = 0.25, hover = en_zh_zht("bosses with 25% health", "巨兽生命值为25%", "巨獸生命值爲25%") },
            { description = "50%", data = 0.50, hover = en_zh_zht("bosses with 50% health", "巨兽生命值为50%", "巨獸生命值爲50%") },
            { description = "75%", data = 0.75, hover = en_zh_zht("bosses with 75% health", "巨兽生命值为75%", "巨獸生命值爲75%") },
            { description = "100%", data = 1.00, hover = en_zh_zht("bosses with 100% health", "巨兽生命值为100%", "巨獸生命值爲100%") },
            { description = "125%", data = 1.25, hover = en_zh_zht("bosses with 125% health", "巨兽生命值为125%", "巨獸生命值爲125%") },
            { description = "150%", data = 1.50, hover = en_zh_zht("bosses with 150% health", "巨兽生命值为150%", "巨獸生命值爲150%") },
            { description = "200%", data = 2.00, hover = en_zh_zht("bosses with 200% health", "巨兽生命值为200%", "巨獸生命值爲200%") },
            { description = "300%", data = 3.00, hover = en_zh_zht("bosses with 300% health", "巨兽生命值为300%", "巨獸生命值爲300%") },
        },
        default = 1,
        world_gen = {
            category = { LEVELCATEGORY.SETTINGS },
            group = tro_modules.common,
            world = { "forest" },
        }
    },


    title(en_zh_zht("<hamlet>", "<哈姆雷特>", "<哈姆雷特>"), tro_modules.hamlet),

    {
        name = "hamlet",
        label = en_zh_zht("hamlet", "哈姆雷特", "哈姆雷特"),
        options = options_enable(),
        default = 1, --默认值
        world_gen = {
            category = { LEVELCATEGORY.WORLDGEN },
            group = tro_modules.hamlet,
            world = { "forest" },
        }
    },
    {
        name = "hayfever",
        label = en_zh_zht("Hay Fever", "花粉症"),
        hover = en_zh_zht("Enables the Hay Fever on Summer", "在夏季启用花粉症", "在夏季啓用花粉症"),
        options = options_enable(),
        default = 1, --默认值
        world_gen = {
            category = { LEVELCATEGORY.SETTINGS },
            group = tro_modules.hamlet,
            world = { "forest" },
            atlas = hamlet_atlas,
            image = "hayfever.tex",
        }
    },
    {
        name = "fog",
        label = en_zh_zht("Winter Fog", "迷雾", "迷霧"),
        hover = en_zh_zht("Enables the fog on Winter", "在冬季启用迷雾", "在冬季啟用迷霧"),
        options = options_enable(),
        default = 1, --默认值
        world_gen = {
            category = { LEVELCATEGORY.SETTINGS },
            group = tro_modules.hamlet,
            world = { "forest" },
            atlas = hamlet_atlas,
            image = "fog.tex",
        }
    },
    {
        name = "vampirebatcave",
        label = en_zh_zht("Vampire bat cave", "洞穴裂缝"),
        options = options_enable(),
        default = 1,
        world_gen = {
            category = { LEVELCATEGORY.SETTINGS },
            group = tro_modules.hamlet,
            world = { "forest" },
            atlas = hamlet_atlas,
            image = "vampire_bat_caves.tex",
        },
    },
    {
        name = "aporkalypse",
        label = en_zh_zht("Aporkalypse", "大灾变", "大災變"),
        hover = en_zh_zht(
            "Aporkalypse appear every 60 days, if u don't reset the calendar inside the ruins *Active Time: 20 days*",
            "大灾变每60天出现一次\n如果不在遗迹内重置灾变日历，每次将持续20天",
            "大災變每60天出現一次\n如果不在遺蹟內重置災變日曆，每次將持續20天"),
        options = options_enable(),
        default = 1,
        world_gen = {
            category = { LEVELCATEGORY.SETTINGS },
            group = tro_modules.hamlet,
            world = { "forest" },
            atlas = hamlet_atlas,
            image = "aporkalypse.tex",
        },
    },

    title(en_zh_zht("<shipwrecked>", "<海难>", "<海难>"), tro_modules.shipwrecked),
    {
        name = "shipwrecked",
        label = en_zh_zht("shipwrecked", "海难", "船難"),
        options = options_enable(),
        default = 1,
        world_gen = {
            category = { LEVELCATEGORY.WORLDGEN },
            group = tro_modules.shipwrecked,
            world = { "forest" },
        }
    },
    {
        name = "volcaniceruption",
        label = en_zh_zht("Volcanic Eruption", "火山喷发", "火山噴發"),
        hover = en_zh_zht(
            "Enables the Volcanic Eruption",
            "将在夏季时的海难区域定时发生火山喷发",
            "將在夏季時的海難區域定時發生火山噴發"),
        options = options_enable(),
        default = 1,
        world_gen = {
            category = { LEVELCATEGORY.SETTINGS },
            group = tro_modules.shipwrecked,
            world = { "forest" },
            atlas = shipwrecked_atlas,
            image = "volcano.tex",
        },
    },
    {
        name = "twister",
        label = en_zh_zht("Sealnado", "豹卷风", "豹捲風"),
        hover = en_zh_zht(
            "Will spawn in spring on Shipwrecked Biomes *Sealnado/Twister* ",
            "将在春季时的海难生态群系生成海难巨兽：“豹卷风”",
            "將在春季時的船難生態羣系生成船難巨獸：“豹捲風”"),
        options = options_enable(),
        default = 1,
        world_gen = {
            category = { LEVELCATEGORY.SETTINGS },
            group = tro_modules.shipwrecked,
            world = { "forest" },
            atlas = shipwrecked_atlas,
            image = "twister.tex",
        },
    },
    {
        name = "hurricane",
        label = en_zh_zht("Wind", "飓风", "颶風"),
        hover = en_zh_zht(
            "affects speed, make trees & plant fall down and the sea create more and powerfull waves",
            "飓风刮起时会影响玩家移动速度\n并将树木和植物吹倒\n在海面形成更大的海浪",
            "颶風颳起時會影響玩家移動速度\n並將樹木和植物吹倒\n在海面形成更大的海浪"),
        options = options_enable(),
        default = 1,
        world_gen = {
            category = { LEVELCATEGORY.SETTINGS },
            group = tro_modules.shipwrecked,
            world = { "forest" },
        },
    },
    {
        name = "springflood",
        label = en_zh_zht("Flood", "洪水"),
        hover = en_zh_zht(
            "In Spring puddles will spawn and attract Mosquitos from the water",
            "春季下雨时会生成水坑\n并在其中生成具有攻击性的毒蚊子",
            "春季下雨時會生成水坑\n並在其中生成具有攻擊性的毒蚊子"),
        options = options_enable(),
        default = 1,
        world_gen = {
            category = { LEVELCATEGORY.SETTINGS },
            group = tro_modules.shipwrecked,
            world = { "forest" },
            atlas = shipwrecked_atlas,
            image = "floods.tex",
        },
    },
    {
        name = "waves",
        label = en_zh_zht("Waves", "海浪"),
        hover = en_zh_zht(
            "The sea generate Waves *wind make them stronger and faster*",
            "海面将生成海浪 *吹风时会有更大的浪*",
            "海面將生成海浪 *吹風時會有更大的浪*"),
        options = options_enable(),
        default = 1,
        world_gen = {
            category = { LEVELCATEGORY.SETTINGS },
            group = tro_modules.shipwrecked,
            world = { "forest" },
            atlas = shipwrecked_atlas,
            image = "waves.tex",
        },
    },
    title(en_zh_zht("<shipwrecked_plus>", "<海难Plus>", "<海难Plus>"), tro_modules.shipwrecked_plus),
    {
        name = "shipwrecked_plus",
        label = en_zh_zht("Shipwrecked Plus", "海难PLUS内容", "船難PLUS內容"),
        hover = en_zh_zht(
            "Generate a extra Shipwrecked island based on the Shipwrecked Plus mod",
            "生成来自海难PLUS(Shipwrecked PLUS)模组内容的额外岛屿",
            "生成來自船難PLUS(Shipwrecked PLUS)模組內容的額外島嶼"),
        options = options_enable(),
        default = 1,
        world_gen = {
            category = { LEVELCATEGORY.WORLDGEN },
            group = tro_modules.shipwrecked_plus,
            world = { "forest" },
        }
    },

    title(en_zh_zht("<greenworld>", "<绿色世界>", "<绿色世界>"), tro_modules.greenworld),
    {
        name = "greenworld",
        label = en_zh_zht("Green World", "绿色世界群系", "綠色世界羣系"),
        hover = en_zh_zht(
            "It will generate the Green World",
            "将生成来自绿色世界(Green World)模组的生态群系",
            "將生成來自綠色世界(Green World)模組的生態羣系"),
        options = options_enable(),
        default = 1,
        world_gen = {
            category = { LEVELCATEGORY.WORLDGEN },
            group = tro_modules.greenworld,
            world = { "forest" },
        }
    },

    title(en_zh_zht("<windy>", "<大风平原>", "<大风平原>"), tro_modules.windy),
    {
        name = "windy",
        label = en_zh_zht("Windy Plains Biome", "大风平原群系", "大風平原羣系"),
        hover = en_zh_zht(
            "It will generate the Windy Plains Biome",
            "将生成来自大风平原(Windy Plains)模组的生态群系",
            "將生成來自大風平原(Windy Plains)模組的生態羣系"),
        options = options_enable(),
        default = 1,
        world_gen = {
            category = { LEVELCATEGORY.WORLDGEN },
            group = tro_modules.windy,
            world = { "forest" },
        }
    },

    title(en_zh_zht("<frostisland>", "<冰霜岛屿>", "<冰霜岛屿>"), tro_modules.frostisland),
    {
        name = "frostisland",
        label = en_zh_zht("Frost Land", "冰霜岛屿", "冰霜島嶼"),
        hover = en_zh_zht(
            "Creates Frost island、frozen cave where it is winter all the time.",
            "创建永远是冬天的冰霜岛屿、冰霜洞穴\n灵感来自永不妥协(Uncompromising Mode)",
            "創建永遠是冬天的冰霜岛屿、冰霜洞穴\n靈感來自永不妥協(Uncompromising Mode)"),
        options = options_enable(),
        default = 1,
        world_gen = {
            category = { LEVELCATEGORY.WORLDGEN },
            group = tro_modules.frostisland,
            world = { "forest" },
        }
    },

    title(en_zh_zht("<quagmire>", "<暴食>", "<暴食>"), tro_modules.quagmire),
    {
        name = "quagmire",
        label = en_zh_zht("Gorge Island", "暴食生态群系岛屿", "暴食生態羣系島嶼"),
        hover = en_zh_zht(
            "create an island with content from the gorge event",
            "生成一个暴食生态群系岛屿\n灵感来自官方的暴食(Re-Gorge-itated)模组",
            "生成一個暴食生態羣系島嶼\n靈感來自官方的暴食(Re-Gorge-itated)模組"),
        options = options_enable(),
        default = 1,
        world_gen = {
            category = { LEVELCATEGORY.WORLDGEN },
            group = tro_modules.quagmire,
            world = { "forest" },
        }
    },

    title(en_zh_zht("<underwater>", "<海底世界>", "<海底世界>"), tro_modules.underwater),
    {
        name = "underwater",
        label = en_zh_zht("Underwater", "海底生态群系", "海底生態羣系"),
        hover = en_zh_zht(
            "It will generate entrances on the surface that lead to the bottom of the ocean. (will only affects custom, hamlet and shipwrecked world)",
            "将在地面服务器生成海底入口\n（仅影响自定义世界、哈姆雷特世界和海难世界）",
            "將在地面伺服器生成海底入口\n（僅影響自定義世界、哈姆雷特世界和船難世界）"),
        options = options_enable(),
        default = 1,
        world_gen = {
            category = { LEVELCATEGORY.WORLDGEN },
            group = tro_modules.underwater,
            world = { "forest" },
        }
    },

    -- title(en_zh_zht("<lavaarena>", "<熔炉竞技场>", "<熔炉竞技场>"), tro_modules.lavaarena),
    -- {
    --     name = "lavaarena",
    --     label = "熔炉竞技场",
    --     options = options_enable(),
    --     default = 1,
    --     world_gen = {
    --         category = { LEVELCATEGORY.WORLDGEN },
    --         group = tro_modules.lavaarena,
    --         world = { "forest" },
    --     }
    -- },
}
