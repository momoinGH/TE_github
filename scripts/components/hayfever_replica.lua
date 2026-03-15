local Hayfever = Class(function(self, inst)
	self.inst = inst

    self.level = net_tinybyte(inst.GUID, "hayfever.level", "pro_updatepollen")
end)

function Hayfever:SetLevel(level)
	self.level:set(level)
end

function Hayfever:GetLevel()
	return self.level:value()
end

return Hayfever
