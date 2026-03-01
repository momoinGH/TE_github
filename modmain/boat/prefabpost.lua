local Utils = require("tropical_utils/utils")

local function GetEquippedShipwreckedBoat(inst)
    if TheWorld.ismastersim then
        return inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.SWBOAT) or nil
    else
        return inst.replica.inventory and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.SWBOAT) or nil
    end
end

local function GetAttackedBefore(self, attacker, damage, weapon, stimuli, spdamage)
    if self.inst.components.health and self.inst.components.health:IsDead() then
        return
    end

    local boat = GetEquippedShipwreckedBoat(self.inst)
    if not boat then
        return
    end

    -- 小船格挡这次伤害
    if damage and boat and boat.components.health then
        local blocked = false
        if damage > 0 and not boat.components.health:IsInvincible() then
            boat.components.health:DoDelta(-damage, "combat", attacker and attacker.prefab or "NIL")
        else
            blocked = true
        end

        if boat.components.shipwreckedboat then
            boat.components.shipwreckedboat:OnDriverAttacked()
        end

        return { false }, true
    end
end

AddComponentPostInit("combat", function(self, inst)
    Utils.FnDecorator(self, "GetAttacked", GetAttackedBefore)
end)

-- 监听船的开始移动和停止移动
local function OnLocomote(inst, data)
    local boat = GetEquippedShipwreckedBoat(inst)
    if not boat then return end

    local is_moving = inst.sg:HasStateTag("moving")
    local should_move = inst.components.locomotor:WantsToMoveForward()

    if is_moving and not should_move then
        boat:PushEvent("boat_stopmoving")
    elseif not is_moving and should_move then
        boat:PushEvent("boat_startmoving")
    end
end

AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("pro_driver")

    inst:ListenForEvent("locomote", OnLocomote)
end)

----------------------------------------------------------------------------------------------------

-- 划船时返回船的移速
AddComponentPostInit("locomotor", function(self)
    Utils.FnDecorator(self, "RunSpeed", function(self)
        local boat = GetEquippedShipwreckedBoat(self.inst)
        if boat and boat.runspeed then
            return { boat.runspeed }, true
        end
    end)
end)
