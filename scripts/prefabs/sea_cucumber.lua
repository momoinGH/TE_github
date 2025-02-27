local assets =
{
	Asset("ANIM", "anim/sea_cucumber.zip"),
}

local function StartSpoil(inst)
	inst.components.perishable:StartPerishing()
end
local function StopSpoil(inst)
	inst.components.perishable:StopPerishing()
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddNetwork()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	MakeInventoryPhysics(inst)

	MakeInventoryFloatable(inst)

	anim:SetBank("sea_cucumber")
	anim:SetBuild("sea_cucumber")
	anim:PlayAnimation("idle")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("edible")
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	inst.components.edible.healthvalue = TUNING.HEALING_TINY
	inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
	inst.components.edible.sanityvalue = 0


	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "sea_cucumber"

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:DoTaskInTime(0.1, function()
		local map = TheWorld.Map
		local x, y, z = inst.Transform:GetWorldPosition()
		local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))
		local naagua = false
		if ground == GROUND.UNDERWATER_SANDY or ground == GROUND.UNDERWATER_ROCKY or (ground == GROUND.BEACH and TheWorld:HasTag("cave")) or (ground == GROUND.PIGRUINS and TheWorld:HasTag("cave")) or (ground == GROUND.PEBBLEBEACH and TheWorld:HasTag("cave")) or (ground == GROUND.MAGMAFIELD and TheWorld:HasTag("cave")) or (ground == GROUND.PAINTED and TheWorld:HasTag("cave")) then naagua = true end

		if naagua then
			StopSpoil(inst)
			inst:ListenForEvent("onpickup", StartSpoil)
			inst:ListenForEvent("ondropped", StopSpoil)
		else
			StartSpoil(inst)
		end
	end)


	return inst
end

return Prefab("sea_cucumber", fn, assets)
