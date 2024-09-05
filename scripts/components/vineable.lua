local function Init(inst, self)
	self.vines = SpawnPrefab("pig_ruins_creeping_vines")
	self.vines:setup(self.inst)

	self:SetOpen(self.vines_open)
end

--- 哈姆雷特门的藤蔓，要求门必须有teleporter组件
local Vineable = Class(function(self, inst)
	self.inst = inst

	self.vines_open = false
	self.regrowtask = nil
	self.regrowtimeleft = nil

	inst:DoTaskInTime(0, Init, self)
end)

function Vineable:SetOpen(open)
	if open then
		-- 摧毁
		self.inst:RemoveTag("NOCLICK")
		self.vines:hackedopen()
		self:BeginRegrow()
	else
		-- 再生
		if self.regrowtask then
			self.regrowtask:Cancel()
			self.regrowtask = nil
		end
		self.inst:AddTag("NOCLICK")
		self.vines:regrow()
	end

	self.vines_open = open
	self.inst.components.teleporter:SetEnabled(open)

	local target = self.inst.components.teleporter:GetTarget()
	if target and target ~= self.inst and target.components.vineable and (target.components.vineable.vines_open ~= open) then
		target.components.vineable:SetOpen(true)
	end
end

function Vineable:SetGrowTask(time)
	self.regrowtask = self.inst:DoTaskInTime(time, function() self:SetOpen(false) end)
end

function Vineable:BeginRegrow()
	self:SetGrowTask(self.regrowtimeleft or (20 + (math.random() * 20)))
	self.regrowtimeleft = nil
end

function Vineable:OnSave()
	return {
		regrowtimeleft = self.regrowtask and GetTaskRemaining(self.regrowtask) or nil,
		vines_open = self.vines_open
	}
end

function Vineable:OnLoad(data)
	if not data then return end

	self.vines_open = data.vines_open or self.vines_open
	self.regrowtimeleft = data.regrowtimeleft
end

return Vineable
