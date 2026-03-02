local Driver = Class(function(self, inst)
    self.inst = inst

    self.boat = net_entity(inst.GUID, "pro_driver.boat")
end)

function Driver:SetBoat(boat)
    self.boat:set(boat)
end

function Driver:GetBoat()
    return self.boat:value()
end

return Driver
