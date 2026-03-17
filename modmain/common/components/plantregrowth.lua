-- 植物再生时间
local default_regrowth_fn = function()
    return TUNING.EVERGREEN_REGROWTH_TIME_MULT --1
end

local PlantRegrowth = require "components/plantregrowth"
PlantRegrowth.TimeMultipliers["mushtree_yellow"] = function()
    return TUNING.MUSHTREE_REGROWTH_TIME_MULT * ((not TheWorld.state.autumn and 0) or 1)
end


AddComponentPostInit("plantregrowth", function(self, inst)
    inst:DoTaskInTime(0, function()
        if inst.prefab and not self.TimeMultipliers[inst.prefab] then
            self.TimeMultipliers[inst.prefab] = default_regrowth_fn --给每个植物一个默认的再生时间，不然没定义的会报错
        end
    end)
end)
