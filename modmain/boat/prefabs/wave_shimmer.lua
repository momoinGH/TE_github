for _, v in ipairs({
    "wave_shimmer",
    "wave_shimmer_med",
    "wave_shimmer_deep",
    "wave_shimmer_flood"
}) do
    AddPrefabPostInit(v, function(inst)
        inst:AddTag("wave_shimmer")
        if not TheWorld.ismastersim then return end
    end)
end
