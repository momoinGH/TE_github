local assets = {}
local prefabs = { "flup" }

local function common(range, density)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddNetwork()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("areaspawner")
	inst.components.areaspawner:SetValidTileType(GROUND.TIDALMARSH)
	inst.components.areaspawner:SetPrefab("flup")
	inst.components.areaspawner:SetDensityInRange(range, density)
	inst.components.areaspawner:SetMinimumSpacing(10)
	--	inst.components.areaspawner:SetSpawnTestFn(spawntestfn)
	inst.components.areaspawner:SetRandomTimes(TUNING.TOTAL_DAY_TIME * 3, TUNING.TOTAL_DAY_TIME)
	inst.components.areaspawner:Start()

	return inst
end

local function fn()
	return common(40, 5)
end

local function dense_fn()
	return common(40, 10)
end

local function sparse_fn()
	return common(40, 2)
end


return Prefab("flupspawner", fn, assets, prefabs),
	Prefab("flupspawner_dense", dense_fn, assets, prefabs),
	Prefab("flupspawner_sparse", sparse_fn, assets, prefabs)
