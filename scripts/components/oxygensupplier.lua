local OxygenSupplier = Class(function(self, inst)
	self.inst = inst
	self.oxygenrate = 0

	self.inst:AddTag("oxygen_supplier")
end)

function OxygenSupplier:SetSupplyRate(n)
	self.oxygenrate = n
end

function OxygenSupplier:GetSupplyRate(owner)
	if self.oxygenfn then
		return self.oxygenfn(self.inst, owner)
	end

	return self.oxygenrate
end

return OxygenSupplier
