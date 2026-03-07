AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("economy") --猪币购买
    inst:AddComponent("quaker_interior") --哈姆雷特蚁后地震生成
end)
