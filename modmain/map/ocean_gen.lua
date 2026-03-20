require "map/ocean_gen"

-- 不让科雷覆盖mod地形里的海洋地皮
local OldOcean_ConvertImpassibleToWater = Ocean_ConvertImpassibleToWater
GLOBAL.Ocean_ConvertImpassibleToWater = function(width, height, data)
    local tro_tiles = {}

    local world = WorldSim
    for y = 0, height - 1, 1 do
        for x = 0, width - 1, 1 do
            local tile = world:GetTile(x, y)
            if TRO_OCEAN_TILES[tile] then
                table.insert(tro_tiles, { x, y, tile })
            end
        end
    end

    OldOcean_ConvertImpassibleToWater(width, height, data)

    for _, v in ipairs(tro_tiles) do
        world:SetTile(v[1], v[2], v[3])
    end
end
