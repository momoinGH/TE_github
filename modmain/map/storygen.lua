require("map/storygen")

-- 科雷标签说明：
-- ExitPiece：好像是一个废弃标签，单机遗留的传送门相关零件


-- 追加标签处理函数，每个自定义标签需要有一个处理函数
-- 可用来判断room类型，也可用于areaaware:CurrentlyInTag判断玩家是否在某个区域
local MapTags = {
    "frost",       --冰岛区域
    "hamlet",      --哈姆雷特区域
    "shipwrecked", --海难区域
    "tropical",
    "underwater",  --海底区域
    "folha",
    "volcano",     --火山区域


    "Canopy", --树冠覆盖区域标签，玩家在这个区域顶部有树叶UI
}

-- 全局标签，当世界生成时包含了含有该标签的room后，便可以通过GlobalTags判断是否包含了该room并拿到对应的task和room
local GlobalMapTags = {
    -- 哈姆雷特标签
    "City1",           --城1
    "City2",           --城2
    "City_Foundation", --城镇区域，用来辅助生成城镇
    "Cultivated",      --耕地地区，如果这些区域没有瞭望塔就加一个瞭望塔
    -- "Suburb",          --城镇郊区，单机加了但是无实际用处，这里不使用
    "Bramble",         --生成荆棘使用
}
AddGlobalClassPostConstruct("map/storygen", "Story", function(self)
    for k, v in pairs(MapTags) do
        self.map_tags.Tag[v] = function(tagdata) return "TAG", v end
    end
    for k, v in pairs(GlobalMapTags) do
        self.map_tags.Tag[v] = function(tagdata) return "GLOBALTAG", v end
    end
end)
