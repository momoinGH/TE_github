--睡觉一会儿后就删除，是干嘛的？？
local function DoVanish(inst, self)
    self:vanish()
end

local function OnEntitySleep(self)
    if self.vanish_task == nil then
        self.vanish_task = self.inst:DoTaskInTime(self.duration, DoVanish, self)
    end
end

AddComponentPostInit("vanish_on_sleep", function(self)
    self.duration = 10 --支持设置休眠后多少秒移除
    self.OnEntitySleep = OnEntitySleep
end)