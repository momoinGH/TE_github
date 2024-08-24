local Constructor = require("tropical_utils/constructor")

local assets = {}

local hats = {
    feathercrown = {
        walkspeedmult = 1.2,
        opentop = true
    },
    lightdamager = {
        attack_mult = { [DAMAGETYPES.PHYSICAL] = 1.1 },
    },
    recharger = {
        cooldown_mult = -0.1,
        opentop = true
    },
    healingflower = {
        -- +25% 在生命蓓蕾领域内生命值的回复量
        opentop = true
    },
    tiaraflowerpetals = {
        -- +20% 在生命蓓蕾领域内生命值的回复量
        opentop = true
    },

    strongdamager = {
        attack_mult = { [DAMAGETYPES.PHYSICAL] = 1.15 },
    },
    crowndamager = {
        walkspeedmult = 1.1,
        attack_mult = { [DAMAGETYPES.PHYSICAL] = 1.15 },
        cooldown_mult = -0.1,
    },
    healinggarland = {
        walkspeedmult = 1.1,
        cooldown_mult = -0.1,
        opentop = true
    },
    eyecirclet = {
        magic_attack_mult = 1.25,
        attack_mult = { [DAMAGETYPES.MAGIC] = 1.25 },
        cooldown_mult = -0.1,
        walkspeedmult = 1.1,
        opentop = true
    }
}

for name, _ in pairs(hats) do
    table.insert(assets, Asset("ANIM", "anim/hat_" .. name .. ".zip"))
end

----------------------------------------------------------------------------------------------------

local function OnEqip(inst, owner)
    Constructor.OnHatEquip(inst, owner, inst._baseBuild)
end

local function OnEqip2(inst, owner)
    Constructor.OnHatEquip(inst, owner, inst._baseBuild)
    Constructor.OpenTopOnEquip(owner)
end

local function OnUneqip(inst, owner)
    Constructor.OnHatUnequip(inst, owner)
end

local function master_postinit(inst, name, build, symbol)
    local data = hats[name]

    inst._baseBuild = build

    inst:AddComponent("inventoryitem")
    inst:AddComponent("inspectable")
    inst:AddComponent("tradable")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(data.opentop and OnEqip2 or OnEqip)
    inst.components.equippable:SetOnUnequip(OnUneqip)
    if data.walkspeedmult then
        inst.components.equippable.walkspeedmult = 1.1
    end

    inst:AddComponent("lavaarena_equip")
    inst.components.lavaarena_equip.cooldown_mult = data.cooldown_mult
    inst.components.lavaarena_equip.attack_mult = data.attack_mult
    inst.components.lavaarena_equip.max_health = data.max_health

    MakeHauntableLaunch(inst)
end

add_event_server_data("lavaarena", "prefabs/hats_lavaarena", {
    master_postinit = master_postinit
}, assets)
