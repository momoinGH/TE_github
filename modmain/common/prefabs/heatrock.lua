local function Init(inst)

end

AddPrefabPostInit("heatrock", function(inst)
    if not TheWorld.ismastersim then return end

    inst:DoTaskInTime(0, Init)
end)
