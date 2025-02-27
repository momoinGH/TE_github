local default_y_offset = 20
local default_xz_offset_small = 30
local default_xz_offset_large = 60

-- 海底世界内单位被工作或死亡时生成点气泡
-- TODO 可以不判断地皮吗
local DeathBubbles = Class(function(self, inst)
	self.inst = inst

	-- Can be set from outside component
	self.bubble_rate = 10
	self.y_offset = nil
	self.xz_offset = nil

	-- Set inside the component
	self.bubbles_to_be_released = 0

	-- Arm component
	if self.inst.components.health then
		self.inst:ListenForEvent("death", function() self:OnDestruction() end, self.inst)
	elseif self.inst.components.workable then
		self.inst:ListenForEvent("worked", function() self:OnHit() end, self.inst)
	end
end)

function DeathBubbles:SetXZOffset(xz_off)
	self.xz_offset = xz_off
end

function DeathBubbles:SetYOffset(y_off)
	self.y_offset = y_off
end

function DeathBubbles:SetBubbleRate(rate)
	self.bubble_rate = rate
end

function DeathBubbles:BubblesToBeReleased()
	-- Bubbles released by large creatures and structures
	if self.inst:HasTag("largecreature") or self.inst:HasTag("structure") then
		self.bubbles_to_be_released = math.random(8, 10)

		if not self.xz_offset then
			self.xz_offset = default_xz_offset_large
		end

		if not self.y_offset then
			self.y_offset = default_y_offset
		end

		-- Bubbles released by small creatures and other things
	else
		self.bubbles_to_be_released = math.random(5, 6)

		if not self.xz_offset then
			self.xz_offset = default_xz_offset_small
		end

		if not self.y_offset then
			self.y_offset = default_y_offset
		end
	end
end

function DeathBubbles:ReleaseBubbles(bubble_mod)
	if not bubble_mod then
		bubble_mod = 1
	end

	-- Lets spawn in a prefab to handle the bubble effects
	local pt = Vector3(self.inst.Transform:GetWorldPosition())
	local bubbler = SpawnPrefab("deathbubble_fx")

	-- Set up the bubbler prefab
	if bubbler and pt then
		bubbler.Transform:SetPosition(pt:Get())
		bubbler.components.und_bubbleblower:SetMaxBubbles(self.bubbles_to_be_released * bubble_mod)
		bubbler.components.und_bubbleblower:SetXZOffset(self.xz_offset)
		bubbler.components.und_bubbleblower:SetYOffset(self.y_offset)
		bubbler.components.und_bubbleblower:SetBubbleRate(self.bubble_rate)
	end
end

function DeathBubbles:OnDestruction()
	local map = TheWorld.Map
	local x, y, z = self.inst.Transform:GetWorldPosition()
	local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))
	local naagua = false
	if ground == GROUND.UNDERWATER_SANDY
		or ground == GROUND.UNDERWATER_ROCKY
		or (ground == GROUND.BEACH and TheWorld:HasTag("cave"))
		or (ground == GROUND.PIGRUINS and TheWorld:HasTag("cave"))
		or (ground == GROUND.PEBBLEBEACH and TheWorld:HasTag("cave"))
		or (ground == GROUND.MAGMAFIELD and TheWorld:HasTag("cave"))
		or (ground == GROUND.PAINTED and TheWorld:HasTag("cave"))
	then
		naagua = true
	end

	-- No need to release bubbles if not underwater
	if not naagua then
		return
	end

	-- Determine the number of bubbles to be released
	self:BubblesToBeReleased()

	-- Add bubble items to the lootdropper if present
	if self.inst.components.lootdropper then
		if self.inst:HasTag("largecreature") or self.inst:HasTag("structure") then
			for k = 1, math.random(2, 3) do
				self.inst.components.lootdropper:SpawnLootPrefab("bubble_item")
			end
		else
			for k = 1, math.random(1, 2) do
				self.inst.components.lootdropper:SpawnLootPrefab("bubble_item")
			end
		end
	end

	-- Release bubbles
	self:ReleaseBubbles()
end

function DeathBubbles:OnHit()
	local map = TheWorld.Map
	local x, y, z = self.inst.Transform:GetWorldPosition()
	local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))
	local naagua = false
	if ground == GROUND.UNDERWATER_SANDY
		or ground == GROUND.UNDERWATER_ROCKY
		or (ground == GROUND.BEACH and TheWorld:HasTag("cave"))
		or (ground == GROUND.PIGRUINS and TheWorld:HasTag("cave"))
		or (ground == GROUND.PEBBLEBEACH and TheWorld:HasTag("cave"))
		or (ground == GROUND.MAGMAFIELD and TheWorld:HasTag("cave"))
		or (ground == GROUND.PAINTED and TheWorld:HasTag("cave"))
	then
		naagua = true
	end

	-- No need to release bubbles if not underwater
	if not naagua then
		return
	end

	-- Determine the number of bubbles to be released
	self:BubblesToBeReleased()

	-- Release bubbles
	self:ReleaseBubbles(0.5)
end

return DeathBubbles
