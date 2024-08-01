local function en_zh_zht(en, zh, zht)
	if locale == "zh" or locale == "zhr" or locale == "chs" or locale == "ch" then
		return zh or en  -- 简体中文
	elseif locale == "zht" or locale == "tc" or locale == "cht" then
		return zht or zh or en -- 繁体中文
	else
		return en
	end -- 英文
end

name = en_zh_zht("Tropical Experience | SW HAM Biomes : From Beyond", "热带体验 | 海难哈姆雷特生态：来自域外", "船難哈姆雷特生態：來自域外")
description = en_zh_zht([[
version：3.79
Attention: We added a complement to this mod.
In it will have several changes to improve the experience of the game.
Visit only the main mod page and download.
Tropical Experience| Complement",
]], [[
版本：3.79
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
版本：3.79
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
version = "3.79"
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

local function title(label)
	return { name = "", label = label, hover = "", options = { { description = "", data = false }, }, default = false, }
end

configuration_options =
{
	{
		name = "language",
		label = en_zh_zht("Language/Idioma", "选择语言", "選擇語言"),
		hover = "EN/PT/ZH/IT/RU/ES/KR/HU/FR",
		default = en_zh_zht("en", "zh"),
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
	},


	title(en_zh_zht("《KIND OF WORLD》", "《世界种类》", "《世界種類》")),

	{
		name = "kindofworld",
		label = (en_zh_zht("What is your kind of world?", "选择当前世界种类", "選擇當前世界種類")),
		hover = "",
		default = 15,
		options =
		{
			{
				description = en_zh_zht("hamlet", "仅哈姆雷特世界", "僅哈姆雷特世界"),
				data = 5,
				hover = en_zh_zht(
					"will generate a world based on hamlet DLC, use settings for hamlet.",
					"将生成一个类似于单机版哈姆雷特DLC的世界，在下面的“仅哈姆雷特世界设置”进行生成设置",
					"將生成一個類似於單機版哈姆雷特DLC的世界，在下面的“僅哈姆雷特世界設置”進行生成設置")
			},
			{
				description = en_zh_zht("shipwrecked", "仅海难世界", "僅船難世界"),
				data = 10,
				hover = en_zh_zht(
					"will generate a world based on shipwreck DLC, use settings for shipwrecked.",
					"将生成一个类似于单机版海难DLC的世界，在下面的“仅海难世界设置”进行生成设置",
					"將生成一個類似於單機版船難DLC的世界，在下面的”僅船難世界設置”進行生成設置")
			},
			{
				description = en_zh_zht("custom", "自定义世界", "自定義世界"),
				data = 15,
				hover = en_zh_zht(
					"will generate a customized world, use settings for custom world.",
					"可把所有地形生成在同一层世界上，在下面的“自定义世界设置”进行生成设置",
					"可把所有地形生成在同一層世界上，在下面的“自定義世界設置”進行生成設置")
			},
			{
				description = en_zh_zht("Sea World", "海洋世界"),
				data = 20,
				hover = en_zh_zht(
					"will generate a world without terain, time to survine in ocean.",
					"将生成陆地稀少的海洋世界，在茫茫大海中探索生存吧",
					"將生成陸地稀少的海洋世界，在茫茫大海中探索生存吧")
			},
		},
	},


	title(en_zh_zht("<for hamlet world>", "<仅哈姆雷特世界设置>", "<僅哈姆雷特世界設置>")),

	{
		name = "hamletcaves_hamletworld",
		label = en_zh_zht("Hamlet Caves", "哈姆雷特洞穴"),
		hover = en_zh_zht(
			"Will generate a new cave zone, do not forget to enable caves to work",
			"将在洞穴服务器生成一个哈姆雷特群系的新洞穴区域\n需要添加洞穴",
			"將在洞穴伺服器生成一個哈姆雷特羣系的新洞穴區域\n需要添加洞穴"),
		options =
		{
			{
				description = en_zh_zht("Disabled", "禁用"),
				data = 0,
				hover = en_zh_zht(
					"This biome will not be generated",
					"禁用该生态群系生成",
					"禁用該生態羣系生成")
			},
			{
				description = en_zh_zht("Enabled", "启用", "啟用"),
				data = 1,
				hover = en_zh_zht(
					"Will generate a new cave zone",
					"将生成一个新的洞穴区域",
					"將生成一個新的洞穴區域")
			},
		},
		default = 1,
	},

	{
		name = "togethercaves_hamletworld",
		label = en_zh_zht("Together Caves", "联机版洞穴", "連線版洞穴"),
		hover = en_zh_zht(
			"Will generate default cave zone, do not forget to enable caves to work",
			"会生成默认的联机版洞穴",
			"會生成默認的連線版洞穴"),
		options =
		{
			{
				description = en_zh_zht("Disabled", "禁用"),
				data = 0,
				hover = en_zh_zht(
					"This biome will not be generated",
					"禁用该生态群系生成",
					"禁用該生態羣系生成")
			},
			{
				description = en_zh_zht("Enabled", "启用", "啟用"),
				data = 1,
				hover = en_zh_zht(
					"Will generate a new cave zone",
					"将生成一个新的洞穴区域",
					"將生成一個新的洞穴區域")
			},
		},
		default = 1,
	},

	{
		name = "continentsize",
		label = en_zh_zht("Continent Size", "大陆尺寸"),
		hover = en_zh_zht("To change the continent size", "更改大陆尺寸"),
		options =
		{
			{
				description = en_zh_zht("Compact", "小型"),
				data = 1,
				hover = en_zh_zht(
					"Will generate the continent more compact can reduce lag in the game",
					"将生成更小的大陆，有助于减少服务器压力",
					"將生成更小的大陸，有助於減少伺服器壓力")
			},
			{
				description = en_zh_zht("Default", "默认", "默認"),
				data = 2,
				hover = en_zh_zht(
					"Will generate the continent in default size",
					"将生成默认尺寸的大陆",
					"將生成默認尺寸的大陸")
			},
			{
				description = en_zh_zht("Bigger", "大型"),
				data = 3,
				hover = en_zh_zht(
					"Will generate the continent bigger can increase lag in the game",
					"将生成更大的大陆，可能会增加服务器压力",
					"將生成更大的大陸，可能會增加伺服器壓力")
			},
		},
		default = 2,
	},

	{
		name = "fillingthebiomes",
		label = en_zh_zht("Filling the Biomes", "填充生态群系", "填充生態羣系"),
		hover = en_zh_zht(
			"To change the filling the biomes, the smaller the less lag will happen in the game",
			"调整生态群系填充，越少服务器压力越低",
			"調整生態羣系填充，越少伺服器壓力越低"),
		options =
		{
			{
				description = "0%",
				data = 0,
				hover = en_zh_zht(
					"The content of the biome will be reduced to a minimum",
					"生态群系的内容将被减少到最少",
					"生態羣系的內容將被減少到最少")
			},
			{
				description = "25%",
				data = 1,
				hover = en_zh_zht(
					"The biome will have 25% of the normal content",
					"生态群系的内容将为正常的25%",
					"生態羣系的內容將爲正常的25%")
			},
			{
				description = "50%",
				data = 2,
				hover = en_zh_zht(
					"The biome will have 50% of the normal content",
					"生态群系的内容将为正常的50%",
					"生態羣系的內容將爲正常的50%")
			},
			{
				description = "75%",
				data = 3,
				hover = en_zh_zht(
					"The biome will have 75% of the normal content",
					"生态群系的内容将为正常的75%",
					"生態羣系的內容將爲正常的75%")
			},
			{
				description = "100%",
				data = 4,
				hover = en_zh_zht(
					"The Biome will have default content",
					"生态群系将拥有默认内容",
					"生態羣系將擁有默認內容")
			},
		},
		default = 4,
	},

	{
		name = "compactruins",
		label = en_zh_zht("Compact Pig Ruins", "小型古代猪人遗迹", "小型古代豬人遺蹟"),
		hover = en_zh_zht(
			"will generate pig ruins with fewer rooms",
			"生成少量遗迹房间",
			"生成少量遺蹟房間"),
		default = false,
		options = {
			{
				description = en_zh_zht("YES", "启用", "啟用"),
				data = true,
				hover = en_zh_zht(
					"Less rooms on pig ruins",
					"将减少房间数量",
					"將減少房間數量")
			},
			{
				description = en_zh_zht("NO", "禁用"),
				data = false,
				hover = en_zh_zht(
					"Standard Quantity",
					"默认数量",
					"默認數量")
			},
		},
	},


	title(en_zh_zht("<for shipwrecked world>", "<仅海难世界设置>", "<僅船難世界設置>")),

	{
		name = "howmanyislands",
		label = en_zh_zht("How Many Islands", "岛屿数量", "島嶼數量"),
		hover = en_zh_zht(
			"You can increase or decrease the number of islands in the game, but more islands will take more time to generate a world",
			"基础8个，可以选择额外增加游戏中的岛屿数量\n但更多的岛屿将需要更长的时间来生成世界",
			"基礎8個，可以選擇額外增加遊戲中的島嶼數量\n但更多的島嶼將需要更長的時間來生成世界"),
		default = 22,
		options = {
			{ description = "20", data = 12, hover = en_zh_zht("increase in 12 islands", "增加12个岛屿", "增加12個島嶼") },
			{ description = "30", data = 22, hover = en_zh_zht("increase in 22 islands", "增加22个岛屿", "增加22個島嶼") },
			{ description = "40", data = 32, hover = en_zh_zht("increase in 32 islands", "增加32个岛屿", "增加32個島嶼") },
			{ description = "50", data = 42, hover = en_zh_zht("increase in 42 islands", "增加42个岛屿", "增加42個島嶼") },
			{ description = "60", data = 52, hover = en_zh_zht("increase in 52 islands", "增加52个岛屿", "增加52個島嶼") },
			{ description = "70", data = 62, hover = en_zh_zht("increase in 62 islands", "增加62个岛屿", "增加62個島嶼") },
			{ description = "80", data = 72, hover = en_zh_zht("increase in 72 islands", "增加72个岛屿", "增加72個島嶼") },
			{ description = "86", data = 78, hover = en_zh_zht("increase in 78 islands", "增加78个岛屿", "增加78個島嶼") },
		},
	},

	{
		name = "Shipwreckedworld_plus",
		label = en_zh_zht("Shipwrecked Plus", "海难PLUS内容", "船難PLUS內容"),
		hover = en_zh_zht(
			"Generate a extra Shipwrecked island based on the Shipwrecked Plus mod",
			"生成来自海难PLUS(Shipwrecked PLUS)模组内容的额外岛屿",
			"生成來自船難PLUS(Shipwrecked PLUS)模組內容的額外島嶼"),
		default = true,
		options = {
			{
				description = en_zh_zht("NO", "禁用"),
				data = false,
				hover = en_zh_zht(
					"Eldorado civilization will not be generated",
					"禁用海难PLUS的黄金之国岛屿生成",
					"禁用海難PLUS的黃金之國島嶼生成")
			},
			{
				description = en_zh_zht("YES", "启用", "啟用"),
				data = true,
				hover = en_zh_zht(
					"Eldorado civilization will be generated",
					"启用海难PLUS的黄金之国岛屿生成",
					"啓用海難PLUS的黃金之國島嶼生成")
			},
		},
	},

	{
		name = "frost_islandworld",
		label = en_zh_zht("Frost Land", "冰霜岛屿", "冰霜島嶼"),
		hover = en_zh_zht(
			"Creates Frost island、frozen cave where it is winter all the time.",
			"创建永远是冬天的冰霜岛屿、冰霜洞穴\n灵感来自永不妥协(Uncompromising Mode)",
			"創建永遠是冬天的冰霜岛屿、冰霜洞穴\n靈感來自永不妥協(Uncompromising Mode)"),
		default = 10,
		options = {
			{
				description = en_zh_zht("NO", "禁用"),
				data = 5,
				hover = en_zh_zht(
					"Disable Generation",
					"禁止生成冰霜岛屿群系",
					"禁止生成冰霜島嶼羣系")
			},
			{
				description = en_zh_zht("YES", "启用", "啟用"),
				data = 10,
				hover = en_zh_zht(
					"Generate on Caves & World",
					"生成冰霜岛屿和冰霜洞穴",
					"生成冰霜島嶼和冰霜洞穴")
			},
			{
				description = en_zh_zht("YES", "启用", "啟用"),
				data = 15,
				hover = en_zh_zht(
					"Just Generate Frost island on World",
					"只在地面服务器生成冰霜岛屿",
					"只在地面伺服器生成冰霜島嶼")
			},
		},
	},

	{
		name = "Moonshipwrecked",
		label = en_zh_zht("Moon Biome", "月岛", "月島"),
		hover = en_zh_zht("Generate the Moon continent from together", "是否生成月岛", "是否生成月島"),
		options = {
			{
				description = en_zh_zht("NO", "禁用"),
				data = 0,
				hover = en_zh_zht(
					"Moon continent will not be generated",
					"禁用月岛生成",
					"禁用月島生成")
			},
			{
				description = en_zh_zht("YES", "启用", "啟用"),
				data = 1,
				hover = en_zh_zht(
					"Moon continent will be generated",
					"启用月岛生成",
					"啟用月島生成")
			},
		},
		default = 0,
	},
	{
		name = "togethercaves_shipwreckedworld",
		label = en_zh_zht("Together Caves", "联机版洞穴", "連線版洞穴"),
		hover = en_zh_zht(
			"Will generate defalt cave zone, do not forget to enable caves to work",
			"会生成默认的联机版洞穴",
			"會生成默認的連線版洞穴"),
		options =
		{
			{ description = en_zh_zht("Disabled", "禁用"), data = 0, hover = en_zh_zht("This biome will not be generated", "禁用该生态群系生成", "禁用該生態羣系生成") },
			{ description = en_zh_zht("Enabled", "启用", "啟用"), data = 1, hover = en_zh_zht("Will generate a new cave zone", "将生成一个新的洞穴区域", "將生成一個新的洞穴區域") },
		},
		default = 1,
	},
	{
		name = "hamletcaves_shipwreckedworld",
		label = en_zh_zht("Hamlet Caves", "哈姆雷特洞穴"),
		hover = en_zh_zht(
			"Will generate a new cave zone, do not forget to enable caves to work",
			"将在洞穴服务器生成一个哈姆雷特群系的新洞穴区域",
			"將在洞穴伺服器生成一個哈姆雷特羣系的新洞穴區域"),
		options =
		{
			{
				description = en_zh_zht("Disabled", "禁用"),
				data = 0,
				hover = en_zh_zht(
					"This biome will not be generated",
					"禁用该生态群系生成",
					"禁用該生態羣系生成")
			},
			{
				description = en_zh_zht("Enabled", "启用", "啟用"),
				data = 1,
				hover = en_zh_zht(
					"Will generate a new cave zone",
					"将生成一个新的洞穴区域",
					"將生成一個新的洞穴區域")
			},
		},
		default = 1,
	},




	title(en_zh_zht("<for custom world>", "<自定义世界设置>", "<自定義世界設置>")),

	{
		name = "startlocation",
		label = en_zh_zht("Player Portal", "出生模式"),
		hover = en_zh_zht(
			"This is the start point, It represents the biome around the initial portal.",
			"选择你的出生点位置\n推荐将对应群系的区域设置为主大陆",
			"選擇你的出生點位置\n推薦將對應羣系的區域設置爲主大陸"),
		default = 5,
		options = {
			{ description = en_zh_zht("Together", "绚丽之门", "絢麗之門"), data = 5, hover = en_zh_zht("ROG Biomes", "巨人国生态群系", "巨人國生態羣系") },
			{ description = en_zh_zht("Shipwrecked", "沉船残骸", "沉船殘骸"), data = 10, hover = en_zh_zht("SW Biomes", "海难生态群系", "船難生態羣系") },
			{ description = en_zh_zht("Hamlet", "坠毁的热气球", "墜毀的熱氣球"), data = 15, hover = en_zh_zht("H Biomes", "哈姆雷特生态群系", "哈姆雷特生態羣系") },
		},
	},

	{
		name = "Together",
		label = en_zh_zht("Reign of Giants Biomes", "巨人国群系", "巨人國羣系"),
		hover = en_zh_zht("ROG Biomes", "巨人国生态群系", "巨人國生態羣系"),
		default = 20,
		options = {
			{
				description = en_zh_zht("Disabled", "禁用"),
				data = 5,
				hover = en_zh_zht("Disables this biome",
					"禁用此生态群系生成",
					"禁用此生態羣系生成")
			},
			{
				description = en_zh_zht("Main land", "主大陆", "主大陸"),
				data = 20,
				hover = en_zh_zht(
					"This biome will be generated in the main land, where the player starts the game",
					"将此生态群系生成在主大陆，玩家会出生在这里",
					"將此生態羣系生成在主大陸，玩家會出生在這裏")
			},
			{
				description = en_zh_zht("Continent", "新大陆", "新大陸"),
				data = 10,
				hover = en_zh_zht(
					"This biome will be generated on another continent.",
					"将此生态群系生成为另一个大陆",
					"將此生態羣系爲生成另一個大陸")
			},
			{
				description = en_zh_zht("Islands", "岛屿", "島嶼"),
				data = 15,
				hover = en_zh_zht(
					"This biome will be generated on several separate islands in the ocean",
					"将此生态群系生成为随机分布的数个岛屿",
					"將此生態羣系生成爲隨機分佈的數個島嶼")
			},
		},
	},

	{
		name = "Moon",
		label = en_zh_zht("Lunar Biomes", "月岛", "月島"),
		hover = en_zh_zht("LunarBiomes", "月岛生态群系", "月島生态群係"),
		default = 10,
		options = {
			{
				description = en_zh_zht("Disabled", "禁用"),
				data = 5,
				hover = en_zh_zht("Disables this biome",
					"禁用此生态群系生成",
					"禁用此生態羣系生成")
			},
			{
				description = en_zh_zht("Main land", "主大陆", "主大陸"),
				data = 20,
				hover = en_zh_zht(
					"This biome will be generated in the main land, where the player starts the game",
					"将此生态群系生成在主大陆，玩家会出生在这里",
					"將此生態羣系生成在主大陸，玩家會出生在這裏")
			},
			{
				description = en_zh_zht("Continent", "新大陆", "新大陸"),
				data = 10,
				hover = en_zh_zht(
					"This biome will be generated on another continent.",
					"将此生态群系生成为另一个大陆",
					"將此生態羣系爲生成另一個大陸")
			},
			{
				description = en_zh_zht("Islands", "岛屿", "島嶼"),
				data = 15,
				hover = en_zh_zht(
					"This biome will be generated on several separate islands in the ocean",
					"将此生态群系生成为随机分布的数个岛屿",
					"將此生態羣系生成爲隨機分佈的數個島嶼")
			},
		},
	},

	{
		name = "Shipwrecked",
		label = en_zh_zht("Shipwrecked Biomes", "海难群系", "船難羣系"),
		hover = en_zh_zht("SW Biomes", "海难生态群系", "船難生態羣系"),
		default = 15,
		options = {
			{
				description = en_zh_zht("Disabled", "禁用"),
				data = 5,
				hover = en_zh_zht("Disables this biome",
					"禁用此生态群系生成",
					"禁用此生態羣系生成")
			},
			{
				description = en_zh_zht("Main land", "主大陆", "主大陸"),
				data = 20,
				hover = en_zh_zht(
					"This biome will be generated in the main land, where the player starts the game",
					"将此生态群系生成在主大陆，玩家会出生在这里",
					"將此生態羣系生成在主大陸，玩家會出生在這裏")
			},
			{
				description = en_zh_zht("Continent", "新大陆", "新大陸"),
				data = 10,
				hover = en_zh_zht(
					"This biome will be generated on another continent.",
					"将此生态群系生成为另一个大陆",
					"將此生態羣系爲生成另一個大陸")
			},
			{
				description = en_zh_zht("Islands", "岛屿", "島嶼"),
				data = 15,
				hover = en_zh_zht(
					"This biome will be generated on several separate islands in the ocean",
					"将此生态群系生成为随机分布的数个岛屿",
					"將此生態羣系生成爲隨機分佈的數個島嶼")
			},
			{
				description = en_zh_zht("Arquipelago", "群岛", "羣島"),
				data = 25,
				hover = en_zh_zht("This biome will be generated as an compact Islands cluster",
					"将此生态群系生成为一个紧凑的岛屿集群",
					"將此生態羣系生成爲一個緊湊的島嶼集羣")
			},
		},
	},

	{
		name = "Shipwrecked_plus",
		label = en_zh_zht("Shipwrecked Plus", "海难PLUS内容", "船難PLUS內容"),
		hover = en_zh_zht(
			"Generate a extra Shipwrecked island based on the Shipwrecked Plus mod",
			"生成来自海难PLUS(Shipwrecked PLUS)模组内容的额外岛屿",
			"生成來自船難PLUS(Shipwrecked PLUS)模組內容的額外島嶼"),
		default = true,
		options = {
			{
				description = en_zh_zht("NO", "禁用"),
				data = false,
				hover = en_zh_zht("Eldorado civilization will not be generated",
					"禁用海难PLUS的黄金之国岛屿生成",
					"禁用船難PLUS的黃金之國島嶼生成")
			},
			{
				description = en_zh_zht("YES", "启用", "啟用"),
				data = true,
				hover = en_zh_zht("Eldorado civilization will be generated",
					"启用海难PLUS的黄金之国岛屿生成",
					"啟用船難PLUS的黃金之國島嶼生成")
			},
		},
	},

	{
		name = "Hamlet",
		label = en_zh_zht("Hamlet Biomes", "哈姆雷特群系", "哈姆雷特羣系"),
		hover = en_zh_zht("H Biomes", "哈姆雷特生态群系", "哈姆雷特生態羣系"),
		default = 10,
		options =
		{
			{
				description = en_zh_zht("Disabled", "禁用"),
				data = 5,
				hover = en_zh_zht("Disables this biome",
					"禁用此生态群系生成",
					"禁用此生態羣系生成")
			},
			{
				description = en_zh_zht("Main land", "主大陆", "主大陸"),
				data = 20,
				hover = en_zh_zht(
					"This biome will be generated in the main land, where the player starts the game",
					"将此生态群系生成在主大陆，玩家会出生在这里",
					"將此生態羣系生成在主大陸，玩家會出生在這裏")
			},
			{
				description = en_zh_zht("Continent", "新大陆", "新大陸"),
				data = 10,
				hover = en_zh_zht(
					"This biome will be generated on another continent.",
					"将此生态群系生成为另一个大陆",
					"將此生態羣系爲生成另一個大陸")
			},
			{
				description = en_zh_zht("Islands", "岛屿", "島嶼"),
				data = 15,
				hover = en_zh_zht(
					"This biome will be generated on several separate islands in the ocean",
					"将此生态群系生成为随机分布的数个岛屿",
					"將此生態羣系生成爲隨機分佈的數個島嶼")
			},
		},
	},

	{
		name = "pigcity1",
		label = en_zh_zht("Swinesbury", "猪伯利市", "豬伯利市"),
		hover = en_zh_zht(
			"Generate City 1",
			"由猪人市长领导的城镇\n即单机版哈姆雷特世界“岛1”",
			"由豬人市長領導的城鎮\n即單機版哈姆雷特世界“島1”"),
		default = 15,
		options =
		{
			{
				description = en_zh_zht("Disabled", "禁用"),
				data = 5,
				hover = en_zh_zht(
					"This pig city will not be generated",
					"禁用此猪镇生成",
					"禁用此豬鎮生成")
			},
			{
				description = en_zh_zht("Main land", "主大陆", "主大陸"),
				data = 10,
				hover = en_zh_zht(
					"This pig city will be generated in the main land, where the player starts the game",
					"将此猪镇生成在主大陆",
					"將此豬鎮生成在主大陸")
			},
			{
				description = en_zh_zht("Continent", "新大陆", "新大陸"),
				data = 15,
				hover = en_zh_zht(
					"This pig city will be generated on another continent.",
					"将此猪镇生成在另一个大陆",
					"將此豬鎮生成在另一個大陸")
			},
			{
				description = en_zh_zht("Island", "岛屿", "島嶼"),
				data = 20,
				hover = en_zh_zht(
					"This pig city will be generated in a islands in ocean",
					"将此猪镇生成在一个岛屿上",
					"將此豬鎮生成在一個島嶼上")
			},
		},
	},

	{
		name = "pigcity2",
		label = en_zh_zht("The Royal Palace", "猪伯利皇城", "豬伯利皇城"),
		hover = en_zh_zht(
			"Generate City 2",
			"由猪人女王领导的城镇\n即单机版哈姆雷特世界“岛2”",
			"由豬人女王領導的城鎮\n即單機版哈姆雷特世界“島2”"),
		default = 15,
		options =
		{
			{
				description = en_zh_zht("Disabled", "禁用"),
				data = 5,
				hover = en_zh_zht(
					"This pig city will not be generated",
					"禁用此猪镇生成",
					"禁用此豬鎮生成")
			},
			{
				description = en_zh_zht("Main land", "主大陆", "主大陸"),
				data = 10,
				hover = en_zh_zht(
					"This pig city will be generated in the main land, where the player starts the game",
					"将此猪镇生成在主大陆",
					"將此豬鎮生成在主大陸")
			},
			{
				description = en_zh_zht("Continent", "新大陆", "新大陸"),
				data = 15,
				hover = en_zh_zht(
					"This pig city will be generated on another continent.",
					"将这个猪镇生成在另一个大陆",
					"將這個豬鎮生成在另一個大陸")
			},
			{
				description = en_zh_zht("Island", "岛屿", "島嶼"),
				data = 20,
				hover = en_zh_zht(
					"This pig city will be generated in a islands in ocean",
					"将此猪镇生成在一个岛屿上",
					"將此豬鎮生成在一個島嶼上")
			},
		},
	},

	{
		name = "pinacle",
		label = en_zh_zht("Pinacle", "峰顶", "峯頂"),
		hover = en_zh_zht("Generate Roc Nest Island", "生成友善的大鵬巢穴島嶼", "生成友善的大鹏巢穴岛屿"),
		default = 1,
		options =
		{
			{
				description = en_zh_zht("Disabled", "禁用"),
				data = 0,
				hover = en_zh_zht(
					"This biome will not be generated",
					"禁用该生态群系生成",
					"禁用該生態羣系生成")
			},
			{
				description = en_zh_zht("Enabled", "启用", "啟用"),
				data = 1,
				hover = en_zh_zht(
					"Will generate a small island in the ocean with a roc nest",
					"将在海洋中生成一个带有友善的大鹏巢穴的小岛",
					"將在海洋中生成一個帶有友善的大鵬巢穴的小島")
			},
		},
	},

	{
		name = "anthill",
		label = en_zh_zht("Ant Hill", "蚁丘", "蟻丘"),
		hover = en_zh_zht(
			"Generate Ant Hill containing: The Den entrance & Queen Womant",
			"生成一个包含蚁后房间的蚁丘",
			"生成一個包含蟻后房間的蟻丘"),
		default = 1,
		options =
		{
			{ description = en_zh_zht("Disabled", "禁用"), data = 0, hover = en_zh_zht("The Anthill will not be generated", "禁用蚁丘生成", "禁用蟻丘生成") },
			{ description = en_zh_zht("Enabled", "启用", "啟用"), data = 1, hover = en_zh_zht("The Anthill will be generated", "启用蚁丘生成", "啟用蟻丘生成") },
		},
	},

	{
		name = "pigruins",
		label = en_zh_zht("Ancient pig ruins", "古代猪人遗迹", "古代豬人遺蹟"),
		hover = en_zh_zht(
			"Generate Ancient pig Ruins containing the Aporkalypse Calendar",
			"生成含有灾变日历的古代猪人遗迹",
			"生成含有災變日曆的古代豬人遺蹟"),
		default = 1,
		options =
		{
			{ description = en_zh_zht("Disabled", "禁用"), data = 0, hover = en_zh_zht("The Pig Ruin will not be generated", "禁用古代猪人遗迹生成", "禁用古代豬人遺蹟生成") },
			{ description = en_zh_zht("Enabled", "启用", "啟用"), data = 1, hover = en_zh_zht("The Pig Ruin will be generated", "启用古代猪人遗迹生成", "啟用古代豬人遺蹟生成") },
		},
	},

	{
		name = "gorgeisland",
		label = en_zh_zht("Gorge Island", "暴食生态群系岛屿", "暴食生態羣系島嶼"),
		hover = en_zh_zht(
			"create an island with content from the gorge event",
			"生成一个暴食生态群系岛屿\n灵感来自官方的暴食(Re-Gorge-itated)模组",
			"生成一個暴食生態羣系島嶼\n靈感來自官方的暴食(Re-Gorge-itated)模組"),
		default = 1,
		options =
		{
			{
				description = en_zh_zht("Disabled", "禁用"),
				data = 0,
				hover = en_zh_zht(
					"This biome will not be generated",
					"禁用该生态群系生成",
					"禁用該生態羣系生成")
			},
			{
				description = en_zh_zht("Enabled", "启用", "啟用"),
				data = 1,
				hover = en_zh_zht(
					"Will generate a small island in the ocean with this biome",
					"将在海洋中生成一个具有此生态群系的岛屿",
					"將在海洋中生成一個具有此生態羣系的島嶼")
			},
		},
	},

	--[[
		{
			name	= "gorgecity",
			label	= "Gorge City",
			hover	= "Generate a Gorge City in Ocean",
			options =
			{
			{description = en_zh_zht("Disabled","禁用"), data = 0, hover = en_zh_zht("This biome will not be generated","禁用该生态群系生成","禁用該生態羣系生成")},
			{description = en_zh_zht("Enabled","启用","啟用"),  data = 1, hover = "Will generate a small island in the ocean with this biome "},	
			},
			default = 1,
		},
		]]

	{
		name = "frost_island",
		label = en_zh_zht("Frost Land", "冰霜岛屿", "冰霜島嶼"),
		hover = en_zh_zht(
			"Creates Frost island、frozen cave where it is winter all the time.",
			"创建永远是冬天的冰霜岛屿、冰霜洞穴\n灵感来自永不妥协(Uncompromising Mode)",
			"創建永遠是冬天的冰霜岛屿、冰霜洞穴\n靈感來自永不妥協(Uncompromising Mode)"),
		default = 10,
		options = {
			{ description = en_zh_zht("NO", "禁用"), data = 5, hover = en_zh_zht("Disable Generation", "禁止生成冰霜岛屿群系", "禁止生成冰霜島嶼羣系") },
			{ description = en_zh_zht("YES", "启用", "啟用"), data = 10, hover = en_zh_zht("Allow Generate on Caves & World", "在洞穴和地面服务器生成冰霜岛屿及冰霜洞穴", "在洞穴和地面伺服器生成冰霜岛屿及冰霜洞穴") },
			{ description = en_zh_zht("YES", "启用", "啟用"), data = 15, hover = en_zh_zht("Just Generate Frost island on World", "只在地面服务器生成冰霜岛屿", "只在地面伺服器生成冰霜島嶼") },
		},
	},

	{
		name = "hamlet_caves",
		label = en_zh_zht("Hamlet Caves", "哈姆雷特洞穴"),
		hover = en_zh_zht(
			"It will generate a new zone in the caves that is very different from the traditional one and with new biomes, accessible in hamlet biome",
			"将在洞穴服务器生成一个与联机版洞穴生态迥异的哈姆雷特群系洞穴区域",
			"將在洞穴伺服器生成一個與連線版洞穴生態迥異的哈姆雷特羣系洞穴區域"),
		default = 1,
		options =
		{
			{ description = en_zh_zht("Disabled", "禁用"), data = 0, hover = en_zh_zht("This biome will not be generated", "禁用该生态群系生成", "禁用該生態羣系生成") },
			{ description = en_zh_zht("Enabled", "启用", "啟用"), data = 1, hover = en_zh_zht("Will generate a new cave zone", "将生成一个新的洞穴区域", "將生成一個新的洞穴區域") },
		},
	},

	{
		name = "monkeyisland",
		label = en_zh_zht("Monkey Island", "月亮码头", "月亮碼頭"),
		hover = en_zh_zht(
			"It will generate the Monkey Island in ocean",
			"将在海洋中生成月亮码头",
			"將在海洋中生成月亮碼頭"),
		default = 1,
		options = {
			{ description = en_zh_zht("Enabled", "启用", "啟用"), data = 1, hover = en_zh_zht("Will generate the Monkey Island", "启用月亮码头生成", "啟用月亮碼頭生成") },
			{ description = en_zh_zht("Disabled", "禁用"), data = 0, hover = en_zh_zht("The Monkey Island will not spawn", "禁用月亮码头生成", "禁用月亮碼頭生成") },
		},
	},


	title(en_zh_zht("for all worlds", "应用于整个世界的设置", "應用於整個世界的設置")),

	{
		name = "Volcano",
		label = en_zh_zht("Volcano", "火山生成模式", "火山生成模式"),
		hover = en_zh_zht(
			"Generates the volcano in the world, if your world has a cave enabled, select the option caves. (will only affects custom and shipwrecked world)",
			"在世界中生成火山生态群系\n需要添加洞穴（仅影响自定义世界和海难世界）",
			"在世界中生成火山生態羣系\n需要添加洞穴（僅影響自定義世界和船難世界）"),
		default = true,
		options = {
			{
				description = en_zh_zht("Complete", "完整版", "完整版"),
				data = true,
				hover = en_zh_zht(
					"Will Generate a complete volcano in terms of content, need caves enabled",
					"将在洞穴服务器生成完整版火山区域\n需要添加洞穴",
					"將在洞穴伺服器生成完整版火山區域\n需要添加洞穴")
			},
			--[[{
								description = en_zh_zht("island","火山岛","火山島"), data = island,
								hover = en_zh_zht(
									"Will Generate a volcano island in terms of content,No need to add caves",
									"将在世界上生成一个火山生态群系岛屿\n不需要添加洞穴",
									"將在世界上生成一個火山生態羣系島嶼\n不需要添加洞穴")},]]
			{
				description = en_zh_zht("Edge", "小型", "小型"),
				data = false,
				hover = en_zh_zht(
					"Will generate volcanic areas around the edge of the map,No need to add caves",
					"将在地图边缘生成小型火山区域\n不需要添加洞穴",
					"將在地圖邊緣生成小型火山區域\n不需要添加洞穴")
			},
		},
	},

	{
		name = "forge",
		label = en_zh_zht("Forge Arena", "熔炉竞技场", "熔爐競技場"),
		hover = en_zh_zht(
			"It will generate the forge arena inside volcano. (will only affects custom and shipwrecked world)",
			"将在火山内生成熔炉竞技场\n灵感来自官方的熔炉(ReForged)模组\n（仅影响自定义世界和海难世界）",
			"將在火山內生成熔爐競技場\n靈感來自官方的熔爐(ReForged)模組\n（僅影響自定義世界和船難世界）"),
		default = 1,
		options = {
			{ description = en_zh_zht("Enabled", "启用", "啟用"), data = 1, hover = en_zh_zht("Will generate the forge arena", "启用熔炉竞技场生成", "啟用熔爐競技場生成") },
			{ description = en_zh_zht("Disabled", "禁用"), data = 0, hover = en_zh_zht("Will not generate the forge arena", "禁用熔炉竞技场生成", "禁用熔爐競技場生成") },
		},
	},

	{
		name = "underwater",
		label = en_zh_zht("Underwater", "海底生态群系", "海底生態羣系"),
		hover = en_zh_zht(
			"It will generate entrances on the surface that lead to the bottom of the ocean. (will only affects custom, hamlet and shipwrecked world)",
			"将在地面服务器生成海底入口\n（仅影响自定义世界、哈姆雷特世界和海难世界）",
			"將在地面伺服器生成海底入口\n（僅影響自定義世界、哈姆雷特世界和船難世界）"),
		default = true,
		options = {
			{
				description = en_zh_zht("Enabled", "启用", "啟用"),
				data = true,
				hover = en_zh_zht("Generate the Underwater Biome, The caves need be enabled to work",
					"启用海底生态群系生成\n需要添加洞穴",
					"啟用海底生態羣系生成\n需要添加洞穴")
			},
			{
				description = en_zh_zht("Disabled", "禁用"),
				data = false,
				hover = en_zh_zht(
					"The Underwater Biome will not spawn",
					"禁用海底生态群系生成",
					"禁用海底生態羣系生成")
			},
		},
	},

	{
		name = "windyplains",
		label = en_zh_zht("Windy Plains Biome", "大风平原群系", "大風平原羣系"),
		hover = en_zh_zht(
			"It will generate the Windy Plains Biome",
			"将生成来自大风平原(Windy Plains)模组的生态群系",
			"將生成來自大風平原(Windy Plains)模組的生態羣系"),
		default = 5,
		options = {
			{
				description = en_zh_zht("Disabled", "禁用"),
				data = 5,
				hover = en_zh_zht(
					"Windy Plains Biome will not spawn",
					"禁用此生态群系生成",
					"禁用此生態羣系生成")
			},
			{
				description = en_zh_zht("Continent", "新大陆", "新大陸"),
				data = 10,
				hover = en_zh_zht(
					"Will generate the Windy Plains Biome in a continent",
					"将此生态群系生成在另一个大陆",
					"將此生態群系生成在另一個大陸")
			},
			{
				description = en_zh_zht("Island", "岛屿", "島嶼"),
				data = 15,
				hover = en_zh_zht(
					"Will generate the Windy Plains Biome in a island",
					"将此生态群系生成在一个岛屿上",
					"將此生態群系生成在一個島嶼上")
			},
		},
	},

	{
		name = "greenworld",
		label = en_zh_zht("Green World", "绿色世界群系", "綠色世界羣系"),
		hover = en_zh_zht(
			"It will generate the Green World",
			"将生成来自绿色世界(Green World)模组的生态群系",
			"將生成來自綠色世界(Green World)模組的生態羣系"),
		default = 5,
		options = {
			{
				description = en_zh_zht("Disabled", "禁用"),
				data = 5,
				hover = en_zh_zht(
					"Green World Biome will not spawn",
					"禁用此生态群系生成",
					"禁用此生態羣系生成")
			},
			{
				description = en_zh_zht("Continent", "新大陆", "新大陸"),
				data = 10,
				hover = en_zh_zht(
					"Will generate the Green World Biome in a continent",
					"将此生态群系生成在另一个大陆",
					"將此生態羣系生成在另一個大陸")
			},
			{
				description = en_zh_zht("Island", "岛屿", "島嶼"),
				data = 15,
				hover = en_zh_zht(
					"Will generate the Green World Biome in a island",
					"将此生态群系单独生成在一个岛屿上",
					"將此生態羣系單獨生成在一個島嶼上")
			},
		},
	},


	title(en_zh_zht("OCEAN SETTINGS", "海洋设置", "海洋設置")),

	{
		name = "Waves",
		label = en_zh_zht("Waves", "海浪"),
		hover = en_zh_zht(
			"The sea generate Waves *wind make them stronger and faster*",
			"海面将生成海浪 *吹风时会有更大的浪*",
			"海面將生成海浪 *吹風時會有更大的浪*"),
		default = true,
		options =
		{
			{ description = en_zh_zht("NO", "禁用"), data = false, hover = "" },
			{ description = en_zh_zht("YES", "启用", "啟用"), data = true, hover = "" },
		},
	},

	{
		name = "whirlpools",
		label = en_zh_zht("Whirlpools", "漩涡", "漩渦"),
		hover = en_zh_zht(
			"The sea generate whirlpools *Whirlpools attract boats and floating objects*",
			"海面将生成漩涡 *漩涡会吸引船只和漂浮物品*",
			"海面將生成漩渦 *漩渦會吸引船隻和漂浮物品*"),
		default = true,
		options =
		{
			{ description = en_zh_zht("NO", "禁用"), data = false, hover = "" },
			{ description = en_zh_zht("YES", "启用", "啟用"), data = true, hover = "" },
		},
	},

	{
		name = "aquaticcreatures",
		label = en_zh_zht("Aquatic Creatures", "海洋生物"),
		hover = en_zh_zht(
			"the sea will randomly generate creatures",
			"海上将随机生成海洋生物",
			"海上將隨機生成海洋生物"),
		default = true,
		options =
		{
			{ description = en_zh_zht("NO", "禁用"), data = false, hover = "" },
			{ description = en_zh_zht("YES", "启用", "啟用"), data = true, hover = "" },
		},
	},

	{
		name = "kraken",
		label = en_zh_zht("Kraken", "海妖"),
		hover = en_zh_zht(
			"Shipwrecked Boss *The Quacken*",
			"将在海上生成海难巨兽：“海妖”",
			"將在海上生成船難巨獸：“海妖”"),
		default = 1,
		options = {
			{ description = en_zh_zht("NO", "禁用"), data = 0, hover = "" },
			{ description = en_zh_zht("YES", "启用", "啟用"), data = 1, hover = "" },
		},
	},

	{
		name = "octopusking",
		label = en_zh_zht("Octopus King", "章鱼王", "章魚王"),
		hover = en_zh_zht(
			"Shipwrecked Dubloon Trader",
			"将在海上生成海难的章鱼王\n可用鱼类料理与他交易",
			"將在海上生成船難的章魚王\n可用魚類料理與他交易"),
		default = 1,
		options = {
			{ description = en_zh_zht("NO", "禁用"), data = 0, hover = "" },
			{ description = en_zh_zht("YES", "启用", "啟用"), data = 1, hover = "" },
		},
	},

	{
		name = "mangrove",
		label = en_zh_zht("Mangrove Biome", "红树林群系", "紅樹林羣系"),
		hover = en_zh_zht(
			"Will generate the mangrove biome on ocean, including the Water Beefalo",
			"将在海上生成包含水牛的红树林生态群系",
			"將在海上生成包含水牛的紅樹林生態羣系"),
		default = 1,
		options = {
			{ description = en_zh_zht("NO", "禁用"), data = 0, hover = "" },
			{ description = en_zh_zht("YES", "启用", "啟用"), data = 1, hover = "" },
		},
	},

	{
		name = "lilypad",
		label = en_zh_zht("Lilypad Biome", "莲花池群系", "蓮花池羣系"),
		hover = en_zh_zht(
			"Will generate the lylypad biome on the water, including the Hippopotamoose",
			"将在海上生成包含河鹿的莲花池生态群系",
			"將在海上生成包含河鹿的蓮花池生態羣系"),
		default = 1,
		options = {
			{ description = en_zh_zht("NO", "禁用"), data = 0, hover = "" },
			{ description = en_zh_zht("YES", "启用", "啟用"), data = 1, hover = "" },
		},
	},

	{
		name = "shipgraveyard",
		label = en_zh_zht("Ship Graveyard Biome", "沉船区群系", "沉船區羣系"),
		hover = en_zh_zht(
			"Will generate the Ship graveyard Biome",
			"将在海上生成沉船区群系",
			"將在海上生成沉船區羣系"),
		default = 1,
		options = {
			{ description = en_zh_zht("NO", "禁用"), data = 0, hover = "" },
			{ description = en_zh_zht("YES", "启用", "啟用"), data = 1, hover = "" },
		},
	},

	{
		name = "coralbiome",
		label = en_zh_zht("Coral Biome", "珊瑚礁群系", "珊瑚礁羣系"),
		hover = en_zh_zht(
			"Will generate the Coral Biome",
			"将在海上生成珊瑚礁生态群系",
			"將在海上生成珊瑚礁生態羣系"),
		default = 1,
		options = {
			{ description = en_zh_zht("NO", "禁用"), data = 0, hover = "" },
			{ description = en_zh_zht("YES", "启用", "啟用"), data = 1, hover = "" },
		},
	},


	title(en_zh_zht("GAMEPLAY SETTINGS", "其它游戏设置", "其它遊戲設置")),

	{
		name = "aporkalypse",
		label = en_zh_zht("Aporkalypse", "大灾变", "大災變"),
		hover = en_zh_zht(
			"Aporkalypse appear every 60 days, if u don't reset the calendar inside the ruins *Active Time: 20 days*",
			"大灾变每60天出现一次\n如果不在遗迹内重置灾变日历，每次将持续20天",
			"大災變每60天出現一次\n如果不在遺蹟內重置災變日曆，每次將持續20天"),
		default = true,
		options =
		{
			{ description = en_zh_zht("YES", "启用", "啟用"), data = true, hover = "" },
			{ description = en_zh_zht("NO", "禁用"), data = false, hover = "" },
		},
	},

	{
		name = "sealnado",
		label = en_zh_zht("Sealnado", "豹卷风", "豹捲風"),
		hover = en_zh_zht(
			"Will spawn in spring on Shipwrecked Biomes *Sealnado/Twister* ",
			"将在春季时的海难生态群系生成海难巨兽：“豹卷风”",
			"將在春季時的船難生態羣系生成船難巨獸：“豹捲風”"),
		default = true,
		options =
		{
			{ description = en_zh_zht("YES", "启用", "啟用"), data = true, hover = "" },
			{ description = en_zh_zht("NO", "禁用"), data = false, hover = "" },
		},
	},

	{
		name = "raftlog",
		label = en_zh_zht("Raft like in Shipwrecked", "海难风格木筏", "船難風格木筏"),
		hover = en_zh_zht(
			"Raft and Logboat Will move like in Shipwrecked DLC",
			"玩家将以与单机版海难DLC相同的方式驾驶木筏和竹筏",
			"玩家將以與單機版船難DLC相同的方式駕駛木筏和竹筏"),
		default = false,
		options =
		{
			{ description = en_zh_zht("YES", "启用", "啟用"), data = true, hover = "" },
			{ description = en_zh_zht("NO", "禁用"), data = false, hover = "" },
		},
	},

	{
		name = "bosslife",
		label = en_zh_zht("Bosses Life", "巨兽生命值", "巨獸生命值"),
		hover = en_zh_zht(
			"Determines how much health mod bosses will have",
			"巨兽不行？不够撸？\n那就提升巨兽的生命值吧！",
			"巨獸不行？不夠擼？\n那就提升巨獸的生命值吧！"),
		default = 1,
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
	},


	title(en_zh_zht("WEATHER SETTINGS", "天气设置", "天氣設置")),

	{
		name = "flood",
		label = en_zh_zht("Flood", "洪水"),
		hover = en_zh_zht(
			"In Spring puddles will spawn and attract Mosquitos from the water",
			"春季下雨时会生成水坑\n并在其中生成具有攻击性的毒蚊子",
			"春季下雨時會生成水坑\n並在其中生成具有攻擊性的毒蚊子"),
		default = 10,
		options =
		{
			{
				description = en_zh_zht("Disabled", "禁用"),
				data = 5,
				hover = en_zh_zht("Disabled", "禁用")
			},
			{
				description = en_zh_zht("Tropical Zone", "海难区域", "船難區域"),
				data = 10,
				hover = en_zh_zht(
					"Will appear only in Tropical Zones",
					"仅在海难生态群系区域出现",
					"僅在船難生態羣系區域出現")
			},
			{
				description = en_zh_zht("All world", "全地图", "全地圖"),
				data = 20,
				hover = en_zh_zht(
					"Will appear in all world",
					"在全世界出现",
					"在全世界出現")
			},
		},
	},

	{
		name = "wind",
		label = en_zh_zht("Wind", "飓风", "颶風"),
		hover = en_zh_zht(
			"affects speed, make trees & plant fall down and the sea create more and powerfull waves",
			"飓风刮起时会影响玩家移动速度\n并将树木和植物吹倒\n在海面形成更大的海浪",
			"颶風颳起時會影響玩家移動速度\n並將樹木和植物吹倒\n在海面形成更大的海浪"),
		default = 10,
		options =
		{
			{ description = en_zh_zht("Disabled", "禁用"), data = 5, hover = en_zh_zht("Disabled", "禁用") },
			{
				description = en_zh_zht("Tropical-Hamlet", "海难区域和哈姆雷特区域", "船難區域和哈姆雷特區域"),
				data = 10,
				hover = en_zh_zht(
					"Will appear only in Tropical and Hamlet Zones",
					"仅在海难区域和哈姆雷特区域出现",
					"僅在船難區域和哈姆雷特區域出現")
			},
			{
				description = en_zh_zht("All world", "全地图", "全地圖"),
				data = 20,
				hover = en_zh_zht(
					"Will appear in all world",
					"在全世界出现",
					"在全世界出現")
			},
		},
	},

	{
		name = "hail",
		label = en_zh_zht("Hail", "冰雹"),
		hover = en_zh_zht(
			"enables to rain hail ice fall from the sky",
			"将在天空降雨时伴有冰雹落下",
			"將在天空降雨時伴有冰雹落下"),
		default = true,
		options =
		{
			{ description = en_zh_zht("YES", "启用", "啟用"), data = true, hover = "" },
			{ description = en_zh_zht("NO", "禁用"), data = false, hover = "" },
		},
	},

	{
		name = "volcaniceruption",
		label = en_zh_zht("Volcanic Eruption", "火山喷发", "火山噴發"),
		hover = en_zh_zht(
			"Enables the Volcanic Eruption",
			"将在夏季时的海难区域定时发生火山喷发",
			"將在夏季時的海難區域定時發生火山噴發"),
		default = 10,
		options =
		{
			{ description = en_zh_zht("Disabled", "禁用"), data = 5, hover = en_zh_zht("Disabled", "禁用") },
			{
				description = en_zh_zht("Tropical Zone", "海难区域", "船難區域"),
				data = 10,
				hover = en_zh_zht(
					"Will appear only in Tropical Zones",
					"仅在海难生态群系区域出现",
					"僅在船難生態羣系區域出現")
			},
			{
				description = en_zh_zht("All world", "全地图", "全地圖"),
				data = 20,
				hover = en_zh_zht(
					"Will appear in all world",
					"在全世界出现",
					"在全世界出現")
			},
		},
	},

	{
		name = "fog",
		label = en_zh_zht("Winter Fog", "迷雾", "迷霧"),
		hover = en_zh_zht("Enables the fog on Winter", "在冬季启用迷雾", "在冬季啟用迷霧"),
		default = 10,
		options =
		{
			{ description = en_zh_zht("Disabled", "禁用"), data = 5, hover = en_zh_zht("Disabled", "禁用") },
			{
				description = en_zh_zht("Hamlet Zone", "哈姆雷特区域", "哈姆雷特區域"),
				data = 10,
				hover = en_zh_zht(
					"Will appear only in Hamlet Zones",
					"仅在哈姆雷特区域出现",
					"僅在哈姆雷特區域出現")
			},
			{
				description = en_zh_zht("All world", "全地图", "全地圖"),
				data = 20,
				hover = en_zh_zht(
					"Will appear in all world",
					"在全世界出现",
					"在全世界出現")
			},
		},
	},

	{
		name = "hayfever",
		label = en_zh_zht("Hay Fever", "花粉症"),
		hover = en_zh_zht("Enables the Hay Fever on Summer", "在夏季启用花粉症", "在夏季啓用花粉症"),
		default = 10,
		options =
		{
			{ description = en_zh_zht("Disabled", "禁用"), data = 5, hover = en_zh_zht("Disabled", "禁用") },
			{
				description = en_zh_zht("Hamlet Zone", "哈姆雷特区域", "哈姆雷特區域"),
				data = 10,
				hover = en_zh_zht(
					"Will appear only in Hamlet Zones",
					"仅在哈姆雷特区域出现",
					"僅在哈姆雷特區域出現")
			},
			{
				description = en_zh_zht("All world", "全地图", "全地圖"),
				data = 20,
				hover = en_zh_zht(
					"Will appear in all world",
					"在全世界出现",
					"在全世界出現")
			},
		},
	},


	title(en_zh_zht("HUD AJUSTMENT", "操作界面调整", "操作界面調整")),

	{
		name = "removedark",
		label = en_zh_zht("remove dark", "移除黑暗"),
		default = false,
		options =
		{
			{ description = en_zh_zht("YES", "启用", "啟用"), data = true, hover = "" },
			{ description = en_zh_zht("NO", "禁用"), data = false, hover = "" },
		},
	},

	{
		name = "automatic_disembarkation",
		label = en_zh_zht("Automatic Disembarkation", "自动离船", "自動離船"),
		hover = en_zh_zht(
			"The player will automatically disembark from the boats",
			"玩家将自动离开船只",
			"玩家將自動離開船隻"),
		default = false,
		options =
		{
			{ description = en_zh_zht("NO", "禁用"), data = false, hover = en_zh_zht("Disable Tab", "禁用选项卡", "禁用選項卡") },
			{ description = en_zh_zht("YES", "启用", "啟用"), data = true, hover = en_zh_zht("Own Extra TAB", "自定义额外选项卡", "自定義額外選項卡") },
		},
	},

	{
		name = "boatlefthud",
		label = en_zh_zht("Boat HUD(Vertical Adjustment)", "海难船只HUD调整", "船難船隻HUD調整"),
		hover = en_zh_zht(
			"Here u can adjust the height of the boat HUD *Health meter",
			"在这里可以调整海难船只HUD（耐久度）的显示高度",
			"在這裏可以調整船難船隻HUD（耐久度）的顯示高度"),
		default = 0,
		options =
		{
			{ description = "-100", data = -100 },
			{ description = "-75",  data = -75 },
			{ description = "-50",  data = -50 },
			{ description = "-25",  data = -25 },
			{ description = "0",    data = 0 },
			{ description = "+25",  data = 25 },
			{ description = "+50",  data = 50 },
			{ description = "+75",  data = 75 },
			{ description = "+100", data = 100 },
		},
	},

	{
		name = "housewallajust",
		label = en_zh_zht("house wall ajust", "室内墙壁调整", "室內牆壁調整"),
		hover = en_zh_zht(
			"Can ajust the wall position if it is not in the center",
			"如果墙壁不在中心位置，可以在这里进行调整",
			"如果牆壁不在中心位置，可以在這裏進行調整"),
		default = 0,
		options =
		{
			{ description = "-7", data = -7 },
			{ description = "-6", data = -6 },
			{ description = "-5", data = -5 },
			{ description = "-4", data = -4 },
			{ description = "-3", data = -3 },
			{ description = "-2", data = -2 },
			{ description = "-1", data = -1 },
			{ description = "0",  data = 0 },
			{ description = "+1", data = 1 },
			{ description = "+2", data = 2 },
			{ description = "+3", data = 3 },
			{ description = "+4", data = 4 },
			{ description = "+5", data = 5 },
			{ description = "+6", data = 6 },
			{ description = "+7", data = 7 },
		},
	},


	title(en_zh_zht("CHARACTERS", "角色调整", "角色調整")),

	{
		name = "disablecharacters",
		label = en_zh_zht("Disable characters", "禁用角色"),
		hover = en_zh_zht("Used for enable or disable characters from the mod", "用于启用或禁用mod中的人物", "用於啟用或禁用mod中的人物"),
		default = false,
		options =
		{
			{ description = en_zh_zht("YES", "启用", "啟用"), data = true, hover = "" },
			{ description = en_zh_zht("NO", "禁用"), data = false, hover = "" },
		},
	},


	title(en_zh_zht("SHARD-DEDICATED", "多层专用服务器设置", "多層專用伺服器設定")),

	{
		name = "enableallprefabs",
		label = en_zh_zht("Enable all prefabs", "启用所有预制件", "啟用所有預製體"),
		hover = en_zh_zht(
			"Used for server shards & Testing, If not active, spawned items can crash in a non mixworld",
			"用于多层世界服务器和测试\n如果不是启用的，生成的物品可能会在非混合世界中崩溃",
			"用於多層世界伺服器和測試\n如果不是啟用的，生成的物品可能會在非混合世界中崩潰"),
		default = false,
		options =
		{
			{ description = en_zh_zht("YES", "启用", "啟用"), data = true, hover = "" },
			{ description = en_zh_zht("NO", "禁用"), data = false, hover = "" },
		},
	},

	{
		name = "tropicalshards",
		label = en_zh_zht("Tropical shards", "多层世界服务器", "多層世界伺服器"),
		hover = en_zh_zht(
			"Presets how world&portals connect using the shard Id,s, *ID 1 = Always Master*",
			"使用服务器Id预设世界和玩家的连接方式, *ID 1 = 始终为主服务器*",
			"使用伺服器Id預設世界和玩家的連接管道，*ID 1 = 始終為主伺服器*"),
		--the table is an array of world ID (whose type is string) 该表是世界ID的数组（其类型为字符串）
		default = 0,
		options =
		{
			{
				description = en_zh_zht("Disabled", "禁用"),
				data = 0,
				hover = en_zh_zht(
					"enable only for dedicated server",
					"仅适用于专用服务器",
					"僅適用於專用伺服器")
			},
			{
				description = "2 + 1 + 1",
				data = 5,
				hover = en_zh_zht(
					"ID=1-2-3-> 2=ROG+Shipwrecked - 1=Caves - 1=Hamlet",
					"ID=1-2-3-> 2=巨人国+海难 - 1=洞穴 - 1=哈姆雷特",
					"ID=1-2-3-> 2=巨人國+船難 - 1=洞穴 - 1=哈姆雷特")
			},
			{
				description = "1 + 1 + 2",
				data = 10,
				hover = en_zh_zht(
					"ID=1-2-3-> 1=ROG - 1=Caves - 2=Shipwrecked+Hamlet",
					"ID=1-2-3-> 1=巨人国 - 1=洞穴 - 2=海难+哈姆雷特",
					"ID=1-2-3-> 1=巨人國 - 1=洞穴 - 2=船難+哈姆雷特")
			},
			{
				description = "1 + 1 + 1 + 1",
				data = 20,
				hover = en_zh_zht(
					"ID=1-2-3-4-> 1=ROG - 1=Caves - 1=Shipwrecked - 1=Hamlet",
					"ID=1-2-3-4-> 1=巨人国 - 1=洞穴 - 1=海难 - 1=哈姆雷特",
					"ID=1-2-3-4-> 1=巨人國 - 1=洞穴 - 1=船難 - 1=哈姆雷特")
			},
			{
				description = en_zh_zht("Lobby Only", "仅大厅", "僅大廳"),
				data = 30,
				hover = en_zh_zht(
					"ID=1-2-3-4-5-> Lobby=ID 1 & 1+1+1+1 setup *ROG=ID 5 in this setup*",
					"ID=1-2-3-4-5-> 大厅=ID 1 & 1+1+1+1设置 *在此设置中巨人国=ID 5*",
					"ID=1-2-3-4-5-> 大廳=ID 1 & 1+1+1+1設定 *在此設定中巨人國=ID 5*")
			},
		},
	},

	{
		name = "lobbyexit",
		label = en_zh_zht("Lobby exit", "大厅出口", "大廳出口"),
		hover = en_zh_zht(
			"Spawn an Lobby return portal in ROG -> lobby=ID 1",
			"在巨人国中生成一个返回大厅的传送门 -> 大厅=ID 1",
			"在巨人國中生成一個返回大廳的傳送門 -> 大廳=ID 1"),
		default = false,
		options =
		{
			{ description = en_zh_zht("YES", "启用", "啟用"), data = true, hover = "" },
			{ description = en_zh_zht("NO", "禁用"), data = false, hover = "" },
		},
	},


	title(en_zh_zht("OTHER MODS (need mod enabled)", "群系扩展(需要启用模组)", "羣系擴展(需要啟用模組)")),

	{
		name = "cherryforest",
		label = en_zh_zht("Cherry Forest", "樱花林", "櫻花林"),
		hover = en_zh_zht(
			"only works if the mod below is enabled",
			"仅启用樱花林(Cherry Forest)模组时生效",
			"僅啟用櫻花林(Cherry Forest)模組時生效"),
		default = 10,
		options =
		{
			{
				description = en_zh_zht("Mainland", "主大陆", "主大陸"),
				data = 10,
				hover = en_zh_zht(
					"Place the Cherry Forest on the main continent so it's easier to find it. 󰀅u󰀅",
					"将樱花林放置在主大陆上，以便更容易找到它",
					"將櫻花林放置在主大陸上，以便更容易找到它")
			},
			{
				description = en_zh_zht("Island", "岛屿", "島嶼"),
				data = 20,
				hover = en_zh_zht(
					"Generate a large island to discover in the ocean, or start on it with Wirlywings.",
					"在海洋中生成一个大岛屿进行探索，或者通过飞翼启动器在岛上开始",
					"在海洋中生成一個大島嶼進行探索，或者通過飛翼啓動器在島上開始")
			},
			{
				description = en_zh_zht("Grove", "小樱花林", "小櫻花林"),
				data = 30,
				hover = en_zh_zht(
					"Also an Island, smaller than the original but with more interesting shapes.",
					"同样是岛屿地形，但比原地形小且形状更有趣",
					"同樣是島嶼地形，但比原地形小且形狀更有趣")
			},
			{
				description = en_zh_zht("Archipelago", "群岛", "羣島"),
				data = 40,
				hover = en_zh_zht(
					"An Island in shards divided by rivers, it's harder but fun for base-building!",
					"一个被河流分割的岛屿，更难但更有趣的基地建造！",
					"一個被河流分割的島嶼，更難但更有趣的基地建造！")
			},
			{
				description = en_zh_zht("Moon Morphis", "月岛", "月島"),
				data = 50,
				hover = en_zh_zht(
					"The Cherry Forest will be merged within the Lunar Island!",
					"樱花林将与月岛合并！",
					"櫻花林將與月島合併！")
			},
		},
	},


	title("LUAJIT"),
	{
		name = "luajit",
		label = en_zh_zht("luajit", "兼容LUAJIT（迷宫玩法）", "兼容LUAJIT（迷宮玩法）"),
		hover = en_zh_zht(
			"luajit will works but Will disable minimaps on pig ruins entrance.",
			"启用了LUAJIT的玩家需开启，但会使古代猪人遗迹入口房间地面上的地图不再显示\n(同时小型古代猪人遗迹设置将失效)",
			"啟用了LUAJIT的玩家需開啟，但會使古代豬人遺跡入口房間地面上的地圖不再顯示\n(同時小型古代猪人遺跡設定將失效)"),
		default = false,
		options =
		{
			{ description = en_zh_zht("YES", "是"), data = true, hover = en_zh_zht("Enabled", "启用", "啟用") },
			{ description = en_zh_zht("NO", "否"), data = false, hover = en_zh_zht("Disabled", "禁用") },
		},
	},

	------------ninguem pode ver isso------------------------	
	{
		name = "megarandomCompatibilityWater",
		label = en_zh_zht("megarandomCompatibilityWater", "兼容超级随机世界生成", "兼容超級隨機世界生成"),
		default = false,
	},
}


--swampyvenice
--pinacle
--gorgeisland
--gorgecity
--mactuskonice
--pandabiome
--Shipwrecked_plus
