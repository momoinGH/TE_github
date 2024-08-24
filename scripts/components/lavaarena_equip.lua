local GetPrefab = require("tropical_utils/getprefab")

local function OnPlayerEquip(owner, data)
    if data.eslot == EQUIPSLOTS.HANDS and data.item and data.item.components.rechargeable then
        local item = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
        if item and item.cooldown_mult then
            data.item.components.rechargeable:SetChargeTimeMod(item, nil, item.cooldown_mult)
        end
    end
end

-- 玩家脱掉武器时移除冷却减免
local function OnPlayerUnequip(owner, data)
    if data.eslot == EQUIPSLOTS.HANDS and data.item and data.item.components.rechargeable then
        local item = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
        if item and item.cooldown_mult then
            data.item.components.rechargeable:RemoveChargeTimeMod(item)
        end
    end
end

local function OnEquipped(inst, data)
    local owner = data.owner
    local self = inst.components.lavaarena_equip

    if self.max_health and owner.components.health then
        GetPrefab.SetMaxHealth(owner, owner.components.health.maxhealth + self.max_health)
    end

    if self.cooldown_mult then
        local weapon = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)        --只减免手部武器
        if weapon and weapon.components.rechargeable then
            weapon.components.rechargeable:SetChargeTimeMod(inst, nil, self.cooldown_mult) --应该是负数
        end
        inst:ListenForEvent("equip", OnPlayerEquip, owner)
        inst:ListenForEvent("unequip", OnPlayerUnequip, owner)
    end
end

local function OnUnequipped(inst, data)
    local owner = data.owner
    local self = inst.components.lavaarena_equip

    if self.max_health and owner.components.health then
        GetPrefab.SetMaxHealth(owner, owner.components.health.maxhealth - self.max_health)
    end
    
    if self.cooldown_mult then
        local weapon = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) --只减免手部武器
        if weapon and weapon.components.rechargeable then
            weapon.components.rechargeable:RemoveChargeTimeMod(inst)
        end
        inst:RemoveEventCallback("equip", OnPlayerEquip, owner)
        inst:RemoveEventCallback("unequip", OnPlayerUnequip, owner)
    end
end

--- 熔炉装备组件，没有记录进来的字段可能交给其他组件处理了
local LavaarenaEquip = Class(function(self, inst)
    self.inst = inst

    --武器
    self.damagetype = DAMAGETYPES.PHYSICAL

    --头盔护甲
    self.cooldown_mult = nil
    self.attack_mult = {} --格式为{[DAMAGETYPES.PHYSICAL] = 1.1,}
    self.max_health = nil

    inst:ListenForEvent("equipped", OnEquipped)
    inst:ListenForEvent("unequipped", OnUnequipped)
end)

function LavaarenaEquip:SetAttackMult(damagetype, mult)
    self.attack_mult[damagetype] = mult
end

return LavaarenaEquip
