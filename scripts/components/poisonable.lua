--- 中毒组件
local Poisonable = Class(function(self, inst)
	self.inst = inst

	self.dmg = 0   --每次扣除的伤害
	self.interval = 0 --每次扣血间隔
	self.maxInterval = 5
	self.minInterval = 1
	self.defaultDuration = 60 * 16
	self.startDuration = 0
	self.duration = 0 --持续时间
	self.updating = false
	self.lastDamageTime = 0
	self:SetOnHitFn()
	self.poisonfx = nil
end)

local function SpoilLoot(inst, loot)
	if loot.components.perishable then
		local pc = 0.5 * loot.components.perishable:GetPercent()
		loot.components.perishable:SetPercent(pc)
	end
	return loot
end

function Poisonable:SetPoison(dmg, interval, duration)
	self.inst:AddTag("tro_poisoned") --中毒标签
	self.dmg = dmg or -1
	self.interval = interval or self.maxInterval
	self.startDuration = duration or self.defaultDuration
	self.duration = self.startDuration
	if self.inst.player_classified then
		self.inst.player_classified.poisonover:set_local(true)
		self.inst.player_classified.poisonover:set(true)
	end
	if not self.updating then
		self.inst:StartUpdatingComponent(self)
	end
end

function Poisonable:ResetValues()
	self.duration = 0
	self.startDuration = 0
	self.dmg = 0
	self.interval = 0
	self.lastDamageTime = 0
end

function Poisonable:WearOff()
	self.inst:RemoveTag("tro_poisoned")
	self:ResetValues()
	self.inst:StopUpdatingComponent(self)
	self.updating = false

	--remove poisonfx
	if self.poisonfx then
		self.poisonfx:Remove()
		self.poisonfx = nil
	end
end

function Poisonable:IncreaseIntensity()
	if self.duration > 0 and self.interval > self.minInterval then
		local progress = self.startDuration / self.duration
		self.interval = math.max(progress * self.maxInterval, self.minInterval)
	end
end

function Poisonable:OnUpdate(dt)
	self.duration = self.duration - dt
	self.lastDamageTime = self.lastDamageTime - dt
	-- thanks to Swaggy for the fix
	if self.inst.components.health and self.lastDamageTime <= 0 then
		self.inst.components.health:DoDelta(self.dmg, nil, "poison")
		self:IncreaseIntensity()
		self.lastDamageTime = self.interval
		if self.inst.player_classified then
			self.inst.player_classified.poisonover:set_local(true)
			self.inst.player_classified.poisonover:set(true)
		end
	end

	-- poison bubbles fx, fixed by EvenMr
	if not self.poisonfx and self.dmg < 0 then
		self.poisonfx = SpawnPrefab("poisonbubble_level1_loop")
		self.inst:AddChild(self.poisonfx)
		local cmp = self.inst.components
		if cmp.burnable and #cmp.burnable.fxdata > 0 then
			local symbol = cmp.burnable.fxdata[1].follow
			if symbol then
				self.poisonfx.Follower:FollowSymbol(self.inst.GUID, symbol, 0, 0, 0)
			end
		end
	end

	if self.duration <= 0
		or self.inst:HasTag("weremoose")
		or self.inst:HasTag("weregoose")
		or self.inst:HasTag("beaver")
		or self.inst:HasTag("playerghost")
	then
		self:WearOff()
	end
end

function Poisonable:SetOnHitFn()
	local onhit = function(inst, attacker, dmg)
		if attacker ~= nil and attacker.components.poisonous then
			attacker.components.poisonous:OnAttack(inst, dmg)
		end
	end
	if self.inst.components.combat.onhitfn ~= nil then
		local oldonhitfn = self.inst.components.combat.onhitfn
		self.inst.components.combat:SetOnHit(function(inst, attacker, dmg)
			oldonhitfn(inst, attacker, dmg)
			onhit(inst, attacker, dmg)
		end)
	else
		self.inst.components.combat:SetOnHit(onhit)
	end
end

function Poisonable:OnLoad(data)
	if data.dmg and data.startDuration and data.duration and data.interval then
		self:SetPoison(data.dmg, data.interval, data.duration)
		self.startDuration = data.startDuration
	end
	if data.lastDamageTime ~= nil then
		self.lastDamageTime = data.lastDamageTime
	end
end

function Poisonable:OnSave()
	return {
		dmg = self.dmg,
		interval = self.interval,
		duration = self.duration,
		startDuration = self.startDuration,
		lastDamageTime = self.lastDamageTime
	}
end

return Poisonable
