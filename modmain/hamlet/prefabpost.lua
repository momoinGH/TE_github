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
