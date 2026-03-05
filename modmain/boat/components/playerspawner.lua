-- 加载的时候找找附近的船，不让玩家掉水里，需要在玩家设置完坐标并且在DoTaskInTime(0)之前设置小船
local function SpawnAtLocationAfter(retTab, self, inst, player, x, y, z, isloading)
    if not isloading then
        return retTab
    end

    x, y, z = player.Transform:GetWorldPosition()
    if not player.components.pro_driver.boat and TheWorld.Map:IsOceanAtPoint(x, y, z, false) then
        local boat = FindClosestEntity(player, 0.5, function(ent) return not ent.parent end, { "shipwrecked_boat" }, { "INLIMBO" })
        if boat then
            player.components.pro_driver:SetBoat(boat)
        end
    end

    return retTab
end

AddComponentPostInit("playerspawner", function(self)
    Utils.FnDecorator(self, "SpawnAtLocation", nil, SpawnAtLocationAfter)
end)
