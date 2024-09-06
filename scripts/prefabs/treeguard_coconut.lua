local assets =
{
	Asset("ANIM", "anim/coconut_cannon.zip"),
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
		if v.components.combat and v ~= inst and v.prefab ~= "treeguard" then
			v.components.combat:GetAttacked(attacker or inst, 50)
		end
	end

	inst.components.groundpounder:GroundPound()

	if math.random() < 0.01 then
		item = ReplacePrefab(inst, "coconut")
		item.components.inventoryitem:OnDropped()
	else
		inst:Remove()
	end
end


local function onremove(inst)
	if inst.TrackHeight then
		inst.TrackHeight:Cancel()
		inst.TrackHeight = nil
	end
end


local function OnSave(inst, data)
	inst:Remove()
end

local function OnLoad(inst, data)
	inst:Remove()
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.Transform:SetFourFaced()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("coconut_cannon")
	inst.AnimState:SetBuild("coconut_cannon")
	inst.AnimState:PlayAnimation("throw", true)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddTag("thrown")
	inst:AddTag("projectile")

	inst:AddComponent("complexprojectile")
	inst.components.complexprojectile:SetOnHit(OnHit)
	inst.components.complexprojectile:SetOnLaunch(OnLaunch)
	inst.components.complexprojectile:SetLaunchOffset(Vector3(.75, 1, 0))
	inst.components.complexprojectile:SetHorizontalSpeed(20)
	inst.components.complexprojectile:SetGravity(-30)


	inst:AddComponent("groundpounder")
	inst.components.groundpounder.numRings = 2
	inst.components.groundpounder.ringDelay = 0.1
	inst.components.groundpounder.initialRadius = 1
	inst.components.groundpounder.radiusStepDistance = 2
	inst.components.groundpounder.pointDensity = .25
	inst.components.groundpounder.damageRings = 1
	inst.components.groundpounder.destructionRings = 1
	inst.components.groundpounder.destroyer = false
	inst.components.groundpounder.burner = false
	inst.components.groundpounder.ring_fx_scale = 0.15
	inst.components.groundpounder.groundpoundfx = "explode_small"
	inst.components.groundpounder.groundpoundringfx = "explode_small"


	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(30)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad


	inst.OnRemoveEntity = onremove

	return inst
end

return Prefab("treeguard_coconut", fn, assets, prefabs)
