local assets =
{
	Asset("ANIM", "anim/hand_lens.zip"),
	Asset("ANIM", "anim/swap_hand_lens.zip"),
}

local prefabs =
{
}

local MAGNIFYING_GLASS_USES = 50
local MAGNIFYING_GLASS_DAMAGE = 34 * .125

local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_hand_lens", "swap_hand_lens")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
end

local function onfinished(inst)
	inst:Remove()
end

local function TargetCheck(inst, doer, target)
	return (target:HasTag("spyable") or target:HasTag("secret_room")) and not doer.replica.rider:IsRiding()
end

local function OnUse(inst, doer, target)
	if target:HasTag("secret_room") then
		target.Investigate(doer)
		return true
	end

	if target.components.mystery then
		target.components.mystery:Investigate(doer)
		inst.components.finiteuses:Use(1)
		return true
	end
end

local function fn(Sim)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	MakeInventoryPhysics(inst)

	MakeInventoryFloatable(inst, "small", 0.05, { 1.2, 0.75, 1.2 })

	inst.AnimState:SetBank("hand_lens")
	inst.AnimState:SetBuild("hand_lens")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("magnifying_glass")

	inst:AddComponent("pro_componentaction"):InitUSEITEM(TargetCheck, "investigate", "SPY", OnUse)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.components.floater:SetBankSwapOnFloat(true, -10, { sym_build = "swap_hand_lens" })

	inst:AddComponent("finiteuses")

	local uses = MAGNIFYING_GLASS_USES

	inst.components.finiteuses:SetMaxUses(uses)
	inst.components.finiteuses:SetUses(uses)
	inst.components.finiteuses:SetOnFinished(onfinished)
	-------
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(MAGNIFYING_GLASS_DAMAGE)

	-------
	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")


	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(onequip)
	inst.components.equippable:SetOnUnequip(onunequip)

	inst:AddComponent("lighter")

	return inst
end

return Prefab("magnifying_glass", fn, assets, prefabs)
