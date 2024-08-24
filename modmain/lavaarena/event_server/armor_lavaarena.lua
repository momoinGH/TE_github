local assets = {}

local armors = {
    ["lavaarena_armorlight"] =
    {
        build = "armor_light",
        armor = 0.5,
        cooldown_mult = -0.05
    },

    ["lavaarena_armorlightspeed"] =
    {
        build = "armor_lightspeed",
        armor = 0.6,
        walkspeedmult = 1.1
    },

    ["lavaarena_armormedium"] =
    {
        build = "armor_medium",
        armor = 0.75
    },

    ["lavaarena_armormediumdamager"] =
    {
        build = "armor_mediumdamager",
        armor = 0.75,
        attack_mult = { [DAMAGETYPES.PHYSICAL] = 1.1 },
    },

    ["lavaarena_armormediumrecharger"] =
    {
        build = "armor_mediumrecharger",
        armor = 0.75,
        cooldown_mult = -0.1
    },

    ["lavaarena_armorheavy"] =
    {
        build = "armor_heavy",
        armor = 0.85
    },

    ["lavaarena_armorextraheavy"] =
    {
        build = "armor_extraheavy",
        armor = 0.9,
        walkspeedmult = 0.85,
        heavyarmor = true

    },
    ["lavaarena_armor_hpextraheavy"] =
    {
        build = "armor_hpextraheavy",
        armor = 0.9,
        heavyarmor = true,
        max_health = 100
    },

    ["lavaarena_armor_hppetmastery"] =
    {
        build = "armor_hppetmastery",
        armor = 0.8,
        max_health = 75,
        -- 强化随从
    },

    ["lavaarena_armor_hprecharger"] =
    {
        build = "armor_hprecharger",
        armor = 0.8,
        cooldown_mult = -0.15,
        max_health = 50
    },

    ["lavaarena_armor_hpdamager"] =
    {
        build = "armor_hpdamager",
        armor = 0.8,
        attack_mult = { [DAMAGETYPES.PHYSICAL] = 1.2 },
        max_health = 50
    },
}

for _, data in pairs(armors) do
    table.insert(assets, Asset("ANIM", "anim/" .. data.build .. ".zip"))
end

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", inst._baseBuild, "swap_body")
end

local function OnUnequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function master_postinit(inst, name, build)
    local data = armors[name] or {}

    inst._baseBuild = build

    if data.heavyarmor then
        inst:AddTag("heavyarmor")
    end

    inst:AddComponent("inventoryitem")
    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    if data.walkspeedmult then
        inst.components.equippable.walkspeedmult = 1.1
    end

    inst:AddComponent("lavaarena_equip")
    inst.components.lavaarena_equip.cooldown_mult = data.cooldown_mult
    inst.components.lavaarena_equip.attack_mult = data.attack_mult
    inst.components.lavaarena_equip.max_health = data.max_health

    if data.armor then
        inst:AddComponent("armor")
        inst.components.armor:InitCondition(1000, data.armor)
        inst.components.armor.conditionlossmultipliers:SetModifier(inst, 0, "armor_lavaarena") --无限耐久
    end

    MakeHauntableLaunch(inst)
end


add_event_server_data("lavaarena", "prefabs/armor_lavaarena", {
    master_postinit = master_postinit
}, assets)
