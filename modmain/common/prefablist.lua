PrefabFiles = {
    "fryfocals_charge",    --镭射焦点
    "goggles",             --镭射焦点
    "hiddendanger_fx",     --陷阱标记
    "thumper",             --撼地者
    "tro_veggies",         --蔬菜
    "antivenom",           --解毒剂
    "armor_void_cloak",    --虚空斗篷
    "buffs_tro",           -- buff集合
    "yellow_mushroom",     --黄蘑菇
    "spore_yellow",        --黄色孢子
    "mushtree_yellow",     --黄蘑菇树
    "spider_mutators_new", --韦伯新的变身涂鸦
    "splash_water",        --海水特效
}

if TUNING.tropical.tropicalshards ~= 0 then
    table.insert(PrefabFiles, "porkland_sw_entrance") --去各种世界的传送门
end

if TUNING.tropical.boat then
    table.insert(PrefabFiles, "pro_pirate_boat_group") --强盗船
end
