-- require("constants")
-- require("mathutil")


-- local TOPOLOGY_SAVE = nil --只能通过hook拿到topology_save
-- local STORYGEN = nil

-- local old_buildstory = BuildStory
-- BuildStory = function(tasks, story_gen_params, level)
--     TOPOLOGY_SAVE, STORYGEN = old_buildstory(tasks, story_gen_params, level)
--     return TOPOLOGY_SAVE, STORYGEN
-- end


-- local forest_map = require("map/forest_map")
-- local make_cities = require("map/tro_city_builder")
-- local old_generatemap = forest_map.Generate
-- forest_map.Generate = function(prefab, map_width, map_height, tasks, level, level_type, ...)
--     local save = old_generatemap(prefab, map_width, map_height, tasks, level, level_type, ...)
--     if save == nil then return save end

--     -- if level.location ~= "forest" then return save end
--     -- if not TUNING.hamlet then return save end

--     --------------------building porkland cities---------------------------------------------------------------------
--     print("Building porkland cities!")
--     make_cities(save.ents, TOPOLOGY_SAVE, save.map.width, save.map.height)
--     local current_gen_params = deepcopy(level.overrides)
--     local join_islands = not current_gen_params.no_joining_islands
--     save.map.tiles, save.map.tiledata, save.map.nav, save.map.adj, save.map.nodeidtilemap = WorldSim:GetEncodedMap(join_islands) ----这是存储地形数据的关键
--     ----mapwidth,height在其中发生过改变
--     -----------------------------------------------------------------------------------------------------------------
--     return save
-- end
