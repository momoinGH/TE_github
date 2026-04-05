local function GetTotalTime()
    return (TheWorld.state.cycles + TheWorld.state.time) * TUNING.TOTAL_DAY_TIME
end

local function SpawnHerald(src, player, count)
    if not player:HasTag("aporkalypse") then return end
    if IsEntityDeadOrGhost(player) then return end
    if player:TroGetRoomCenter() then return end

    local pt = player:GetPosition()
    local herald = TroSpawnRandomEntsInRange("ancient_herald", pt, 1, 10)[1]
    if not herald then return false end         --没有合适的位置

    herald:TroAddSaveTag("aporkalypse_cleanup") --大灾变过去会销毁
    -- herald.components.combat:SuggestTarget(player) --绕过玩家吧
    herald.sg:GoToState("appear")
    return herald
end

local function SpawnBats(src, player, count)
    if not player:HasTag("aporkalypse") then return end
    if IsEntityDeadOrGhost(player) then return end
    if player:TroGetRoomCenter() then return end

    local pt = player:GetPosition()
    print("生成蝙蝠", count)
    local bats = TroSpawnRandomEntsInRange("circlingbat", pt, count, 5, nil, function()
        return Vector3(math.random(-5, 5), 0, math.random(-5, 5))
    end)
    for _, bat in ipairs(bats) do
        bat:TroAddSaveTag("aporkalypse_cleanup")
    end
    return bats
end

local function UpdatePlayerTag(self, player)
    if self.aporkalypse_active and player:IsInHamletArea() then
        player:AddTag("aporkalypse") --在大灾变范围内
    else
        player:RemoveTag("aporkalypse")
    end
end

-- 哈姆雷特大灾变组件
local Aporkalypse = Class(function(self, inst)
    self.inst = inst

    --远古先驱生成
    local PlayerNearSpawnForOne = require("components/tro_playernearspawnforone")
    self.herald_spawn = PlayerNearSpawnForOne(inst)
    self.herald_spawn.first_spawn_time = 0
    self.herald_spawn.spawn_interval = function() return math.random(TUNING.TOTAL_DAY_TIME / 3, TUNING.TOTAL_DAY_TIME) end --再生时间
    self.herald_spawn.spawn_fn = SpawnHerald
    self.herald_spawn.enable = false

    --蝙蝠生成
    local PlayerNearSpawnForEach = require("components/tro_playernearspawnforeach")
    self.bat_spawn = PlayerNearSpawnForEach(inst)
    self.bat_spawn.first_spawn_time = 0
    self.bat_spawn.max_count = 15
    self.bat_spawn.spawn_interval = function() return TUNING.TOTAL_DAY_TIME + (TUNING.TOTAL_DAY_TIME * math.random(0, 0.25)) end
    self.bat_spawn.spawn_fn = SpawnBats
    self.bat_spawn.enable = false

    -- 大灾变
    self.begin_date = 60 * TUNING.TOTAL_DAY_TIME --下次大灾变时间，60天之后才能生成
    self.aporkalypse_active = false              --是否在大灾变时期

    -- 庆典
    self.fiesta_active = false
    self.fiesta_begin_date = 0
    self.fiesta_duration = 5 * TUNING.TOTAL_DAY_TIME

    self.inst:ListenForEvent("clocktick", function(inst, data)
        if GetTotalTime() - self.begin_date >= 20 * TUNING.TOTAL_DAY_TIME then --这里让他20天自动结束
            self:EndAporkalypse()
        elseif GetTotalTime() >= self.begin_date then
            self:BeginAporkalypse()
        end
    end, TheWorld)

    self.inst:ListenForEvent("ms_playerjoined", function(src, player)
        UpdatePlayerTag(self, player)
        self.inst:ListenForEvent("changearea", function() UpdatePlayerTag(self, player) end, player)
    end, TheWorld)
    for _, v in ipairs(AllPlayers) do UpdatePlayerTag(self, v) end
end)

function Aporkalypse:OnSave()
    local data = {
        begin_date = self.begin_date,
        aporkalypse_active = self.aporkalypse_active,
        fiesta_active = self.fiesta_active,
        fiesta_begin_date = self.fiesta_begin_date,
        fiesta_elapsed = GetTotalTime() - self.fiesta_begin_date
    }
    local refs = {}

    local herald_data, herald_refs = self.herald_spawn:OnSave()
    local bat_data, bat_refs = self.bat_spawn:OnSave()
    data.herald_data = herald_data
    data.bat_data = bat_data
    table.troinserttable(refs, herald_refs)
    table.troinserttable(refs, bat_refs)

    return data, refs
end

function Aporkalypse:OnLoad(data)
    if not data then return end

    self.begin_date = data.begin_date or self.begin_date

    if data.aporkalypse_active then
        self:BeginAporkalypse(true)
    end

    if data.fiesta_active then
        self.fiesta_active = data.fiesta_active
        self.fiesta_begin_date = data.fiesta_begin_date
        local duration = math.clamp(self.fiesta_duration - (data.fiesta_elapsed or 0), 0, self.fiesta_duration)
        self.fiesta_task = self.inst:DoTaskInTime(duration, function() self:EndFiesta() end)
    end

    self.herald_spawn:OnLoad(data.herald_data)
    self.bat_spawn:OnLoad(data.bat_data)
end

function Aporkalypse:LoadPostPass(ents, data)
    self.herald_spawn:LoadPostPass(ents, data and data.herald_data)
    self.bat_spawn:LoadPostPass(ents, data and data.bat_data)
end

-- 调整大灾变时间
function Aporkalypse:ScheduleAporkalypse(date)
    local delta = date - GetTotalTime()
    local daytime = 60 * TUNING.TOTAL_DAY_TIME
    while delta > daytime do
        delta = delta % daytime
    end
    while delta < 0 do
        delta = delta + daytime
    end
    self.begin_date = GetTotalTime() + delta
end

-- 开始大灾变
function Aporkalypse:BeginAporkalypse(is_load)
    if self.aporkalypse_active then return end

    self.aporkalypse_active = true
    self.herald_spawn.enable = true
    self.bat_spawn.enable = true
    if not is_load then
        self.inst:PushEvent("beginaporkalypse")
    end
    for _, v in ipairs(AllPlayers) do UpdatePlayerTag(self, v) end
end

-- 开始庆典
function Aporkalypse:BeginFiesta()
    self.fiesta_active = true
    self.fiesta_begin_date = GetTotalTime()
    self.inst:PushEvent("beginfiesta")
    self.fiesta_task = self.inst:DoTaskInTime(self.fiesta_duration, function() self:EndFiesta() end)
end

function Aporkalypse:EndFiesta()
    self.fiesta_active = false
    self.inst:PushEvent("endfiesta")
end

function Aporkalypse:EndAporkalypse()
    if not self.aporkalypse_active then return end

    self.aporkalypse_active = nil
    self.herald_spawn.enable = false
    self.bat_spawn.enable = false
    for _, v in ipairs(AllPlayers) do UpdatePlayerTag(self, v) end

    local aporkalypse_duration = (GetTotalTime() - self.begin_date) / TUNING.TOTAL_DAY_TIME
    if aporkalypse_duration >= 2 then
        self:BeginFiesta()
    end

    -- Schedule the next one!
    self:ScheduleAporkalypse(GetTotalTime() + (60 * TUNING.TOTAL_DAY_TIME))
    self.inst:PushEvent("endaporkalypse") --相关实体会在这个事件里处理
end

function Aporkalypse:IsNear()
    local near_days = 7
    return self.begin_date - GetTotalTime() < near_days * TUNING.TOTAL_DAY_TIME
end

function Aporkalypse:GetBeginDate() return self.begin_date end

function Aporkalypse:IsActive() return self.aporkalypse_active end

function Aporkalypse:GetFiestaActive() return self.fiesta_active end

return Aporkalypse
