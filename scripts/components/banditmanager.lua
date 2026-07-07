local PlayerNearSpawnForOne = require("components/tro_playernearspawnforone")

local function CanSpawn(player)
    -- if tiletype == GROUND.SUBURB or tiletype == GROUND.COBBLEROAD or tiletype == GROUND.FOUNDATION or tiletype == GROUND.LAWN then	
    return not IsEntityDeadOrGhost(player)
        and player.components.areaaware
        and (player.components.areaaware:CurrentlyInTag("City1") or player.components.areaaware:CurrentlyInTag("City2")) --单机是判断地皮的
end

local function TrySpawnBandit(inst, player, need_count)
    if not CanSpawn(player) then
        return
    end

    local value = player.components.inventory:GetMoney()
    if TheWorld.state.isdusk then
        value = value * 1.5
    elseif TheWorld.state.isnight then
        value = value * 3
    end

    local chance = 1 / 100
    if value >= 150 then
        chance = 1 / 5
    elseif value >= 100 then
        chance = 1 / 10
    elseif value >= 50 then
        chance = 1 / 20
    elseif value >= 10 then
        chance = 1 / 40
    elseif value == 0 then
        chance = 0
    end

    if math.random() < chance then
        return inst.components.banditmanager:SpawnBandit(player)
    end
end

local Banditmanager = Class(function(self, inst)
    self.inst = inst

    self.spawner = PlayerNearSpawnForOne(inst)
    self.spawner.spawn_fn = TrySpawnBandit
    self.spawner.spawn_interval = 30 * 16 * 1.5
    self.spawner.spawn_check_interval = 10
end)

function Banditmanager:SpawnBandit(player)
    local cover = FindEntity(player, 40, nil, { "bandit_cover" })
    if not cover then
        return --附近有猪人房才生成
    end

    local bandit = SpawnPrefab("pigbandit")
    local x, y, z = cover.Transform:GetWorldPosition()
    local angle = math.random() * PI2
    x = x + math.cos(angle)
    z = z + math.sin(angle)
    bandit.Transform:SetPosition(x, 0, z)

    --宝藏和藏宝图
    local treasure = TroSpawnRandomEntsInRange("bandittreasure", player:GetPosition(), 1, math.random(120, 200), nil, nil)[1]
    if treasure then
        local map = SpawnPrefab("banditmap")
        map.treasure = treasure
        bandit.components.inventory:GiveItem(map)
    end

    return bandit
end

function Banditmanager:OnSave()
    return self.spawner:OnSave()
end

function Banditmanager:OnLoad(data)
    if not data then return end

    self.spawner:OnLoad(data)
end

function Banditmanager:LoadPostPass(ents, data)
    self.spawner:LoadPostPass(ents, data)
end

return Banditmanager
