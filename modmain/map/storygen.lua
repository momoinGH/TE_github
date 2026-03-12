require("map/storygen")

-- 追加标签处理函数，每个自定义标签需要有一个处理函数

local MapTags = { "frost", "hamlet", "shipwrecked", "tropical", "underwater", "folha", "volcano" }
local GlobalMapTags = { "City1", "City2", "City_Foundation", "Cultivated", "Suburb" }
AddGlobalClassPostConstruct("map/storygen", "Story", function(self)
    -- 标签，可用来判断room类型，也可用于areaaware:CurrentlyInTag判断玩家是否在某个区域
    for k, v in pairs(MapTags) do
        self.map_tags.Tag[v] = function(tagdata) return "TAG", v end
    end

    -- 全局标签，当世界生成时包含了含有该标签的room后，便可以通过GlobalTags判断是否包含了该room并拿到对应的task和room
    for k, v in pairs(GlobalMapTags) do
        self.map_tags.Tag[v] = function(tagdata) return "GLOBALTAG", v end
    end
end)
