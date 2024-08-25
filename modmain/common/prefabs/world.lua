local Utils = require("tropical_utils/utils")

AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim then return end

    AddComponentIfNot(inst, "bigfooter")


    inst:AddComponent("tro_tempentitytracker")

    -- TODO 优化掉，使用tro_tempentitytracker组件实现，并且写哈姆雷特代码里
    -- world存一点不需要保存的对象，省去查找Ents
    inst.pig_ruins_exits = {}         --猪人遗迹外部出口二
    inst.cave_entrance_roc_exits = {} --哈姆雷特有荧光果的那种洞穴外部出口二
    inst.anthill_exits = {}           --蚁丘出口
end)
