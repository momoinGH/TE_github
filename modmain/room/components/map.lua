local Utils = require("tools/utils")

require("components/map")

local check_size = 1350
local function checkxz(x, z)
    if math.abs(z) >= check_size or math.abs(x) >= check_size then
        return true
    else
        return false
    end
end

local HamHome = {}     --室内的中心坐标，由于地皮一定在中心
local DIS = 28         --室内的最大半径
local lastHamHome = {} --缓冲，短时间内在一个房间附近求值的可能性较大
local roomsize = TUNING.HAMROOM.roomsize
local roomtype = TUNING.HAMROOM.roomtype
-- 室内可放置建筑，物品不会掉入“水”中
local function CheckNearRoomCenter(x, z, v, checkwall)
    if checkxz(x, z) then -----判断一下以减少运算
        local rsize = roomsize[roomtype[v.prefab] or "small"]
        local xx, yy, zz = v.Transform:GetWorldPosition()

        if not checkwall then
            if ((x - xx) <= rsize.front and (x - xx) >= -rsize.back and math.abs(z - zz) <= rsize.side) then
                return true
            end
        else
            if (x - xx) < -(rsize.back - 0.5) and (x - xx) > -(rsize.back + 0.5) and math.abs(z - zz) <= (rsize.side - 2) then ---11
                return "back"
            elseif (z - zz) > (rsize.side - 0.5) and (z - zz) < (rsize.side + 0.5) and (x - xx) <= (rsize.front - 1) and (x - xx) >= -(rsize.back - 1) then
                return "right"
            elseif (zz - z) > (rsize.side - 0.5) and (zz - z) < (rsize.side + 0.5) and (x - xx) <= (rsize.front - 1) and (x - xx) >= -(rsize.back - 1) then
                return "left"
            end
        end
    end

    return false
end

local function IsHamRoomAtPoint(x, y, z, checkwall)
    if type(x) ~= "number" then
        x, y, z = x.x or x, x.y or y, x.z or z
    end

    if not checkxz(x, z) then
        return false --判断的基础，也许光判断z就行了
    end

    -- 缓存
    if lastHamHome.home then
        if lastHamHome.home:IsValid() then
            local isroom = CheckNearRoomCenter(x, z, lastHamHome.home, checkwall)
            if isroom
            --[[VecUtil_DistSq(lastHamHome.pos[1], lastHamHome.pos[2], x, z) < DIS_SQ]] then
                return isroom
            end
        else
            lastHamHome.home = nil
            lastHamHome.pos = nil
        end
    end

    -- 缓存表
    for ent, pos in pairs(HamHome) do
        if ent:IsValid() then
            -- print(x, z, pos[1], pos[2], VecUtil_DistSq(pos[1], pos[2], x, z))
            local isroom = CheckNearRoomCenter(x, z, ent, checkwall)
            if isroom
            --[[VecUtil_DistSq(pos[1], pos[2], x, z) < DIS_SQ]] then
                lastHamHome.home = ent
                lastHamHome.pos = pos
                return isroom
            end
        else
            HamHome[ent] = nil
        end
    end

    -- 查找
    local ents = TheSim:FindEntities(x, 0, z, DIS, { "interior_center" })     --查找地板
    if #ents > 0 then
        for _, ent in ipairs(ents) do
            if ent:IsValid() then
                local ex, _, ez = ent.Transform:GetWorldPosition()
                HamHome[ent] = { ex, ez }
                local isroom = CheckNearRoomCenter(x, z, ent, checkwall)
                if isroom then
                    lastHamHome.home = ent
                    lastHamHome.pos = { ex, ez }
                    return isroom
                end
            end
        end
    end

    return false
end

-----------新的Map函数---------------
Map.IsHamRoomAtPoint = function(self, x, y, z)
    return IsHamRoomAtPoint(x, y, z, false)
end

Map.IsHamRoomWallAtPoint = function(self, x, y, z)
    return IsHamRoomAtPoint(x, y, z, true) --true则检查墙点
end

-- 判断是否在世界外面，一般世界外就是小房子
Map.OutsideWorldAtPoint = function(x, z)
    if type(x) == "table" then
        x, z = x.x or x, x.z or z
    end

    -- 未知类型错误bug
    if type(x) ~= "number" then
        x = 0
    end

    if type(z) ~= "number" then
        z = 0
    end

    if checkxz(x, z) then --判断的基础，也许光判断z就行了
        return true
    end
    return false
end

-----------地皮中心点----------------
local function GetHamTileCenterPointBefore(self, x, y, z)
    if type(x) ~= "number" then
        x, y, z = x.x or x, x.y or y, x.z or z
    end

    if z and checkxz(x, z) then -- 虚空也不希望返回一个空值
        return { math.floor(x / 4) * 4 + 2, 0, math.floor(z / 4) * 4 + 2 }, true
    end
end


local function CheckHamRoomBefore(self, x, y, z)
    local isroom = IsHamRoomAtPoint(x, y, z, false)
    return { true }, isroom
end

---------- 根据components/deployable.lua判断需要覆盖的方法
Utils.FnDecorator(Map, "IsAboveGroundAtPoint", CheckHamRoomBefore)
Utils.FnDecorator(Map, "IsPassableAtPoint", CheckHamRoomBefore)
Utils.FnDecorator(Map, "IsVisualGroundAtPoint", CheckHamRoomBefore)
Utils.FnDecorator(Map, "CanPlantAtPoint", CheckHamRoomBefore)             --允许房间里种植，不知道算不算超模
Utils.FnDecorator(Map, "GetTileCenterPoint", GetHamTileCenterPointBefore) -------地皮中心


---------放置检查---------------------限制制作的配方-----------------------
local banrecipe = { "playerhouse_city", "pighouse_city", "city_lamp", "pig_guard_tower", "pig_guard_tower_palace",
    "pugaliskfountain_made",
    "hua_player_house_recipe",
    "homesign", "townportal", "telebase", "hua_player_house1_recipe",
    "hua_player_house_pvz_recipe", "hua_player_house_tardis_recipe", "infantree_carpet", "myth_house_bamboo"

}

local old_CanDeployRecipeAtPoint = Map.CanDeployRecipeAtPoint
Map.CanDeployRecipeAtPoint = function(self, pt, recipe, rot)
    if recipe.build_mode == "insidedoor" then
        local pt_x, pt_y, pt_z = pt:Get()
        local isbackwall = IsHamRoomAtPoint(pt_x, pt_y, pt_z, true)
        if isbackwall == "back" then
            return true
        else
            return false
        end
    elseif recipe.build_mode == "wallsection" then
        local pt_x, pt_y, pt_z = pt:Get()
        local iswall = IsHamRoomAtPoint(pt_x, pt_y, pt_z, true)
        if iswall then
            return true
        else
            return false
        end
    elseif tableutil.has_component(banrecipe, recipe.name) or string.find(recipe.name, "pig_shop") then
        local pt_x, pt_y, pt_z = pt:Get()
        local isroom = IsHamRoomAtPoint(pt_x, pt_y, pt_z, false)
        if isroom then
            return false
        else
            return old_CanDeployRecipeAtPoint(self, pt, recipe, rot)
        end
    else
        return old_CanDeployRecipeAtPoint(self, pt, recipe, rot)
    end
end
