local MapTags = { "frost", "tropical", "hamlet", "shipwrecked", "volcano", "underwater" }
local GlobalMapTags = { "City1", "City2", "City_Foundation", "Suburb", "Cultivated" }

AddGlobalClassPostConstruct("map/storygen", "Story", function(self)
    for k, v in pairs(MapTags) do
        self.map_tags.Tag[v] = function(tagdata) return "TAG", v end
    end

    for k, v in pairs(GlobalMapTags) do
        self.map_tags.Tag[v] = function(tagdata) return "GLOBALTAG", v end
    end
end)

require("map/storygen")



TOPOLOGY_SAVE = nil
STORYGEN = nil

local old_buildstory = BuildStory
BuildStory = function(tasks, story_gen_params, level)
    TOPOLOGY_SAVE, STORYGEN = old_buildstory(tasks, story_gen_params, level)
    print("BuildStory data has been saved!")
    return TOPOLOGY_SAVE, STORYGEN
end




