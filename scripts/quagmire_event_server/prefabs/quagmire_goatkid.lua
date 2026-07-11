local brain = require "brains/goatbrain"

return {
    master_postinit = function(inst, prefabs)
        inst:AddComponent("inspectable")
        inst:AddComponent("knownlocations")

        inst:SetStateGraph("SGgoat")
        inst:SetBrain(brain)

        inst:AddComponent("prototyper")
        inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.QUAGMIRE_GOATKID
    end
}
