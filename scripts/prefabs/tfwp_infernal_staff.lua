local a = {
    Asset("ANIM", "anim/fireballstaff.zip"),
    Asset("ANIM", "anim/swap_fireballstaff.zip") }
local b = { "forge_fireball_projectile", "forge_fireball_hit_fx", "infernalstaff_meteor", "reticuleaoe",
    "reticuleaoeping", "reticuleaoehostiletarget" }
local c = 4 * FRAMES;
local function d(e, f)
    f.AnimState:OverrideSymbol("swap_object", "swap_fireballstaff", "swap_fireballstaff")
    f.AnimState:Show("ARM_carry")
    f.AnimState:Hide("ARM_normal")
end;
local function g(e, f)
    f.AnimState:Hide("ARM_carry")
    f.AnimState:Show("ARM_normal")
end;
local function h()
    local i = ThePlayer;
    local j = TheWorld.Map; local k = Vector3()
    for l = 7, 0, -.25 do
        k.x, k.y, k.z = i.entity:LocalToWorldSpace(l, 0, 0)
        if j:IsPassableAtPoint(k:Get()) and not j:IsGroundTargetBlocked(k) then return k end
    end;
    return k
end;

local function m(e, n, k)
    SpawnPrefab("infernalstaff_meteor"):AttackArea(n, e, k)
    e.components.recarregavel:StartRecharge()
end;
local function o(e, p, q)
    local r = (q:GetPosition() - p:GetPosition()):GetNormalized() * 1.2;
    local s = SpawnPrefab("forge_fireball_hit_fx")
    s.Transform:SetPosition((p:GetPosition() + r):Get())
    s.AnimState:SetScale(0.8, 0.8)
end;
local function t(e, p, q)
    local u = e.meteor:GetPosition()
    local v = TUNING.FORGE_ITEM_PACK.TFWP_INFERNAL_STAFF.ALT_DAMAGE.base;
    local w = TUNING.FORGE_ITEM_PACK.TFWP_INFERNAL_STAFF.ALT_DAMAGE.center_mult;
    local x = 16; local y = distsq(u, q:GetPosition())
    local z = math.max(0, 1 - y / x)
    local A = v * (1 + Lerp(0, w, z))
    return A
end;
local function B(inst, p, q)
    if inst.components.weapon.isaltattacking then SpawnPrefab("infernalstaff_meteor_splashhit"):SetTarget(q) end
end;
local function C()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.nameoverride = "fireballstaff"

    inst.AnimState:SetBank("fireballstaff")
    inst.AnimState:SetBuild("fireballstaff")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("firestaff")
    inst:AddTag("magicweapon")
    inst:AddTag("pyroweapon")
    inst:AddTag("rangedweapon")
    inst:AddTag("rechargeable")

    inst:AddComponent("aoetargeting")
    inst.components.aoetargeting.reticule.reticuleprefab = "reticuleaoe"
    inst.components.aoetargeting.reticule.pingprefab = "reticuleaoeping"
    inst.components.aoetargeting.reticule.targetfn = h;
    inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
    inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
    inst.components.aoetargeting.reticule.ease = true;
    inst.components.aoetargeting.reticule.mouseenabled = true;

    inst.projectiledelay = c; inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end;

    inst.IsWorkableAllowed = function(self, D, E)
        return D == ACTIONS.CHOP or D == ACTIONS.DIG and E:HasTag("stump") or
            D == ACTIONS.MINE
    end;

    inst.castsound = "dontstarve/common/lava_arena/spell/meteor"

    inst:AddComponent("aoespell")
    inst.components.aoespell:SetSpellFn(m)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(d)
    inst.components.equippable:SetOnUnequip(g)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "fireballstaff"

    inst:AddComponent("recarregavel")
    inst.components.recarregavel:SetRechargeTime(TUNING.FORGE_ITEM_PACK.TFWP_INFERNAL_STAFF.COOLDOWN)

    inst:AddComponent("reticule_spawner")
    inst.components.reticule_spawner:Setup(unpack(TUNING.FORGE_ITEM_PACK.RET_DATA.tfwp_infernal_staff))

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.FORGE_ITEM_PACK.TFWP_INFERNAL_STAFF.DAMAGE)
    inst.components.weapon:SetOnAttack(B)
    inst.components.weapon:SetRange(10, 20)
    inst.components.weapon:SetProjectile("forge_fireball_projectile")
    inst.components.weapon:SetOnProjectileLaunch(o)
    inst.components.weapon:SetDamageType(DAMAGETYPES.MAGIC)
    inst.components.weapon:SetStimuli("fire")
    inst.components.weapon:SetAltAttack(TUNING.FORGE_ITEM_PACK.TFWP_INFERNAL_STAFF.ALT_DAMAGE.minimum, { 10, 20 }, nil,
        DAMAGETYPES.MAGIC, t)

    return inst
end;
return
    CustomPrefab("tfwp_infernal_staff", C, a, b, nil, "images/inventoryimages.xml", "fireballstaff.tex",
        TUNING.FORGE_ITEM_PACK.TFWP_INFERNAL_STAFF, "swap_fireballstaff", "common_hand")
