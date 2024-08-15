local assets = {
    Asset("ANIM", "anim/blowdart_lava2.zip"),
    Asset("ANIM", "anim/swap_blowdart_lava2.zip") }
local projectile_assets = { Asset("ANIM", "anim/lavaarena_blowdart_attacks.zip") }
local prefabs = { "moltendarts_projectile", "moltendarts_projectile_explosive", "reticulelong", "reticulelongping" }
local projectile_prefabs = { "weaponsparks_piercing" }
local explosive_prefabs = { "explosivehit" }
local f = 4 * FRAMES;

local function g(h, i)
    i.AnimState:OverrideSymbol("swap_object", "swap_blowdart_lava2", "swap_blowdart_lava2")
    i.AnimState:Show("ARM_carry")
    i.AnimState:Hide("ARM_normal")
end;
local function j(h, i)
    i.AnimState:Hide("ARM_carry")
    i.AnimState:Show("ARM_normal")
end;
local function k()
    return Vector3(ThePlayer.entity:LocalToWorldSpace(6.5, 0, 0))
end;
local function l(h, m)
    if m ~= nil then
        local n, o, p = h.Transform:GetWorldPosition()
        local q = m.x - n; local r = m.z - p; local s = q * q + r * r; if s <= 0 then
            return h.components.reticule
                .targetpos
        end; s = 6.5 / math.sqrt(s)
        return Vector3(n + q * s, 0, p + r * s)
    end
end;
local function t(h, u, v, w, x, y)
    local n, o, p = h.Transform:GetWorldPosition()
    v.Transform:SetPosition(n, 0, p)
    local z = -math.atan2(u.z - p, u.x - n) / DEGREES; if w and y ~= nil then
        local A = v.Transform:GetRotation()
        local B = z - A; z = Lerp(B > 180 and A + 360 or B < -180 and A - 360 or A, z, y * x)
    end;
    v.Transform:SetRotation(z)
end;
local function C(h, D, u)
    local E = SpawnPrefab("moltendarts_projectile_explosive")
    E.Transform:SetPosition(h:GetPosition():Get())
    E.components.aimedprojectile:Throw(h, D, u)
    E.components.aimedprojectile:DelayVisibility(h.projectiledelay)
    D.SoundEmitter:PlaySound("dontstarve/common/lava_arena/blow_dart")
    h.components.recarregavel:StartRecharge()
end;

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.nameoverride = "blowdart_lava2"
    inst.AnimState:SetBank("blowdart_lava2")
    inst.AnimState:SetBuild("blowdart_lava2")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("blowdart")
    inst:AddTag("rechargeable")
    inst:AddTag("sharp")

    inst:AddComponent("aoetargeting")
    inst.components.aoetargeting:SetAlwaysValid(true)
    inst.components.aoetargeting.reticule.reticuleprefab = "reticulelong"
    inst.components.aoetargeting.reticule.pingprefab = "reticulelongping"
    inst.components.aoetargeting.reticule.targetfn = k;
    inst.components.aoetargeting.reticule.mousetargetfn = l;
    inst.components.aoetargeting.reticule.updatepositionfn = t;
    inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
    inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
    inst.components.aoetargeting.reticule.ease = true; inst.components.aoetargeting.reticule.mouseenabled = true;

    inst.projectiledelay = f;

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end;

    inst:AddComponent("aoespell")
    inst.components.aoespell:SetSpellFn(C)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(g)
    inst.components.equippable:SetOnUnequip(j)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "blowdart_lava2"

    inst:AddComponent("recarregavel")
    inst.components.recarregavel:SetRechargeTime(TUNING.FORGE_ITEM_PACK.TFWP_DRAGON_DART.COOLDOWN)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.FORGE_ITEM_PACK.TFWP_DRAGON_DART.DAMAGE)
    inst.components.weapon:SetRange(10, 15)
    inst.components.weapon:SetProjectile("moltendarts_projectile")
    inst.components.weapon:SetDamageType(DAMAGETYPES.PHYSICAL)
    inst.components.weapon:SetAltAttack(TUNING.FORGE_ITEM_PACK.TFWP_DRAGON_DART.ALT_DAMAGE, { 10, 15 }, nil,
        DAMAGETYPES.PHYSICAL)

    return inst
end;
local G = 5;
local H = { ["tail_5_2"] = .15, ["tail_5_3"] = .15, ["tail_5_4"] = .2, ["tail_5_5"] = .8, ["tail_5_6"] = 1, ["tail_5_7"] = 1 }
local I = { ["tail_5_8"] = 1, ["tail_5_9"] = .5 }
local function J(K, suffix)
    local h = CreateEntity()
    h:AddTag("FX")
    h:AddTag("NOCLICK")
    h.entity:SetCanSleep(false)
    h.persists = false;
    h.entity:AddTransform()
    h.entity:AddAnimState()
    h.AnimState:SetBank("lavaarena_blowdart_attacks")
    h.AnimState:SetBuild("lavaarena_blowdart_attacks")
    h.AnimState:PlayAnimation(weighted_random_choice(K and I or H) .. suffix)
    h.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    if not K then
        h.AnimState:SetAddColour(1, 1, 0, 0)
    end; h:ListenForEvent("animover", h.Remove)
    h.OnLoad = h.Remove; return h
end;
local function M(inst, suffix)
    local N = not inst.entity:IsVisible() and 0 or inst._fade ~= nil and (G - inst._fade:value() + 1) / G or 1;
    if N > 0 then
        local O = J(inst.thintailcount > 0, suffix)
        O.Transform:SetPosition(inst.Transform:GetWorldPosition())
        O.Transform:SetRotation(inst.Transform:GetRotation())
        if N < 1 then O.AnimState:SetTime(N * O.AnimState:GetCurrentAnimationLength()) end;
        if inst.thintailcount > 0 then inst.thintailcount = inst.thintailcount - 1 end
    end
end;

local function OnHit(inst, i, Q, R)
    if not R then
        SpawnPrefab("weaponsparks_fx"):SetPiercing(inst, Q)
    else
        local fx = SpawnPrefab("explosivehit") --这个特效不会消失，而是留在地图上每次进入加载都会播放一次
        fx.Transform:SetPosition(inst:GetPosition():Get())
        fx.persists = false
        fx:DoTaskInTime(5, fx.Remove)
    end;
    inst:Remove()
end;

local function common(anim, suffix, fade)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("lavaarena_blowdart_attacks")
    inst.AnimState:SetBuild("lavaarena_blowdart_attacks")
    inst.AnimState:PlayAnimation(anim, true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetAddColour(1, 1, 0, 0)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst:AddTag("projectile")

    if fade then
        inst._fade = net_tinybyte(inst.GUID, "blowdart_lava2_projectile_explosive._fade")
    end;

    if not TheNet:IsDedicated() then
        inst.thintailcount = fade and math.random(3, 5) or math.random(2, 4)
        inst:DoPeriodicTask(0, M, nil, suffix)
    end;

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end;

    if not fade then
        inst:AddComponent("projectile")
        inst.components.projectile:SetSpeed(30)
        inst.components.projectile:SetRange(20)
        inst.components.projectile:SetOnHitFn(function(inst, V, Q) OnHit(inst, inst.components.projectile.owner, Q, fade) end)
        inst.components.projectile:SetOnMissFn(inst.Remove)
        inst.components.projectile:SetLaunchOffset(Vector3(-2, 1, 0))
    else
        inst:AddComponent("aimedprojectile")
        inst.components.aimedprojectile:SetSpeed(30)
        inst.components.aimedprojectile:SetRange(30)
        inst.components.aimedprojectile:SetStimuli("explosive")
        inst.components.aimedprojectile:SetOnHitFn(OnHit)
        inst.components.aimedprojectile:SetOnMissFn(inst.Remove)
        inst:DoTaskInTime(0, function(h)
            h.SoundEmitter:PlaySound("dontstarve/common/lava_arena/blow_dart")
        end)
    end;

    inst.persists = false

    return inst
end;

local function projectile_fn()
    return common("attack_4", "", false)
end;
local function explosive_fn()
    return common("attack_4_large", "_large", true)
end;
return CustomPrefab("tfwp_dragon_dart", fn, assets, prefabs, nil, "images/inventoryimages.xml", "blowdart_lava2.tex",
        TUNING.FORGE_ITEM_PACK.TFWP_DRAGON_DART, "swap_blowdart_lava2", "common_hand"),
    Prefab("moltendarts_projectile", projectile_fn, projectile_assets, projectile_prefabs),
    Prefab("moltendarts_projectile_explosive", explosive_fn, projectile_assets, explosive_prefabs)
