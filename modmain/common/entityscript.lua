require("entityscript")

function EntityScript:IsInTropicalArea()
    return TheWorld.Map:IsTropicalAreaAtPoint(self:GetPosition():Get())
end

function EntityScript:IsInShipwreckedArea()
    return TheWorld.Map:IsShipwreckedAreaAtPoint(self:GetPosition():Get())
end

function EntityScript:IsInHamletArea()
    return TheWorld.Map:IsHamletAreaAtPoint(self:GetPosition():Get())
end

function EntityScript:IsInVolcanoArea()
    return TheWorld.Map:IsVolcanoAreaAtPoint(self:GetPosition():Get())
end

function EntityScript:IsInWorld()
    local x, y, z = self.Transform:GetWorldPosition()
    return math.abs(x) <= 1350 and math.abs(z) <= 1350
    -- local width, height = TheWorld.Map:GetWorldSize()
    -- local x, y, z = self.Transform:GetWorldPosition()
    -- local tile_x, tile_y = TheWorld.Map:GetTileCoordsAtPoint(x, 0, z)

    -- return tile_x <= width and tile_y <= height

    -- local nx = (tile_x - width / 2) * TILE_SCALE
    -- local nz = (tile_y - height / 2) * TILE_SCALE
    -- local worldwidth, worldheight = TheWorld.Map:GetWorldSize()
    -- local x, y, z = self.Transform:GetWorldPosition()
    -- return math.abs(x) <= worldwidth and math.abs(z) <= worldheight
    -- return true
end

function EntityScript:IsOnLandTile()
    return TheWorld.Map:IsLandTileAtPoint(self.Transform:GetWorldPosition())
end

----area aware related--------------------
function EntityScript:AwareInTropicalArea() ----减少计算量
    return self.components.areaaware and
        (self.components.areaaware:CurrentlyInTag("tropical")
            or self.components.areaaware:CurrentlyInTag("ForceDisconnected")) and
        true or false
end

function EntityScript:AwareInShipwreckedArea()
    local aware = self.components.areaaware and self.components.areaaware:CurrentlyInTag("shipwrecked") and true
    return aware or false
end

function EntityScript:AwareInHamletArea()
    local aware = self.components.areaaware and self.components.areaaware:CurrentlyInTag("hamlet") and true
    return aware or false
end

function EntityScript:AwareInVolcanoArea()
    local aware = self.components.areaaware and self.components.areaaware:CurrentlyInTag("volcano") and true
    return aware or false
end
