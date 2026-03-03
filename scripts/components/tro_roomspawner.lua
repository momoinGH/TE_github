local RoomUtils = require("tropical_utils/room_utils")

local BASE_OFF = RoomUtils.BASE_OFF + 100
local ROOM_GAP = RoomUtils.ROOM_GAP
local ROW_COUNT = RoomUtils.ROW_COUNT

-- 虚空小房子计数器，计数会一直递增，即便前面生成的房子已经销毁
local RoomSpawner = Class(function(self, inst)
    self.inst = inst

    self.count = 0 --小房子计数器，主机数据
end)

---从地图左上角开始，从左到右，从上到下累积
function RoomSpawner:GetPos()
    local x = (self.count % ROW_COUNT) * ROOM_GAP - BASE_OFF
    local z = BASE_OFF + math.ceil(self.count / ROW_COUNT) * ROOM_GAP
    self.count = self.count + 1
    return Vector3(x, 0, z)
end

function RoomSpawner:OnSave()
    return {
        count = self.count,
    }
end

function RoomSpawner:OnLoad(data)
    if not data then return end
    self.count = data.count or self.count
end

return RoomSpawner
