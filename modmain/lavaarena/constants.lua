local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", inst.symbol_build, inst.symbol_build)
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end
local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function OnDischarged(inst)
    inst.components.aoetargeting:SetEnabled(false)
end

local function OnCharged(inst)
    inst.components.aoetargeting:SetEnabled(true)
end

local function OnAttack(inst, attacker, target)
    if target then
        SpawnPrefab(inst.weaponspark):Setup(attacker, target)
    end
end

---初始化有技能的熔炉武器
---@param inst Entity
---@param symbol_build string|nil
---@param damage number|nil
---@param weaponspark string|nil
function InitLavaarenaWeapon(inst, symbol_build, damage, weaponspark)
    inst:AddComponent("aoespell")

    inst:AddComponent("equippable")
    if symbol_build then
        inst.symbol_build = symbol_build
        inst.components.equippable:SetOnEquip(OnEquip)
        inst.components.equippable:SetOnUnequip(OnUnequip)
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("weapon")
    if damage then
        inst.components.weapon:SetDamage(damage)
    end
    if weaponspark then
        inst.weaponspark = weaponspark
        inst.components.weapon:SetOnAttack(OnAttack)
    end


    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetOnDischargedFn(OnDischarged)
    inst.components.rechargeable:SetOnChargedFn(OnCharged)
end

----------------------------------------------------------------------------------------------------
