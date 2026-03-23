-- 大灾变时花都变成恶魔花
for _, v in ipairs({
    "flower",
    "flower_rose",
    "planted_flower"
}) do
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then return end
        inst:ListenForEvent("beginaporkalypse", function()
            if inst:IsInHamletArea() and inst:IsValid() then
                RemoveFromRegrowthManager(inst) --花移除前要调用这个移除onrmeve的监听，不然会在附近再生的
                inst:DoTaskInTime(0, ReplacePrefab, "flower_evil")
            end
        end, TheWorld)
    end)
end


AddPrefabPostInit("flower_evil", function(inst)
    if not TheWorld.ismastersim then return end

    inst:ListenForEvent("endaporkalypse", function()
        if inst:IsInHamletArea() and inst:IsValid() then
            RemoveFromRegrowthManager(inst)
            inst:DoTaskInTime(0, ReplacePrefab, "flower")
        end
    end, TheWorld)
end)
