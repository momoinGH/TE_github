local function Spell(inst, doer, pos)
    for i = 1, 6 do
        inst:DoTaskInTime(0.08 * i, function()
            if doer:IsValid() then
                local off = math.random() * 2.5 - 1.25;
                local offset = Vector3(math.random(), 0, math.random()):Normalize() * off;
                local alt = SpawnPrefab("blowdart_lava_projectile_alt")
                alt.Transform:SetPosition((inst:GetPosition() + offset):Get())
                alt.components.complexprojectile:Launch(pos + offset, doer, inst)
                doer.SoundEmitter:PlaySound("dontstarve/common/lava_arena/blow_dart_spread")
            end
        end)
    end;
    inst.components.rechargeable:Discharge(18)
end

local function OnProjectileLaunched(inst, attacker)
    if attacker.SoundEmitter then
        attacker.SoundEmitter:PlaySound("dontstarve/common/lava_arena/blow_dart")
    end
end

local function blowdart_postinit(inst)
    InitLavaarenaWeapon(inst, "swap_blowdart_lava",30)

    inst.components.aoespell:SetSpellFn(Spell)

    inst.components.weapon:SetRange(10, 20)
    inst.components.weapon:SetProjectile("blowdart_lava_projectile")
    inst.components.weapon:SetOnProjectileLaunched(OnProjectileLaunched)
end

----------------------------------------------------------------------------------------------------
local function OnHit(inst, attacker, target)
    if target then
        if inst.prefab == "blowdart_lava_projectile_alt" then
            if attacker and attacker.components.combat and attacker.components.combat:CanTarget(target) then
                target.components.combat:GetAttacked(attacker, 20, inst.components.complexprojectile.owningweapon, nil, { lavaarena_strong = 1 })
            end
        end

        SpawnPrefab("weaponsparks_piercing"):Setup(attacker, target, inst)
    end

    inst:Remove()
end

local ATTACK_MUST_TAGS = { "_combat" }
local ATTACK_CANT_TAGS = { "player", "companion" }
local function OnUpdate(inst)
    local dt = 0.1
    local self = inst.components.complexprojectile

    if self.attacker:IsValid() and self.attacker.components.combat then
        local pos = inst:GetPosition()
        for _, v in ipairs(TheSim:FindEntities(pos.x, pos.y, pos.z, 3, ATTACK_MUST_TAGS, ATTACK_CANT_TAGS)) do
            if v.entity:IsVisible() and self.attacker.components.combat:CanTarget(v) then
                if v:GetPhysicsRadius(0) + 1 > distsq(pos, v:GetPosition()) then
                    self:Hit(v)
                    return true
                end
            end
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

add_event_server_data("lavaarena", "prefabs/blowdart_lava", {
    blowdart_postinit = blowdart_postinit,
    projectile_postinit = projectile_postinit
})
