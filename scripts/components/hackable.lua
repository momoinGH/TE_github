local function oncanbehacked(self)
	if self.canbehacked and self.caninteractwith then
		self.inst:AddTag("hackable")
	else
		self.inst:RemoveTag("hackable")
	end
end

--- 可以劈砍，简易组件，如果要更多功能可以加个pickable作为辅助组件
local Hackable = Class(function(self, inst)
	self.inst = inst

	self.canbehacked = true
	self.caninteractwith = true
	self.savestate = false

	self.hacksleft = 1
	self.maxhacks = 1
end, nil, {
	canbehacked = oncanbehacked,
	caninteractwith = oncanbehacked
})

function Hackable:OnSave()
	return self.savestate and {
		maxhacks = self.maxhacks,
		hacksleft = self.hacksleft,
	} or nil
end

function Hackable:OnLoad(data)
	if not data then return end

	self.hacksleft = data.hacksleft or self.hacksleft
	self.maxhacks = data.maxhacks or self.maxhacks
end

function Hackable:CanBeHacked()
	return self.canbehacked
end

function Hackable:Hack(hacker, numworks)
	if not self.canbehacked or not self.caninteractwith then
		return
	end

	self.hacksleft = self.hacksleft - numworks
	if self.onhackedfn then
		self.onhackedfn(self.inst, hacker, self.hacksleft)
	end
end

return Hackable
