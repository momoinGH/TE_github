require "stategraphs/SGclam"
require "brains/clambrain"

local assets =
{
	Asset("ANIM", "anim/clam.zip"),
}

local prefabs =
{
	"fish_fillet",
	"pearl",
	"slurtle_shellpieces",
	"saltrock",
}

local function OnEntityWake(inst)
	inst.components.und_bubbleblower:Start()
end

local function OnEntitySleep(inst)
	inst.components.und_bubbleblower:Stop()
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddNetwork()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local minimap = inst.entity:AddMiniMapEntity()
	inst.Transform:SetTwoFaced()

	inst.entity:AddMiniMapEntity()
	inst.MiniMapEntity:SetIcon("clam.tex")


	MakeObstaclePhysics(inst, 0.8, 1.2)
	inst.Transform:SetScale(0.7, 0.7, 0.7)

	anim:SetBank("clam")
	anim:SetBuild("clam")

	inst:AddTag("scarytoprey")
	inst:AddTag("clam")
	inst:AddTag("underwater")

	inst:AddComponent("und_bubbleblower")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
	inst.components.locomotor.walkspeed = 0
	inst.components.locomotor.runspeed = 0

	inst:AddComponent("inspectable")

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.CLAM_HEALTH)

	inst:AddComponent("combat")

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({ "fish_fillet", "fish_fillet", "slurtle_shellpieces", "slurtle_shellpieces" })
	inst.components.lootdropper:AddChanceLoot("pearl", 1)
	inst.components.lootdropper:AddChanceLoot("saltrock", 0.2)

	--inst:AddComponent("sleeper")
	--inst.components.sleeper:SetResistance(2)

	inst:SetStateGraph("SGclam")

	local brain = require "brains/clambrain"
	inst:SetBrain(brain)

	inst.OnEntityWake = OnEntityWake
	inst.OnEntitySleep = OnEntitySleep

	return inst
end

return Prefab("clam", fn, assets, prefabs)
