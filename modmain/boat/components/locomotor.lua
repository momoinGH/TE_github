-- 划船时返回船的移速
local function RunSpeedBefore(self)
    local boat = self.inst:TroGetSWBoat()
    if boat and boat.runspeed then
        return { boat.runspeed }, true
    end
end

AddComponentPostInit("locomotor", function(self)
    if self.inst:HasTag("player") then
        -- Hooks.FnDecorator(self, "OnUpdate", OnUpdateBefore, OnUpdateAfter)
        Hooks.FnDecorator(self, "RunSpeed", RunSpeedBefore)
    end
end)
