-- 这些东西在海底不能点燃
local cant_ignite_tags = {
    "lighter"
}

local function IgniteBefore(self)
    if self.inst:HasOneOfTags(cant_ignite_tags) and self.inst:IsInUnderWaterArea() then
        return nil, true
    end
end


AddComponentPostInit("burnable", function(self)
    Hooks.FnDecorator(self, "Ignite", IgniteBefore)
end)
