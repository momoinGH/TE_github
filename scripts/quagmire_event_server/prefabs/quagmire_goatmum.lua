local brain = require "brains/goatmumbrain"

local function OnPlayerNear(inst)
    if not inst.coin then
        inst.sg:GoToState("coin")
    end
end

local function OnSave(inst, data)
    data.coin = inst.coin
end

local function OnLoad(inst, data)
    if not data then return end

    inst.coin = data.coin
end

return {
    master_postinit = function(inst, prefabs)
        inst.coin = false --是否已经给予过初始硬币

        inst:AddComponent("locomotor")
        inst.components.locomotor.runspeed = TUNING.MERM_RUN_SPEED
        inst.components.locomotor.walkspeed = TUNING.MERM_WALK_SPEED

        inst:AddComponent("inspectable")
        inst:AddComponent("knownlocations")

        inst:AddComponent("prototyper")
        inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.QUAGMIRE_GOATMUM

        inst:AddComponent("playerprox")
        inst.components.playerprox.near = 6
        inst.components.playerprox.far = 8
        inst.components.playerprox.onnear = OnPlayerNear

        inst:SetStateGraph("SGgoatmum")
        inst:SetBrain(brain)

        inst.OnSave = OnSave
        inst.OnLoad = OnLoad
    end
}
