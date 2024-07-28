local assets = {
    Asset("ANIM", "anim/spear_gungnir.zip"),
    Asset("ANIM", "anim/swap_spear_gungnir.zip") }

local c = { "reticuleline", "reticulelineping", "spear_gungnir_lungefx", "weaponsparks_fx", "firehit" }

local function d(e, f)
    f.AnimState:OverrideSymbol("swap_object", "swap_spear_gungnir", "swap_spear_gungnir")
    f.AnimState:Show("ARM_carry")
    f.AnimState:Hide("ARM_normal")
end;

local function g(e, f)
    f.AnimState:Hide("ARM_carry")
    f.AnimState:Show("ARM_normal")
end;

local function targetfn()
    return Vector3(ThePlayer.entity:LocalToWorldSpace(TUNING.FORGE_ITEM_PACK.TFWP_SPEAR_GUNG.ALT_DIST, 0,
        0))
end;


local function mousetargetfn(inst, j)
    if j ~= nil then
        local k, l, m = inst.Transform:GetWorldPosition()
        local n = j.x - k; local o = j.z - m; local p = n * n + o * o; if p <= 0 then
            return inst.components.reticule.targetpos
        end;
        p = 6.5 / math.sqrt(p)
        return Vector3(k + n * p, 0, m + o * p)
    end
end;


local function updatepositionfn(inst, r, s, t, u, v)
    local k, l, m = inst.Transform:GetWorldPosition()
    s.Transform:SetPosition(k, 0, m)
    local w = -math.atan2(r.z - m, r.x - k) / DEGREES; if t and v ~= nil then
        local x = s.Transform:GetRotation()
        local y = w - x; w = Lerp(y > 180 and x + 360 or y < -180 and x - 360 or x, w, v * u)
    end;
    s.Transform:SetRotation(w)
end;

local function Spell(inst, A, r)
    A:PushEvent("combat_lunge", { targetpos = r, weapon = inst })
end;

local function OnAttack(inst, C, D)
    if not inst.components.weapon.isaltattacking then
        SpawnPrefab("weaponsparks_fx"):SetPosition(C, D)
    else
        SpawnPrefab("forgespear_fx"):SetTarget(D)
        if D and D:HasTag("flippable") then
            D:PushEvent("flipped", { flipper = C })
        end
    end
end;

-- 生成火焰路径
local function OnLunged(inst, doer, startingpos, targetpos)
    local targets = {}
    for k = 0, 10 do
        doer:DoTaskInTime(FRAMES * math.ceil(1 + k / 3.5), function()
            if inst.components.weapon and inst.components.weapon:HasAltAttack() then
                local ents = {}
                local l = (targetpos - startingpos):GetNormalized() * k * 0.6;
                local x, y, z = (startingpos + l):Get()
                SpawnPrefab("spear_gungnir_lungefx").Transform:SetPosition(x, y, z)

                for _, v in ipairs(TheSim:FindEntities(x, y, z, TUNING.FORGE_ITEM_PACK.TFWP_SPEAR_GUNG.ALT_WIDTH / 2, nil,
                    { "player", "companion" })) do
                    if not targets[v]
                        and v ~= doer
                        and doer.components.combat:IsValidTarget(v)
                        and (v.components.health or v.entity:IsValid()
                            and v.components.workable and v.components.workable:CanBeWorked() and v.components.workable:GetWorkAction()) then
                        targets[v] = true;
                        table.insert(ents, v)
                    end
                end;

                inst.components.weapon:DoAltAttack(doer, ents, nil, "explosive")
            end
        end)
    end

    inst.components.recarregavel:StartRecharge()
end;
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.nameoverride = "spear_gungnir"
    inst.AnimState:SetBank("spear_gungnir")
    inst.AnimState:SetBuild("spear_gungnir")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("aoeweapon_lunge")
    inst:AddTag("rechargeable")
    inst:AddTag("sharp")
    inst:AddTag("pointy")

    inst:AddComponent("aoetargeting")
    inst.components.aoetargeting.reticule.reticuleprefab = "reticuleline"
    inst.components.aoetargeting.reticule.pingprefab = "reticulelineping"
    inst.components.aoetargeting.reticule.targetfn = targetfn;
    inst.components.aoetargeting.reticule.mousetargetfn = mousetargetfn;
    inst.components.aoetargeting.reticule.updatepositionfn = updatepositionfn;
    inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
    inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
    inst.components.aoetargeting.reticule.ease = true;
    inst.components.aoetargeting.reticule.mouseenabled = true;

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end;

    inst.AllowWorkable = function(self, G, H)
        return G == ACTIONS.MINE
    end;

    inst:AddComponent("aoespell")
    inst.components.aoespell:SetSpellFn(Spell)

    inst:AddComponent("aoeweapon_lunge")
    inst.components.aoeweapon_lunge:SetStimuli("explosive")
    inst.components.aoeweapon_lunge:SetOnLungedFn(OnLunged)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(d)
    inst.components.equippable:SetOnUnequip(g)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "spear_gungnir"

    inst:AddComponent("recarregavel")
    inst.components.recarregavel:SetRechargeTime(TUNING.FORGE_ITEM_PACK.TFWP_SPEAR_GUNG.COOLDOWN)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.FORGE_ITEM_PACK.TFWP_SPEAR_GUNG.DAMAGE)
    inst.components.weapon:SetOnAttack(OnAttack)
    inst.components.weapon:SetDamageType(DAMAGETYPES.PHYSICAL)
    inst.components.weapon:SetAltAttack(TUNING.FORGE_ITEM_PACK.TFWP_SPEAR_GUNG.ALT_DAMAGE,
        TUNING.FORGE_ITEM_PACK.TFWP_SPEAR_GUNG.ALT_DIST + TUNING.FORGE_ITEM_PACK.TFWP_SPEAR_GUNG.ALT_WIDTH, nil,
        DAMAGETYPES.PHYSICAL)

    return inst
end;

return CustomPrefab("tfwp_spear_gung", fn, assets, c, nil, "images/inventoryimages.xml", "spear_gungnir.tex",
    TUNING.FORGE_ITEM_PACK.TFWP_SPEAR_GUNG, "swap_spear_gungnir", "common_hand")
