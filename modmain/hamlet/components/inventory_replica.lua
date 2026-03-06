-- 身上总钱数
AddClassPostConstruct("components/inventory_replica", function(self)
    self.check_all_oincs = nil

    local OldHas = self.Has
    function self:Has(prefab, amount, checkallcontainers, ...)
        if self.check_all_oincs and prefab == "oinc" then
            local _, oincamount = OldHas(self, "oinc", 0, true)
            local _, oinc10amount = OldHas(self, "oinc10", 0, true)
            local _, oinc100amount = OldHas(self, "oinc100", 0, true)
            local total = oincamount + (oinc10amount * 10) + (oinc100amount * 100)
            return total >= amount, total
        end
        return OldHas(self, prefab, amount, checkallcontainers, ...)
    end
end)
