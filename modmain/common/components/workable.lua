-- 当前workleft改变时推送一下事件
local function onworkleftbefore(self, new, old)
    self.inst:PushEvent("tro_onworkleftchange", new, old)
end

AddComponentPostInit("workable", function(self)
    Hooks.FnDecorator(self._.workleft, 2, onworkleftbefore)
end)
