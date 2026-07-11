-- 表示个物品可以放进锅里烹饪
local Quagmire_Stewable = Class(function(self, inst)
    self.inst = inst

    inst:AddTag("quagmire_stewable")
end)

return Quagmire_Stewable
