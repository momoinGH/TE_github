AddComponentPostInit("grogginess", function(self)
    local OldAddGrogginess = self.AddGrogginess
    --雾气开始减速
    function self:ProStartFoggrog()
        self:SetDecayRate(0)                              --眩晕值不要减
        local old_knockouttestfn = self.knockouttestfn
        self.knockouttestfn = function() return false end --玩家不需要睡着
        OldAddGrogginess(self, 3)
        self.knockouttestfn = old_knockouttestfn
    end

    function self:ProStopFoggrog()
        self:SetDecayRate(TUNING.GROGGINESS_DECAY_RATE)
    end
end)
