local Utils = require("tropical_utils/utils")

local function UpdateGroundSpeedMultiplierAfter(retTab, self)
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local oncreep = TheWorld.GroundCreep:OnCreep(x, y, z)

    if oncreep and self.triggerscreep then return retTab end

    -- 重新修改groundspeedmultiplier的值
    local current_ground_tile = TheWorld.Map:GetTileAtPoint(x, 0, z)
    local isCave = TheWorld:HasTag("cave")
    if current_ground_tile == GROUND.UNDERWATER_SANDY or
        current_ground_tile == GROUND.UNDERWATER_ROCKY or
        (current_ground_tile == GROUND.BEACH and isCave) or
        (current_ground_tile == GROUND.MAGMAFIELD and isCave) or
        (current_ground_tile == GROUND.PAINTED and isCave) or
        (current_ground_tile == GROUND.BATTLEGROUND and isCave) or
        (current_ground_tile == GROUND.PEBBLEBEACH and isCave) then
        if self.inst.prefab ~= "wurt" then
            self.groundspeedmultiplier = 0.5
        end
        if self.inst:HasTag("nadador") then
            self.groundspeedmultiplier = 0.8
        end
    end

    return retTab
end

local function ExternalSpeedMultiplierBefore(self)
    ----------------------efeito dos ventos----------------------------------
    local wind_speed = 1
    local vento = GetClosestInstWithTag("vento", self.inst, 10)
    if vento then
        local wind = vento.Transform:GetRotation() + 180
        local windangle = self.inst.Transform:GetRotation() - wind
        local windproofness = 1.0
        local velocidadedovento = 1.5

        if self.inst.components.inventory then
            local corpo = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
            local cabeca = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
            if cabeca and cabeca.prefab == "aerodynamichat" then
                windproofness = 0.5
            end
            if corpo and corpo.prefab == "armor_windbreaker" then
                windproofness = 0
            end
        end

        local windfactor = 0.4 * windproofness * velocidadedovento * math.cos(windangle * DEGREES) + 1.0
        wind_speed = math.max(0.1, windfactor)
    end
    ----------------------efeito das correntes marinhas----------------------------------
    local wave_speed = 1
    local ondamarinha = GetClosestInstWithTag("ondamarinha", self.inst, 6)
    if ondamarinha then
        local wave = ondamarinha.Transform:GetRotation() + 180
        local waveangle = self.inst.Transform:GetRotation() - wave
        local waveproofness = 1.0
        local velocidadedoondamarinha = 2


        local wavefactor = 0.4 * waveproofness * velocidadedoondamarinha * math.cos(waveangle * DEGREES) + 1.0
        wave_speed = math.max(0.1, wavefactor)
    end
    ----------------------efeito da inundação----------------------------------
    local flood_speed = 1
    local alagamento = GetClosestInstWithTag("mare", self.inst, 8)
    if alagamento and not self.inst:HasTag("ghost") then
        if not self.inst:HasTag("playerghost") then
            flood_speed = 0.6
        end
    end
    -------------------------------------------------------------------------------------------

    local groggy_modifier = 1

    if self.inst.components.grogginess and self.inst:HasTag("groggy") then
        groggy_modifier = self.inst.components.grogginess.speed_mod
    end

    return self.externalspeedmultiplier * wind_speed * wave_speed * flood_speed * groggy_modifier
end

----------------------------------------------------------------------------------------------------
-- 用来在OnUpdate中跳到岸上用的
local function GetCurrentPlatform(inst)
    return inst:_pro_GetCurrentPlatform() or inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.SWBOAT)
end

local function OnUpdateBefore(self)
    self.inst._pro_GetCurrentPlatform = self.inst.GetCurrentPlatform
    self.inst.GetCurrentPlatform = GetCurrentPlatform
end

local function OnUpdateAfter(retTab, self)
    self.inst.GetCurrentPlatform = self.inst._pro_GetCurrentPlatform or self.inst.GetCurrentPlatform
    self.inst._pro_GetCurrentPlatform = nil
    return retTab
end

----------------------------------------------------------------------------------------------------

AddComponentPostInit("locomotor", function(self)
    Utils.FnDecorator(self, "UpdateGroundSpeedMultiplier", nil, UpdateGroundSpeedMultiplierAfter)

    if self.inst:HasTag("player") then
        Utils.FnDecorator(self, "OnUpdate", OnUpdateBefore, OnUpdateAfter)
    end

    if not TheWorld.ismastersim then return end

    Utils.FnDecorator(self, "ExternalSpeedMultiplier", ExternalSpeedMultiplierBefore)
end)
