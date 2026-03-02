local function GetAttackedBefore(self, attacker, damage, weapon, stimuli, spdamage)
    if self.inst.components.health and self.inst.components.health:IsDead() then
        return
    end

    local boat = self.inst:TroGetSWBoat()
    if not boat then
        return
    end

    -- 小船格挡这次伤害
    if damage and boat and boat.components.health then
        if damage > 0 and not boat.components.health:IsInvincible() then
            boat.components.combat:GetAttacked(attacker, damage)
        end
        return { false }, true
    end
end

AddComponentPostInit("combat", function(self, inst)
    Utils.FnDecorator(self, "GetAttacked", GetAttackedBefore)
end)
