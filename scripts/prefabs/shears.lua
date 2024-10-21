local assets =
{
    Asset("ANIM", "anim/shears.zip"),
    Asset("ANIM", "anim/swap_shears.zip"),
    Asset("INV_IMAGE", "shears"),
}

local SHEARS_DAMAGE = 34 * .5
local SHEARS_USES = 20

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_shears", "swap_shears")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "small", 0.05, { 1.2, 0.75, 1.2 })

    inst.AnimState:SetBank("shears")
    inst.AnimState:SetBuild("shears")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("shears")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.floater:SetBankSwapOnFloat(true, -20, { sym_build = "swap_shears" })

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(SHEARS_DAMAGE)
    ---------------------------------------------------------------
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.SHEAR)
    ---------------------------------------------------------------
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(SHEARS_USES)
    inst.components.finiteuses:SetUses(SHEARS_USES)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    ---------------------------------------------------------------
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    return inst
end


return Prefab("shears", fn, assets)
