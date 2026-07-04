local assets =
{
	Asset("ANIM", "anim/volcano.zip"),
	Asset("MINIMAP_IMAGE", "volcano"),
	Asset("MINIMAP_IMAGE", "volcano_active"),
}

local prefabs =
{

}

local function OnSeasonChange(inst)
	if TheWorld.state.issummer then
		inst.sg:GoToState("active")
	else
		inst.sg:GoToState("dormant")
	end
end

local function OnWake(inst)
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/volcano/volcano_external_amb", "volcano")
	local state = 1.0
	if inst.sg and inst.sg.currentstate == "dormant" then
		state = 0.0
	end
	inst.SoundEmitter:SetParameter("volcano", "volcano_state", state)
end

local function OnSleep(inst)
	inst.SoundEmitter:KillSound("volcano")
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	inst.Transform:SetScale(0.5, 0.5, 0.5)

	inst.entity:AddLight()
	inst.Light:SetFalloff(0.4)
	inst.Light:SetIntensity(.7)
	inst.Light:SetRadius(10)
	inst.Light:SetColour(249 / 255, 130 / 255, 117 / 255)
	inst.Light:Enable(true)

	inst.AnimState:SetBank("volcano")
	inst.AnimState:SetBuild("volcano")
	inst.AnimState:PlayAnimation("dormant_idle", true)

	inst.MiniMapEntity:SetIcon("volcano.png")

	inst.entity:AddPhysics()
	inst.Physics:SetMass(0)
	inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
	inst.Physics:ClearCollisionMask()
	inst.Physics:CollidesWith(COLLISION.ITEMS)
	inst.Physics:CollidesWith(COLLISION.CHARACTERS)
	inst.Physics:SetCapsule(17, 5)

	inst:AddTag("theVolcano")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("scenariorunner")
	inst.components.scenariorunner:SetScript("camera_volcano")
	inst.components.scenariorunner:Run()

	inst:AddComponent("worldmigrator")
	inst.components.worldmigrator:SetID("volcano")

	inst:SetStateGraph("SGvolcano")

	inst.OnLoadPostPass = function(inst, ents, data)
		if TheWorld.components.volcanomanager then
			TheWorld.components.volcanomanager:AddVolcano(inst)
		end
	end
	inst.OnRemoveEntity = function(inst)
		if TheWorld.components.volcanomanager then
			TheWorld.components.volcanomanager:RemoveVolcano(inst)
		end
	end

	inst.OnEntityWake = OnWake
	inst.OnEntitySleep = OnSleep

	inst:ListenForEvent("OnVolcanoEruptionBegin", function(it)
		if inst.sg then
			inst.sg:GoToState("erupt")
		end
	end, TheWorld)

	inst:ListenForEvent("OnVolcanoEruptionEnd", function(it)
		if inst.sg then
			inst.sg:GoToState("rumble")
		end
	end, TheWorld)

	inst:ListenForEvent("OnVolcanoWarningQuake", function(it)
		if inst.sg then
			inst.sg:GoToState("rumble")
		end
	end, TheWorld)

	inst:ListenForEvent("seasonChange", OnSeasonChange)

	return inst
end

return Prefab("volcano", fn, assets, prefabs)
