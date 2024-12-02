IsInTropicalArea = function(inst)
    local x, _, z = inst.Transform:GetWorldPosition()
    return TheWorld.Map:IsTropicalAreaAtPoint(x, 0, z)
end

IsInShipwreckedArea = function(inst)
    local x, _, z = inst.Transform:GetWorldPosition()
    return TheWorld.Map:IsShipwreckedAreaAtPoint(x, 0, z)
end

IsInHamletArea = function(inst)
    local x, _, z = inst.Transform:GetWorldPosition()
    return TheWorld.Map:IsHamletAreaAtPoint(x, 0, z)
end

IsInVolcanoArea = function(inst)
    local x, _, z = inst.Transform:GetWorldPosition()
    return TheWorld.Map:IsVolcanoAreaAtPoint(x, 0, z)
end
