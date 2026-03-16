local function IsSpecialTile(tile)
    local isCave = TheWorld:HasTag("cave")
    return tile == WORLD_TILES.UNDERWATER_SANDY
        or tile == WORLD_TILES.UNDERWATER_ROCKY
        or (isCave and (tile == WORLD_TILES.BEACH
            or tile == WORLD_TILES.MAGMAFIELD
            or tile == WORLD_TILES.PAINTED
            or tile == WORLD_TILES.BATTLEGROUNDS
            or tile == WORLD_TILES.PEBBLEBEACH
            or tile == WORLD_TILES.ICELAND
            or tile == WORLD_TILES.SNOWLAND
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
    Hooks.FnDecorator(self, "CanDeploy", DeployableCanDeployBefore)
end)
