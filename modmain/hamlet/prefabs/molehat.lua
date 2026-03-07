-- 可以抵挡哈姆雷特大雾
AddPrefabPostInit("molehat", function(inst)
    inst:AddTag("clearfog")
end)
