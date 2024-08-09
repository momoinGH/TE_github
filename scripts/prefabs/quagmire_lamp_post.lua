
local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	--inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle")
end


local function onbuilt(inst)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PlayAnimation("idle")
end

local function onbuilt1(inst)
    inst.AnimState:PlayAnimation("idle")
end


local function LightFn(bank_build, radius, falloff, intensity, color)
    return function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddLight()
        inst.entity:AddNetwork()

        MakeObstaclePhysics(inst, .5)

        inst.AnimState:SetBank(bank_build)
        inst.AnimState:SetBuild(bank_build)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:PlayAnimation("idle")

        inst.Light:Enable(true)
        inst.Light:SetRadius(radius)
        inst.Light:SetFalloff(falloff)
        inst.Light:SetIntensity(intensity)
        inst.Light:SetColour(color / 255, color / 255, color / 255)

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
		
		inst:ListenForEvent("onbuilt", onbuilt)	
		
	 	MakeHauntableWork(inst)   
		
        return inst
    end
end

local function postfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddLight()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(0.58)
    inst.Light:SetIntensity(INTENSITY)
    inst.Light:SetRadius(12)
    inst.Light:SetColour(235/255, 235/255, 235/255)
	inst.Light:Enable(true)
	
    MakeObstaclePhysics(inst, .2)
	
    inst.AnimState:SetBank("kyno_lamp_post")
    inst.AnimState:SetBuild("kyno_lamp_post")
    inst.AnimState:PlayAnimation("idle_on")
    
	inst:AddTag("structure")
	inst:AddTag("streetlamp")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_LAMP_POST"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("fader")
	
	-- inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	
	inst:DoTaskInTime(1, function()
        if TheWorld.state.isday and not TheWorld:HasTag("cave") then
            inst.AnimState:PlayAnimation("idle_off")
			inst.AnimState:PushAnimation("idle_off", true)
            inst.Light:Enable(false)
			inst.Light:SetIntensity(0)
			inst.components.fader:Fade(INTENSITY, 0, .75+math.random()*1, function(v) inst.Light:SetIntensity(v) end)
        else
			inst.AnimState:PlayAnimation("idle_on")
			inst.AnimState:PushAnimation("idle_on", true)
            inst.Light:Enable(true)
			inst.Light:SetIntensity(INTENSITY)
			inst.components.fader:Fade(0, INTENSITY, 3+math.random()*2, function(v) inst.Light:SetIntensity(v) end)
        end
    end)
    inst:ListenForEvent("phasechanged", function(src, data)
        if data ~= "night" and data ~= "dusk" and not TheWorld:HasTag("cave") then
            inst:DoTaskInTime(2, function()
                inst.AnimState:PlayAnimation("idle_off")
				inst.AnimState:PushAnimation("idle_off", true)
				inst.Light:Enable(false)
				inst.Light:SetIntensity(0)
            end)
        else
            inst:DoTaskInTime(2, function()
				inst.AnimState:PlayAnimation("idle_on")
				inst.AnimState:PushAnimation("idle_on", true)
				inst.Light:Enable(true)
				inst.Light:SetIntensity(INTENSITY)
            end)
        end
    end,TheWorld)
	
	inst.OnSave = function(inst, data)
        if inst.lighton then
            data.lighton = inst.lighton
        end
    end        

    inst.OnLoad = function(inst, data)    
        if data then
            if data.lighton then 
                fadein(inst)
                inst.Light:Enable(true)
                inst.Light:SetIntensity(INTENSITY)            
                inst.AnimState:Show("glow")        
                inst.lighton = true
            end
        end
    end
	
    return inst
end

local function shortfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddLight()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(0.58)
    inst.Light:SetIntensity(INTENSITY)
    inst.Light:SetRadius(12)
    inst.Light:SetColour(200/255, 200/255, 200/255)
	inst.Light:Enable(true)
	
    MakeObstaclePhysics(inst, .2)
	
    inst.AnimState:SetBank("kyno_lamp_post_short")
    inst.AnimState:SetBuild("kyno_lamp_post_short")
    inst.AnimState:PlayAnimation("idle_on")
    
	inst:AddTag("structure")
	inst:AddTag("streetlamp_short")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_LAMP_SHORT"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("fader")
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	
	inst:DoTaskInTime(1, function()
        if TheWorld.state.isday and not TheWorld:HasTag("cave") then
            inst.AnimState:PlayAnimation("idle_off")
			inst.AnimState:PushAnimation("idle_off", true)
            inst.Light:Enable(false)
			inst.Light:SetIntensity(0)
			inst.components.fader:Fade(INTENSITY, 0, .75+math.random()*1, function(v) inst.Light:SetIntensity(v) end)
        else
			inst.AnimState:PlayAnimation("idle_on")
			inst.AnimState:PushAnimation("idle_on", true)
            inst.Light:Enable(true)
			inst.Light:SetIntensity(INTENSITY)
			inst.components.fader:Fade(0, INTENSITY, 3+math.random()*2, function(v) inst.Light:SetIntensity(v) end)
        end
    end)
    inst:ListenForEvent("phasechanged", function(src, data)
        if data ~= "night" and data ~= "dusk" and not TheWorld:HasTag("cave") then
            inst:DoTaskInTime(2, function()
                inst.AnimState:PlayAnimation("idle_off")
				inst.AnimState:PushAnimation("idle_off", true)
				inst.Light:Enable(false)
				inst.Light:SetIntensity(0)
            end)
        else
            inst:DoTaskInTime(2, function()
				inst.AnimState:PlayAnimation("idle_on")
				inst.AnimState:PushAnimation("idle_on", true)
				inst.Light:Enable(true)
				inst.Light:SetIntensity(INTENSITY)
            end)
        end
    end,TheWorld)
	
	inst.OnSave = function(inst, data)
        if inst.lighton then
            data.lighton = inst.lighton
        end
    end        

    inst.OnLoad = function(inst, data)    
        if data then
            if data.lighton then 
                fadein(inst)
                inst.Light:Enable(true)
                inst.Light:SetIntensity(INTENSITY)            
                inst.AnimState:Show("glow")        
                inst.lighton = true
            end
        end
    end
	
    return inst
end

return Prefab("quagmire_lamp_post", LightFn("quagmire_lamp_post", 3.5, 0.58, 0.75, 235), { Asset("ANIM", "anim/quagmire_lamp_post.zip") }),
       Prefab("quagmire_lamp_short", LightFn("quagmire_lamp_short", 2, 0.58, 0.75, 200), { Asset("ANIM", "anim/quagmire_lamp_short.zip") }),
	   
	   MakePlacer("quagmire_lamp_post_placer", "quagmire_lamp_post", "quagmire_lamp_post", "idle"),
       MakePlacer("quagmire_lamp_short_placer", "quagmire_lamp_short", "quagmire_lamp_short", "idle")
