local function ArmorCanResistBefore(self, attacker, weapon)
    if attacker and self.immunetags then
        for k, v in pairs(self.immunetags) do
            if attacker:HasTag(v) or (weapon ~= nil and weapon:HasTag(v)) then
                return { false }, true
            end
        end
    end
end

--不能抵抗标签，如果指定了标签，则对于含有该标签的攻击者伤害不抵抗，与tags不同，tags只能抵抗记录已有标签的攻击
AddComponentPostInit("armor", function(self)
    self.immunetags = nil

    function self:SetImmuneTags(tags)
        self.immunetags = tags
    end

    Utils.FnDecorator(self, "CanResist", ArmorCanResistBefore)
end)
