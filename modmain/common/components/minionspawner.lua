local function HasOceanTile(self)
    for k, _ in pairs(self.validtiletypes) do
        if TileGroupManager:IsOceanTile(k) then
            return true
        end
    end
    return false
end

local function generatefreepositions(max)
    local pos_table = {}
    for num = 1, max do
        table.insert(pos_table, num)
    end
    return pos_table
end

local POS_MODIFIER = 1.2
local function MakeSpawnLocationsBefore(self)
    if not HasOceanTile(self) then
        return --如果没有海洋地皮就走原来的逻辑
    end

    print("查找新点")

    -- 有海洋地皮就是我们mod自己的，直接取消陆地和眼球草数量的限制
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local ground = TheWorld
    local maxpositions = self.maxminions * POS_MODIFIER
    local useablepositions = {}
    for i = 1, 100 do
        local s = i / 32 --(num/2) -- 32.0
        local a = math.sqrt(s * 512)
        local b = math.sqrt(s) * self.distancemodifier
        local pos = Vector3(x + math.sin(a) * b, 0, z + math.cos(a) * b)
        if
            self:CheckTileCompatibility(ground.Map:GetTileAtPoint(pos:Get())) and
            ground.Pathfinder:IsClear(x, 0, z, pos.x, 0, pos.z, { ignorewalls = true, allowocean = true }) and
            #TheSim:FindEntities(pos.x, pos.y, pos.z, 1) <= 0 and
            not ground.Map:IsPointNearHole(pos) then
            table.insert(useablepositions, pos)
            if #useablepositions >= maxpositions then
                return { useablepositions }, true
            end
        end
    end

    --if it couldn't find enough spots for minions.
    self.maxminions = #useablepositions
    self.freepositions = generatefreepositions(self.maxminions)
    return { #useablepositions > 0 and useablepositions or nil }, true
end


AddComponentPostInit("minionspawner", function(self)
    Hooks.FnDecorator(self, "MakeSpawnLocations", MakeSpawnLocationsBefore)


    function self:DespawnAll()
        self.spawninprogress = false
        for k, v in pairs(self.minions) do
            v:DoTaskInTime(math.random(), function()
                if v:IsAsleep() then
                    v:Remove()
                else
                    v:PushEvent("despawn")
                    v:ListenForEvent("entitysleep", function() v:Remove() end)
                end
            end)
        end
    end

    function self:SpawnAll()
        for i = 1, self.maxminions do
            self.inst:DoTaskInTime(math.random(2, 3) * math.random(), function()
                local old_shouldspawn = self.shouldspawn
                self.shouldspawn = true --这是一个强制生成，忽略这个变量
                self:SpawnNewMinion()
                self.shouldspawn = old_shouldspawn
            end)
        end
    end

    function self:RegenerateFreePositions()
        self.freepositions = generatefreepositions(self.maxminions * POS_MODIFIER)
    end
end)
