-- 在传送组件的传送目标改变时推送个事件
local function OnTeleporterTargetChange(self, new, old)
    self.inst:PushEvent("tro_onteleportertargetchange", new, old)
end

AddComponentPostInit("teleporter", function(self)
    Hooks.FnDecorator(self._.targetTeleporter, 2, OnTeleporterTargetChange)
end)
