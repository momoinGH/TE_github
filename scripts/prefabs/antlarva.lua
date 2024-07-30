require "stategraphs/SGantlarva"

local prefabs = {
	"antman"
}

local assets =
{
	Asset("ANIM", "anim/ant_larva.zip"),
}

local function spawnant(inst)
	local ant = SpawnPrefab("antman")
	local pt = inst:GetPosition()
	ant.Transform:SetPosition(pt.x, pt.y, pt.z)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddPhysics()
	inst.entity:AddNetwork()

	inst.Physics:SetMass(1)
	inst.Physics:SetCapsule(0.2, 0.2)
	inst.Physics:SetFriction(10)
	inst.Physics:SetDamping(5)
	inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
	inst.Physics:ClearCollisionMask()
	inst.Physics:CollidesWith(COLLISION.WORLD)
	inst.Physics:CollidesWith(COLLISION.OBSTACLES)
	inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
	inst.Physics:CollidesWith(COLLISION.CHARACTERS)
	inst.Physics:CollidesWith(COLLISION.GIANTS)

	inst.AnimState:SetBank("ant_larva")
	inst.AnimState:SetBuild("ant_larva")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("locomotor")

	inst:AddComponent("complexprojectile")
	inst.components.complexprojectile.yOffset = 2.5

	inst.SpawnAnt = spawnant

	inst:SetStateGraph("SGantlarva")

	inst.persists = false

	return inst
end

return Prefab("antlarva", fn, assets, prefabs)
