local Store = Class(function(self, inst)
    self.inst = inst
end)

function Store:CanOpen(doer)
    return self.CanOpenFn == nil or self.CanOpenFn(self.inst, doer)
end

function Store:OpenStore(doer)
    if self.OpenFn then self.OpenFn(self.inst, doer) end
end

return Store
