AddPrefabPostInitAny(function(inst)
    -----mostra neve--------------
    if inst:HasTag("SnowCovered") then
        inst:DoTaskInTime(0.5, function(inst)
            local map = TheWorld.Map
            local x, y, z = inst.Transform:GetWorldPosition()
            local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))
            if ground == WORLD_TILES.SNOWLAND or ground == WORLD_TILES.ICELAND then
                inst:AddTag("mostraneve")
            end
        end)
    end

    if not TheWorld.ismastersim then return end

    if TheWorld.components.tro_tempentitytracker and TheWorld.components.tro_tempentitytracker:KeyExists(inst.prefab) then
        TheWorld.components.tro_tempentitytracker:OnEntSpawned(inst)
    end
end)