local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"

local OxygenBadge = Class(Badge, function(self, owner)
	Badge._ctor(self, "oxygen_meter_player", owner)

	self.oxygenarrow = self.underNumber:AddChild(UIAnim())
	self.oxygenarrow:GetAnimState():SetBank("sanity_arrow")
	self.oxygenarrow:GetAnimState():SetBuild("sanity_arrow")
	self.oxygenarrow:GetAnimState():PlayAnimation("neutral")
	self.oxygenarrow:SetClickable(false)

	self.topperanim = self.underNumber:AddChild(UIAnim())
	self.topperanim:GetAnimState():SetBank("effigy_topper")
	self.topperanim:GetAnimState():SetBuild("effigy_topper")
	self.topperanim:GetAnimState():PlayAnimation("anim")
	self.topperanim:SetClickable(false)

	-- 默认隐藏，由 OnUpdate / statusdisplays 按条件显示
	self:Hide()
	self:StartUpdating()
end)

function OxygenBadge:SetPercent(val, max, penaltypercent)
	Badge.SetPercent(self, val, max)

	penaltypercent = penaltypercent or 0
	self.topperanim:GetAnimState():SetPercent("anim", penaltypercent)
end

--- 是否应显示：非幽灵 且 在水下（与 heart 幽灵显隐对齐，并保留水下机制）
function OxygenBadge:ShouldShow()
	local owner = self.owner
	if owner == nil then
		return false
	end

	-- 与 heart 一致：幽灵模式强制隐藏
	if owner:HasTag("playerghost") then
		return false
	end
	-- statusdisplays.isghostmode（SetGhostMode 同步）
	local parent = self.parent
	if parent ~= nil and parent.isghostmode then
		return false
	end

	-- 原本机制：仅在水下显示
	return owner:IsInUnderWaterArea()
end

function OxygenBadge:RefreshVisibility()
	if self:ShouldShow() then
		self:Show()
	else
		self:Hide()
	end
end

function OxygenBadge:OnUpdate(dt)
	local oxygen = self.owner ~= nil and self.owner.replica.oxygen or nil
	if oxygen == nil then
		self:Hide()
		return
	end

	local rate = oxygen:GetRate()
	local percent = oxygen:GetPercent()

	-- 同步表盘数值（防止仅依赖事件时漏刷新）
	self:SetPercent(percent, oxygen:Max())

	local small_down = .02
	local med_down = .1
	local large_down = .3
	local small_up = .01
	local med_up = .1
	local large_up = .2
	local anim = "neutral"

	if rate > 0 and percent < 1 then
		if rate > large_up then
			anim = "arrow_loop_increase_most"
		elseif rate > med_up then
			anim = "arrow_loop_increase_more"
		elseif rate > small_up then
			anim = "arrow_loop_increase"
		end
	elseif rate < 0 and percent > 0 then
		if rate < -large_down then
			anim = "arrow_loop_decrease_most"
		elseif rate < -med_down then
			anim = "arrow_loop_decrease_more"
		elseif rate < -small_down then
			anim = "arrow_loop_decrease"
		end
	end

	if anim and self.arrowdir ~= anim then
		self.arrowdir = anim
		self.oxygenarrow:GetAnimState():PlayAnimation(anim, true)
	end

	self:RefreshVisibility()
end

return OxygenBadge
