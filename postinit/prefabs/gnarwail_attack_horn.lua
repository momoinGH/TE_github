local function CheckHorn(inst)
    local boat = inst:GetCurrentPlatform()
    if not boat then
        inst.components.health:Kill()
    end
end

--- 海难的船太小，一角鲸的角可能扎不到，获取不到boat，就会报错
AddPrefabPostInit("gnarwail_attack_horn", function(inst)
    if not TheWorld.ismastersim then return end

    inst:DoTaskInTime(TUNING.GNARWAIL.HORN_RETREAT_TIME - 0.1, CheckHorn)
end)