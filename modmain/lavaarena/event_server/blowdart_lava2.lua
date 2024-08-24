local assets =
{
    Asset("ANIM", "anim/blowdart_lava2.zip"),
    Asset("ANIM", "anim/swap_blowdart_lava2.zip"),
    Asset("ANIM", "anim/lavaarena_blowdart_attacks.zip"),
}

local function Spell(inst, doer, pos)
    inst:DoTaskInTime(4 * FRAMES, function(inst)
        if doer:IsValid() then
            local fx = SpawnPrefab("blowdart_lava2_projectile_explosive")
            fx.Transform:SetPosition(doer.Transform:GetWorldPosition())
            fx.components.complexprojectile:Launch(pos, doer, inst)
        end
    end)
    if doer.SoundEmitter then
        doer.SoundEmitter:PlaySound("dontstarve/common/lava_arena/blow_dart")
    end
    inst.components.rechargeable:Discharge(18)
end

local function OnProjectileLaunched(inst, attacker)
    if attacker.SoundEmitter then
        attacker.SoundEmitter:PlaySound("dontstarve/common/lava_arena/blow_dart")
    end
end

local function blowdart_postinit(inst)
    InitLavaarenaWeapon(inst, "swap_blowdart_lava2", 25)

    inst.components.aoespell:SetSpellFn(Spell)

    inst.components.weapon:SetRange(10, 20)
    inst.components.weapon:SetProjectile("blowdart_lava2_projectile")
    inst.components.weapon:SetOnProjectileLaunched(OnProjectileLaunched)
end

----------------------------------------------------------------------------------------------------
local function OnHit(inst, attacker, target)
    if target then
        if inst.prefab == "blowdart_lava2_projectile_explosive" then
            if attacker and attacker.components.combat and attacker.components.combat:CanTarget(target) then
                target.components.combat:GetAttacked(attacker, 50, inst.components.complexprojectile.owningweapon, nil, { lavaarena_fire = 1 })
            end
            local fx = SpawnPrefab("explosivehit") --这个特效不会消失，而是留在地图上每次进入加载都会播放一次
            fx.Transform:SetPosition(target:GetPosition():Get())
            fx.persists = false
            fx:DoTaskInTime(5, fx.Remove)
        else
            SpawnPrefab("weaponsparks_piercing"):Setup(attacker, target, inst)
        end
    end

    inst:Remove()
end

local function OnUpdate(inst)
    local dt = 0.1
    local self = inst.components.complexprojectile

    if self.attacker:IsValid() and self.attacker.components.combat then
        for _, v in ipairs(GetPlayerAttackTarget(self.attacker, 3,
            function(v) return v:GetPhysicsRadius(0) + 1 > distsq(pos, v:GetPosition()) end, pos, true)) do
            self:Hit(v)
            return true
        end
    end

    inst.Physics:SetMotorVel(self.velocity:Get())
    self.velocity.x = self.velocity.x + (self.gravity * dt)
    if self.velocity.x < 0 then
        self:Hit() --落空
    end

    return true
end

local function projectile_postinit(inst, alt)
    if alt then
        inst:AddComponent("complexprojectile")
        inst.components.complexprojectile:SetHorizontalSpeed(35)
        inst.components.complexprojectile.usehigharc = false
        -- inst.components.complexprojectile:SetGravity(-5) --这里作为水平方向的加速度
        inst.components.complexprojectile:SetOnHit(OnHit)
        inst.components.complexprojectile:SetOnUpdate(OnUpdate)
    else
        inst:AddComponent("projectile")
        inst.components.projectile:SetSpeed(35)
        inst.components.projectile:SetRange(20)
        inst.components.projectile:SetHitDist(0.5)
        inst.components.projectile:SetOnHitFn(OnHit)
        inst.components.projectile:SetOnMissFn(inst.Remove)
        -- inst.components.projectile:SetOnThrownFn(OnThrown)
        inst.components.projectile:SetLaunchOffset(Vector3(-2, 1, 0))
    end

    inst.persists = false
end

add_event_server_data("lavaarena", "prefabs/blowdart_lava2", {
    blowdart_postinit = blowdart_postinit,
    projectile_postinit = projectile_postinit
}, assets)
