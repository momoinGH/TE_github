modimport "modmain/quagmire/prefabs/firepit"



AddPrefabPostInit("saltrock", function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("mealable")
    inst.components.mealable:SetType("salt")
end)
