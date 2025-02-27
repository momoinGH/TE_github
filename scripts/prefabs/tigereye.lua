local assets =
{
	Asset("ANIM", "anim/eye_of_the_tiger.zip"),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.AnimState:SetBuild("eye_of_the_tiger")
	inst.AnimState:SetBank("eye_of_the_tiger")
	inst.AnimState:PlayAnimation("idle")

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst:AddTag("aquatic")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end


	inst:AddComponent("inventoryitem")

	inst:AddComponent("inspectable")

	inst:AddComponent("edible")
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.healthvalue = TUNING.HEALING_HUGE
	inst.components.edible.hungervalue = TUNING.CALORIES_HUGE
	inst.components.edible.sanityvalue = -TUNING.SANITY_MED

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM


	return inst
end

return Prefab("tigereye", fn, assets)
