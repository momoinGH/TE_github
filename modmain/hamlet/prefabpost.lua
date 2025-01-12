local Utils = require "tropical_utils/utils"

AddReplicableComponent("hayfever")

AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return end

    if TUNING.tropical.hayfever ~= 0 then
        inst:AddComponent("hayfever")
    end

    if TUNING.tropical.fog ~= 0 then
        inst:AddComponent("grogginess")
        inst.components.grogginess:SetResistance(3)
    end
end)


AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim then return end

    TheWorld.components.tro_tempentitytracker:AddKey("pig_ruins_exits") --遗迹出口
    TheWorld.components.tro_tempentitytracker:AddKey("cave_exit_roc")   --洞穴出口
    TheWorld.components.tro_tempentitytracker:AddKey("anthill_exit")    --蚁穴出口
end)

AddComponentPostInit("autoterraformer", function(self)
    Utils.FnDecorator(self, "DoTerraform", function(_self, px, py, pz, _x, _y)
        local tile = TheWorld.Map:GetTileAtPoint(px, py, pz)
		if tile == GROUND.GASRAINFOREST or tile == GROUND.DEEPRAINFOREST then return nil, true end
    end)
end)