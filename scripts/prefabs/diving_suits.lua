local assets =
{
    Asset("ANIM", "anim/diving_suit_summer.zip"),
    Asset("ANIM", "anim/diving_suit_winter.zip"),
}

local function onequip(inst, owner)
    owner:AddTag("nadador")
    owner.AnimState:OverrideSymbol("swap_body", inst.prefab, "swap_body")
    inst.components.fueled:StartConsuming()
    if owner.components.health then -- for robots
        owner:DoTaskInTime(0, function(wilson)
            wilson.components.health:RecalculatePenalty()
        end)
    end
end

local function onunequip(inst, owner)
    owner:RemoveTag("nadador")
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst.components.fueled:StopConsuming()
    if owner.components.health then -- for robots
        owner:DoTaskInTime(0, function(wilson)
            wilson.components.health:RecalculatePenalty()
        end)
    end
end

local function create_summer()
    local inst = CreateEntity()
    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.AnimState:SetBank("diving_suit_summer")
    inst.AnimState:SetBuild("diving_suit_summer")

    MakeInventoryPhysics(inst)

    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("diving_suit")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.foleysound = "dontstarve/movement/foley/trunksuit"

    --    inst:AddComponent("dapperness")
    --    inst.components.dapperness.dapperness = TUNING.DAPPERNESS_SMALL


    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.WAIST or EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("insulator")

    inst:AddTag("clothing")

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.TRUNKVEST_PERISHTIME)
    inst.components.fueled:SetDepletedFn(inst.Remove)

    inst:AddComponent("oxygenapparatus")

    inst.components.insulator.insulation = TUNING.INSULATION_SMALL

    local map = TheWorld.Map
    local x, y, z = inst.Transform:GetWorldPosition()
    local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))
    local naagua = false
    if ground == GROUND.UNDERWATER_SANDY or ground == GROUND.UNDERWATER_ROCKY or (ground == GROUND.BEACH and TheWorld:HasTag("cave")) or (ground == GROUND.PIGRUINS and TheWorld:HasTag("cave")) or (ground == GROUND.PEBBLEBEACH and TheWorld:HasTag("cave")) or (ground == GROUND.MAGMAFIELD and TheWorld:HasTag("cave")) or (ground == GROUND.PAINTED and TheWorld:HasTag("cave")) then naagua = true end

    if naagua then
        inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT
    end

    inst.components.oxygenapparatus:SetReductionPercentage(0.5)

    inst.components.inventoryitem.imagename = "diving_suit_summer"

    return inst
end

local function create_winter()
    local inst = CreateEntity()
    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.AnimState:SetBank("diving_suit_winter")
    inst.AnimState:SetBuild("diving_suit_winter")

    MakeInventoryPhysics(inst)

    inst.AnimState:PlayAnimation("anim")
    inst:AddTag("diving_suit")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.foleysound = "dontstarve/movement/foley/trunksuit"

    --    inst:AddComponent("dapperness")
    --    inst.components.dapperness.dapperness = TUNING.DAPPERNESS_SMALL


    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.WAIST or EQUIPSLOTS.BODY -- 适配五格

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("insulator")

    inst:AddTag("clothing") -- 适配六格

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.TRUNKVEST_PERISHTIME)
    inst.components.fueled:SetDepletedFn(inst.Remove)

    inst:AddComponent("oxygenapparatus")

    inst.components.insulator.insulation = TUNING.INSULATION_LARGE
    inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT
    inst.components.oxygenapparatus:SetReductionPercentage(0.5)

    inst.components.inventoryitem.imagename = "diving_suit_winter"

    return inst
end

return Prefab("diving_suit_summer", create_summer, assets),
    Prefab("diving_suit_winter", create_winter, assets)
