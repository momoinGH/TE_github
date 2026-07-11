PrefabFiles =
{
    "feather_chicken",                --鸡毛
    "chicken",                        --鸡
    "quagmire_merm_house",            --破烂的小屋
    -- "quagmire_foods2",             --食物 (已移除，使用基础游戏的 quagmire_foods)
    "quagmire_slaughtertool",         --屠宰工具
    "quagmire_seedpackets",           --种子包
    "quagmire_sugarwoodtree_sapling", --棉树苗
    "quagmire_sugarwoodtree_cone",    --棉树种子
    "quagmire_oldstructures",         --一堆破烂建筑
    "quagmire_altar_statue",          --饥饿之兽
    "quagmire_portal",                --远古大门
    "quagmire_smallmeat",             --肉碎
    "quagmire_mushroomstump",         --蘑菇
    "quagmire_mushrooms",             --蘑菇
    "quagmire_safe",                  --保险箱
    "quagmire_parkspike",             --铁栅栏


    "quagmire_traders",      --商人
    "quagmire_swampigelder", --沼泽猪长老


    "quagmiregoat",                 --沼地山羊
    "quagmiregoatherd",             --沼地山羊生成器
    "quagmire_swampig",             --沼泽猪
    "quagmire_swampig_house",       --沼泽猪舍
    "quagmire_pigeon",              --鸽子
    "quagmire_spiceshrub",          --带斑点的小灌木
    "dug_quagmire_spotspice_shrub", --带斑点的小灌木丛
    "turf_quagmire",                --地皮
    "quagmire_plants_planted",      --植物
    "pebblecrabspawner",
    "chickenhouse",                 --鸡舍
}

-- 把暴食依赖的预制件文件加到这里面，暴食预制件文件如果不提前声明，生成的时候会丢失动画，这里只把固定前缀的文件加进来，别的可手动写一下
require("prefablist")
for _, v in ipairs(PREFABFILES) do
    if string.starts(v, "quagmire") then
        table.insert(PrefabFiles, v)
    end
end
