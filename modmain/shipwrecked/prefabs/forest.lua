AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("whalehunter")           --鲸鱼生成
    inst:AddComponent("rainbowjellymigration") --彩虹水母生成
    inst:AddComponent("tigersharker")          --虎鲨生成
    if TUNING.tropical.twister then
        inst:AddComponent("twisterspawner")    --豹卷风生成
        -- inst:AddComponent("tro_twistermanager") --这个没写完
    end
    if TUNING.tropical.volcaniceruption then
        inst:AddComponent("volcanomanager") --火山喷发
    end
    if TUNING.tropical.waves then
        inst:AddComponent("sw_wavemanager") --海浪
    end
end)
