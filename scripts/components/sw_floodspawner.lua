local Shapes = require("tro_utils/shapes")

local function GetSpawnPos(ent)
    if not ent:IsInShipwreckedArea() then
        return nil --必须海难区域
    end

    local pos = Shapes.GetRandomLocation(ent:GetPosition(), 2, 8)
    if not TheWorld.Map:IsSurroundedByLand(pos.x, pos.y, pos.z, 6) then
        return nil --附近是陆地
    end

    if #TheSim:FindEntities(pos.x, pos.y, pos.z, 10, { "sandbag" }) >= 3 then
        return nil --附近沙袋不能超过3个
    end

    if #TheSim:FindEntities(pos.x, pos.y, pos.z, 13, { "sw_flood" }) >= 1 then
        return nil --附近没有水坑
    end

    return pos
end

local function SpawnFlood(spawn_pos)
    SpawnAt("shipwrecked_flood", spawn_pos)
end

local function Check(inst, self)
    local spawned = false
    if self.flood_count < self.max_flood_count
        and TheWorld.state.isspring
        and TheWorld.state.iswet
        and TheWorld.state.israining
        and math.random() > 0.8
    then
        for _, v in ipairs(AllPlayers) do
            for i = 1, math.random(2) do
                local spawn_pos = GetSpawnPos(v)
                if spawn_pos then
                    SpawnFlood(spawn_pos)
                    spawned = true
                end
            end
        end
    end

    local cd = spawned and math.random(30, 60) or math.random(5, 10)
    inst:DoTaskInTime(cd, Check, self)
end

local Floodspawner = Class(function(self, inst)
    self.inst = inst

    self.flood_count = 0
    self.max_flood_count = 20 --水坑最大数量

    inst:DoTaskInTime(math.random(5, 10), Check, self)
end)

function Floodspawner:OnFloodSpawn()
    self.flood_count = self.flood_count + 1
end

function Floodspawner:OnFloodRemove()
    self.flood_count = math.max(0, self.flood_count - 1)
end

return Floodspawner
