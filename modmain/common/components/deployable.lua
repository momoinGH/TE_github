local Utils = require("tropical_utils/utils")

local function IsSpecialTile(tile)
    local isCave = TheWorld:HasTag("cave")
    return tile == GROUND.UNDERWATER_SANDY
        or tile == GROUND.UNDERWATER_ROCKY
        or (isCave and (tile == GROUND.BEACH
            or tile == GROUND.MAGMAFIELD
            or tile == GROUND.PAINTED
            or tile == GROUND.BATTLEGROUNDS
            or tile == GROUND.PEBBLEBEACH
            or tile == GROUND.ICELAND
            or tile == GROUND.SNOWLAND
        ))
end

local function DeployableCanDeployBefore(self, pt)
    if self.tro_force_deploy then
        return { true }, true
    end

    local tile = TheWorld.Map:GetTileAtPoint(pt:Get())
    return { false }, IsSpecialTile(tile)
end

local function TroForceDeploy(self, ...)
    self.tro_force_deploy = true
    local result = self:Deploy(...)
    self.tro_force_deploy = false
    return result
end

AddComponentPostInit("deployable", function(self)
    self.tro_force_deploy = false --不检查放置条件

    self.TroForceDeploy = TroForceDeploy
    Utils.FnDecorator(self, "CanDeploy", DeployableCanDeployBefore)
end)
