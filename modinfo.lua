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

name = pub_dev(en_zh_zht("Tropical Experience | SW HAM Biomes : From Beyond", "热带体验 | 海难哈姆雷特生态：来自域外", "熱帶體驗 | 船難哈姆雷特生態：來自域外"),
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

local LEVELCATEGORY = {
    SETTINGS = "SETTINGS", --世界规则里显示
    WORLDGEN = "WORLDGEN", --世界生成里显示
}

tro_modules = {
    common           = "common",           -- 共同
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

    title(en_zh_zht("<hamlet>", "<哈姆雷特>", "<哈姆雷特>"), tro_modules.hamlet),

    -- 使用示例
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

    {
        name = "hamlet",
        label = "哈姆雷特",
        options = options_enable(),
        default = 1, --默认值
        world_gen = {
            category = { LEVELCATEGORY.WORLDGEN },
            group = tro_modules.hamlet,
            world = { "forest" }, --在世界和洞穴的世界规则中显示
        }
    },
    {
        name = "hayfever",
        label = "花粉症",
        options = options_enable(),
        default = 1, --默认值
        world_gen = {
            category = { LEVELCATEGORY.SETTINGS },
            group = tro_modules.hamlet,
            world = { "forest" }, --在世界和洞穴的世界规则中显示
            atlas = hamlet_atlas,
            image = "hayfever.tex",
        }
    },
    {
        name = "fog",
        label = "大雾",
        options = options_enable(),
        default = 1, --默认值
        world_gen = {
            category = { LEVELCATEGORY.SETTINGS },
            group = tro_modules.hamlet,
            world = { "forest" }, --在世界和洞穴的世界规则中显示
            atlas = hamlet_atlas,
            image = "fog.tex",
        }
    },
    {
        name = "vampirebatcave",
        label = "洞穴裂缝",
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
}
