require 'map/terrain'
local tiledefs = require 'worldtiledefs'
modimport 'tiledescription.lua'

local newTilesProperties = SetInfo() --Loading data from tiledescription.lua
local minStartID = 33                -- 1-32 is reserved by game
local Utils = require("tropical_utils/utils")

print("Strating Tileadder")

--Logic. It works, I think. It is not necessary to change anything
local function GroundTextures(name) return "levels/textures/noise_" .. name .. ".tex" end
local function MiniGroundTextures(name) return "levels/textures/mini_noise_" .. name .. ".tex" end



local function GroundImage(name)
    if name == "underwater_sandy" then return "levels/tiles/cave.tex" end
    if name == "underwater_rocky" then return "levels/tiles/marsh.tex" end

    if name == "magmafield" then return "levels/tiles/cave.tex" end
    if name == "ash" then return "levels/tiles/cave.tex" end
    if name == "volcano" then return "levels/tiles/cave.tex" end

    if name == "jungle" then return "levels/tiles/jungle.tex" end
    if name == "meadow" then return "levels/tiles/jungle.tex" end
    if name == "plains" then return "levels/tiles/jungle.tex" end
    if name == "fields" then return "levels/tiles/jungle.tex" end

    if name == "deeprainforest" then return "levels/tiles/deeprainforest.tex" end
    if name == "battleground" then return "levels/tiles/deeprainforest.tex" end
    if name == "gasjungle" then return "levels/tiles/deeprainforest.tex" end
    if name == "painted" then return "levels/tiles/deeprainforest.tex" end

    if name == "suburb" then return "levels/tiles/deciduous.tex" end
    if name == "snakeskinfloor" then return "levels/tiles/carpet.tex" end

    if name == "beach" then return "levels/tiles/beach.tex" end
    if name == "tidalmarsh" then return "levels/tiles/beach.tex" end

    if name == "beardrug" then return "levels/tiles/rocky.tex" end
    if name == "checkeredlawn" then return "levels/tiles/cobbleroad.tex" end
    if name == "foundation" then return "levels/tiles/blocky.tex" end
    if name == "pigruins" then return "levels/tiles/carpet.tex" end


    if name == "hamarchive" then return "levels/tiles/deeprainforest.tex" end
    --[[


if name == "rainforest" 		then return "levels/tiles/rainforest.tex" end

if name == "cobbleroad" 		then return "levels/tiles/cobbleroad.tex" end

if name == "water_mangrove" 	then return "levels/tiles/water_mangrove.tex" end


if name == "antfloor" 			then return "levels/tiles/antfloor.tex" end
if name == "batfloor" 			then return "levels/tiles/batfloor.tex" end

]]
    return "levels/tiles/" .. name .. ".tex"
end



local function GroundAtlas(name)
    if name == "underwater_sandy" then return "levels/tiles/cave.xml" end
    if name == "underwater_rocky" then return "levels/tiles/marsh.xml" end

    if name == "magmafield" then return "levels/tiles/cave.xml" end
    if name == "ash" then return "levels/tiles/cave.xml" end
    if name == "volcano" then return "levels/tiles/cave.xml" end

    if name == "jungle" then return "levels/tiles/jungle.xml" end
    if name == "meadow" then return "levels/tiles/jungle.xml" end
    if name == "plains" then return "levels/tiles/jungle.xml" end
    if name == "fields" then return "levels/tiles/jungle.xml" end

    if name == "deeprainforest" then return "levels/tiles/deeprainforest.xml" end
    if name == "battleground" then return "levels/tiles/deeprainforest.xml" end
    if name == "gasjungle" then return "levels/tiles/deeprainforest.xml" end
    if name == "painted" then return "levels/tiles/deeprainforest.xml" end

    if name == "suburb" then return "levels/tiles/deciduous.xml" end
    if name == "snakeskinfloor" then return "levels/tiles/carpet.xml" end

    if name == "tidalmarsh" then return "levels/tiles/beach.xml" end
    if name == "beach" then return "levels/tiles/beach.xml" end
    if name == "beardrug" then return "levels/tiles/rocky.xml" end
    if name == "checkeredlawn" then return "levels/tiles/cobbleroad.xml" end
    if name == "foundation" then return "levels/tiles/blocky.xml" end
    if name == "pigruins" then return "levels/tiles/carpet.xml" end


    if name == "hamarchive" then return "levels/tiles/deeprainforest.xml" end
    --[[


if name == "rainforest" 		then return "levels/tiles/rainforest.xml" end


if name == "water_mangrove" 	then return "levels/tiles/water_mangrove.xml" end

if name == "antfloor" 			then return "levels/tiles/antfloor.xml" end
if name == "batfloor" 			then return "levels/tiles/batfloor.xml" end

]]
    return "levels/tiles/" .. name .. ".xml"
end


-- local function FirstToUpper( str )           return ( str:gsub("^%l", string.upper) )                    end

local is_multiworlds_enabled = GLOBAL.KnownModIndex:IsModEnabled("workshop-726432903")

function AddTiles()
    for tilename, data in pairs(newTilesProperties) do
        _G.assert(_G.type(tilename) == "string", "Name should be a string parameter")
        _G.assert(_G.type(data.specs) == "table", "Specs should be a table parameter")

        local mapspecs = data.specs
        local layer = _G.type(data.layer) == "number" and data.layer or nil
        if layer and (layer < 0 or layer >= 255) then
            return error(("Layer level shoud be in range 1..255, now it is %d"):format(layer))
        end

        local chk = true
        local tile_id = minStartID
        local j = 1
        while chk do
            chk = false
            for _, val2 in pairs(tiledefs.ground) do
                if val2[1] == tile_id or (is_multiworlds_enabled and tile_id >= 50 and tile_id < 68) then
                    -- print(tile_id, "is reserved, incrementing...")
                    tile_id = tile_id + 1
                    chk = true
                end
            end
        end

        if tile_id >= GROUND.UNDERGROUND then
            return error(("Numerical id %d is out of limits"):format(tile_id, GROUND.UNDERGROUND), 3)
        end

        -- print("lowest founded value:", tile_id)
        ------------------------------------------------------

        GROUND[string.upper(tilename)] = tile_id
        WORLD_TILES[string.upper(tilename)] = tile_id
        GROUND_NAMES[tile_id] = tilename
        GROUND_FLOORING[tile_id] = data.isfloor

        if data.hard then --不能种植
            GROUND_HARD[tile_id] = true
        end
        if data.cannotbedug then --不能用草叉挖掉
            TERRAFORM_IMMUNE[tile_id] = true
        end

        mapspecs = mapspecs or {}


        local tileSpecDefault = {
            name = "carpet",
            noise_texture = GroundTextures(tilename),
            runsound = "dontstarve/movement/run_dirt",
            walksound = "dontstarve/movement/walk_dirt",
            snowsound = "dontstarve/movement/run_ice",
            mudsound = "dontstarve/movement/run_mud",
            flashpoint_modifier = 0,
            colors =
            {
                primary_color = { 0, 0, 0, 25 },
                secondary_color = { 0, 20, 33, 0 },
                secondary_color_dusk = { 0, 20, 33, 80 },
                minimap_color = { 23, 51, 62, 102 },
            },
        }

        local realMapspecs = {}

        for k, spec in pairs(mapspecs) do
            realMapspecs[k] = spec
        end

        for k, default in pairs(tileSpecDefault) do --adding defaults, if not setted
            if realMapspecs[k] == nil then
                realMapspecs[k] = default
            end
        end

        if layer then
            table.insert(tiledefs.ground, layer, { tile_id, realMapspecs })
        else
            table.insert(tiledefs.ground, { tile_id, realMapspecs })
        end
        table.insert(tiledefs.assets, Asset("IMAGE", realMapspecs.noise_texture))
        table.insert(tiledefs.assets, Asset("IMAGE", GroundImage(realMapspecs.name)))
        table.insert(tiledefs.assets, Asset("FILE", GroundAtlas(realMapspecs.name)))
        -- print("tile", tilename, "added!")
    end
end

function AddMinimap()
    local addedTilesTurfInfo = {}
    local minimapGroundProperties = {}

    for tilename, data in pairs(newTilesProperties) do
        local groundID = nil
        for k, v in pairs(GROUND_NAMES) do
            --print(k, v, tilename)
            if v == tilename then
                groundID = k
                break
            end
        end
        table.insert(Assets, Asset("IMAGE", GroundTextures(tilename)))
        table.insert(Assets, Asset("IMAGE", MiniGroundTextures(tilename)))
        table.insert(Assets, Asset("IMAGE", GroundImage(tilename)))
        table.insert(Assets, Asset("FILE", GroundImage(tilename)))
        table.insert(minimapGroundProperties,
            { groundID, { name = "map_edge", noise_texture = MiniGroundTextures(tilename) } })

        if data.turf then
            _G.assert(_G.type(data.turf) == "table")
            addedTilesTurfInfo[groundID] = data.turf
        end
    end

    --Adding layers info for the minimap. Tiles will work without it, but the minimap will got empty spaces.
    AddPrefabPostInit("minimap", function(inst)
        for _, data in pairs(minimapGroundProperties) do
            local tile_type, layer_properties = unpack(data)
            -- print(layer_properties.name, GroundAtlas(layer_properties.name))
            local handle = _G.MapLayerManager:CreateRenderLayer(
                tile_type,
                resolvefilepath(GroundAtlas(layer_properties.name)),
                resolvefilepath(GroundImage(layer_properties.name)),
                resolvefilepath(layer_properties.noise_texture)
            )
            inst.MiniMap:AddRenderLayer(handle)
        end
    end)

    -- 根据地皮id生成地皮物品，应对terraformer组件和autoterraformer组件
    Utils.FnDecorator(GLOBAL, "HandleDugGround", function(dug_ground, x, y, z)
        if addedTilesTurfInfo[dug_ground] then
            for k, lootinfo in pairs(addedTilesTurfInfo[dug_ground]) do
                local min = lootinfo[2] or 1
                local max = lootinfo[3] or min
                for i = 1, math.random(min, max) do
                    local loot = SpawnPrefab(lootinfo[1])
                    if loot.components.inventoryitem ~= nil then
                        loot.components.inventoryitem:InheritWorldWetnessAtXZ(x, z)
                    end
                    loot.Transform:SetPosition(x, y, z)
                    if loot.Physics ~= nil then
                        local angle = math.random() * TWOPI
                        loot.Physics:SetVel(2 * math.cos(angle), 10, 2 * math.sin(angle))
                    end
                end
            end
            return nil, true
        end
    end)
end
