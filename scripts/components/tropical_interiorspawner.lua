local InteriorSpawnerUtils = require("interiorspawnerutils")

local BASE_OFF = InteriorSpawnerUtils.BASE_OFF
local ROOM_SIZE = InteriorSpawnerUtils.ROOM_SIZE
local ROW_COUNT = InteriorSpawnerUtils.ROW_COUNT

-- 虚空小房子计数器，计数会一直递增，即便前面生成的房子已经销毁
local InteriorSpawner = Class(function(self, inst)
    self.inst = inst

    self.count = 0 --小房子计数器，主机数据
end)

---从地图左上角开始，从左到右，从上到下累积
function InteriorSpawner:GetPos()
    local x = (self.count % ROW_COUNT) * ROOM_SIZE - BASE_OFF
    local z = BASE_OFF + math.ceil(self.count / ROW_COUNT) * ROOM_SIZE
    self.count = self.count + 1
    return Vector3(x, 0, z)
end

function InteriorSpawner:OnSave()
    return {
        count = self.count,
    }
end

function InteriorSpawner:OnLoad(data)
    if not data then return end
    self.count = data.count or self.count
end

return InteriorSpawner
