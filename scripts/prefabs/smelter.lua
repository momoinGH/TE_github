local cooking = require("cooking")

local assets =
{
	Asset("ANIM", "anim/smelter.zip"),
	--Asset("ANIM", "anim/cook_pot_food.zip"),
}

local prefabs = { "collapse_small" }

local function onhammered(inst, worker)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	if not inst:HasTag("burnt") and inst.components.stewer and inst.components.stewer.product and inst.components.stewer.done then
		inst.components.lootdropper:AddChanceLoot(inst.components.stewer.product, 1)
	end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhit(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit_empty")

		if inst.components.stewer.cooking then
			inst.AnimState:PushAnimation("smelting_loop")
		elseif inst.components.stewer.done then
			inst.AnimState:PushAnimation("idle_full")
		else
			inst.AnimState:PushAnimation("idle_empty")
		end
	end
end

local function ShowProduct(inst)
	if not inst:HasTag("burnt") then
		-- 图片能显示倒是能显示，但是图片一般太大又不支持缩放，干脆还是显示固定的铁好了
		-- local product = inst.components.stewer.product
		-- local recipe = cooking.GetRecipe(inst.prefab, product)
		-- local build = (recipe ~= nil and recipe.overridebuild) or overridebuild or GetInventoryItemAtlas(product .. ".tex") or "cook_pot_food"
		-- local overridesymbol = (recipe ~= nil and recipe.overridesymbolname) or (product .. ".tex")
		inst.AnimState:OverrideSymbol("swap_item", "alloy", "alloy01")
	end
end

local function startcookfn(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("smelting_pre")
		inst.AnimState:PushAnimation("smelting_loop", true)

		inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/smelter/move_1")
		inst.SoundEmitter:KillSound("snd")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/smelt_LP", "snd")
		inst.Light:Enable(true)
	end
end

local animparams = { frame = 3, scale = .05, curframe = 0 }

local function playJoggleAnim(inst)
	if not inst:HasTag("burnt") then
		local function stopJoggle(inst)
			if inst._joggleTask then
				inst._joggleTask:Cancel()
				inst._joggleTask = nil
				animparams.curframe = 0
				inst.AnimState:SetScale(1, 1)
			end
		end
		stopJoggle(inst)
		inst._joggleTask = inst:DoPeriodicTask(0, function(inst)
			inst.AnimState:SetScale(1 - animparams.scale * math.sin(math.pi / animparams.frame * animparams.curframe),
				1 + animparams.scale * math.sin(math.pi / animparams.frame * animparams.curframe))
			animparams.curframe = animparams.curframe + 1
			if animparams.curframe > animparams.frame then
				stopJoggle(inst)
			end
		end)
	end
end

local function onopen(inst)
	if not inst:HasTag("burnt") then
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/move_3", "open")
	end
	playJoggleAnim(inst)
end

local function onclose(inst)
	playJoggleAnim(inst)
end

local function spoilfn(inst)
	if not inst:HasTag("burnt") then
		inst.components.stewer.product = inst.components.stewer.spoiledproduct
		ShowProduct(inst)
	end
end

local function donecookfn(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("smelting_pst")
		inst.AnimState:PushAnimation("idle_full")
		ShowProduct(inst)
		inst.SoundEmitter:KillSound("snd")
		inst.Light:Enable(false)
		inst:DoTaskInTime(1 / 30, function()
			if inst.AnimState:IsCurrentAnimation("smelting_pst") then
				inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/move_1")
			end
		end)
		inst:DoTaskInTime(8 / 30, function()
			if inst.AnimState:IsCurrentAnimation("smelting_pst") then
				inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/move_2")
			end
		end)
		inst:DoTaskInTime(14 / 30, function()
			if inst.AnimState:IsCurrentAnimation("smelting_pst") then
				inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/pour")
			end
		end)
		inst:DoTaskInTime(31 / 30, function()
			if inst.AnimState:IsCurrentAnimation("smelting_pst") then
				inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/steam")
			end
		end)
		inst:DoTaskInTime(36 / 30, function()
			if inst.AnimState:IsCurrentAnimation("smelting_pst") then
				inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/brick")
			end
		end)
		inst:DoTaskInTime(49 / 30, function()
			if inst.AnimState:IsCurrentAnimation("smelting_pst") then
				inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/move_2")
			end
		end)
		--play a one-off sound
	end
end

local function continuedonefn(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("idle_full")
		ShowProduct(inst)
	end
end

local function continuecookfn(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("smelting_loop", true)
		--play a looping sound
		inst.Light:Enable(true)

		inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/smelt_LP", "snd")
	end
end

local function harvestfn(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("idle_empty")
	end
end

local function getstatus(inst)
	if inst:HasTag("burnt") then
		return "BURNT"
	elseif inst.components.stewer.cooking and inst.components.stewer:GetTimeToCook() > 15 then
		return "COOKING_LONG"
	elseif inst.components.stewer.cooking then
		return "COOKING_SHORT"
	elseif inst.components.stewer.done then
		return "DONE"
	else
		return "EMPTY"
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle_empty")
	inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/build")
	inst:DoTaskInTime(1 / 30, function()
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/brick")
	end)
	inst:DoTaskInTime(4 / 30, function()
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/smelter/brick")
	end)
end

local function onsave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
		data.burnt = true
	end
end

local function onload(inst, data)
	if data and data.burnt then
		inst.components.burnable.onburnt(inst)
		inst.Light:Enable(false)
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("cookpot.png")

	inst.entity:AddLight()
	inst.Light:Enable(false)
	inst.Light:SetRadius(.6)
	inst.Light:SetFalloff(1)
	inst.Light:SetIntensity(.5)
	inst.Light:SetColour(235 / 255, 62 / 255, 12 / 255)

	inst:AddTag("structure")
	inst:AddTag("stewer")

	MakeObstaclePhysics(inst, .5)

	inst.AnimState:SetBank("smelter")
	inst.AnimState:SetBuild("smelter")
	inst.AnimState:PlayAnimation("idle_empty")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("stewer")
	inst.components.stewer.onstartcooking = startcookfn
	inst.components.stewer.oncontinuecooking = continuecookfn
	inst.components.stewer.oncontinuedone = continuedonefn
	inst.components.stewer.ondonecooking = donecookfn
	inst.components.stewer.onharvest = harvestfn
	inst.components.stewer.onspoil = spoilfn

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("smelter")
	inst.components.container.onopenfn = onopen
	inst.components.container.onclosefn = onclose
	inst.replica.container.acceptsstacks = false

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = getstatus

	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)

	MakeSnowCovered(inst, .01)
	inst:ListenForEvent("onbuilt", onbuilt)

	MakeMediumBurnable(inst, nil, nil, true)
	MakeSmallPropagator(inst)

	inst.OnSave = onsave
	inst.OnLoad = onload

	return inst
end

return Prefab("smelter", fn, assets, prefabs),
	MakePlacer("smetler_placer", "smelter", "smelter", "idle_empty")
