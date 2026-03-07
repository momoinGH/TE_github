-- 增加码头可以放置的地皮
local function IsPermanentOrDockFilterFn(tileid)
    return IsLandTile(tileid) and not (TileGroupManager:IsTemporaryTile(tileid) and tileid ~= WORLD_TILES.FARMING_SOIL and tileid ~= WORLD_TILES.MONKEY_DOCK)
end

-- 可以放码头的地皮
local can_deploy_tiles = {
    [WORLD_TILES.OCEAN_COASTAL_SHORE] = true,
    [WORLD_TILES.OCEAN_COASTAL] = true,
    [WORLD_TILES.OCEAN_SHALLOW_SHORE] = true,
    [WORLD_TILES.OCEAN_SHALLOW] = true,
    [WORLD_TILES.MANGROVE] = true,
    [WORLD_TILES.LILYPOND] = true,
}

local function CLIENT_CanDeployDockKit(inst, pt, mouseover, deployer, rotation)
    local x, y, z = pt:Get()
    local tile = TheWorld.Map:GetTileAtPoint(x, 0, z)
    if not can_deploy_tiles[tile] then
        return false
    end


    local tx, ty = TheWorld.Map:GetTileCoordsAtPoint(x, 0, z)
    if not TheWorld.Map:HasAdjacentTileFiltered(tx, ty, IsPermanentOrDockFilterFn) then
        return false
    end

    local center_pt = Vector3(TheWorld.Map:GetTileCenterPoint(tx, ty))
    return TheWorld.Map:CanDeployDockAtPoint(center_pt, inst, mouseover)
end

AddPrefabPostInit("dock_kit", function(inst)
    inst._custom_candeploy_fn = CLIENT_CanDeployDockKit
end)
