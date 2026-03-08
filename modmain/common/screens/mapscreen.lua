-- 地图打开关闭时播放音效
AddClassPostConstruct("screens/mapscreen", function(self)
    local _OnBecomeInactive = self.OnBecomeInactive
    function self:OnBecomeInactive(...)
        _OnBecomeInactive(self, ...)
        TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/map_close")
    end

    local _OnBecomeActive = self.OnBecomeActive
    function self:OnBecomeActive(...)
        _OnBecomeActive(self, ...)
        TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/map_open")
    end
end)
