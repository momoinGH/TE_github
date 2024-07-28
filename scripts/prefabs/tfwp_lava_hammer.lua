local a = {
    Asset("ANIM", "anim/hammer_mjolnir.zip"),
    Asset("ANIM", "anim/swap_hammer_mjolnir.zip") }
local b = {
    Asset("ANIM", "anim/lavaarena_hammer_attack_fx.zip") }
local c = { "forginghammer_crackle_fx", "forgeelectricute_fx", "reticuleaoe", "reticuleaoeping",
    "reticuleaoehostiletarget", "weaponsparks_fx" }
local d = { "forginghammer_cracklebase_fx" }
local function e(f, g)
    g.AnimState:OverrideSymbol("swap_object", "swap_hammer_mjolnir", "swap_hammer_mjolnir")
    g.AnimState:Show("ARM_carry")
    g.AnimState:Hide("ARM_normal")
end; local function h(f, g)
    g.AnimState:Hide("ARM_carry")
    g.AnimState:Show("ARM_normal")
end;
local function targetfn()
    local j = ThePlayer;
    local k = TheWorld.Map;
    local l = Vector3()
    for m = 7, 0, -.25 do
        l.x, l.y, l.z = j.entity:LocalToWorldSpace(m, 0, 0)
        if k:IsPassableAtPoint(l:Get()) and not k:IsGroundTargetBlocked(l) then
            return l
        end
    end;
    return l
end;
local function n(f, o, l) o:PushEvent("combat_leap", { targetpos = l, weapon = f }) end;

local function OnLeapt(inst, doer, startingpos, targetpos)
    if inst.components.weapon and inst.components.weapon:HasAltAttack() then
        local ents = {}
        local x, y, z = targetpos:Get()
        for _, v in ipairs(TheSim:FindEntities(x, y, z, 4, nil, { "player", "companion" })) do
            if v ~= doer and (doer.components.combat:IsValidTarget(v)
                    and v.components.health
                    or v.entity:IsValid() and v.components.workable and v.components.workable:CanBeWorked() and v.components.workable:GetWorkAction())
            then
                table.insert(ents, v)
            end
        end;
        inst.components.weapon:DoAltAttack(doer, ents, nil, "electric")
    end

    SpawnPrefab("forginghammer_crackle_fx"):SetTarget(inst)
    inst.components.recarregavel:StartRecharge()
end;
local function q(f, r, s)
    if not f.components.weapon.isaltattacking then
        SpawnPrefab("weaponsparks_fx"):SetPosition(r, s)
        if s and s.components.armorbreak_debuff then
            s.components.armorbreak_debuff:ApplyDebuff()
        end
    else
        SpawnPrefab("forgeelectricute_fx"):SetTarget(s, true)
    end
end;

local function HammerFn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.nameoverride = "hammer_mjolnir"
    inst.AnimState:SetBank("hammer_mjolnir")
    inst.AnimState:SetBuild("hammer_mjolnir")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("aoeweapon_leap")
    inst:AddTag("hammer")
    inst:AddTag("rechargeable")

    inst:AddComponent("aoetargeting")
    inst.components.aoetargeting.reticule.reticuleprefab = "reticuleaoe"
    inst.components.aoetargeting.reticule.pingprefab = "reticuleaoeping"
    inst.components.aoetargeting.reticule.targetfn = targetfn;
    inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
    inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
    inst.components.aoetargeting.reticule.ease = true;
    inst.components.aoetargeting.reticule.mouseenabled = true;

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end;

    inst.IsWorkableAllowed = function(self, u, v)
        return u == ACTIONS.CHOP or u == ACTIONS.DIG and v:HasTag("stump") or
            u == ACTIONS.MINE
    end;

    inst:AddComponent("aoespell")
    inst.components.aoespell:SetSpellFn(n)

    inst:AddComponent("aoeweapon_leap")
    inst.components.aoeweapon_leap:SetOnLeaptFn(OnLeapt)

    inst:AddComponent("reticule_spawner")
    inst.components.reticule_spawner:Setup(unpack(TUNING.FORGE_ITEM_PACK.RET_DATA.hammer))

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(e)
    inst.components.equippable:SetOnUnequip(h)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "hammer_mjolnir"

    inst:AddComponent("recarregavel")
    inst.components.recarregavel:SetRechargeTime(TUNING.FORGE_ITEM_PACK.TFWP_LAVA_HAMMER.COOLDOWN)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.FORGE_ITEM_PACK.TFWP_LAVA_HAMMER.DAMAGE)
    inst.components.weapon:SetOnAttack(q)
    inst.components.weapon:SetDamageType(DAMAGETYPES.PHYSICAL)
    inst.components.weapon:SetAltAttack(TUNING.FORGE_ITEM_PACK.TFWP_LAVA_HAMMER.ALT_DAMAGE,
        TUNING.FORGE_ITEM_PACK.TFWP_LAVA_HAMMER.ALT_RADIUS, nil, DAMAGETYPES.PHYSICAL)

    return inst
end;

local function w()
    local f = CreateEntity()
    f.entity:AddTransform()
    f.entity:AddAnimState()
    f.entity:AddSoundEmitter()
    f.entity:AddNetwork()
    f.AnimState:SetBank("lavaarena_hammer_attack_fx")
    f.AnimState:SetBuild("lavaarena_hammer_attack_fx")
    f.AnimState:PlayAnimation("crackle_hit")
    f.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    f.AnimState:SetFinalOffset(1)
    f:AddTag("FX")
    f:AddTag("NOCLICK")
    f.entity:SetPristine()
    if not TheWorld.ismastersim then return f end;
    f.SetTarget = function(f, s)
        f.Transform:SetPosition(s:GetPosition():Get())
        f.SoundEmitter:PlaySound("dontstarve/impacts/lava_arena/hammer")
        SpawnPrefab("forginghammer_cracklebase_fx"):SetTarget(f)
    end;
    f:ListenForEvent("animover", f.Remove)
    return f
end;

local function x()
    local f = CreateEntity()
    f.entity:AddTransform()
    f.entity:AddAnimState()
    f.entity:AddNetwork()
    f.AnimState:SetBank("lavaarena_hammer_attack_fx")
    f.AnimState:SetBuild("lavaarena_hammer_attack_fx")
    f.AnimState:PlayAnimation("crackle_projection")
    f.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    f.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    f.AnimState:SetLayer(LAYER_BACKGROUND)
    f.AnimState:SetSortOrder(3)
    f.AnimState:SetScale(1.5, 1.5)
    f:AddTag("FX")
    f:AddTag("NOCLICK")

    f.entity:SetPristine()
    if not TheWorld.ismastersim then return f end;

    f.SetTarget = function(f, s)
        f.Transform:SetPosition(s:GetPosition():Get())
    end;
    f:ListenForEvent("animover", f.Remove)
    return f
end;

local function y()
    local f = CreateEntity()
    f.entity:AddTransform()
    f.entity:AddAnimState()
    f.entity:AddSoundEmitter()
    f.entity:AddNetwork()
    f.AnimState:SetBank("lavaarena_hammer_attack_fx")
    f.AnimState:SetBuild("lavaarena_hammer_attack_fx")
    f.AnimState:PlayAnimation("crackle_loop")
    f.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    f.AnimState:SetFinalOffset(1)
    f.AnimState:SetScale(1.5, 1.5)
    f:AddTag("FX")
    f:AddTag("NOCLICK")

    f.entity:SetPristine()
    if not TheWorld.ismastersim then return f end;

    f.SetTarget = function(f, s, z)
        f.Transform:SetPosition(s:GetPosition():Get())
        if z then f.SoundEmitter:PlaySound("dontstarve/impacts/lava_arena/electric") end;
        if s:HasTag("largecreature") or s:HasTag("epic") then f.AnimState:SetScale(2, 2) end
    end;
    f:ListenForEvent("animover", f.Remove)
    return f
end;
return
    CustomPrefab("tfwp_lava_hammer", HammerFn, a, c, nil, "images/inventoryimages.xml", "hammer_mjolnir.tex",
        TUNING.FORGE_ITEM_PACK.TFWP_LAVA_HAMMER, "swap_hammer_mjolnir", "common_hand"),
    Prefab("forginghammer_crackle_fx", w, b, d),
    Prefab("forginghammer_cracklebase_fx", x, b),
    Prefab("forgeelectricute_fx", y, b)
