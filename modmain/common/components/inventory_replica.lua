local function IsItemNameEquipped(self, item_name)
    if self.inst.components.inventory ~= nil then
        return self.inst.components.inventory:IsItemNameEquipped(item_name)
    end

    for _, v in pairs(EQUIPSLOTS) do
        local item = self:GetEquippedItem(v)
        if item and item.prefab == item_name then
            return true
        end
    end
    return false
end

AddClassPostConstruct("components/inventory_replica", function(self)
    self.IsItemNameEquipped = IsItemNameEquipped
end)
