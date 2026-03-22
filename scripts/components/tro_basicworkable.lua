local function onworkable(self)
    if self.action ~= nil then
        if self.workleft > 0 and self.workable then
            self.inst:AddTag(self.workable_tag)
        else
            self.inst:RemoveTag(self.workable_tag)
        end
    end
end

local base_props = {
    workleft = onworkable,
    maxwork = onworkable,
    workable = onworkable,
}

-- TODO 没有生效！
-- 提供一个基础的workable功能，只用于子类继承
local BasicWorkable = Class(function(self, inst, workable_tag, worked_event, workfinished_event, working_event, finishedwork_event)
    self.inst = inst

    -- 对比workable的各种标签，尽量不要和workable的事件重名，可能导致误触发回调
    assert(workable_tag)
    self.workable_tag = workable_tag
    self.worked_event = worked_event
    self.workfinished_event = workfinished_event
    self.working_event = working_event
    self.finishedwork_event = finishedwork_event

    self.workleft = 10
    self.maxwork = -1
    self.workable = true

    self.savestate = false
    self.onloadfn = nil
end)

function BasicWorkable:OnRemoveFromEntity()
    self.inst:RemoveTag(self.workable_tag)
end

function BasicWorkable:SetMaxWork(work)
    self.maxwork = math.max(1, work or 10)
end

function BasicWorkable:SetWorkLeft(work)
    self.workable = true
    self.workleft = self.maxwork > 0 and math.clamp(work or 10, 1, self.maxwork) or math.max(1, work or 10)
end

function BasicWorkable:WorkedBy(worker, numworks)
    numworks = numworks or 1
    if numworks > 0 then
        if self.workleft <= 1 then -- if there is less that one full work remaining, then just finish it. This is to handle the case where objects are set to only one work and not planned to handled something like 0.5 numworks
            self.workleft = 0
        else
            self.workleft = self.workleft - numworks
            if self.workleft < 0.01 then -- NOTES(JBK): Floating points are possible with work efficiency modifiers so cut out the epsilon.
                self.workleft = 0
            end
        end
    end

    if self.working_event then
        worker:PushEvent(self.working_event, { target = self.inst })
    end
    if self.worked_event then
        self.inst:PushEvent(self.worked_event, { worker = worker, workleft = self.workleft })
    end

    if self.workleft <= 0 then
        if self.workfinished_event then
            self.inst:PushEvent(self.workfinished_event, { worker = worker })
        end
        if self.finishedwork_event then
            worker:PushEvent(self.finishedwork_event, { target = self.inst, action = self.action })
        end
    end
end

function BasicWorkable:OnSave()
    return self.savestate
        and {
            maxwork = self.maxwork,
            workleft = self.workleft,
        }
        or {}
end

function BasicWorkable:OnLoad(data)
    self.workleft = data.workleft or self.workleft
    self.maxwork = data.maxwork or self.maxwork
    if self.onloadfn ~= nil then
        self.onloadfn(self.inst, data)
    end
end

-- 好像父类不支持第三个参数props，会报错，所以这里整合一下props
local function MakeWorkable(data, _ctor, props)
    props = props or {}
    table.trodeep_merge(props, base_props)
    return Class(BasicWorkable, function(self, inst, ...)
        BasicWorkable._ctor(self, inst, data.workable_tag, data.worked_event, data.workfinished_event, data.working_event, data.finishedwork_event)
        return _ctor(self, inst, ...)
    end, props)
end

return MakeWorkable
