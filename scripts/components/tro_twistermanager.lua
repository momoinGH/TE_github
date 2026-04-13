local PlayerNearSpawnForOne = require("components/tro_playernearspawnforone")

local function SpawnTwister(inst, player)

end

local function OnStartSpawnTwister(inst)
    local self = inst.components.tro_twistermanager
end

local function OnIsWet(inst, iswet)
    local self = inst.components.tro_twistermanager
    if iswet then
        if not self.spawner.enable and math.random() < 0.67 then
            --这里懒得考虑跳过时间
            local total = (TheWorld.state.remainingdaysinseason + TheWorld.state.elapseddaysinseason) * TUNING.TOTAL_DAY_TIME
            local remain_time = TheWorld.state.seasonprogress * total * math.random(0.7, 0.85) - TheWorld.state.elapseddaysinseason * TUNING.TOTAL_DAY_TIME
            self.spawner:SetNextSpawnTime(remain_time)
            self.spawner.enable = true
        end
    else
        self.spawner.enable = false
    end
end

local TwisterManager = Class(function(self, inst)
    self.inst = inst

    self.spawner = PlayerNearSpawnForOne(inst)
    self.spawner.spawn_fn = SpawnTwister
    self.spawner.start_spawn_fn = OnStartSpawnTwister
    self.spawner.first_spawn_time = TUNING.TOTAL_DAY_TIME * 20
    self.spawner.spawn_check_interval = 10
    self.spawner.spawn_interval = 999999 --死了不能重生
    self.spawner.enable = false

    self.warn = nil

    inst:WatchWorldState("iswet", OnIsWet)
end)

function TwisterManager:OnSave()
    local data, refs = {}, {}

    data.spawner_enable = self.spawner.enable

    local spawner_data, spawner_refs = self.spawner:OnSave()
    data.spawner_data = spawner_data
    table.troinserttable(refs, spawner_refs)
    return data, refs
end

function TwisterManager:OnLoad(data)
    if not data then return end

    self.spawner:OnLoad(data.spawner_data)

    if data.spawner_enable then
        self.spawner.enable = true
    end
end

function TwisterManager:LoadPostPass(ents, data)
    self.spawner:LoadPostPass(ents, data.spawner_data)
end

return TwisterManager
