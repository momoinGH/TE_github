local assets =
{
	Asset("ANIM", "anim/quagmire_goatkid_basic.zip"),
	Asset("ANIM", "anim/quagmire_swampig_build.zip"),
}

local brain = require "brains/goatbrain"

local prefabs =
{
	"meat",
}

local loot =
{
	"meat",
}

local function fn3()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()

	inst.entity:AddMiniMapEntity()
	inst.MiniMapEntity:SetIcon("goatkid.png")

	MakeObstaclePhysics(inst, 0.8, .4)

	inst.DynamicShadow:SetSize(1.5, 0.75)

	inst.Transform:SetFourFaced()
	inst.Transform:SetScale(.8, .8, .8)
	--	inst.Transform:SetRotation(180)

	local minimap = inst.entity:AddMiniMapEntity()

	inst.MiniMapEntity:SetPriority(1)

	inst.AnimState:SetBank("quagmire_goatkid_basic")
	inst.AnimState:SetBuild("quagmire_goatkid_basic")
	inst.AnimState:PlayAnimation("idle_loop", true)
	inst.AnimState:Hide("hat")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	MakeHauntablePanic(inst)

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot(loot)

	inst:AddComponent("inventory")

	inst:AddComponent("inspectable")
	inst:AddComponent("knownlocations")

	MakeMediumBurnableCharacter(inst, "pig_torso")
	MakeMediumFreezableCharacter(inst, "pig_torso")

	inst:SetStateGraph("SGgoat")

	inst:SetBrain(brain)

	inst:AddComponent("prototyper")
	inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.QUAGMIRE_GOATKID

	return inst
end

return Prefab("quagmire_goatkid", fn3, assets, prefabs)
