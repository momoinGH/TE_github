local function OnTurnOn(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl1_run", "sound")
end

local function OnTurnOff(inst)
    inst:DoTaskInTime(1.5, function()
        inst.SoundEmitter:KillSound("sound")
        inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl1_ding", "sound")
    end)
end

return {
    master_postinit = function(inst)
        inst:AddTag("irreplaceable")

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")

        inst:AddComponent("prototyper")
        inst.components.prototyper.onturnon = OnTurnOn
        inst.components.prototyper.onturnoff = OnTurnOff
        inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.GORGE_TWO
    end
}
