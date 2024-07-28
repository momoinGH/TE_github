function a(b)
    return b.components.health ~= nil and not b.components.health:IsDead()
end;

local function c(d)
    local e = GetTime() - d.components.combat.lastwasattackedtime;
    d:AddTag("_isinheals")
    if e > 3 and not (d.sg and d.sg:HasStateTag("hiding")) then
        d.components.sleeper:AddSleepiness(10, 3)
    end
end;


local HealAura = Class(function(self, g)
    self.inst = g;
    self.range = 15;
    self.range = TUNING.FORGE_ITEM_PACK.TFWP_HEALING_STAFF.RANGE;
    self.duration = TUNING.FORGE_ITEM_PACK.TFWP_HEALING_STAFF.DURATION;
    self.heal_rate = TUNING.FORGE_ITEM_PACK.TFWP_HEALING_STAFF.HEAL_RATE;
    self.cache = {}

    local h = function() self:Stop() end;

    self.inst:DoTaskInTime(0, g.StartUpdatingComponent, self)
    self.inst:DoTaskInTime(self.duration, h)
end)

function HealAura:OnUpdate(i)
    local x, y, z = self.inst.Transform:GetWorldPosition()
    for _, v in pairs(TheSim:FindEntities(x, 0, z, self.range, nil, { "fossilized" })) do
        if not self.cache[v] and a(v) then
            self.cache[v] = true;
            self:OnEntEnter(v)
        end
    end;

    for b, _ in pairs(self.cache) do
        local n = b:GetPosition()
        if not a(b) or distsq(n.x, n.z, x, z) > self.range * self.range then self:OnEntLeave(b) end
    end
end;

function HealAura:OnEntEnter(target)
    if target.components.fossilizable and target.components.fossilizable:IsFossilized() then
        self.cache[target] = nil;
        return
    end

    if target.components.colourfader then target.components.colourfader:StartFade({ 0, 0.3, 0.1 }, .35) end;
    if (target:HasTag("player") or target:HasTag("companion")) and target.components.debuffable ~= nil and target.components.debuffable:IsEnabled() and not (target.components.health ~= nil and target.components.health:IsDead()) and not target:HasTag("playerghost") then
        target.components.debuffable:AddDebuff("healingcircle_regenbuff", "healingcircle_regenbuff")
        target.components.debuffable.debuffs["healingcircle_regenbuff"].inst.heal_value = self.heal_rate *
            target.components.debuffable.debuffs["healingcircle_regenbuff"].inst.tick_rate;
        target.components.debuffable.debuffs["healingcircle_regenbuff"].inst.caster =
            self.caster;
        if target.components.debuffable:HasDebuff("scorpeon_dot") then
            target.components.debuffable:RemoveDebuff(
                "scorpeon_dot")
        end
    elseif target.components.sleeper and not (target:HasTag("player") or target:HasTag("companion")) and not target.healingcircle_sleeptask then
        target.healingcircle_sleeptask = target:DoPeriodicTask(1 / 10, c)
        target.sleep_start = GetTime()
    end
end;

function HealAura:OnEntLeave(target)
    if not self.cache[target] then return end;
    if target:HasTag("_isinheals") then target:RemoveTag("_isinheals") end;
    if target.components.colourfader then
        target.components.colourfader:StartFade({ 0, 0, 0 }, .35)
    end;
    if target.components.debuffable ~= nil
        and target.components.debuffable:IsEnabled()
        and target.components.debuffable:HasDebuff("healingcircle_regenbuff")
        and not (target.components.health ~= nil and target.components.health:IsDead())
        and not target:HasTag("playerghost")
        and target:HasTag("player")
    then
        target.components.debuffable:RemoveDebuff("healingcircle_regenbuff")
    elseif target.components.sleeper and not target:HasTag("player") and target.healingcircle_sleeptask then
        target.healingcircle_sleeptask:Cancel()
        target.healingcircle_sleeptask = nil
    end;
    self.cache[target] = nil
end;

function HealAura:Stop()
    self.inst:StopUpdatingComponent(self)
    for b, k in pairs(self.cache) do
        self:OnEntLeave(b)
    end
end;

HealAura.OnRemoveEntity = HealAura.Stop;
HealAura.OnRemoveFromEntity = HealAura.Stop;

return HealAura
