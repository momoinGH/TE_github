AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim then return end

    AddComponentIfNot(inst, "bigfooter")
end)
