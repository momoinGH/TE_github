-- 用于机关，卸下机关的武器
local function onrearmable(self, rearmable)
	if rearmable then
		self.inst:AddTag("rearmable")
	else
		self.inst:RemoveTag("rearmable")
	end
end

local Disarmable = Class(function(self, inst)
	self.inst = inst
	self.armed = true
	self.rearmable = true
end, nil, {
	rearmable = onrearmable
})


function Disarmable:disarm(doer, item)
	if self.armed then
		self.armed = false

		if self.disarmfn then
			self.disarmfn(self.inst, doer)
		end

		return true
	end
end

function Disarmable:DoRearming(inst, doer)
	if not self.armed then
		self.armed = true
		if self.rearmfn then
			self.rearmfn(self.inst, doer)
		end
		return true
	end
end

return Disarmable
