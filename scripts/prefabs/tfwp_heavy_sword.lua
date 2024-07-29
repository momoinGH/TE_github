local a = { Asset("ANIM", "anim/sword_buster.zip"),
    Asset("ANIM", "anim/swap_sword_buster.zip") }
local b = {
    "weaponsparks_fx",
    "sunderarmordebuff",
    "superjump_fx",
    "reticulearc",
    "reticulearcping" }

local function c() return Vector3(ThePlayer.entity:LocalToWorldSpace(6.5, 0, 0)) end;

local function d(e, f)
    if f ~= nil then
        local g, h, i = e.Transform:GetWorldPosition()

        local j = f.x - g; local k = f.z - i;

        local l = j * j + k * k; if l <= 0 then return e.components.reticule.targetpos end;

        l = 6.5 / math.sqrt(l)
        return Vector3(g + j * l, 0, i + k * l)
    end
end;
local function m(e, n, o, p, q, r)
    local g, h, i = e.Transform:GetWorldPosition()
    o.Transform:SetPosition(g, 0, i)
    local s = -math.atan2(n.z - i, n.x - g) / DEGREES; if p and r ~= nil then
        local t = o.Transform:GetRotation()
        local u = s - t; s = Lerp(u > 180 and t + 360 or u < -180 and t - 360 or t, s, r * q)
    end; o.Transform:SetRotation(s)
end;
local function v(e, w)
    w.AnimState:OverrideSymbol("swap_object", "swap_sword_buster", "swap_sword_buster")
    w.AnimState:Show("ARM_carry")
    w.AnimState:Hide("ARM_normal")
end;
local function x(e, w)
    w.AnimState:Hide("ARM_carry")
    w.AnimState:Show("ARM_normal")
end;
local function y(e, z, A)
    SpawnPrefab("weaponsparks_fx"):SetPosition(z, A)
    if A and A.components.combat and z then A.components.combat:SetTarget(z) end
end;
local function B(e, C, n)
    C:PushEvent("combat_parry",
        { direction = e:GetAngleToPoint(n), duration = e.components.parryweapon.duration, weapon = e })
end;
local function OnPreParry(e, C) e.components.recarregavel:StartRecharge() end; local function E(e)
    SpawnPrefab("superjump_fx")
        :SetTarget(e)
end;
local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
    inst.nameoverride = "lavaarena_heavyblade"
    inst.AnimState:SetBank("sword_buster")
    inst.AnimState:SetBuild("sword_buster")
    inst.AnimState:PlayAnimation("idle")
    inst:AddTag("parryweapon")
    inst:AddTag("rechargeable")
    inst:AddComponent("aoetargeting")
    inst.components.aoetargeting:SetAlwaysValid(true)
    inst.components.aoetargeting.reticule.reticuleprefab = "reticulearc"
    inst.components.aoetargeting.reticule.pingprefab = "reticulearcping"
    inst.components.aoetargeting.reticule.targetfn = c;
    inst.components.aoetargeting.reticule.mousetargetfn = d;
    inst.components.aoetargeting.reticule.updatepositionfn = m;
    inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
    inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
    inst.components.aoetargeting.reticule.ease = true;
    inst.components.aoetargeting.reticule.mouseenabled = true;
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end;

    inst:AddComponent("aoespell")
    inst.components.aoespell:SetSpellFn(B)
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(v)
    inst.components.equippable:SetOnUnequip(x)
    inst:AddComponent("helmsplitter")
    inst.components.helmsplitter:SetOnHelmSplitFn(E)
    inst.components.helmsplitter.damage = TUNING.FORGE_ITEM_PACK.TFWP_HEAVY_SWORD.HELMSPLIT_DAMAGE;
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "lavaarena_heavyblade"
    --e.components.inventoryitem.atlasname = "images/tfwp_inventoryimgs.xml"
    inst:AddComponent("parryweapon")
    inst.components.parryweapon.duration = TUNING.FORGE_ITEM_PACK.TFWP_HEAVY_SWORD.PARRY_DURATION;
    inst.components.parryweapon:SetOnPreParryFn(OnPreParry)
    inst:AddComponent("recarregavel")
    inst.components.recarregavel:SetRechargeTime(TUNING.FORGE_ITEM_PACK.TFWP_HEAVY_SWORD.COOLDOWN / 20)
    inst:AddComponent("reticule_spawner")
    inst.components.reticule_spawner:Setup(unpack(TUNING.FORGE_ITEM_PACK.RET_DATA.tfwp_heavy_sword))
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.FORGE_ITEM_PACK.TFWP_HEAVY_SWORD.DAMAGE)
    inst.components.weapon:SetDamageType(DAMAGETYPES.PHYSICAL)

    --e:AddComponent("finiteuses")
    --e.components.finiteuses:SetMaxUses(TUNING.TFWP_HEAVY_SWORD.USES)
    --e.components.finiteuses:SetUses(TUNING.TFWP_HEAVY_SWORD.USES)
    --e.components.finiteuses:SetOnFinished(e.Remove)
    return inst
end;

return CustomPrefab("tfwp_heavy_sword", fn, a, b, nil, "images/inventoryimages.xml", "lavaarena_heavyblade.tex",
    TUNING.FORGE_ITEM_PACK.TFWP_HEAVY_SWORD, "swap_sword_buster", "common_hand")
