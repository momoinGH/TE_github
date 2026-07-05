-- 如果夏季考拉象在冰岛上生成则替换成冬季的
local function OnSummerSpawnedForHunt(inst, data)
    if inst:IsValid() and inst:TroHasWinter() then
        inst:DoTaskInTime(0, ReplacePrefab, "koalefant_winter")
    end
end

AddPrefabPostInit("koalefant_summer", function(inst)
    if not TheWorld.ismastersim then return end
    inst:ListenForEvent("spawnedforhunt", OnSummerSpawnedForHunt)
end)

----------------------------------------------------------------------------------------------------
local function OnWinterSpawnedForHunt(inst, data)
    if inst:IsValid() and not inst:TroHasWinter() then
        inst:DoTaskInTime(0, ReplacePrefab, "koalefant_summer")
    end
end

AddPrefabPostInit("koalefant_winter", function(inst)
    if not TheWorld.ismastersim then return end
    inst:ListenForEvent("spawnedforhunt", OnWinterSpawnedForHunt)
end)
