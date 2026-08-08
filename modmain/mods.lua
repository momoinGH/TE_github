-- for client mod ActionQueue
AddComponentPostInit("actionqueuer", function(self)
    if self.AddActionList then
        self.AddActionList("allclick", "HACK")
        self.AddActionList("leftclick", "HACK")
        self.AddActionList("autocollect", "HACK")
        self.AddActionList("noworkdelay", "HACK")
    end
end)

---覆盖Insight海上气泡提醒
local st, whalehunter = pcall(require, "descriptors/whalehunter")
if st and whalehunter ~= nil and whalehunter.OnServerLoad ~= nil then
    whalehunter.OnServerLoad = function() end
end

require("components/map")
function Map:IsWater(tile) -- 给几何mod用的，群鸟也用了这个方法
    return TileGroupManager:IsOceanTile(tile)
end
