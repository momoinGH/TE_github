AddPrefabPostInit("nightmarefuel", function (inst)
    if TheWorld.ismastersim then
        inst:AddComponent("tradable")
    end
end)