-- 对象销毁后不能执行定时任务，因为销毁后定时任务仍在有效，但是如果回调里获取坐标就会返回nil，进而游戏崩溃
local old_DoTaskInTime = EntityScript.DoTaskInTime
function EntityScript:DoTaskInTime(...)
    if self.IsValid and not self:IsValid() then
        TroErrorHandle("对象" .. tostring(self) .. "在移除后仍然执行DoTaskInTime，这可能导致游戏崩溃", true, false)
        return
    end
    return old_DoTaskInTime(self, ...)
end

local old_DoPeriodicTask = EntityScript.DoPeriodicTask
function EntityScript:DoPeriodicTask(...)
    if self.IsValid and not self:IsValid() then
        TroErrorHandle("对象" .. tostring(self) .. "在移除后仍然执行DoPeriodicTask，这可能导致游戏崩溃", true, false)
        return
    end
    return old_DoPeriodicTask(self, ...)
end
