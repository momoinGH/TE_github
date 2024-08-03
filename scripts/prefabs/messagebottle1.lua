local assets =
{
	Asset("ANIM", "anim/messagebottle.zip"),
	Asset("MINIMAP_IMAGE", "messageBottle"),
}


-- TODO 看看能不能优化掉这个文件

local function getrevealtargetpos(inst, doer)
    local davez = nil
	local map = TheWorld.Map
	local x, y, z
	for k, v in pairs(Ents) do
		if (v.prefab == "kraken" and v.revelado == nil)
			or (v.prefab == "octopusking" and v.revelado == nil)
		then
			v.revelado = true
			davez = v
			break
		end
	end
	if davez then
		x, y, z = davez.Transform:GetWorldPosition()
		doer.components.inventory:GiveItem(SpawnPrefab("messagebottleempty1"))
		return Vector3(math.floor(x), 0, math.floor(z))
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
	inst.components.inventoryitem.atlasname = "images/inventoryimages/volcanoinventory.xml"


	inst:AddComponent("waterproofer")
	inst.components.waterproofer:SetEffectiveness(0)

	inst.no_wet_prefix = true
	--local minimap = inst.entity:AddMiniMapEntity() --temp

	--minimap:SetIcon("messageBottle.png")

	inst:AddComponent("mapspotrevealer")
	inst.components.mapspotrevealer:SetGetTargetFn(getrevealtargetpos)
	inst.components.mapspotrevealer.postreveal = inst.Remove

	return inst
end

local function emptybottlefn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	anim:SetBank("messagebottle")
	anim:SetBuild("messagebottle")
	inst.AnimState:PlayAnimation("idle_empty", true)
	inst:AddTag("aquatic")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/volcanoinventory.xml"


	inst:AddComponent("waterproofer")
	inst.components.waterproofer:SetEffectiveness(0)

	inst.no_wet_prefix = true

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	return inst
end

return Prefab("shipwrecked/objects/messagebottle1", messagebottlefn, assets),
	Prefab("shipwrecked/objects/messagebottleempty1", emptybottlefn, assets)
