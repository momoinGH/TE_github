--- 简单的周期任务组件，休眠后会暂停
local SimplePeriodTask = Class(function(self, inst)
    self.inst = inst
    self.tasks = {}
end)

function SimplePeriodTask:DoPeriodicTask(name, time, fn, initialdelay, ...)
    if self.tasks[name] then
        self:Cancel(name)
    end

    self.tasks[name] = {
        task = not self.inst:IsAsleep() and self.inst:DoPeriodicTask(time, fn, initialdelay, ...) or nil,
        time = time,
        fn = fn,
        initialdelay = initialdelay,
        data = { ... }
    }
end

function SimplePeriodTask:Cancel(name)
    local d = self.tasks[name]
    if d then
        if d.task then
            d.task:Cancel()
        end
        self.tasks[name] = nil
    end
end

function SimplePeriodTask:OnEntityWake()
    for _, d in pairs(self.tasks) do
        d.task = self.inst:DoPeriodicTask(d.time, d.fn, d.initialdelay, unpack(d.data))
    end
end

function SimplePeriodTask:TaskExists(name)
    return self.tasks[name] ~= nil
end

function SimplePeriodTask:OnEntitySleep()
    for _, d in pairs(self.tasks) do
        if d.task then
            d.task:Cancel()
            d.task = nil
        end
    end
end

return SimplePeriodTask
