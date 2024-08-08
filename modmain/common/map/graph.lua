require("map/network")
local Utils = require("tropical_utils/utils")

local function GlobalPostPopulateAfter(retTab, root, entities, width, height)
    local numTriangles = 12
    local minDistSq = 50 * 50

    if entities.bermudatriangle_MARKER == nil then
        entities.bermudatriangle_MARKER = {}
    end

    local function checkTriangle(tile, x, y, points)
        if tile ~= WORLD_TILES.OCEAN_SWELL
            and tile ~= WORLD_TILES.OCEAN_DEEP
        then
            return false
        end
        for i = 1, #points, 1 do
            local dx = x - points[i].x
            local dy = y - points[i].y
            local dsq = dx * dx + dy * dy

            if dsq < minDistSq then
                return false
            end
        end
        return true
    end

    local pointsX, pointsY = SpawnUtil.FindRandomWaterPoints(checkTriangle, width, height, TUNING.MAPEDGE_PADDING,
        numTriangles)

    for i = 1, #pointsX, 1 do
        local entData = {}
        entData.x = (pointsX[i] - width / 2.0) * TILE_SCALE
        entData.z = (pointsY[i] - height / 2.0) * TILE_SCALE
        table.insert(entities.bermudatriangle_MARKER, entData)
    end
    ---------------------------------
    print(#entities.bermudatriangle_MARKER .. " points for bermudatriangle")
    if #entities.bermudatriangle_MARKER < 2 then return print("WARNING: Not enough points for new bermudatriangle") end

    if entities.bermudatriangle == nil then
        entities.bermudatriangle = {}
    end

    local id = root.MIN_WORMHOLE_ID
    local pair = 0
    minDistSq = minDistSq * TILE_SCALE
    local is_farenough = function(marker1, marker2)
        local diffx, diffz = marker2.x - marker1.x, marker2.z - marker1.z
        local mag = diffx * diffx + diffz * diffz
        if mag < minDistSq then
            return false
        end
        return true
    end

    for i = #entities.bermudatriangle_MARKER, 1, -1 do
        local firstMarkerData = entities.bermudatriangle_MARKER[i]
        if firstMarkerData ~= nil then
            for j = #entities.bermudatriangle_MARKER, 1, -1 do
                local secondMarkerData = entities.bermudatriangle_MARKER[j]
                if secondMarkerData ~= nil and i ~= j and is_farenough(firstMarkerData, secondMarkerData) then
                    firstMarkerData["id"] = id
                    secondMarkerData["id"] = id + 1
                    id = id + 2
                    pair = pair + 1

                    firstMarkerData["data"] = { teleporter = { target = secondMarkerData["id"] } }
                    secondMarkerData["data"] = { teleporter = { target = firstMarkerData["id"] } }

                    table.insert(entities.bermudatriangle, firstMarkerData)
                    table.insert(entities.bermudatriangle, secondMarkerData)

                    entities.bermudatriangle_MARKER[i] = nil
                    entities.bermudatriangle_MARKER[j] = nil
                    break
                end
            end

            if pair > 6 --[[ IAENV.max_pairs and pair >= IAENV.max_pairs ]] then
                break
            end
        end
    end

    print(pair .. " bermudatriangle pairs placed.")

    root.MIN_WORMHOLE_ID = id
    entities.bermudatriangle_MARKER = nil
end

Utils.FnDecorator(Graph, "GlobalPostPopulate", nil, GlobalPostPopulateAfter)
