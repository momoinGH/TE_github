local assets =
{
	Asset("ANIM", "anim/messagebottle.zip"),
	Asset("MINIMAP_IMAGE", "messageBottle"),
}

local function GiveEmpty(inst)

end

local function getrevealtargetpos(inst, doer)
	local map = TheWorld.Map
	local x, y, z
	local inventory = inst.components.inventoryitem:GetContainer()
	-- 返回这两个家伙的位置
	for _, name in ipairs({ "kraken", "octopusking" }) do
		for _, v in ipairs(TheWorld.components.tro_tempentitytracker:GetEnts(name)) do
			if not v.revelado then
				v.revelado = true
				x, y, z = v.Transform:GetWorldPosition()
-- TODO
				local empty_bottle = SpawnPrefab("messagebottleempty")
				empty_bottle.Transform:SetPosition(inst.Transform:GetWorldPosition())
				inst:Remove()
				if inventory ~= nil then
					inventory:GiveItem(empty_bottle)
				end
				return Vector3(math.floor(x), 0, math.floor(z))
			end
		end
	end

	local sx, sy = TheWorld.Map:GetSize()

	for i = 1, 500 do
		x = math.random(-sx, sx)
		z = math.random(-sy, sy)
		if map:IsAboveGroundAtPoint(x, 0, z) then
			break
		end
	end

	SpawnPrefab("buriedtreasure").Transform:SetPosition(x, 0, z)
	return Vector3(x, 0, z)
end

local function messagebottlefn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("messagebottle")
	inst.AnimState:SetBuild("messagebottle")
	inst.AnimState:PlayAnimation("idle", true)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("messageBottle.png")

	inst:AddTag("aquatic")
	inst:AddTag("messagebottle")
	inst:AddTag("nosteal")
	inst:AddTag("unwrappable")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")

	inst:AddComponent("waterproofer")
	inst.components.waterproofer:SetEffectiveness(0)

	inst:AddComponent("mapspotrevealer")
	inst.components.mapspotrevealer:SetGetTargetFn(getrevealtargetpos)
	inst.components.mapspotrevealer.postreveal = inst.Remove

	return inst
end

return Prefab("messagebottle1", messagebottlefn, assets)
