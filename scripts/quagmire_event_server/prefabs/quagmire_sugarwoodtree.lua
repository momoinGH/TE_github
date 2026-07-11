local TREE_DEFS = {
	{
		prefab_name = "quagmire_sugarwoodtree_small",
		anim_file = "quagmire_tree_cotton_short",
		loot = { "log" },
		workleft = 5,
	},
	{
		prefab_name = "quagmire_sugarwoodtree_normal",
		anim_file = "quagmire_tree_cotton_normal",
		loot = { "log", "twigs" },
		workleft = 10,
	},
	{
		prefab_name = "quagmire_sugarwoodtree_tall",
		anim_file = "quagmire_tree_cotton_tall",
		loot = { "log", "log", "twigs" },
		workleft = 15,
	},
}


local PALMTREE_CHOPS_SMALL = 5
local PALMTREE_CHOPS_NORMAL = 10
local PALMTREE_CHOPS_TALL = 15
local DEFAULT_TREE_DEF = math.random(1, 3)


local function SetStage(inst, stage)
	stage = stage or DEFAULT_TREE_DEF
	inst.stage = stage
	inst.AnimState:SetBank(TREE_DEFS[stage].anim_file)
	inst.AnimState:PlayAnimation("sway1_loop", true)
	inst.components.lootdropper:SetLoot(TREE_DEFS[stage].loot)
end


local function SetShort(inst)
	SetStage(inst, 1)

	if inst.components.workable then
		inst.components.workable:SetWorkLeft(TREE_DEFS[1].workleft)
	end
end

local function GrowShort(inst)
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrowFromWilt")
end

local function SetNormal(inst)
	SetStage(inst, 2)

	if inst.components.workable then
		inst.components.workable:SetWorkLeft(TREE_DEFS[2].workleft)
	end
end

local function GrowNormal(inst)
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
end

local function SetTall(inst)
	SetStage(inst, 3)
	if inst.components.workable then
		inst.components.workable:SetWorkLeft(TREE_DEFS[3].workleft)
	end
end

local function GrowTall(inst)
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
end

local growth_stages =
{
	{
		name = "short",
		time = function(inst)
			return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[1].base,
				TUNING.EVERGREEN_GROW_TIME[1].random)
		end,
		fn = function(inst)
			SetShort(inst)
		end,
		growfn = function(inst)
			GrowShort(inst)
		end,
		leifscale = .7
	},
	{
		name = "normal",
		time = function(inst)
			return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[2].base,
				TUNING.EVERGREEN_GROW_TIME[2].random)
		end,
		fn = function(
			inst)
			SetNormal(inst)
		end,
		growfn = function(
			inst)
			GrowNormal(inst)
		end,
		leifscale = 1
	},
	{
		name = "tall",
		time = function(inst)
			return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[3].base,
				TUNING.EVERGREEN_GROW_TIME[3].random)
		end,
		fn = function(inst)
			SetTall(inst)
		end,
		growfn = function(inst)
			GrowTall(inst)
		end,
		leifscale = 1.25
	},
	--{name="old", time = function(inst) return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[4].base, TUNING.EVERGREEN_GROW_TIME[4].random) end, fn = function(inst) SetOld(inst) end, growfn = function(inst) GrowOld(inst) end },
}

local function ChopDownTreeShake(inst)
	ShakeAllCameras(
		CAMERASHAKE.FULL,
		.25,
		.03,
		inst.stage > 2 and .5 or .25,
		inst, 6
	)
end

local function DigUpStump(inst)
	inst.components.lootdropper:SpawnLootPrefab("log")
	inst:Remove()
end

local function MakeStump(inst)
	inst:RemoveComponent("burnable")
	MakeSmallBurnable(inst)
	inst:RemoveComponent("propagator")
	MakeSmallPropagator(inst)
	inst:RemoveComponent("workable")
	inst:RemoveTag("shelter")
	inst:RemoveTag("cattoyairborne")
	inst:AddTag("stump")

	RemovePhysicsColliders(inst)

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(DigUpStump)
	inst.components.workable:SetWorkLeft(1)

	if inst.components.growable ~= nil then
		inst.components.growable:StopGrowing()
	end
end

local function ChopDownTree(inst, chopper)
	inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")

	local pt = inst:GetPosition()
	local he_right = chopper == nil or (chopper:GetPosition() - pt):Dot(TheCamera:GetRightVec()) > 0

	if he_right then
		inst.AnimState:PlayAnimation("fallleft")
		inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
	else
		inst.AnimState:PlayAnimation("fallright")
		inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
	end

	inst.AnimState:PushAnimation("stump")

	if inst.flies then
		inst.flies:Remove()
		inst.flies = nil
	end

	inst:DoTaskInTime(.4, ChopDownTreeShake)

	inst:RemoveComponent("quagmire_tappable")

	inst:RemoveTag("tappable")
	inst:RemoveTag("shelter")
	inst:RemoveTag("cattoyairborne")

	inst:AddTag("stump")

	RemovePhysicsColliders(inst)

	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(DigUpStump)
	inst.components.workable:SetWorkLeft(1)

	MakeStump(inst)
end

local function OnChop(inst, chopper)
	local x, y, z = inst.Transform:GetWorldPosition()

	if not inst:HasTag("stump") then
		if inst:HasTag("withered") then
			SpawnPrefab("sugarwood_leaf_withered_fx_chop").Transform:SetPosition(x, 1, z)
		elseif not inst:HasTag("dead") then
			SpawnPrefab("sugarwood_leaf_fx_chop").Transform:SetPosition(x, 1, z)
		end
	end

	if not (chopper ~= nil and chopper:HasTag("playerghost")) then
		inst.SoundEmitter:PlaySound(
			chopper ~= nil and chopper:HasTag("beaver") and
			"dontstarve/characters/woodie/beaver_chop_tree" or
			"dontstarve/wilson/use_axe_tree"
		)
	end

	if inst.components.quagmire_tappable ~= nil and inst.components.quagmire_tappable:IsTapped() then
		inst.components.quagmire_tappable:UninstallTap(nil)
	end

	inst.AnimState:PlayAnimation("chop")
	inst.AnimState:PushAnimation(math.random() > .5 and "sway1_loop" or "sway2_loop", true)
end


local function OnLoad(inst, data)
	if not data then
		return
	end

	if data.stage then
		SetStage(inst, data.stage)
	end

	if data.stump then
		inst.AnimState:PushAnimation("stump")
		MakeStump(inst)
	end
end

local function OnSave(inst, data)
	if not data then
		return
	end
	if inst.stage then
		data.stage = inst.stage
	end

	if inst:HasTag("stump") then
		data.stump = true
	end
end


return {
	master_postinit = function(inst, tree_def, prefab_name)
		inst.AnimState:SetBank(TREE_DEFS[tree_def or DEFAULT_TREE_DEF].anim_file)
		inst.AnimState:SetTime(math.random() * 2)

		MakeLargeBurnable(inst, TUNING.TREE_BURN_TIME)
		inst.components.burnable:SetFXLevel(5)
		inst.components.burnable:SetOnBurntFn(DefaultBurntFn)
		MakeMediumPropagator(inst)
		MakeSnowCovered(inst)

		inst:AddComponent("inspectable")
		inst:AddComponent("lootdropper")

		inst:AddComponent("quagmire_tappable")

		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.CHOP)
		inst.components.workable:SetOnFinishCallback(ChopDownTree)
		inst.components.workable:SetOnWorkCallback(OnChop)


		inst:AddComponent("growable")
		inst.components.growable.stages = growth_stages
		inst.components.growable:SetStage(tree_def or DEFAULT_TREE_DEF)
		inst.components.growable.loopstages = true
		inst.components.growable.springgrowth = true
		inst.components.growable:StartGrowing()

		inst.OnSave = OnSave
		inst.OnLoad = OnLoad
	end,
}
