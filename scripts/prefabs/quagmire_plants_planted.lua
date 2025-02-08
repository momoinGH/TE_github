local assets =
{
	Asset("ANIM", "anim/farm_soil.zip"),

	Asset("ANIM", "anim/quagmire_soil.zip"),
	Asset("ANIM", "anim/quagmire_crop_onion.zip"),
	Asset("ANIM", "anim/quagmire_crop_wheat.zip"),
	Asset("ANIM", "anim/quagmire_crop_turnip.zip"),
	Asset("ANIM", "anim/quagmire_crop_potato.zip"),
	Asset("ANIM", "anim/quagmire_crop_tomato.zip"),
	Asset("ANIM", "anim/quagmire_crop_garlic.zip"),
}

local prefabs =
{
	"onion",
	"wheat",
	"turnip",
	"phtato",
	"tomato",
	"garlic",
}
    --all you eat is defined in veggies.lua
local function fn_onion(Sim)

	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("quagmire_soil")
	inst.AnimState:SetBuild("quagmire_crop_onion")
	inst.AnimState:PlayAnimation("crop_full", true)
	inst.AnimState:OverrideSymbol("soil01", "farm_soil", "soil01")
	inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:SetFinalOffset(2)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
	inst.components.pickable:SetUp("onion", 10)
	inst.components.pickable.remove_when_picked = true
	inst.components.pickable.quickpick = true

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)

	return inst
end
local function fn_wheat(Sim)

	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("quagmire_soil")
	inst.AnimState:SetBuild("quagmire_crop_wheat")
	inst.AnimState:PlayAnimation("crop_full", true)
	inst.AnimState:OverrideSymbol("soil01", "farm_soil", "soil01")
	inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:SetFinalOffset(2)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
	inst.components.pickable:SetUp("wheat", 10)
	inst.components.pickable.remove_when_picked = true
	inst.components.pickable.quickpick = true

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)

	return inst
end
local function fn_turnip(Sim)

	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("quagmire_soil")
	inst.AnimState:SetBuild("quagmire_crop_turnip")
	inst.AnimState:PlayAnimation("crop_full", true)
	inst.AnimState:OverrideSymbol("soil01", "farm_soil", "soil01")
	inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:SetFinalOffset(2)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
	inst.components.pickable:SetUp("turnip", 10)
	inst.components.pickable.remove_when_picked = true
	inst.components.pickable.quickpick = true

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)

	return inst
end
local function fn_potato(Sim)

	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("quagmire_soil")
	inst.AnimState:SetBuild("quagmire_crop_potato")
	inst.AnimState:PlayAnimation("crop_full", true)
	inst.AnimState:OverrideSymbol("soil01", "farm_soil", "soil01")
	inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:SetFinalOffset(2)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
	inst.components.pickable:SetUp("potato", 10)
	inst.components.pickable.remove_when_picked = true
	inst.components.pickable.quickpick = true

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)

	return inst
end
local function fn_tomato(Sim)

	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("quagmire_soil")
	inst.AnimState:SetBuild("quagmire_crop_tomato")
	inst.AnimState:PlayAnimation("crop_full", true)
	inst.AnimState:OverrideSymbol("soil01", "farm_soil", "soil01")
	inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:SetFinalOffset(2)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
	inst.components.pickable:SetUp("tomato", 10)
	inst.components.pickable.remove_when_picked = true
	inst.components.pickable.quickpick = true

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)

	return inst
end
local function fn_garlic(Sim)

	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("quagmire_soil")
	inst.AnimState:SetBuild("quagmire_crop_garlic")
	inst.AnimState:PlayAnimation("crop_full", true)
	inst.AnimState:OverrideSymbol("soil01", "farm_soil", "soil01")
	inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:SetFinalOffset(2)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
	inst.components.pickable:SetUp("garlic", 10)
	inst.components.pickable.remove_when_picked = true
	inst.components.pickable.quickpick = true

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)

	return inst
end

return
    --Prefab("onion_planted", fn_onion, assets),--和哈姆的同名了
	Prefab("wheat_planted", fn_wheat, assets),
	Prefab("turnip_planted", fn_turnip, assets),
	Prefab("potato_planted", fn_potato, assets),
	Prefab("tomato_planted", fn_tomato, assets),
	Prefab("garlic_planted", fn_garlic, assets)
