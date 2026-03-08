modimport "modmain/frostisland/prefabs/koalefant_summer.lua" --象生成




AddPrefabPostInitAny(function(inst)
    -----mostra neve--------------
    if inst:HasTag("SnowCovered") then
        inst:DoTaskInTime(0.5, function(inst)
            if inst:IsInFrostisLandArea() then
                inst:AddTag("mostraneve") --给冰岛上可以覆盖雪的东西加一个标签
            end
        end)
    end
end)
