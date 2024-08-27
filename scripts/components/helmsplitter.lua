local function onready(self, ready)
    if ready then
        self.inst:AddTag("helmsplitter")
    else
        self.inst:RemoveTag("helmsplitter")
    end
end

--- 熔炉武器技能组件
local Helmsplitter = Class(function(self, inst)
    self.inst = inst

    self.ready = false
    self.damage = 10
    self.onhelmsplit = nil
end, nil, {
    ready = onready,
})

function Helmsplitter:SetOnHelmSplitFn(fn)
    self.onhelmsplit = fn
end

function Helmsplitter:StartHelmSplitting(doer)
    if doer.sg then
        doer.sg:PushEvent("start_helmsplit")
        return true
    end
    return false
end

function Helmsplitter:DoHelmSplit(doer, target)
    if doer.sg then
        doer.sg:PushEvent("do_helmsplit")
    end
    doer.components.combat:DoSpecialAttack(self.damage, target, "strong", doer.components.combat.damagemultiplier)
    if self.onhelmsplit then
        self.onhelmsplit(self.inst, doer, target)
    end
end

function Helmsplitter:StopHelmSplitting(doer)
    if doer.sg then
        doer.sg:PushEvent("stop_helmsplit")
    end
    self.ready = false
end

return Helmsplitter
