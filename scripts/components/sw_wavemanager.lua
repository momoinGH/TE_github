local CHECK_INTERVAL = 0.5
local WAVE_LANE_SPACING = 12
local MAX_WAVES_PER_PLAYER = 8
local WAVE_CHECK_RADIUS = 36
local WAVE_CLEAR_RADIUS = 4
local PLATFORM_CLEAR_RADIUS = 8
local NOWAVES_CLEAR_RADIUS = 10
local LANE_WAVE_TAG = "lanewave"
local RIPPLE_SPEED = 2
local ROGUE_WAVE_SPEED = 6
local RIPPLE_IDLE_TIME = 5
local SPAWN_ATTEMPTS_PER_TICK = 2
local ENTER_SEA_GRACE_TIME = 4 --进入海中满足条件后这么长时间后开始生成
local DEFAULT_CURRENT_ANGLE = 67.5
local MIN_ROW_RADIUS = 10
local MAX_ROW_RADIUS = 18
local MIN_COL_RADIUS = 1
local MAX_COL_RADIUS = 4
local MIN_PLATFORM_OFFSET = 6

local function IsPlayerAtSea(player)
    local x, y, z = player.Transform:GetWorldPosition()
    return TheWorld.Map:IsOceanAtPoint(x, y, z, true)                                     --在海里
        and not TileGroupManager:IsShallowOceanTile(TheWorld.Map:GetTileAtPoint(x, y, z)) --浅海不生成
end

local function IsValidWavePoint(x, y, z, player)
    if not TheWorld.Map:IsOceanAtPoint(x, y, z, false) then
        return false
    end
    if #TheSim:FindEntities(x, y, z, WAVE_CLEAR_RADIUS, { "wave" }) > 0 then
        return false
    end
    if #TheSim:FindEntities(x, y, z, PLATFORM_CLEAR_RADIUS, { "walkableplatform" }) > 0 then
        return false
    end
    if #TheSim:FindEntities(x, y, z, NOWAVES_CLEAR_RADIUS, { "nowaves" }) > 0 then
        return false
    end

    local platform = player ~= nil and player.GetCurrentPlatform ~= nil and player:GetCurrentPlatform() or nil
    if platform ~= nil then
        local px, _, pz = platform.Transform:GetWorldPosition()
        local radius = platform.components.walkableplatform ~= nil and platform.components.walkableplatform.radius or 4
        local dx = x - px
        local dz = z - pz
        if dx * dx + dz * dz <= (radius + MIN_PLATFORM_OFFSET) * (radius + MIN_PLATFORM_OFFSET) then
            return false
        end
    end

    return true
end

local function GetOceanMotion()
    local ocean = TheWorld.components.ocean
    local currentangle = DEFAULT_CURRENT_ANGLE
    local currentspeed = 1

    if ocean ~= nil then
        if ocean.GetCurrentAngle ~= nil then
            currentangle = ocean:GetCurrentAngle() or currentangle
        end
        if ocean.GetCurrentSpeed ~= nil then
            currentspeed = ocean:GetCurrentSpeed() or currentspeed
        end
    end

    local rad = currentangle * DEGREES
    local cx = math.cos(rad)
    local cz = math.sin(rad)
    local angle = -currentangle
    local speed = math.max(RIPPLE_SPEED, RIPPLE_SPEED * currentspeed)

    return angle, speed, cx, cz, currentspeed
end

local function GetWaveMotion()
    local angle, speed, cx, cz, currentspeed = GetOceanMotion()
    local prefab = "wave_ripple"

    if TheWorld.state.moonphase == "full" and math.random() < 0.15 then
        prefab = "rogue_wave"
        speed = math.max(ROGUE_WAVE_SPEED, speed * 2)
    end

    return prefab, angle, speed, cx, cz, currentspeed
end

local function GetLaneRadii()
    if TheCamera ~= nil and TheCamera.GetDistance ~= nil then
        local percent = math.max(0, math.min(1, (TheCamera:GetDistance() - 30) / 70))
        local row_radius = math.max(1, math.floor((MAX_ROW_RADIUS - MIN_ROW_RADIUS) * percent + MIN_ROW_RADIUS + 0.5))
        local col_radius = math.max(1, math.floor((MAX_COL_RADIUS - MIN_COL_RADIUS) * percent + MIN_COL_RADIUS + 0.5))
        return row_radius, col_radius
    end

    return 14, 2
end

local function FindLaneWaveSpawnPoint(player, cx, cz)
    local px, py, pz = player.Transform:GetWorldPosition()
    local gridw = WAVE_LANE_SPACING
    local lx = math.floor(px / gridw) * gridw
    local lz = math.floor(pz / gridw) * gridw
    local row_radius, col_radius = GetLaneRadii()

    for _ = 1, 12 do
        local m1 = math.floor(math.random(-row_radius, row_radius))
        local m2 = WAVE_LANE_SPACING * math.floor(math.random(-col_radius, col_radius))
        local dx = 2 * m1 * cx + m2 * cz
        local dz = 2 * m1 * cz + m2 * -cx
        local x = lx + dx
        local z = lz + dz

        if IsValidWavePoint(x, py, z, player) then
            return x, py, z
        end
    end
end

local function SpawnWaveForPlayer(player)
    local px, py, pz = player.Transform:GetWorldPosition()
    local nearbywaves = TheSim:FindEntities(px, py, pz, WAVE_CHECK_RADIUS, { "wave" })
    if #nearbywaves >= MAX_WAVES_PER_PLAYER then
        return false
    end

    local prefab, angle, speed, cx, cz, currentspeed = GetWaveMotion()
    if currentspeed <= 0 then
        return false
    end

    local x, y, z = FindLaneWaveSpawnPoint(player, cx, cz)
    if x == nil then
        return false
    end

    local wave = SpawnPrefab(prefab)
    if wave == nil then
        return false
    end

    wave.Transform:SetPosition(x, y, z)
    wave.Transform:SetRotation(angle)

    if wave.Physics ~= nil then
        wave.Physics:SetMotorVel(speed, 0, 0)
    end

    wave.idle_time = RIPPLE_IDLE_TIME
    wave:AddTag(LANE_WAVE_TAG)

    return true
end

local function Check(inst, self)
    local now = GetTime()

    for _, player in ipairs(AllPlayers) do
        local atsea = IsPlayerAtSea(player)

        if atsea then
            self.enter_sea_times[player.userid] = self.enter_sea_times[player.userid] or now
            if now - self.enter_sea_times[player.userid] >= ENTER_SEA_GRACE_TIME then
                for _ = 1, SPAWN_ATTEMPTS_PER_TICK do
                    if not SpawnWaveForPlayer(player) then
                        break
                    end
                end
            end
        else
            self.enter_sea_times[player.userid] = nil
        end
    end
end

-- 海难海浪生成
local Wavemanager = Class(function(self, inst)
    self.inst = inst

    self.enter_sea_times = {} --玩家进入海中时间
    self.task = inst:DoPeriodicTask(CHECK_INTERVAL, Check, CHECK_INTERVAL, self)
end)

return Wavemanager
