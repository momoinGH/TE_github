local function IsItemNameEquipped(self, item_name)
    for k, v in pairs(self.equipslots) do
        if v.prefab == item_name then
            return true
        end
    end
    return false
end

local function GetMoney(self)
    local _, oincamount = self:Has("oinc", 0)
    local _, oinc10amount = self:Has("oinc10", 0)
    local _, oinc100amount = self:Has("oinc100", 0)
    return oincamount + (oinc10amount * 10) + (oinc100amount * 100)
end

AddComponentPostInit("inventory", function(self)
    self.IsItemNameEquipped = IsItemNameEquipped
    self.GetMoney = GetMoney
end)
