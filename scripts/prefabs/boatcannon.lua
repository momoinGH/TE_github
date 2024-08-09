local BOATCANNON_AMMO_COUNT = 15

local function onthrowfn(inst)
    if inst.components.finiteuses then
        inst.components.finiteuses:Use()
    end
end

local function canshootfn(inst, pt)
    return true
end

local function OnBoatQeuipped(inst, data)
    data.owner.AnimState:OverrideSymbol("swap_lantern", inst.symbol_build, inst.symbol)
end

local function OnBoatUnQeuipped(inst, data)
    data.owner.AnimState:ClearOverrideSymbol("swap_lantern")
end

local function OnFinished(inst)
    local boat = inst.components.shipwreckedboatparts:GetBoat()
    if boat then
        boat.AnimState:ClearOverrideSymbol("swap_lantern")
    end

    inst:Remove()
end

local function common(bank, build, anim, symbol_build, symbol)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.symbol_build = symbol_build
    inst.symbol = symbol

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation(anim)

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst:AddTag("boatcannon")
    inst:AddTag("shipwrecked_boat_head")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/volcanoinventory.xml"

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(BOATCANNON_AMMO_COUNT)
    inst.components.finiteuses:SetUses(BOATCANNON_AMMO_COUNT)
    inst.components.finiteuses:SetOnFinished(OnFinished)

    inst:AddComponent("reticule")
    inst.components.reticule.targetfn = function()
        return inst.components.thrower:GetThrowPoint()
    end
    inst.components.reticule.ease = true

    inst:AddComponent("thrower")
    inst.components.thrower.throwable_prefab = "cannonshot"
    inst.components.thrower.onthrowfn = onthrowfn
    inst.components.thrower.canthrowatpointfn = canshootfn

    inst:AddComponent("shipwreckedboatparts")

    inst:ListenForEvent("boat_equipped", OnBoatQeuipped)
    inst:ListenForEvent("boat_unequipped", OnBoatUnQeuipped)

    return inst
end

----------------------------------------------------------------------------------------------------

local boatcannon_assets = {
    Asset("ANIM", "anim/swap_cannon.zip"),
}

local boatcannon_prefabs = {
    "cannonshot",
    "collapse_small",
}

local function boatcannon_fn()
    return common("cannon", "swap_cannon", "idle", "swap_cannon", "swap_cannon")
end

local woodlegs_boatcannon_assets = {
    Asset("ANIM", "anim/swap_cannon_pirate.zip"),
}

local woodlegs_boatcannon_prefabs = {
    "collapse_small",
}

local function woodlegs_boatcannon_fn()
    return common("cannon", "swap_cannon_pirate", "anim", "swap_cannon_pirate", "swap_cannon")
end

return Prefab("boatcannon", boatcannon_fn, boatcannon_assets, boatcannon_prefabs),
    Prefab("woodlegs_boatcannon", woodlegs_boatcannon_fn, woodlegs_boatcannon_assets, woodlegs_boatcannon_prefabs)
