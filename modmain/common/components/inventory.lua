local function IsItemNameEquipped(self, item_name)
    for k, v in pairs(self.equipslots) do
        if v.prefab == item_name then
            return true
        end
    end
    return false
end

AddComponentPostInit("inventory", function(self)
    self.IsItemNameEquipped = IsItemNameEquipped
end)
