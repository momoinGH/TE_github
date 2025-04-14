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
    local tile = TheWorld.Map:GetTileAtPoint(pt:Get())
    return { false }, IsSpecialTile(tile)
end

local function ForceDeploy(self, pt, deployer)
    if self.ondeploy ~= nil then
        self.ondeploy(self.inst, pt, deployer)
    end
    -- self.inst is removed during ondeploy
    deployer:PushEvent("deployitem", { prefab = self.inst.prefab })
    return true
end

AddComponentPostInit("deployable", function(self)
    self.ForceDeploy = ForceDeploy

    Utils.FnDecorator(self, "CanDeploy", DeployableCanDeployBefore)
end)
