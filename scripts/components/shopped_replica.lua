local Shopped = Class(function(self, inst)
    self.inst = inst

    self.goods = net_string(inst.GUID, "shopped.goods")
    self.costprefab = net_string(inst.GUID, "shopped.costprefab")
    self.cost = net_smallbyte(inst.GUID, "shopped.cost") --[0..63]
end)

function Shopped:SetGoods(goods)
    self.goods:set(goods or "")
end

function Shopped:GetGoods()
    return self.goods:value()
end

function Shopped:SetCostPrefab(costprefab)
    self.costprefab:set(costprefab or "")
end

function Shopped:GetCostPrefab()
    return self.costprefab:value()
end

function Shopped:SetCost(cost)
    self.cost:set(cost or 0)
end

function Shopped:GetCost()
    return self.cost:value()
end

return Shopped
