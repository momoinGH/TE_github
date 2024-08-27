--- 标记组件，主要用于POINT类型的componentaction，允许空手下也能触发行为，用来限制空手下的componentaction遍历
--- 用在哪个对象上面还是根据覆盖playeractionpicker方法调用GetPointActions时传入的参数是谁
local NoEquipActivator = Class(function(self, inst)
    self.inst = inst
end)


return NoEquipActivator
