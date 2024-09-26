local assets =
{
	Asset("ANIM", "anim/swap_quackeringram.zip"),
}

local prefabs =
{
	"quackering_wave"
}

local QUACKERINGRAM_USE_COUNT = 25
local QUACKERINGRAM_DAMAGE = 100

local function onfinished(inst)
	local boat = inst.components.shipwreckedboatparts:GetBoat()

	if boat then
		boat.AnimState:ClearOverrideSymbol("swap_lantern")
		if boat.wakeTask then
			boat.wakeTask:Cancel()
			boat.wakeTask = nil
		end
	end

	if inst.windFX then
		inst.windFX:Remove()
	end

	inst:Remove()
end

local function spawnWake(boat)
	if boat then
		local wake = SpawnPrefab("quackering_wake")
		wake.entity:AddFollower()
		if boat and boat.wakeLeft == true then
			wake.idleanimation = "idle"
			boat.wakeLeft = false
		else
			wake.idleanimation = "idle_2"
			boat.wakeLeft = true
		end
		if wake.Follower then
			wake.Follower:FollowSymbol(boat.GUID, "torso", 0, 0, 0)
		end
		wake.Transform:SetRotation(boat.Transform:GetRotation())
		boat.wakeTask = boat:DoTaskInTime(5 * FRAMES, function() spawnWake(boat) end)
	end
end

local function performRamFX(inst, target)
	for i = 1, 5 do
		local fx = SpawnPrefab("boat_hit_fx_quackeringram")
		local dx = math.random(-3, 3)
		local dz = math.random(-3, 3)
		local x, y, z = target.Transform:GetWorldPosition()
		fx.Transform:SetPosition(x + dx, y, z + dz)
	end

	local boat = inst.components.shipwreckedboatparts:GetBoat()
	if boat then
		local currentSpeed = boat.Physics:GetMotorSpeed()
		local boost = 25

		inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/quackering_ram/impact")
		boat.Physics:SetMotorVel(currentSpeed + boost, 0, 0)
		boat.wakeLeft = true
		boat.wakeTask = spawnWake(boat)
		boat:DoTaskInTime(40 * FRAMES, function()
			if boat and boat.wakeTask then
				boat.wakeTask:Cancel()
				boat.wakeTask = nil
			end
		end)
	end
end

local ATTACK_CANT_TAGS = { "player", "companion", "shipwrecked_boat" }

local function onPotentialRamHit(inst, target)
	if target:HasOneOfTags(ATTACK_CANT_TAGS) then
		return
	end

	local hitTarget = false
	if target.components.combat then
		hitTarget = true
		local driver = inst.components.shipwreckedboatparts:GetDriver()
		if driver then
			target.components.combat:GetAttacked(driver, QUACKERINGRAM_DAMAGE, inst)
		end
	elseif target.components.workable then
		hitTarget = true
		target.components.workable:Destroy(inst)
	end

	if hitTarget then
		-- show fx
		performRamFX(inst, target)
		-- use up a charge
		inst.components.finiteuses:Use()
		-- cooldown, avoid double hits
		inst.components.rammer:StartCooldown()
	end
end

-- 这写法感觉有点落伍了
local function updateWindFX(inst)
	local boat = inst.components.shipwreckedboatparts:GetBoat()

	local sortOrder = -1

	if boat ~= nil then
		local facing = boat.AnimState:GetCurrentFacing()
		inst.windFX:ChangeDirection(facing)

		-- when facing up, let the wind effect be behind the boat
		if facing == 1 then
			sortOrder = 3
		end
	end

	inst.windFX.AnimState:SetSortOrder(sortOrder)

	-- keep attached to ram
	local p = inst:GetPosition()
	inst.windFX.Transform:SetPosition(p.x, p.y, p.z)
end

local function OnBoatEquipped(inst, data)
    data.owner.AnimState:OverrideSymbol("swap_lantern", "swap_quackeringram", "swap_quackeringram")
	local boatfx = data.owner.components.shipwreckedboat.boatfx
	if boatfx then
		boatfx.AnimState:OverrideSymbol("swap_lantern", "swap_quackeringram", "swap_quackeringram")
	end
end

local function OnBoatUnquipped(inst, data)
    data.owner.AnimState:ClearOverrideSymbol("swap_lantern")
	local boatfx = data.owner.components.shipwreckedboat.boatfx
	if boatfx then
		boatfx.AnimState:ClearOverrideSymbol("swap_lantern")
	end
end

local function OnRammerActive(inst)
	local boat = inst.components.shipwreckedboatparts:GetBoat()
	local facing = boat.AnimState:GetCurrentFacing()
	inst.windFX:ShowEffect(facing)
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/quackering_ram/impact")
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/quackering_ram/ram_LP", "ram_LP")
end

local function OnRammerDeactivate(inst)
	inst.windFX:HideEffect()
	inst.SoundEmitter:KillSound("ram_LP")
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.Transform:SetFourFaced()

	inst.AnimState:SetBuild("swap_quackeringram")
	inst.AnimState:SetBank("quackeringram")
	inst.AnimState:PlayAnimation("idle")

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst:AddTag("shipwrecked_boat_head")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/volcanoinventory.xml"

	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(QUACKERINGRAM_USE_COUNT)
	inst.components.finiteuses:SetUses(QUACKERINGRAM_USE_COUNT)
	inst.components.finiteuses:SetOnFinished(onfinished)

	-- wind fx
	inst.windFX = SpawnPrefab("quackering_wave")
	inst.windFX:HideEffect()

	inst:AddComponent("rammer")
	inst.components.rammer.minSpeed = 2.5
	inst.components.rammer.onRamTarget = onPotentialRamHit
	inst.components.rammer.onUpdate = updateWindFX
	inst.components.rammer.onActivate = OnRammerActive
	inst.components.rammer.onDeactivate = OnRammerDeactivate

	inst:AddComponent("shipwreckedboatparts")

	inst:ListenForEvent("boat_equipped", OnBoatEquipped)
	inst:ListenForEvent("boat_unequipped", OnBoatUnquipped)

	return inst
end

return Prefab("quackeringram", fn, assets, prefabs)
