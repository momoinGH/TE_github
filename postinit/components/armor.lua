--[[这些是TA的
local TROENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------
local Armor = require("components/armor")

TROENV.AddComponentPostInit("Armor", function(self)

end)

function Armor:SetImmuneTags(tags)
    self.immunetags = tags
end

local oldcanresist = Armor.CanResist
function Armor:CanResist(attacker, weapon)
    if attacker and self.immunetags then
        for k, v in pairs(self.immunetags) do
            if attacker:HasTag(v) then
                return false
            end
        end
    end

    return oldcanresist
end]]

local Utils = require("tropical_utils/utils")

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