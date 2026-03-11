require("map/storygen")

local GlobalMapTags = { "City1", "City2", "City_Foundation", "Suburb", "Cultivated" }
local MapTags = { "frost", "hamlet", "shipwrecked", "tropical", "underwater", "folha", "volcano" }
AddGlobalClassPostConstruct("map/storygen", "Story", function(self)
    for k, v in pairs(MapTags) do
        self.map_tags.Tag[v] = function(tagdata) return "TAG", v end
    end

    for k, v in pairs(GlobalMapTags) do
        self.map_tags.Tag[v] = function(tagdata) return "GLOBALTAG", v end
    end
end)
