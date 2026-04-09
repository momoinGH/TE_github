AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then return end
    inst:AddComponent("rocmanager") --饥荒大鹏鸟管理
    inst:AddComponent("banditmanager") --蒙面猪生成
end)
