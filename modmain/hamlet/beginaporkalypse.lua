-- 大灾变时花都变成恶魔花
for _, v in ipairs({
    "flower",
    "flower_rose",
    "planted_flower"
}) do
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then return end
        inst:ListenForEvent("beginaporkalypse", function()
            if inst:IsInHamletArea() then
                RemoveFromRegrowthManager(inst) --花移除前要调用这个移除onrmeve的监听，不然会在附近再生的
                SpawnAt("flower_evil", inst)
                if inst:IsValid() then
                    inst:DoTaskInTime(0, inst.Remove)
                end
            end
        end, TheWorld)
    end)
end
