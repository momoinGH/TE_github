-- 树木再生时间
local regrowthfunc = function()
    return TUNING.EVERGREEN_REGROWTH_TIME_MULT
end

local plants = { "jungletree", "palmtree", "tubertree", "teatree", "rainforesttree", "clawpalmtree" }
AddComponentPostInit("plantregrowth", function(self)
    for i, v in ipairs(plants) do
        self.TimeMultipliers[v] = regrowthfunc
    end
    self.TimeMultipliers["mushtree_yellow"] = function()
        return TUNING.MUSHTREE_REGROWTH_TIME_MULT * ((not TheWorld.state.autumn and 0) or 1)
    end
end)
