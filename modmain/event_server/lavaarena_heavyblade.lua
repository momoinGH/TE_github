local function Spell(inst, doer, pos)
    inst.components.parryweapon:EnterParryState(doer, doer:GetAngleToPoint(pos), 6)
    inst.components.rechargeable:Discharge(12)
end

local function OnParry(inst, doer, attacker, damage)
    doer:ShakeCamera(CAMERASHAKE.SIDE, 0.1, 0.03, 0.3)

    if inst.components.rechargeable:GetPercent() < TUNING.WATHGRITHR_SHIELD_COOLDOWN_ONPARRY_REDUCTION then
        inst.components.rechargeable:SetPercent(TUNING.WATHGRITHR_SHIELD_COOLDOWN_ONPARRY_REDUCTION)
    end
end

local function OnHelmSplit(inst)
    SpawnPrefab("superjump_fx"):SetTarget(inst)
end

local function master_postinit(inst)
    InitLavaarenaWeapon(inst, "swap_sword_buster",  30, "weaponsparks")

    inst.components.aoespell:SetSpellFn(Spell)

    inst:AddComponent("parryweapon")
    inst.components.parryweapon:SetParryArc(TUNING.WATHGRITHR_SHIELD_PARRY_ARC)
    inst.components.parryweapon:SetOnParryFn(OnParry)

    inst:AddComponent("helmsplitter")
    inst.components.helmsplitter:SetOnHelmSplitFn(OnHelmSplit)
    inst.components.helmsplitter.damage = 100
end

add_event_server_data("lavaarena", "prefabs/lavaarena_heavyblade", {
    master_postinit = master_postinit,
})
