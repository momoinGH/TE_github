local assets =
{
	Asset("ANIM", "anim/snake_cannon.zip"),
}

local prefabs =
{
	"groundpound_fx",
	"groundpoundring_fx",
}

local function OnLaunch(inst, attacker, targetPos)
	local shadow = SpawnPrefab("warningshadow")
	shadow.Transform:SetPosition(targetPos:Get())
	local time_to_target = 1 -- 落地时间不好计算啊
	shadow:shrink(time_to_target, 1.75, 0.5)
end

local function OnHit(inst, attacker)
	local x, y, z = inst.Transform:GetWorldPosition()
	for k, v in pairs(TheSim:FindEntities(x, y, z, 1.5)) do
		if v.components.combat and v ~= inst then
			v.components.combat:GetAttacked(attacker or inst, 50)
		end
	end

	ReplacePrefab(inst, "snake")
end

local function onremove(inst)
	if inst.TrackHeight then
		inst.TrackHeight:Cancel()
		inst.TrackHeight = nil
	end
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.Transform:SetFourFaced()

	inst.AnimState:SetBank("snake_cannon")
	inst.AnimState:SetBuild("snake_cannon")
	inst.AnimState:PlayAnimation("throw", true)

	inst:AddTag("projectile")
	inst:AddTag("thrown")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("complexprojectile")
	inst.components.complexprojectile:SetOnHit(OnHit)
	inst.components.complexprojectile:SetOnLaunch(OnLaunch)
	inst.components.complexprojectile:SetLaunchOffset(Vector3(.75, 4.5, 0))
	inst.components.complexprojectile:SetHorizontalSpeed(20)
	inst.components.complexprojectile:SetGravity(-30)

	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(3)

	inst.persists = false

	inst.OnRemoveEntity = onremove

	return inst
end

local function fall(inst, thrower, pt, time_to_target)
	inst.Physics:SetFriction(.2)
	inst.Transform:SetFourFaced()
	inst.AnimState:PlayAnimation("throw", true)

	inst.TrackHeight = inst:DoPeriodicTask(FRAMES, function()
		local pos = inst:GetPosition()
		if pos.y <= 0.3 then
			local px, py, pz = inst.Transform:GetWorldPosition()
			local other = SpawnPrefab("snake_amphibious")
			other.Transform:SetPosition(px, py, pz)
			inst:Remove()
		end
	end)
end

local function fn2()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("snake_cannon")
	inst.AnimState:SetBuild("snake_cannon")
	inst.AnimState:PlayAnimation("throw", true)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.OnRemoveEntity = onremove

	inst:DoTaskInTime(0, fall)

	inst:AddComponent("inspectable")

	return inst
end

return Prefab("jungletreeguard_snake", fn, assets, prefabs),
	Prefab("snakefall", fn2, assets, prefabs)
