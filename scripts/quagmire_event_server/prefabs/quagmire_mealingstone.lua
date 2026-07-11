local function onopen(inst)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/clayhound/footstep_hound")

	local foodstuff = inst.replica.container ~= nil and inst.replica.container:GetItemInSlot(1) or
		inst.components.container:GetItemInSlot(1)

	if foodstuff ~= nil then
		if foodstuff.prefab == "quagmire_flour" or foodstuff.prefab == "turnip_sugar" then
			inst.SoundEmitter:PlaySound("dontstarve/quagmire/HUD/meal_cooked")
		elseif foodstuff.prefab == "ash" then
			inst.SoundEmitter:PlaySound("dontstarve/quagmire/HUD/failed_recipe")
		end
	end
end

local function mealdone(inst)
	if inst.components.mealer ~= nil then
		inst.SoundEmitter:PlaySound("dontstarve/creatures/together/clayhound/stone_shake")
		inst.components.mealer:DoneMealing()
	end
end

local function meal(inst)
	if inst.components.mealer ~= nil then
		inst.AnimState:PlayAnimation("proximity_loop")
		inst.SoundEmitter:PlaySound("dontstarve/creatures/together/clayhound/stone_shake")
		inst.SoundEmitter:PlaySound("dontstarve/creatures/together/clayhound/footstep_hound")
		inst:DoTaskInTime(1.8, mealdone)
	end
end

local function onfar(inst)
	if inst.components.container ~= nil then
		inst.components.container:Close()
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle")
	inst.SoundEmitter:PlaySound("dontstarve/common/cook_pot_craft")
end

local function onsave(inst, data)
	if inst.components.mealer:IsMealing() then
		data.ismealing = true
		data.mealprize = inst.components.mealer.prize
	end
end

local function onload(inst, data)
	if data and data.ismealing then
		inst.components.mealer.prize = data.mealprize
		inst.components.mealer:ResumeMealing()
	end
end

return {
	master_postinit = function(inst)
		inst:AddComponent("container")
		inst.components.container:WidgetSetup("quagmire_mealingstone")
		inst.components.container.onopenfn = onopen

		inst:AddComponent("inspectable")

		inst:AddComponent("playerprox")
		inst.components.playerprox:SetDist(3, 5)
		inst.components.playerprox:SetOnPlayerFar(onfar)

		inst:AddComponent("mealer")
		inst.components.mealer:SetStartMealingFn(meal)

		inst:ListenForEvent("onbuilt", onbuilt)

		inst.OnSave = onsave
		inst.OnLoad = onload
	end,
}
