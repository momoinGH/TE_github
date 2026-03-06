AddClassPostConstruct("components/builder_replica", function(self)
    local oldHas = self.Has
    function self:Has(item, amount, ...)
        if not TUNING.OINCS[item] or self.inst.components.inventory or not self.classified then --主机交给主机组件判断
            return oldHas(self, item, amount, ...)
        end

        local all = 0
        for key, val in pairs(TUNING.OINCS) do
            local _, count = oldHas(self, key, 1, ...)
            all = all + count * val
        end

        local need = TUNING.OINCS[item] * amount
        if all >= need then
            return true, math.floor(all / TUNING.OINCS[item])
        else
            return false, all
        end
    end

    local HasIngredients = self.HasIngredients
    function self:HasIngredients(recipe, ...)
        local check_all_oincs = self.inst.replica.inventory.check_all_oincs
        self.inst.replica.inventory.check_all_oincs = true
        local ret = { HasIngredients(self, recipe, ...) }
        self.inst.replica.inventory.check_all_oincs = check_all_oincs
        return unpack(ret)
    end
end)
