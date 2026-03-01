local function OnEquipped(inst, data)
    data.owner.AnimState:OverrideSymbol(inst.symboltooverride, inst.build, inst.symbol)
    local boatfx = data.owner.components.shipwreckedboat.boatfx
    if boatfx then
        boatfx.AnimState:OverrideSymbol(inst.symboltooverride, inst.build, inst.symbol)
    end
    if inst.components.fueled then
        inst.components.fueled:StartConsuming()
    end
end

local function OnUnEquipped(inst, data)
    data.owner.AnimState:ClearOverrideSymbol(inst.symboltooverride)
    local boatfx = data.owner.components.shipwreckedboat.boatfx
    if boatfx then
        boatfx.AnimState:ClearOverrideSymbol(inst.symboltooverride)
    end
    if inst.components.fueled then
        inst.components.fueled:StopConsuming()
    end
end

---fn
---@param bank string
---@param build string
---@param anim string
---@param symbol string
---@param data table|nil {perish_time,fueltype,speed_mult}
local function common(bank, build, anim, symbol, data)
    data = data or {}

    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.build = build
    inst.symbol = symbol
    inst.symboltooverride = symbol
    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(inst.build)
    inst.AnimState:PlayAnimation(anim)

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst:AddTag("sail")
    inst:AddTag("shipwrecked_boat_tail")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    if data.perish_time then
        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = data.fueltype or FUELTYPE.USAGE
        inst.components.fueled:SetDepletedFn(inst.Remove)
        inst.components.fueled:InitializeFuelLevel(data.perish_time)
    end

    inst:AddComponent("shipwreckedboatparts")
    inst.components.shipwreckedboatparts:SetSpeedMult(data.speed_mult or 1)
    inst.components.shipwreckedboatparts.move_sound = data.move_sound

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    inst:ListenForEvent("boat_equipped", OnEquipped)
    inst:ListenForEvent("boat_unequipped", OnUnEquipped)

    return inst
end

----------------------------------------------------------------------------------------------------

local sail_assets =
{
    Asset("ANIM", "anim/swap_sail.zip"),
}

local function sail_fn()
    return common("sail", "swap_sail", "idle", "swap_sail", {
        perish_time = TUNING.TOTAL_DAY_TIME * 2,
        speed_mult = 1.2,
        move_sound = "dontstarve_DLC002/common/sail_LP_cloth"
    })
end

local clothsail_assets =
{
    Asset("ANIM", "anim/swap_sail_cloth.zip"),
}

local function clothsail_fn()
    return common("sail", "swap_sail_cloth", "idle", "swap_sail", {
        perish_time = TUNING.TOTAL_DAY_TIME * 3,
        speed_mult = 1.3,
        move_sound = "dontstarve_DLC002/common/sail_LP_cloth"
    })
end

local snakeskinsail_assets =
{
    Asset("ANIM", "anim/swap_sail_snakeskin.zip"),
}

local function snakeskinsail_fn()
    return common("sail", "swap_sail_snakeskin", "idle", "swap_sail", {
        perish_time = TUNING.TOTAL_DAY_TIME * 4,
        speed_mult = 1.25,
        move_sound = "dontstarve_DLC002/common/sail_LP_snakeskin"
    })
end

local feathersailassets =
{
    Asset("ANIM", "anim/swap_sail_feathers.zip"),
}

local function feathersail_fn()
    return common("sail", "swap_sail_feathers", "idle", "swap_sail", {
        perish_time = TUNING.TOTAL_DAY_TIME * 2,
        speed_mult = 1.4,
        move_sound = "dontstarve_DLC002/common/sail_LP_feather"
    })
end

local ironwind_assets =
{
    Asset("ANIM", "anim/swap_propeller.zip"),
}

local function ironwind_fn()
    return common("propeller", "swap_propeller", "idle", "swap_propeller", {
        perish_time = TUNING.TOTAL_DAY_TIME * 4,
        fueltype = FUELTYPE.REPARODEBARCO,
        speed_mult = 1.5,
        move_sound = "dontstarve_DLC002/common/boatpropellor_lp"
    })
end

local woodlegssail_assets =
{
    Asset("ANIM", "anim/swap_sail_pirate.zip"),
}

local function woodlegssail_fn()
    return common("sail", "swap_sail_pirate", "anim", "swap_sail", {
        move_sound = "dontstarve_DLC002/common/sail_LP_sealegs"
    })
end

local malbatrossail_assets =
{
    Asset("ANIM", "anim/swap_sail_malbatro.zip"),
}

local function malbatrossail_fn()
    return common("sail", "swap_sail_malbatro", "idle", "swap_sail", {
        perish_time = TUNING.TOTAL_DAY_TIME * 3,
        speed_mult = 1.3,
        move_sound = "dontstarve_DLC002/common/sail_LP_sealegs"
    })
end


return Prefab("sail", sail_fn, sail_assets),
    Prefab("clothsail", clothsail_fn, clothsail_assets),
    Prefab("snakeskinsail", snakeskinsail_fn, snakeskinsail_assets),
    Prefab("feathersail", feathersail_fn, feathersailassets),
    Prefab("ironwind", ironwind_fn, ironwind_assets),
    Prefab("woodlegssail", woodlegssail_fn, woodlegssail_assets),
    Prefab("malbatrossail", malbatrossail_fn, malbatrossail_assets)
