--- 本体portablestructure组件，因为原来的组件只给厨师和女工用，这里拷贝一份出来
local PortableStructure = Class(function(self, inst)
    self.inst = inst
    self.ondismantlefn = nil
end)

--- 注意，需要返回值
function PortableStructure:SetOnDismantleFn(fn)
    self.ondismantlefn = fn
end

function PortableStructure:Dismantle(doer)
    if self.ondismantlefn ~= nil then
        return self.ondismantlefn(self.inst, doer)
    else
        return false
    end
end

return PortableStructure
