local Utils = require("tropical_utils/utils")
local InteriorSpawnerUtils = require("interiorspawnerutils")
require "components/map"

local CANT_DEPLOY_TILES = {
    [WORLD_TILES.UNDERWATER_SANDY] = true,
    [WORLD_TILES.UNDERWATER_ROCKY] = true,
}

local CANT_DEPLOY_IN_CAVE_TILES = {
    [WORLD_TILES.BEACH] = true,
    [WORLD_TILES.MAGMAFIELD] = true,
    [WORLD_TILES.PAINTED] = true,
    [WORLD_TILES.BATTLEGROUND] = true,
    [WORLD_TILES.PEBBLEBEACH] = true,
}

Utils.FnDecorator(Map, "CanDeployRecipeAtPoint", function(self, pt, recipe, rot)
    local x, _, z = pt:Get()
    -- 地皮限制
    local tile = TheWorld.Map:GetTileAtPoint(x, 0, z)
    if CANT_DEPLOY_TILES[tile] or (TheWorld:HasTag("cave") and CANT_DEPLOY_IN_CAVE_TILES[tile]) then
        return { false }, true
    end
end)

local home = {}     --室内的中心坐标，由于地皮一定在中心
local DIS = 30      --只要不比房子半径小就行
local DIS_SQ = DIS * DIS
local lastHome = {} --缓存，短时间内在一个房间附近求值的可能性较大
-- 室内可放置建筑，物品不会掉入“水”中

local function CheckPointBefore(self, x, y, z)
    if z >= InteriorSpawnerUtils.BASE_OFF - 100 then --判断的基础
        -- 缓存
        if lastHome.home then
            if lastHome.home:IsValid() then
                if VecUtil_DistSq(lastHome.pos[1], lastHome.pos[2], x, z) < DIS_SQ then
                    return { true }, true
                end
            else
                lastHome.home = nil
                lastHome.pos = nil
            end
        end

        -- 缓存表
        for ent, pos in pairs(home) do
            if ent:IsValid() then
                -- print(x, z, pos[1], pos[2], VecUtil_DistSq(pos[1], pos[2], x, z))
                if VecUtil_DistSq(pos[1], pos[2], x, z) < DIS_SQ then
                    lastHome.home = ent
                    lastHome.pos = pos
                    return { true }, true
                end
            else
                home[ent] = nil
            end
        end

        -- 查找
        local ents = TheSim:FindEntities(x, 0, z, DIS, { "interior_center" }) --查找地板
        if #ents > 0 then
            for _, ent in ipairs(ents) do
                local ex, _, ez = ent.Transform:GetWorldPosition()
                ex = ex + 2 --地板中心往下偏移2
                home[ent] = { ex, ez }
                lastHome.home = ent
                lastHome.pos = { ex, ez }
            end
            return { true }, true
        end
    end
end


Utils.FnDecorator(Map, "IsAboveGroundAtPoint", CheckPointBefore)
Utils.FnDecorator(Map, "IsPassableAtPoint", CheckPointBefore)
Utils.FnDecorator(Map, "IsVisualGroundAtPoint", CheckPointBefore)
-- Utils.FnDecorator(Map, "CanPlantAtPoint", CheckPointBefore) --允许房间里种植，不知道算不算超模，如果可以的话，需要处理耕地机等其他问题

-- 虚空也不希望返回一个空值
Utils.FnDecorator(Map, "GetTileCenterPoint", nil, function(retTab, self, x, y, z)
    return next(retTab) and retTab
        or x and z and { math.floor(x / 4) * 4 + 2, 0, math.floor(z / 4) * 4 + 2 }
        or {}
end)
