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
    for periodic, data in pairs(inst._tro_sleep_pendingtasks) do
        table.remove(data.arg, 1) --把inst拿出来，因为DoPeriodicTask会往arg里再塞一个inst
        local new_periodic = inst:DoPeriodicTask(data.period, data.fn, data.initialdelay, unpack(data.arg))
        -- 链表，老对象指向新对象，新对象指向老对象，然后中间对象断开，新对象相对于一个代理
        local old_periodic = periodic._tro_old_periodic or periodic
        old_periodic._tro_new_periodic = new_periodic
        new_periodic._tro_old_periodic = old_periodic --这个old对象是最开始创建的那个对象，不是wake中生成的，因为外部可能持有old对象并且调用Cancel
        periodic._tro_old_periodic = nil
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
    if self._tro_new_periodic then              --把新创建的取消掉
        self._tro_new_periodic:Cancel()
        self._tro_new_periodic = nil
    end
    return OldCancel(self, ...)
end

-- 如果获取的对象已经被取消了，应该返回新对象的
local OldNextTime = Periodic.NextTime
function Periodic:NextTime(...)
    if not self.nexttick and self._tro_new_periodic then
        return self._tro_new_periodic:NextTime(...)
    end
    return OldNextTime(self, ...)
end
