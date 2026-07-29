local Oxygen = Class(function(self, inst)
    self.inst = inst

    self._current = net_float(inst.GUID, "oxygen._current", "oxygendirty")
    self._max = net_float(inst.GUID, "oxygen._max", "oxygendirty")
    self._rate = net_float(inst.GUID, "oxygen._rate")

    self._current:set(100)
    self._max:set(100)
    self._rate:set(0)

    self._oldpercent = 1

    -- 客机通过 netvar dirty 重建 oxygendelta（PushEvent 不会跨网络）
    if not TheWorld.ismastersim then
        inst:ListenForEvent("oxygendirty", function()
            self:OnOxygenDirty()
        end)
    end
end)

function Oxygen:OnOxygenDirty()
    local newpercent = self:GetPercent()
    local oldpercent = self._oldpercent

    if oldpercent ~= newpercent then
        self.inst:PushEvent("oxygendelta", {
            oldpercent = oldpercent,
            newpercent = newpercent,
            overtime = true,
        })

        -- 与主机端 DoDelta 保持一致的低氧提示事件
        if (newpercent > TUNING.OXYGEN_THRESH) ~= (oldpercent > TUNING.OXYGEN_THRESH)
            and newpercent <= TUNING.OXYGEN_THRESH
        then
            self.inst:PushEvent("runningoutofoxygen")
        end

        if oldpercent > 0 and newpercent <= 0 then
            self.inst:PushEvent("startdrowning")
        elseif oldpercent <= 0 and newpercent > 0 then
            self.inst:PushEvent("stopdrowning")
        end
    end

    self._oldpercent = newpercent
end

--------------------------------------------------------------------------
-- 主机端写入

function Oxygen:SetCurrent(current)
    self._current:set(current)
end

function Oxygen:SetMax(max)
    self._max:set(max)
end

function Oxygen:SetRate(rate)
    self._rate:set(rate)
end

--------------------------------------------------------------------------
-- 读写接口：优先走主机 component，客机走 netvar

function Oxygen:Max()
    if self.inst.components.oxygen ~= nil then
        return self.inst.components.oxygen.max
    end
    return self._max:value()
end

function Oxygen:GetCurrent()
    if self.inst.components.oxygen ~= nil then
        return self.inst.components.oxygen.current
    end
    return self._current:value()
end

function Oxygen:GetPercent()
    if self.inst.components.oxygen ~= nil then
        return self.inst.components.oxygen:GetPercent()
    end

    local max = self._max:value()
    if max <= 0 then
        return 0
    end
    return self._current:value() / max
end

function Oxygen:GetRate()
    if self.inst.components.oxygen ~= nil then
        return self.inst.components.oxygen:GetRate()
    end
    return self._rate:value()
end

function Oxygen:GetDelta()
    return self:GetRate()
end

function Oxygen:IsDrowning()
    if self.inst.components.oxygen ~= nil then
        return self.inst.components.oxygen:IsDrowning()
    end
    return self._current:value() <= 0
end

return Oxygen
