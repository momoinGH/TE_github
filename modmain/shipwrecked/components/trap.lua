-- 海上陷阱可以抓海里的龙虾

local function DoSpringBefore(self)
    if not self.pro_water then return end

    if self.target
        and self.target:IsValid()
        and not self.target:IsInLimbo()
        and not (self.target.components.health ~= nil and self.target.components.health:IsDead())
        and self.target.components.inventoryitem ~= nil
        and self.target.components.inventoryitem.trappable
    then
        if self.target:HasTag("lobster") then
            self.target.prefab = self.target.prefab .. "_land"
        end
    end
end

AddComponentPostInit("trap", function(self)
    self.pro_water = nil --海里的陷阱
    Hooks.FnDecorator(self, "DoSpring", DoSpringBefore)
end)
