local function onmax(self, max)
    self.inst.replica.oxygen:SetMax(max)
end

local function oncurrent(self, current)
    self.inst.replica.oxygen:SetCurrent(current)
end

local function onrate(self, rate)
    self.inst.replica.oxygen:SetRate(rate)
end

local Oxygen = Class(function(self, inst)
    self.inst = inst

    self.max = 100
    self.current = self.max
    self.rate = 0
    self.hurtrate = 5
    self.burning = true

    -- self.oxygen_supply = nil -- 额外固定供氧（外部可写）
    -- self.redirect = nil
    -- self.ignore = nil
    -- self.custom_rate_fn = nil

    self.inst:StartUpdatingComponent(self)
end,
nil,
{
    max = onmax,
    current = oncurrent,
    rate = onrate,
})

function Oxygen:OnRemoveFromEntity()
    self.inst:StopUpdatingComponent(self)
end

function Oxygen:Pause()
    self.burning = false
end

function Oxygen:Resume()
    self.burning = true
end

function Oxygen:IsDrowning()
    return self.current <= 0
end

function Oxygen:OnSave()
    return {
        oxigenio = self.current,
    }
end

function Oxygen:OnLoad(data)
    if data.oxigenio ~= nil then
        self.current = data.oxigenio
        self:DoDelta(0)
    end
end

function Oxygen:GetCurrent()
    return self.current
end

function Oxygen:GetMax()
    return self.max
end

function Oxygen:GetDelta()
    return self.rate
end

function Oxygen:GetPercent()
    if self.max <= 0 then
        return 0
    end
    return self.current / self.max
end

function Oxygen:SetPercent(n)
    local target = n * self.max
    local delta = target - self.current
    self:DoDelta(delta)
end

function Oxygen:GetDebugString()
    return string.format("%2.2f / %2.2f at %2.4f", self.current, self.max, self.rate)
end

function Oxygen:SetMax(amount)
    self.max = amount
    self.current = amount
end

function Oxygen:GetRate()
    return self.rate
end

--- 遍历已装备物品，汇总 oxygensupplier 供氧与 oxygenapparatus 减耗
local function GetEquipmentOxygenModifiers(inst)
    local oxygen_supply = 0
    local reduction_mult = 1

    local inventory = inst.components.inventory
    if inventory == nil then
        return oxygen_supply, reduction_mult
    end

    for _, item in pairs(inventory.equipslots) do
        if item ~= nil and item:IsValid() then
            if item.components.oxygensupplier ~= nil then
                oxygen_supply = oxygen_supply + item.components.oxygensupplier:GetSupplyRate(inst)
            end
            if item.components.oxygenapparatus ~= nil then
                local pct = item.components.oxygenapparatus:GetReductionPercentage() or 0
                reduction_mult = reduction_mult * (1 - pct)
            end
        end
    end

    return oxygen_supply, reduction_mult
end

function Oxygen:DoDelta(delta, overtime)
    -- 无敌 / 传送中不掉氧
    if (self.inst.components.health ~= nil and self.inst.components.health:IsInvincible())
        or self.inst.is_teleporting == true
    then
        return
    end

    -- 仅在水下消耗氧气；离水立即回满
    if not self.inst:IsInUnderWaterArea() then
        self.rate = 0
        if self.current ~= self.max then
            local old = self.current
            self.current = self.max
            local oldpercent = old / self.max
            local newpercent = 1
            self.inst:PushEvent("oxygendelta", {
                oldpercent = oldpercent,
                newpercent = newpercent,
                overtime = true,
            })
            if old <= 0 then
                self.inst:PushEvent("stopdrowning")
            end
        end
        return
    end

    if self.redirect then
        self.redirect(self.inst, delta, overtime)
        return
    end

    -- 气泡等外部临时回氧标记
    if self.inst:HasTag("respire") then
        delta = 10
        self.inst:RemoveTag("respire")
    end

    if self.ignore then
        return
    end

    local old = self.current
    self.current = math.clamp(self.current + delta, 0, self.max)

    local oldpercent = old / self.max
    local newpercent = self.current / self.max

    self.inst:PushEvent("oxygendelta", {
        oldpercent = oldpercent,
        newpercent = newpercent,
        overtime = overtime,
    })

    if old > 0 and self.current <= 0 then
        self.inst:PushEvent("startdrowning")
    elseif old <= 0 and self.current > 0 then
        self.inst:PushEvent("stopdrowning")
    end

    if (newpercent > TUNING.OXYGEN_THRESH) ~= (oldpercent > TUNING.OXYGEN_THRESH)
        and newpercent <= TUNING.OXYGEN_THRESH
    then
        self.inst:PushEvent("runningoutofoxygen")
    end
end

function Oxygen:OnUpdate(dt)
    self:Recalc(dt)

    if self:IsDrowning()
        and self.burning
        and self.inst.components.health ~= nil
        and not self.inst.components.health:IsDead()
    then
        self.inst.components.health:DoDelta(-self.hurtrate * dt, true, "drowning")
    end
end

function Oxygen:Recalc(dt)
    if not self.burning then
        return
    end

    -- 不在水下时由 DoDelta 处理回满，这里直接走一遍即可
    if not self.inst:IsInUnderWaterArea() then
        self:DoDelta(0, true)
        return
    end

    local loss_delta = TUNING.OXYGEN_LOSS_RATE
    local oxygen_supply, reduction_mult = GetEquipmentOxygenModifiers(self.inst)
    oxygen_supply = oxygen_supply + (self.oxygen_supply or 0)

    local supply_delta = oxygen_supply * TUNING.OXYGEN_AIRINESS

    -- 环境氧气光环
    local aura_delta = 0
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, TUNING.OXYGEN_EFFECT_RANGE, { "oxygen_aura" })
    for _, v in ipairs(ents) do
        if v ~= self.inst and v.components.oxygenaura ~= nil then
            local distsq = self.inst:GetDistanceSqToInst(v)
            local aura_val = v.components.oxygenaura:GetAura(self.inst) / math.max(1, distsq)
            aura_delta = aura_delta + aura_val
        end
    end

    self.rate = supply_delta + loss_delta + aura_delta

    if self.custom_rate_fn then
        self.rate = self.rate + self.custom_rate_fn(self.inst)
    end

    -- 佩戴 oxygenapparatus 时降低耗氧（多件乘法叠加）
    if self.rate < 0 then
        self.rate = self.rate * reduction_mult
    end

    self:DoDelta(self.rate * dt, true)
end

function Oxygen:LongUpdate(dt)
    self:OnUpdate(dt)
end

return Oxygen
