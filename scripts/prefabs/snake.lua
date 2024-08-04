local trace = function() end

local assets =
{
	Asset("ANIM", "anim/snake_build.zip"),
	Asset("ANIM", "anim/snake_yellow_build.zip"),
	Asset("ANIM", "anim/snake_basic.zip"),
	Asset("ANIM", "anim/snake_water.zip"),
	Asset("ANIM", "anim/snake_scaly_build.zip"),
}

local brain = require "brains/snakebrain"

local prefabs =
{
}

local SHARE_TARGET_DIST = 30


local function OnNewTarget(inst, data)
	if inst.components.sleeper:IsAsleep() then
		inst.components.sleeper:WakeUp()
	end
end

local function retargetfn(inst)
	local dist = TUNING.SPIDER_TARGET_DIST
	local notags = { "FX", "NOCLICK", "INLIMBO", "wall", "snake", "structure" }
	return FindEntity(inst, dist, function(guy)
		return inst.components.combat:CanTarget(guy)
	end, nil, notags)
end

local function KeepTarget(inst, target)
	return inst.components.combat:CanTarget(target) and
		inst:GetDistanceSqToInst(target) <= (TUNING.SPIDER_TARGET_DIST * TUNING.SPIDER_TARGET_DIST * 4 * 4) and
		not target:HasTag("aquatic")
end

local function OnAttacked(inst, data)
	inst.components.combat:SetTarget(data.attacker)
	inst.components.combat:ShareTarget(
		data.attacker,
		SHARE_TARGET_DIST,
		function(dude)
			return dude:HasTag("snake") and not dude.components.health:IsDead()
		end,
		5
	)
end

local function OnAttackOther(inst, data)
	inst.components.combat:ShareTarget(
		data.target,
		SHARE_TARGET_DIST,
		function(dude)
			return dude:HasTag("snake") and not dude.components.health:IsDead()
		end,
		5
	)
end

local function DoReturn(inst)
	--print("DoReturn", inst)
	if inst.components.homeseeker and inst.components.homeseeker:HasHome() then
		inst.components.homeseeker.home.components.spawner:GoHome(inst)
	end
end

local function OnEntitySleep(inst)
	--print("OnEntitySleep", inst)
	if TheWorld.state.iscaveday then
		DoReturn(inst)
	end
end

local function SanityAura(inst, observer)
	if observer.prefab == "webber" then
		return 0
	end
	return -TUNING.SANITYAURA_SMALL
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddPhysics()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()

	inst.Transform:SetFourFaced()

	inst:AddTag("scarytoprey")
	inst:AddTag("monster")
	inst:AddTag("hostile")
	inst:AddTag("snake")
	inst:AddTag("canbetrapped")

	MakeCharacterPhysics(inst, 10, .5)

	inst.AnimState:SetBank("snake")
	inst.AnimState:SetBuild("snake_build")
	inst.AnimState:PlayAnimation("idle")
	--inst.AnimState:SetRayTestOnBB(true)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("knownlocations")

	inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
	inst.components.locomotor.runspeed = 3

	inst:SetStateGraph("SGsnake")

	inst:SetBrain(brain)

	inst:AddComponent("follower")

	inst:AddComponent("eater")
	inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })
	inst.components.eater:SetCanEatHorrible()

	inst.components.eater.strongstomach = true -- can eat monster meat!

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(150)
	--inst.components.health.poison_damage_scale = 0 -- immune to poison

	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(10)
	inst.components.combat:SetAttackPeriod(3)
	inst.components.combat:SetRetargetFunction(3, retargetfn)
	inst.components.combat:SetKeepTargetFunction(KeepTarget)
	inst.components.combat:SetHurtSound("dontstarve_DLC002/creatures/snake/hurt")
	inst.components.combat:SetRange(2, 3)

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:AddChanceLoot("monstermeat", 1)
	inst.components.lootdropper:AddChanceLoot("snakeskin", 0.5)
	inst.components.lootdropper:AddChanceLoot("venomgland", 0.01)

	inst.components.lootdropper.numrandomloot = 0

	inst:AddComponent("inspectable")

	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aurafn = SanityAura

	inst:AddComponent("sleeper")
	inst.components.sleeper:SetNocturnal(true)

	inst.OnEntitySleep = OnEntitySleep

	inst:ListenForEvent("newcombattarget", OnNewTarget)
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("onattackother", OnAttackOther)

	return inst
end

local function commonfn()
	local inst = fn()

	if not TheWorld.ismastersim then
		return inst
	end

	MakeMediumBurnableCharacter(inst, "body")
	MakeMediumFreezableCharacter(inst, "body")
	inst.components.burnable.flammability = TUNING.SPIDER_FLAMMABILITY

	return inst
end

local function poisonfn()
	local inst = fn()

	inst.AnimState:SetBuild("snake_yellow_build")

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("poisonous")

	--inst.components.lootdropper:AddChanceLoot("venom_gland", 0.25)

	MakeMediumBurnableCharacter(inst, "body")
	MakeMediumFreezableCharacter(inst, "body")
	inst.components.burnable.flammability = TUNING.SPIDER_FLAMMABILITY
	return inst
end

return Prefab("snake", commonfn, assets, prefabs),
	Prefab("snake_poison", poisonfn, assets, prefabs)
