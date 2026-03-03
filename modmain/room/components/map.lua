local Utils = require("tools/utils")
local RoomUtils = require("tropical_utils/room_utils")
require("components/map")

local check_size = 1350
-- 判断是否在世界外面，一般世界外就是小房子
function Map:TroIsWorldOut(x, y, z)
    if math.abs(z) >= check_size or math.abs(x) >= check_size then
        return true
    else
        return false
    end
end

local last_rooms = {} --缓存，短时间内在一个房间附近求值的可能性较大
function Map:TroGetRoomCenter(x, y, z)
    if not self:TroIsWorldOut(x, 0, z) then
        return nil
    end

    for _, v in ipairs(last_rooms) do
        if v:IsValid() and v:IsPointInRoom(x, z) then
            return v
        end
    end
    -- 查找
    last_rooms = TheSim:FindEntities(x, 0, z, RoomUtils.RADIUS, { "interior_center" })
    for _, v in ipairs(last_rooms) do
        if v:IsPointInRoom(x, z) then
            return v
        end
    end

    return nil
end

local function CheckPointBefore(self, x, y, z)
    return { true }, self:TroGetRoomCenter(x, y, z) ~= nil
end

local function GetTileCenterPointBefore(self, x, y, z)
    if x and z and self:TroIsWorldOut(x, 0, z) then -- 虚空也不希望返回一个空值
        return { math.floor(x / 4) * 4 + 2, 0, math.floor(z / 4) * 4 + 2 }, true
    end
end

---------- 根据components/deployable.lua判断需要覆盖的方法
Utils.FnDecorator(Map, "IsAboveGroundAtPoint", CheckPointBefore)
Utils.FnDecorator(Map, "IsPassableAtPoint", CheckPointBefore)
Utils.FnDecorator(Map, "IsVisualGroundAtPoint", CheckPointBefore)
-- Utils.FnDecorator(Map, "CanPlantAtPoint", CheckPointBefore)             --允许房间里种植，不知道算不算超模
Utils.FnDecorator(Map, "GetTileCenterPoint", GetTileCenterPointBefore) -------地皮中心

----------------------------------------------------------------------------------------------------
