local assets =
{
    Asset("ANIM", "anim/quagmire_salt_rack.zip"),
    Asset("ANIM", "anim/quagmire_pot_hanger.zip"),
}

local prefabs =
{
    "salt_rack_item",
    "saltrock",
    "collapse_small",
    "splash",
}

local prefabs_item =
{
    "salt_rack",
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("salt_rack.png")

    inst.AnimState:SetBank("quagmire_salt_rack")
    inst.AnimState:SetBuild("quagmire_salt_rack")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:Hide("salt")

    inst:AddTag("FX")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    return inst
end

local function TargetCheckFn(inst, doer, target)
    return target:HasTag("saltwater")
end

local function ConsumableState(inst, doer)
    return doer:HasTag("quagmire_fasthands") and "domediumaction" or "dolongaction"
end

local function Use(inst, doer, target)
    if target.components.setupable then
        if target.components.setupable:IsSetup() then
            return false
        else
            target.components.setupable:Setup(inst)
            return true
        end
    end
    return false
end

local function itemfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("quagmire_pot_hanger")
    inst.AnimState:SetBuild("quagmire_pot_hanger")
    inst.AnimState:PlayAnimation("item", true)

    inst:AddTag("salty")
    inst:AddTag("saltrack")

    inst:AddComponent("tropical_consumable")
    inst.components.tropical_consumable.state = ConsumableState
    inst.components.tropical_consumable.targetCheckFn = TargetCheckFn
    inst.components.tropical_consumable.str = "INSTALL"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.tropical_consumable.onUseFn = Use

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(10)
    inst.components.finiteuses:SetUses(10)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    return inst
end

return Prefab("quagmire_salt_rack", fn, assets, prefabs),
    Prefab("quagmire_salt_rack_item", itemfn, assets, prefabs_item)
