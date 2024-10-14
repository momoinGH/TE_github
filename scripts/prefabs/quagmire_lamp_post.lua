local assets =
{
	Asset("ANIM", "anim/quagmire_lamp_post.zip"),
    Asset("ANIM", "anim/quagmire_lamp_short.zip"),    
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle")
end

local function onhit1(inst, worker)
    inst.AnimState:PushAnimation("idle")
end


local function onbuilt(inst)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PlayAnimation("idle")
end

local function onbuilt1(inst)
    inst.AnimState:PlayAnimation("idle")
end


local function postfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddLight()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("quagmire_lamp_post")
    inst.AnimState:SetBuild("quagmire_lamp_post")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.Light:Enable(true)
    inst.Light:SetRadius(3.5)
    inst.Light:SetFalloff(0.58)
    inst.Light:SetIntensity(0.75)
    inst.Light:SetColour(235 / 255, 235 / 255, 235 / 255)
	
    MakeObstaclePhysics(inst, 0.25)
	
	inst:AddTag("structure")
	inst:AddTag("streetlamp")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")

	inst:AddComponent("lootdropper")   
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	--inst:AddComponent("fader")
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function shortfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddLight()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("quagmire_lamp_short")
    inst.AnimState:SetBuild("quagmire_lamp_short")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.Light:Enable(true)
    inst.Light:SetRadius(2)
    inst.Light:SetFalloff(0.58)
    inst.Light:SetIntensity(0.75)
    inst.Light:SetColour(200 / 255, 200 / 255, 200 / 255)
	
    MakeObstaclePhysics(inst, 0.25)
	
	inst:AddTag("structure")
	inst:AddTag("streetlamp")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")

	inst:AddComponent("lootdropper")   
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit1)
	
	--inst:AddComponent("fader")
	
	inst:ListenForEvent("onbuilt", onbuilt1)
	
	MakeHauntableWork(inst)
	
    return inst
end

return Prefab("quagmire_lamp_post", postfn, assets ),
       Prefab("quagmire_lamp_short", shortfn, assets),
	   
	   MakePlacer("quagmire_lamp_post_placer", "quagmire_lamp_post", "quagmire_lamp_post", "idle"),
       MakePlacer("quagmire_lamp_short_placer", "quagmire_lamp_short", "quagmire_lamp_short", "idle")
