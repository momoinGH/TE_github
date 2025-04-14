local Utils = require("tropical_utils/utils")
-- 在室内不会落水
local function DrownableShouldDrownBefore(self)
    local x, y, z = self.inst.Transform:GetWorldPosition()
    if #TheSim:FindEntities(x, y, z, 30, { "interior_center" }) > 0 then
        return { false }, true
    end
end


local function ShouldX_InternalCheckAfter(retTab, self)
    if not retTab[1] then return retTab end

    -- 同设置drownable的enabled效果，没有直接改enabled是为了兼容
    local x, y, z = self.inst.Transform:GetWorldPosition()
    if TheWorld.Map:GetSWBoatAtPoint(x, y, z) then
        retTab[1] = false
    end

    return retTab
end

AddComponentPostInit("drownable", function(self)
    Utils.FnDecorator(self, "ShouldX_InternalCheck", nil, ShouldX_InternalCheckAfter)
    Utils.FnDecorator(self, "ShouldDrown", DrownableShouldDrownBefore)
end)