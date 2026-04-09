-- 海难季节管理，飓风季大风生成
local Seasonmanager = Class(function(self, inst)
    self.inst = inst

    self.hurricane_gust_speed = 0 --当前飓风风速
end)

function Seasonmanager:OnUpdate(dt)
    -- if TheWorld.state.iswinter then
    --     self:UpdateHurricaneTease(dt)
    -- end
end

return Seasonmanager
