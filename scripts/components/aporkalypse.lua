--- 哈姆雷特蝙蝠的生成
local Aporkalypse = Class(function(self, inst)
    self.inst = inst
    self.begin_date = 120 * TUNING.TOTAL_DAY_TIME
    self.aporkalypse_active = false
    self.inside_ruins = false
    self.near_days = 7

    self.bat_task = nil
    self.bat_amount = 15

    self.clock_dungeon = math.random(1, 3)

    self.fiesta_active = false
    self.fiesta_begin_date = 0
    self.fiesta_duration = 5 * TUNING.TOTAL_DAY_TIME

    self.first_time = true

    self.inst:ListenForEvent("clocktick", function(inst, data)
        local fiesta_elapsed = (TheWorld.state.cycles + TheWorld.state.time) * TUNING.TOTAL_DAY_TIME -
                                   self.fiesta_begin_date
        if self.fiesta_duration - fiesta_elapsed < 0 and self.fiesta_active == true then
            self.fiesta_active = false
        end
        if (TheWorld.state.cycles + TheWorld.state.time) * TUNING.TOTAL_DAY_TIME >= self.begin_date and
            not self:IsActive() then self:BeginAporkalypse() end

        local aporkalypse_duration = ((TheWorld.state.cycles + TheWorld.state.time) * TUNING.TOTAL_DAY_TIME -
                                         self.begin_date) / TUNING.TOTAL_DAY_TIME
        if aporkalypse_duration >= 20 or TUNING.tropical.aporkalypse == false then self:EndAporkalypse() end
    end, TheWorld)

    self.inst:DoTaskInTime(0.5, function()
        if self.aporkalypse_active == true then
            for k, jogador in pairs(AllPlayers) do jogador:AddTag("aporkalypse") end
        end
    end)

    local function OnPlayerJoined(src, player)
        if self.aporkalypse_active == true then player:AddTag("aporkalypse") end
    end

    self.inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, TheWorld)
end)

function Aporkalypse:OnSave()
    return {
        begin_date = self.begin_date,
        aporkalypse_active = self.aporkalypse_active,
        inside_ruins = self.inside_ruins,
        fiesta_active = self.fiesta_active,
        fiesta_begin_date = self.fiesta_begin_date,
        first_time = self.first_time,
    }
end

function Aporkalypse:OnLoad(data)
    if data then
        self.begin_date = data.begin_date or (TheWorld.state.cycles + TheWorld.state.time) * TUNING.TOTAL_DAY_TIME +
                              (120 * TUNING.TOTAL_DAY_TIME)
        self.aporkalypse_active = data.aporkalypse_active
        self:ScheduleAporkalypseTasks()
        self.inside_ruins = data.inside_ruins
        -- TODO: should we push "beginfiesta" here?
        self.fiesta_active = data.fiesta_active
        self.fiesta_begin_date = data.fiesta_begin_date
        self.first_time = data.first_time
    end
end

function Aporkalypse:ScheduleAporkalypse(date)
    local currentTime = (TheWorld.state.cycles + TheWorld.state.time) * TUNING.TOTAL_DAY_TIME

    local delta = date - (TheWorld.state.cycles + TheWorld.state.time) * TUNING.TOTAL_DAY_TIME

    local daytime = 120 * TUNING.TOTAL_DAY_TIME
    while delta > daytime do delta = delta % daytime end

    while delta < 0 do delta = delta + daytime end

    self.begin_date = currentTime + delta
end

function Aporkalypse:ScheduleAporkalypseTasks()
    self:ScheduleBatSpawning()
    self:ScheduleHeraldCheck()
end

function Aporkalypse:BeginAporkalypse()
    if self.aporkalypse_active then return end

    self.aporkalypse_active = true
    for k, jogador in pairs(AllPlayers) do jogador:AddTag("aporkalypse") end

    self:ScheduleAporkalypseTasks()

    self.inst:PushEvent("beginaporkalypse")
end

function Aporkalypse:BeginFiesta()
    self.fiesta_active = true
    self.inst:PushEvent("beginfiesta")
end

function Aporkalypse:EndFiesta()
    self.fiesta_active = false
    self.inst:PushEvent("endfiesta")
end

function Aporkalypse:EndAporkalypse()
    if not self.aporkalypse_active then return end

    self.aporkalypse_active = nil
    for k, jogador in pairs(AllPlayers) do jogador:RemoveTag("aporkalypse") end

    local aporkalypse_duration = ((TheWorld.state.cycles + TheWorld.state.time) * TUNING.TOTAL_DAY_TIME -
                                     self.begin_date) / TUNING.TOTAL_DAY_TIME
    if aporkalypse_duration >= 2 then
        self.fiesta_begin_date = TheWorld.state.cycles * TUNING.TOTAL_DAY_TIME
        self:BeginFiesta()
    end

    self.first_time = false

    -- Schedule the next one!
    self:ScheduleAporkalypse((TheWorld.state.cycles + TheWorld.state.time) * TUNING.TOTAL_DAY_TIME +
                                 (120 * TUNING.TOTAL_DAY_TIME))
    self.inst:PushEvent("endaporkalypse")
end

function Aporkalypse:ScheduleBatSpawning()
    self.bat_task = self.aporkalypse_active and self.inst:StartThread(function()
        while self.aporkalypse_active do
            for _, player in ipairs(AllPlayers) do
                if not GetClosestInstWithTag("interior_center", player, 30) then
                    local x, y, z = player.Transform:GetWorldPosition()
                    for __ = 1, 6 do
                        SpawnAt("circlingbat", Vector3(x + math.random(-10, 10), y, z + math.random(-10, 10)))
                    end
                end
            end
            Sleep(TUNING.TOTAL_DAY_TIME * math.random(1, 1.25))
        end
    end)
end

function Aporkalypse:ScheduleHeraldCheck()
    self.herald_check_task = self.aporkalypse_active and self.inst:StartThread(function()
        while self.aporkalypse_active do
            for _, player in ipairs(AllPlayers) do
                if player and not player.components.health:IsDead() then
                    local herald = GetClosestInstWithTag("ancient", player, 40)
                    if not GetClosestInstWithTag("interior_center", player, 40) then
                        if not herald then
                            local map = TheWorld.Map
                            local x, _, z = player.Transform:GetWorldPosition()
                            local ground = map:GetTile(map:GetTileCoordsAtPoint(x + math.random(-10, 10), 0, z + math.random(-10, 10)))
                            if ground ~= GROUND.OCEAN_COASTAL   and ground ~= GROUND.OCEAN_COASTAL_SHORE   and
                               ground ~= GROUND.OCEAN_SWELL     and ground ~= GROUND.OCEAN_ROUGH           and
                               ground ~= GROUND.OCEAN_BRINEPOOL and ground ~= GROUND.OCEAN_BRINEPOOL_SHORE and
                               ground ~= GROUND.OCEAN_WATERLOG  and ground ~= GROUND.OCEAN_HAZARDOU       then
                                herald = SpawnAt("ancient_herald", Vector3(x, 0, z))
                            end
                            if herald and herald.components.combat then
                                herald.components.combat:SuggestTarget(player)
                            end
                        end
                    end
                end
            end
            Sleep(math.random(TUNING.SEG_TIME / 2, TUNING.SEG_TIME))
        end
    end)
end

function Aporkalypse:GetClockDungeon() return "RUINS_" .. self.clock_dungeon end

function Aporkalypse:IsNear()
    return self.begin_date - (TheWorld.state.cycles + TheWorld.state.time) * TUNING.TOTAL_DAY_TIME < self.near_days *
               TUNING.TOTAL_DAY_TIME
end

function Aporkalypse:GetBeginDate() return self.begin_date end

function Aporkalypse:IsActive() return self.aporkalypse_active end

function Aporkalypse:GetFiestaActive() return self.fiesta_active end

return Aporkalypse
