local Utils = require("tropical_utils/utils")

local FX_MAP
AddComponentPostInit("spooked", function(self)
    if not FX_MAP then
        FX_MAP = Utils.ChainFindUpvalue(self.Spook, "FX_MAP")
        if FX_MAP then
            FX_MAP["mushtree_yellow"] = "mushtree_yellow"
        end
    end
end)
