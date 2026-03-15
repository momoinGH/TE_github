AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("aporkalypse")           --蝙蝠生成
    inst:AddComponent("rocmanager")            --饥荒大鹏鸟管理
end)
