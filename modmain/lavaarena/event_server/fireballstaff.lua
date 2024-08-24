local assets =
{
    Asset("ANIM", "anim/fireballstaff.zip"),
    Asset("ANIM", "anim/swap_fireballstaff.zip"),
    Asset("ANIM", "anim/fireball_2_fx.zip"),
    Asset("ANIM", "anim/deer_fire_charge.zip"),
}

local function Spell(inst, doer, pos)
    local fx = SpawnPrefab("lavaarena_meteor")
    fx.Transform:SetPosition(pos:Get())
    fx.owner = doer

    inst.components.rechargeable:Discharge(24)
end

local function OnProjectileLaunch(inst, attacker, target)
    local off = (target:GetPosition() - attacker:GetPosition()):GetNormalized() * 1.2;
    local fx = SpawnPrefab("fireball_hit_fx")
    fx.Transform:SetPosition((attacker:GetPosition() + off):Get())
    fx.AnimState:SetScale(0.8, 0.8)
end

local function fireballstaff_postinit(inst)
    InitLavaarenaWeapon(inst, "swap_fireballstaff", 25)

    inst.components.aoespell:SetSpellFn(Spell)

    inst.components.weapon:SetRange(10, 20)
    inst.components.weapon:SetProjectile("fireball_projectile")
    inst.components.weapon:SetOnProjectileLaunch(OnProjectileLaunch)
    inst.components.weapon:SetDamageType(DAMAGETYPES.MAGIC)

    inst.components.lavaarena_equip.damagetype = DAMAGETYPES.MAGIC
end

add_event_server_data("lavaarena", "prefabs/fireballstaff", {
    fireballstaff_postinit = fireballstaff_postinit,
    -- castfx_postinit = castfx_postinit
}, assets)
