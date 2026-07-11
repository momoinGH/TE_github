local brain = require "brains/goatbrain"

return {
    master_postinit = function(inst, prefabs)
        MakeHauntablePanic(inst)

        inst:AddComponent("inspectable")
        inst:AddComponent("knownlocations")

        MakeMediumBurnableCharacter(inst, "pig_torso")
        MakeMediumFreezableCharacter(inst, "pig_torso")

        inst:SetStateGraph("SGgoat")
        inst:SetBrain(brain)

        inst:AddComponent("prototyper")
        inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.QUAGMIRE_GOATKID
    end
}
