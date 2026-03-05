local Utils = require("tropical_utils/utils")
-- 在室内不会落水
local function DrownableShouldDrownBefore(self)
    local x, y, z = self.inst.Transform:GetWorldPosition()
    if #TheSim:FindEntities(x, y, z, 30, { "interior_center" }) > 0 then
        return { false }, true
    end
end

AddComponentPostInit("drownable", function(self)
    Utils.FnDecorator(self, "ShouldDrown", DrownableShouldDrownBefore)
end)
