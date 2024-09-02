local UIAnim = require "widgets/uianim"

--- 两个食物加速buff的图标
local SpeediconBadge = Class(UIAnim, function(self, owner)
	self.owner = owner
	UIAnim._ctor(self, "speedicon")

	self:GetAnimState():SetBank("speedicon")
	self:GetAnimState():SetBuild("speedicon")
	self:GetAnimState():PlayAnimation("frame01")
	self:Hide()

	self.last_anim = nil

	self:StartUpdating()
end)

-- TODO 专门给两个食物的buff添加UI，是不是有点奢侈了？而且不应该通过标签判断，角色标志位置宝贵，尽量少占用
function SpeediconBadge:OnUpdate()
	local anim = self.owner:HasTag("tropicalbouillabaisse") and "frame02"
		or self.owner:HasTag("coffee") and "frame01"
		or nil

	if anim ~= self.last_anim then
		if anim then
			self:GetAnimState():PlayAnimation(anim)
			self:Show()
		else
			self:Hide()
		end

		self.last_anim = anim
	end
end

return SpeediconBadge
