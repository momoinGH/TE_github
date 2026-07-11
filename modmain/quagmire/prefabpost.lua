modimport "modmain/quagmire/prefabs/firepit"
modimport "modmain/quagmire/prefabs/fishingrod.lua"

AddPrefabPostInit("saltrock", function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("mealable")
    inst.components.mealable:SetType("salt")
end)



require("components/map")
-- 暴食的耕地地皮可以耕地
local OldIsFarmableSoilAtPoint = Map.IsFarmableSoilAtPoint
function Map:IsFarmableSoilAtPoint(x, y, z, ...)
    local res = OldIsFarmableSoilAtPoint(self, x, y, z, ...)
    if res then
        return res
    end

    return self:GetTileAtPoint(x, y, z) == WORLD_TILES.QUAGMIRE_SOIL
end
