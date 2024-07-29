local assets = {
    Asset("ANIM", "anim/spear_lance.zip"),
    Asset("ANIM", "anim/swap_spear_lance.zip")
}

local prefabs = {
    "reticuleaoesmall",
    "reticuleaoesmallping",
    "reticuleaoesmallhostiletarget",
    "weaponsparks_fx",
    "weaponsparks_thrusting",
    "forgespear_fx",
    "superjump_fx",
}

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_spear_lance", "swap_spear_lance")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end;
local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end;

local function targetfn()
    local pos = Vector3()
    for k = 5, 0, -.25 do
        pos.x, pos.y, pos.z = ThePlayer.entity:LocalToWorldSpace(k, 0, 0)
        if TheWorld.Map:IsPassableAtPoint(pos:Get()) and not TheWorld.Map:IsGroundTargetBlocked(pos) then
            return pos
        end
    end;
    return pos
end;

local function Spell(inst, doer, pos)
    doer:PushEvent("combat_superjump", { targetpos = pos, weapon = inst })
end;

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
        inst.components.weapon:DoAltAttack(doer, ents, nil, "explosive")
    end

    SpawnPrefab("superjump_fx"):SetTarget(inst)
    inst.components.recarregavel:StartRecharge()
end;

local function OnAttack(inst, p, q)
    if not inst.components.weapon.isaltattacking then
        SpawnPrefab("weaponsparks_fx"):SetPosition(p, q)
    else
        SpawnPrefab("forgespear_fx"):SetTarget(q)
    end
end;
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.nameoverride = "spear_lance"
    inst.AnimState:SetBank("spear_lance")
    inst.AnimState:SetBuild("spear_lance")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("aoeweapon_leap")
    inst:AddTag("pointy")
    inst:AddTag("rechargeable")
    inst:AddTag("sharp")
    inst:AddTag("superjump")

    inst:AddComponent("aoetargeting")
    inst.components.aoetargeting:SetRange(TUNING.FORGE_ITEM_PACK.TFWP_SPEAR_LANCE.ALT_RANGE)
    inst.components.aoetargeting.reticule.reticuleprefab = "reticuleaoesmall"
    inst.components.aoetargeting.reticule.pingprefab = "reticuleaoesmallping"
    inst.components.aoetargeting.reticule.targetfn = targetfn;
    inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
    inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
    inst.components.aoetargeting.reticule.ease = true;
    inst.components.aoetargeting.reticule.mouseenabled = true;

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end;

    inst.IsWorkableAllowed = function(self, s, t)
        return s == ACTIONS.CHOP or s == ACTIONS.DIG and t:HasTag("stump") or
            s == ACTIONS.MINE
    end;

    inst:AddComponent("aoespell")
    inst.components.aoespell:SetSpellFn(Spell)

    inst:AddComponent("aoeweapon_leap")
    inst.components.aoeweapon_leap:SetStimuli("explosive")
    inst.components.aoeweapon_leap:SetOnLeaptFn(OnLeapt)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "spear_lance"

    inst:AddComponent("multithruster")
    inst.components.multithruster.weapon = inst;

    inst:AddComponent("recarregavel")
    inst.components.recarregavel:SetRechargeTime(TUNING.FORGE_ITEM_PACK.TFWP_SPEAR_LANCE.COOLDOWN)

    inst:AddComponent("reticule_spawner")
    inst.components.reticule_spawner:Setup(unpack(TUNING.FORGE_ITEM_PACK.RET_DATA.tfwp_spear_lance))

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.FORGE_ITEM_PACK.TFWP_SPEAR_LANCE.DAMAGE)
    inst.components.weapon:SetOnAttack(OnAttack)
    inst.components.weapon:SetDamageType(DAMAGETYPES.PHYSICAL)
    inst.components.weapon:SetAltAttack(TUNING.FORGE_ITEM_PACK.TFWP_SPEAR_LANCE.ALT_DAMAGE,
        TUNING.FORGE_ITEM_PACK.TFWP_SPEAR_LANCE.ALT_RADIUS, nil, DAMAGETYPES.PHYSICAL)

    return inst
end;
return
    CustomPrefab("tfwp_spear_lance", fn, assets, prefabs, nil, "images/inventoryimages.xml", "spear_lance.tex",
        TUNING.FORGE_ITEM_PACK.TFWP_SPEAR_LANCE, "swap_spear_lance", "common_hand")
