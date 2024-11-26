local Utils = require("tropical_utils/utils")

-- 控制鸟生成逻辑

local BIRD_TYPES
-- 有的鸟预制件没有定义，这里要判断一下再添加，不然生成的时候会报错
local function AddBirds(tile, vals)
    local birds = {}
    for _, v in ipairs(vals) do
        if GLOBAL.Prefabs[v] then
            table.insert(birds, v)
        end
    end
    BIRD_TYPES[tile] = birds
end

AddComponentPostInit("birdspawner", function(self)
    if not BIRD_TYPES then
        BIRD_TYPES = Utils.ChainFindUpvalue(self.SpawnBird, "PickBird", "BIRD_TYPES")
        if BIRD_TYPES then
            AddBirds(WORLD_TILES.OCEAN_COASTAL, { "puffin", "cormorant" })
            AddBirds(WORLD_TILES.OCEAN_COASTAL_SHORE, { "puffin", "cormorant" })
            AddBirds(WORLD_TILES.OCEAN_SWELL, { "puffin", "cormorant", "seagullwater" })
            AddBirds(WORLD_TILES.OCEAN_ROUGH, { "puffin", "seagullwater", "cormorant" })
            AddBirds(WORLD_TILES.OCEAN_BRINEPOOL, { "puffin", "seagullwater" })
            AddBirds(WORLD_TILES.OCEAN_BRINEPOOL_SHORE, { "puffin" })
            AddBirds(WORLD_TILES.OCEAN_HAZARDOUS, { "puffin", "seagullwater" })


            --AddBirds(WORLD_TILES.ASH, { "toucan" })				
            AddBirds(WORLD_TILES.BEACH, { "toucan" })			
            AddBirds(WORLD_TILES.JUNGLE, { "parrot", "parrot_pirate" })			
            AddBirds(WORLD_TILES.MAGMAFIELD, { "toucan" })			
            AddBirds(WORLD_TILES.MEADOW, { "parrot", "toucan", "parrot_pirate" })			
            --AddBirds(WORLD_TILES.SNAKESKINFLOOR, { "parrot", "toucan", "parrot_pirate" })				
            AddBirds(WORLD_TILES.TIDALMARSH, { "toucan" })
            --AddBirds(WORLD_TILES.VOLCANO, { "toucan" })	
            --AddBirds(WORLD_TILES.VOLCANO_ROCK, { "toucan" })	


            --AddBirds(WORLD_TILES.ANTCAVE, { "robin", "crow" })
            --AddBirds(WORLD_TILES.BATCAVE, { "robin", "crow" })
			--AddBirds(WORLD_TILES.BATTLEGROUNDS, { "robin", "crow" })
			--AddBirds(WORLD_TILES.COBBLEROAD, { "robin", "crow" })
            AddBirds(WORLD_TILES.DEEPRAINFOREST, { "toucan_hamlet", "parrot_blue", "kingfisher", "kingfisher_swarm","toucan_hamlet_swarm", "parrot_blue_swarm" })			
            AddBirds(WORLD_TILES.FIELDS, { "robin", "crow" })
            AddBirds(WORLD_TILES.FOUNDATION, { "quagmire_pigeon", "crow", "pigeon_swarm" })
            AddBirds(WORLD_TILES.GASRAINFOREST, { "parrot_blue", "parrot_blue_swarm" })
            --AddBirds(WORLD_TILES.LAWN, { "robin", "crow" })
            AddBirds(WORLD_TILES.MOSS, { "robin", "crow", "quagmire_pigeon", "pigeon_swarm" })
            AddBirds(WORLD_TILES.PAINTED, { "kingfisher", "crow", "kingfisher_swarm" })
            --AddBirds(WORLD_TILES.PIGRUINS, { "robin", "crow" })
            AddBirds(WORLD_TILES.PLAINS, { "robin", "crow", "kingfisher", "kingfisher_swarm" })
            AddBirds(WORLD_TILES.RAINFOREST, { "toucan_hamlet", "kingfisher", "parrot_blue", "kingfisher_swarm","toucan_hamlet_swarm", "parrot_blue_swarm" })


            AddBirds(WORLD_TILES.QUAGMIRE_PEATFOREST, { "quagmire_pigeon", "pigeon_swarm" })
            AddBirds(WORLD_TILES.QUAGMIRE_PARKFIELD, { "quagmire_pigeon", "pigeon_swarm" })
            AddBirds(WORLD_TILES.QUAGMIRE_PARKSTONE, { "quagmire_pigeon", "pigeon_swarm" })
            AddBirds(WORLD_TILES.QUAGMIRE_GATEWAY, { "quagmire_pigeon", "pigeon_swarm" })
            AddBirds(WORLD_TILES.QUAGMIRE_SOIL, { "quagmire_pigeon", "pigeon_swarm" })
            AddBirds(WORLD_TILES.QUAGMIRE_CITYSTONE, { "quagmire_pigeon", "pigeon_swarm" })
            AddBirds(WORLD_TILES.IMPASSABLE, {}) --不生成鸟
            AddBirds(WORLD_TILES.INVALID, {})    --不生成鸟
            --AddBirds(WORLD_TILES.WATER_MANGROV, { "robin_winter" })
            --AddBirds(WORLD_TILES.ANTFLOOR, { "robin_winter" })
            AddBirds(WORLD_TILES.WINDY, { "goddess_bird" })

            if KnownModIndex:IsModEnabled("workshop-1289779251") then --樱花林
                AddBirds(WORLD_TILES.CHERRY, { "catbird", "crow" })
                AddBirds(WORLD_TILES.CHERRY2, { "chaffinch", "robin" })
                AddBirds(WORLD_TILES.CHERRY3, { "catbird" })
                AddBirds(WORLD_TILES.CHERRY4, { "chaffinch" })
            end
        end
    end
end)
