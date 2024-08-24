local assets =
{
    Asset("ANIM", "anim/lavaarena_firebomb.zip"),
    Asset("ANIM", "anim/swap_lavaarena_firebomb.zip"),
    Asset("ANIM", "anim/lavaarena_firebomb.zip"),
    Asset("ANIM", "anim/sparks_molotov.zip"),
}

local function ClearCharge(inst)
    inst.charge = 0
    if inst.chargetask then
        inst.chargetask:Cancel()
        inst.chargetask = nil
    end
    if inst.charge_fx then
        inst.charge_fx:Remove()
        inst.charge_fx = nil
    end
end;

local function ChangeLevel(inst, level)
    if not inst.charge_fx then
        inst.charge_fx = SpawnPrefab("lavaarena_firebomb_sparks")
        inst.charge_fx.entity:AddFollower()
        inst.charge_fx.Follower:FollowSymbol(inst.components.inventoryitem.owner.GUID, "swap_object", 3, 2, 0)
    end
    inst.charge_fx:SetSparkLevel(level)
end;


local function Explode(inst, attacker, target)
    SpawnPrefab("firehit").Transform:SetPosition(target.Transform:GetWorldPosition())

    if attacker and attacker.components.combat and target and attacker.components.combat:CanTarget(target) then
        target.components.combat:GetAttacked(attacker, 75, inst)
    end

    ClearCharge(inst)
end;

local function OnAttack(inst, attacker, target)
    inst.charge = inst.charge + 1
    if inst.chargetask then
        inst.chargetask:Cancel()
        inst.chargetask = nil
    end;
    inst.chargetask = inst:DoTaskInTime(5, ClearCharge)

    if inst.charge >= 13 then
        Explode(inst, attacker, target)
    elseif inst.charge >= 12 then
        ChangeLevel(inst, 3)
    elseif inst.charge >= 10 then
        ChangeLevel(inst, 2)
    elseif inst.charge >= 7 then
        ChangeLevel(inst, 1)
    end
end

local function Spell(inst, doer, pos)
    local pro = SpawnPrefab("lavaarena_firebomb_projectile")
    pro.Transform:SetPosition(inst.Transform:GetWorldPosition())
    pro.components.complexprojectile:Launch(pos, doer, inst)
    pro.owner = doer

    ClearCharge(inst)
    inst.components.rechargeable:Discharge(6)
end

local function firebomb_postinit(inst)
    InitLavaarenaWeapon(inst, "swap_lavaarena_firebomb", 15)

    inst.charge = 0 --连击次数

    inst.components.weapon:SetOnAttack(OnAttack)

    inst.components.aoespell:SetSpellFn(Spell)
end

----------------------------------------------------------------------------------------------------
local function OnLaunch(inst)
    inst:AddTag("NOCLICK")
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_fuse_LP", "hiss")
    inst.Physics:SetMass(1)
    inst.Physics:SetCapsule(0.2, 0.2)
    inst.Physics:SetFriction(0)
    inst.Physics:SetDamping(0)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.ITEMS)
end

local ATTACK_MUST_TAGS = { "_combat" }
local ATTACK_CANT_TAGS = { "player", "companion" }
local function OnHit(inst)
    inst.SoundEmitter:KillSound("hiss")
    SpawnPrefab("lavaarena_firebomb_explosion").Transform:SetPosition(inst.Transform:GetWorldPosition())

    if not inst.owner or not inst.owner:IsValid() or not inst.owner.components.combat then
        return
    end

    for _, v in ipairs(GetPlayerAttackTarget(inst.owner, 8, nil, inst:GetPosition(), true)) do
        v.components.combat:GetAttacked(inst.owner, 75, inst.components.complexprojectile.owningweapon)
    end

    inst:Remove()
end

local function projectile_postinit(inst)
    inst.owner = nil

    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetHorizontalSpeed(20)
    inst.components.complexprojectile:SetGravity(-30)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(.25, 1, 0))
    inst.components.complexprojectile:SetOnLaunch(OnLaunch)
    inst.components.complexprojectile:SetOnHit(OnHit)

    inst.persists = false
end

----------------------------------------------------------------------------------------------------

local function explosion_postinit(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo")

    inst.persists = false
    inst:ListenForEvent("animover", inst.Remove)
end

add_event_server_data("lavaarena", "prefabs/lavaarena_firebomb", {
    firebomb_postinit = firebomb_postinit,
    projectile_postinit = projectile_postinit,
    explosion_postinit = explosion_postinit,
    -- procfx_postinit = explosion_postinit --和爆炸一个动画，也用不着
}, assets)
