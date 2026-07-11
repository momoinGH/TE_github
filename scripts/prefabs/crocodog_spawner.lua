local prefabs =
{
	"crocodog",
	"poisoncrocodog",
	"watercrocodog",
}

local function oninit(inst)
	local dado = math.random(1, 3)
	if dado == 1 then
		SpawnAt("crocodog", inst)
	elseif dado == 2 then
		SpawnAt("poisoncrocodog", inst)
	elseif dado == 3 then
		SpawnAt("watercrocodog", inst)
	end
	inst:Remove()
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()

	inst:AddTag("NOCLICK")
	inst:DoTaskInTime(0, oninit)

	return inst
end

return Prefab("crocodog_spawner", fn, nil, prefabs)
