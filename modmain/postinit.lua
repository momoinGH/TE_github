-------------------------------------------------------------------------------------


---modimport("postinit/tropical_climate")         --热带气候
---modimport("postinit/room_camera")              --房间镜头
---modimport("postinit/boat")                     --单人船相关修改


-- do not know how to sort
---modimport("postinit/oceancolor")
modimport("postinit/postinit_poisonables") --posonables--and loot dropper--
---modimport("postinit/camera")               --旧的房间镜头，但是现在不能删
---modimport("postinit/sim_rain_effect")
-- modimport("postinit/player_darkness") --没有用
---modimport("postinit/farm")    --种植相关  --通过veggies改变随机种子权重


---modimport("postinit/entity")  --不知道这个是干啥的
modimport("postinit/naughty") --淘气值


----------------------------components-------------------------------------------

-- modimport("postinit/components/oceancolor")
-- modimport("postinit/components/playervision")
-- modimport("postinit/components/trap")
modimport("postinit/components/ambientlighting")
modimport("postinit/components/ambientsound")
modimport("postinit/components/armor")
modimport("postinit/components/boatphysics")
modimport("postinit/components/builder")
modimport("postinit/components/colourcube")
modimport("postinit/components/combat")
-- modimport("postinit/components/container")
modimport("postinit/components/curseditem") --威尔伯不受诅咒饰品影响
modimport("postinit/components/dynamicmusic")
modimport("postinit/components/embarker")
modimport("postinit/components/flotsamgenerator") --漂浮物刷新，TODO可能不生效
modimport("postinit/components/groundpounder")    --这个组件拍地板的？
---modimport("postinit/components/hatchable")这是孵露比蛋的吗？***
modimport("postinit/components/healthtrigger")    --这个生命值管理器是干嘛的？
modimport("postinit/components/hounded")          --猎犬袭击
modimport("postinit/components/inventory")        ----主要是物品栏的钱的计算
---modimport("postinit/components/inventory_prevent_pick") ----可能和船拿不起来有关系***
modimport("postinit/components/inventoryitem")    --优化架子上放东西？
---modimport("postinit/components/penguinspawner")控制企鸥生成，现在是覆盖的***
---modimport("postinit/components/playercontroller")***
---modimport("postinit/components/playerspawner")***
---modimport("postinit/components/snowtile") -- disable snow effeccts控积雪***
modimport("postinit/components/soundemitter")
---modimport("postinit/components/thief")偷东西，能否打开容器、丢弃物品、吃特定的食物，是给小狐狸用的吗？***
---modimport("postinit/components/wavemanager")波浪管理***
---modimport("postinit/components/worldstate")世界状态***
---modimport("postinit/components/edible")吃荨麻治花粉的？***
modimport("postinit/components/plantregrowth")   --植物再生 --黄蘑菇树成长

modimport("postinit/components/areaaware")       -- 用于控制熊大和巨鹿刷新条件
modimport("postinit/components/drownable")       -- 在室内不会落水
modimport("postinit/components/oar")             -- 桨加标签
modimport("postinit/components/vanish_on_sleep") --

---------------------prefabs------------------------------

-- modimport("postinit/prefabs/cave")
modimport("postinit/prefabs/farm_plants") --屏蔽随机种子种出三合一作物
-- modimport("postinit/prefabs/forest")
-- modimport("postinit/prefabs/image_minisign") --会影响到其他mod
---modimport("postinit/prefabs/blueprints")不老泉蓝图不可燃烧
modimport("postinit/prefabs/dock_kit")        --码头套件安放相关
modimport("postinit/prefabs/floatable_items") --海洋世界里石头漂浮
modimport("postinit/prefabs/gears")
modimport("postinit/prefabs/lots_of_things")
modimport("postinit/prefabs/meatrack")
modimport("postinit/prefabs/mosquitosack")
modimport("postinit/prefabs/mushroom_farm")
modimport("postinit/prefabs/player_classified")
-- modimport("postinit/prefabs/player_hayfever")
---modimport("postinit/prefabs/player") --shopper, drownable, infestable***
modimport("postinit/prefabs/sword_lunarplant") --亮茄剑加劈砍功能
modimport("postinit/prefabs/trinket_1")
modimport("postinit/prefabs/warningshadow")
modimport("postinit/prefabs/wobster")
modimport("postinit/prefabs/world")

modimport("postinit/prefabs/quaker_rocks")         --删除多余的地震石头
modimport("postinit/prefabs/koalefant_summer")     --冰岛翻冬象
modimport("postinit/prefabs/snowcovered")          --冰岛东西落雪
modimport("postinit/prefabs/gnarwail_attack_horn") --一角鲸扎小饼船

--screens and widgets
---modimport("postinit/screens/playerhud")      ---雾和花粉症效果在这里

---modimport("postinit/widgets/container_boat") -- boat container sizing tweak by EvenMr
modimport("postinit/widgets/craftingmenu_ingredients")
--("postinit/widgets/containers") --new containers
---modimport("postinit/widgets/crafttabs")优化制作栏***
---modimport("postinit/widgets/healthbadge")毒在血量上的显示***
---modimport("postinit/widgets/inventorybar")       -- 船HUD自适应***
---modimport("postinit/widgets/seasonsdisplay.lua") --大树藤树荫层级？***
---modimport("postinit/widgets/statusdisplays_speed")速度图标？***
--modimport("postinit/widgets/uiclock_bloodmoon")哈姆雷特血月，在ui里面有了
modimport("postinit/widgets/image")
modimport("postinit/widgets/mapstyle") --地图边框

--stagegraph
--modimport("postinit/stategraphs/stagegraph_wilson") --需要整理
--modimport("postinit/stategraphs/SGwilson")
--modimport("postinit/stategraphs/SGwilson_client")
