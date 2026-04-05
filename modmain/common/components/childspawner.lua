AddComponentPostInit("childspawner", function(self)
    -- 可以替换子实体
    function self:ReplaceChild(oldEnt, newEnt)
        self:TakeOwnership(newEnt)
        self:OnChildKilled(oldEnt)
    end
end)
