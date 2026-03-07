AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("twisterspawner")        --豹卷风生成
    inst:AddComponent("whalehunter")           --鲸鱼生成
    inst:AddComponent("rainbowjellymigration") --彩虹水母生成
end)
