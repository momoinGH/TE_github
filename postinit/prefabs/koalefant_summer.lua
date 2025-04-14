-- 如果夏季考拉象在冰岛上生成则替换成冬季的
local function OnSpawnedForHunt(inst, data)
    local ground = TheWorld.Map:GetTileAtPoint(inst.Transform:GetWorldPosition())
    if ground == GROUND.SNOWLAND or ground == GROUND.ICELAND then
        ReplacePrefab(inst, "koalefant_winter")
    end
end

AddPrefabPostInit("koalefant_summer", function(inst)
    if not TheWorld.ismastersim then return end

    inst:ListenForEvent("spawnedforhunt", OnSpawnedForHunt)
end)