--灰烬施肥，给咖啡的
AddPrefabPostInit("ash", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    if not inst.components.fertilizer then
        inst:AddComponent("fertilizer")
    end
end)
