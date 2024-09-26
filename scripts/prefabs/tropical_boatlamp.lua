local function DoTurnOffSound(inst, owner)
    inst._soundtask = nil
    (owner ~= nil and owner:IsValid() and owner.SoundEmitter or inst.SoundEmitter):PlaySound(
        "dontstarve/wilson/lantern_off")
end

local function PlayTurnOffSound(inst)
    if inst._soundtask == nil and inst:GetTimeAlive() > 0 then
        inst._soundtask = inst:DoTaskInTime(0, DoTurnOffSound, inst.components.inventoryitem.owner)
    end
end

local function PlayTurnOnSound(inst)
    if inst._soundtask ~= nil then
        inst._soundtask:Cancel()
        inst._soundtask = nil
    elseif not POPULATING then
        inst._light.SoundEmitter:PlaySound("dontstarve/wilson/lantern_on")
    end
end

local function fuelupdate(inst)
    if inst._light ~= nil then
        local fuelpercent = inst.components.fueled:GetPercent()
        inst._light.Light:SetIntensity(Lerp(.4, .6, fuelpercent))
        inst._light.Light:SetRadius(Lerp(3, 5, fuelpercent))
        inst._light.Light:SetFalloff(.9)
    end
end

local function onremovelight(light)
    light._lantern._light = nil
end

local function stoptrackingowner(inst)
    if inst._owner ~= nil then
        inst:RemoveEventCallback("equip", inst._onownerequip, inst._owner)
        inst._owner = nil
    end
end

local function starttrackingowner(inst, owner)
    if owner ~= inst._owner then
        stoptrackingowner(inst)
        if owner ~= nil and owner.components.inventory ~= nil then
            inst._owner = owner
            inst:ListenForEvent("equip", inst._onownerequip, owner)
        end
    end
end

local function turnon(inst)
    if not inst.components.fueled:IsEmpty() then
        inst.components.fueled:StartConsuming()

        local owner = inst.components.inventoryitem.owner

        if inst._light == nil then
            inst._light = SpawnPrefab("lanternlight")
            inst._light._lantern = inst
            inst:ListenForEvent("onremove", onremovelight, inst._light)
            fuelupdate(inst)
            PlayTurnOnSound(inst)
        end
        inst._light.entity:SetParent((owner or inst).entity)

        if inst.machineanim then
            inst.AnimState:PlayAnimation(inst.machineanim)
        end

        if owner ~= nil and inst.components.equippable and inst.components.equippable:IsEquipped() then
            owner.AnimState:Show("LANTERN_OVERLAY")
        end

        if inst.components.machine then
            inst.components.machine.ison = true
        end
    end
end

local function turnoff(inst)
    stoptrackingowner(inst)

    inst.components.fueled:StopConsuming()

    if inst._light ~= nil then
        inst._light:Remove()
        PlayTurnOffSound(inst)
    end

    inst.AnimState:PlayAnimation(inst.anim)

    if inst.components.equippable and inst.components.equippable:IsEquipped() then
        inst.components.inventoryitem.owner.AnimState:Hide("LANTERN_OVERLAY")
    end

    if inst.components.machine then
        inst.components.machine.ison = false
    end

    local boat = inst.components.shipwreckedboatparts:GetBoat()
    if boat then
        boat.AnimState:OverrideSymbol("swap_lantern", inst.symbol_build, FunctionOrValue(inst.symbol, inst))
    end
end

local function OnRemove(inst)
    if inst._light ~= nil then
        inst._light:Remove()
    end
    if inst._soundtask ~= nil then
        inst._soundtask:Cancel()
    end
end

local function ondropped(inst)
    if inst.components.machine then
        turnoff(inst)
        turnon(inst)
    end
end

local function ontakefuel(inst)
    if inst.components.equippable and inst.components.equippable:IsEquipped() then
        turnon(inst)
    end
end

local function OnBoatEquipped(inst, data)
    turnon(inst)
    data.owner.AnimState:OverrideSymbol("swap_lantern", inst.symbol_build, FunctionOrValue(inst.symbol, inst))
    local boatfx = data.owner.components.shipwreckedboat.boatfx
    if boatfx then
        boatfx.AnimState:OverrideSymbol("swap_lantern", inst.symbol_build, FunctionOrValue(inst.symbol, inst))
    end
end

local function OnBoatUnEquipped(inst, data)
    turnoff(inst)

    data.owner.AnimState:ClearOverrideSymbol("swap_lantern")
    local boatfx = data.owner.components.shipwreckedboat.boatfx
    if boatfx then
        boatfx.AnimState:ClearOverrideSymbol("swap_lantern")
    end
end

---fn
---@param bank string
---@param build string
---@param anim string
---@param symbol_build string
---@param symbol string|function
---@param fuelvalue number
---@param data table|nil machineanim：是否可以右键打开，右键打开动画
local function common(bank, build, anim, symbol_build, symbol, fuelvalue, data)
    data = data or {}

    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.anim = anim
    inst.symbol_build = symbol_build
    inst.symbol = symbol

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation(anim)

    inst:AddTag("boatlight")
    inst:AddTag("light")
    inst:AddTag("tarlamp")
    inst:AddTag("shipwrecked_boat_head")

    MakeInventoryFloatable(inst, "med", 0.2, 0.65)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/volcanoinventory.xml"
    inst.components.inventoryitem:SetOnDroppedFn(ondropped)
    inst.components.inventoryitem:SetOnPutInInventoryFn(turnoff)

    inst:AddComponent("fueled")

    if data.machineanim then
        inst.machineanim = data.machineanim
        inst:AddComponent("machine")
        inst.components.machine.turnonfn = turnon
        inst.components.machine.turnofffn = turnoff
        inst.components.machine.cooldowntime = 0
    end

    inst.components.fueled.fueltype = FUELTYPE.TAR
    inst.components.fueled:InitializeFuelLevel(fuelvalue)
    inst.components.fueled:SetDepletedFn(turnoff)
    inst.components.fueled:SetUpdateFn(fuelupdate)
    inst.components.fueled:SetTakeFuelFn(ontakefuel)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
    inst.components.fueled.accepting = true

    inst._light = nil

    MakeHauntableLaunch(inst)

    inst:AddComponent("shipwreckedboatparts")

    inst.OnRemoveEntity = OnRemove

    inst._onownerequip = function(owner, data)
        if data.item ~= inst and
            (data.eslot == EQUIPSLOTS.HANDS or
                (data.eslot == EQUIPSLOTS.BODY and data.item:HasTag("heavy"))
            ) then
            turnoff(inst)
        end
    end

    inst:ListenForEvent("boat_equipped", OnBoatEquipped)
    inst:ListenForEvent("boat_unequipped", OnBoatUnEquipped)

    return inst
end

----------------------------------------------------------------------------------------------------

local tarlamp_assets =
{
    Asset("ANIM", "anim/tarlamp.zip"),
    Asset("ANIM", "anim/swap_tarlamp.zip"),
    Asset("ANIM", "anim/swap_tarlamp_boat.zip"),
}

local tarlamp_prefabs =
{
    "lanternlight",
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_tarlamp", "swap_lantern")
    owner.AnimState:OverrideSymbol("lantern_overlay", "swap_tarlamp", "lantern_overlay")

    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if inst.components.fueled:IsEmpty() then
        owner.AnimState:Hide("LANTERN_OVERLAY")
    else
        owner.AnimState:Show("LANTERN_OVERLAY")
        turnon(inst)
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("lantern_overlay")
    owner.AnimState:Hide("LANTERN_OVERLAY")

    if inst.components.machine.ison then
        starttrackingowner(inst, owner)
    end
end

local function onequiptomodel(inst, owner, from_ground)
    if inst.components.machine.ison then
        starttrackingowner(inst, owner)
    end

    turnoff(inst)
end

local function OnAttack(attacker, target)
    if target.components.burnable then
        if math.random() < TUNING.LIGHTER_ATTACK_IGNITE_PERCENT * target.components.burnable.flammability then
            target.components.burnable:Ignite()
        end
    end
end

local function GetLampSymbol(inst)
    return ((inst.components.machine and not inst.components.machine.ison)
            or inst.components.fueled:IsEmpty()) and "swap_lantern_off"
        or "swap_lantern"
end

-- 用完消失
local function OnTarLampDepleted(inst)
    turnoff(inst)

    local boat = inst.components.shipwreckedboatparts:GetBoat()
    if boat then
        boat.AnimState:ClearOverrideSymbol("swap_lantern")
    end

    ReplacePrefab("ash").components.inventoryitem:OnDropped()
end

local function tarlamp_fn()
    local inst = common("tarlamp", "tarlamp", "idle_off", "swap_tarlamp_boat", GetLampSymbol, TUNING.TORCH_FUEL, {
        machineanim = "idle_on",
    })

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable:SetOnEquipToModel(onequiptomodel)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.LIGHTER_DAMAGE)
    inst.components.weapon:SetAttackCallback(OnAttack)

    inst.components.fueled:SetDepletedFn(OnTarLampDepleted)
end

----------------------------------------------------------------------------------------------------
local boat_lantern_assets = {
    Asset("ANIM", "anim/swap_lantern_boat.zip"),
    Asset("INV_IMAGE", "boat_lantern_off"),
}

local boat_lantern_prefabs = {
    "lanternlight",
}

local function boat_lantern_fn()
    return common("lantern_boat", "swap_lantern_boat", "idle_water", "swap_lantern_boat", GetLampSymbol,
        TUNING.BOAT_LANTERN_LIGHTTIME)
end

----------------------------------------------------------------------------------------------------
local boat_torch_assets = {
    Asset("ANIM", "anim/swap_torch_boat.zip"),
    Asset("INV_IMAGE", "boat_torch_off"),
}

local boat_torch_prefabs = {
    "lanternlight",
}

local function boat_torch_fn()
    return common("torch_boat", "swap_torch_boat", "idle", "swap_torch_boat", GetLampSymbol,
        TUNING.BOAT_TORCH_LIGHTTIME)
end

return Prefab("tarlamp", tarlamp_fn, tarlamp_assets, tarlamp_prefabs),
    Prefab("boat_lantern", boat_lantern_fn, boat_lantern_assets, boat_lantern_prefabs),
    Prefab("boat_torch", boat_torch_fn, boat_torch_assets, boat_torch_prefabs)
