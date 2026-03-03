AddComponentPostInit("playerspawner", function(self)
    local OldSpawnAtLocation = self.SpawnAtLocation
    function self:SpawnAtLocation(inst, player, x, y, z, isloading, ...)
        -- local portal
        if not isloading then
            -- portal = TheSim:FindFirstEntityWithTag("multiplayer_portal") --  multiplayer_portal  constructionsite
            -- if portal ~= nil then
            --     x, y, z = portal.Transform:GetWorldPosition()
            -- end

            -------------添加出生物品---------------修改为DOTAskintime或许会更好
            local startitem
            if TUNING.sw_start == true then
                startitem = "porto_raft_old"
            elseif TUNING.ham_start == true then
                startitem = "machete"
            end

            if startitem then
                local item = SpawnPrefab(startitem)
                if item then
                    player.components.inventory:GiveItem(item)
                end
            end
        end
        OldSpawnAtLocation(self, inst, player, x, y, z, isloading, ...)
    end
end)
