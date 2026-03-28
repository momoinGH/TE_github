local function OnEntitySleep(inst)
    if not (inst.pendingtasks and inst:IsValid()) then
        return
    end

    inst._tro_sleep_pendingtasks = inst._tro_sleep_pendingtasks or {}
    for periodic in pairs(inst.pendingtasks) do
        if periodic._tro_cansleep then
            local data = {
                period = periodic.period,
                fn = periodic.fn,
                initialdelay = GetTaskRemaining(periodic),
                arg = periodic.arg,
            }
            periodic:Cancel()
            inst._tro_sleep_pendingtasks[periodic] = data
        end
    end
end

local function OnEntityWake(inst)
    if not (inst._tro_sleep_pendingtasks and inst:IsValid()) then
        return
    end

    for _, data in pairs(inst._tro_sleep_pendingtasks) do
        table.remove(data.arg, 1) --把inst拿出来，因为DoPeriodicTask会往arg里再塞一个inst
        inst:DoPeriodicTask(data.period, data.fn, data.period, data.initialdelay, unpack(data.arg))
    end
    inst._tro_sleep_pendingtasks = nil
end

-- 休眠时关闭，苏醒时启用的DoPeriodicTask
function EntityScript:TroDoCanSleepPeriodicTask(time, fn, initialdelay, ...)
    self:RemoveEventCallback("entitysleep", OnEntitySleep)
    self:RemoveEventCallback("entitywake", OnEntityWake)
    self:ListenForEvent("entitysleep", OnEntitySleep)
    self:ListenForEvent("entitywake", OnEntityWake)

    local periodic = self:DoPeriodicTask(time, fn, initialdelay, ...)
    periodic._tro_cansleep = true
    return periodic
end

-- hook Cancel，如果任务在休眠时被取消，就不需要再苏醒时恢复了
local OldCancel = Periodic.Cancel
function Periodic:Cancel(...)
    local ent = self.id and Ents[self.id]       --还好任务取消了id也还在
    if ent and ent._tro_sleep_pendingtasks then
        ent._tro_sleep_pendingtasks[self] = nil --不用恢复了
    end
    return OldCancel(self, ...)
end
