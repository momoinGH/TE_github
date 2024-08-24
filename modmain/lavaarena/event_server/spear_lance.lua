local assets =
{
    Asset("ANIM", "anim/spear_lance.zip"),
    Asset("ANIM", "anim/swap_spear_lance.zip"),
}

local function Spell(inst, doer, pos)
    doer:PushEvent("combat_superjump", { targetpos = pos, weapon = inst })
end

-- 生成火焰路径
local function OnLeapt(inst, doer, startingpos, targetpos)
    SpawnAt("superjump_fx", targetpos)
    inst.components.rechargeable:Discharge(12)
end

local function master_postinit(inst)
    InitLavaarenaWeapon(inst, "swap_spear_lance", 30, "weaponsparks")

    inst.components.aoespell:SetSpellFn(Spell)

    inst:AddComponent("aoeweapon_leap")
    inst.components.aoeweapon_leap:SetStimuli("explosive")
    inst.components.aoeweapon_leap:SetOnLeaptFn(OnLeapt)
end

add_event_server_data("lavaarena", "prefabs/spear_lance", {
    master_postinit = master_postinit,
}, assets)
