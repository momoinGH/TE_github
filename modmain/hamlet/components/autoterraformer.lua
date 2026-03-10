--希望刮地皮头盔忽略的地皮
local antlion_ignore_tiles = {
    [WORLD_TILES.GASRAINFOREST] = true,
    [WORLD_TILES.DEEPRAINFOREST] = true
}
AddComponentPostInit("autoterraformer", function(self)
    Hooks.FnDecorator(self, "DoTerraform", function(_self, px, py, pz, _x, _y)
        local tile = TheWorld.Map:GetTileAtPoint(px, py, pz)
        if antlion_ignore_tiles[tile] then
            return nil, true
        end
    end)
end)
