local PlantRegrowth = require "components/plantregrowth"

PlantRegrowth.TimeMultipliers["mushtree_yelow"] = function()
    return TUNING.MUSHTREE_REGROWTH_TIME_MULT * ((not TheWorld.state.autumn and 0) or 1)
end
