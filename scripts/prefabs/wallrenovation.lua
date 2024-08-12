local assets =
{
	Asset("ANIM", "anim/pig_shop_doormats.zip"),
}

local function SpawnPiso2()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddNetwork()

	inst:AddTag("NOBLOCK")
	inst:AddTag("NOCLICK")
	inst:AddTag("prototyper")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("prototyper")
	inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.HOME_TWO

	inst.persists = false

	return inst
end

-- 玩家小房子室内原型机
return Prefab("wallrenovation", SpawnPiso2, assets)
