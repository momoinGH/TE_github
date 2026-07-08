AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("tro_messagebottlemanager") --mod的瓶子信数据
end)
