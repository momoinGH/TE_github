require "stategraphs/SGroc"

local assets =
{
	Asset("ANIM", "anim/roc_shadow.zip"),
}

local prefabs =
{
	"roc_leg",
	"roc_head",
	"roc_tail",
}

local ROC_SPEED = 20
local ROC_SHADOWRANGE = 8

local function setstage(inst, stage)
	if stage == 1 then
		inst.Transform:SetScale(0.35, 0.35, 0.35)
		if inst.components.locomotor ~= nil then
			inst.components.locomotor.runspeed = 5
		end
	elseif stage == 2 then
		inst.Transform:SetScale(0.65, 0.65, 0.65)
		if inst.components.locomotor ~= nil then
			inst.components.locomotor.runspeed = 7.5
		end
	else
		inst.Transform:SetScale(1, 1, 1)
		if inst.components.locomotor ~= nil then
			inst.components.locomotor.runspeed = 10
		end
	end
end


local function scalefn(inst, scale)
	if inst.components.locomotor ~= nil then
		inst.components.locomotor.runspeed = ROC_SPEED * scale
	end
	if inst.components.shadowcaster ~= nil then
		inst.components.shadowcaster:setrange(ROC_SHADOWRANGE * scale)
	end
end

local function OnRemoved(inst)
	if TheWorld.components.rocmanager ~= nil then
		TheWorld.components.rocmanager:RemoveRoc(inst)
	end

	if inst.bodyparts ~= nil then
		for _, part in ipairs(inst.bodyparts) do
			if part:IsValid() then
				part:Remove()
			end
		end
		inst.bodyparts = nil
	end
end

local function MakeNoPhysics(inst, mass, rad)
	local physics = inst.entity:AddPhysics()
	physics:SetMass(mass)
	physics:SetCapsule(rad, 1)
	inst.Physics:SetFriction(0)
	inst.Physics:SetDamping(5)
	inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
	inst.Physics:ClearCollisionMask()
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeNoPhysics(inst, 10, 1.5)
	RemovePhysicsColliders(inst)

	inst.Transform:SetScale(1.5, 1.5, 1.5)

	inst:AddTag("roc")
	inst:AddTag("roc_body")
	inst:AddTag("canopytracker")
	inst:AddTag("noteleport")
	inst:AddTag("NOCLICK")

	inst.AnimState:SetBank("roc")
	inst.AnimState:SetBuild("roc_shadow")
	inst.AnimState:PlayAnimation("ground_loop", true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(1)
	inst.AnimState:SetMultColour(1, 1, 1, 0.5)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("colourtweener")
	if not TheWorld.state.isnight and not inst:HasTag("under_leaf_canopy") then
		inst.components.colourtweener:StartTween({ 1, 1, 1, 0.5 }, 3)
	else
		inst.components.colourtweener:StartTween({ 1, 1, 1, 0 }, 3)
	end
	inst:WatchWorldState("isday", function()
		if not inst:HasTag("under_leaf_canopy") then
			inst.components.colourtweener:StartTween({ 1, 1, 1, 0.5 }, 3)
		end
	end)

	inst:WatchWorldState("isnight", function()
		inst.components.colourtweener:StartTween({ 1, 1, 1, 0 }, 3)
	end)

	inst:AddComponent("knownlocations")

	inst:AddComponent("shadowcaster")

	inst:AddComponent("area_aware")

	inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
	inst.components.locomotor.runspeed = ROC_SPEED

	inst:AddComponent("roccontroller")
	inst.components.roccontroller.scalefn = scalefn
	inst.components.roccontroller:Setup(ROC_SPEED, 0.35, 3)
	inst.components.roccontroller:Start()

	inst:SetStateGraph("SGroc")

	inst.setstage = setstage

	inst:ListenForEvent("onremove", OnRemoved)
	inst:ListenForEvent("onchangecanopyzone", function()
		if inst:HasTag("under_leaf_canopy") then
			inst.components.colourtweener:StartTween({ 1, 1, 1, 0 }, 1)
		else
			if not TheWorld.state.isnight then
				inst.components.colourtweener:StartTween({ 1, 1, 1, 0.5 }, 1)
			end
		end
	end, TheWorld)

	return inst
end

return Prefab("roc", fn, assets, prefabs)
