local assets =
{
    Asset("ANIM", "anim/healingstaff.zip"),
    Asset("ANIM", "anim/swap_healingstaff.zip"),
    Asset("ANIM", "anim/lavaarena_heal_projectile.zip"),
}

local function Spell(inst, doer, pos)
    SpawnAt("lavaarena_healblooms", pos)
    inst.components.rechargeable:Discharge(24)
end

local function OnProjectileLaunch(inst, attacker, target)
    inst.SoundEmitter:PlaySound("dontstarve/common/lava_arena/heal_staff")

    local off = (target:GetPosition() - attacker:GetPosition()):GetNormalized() * 1.2;
    local fx = SpawnPrefab("blossom_hit_fx")
    fx.Transform:SetPosition((attacker:GetPosition() + off):Get())
    fx.AnimState:SetScale(0.8, 0.8)
end

local function healingstaff_postinit(inst)
    InitLavaarenaWeapon(inst, "swap_healingstaff", 10)

    inst.castsound = "dontstarve/common/lava_arena/spell/heal"

    inst.components.aoespell:SetSpellFn(Spell)

    inst.components.weapon:SetRange(10, 20)
    inst.components.weapon:SetProjectile("blossom_projectile")
    inst.components.weapon:SetOnProjectileLaunch(OnProjectileLaunch)

    inst.components.lavaarena_equip.damagetype = DAMAGETYPES.MAGIC
end

add_event_server_data("lavaarena", "prefabs/healingstaff", {
    healingstaff_postinit = healingstaff_postinit,
    -- castfx_postinit = castfx_postinit --爆炸特效已经有blossom_hit_fx了，一样的动画
}, assets)
