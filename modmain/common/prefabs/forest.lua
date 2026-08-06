AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("tro_messagebottlemanager") --海难瓶中信数据
end)
