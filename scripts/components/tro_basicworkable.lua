local function onworkable(self)
    if self.workleft > 0 and self.workable then
        self.inst:AddTag(self.workable_tag)
    else
        self.inst:RemoveTag(self.workable_tag)
    end
end

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
    -- self.maxwork = -1 --好像用不着这个
    self.workable = true

    self.savestate = false
    self.onloadfn = nil
end, nil, {
    workleft = onworkable,
    workable = onworkable,
})

function BasicWorkable:OnRemoveFromEntity()
    self.inst:RemoveTag(self.workable_tag)
end

function BasicWorkable:SetWorkLeft(work)
    self.workable = true
    self.workleft = work
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
            worker:PushEvent(self.finishedwork_event, { target = self.inst })
        end
    end
end

function BasicWorkable:OnSave()
    return self.savestate
        and {
            workleft = self.workleft,
        }
        or {}
end

function BasicWorkable:OnLoad(data)
    self.workleft = data.workleft or self.workleft
    if self.onloadfn ~= nil then
        self.onloadfn(self.inst, data)
    end
end

return BasicWorkable
