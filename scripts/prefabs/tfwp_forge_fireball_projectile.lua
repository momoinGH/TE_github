local a = { Asset("ANIM", "anim/fireball_2_fx.zip"), Asset("ANIM", "anim/deer_fire_charge.zip") }
local b = { Asset("ANIM", "anim/lavaarena_heal_projectile.zip") }

local function c(d, e, f)
    local g = SpawnPrefab("forge_fireball_hit_fx").Transform:SetPosition(d.Transform:GetWorldPosition())
    d:Remove()
    g:ListenForEvent("animover", g.Remove)
end;

local function h(d, e, f)
    local g = SpawnPrefab("fireball_cast_fx").Transform:SetPosition(d.Transform:GetWorldPosition())
    g:ListenForEvent("animover", g.Remove)
end;

local function i(j, k, light, addColour, multColour)
    local inst = CreateEntity()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetCanSleep(false)

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)

    inst.Physics:ClearCollisionMask()

    inst.AnimState:SetBank(j)
    inst.AnimState:SetBuild(k)
    inst.AnimState:PlayAnimation("disappear")
    if addColour ~= nil then
        inst.AnimState:SetAddColour(unpack(addColour))
    end;
    if multColour ~= nil then
        inst.AnimState:SetMultColour(unpack(multColour))
    end;
    if light > 0 then
        inst.AnimState:SetLightOverride(light)
    end;
    inst.AnimState:SetFinalOffset(-1)

    inst:ListenForEvent("animover", inst.Remove)

    inst.persists = false

    return inst
end;
local function fn(d, j, k, p, l, m, n, q, r)
    local s, t, u = d.Transform:GetWorldPosition()
    for v, w in pairs(r) do v:ForceFacePoint(s, t, u) end;
    if d.entity:IsVisible() then
        local v = i(j, k, l, m, n)
        local rotation = d.Transform:GetRotation()
        v.Transform:SetRotation(rotation)
        rotation = rotation * DEGREES;
        local y = math.random() * TWOPI;
        local z = math.random() * .2 + .2;
        local A = math.cos(y) * z;
        local B = math.sin(y) * z;
        v.Transform:SetPosition(s + math.sin(rotation) * A, t + B, u + math.cos(rotation) * A)
        v.Physics:SetMotorVel(p * (.2 + math.random() * .3), 0, 0)
        r[v] = true;
        d:ListenForEvent("onremove", function(v) r[v] = nil end, v)
        v:ListenForEvent("onremove", function(d)
            v.Transform:SetRotation(v.Transform:GetRotation() + math.random() * 30 - 15)
        end, d)
    end
end;

local function MakeProjectile(D, bank, build, speed, light, addColour, multColour, q)
    local assets = { Asset("ANIM", "anim/" .. build .. ".zip") }
    local F = q ~= nil and { q } or nil;
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        RemovePhysicsColliders(inst)

        inst.AnimState:SetBank(bank)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("idle_loop", true)

        if addColour ~= nil then
            inst.AnimState:SetAddColour(unpack(addColour))
        end;
        if multColour ~= nil then
            inst.AnimState:SetMultColour(unpack(multColour))
        end;
        if light > 0 then
            inst.AnimState:SetLightOverride(light)
        end;
        inst.AnimState:SetFinalOffset(-1)

        inst:AddTag("projectile")

        if not TheNet:IsDedicated() then
            inst:DoPeriodicTask(0, fn, nil, bank, build, speed, light, addColour, multColour, q, {})
        end;

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end;

        inst.persists = false;

        inst:AddComponent("projectile")
        inst.components.projectile:SetSpeed(speed)
        inst.components.projectile:SetHoming(true)
        inst.components.projectile:SetHitDist(0.5)
        inst.components.projectile.onhit = function(inst, e, f)
            SpawnPrefab(q).Transform:SetPosition(inst.Transform:GetWorldPosition())
            inst:Remove()
        end;

        inst.components.projectile:SetOnMissFn(inst.Remove)
        inst.components.projectile:SetStimuli("fire")

        return inst
    end;
    return Prefab(D, fn, assets, F)
end;
local function H()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("fireball_fx")
    inst.AnimState:SetBuild("deer_fire_charge")
    inst.AnimState:PlayAnimation("blast")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(1)
    inst.AnimState:SetFinalOffset(-1)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    inst.persists = false;

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end;
local function hit_fx_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("lavaarena_heal_projectile")
    inst.AnimState:SetBuild("lavaarena_heal_projectile")
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:SetAddColour(0, .1, .05, 0)
    inst.AnimState:SetFinalOffset(-1)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    inst.persists = false;

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

return
    MakeProjectile("forge_fireball_projectile", "fireball_fx", "fireball_2_fx", 15, 1, nil, nil, "forge_fireball_hit_fx"),
    MakeProjectile("forge_blossom_projectile", "lavaarena_heal_projectile", "lavaarena_heal_projectile", 15, 0,
        { 0, .2, .1, 0 }, nil,
        "forge_blossom_hit_fx"),
    Prefab("forge_fireball_hit_fx", H, a),
    Prefab("forge_blossom_hit_fx", hit_fx_fn, b),
    MakeProjectile("forge_fireball_projectile_fast", "fireball_fx", "fireball_2_fx", 30, 1, nil, nil,
        "forge_fireball_hit_fx")
