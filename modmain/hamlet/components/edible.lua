-- 吃东西可以消除花粉症
local function OnEaten(inst, data)
    local eater = data and data.eater
    local antihistamine = inst.components.edible and inst.components.edible.antihistamine
    if eater and eater.components.hayfever and antihistamine then
        eater.components.hayfever:SetNextSneezeTime(antihistamine)
    end
end

AddComponentPostInit("edible", function(self, inst)
    inst:RemoveEventCallback("oneaten", OnEaten)
    inst:ListenForEvent("oneaten", OnEaten)
end)
