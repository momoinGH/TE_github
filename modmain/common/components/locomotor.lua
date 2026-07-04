local function UpdateGroundSpeedMultiplierAfter(retTab, self)
    -- 海底世界减速，这里只考虑玩家
    if self.inst:HasTag("player")
        and not self.inst:HasTag("playerghost")
        and self.inst:IsInUnderWaterArea()
        and self.inst.prefab ~= "wurt"      --沃特不减速
    then
        if self.inst:HasTag("nadador") then --穿了潜水衣
            self.groundspeedmultiplier = math.min(0.8, self.groundspeedmultiplier)
        else
            self.groundspeedmultiplier = math.min(0.5, self.groundspeedmultiplier)
        end
    end

    return retTab
end

AddComponentPostInit("locomotor", function(self)
    Hooks.FnDecorator(self, "UpdateGroundSpeedMultiplier", nil, UpdateGroundSpeedMultiplierAfter)
end)

----------------------------------------------------------------------------------------------------
-- 刷帧刷新倍率
local function UpdateSpeedMult(inst)
    if inst:HasTag("playerghost") then
        inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "sw_wind")
        inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "ondamarinha")
        inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "sw_flood")
        return
    end

    -- efeito dos ventos风效应
    if TheWorld.components.tro_hurricane and TheWorld.components.tro_hurricane:IsHurricaneStorm() then
        local windangle = TheWorld.components.tro_hurricane:GetWindAngle(inst)
        local windproofness = 1.0
        local velocidadedovento = 1.5

        if inst.components.inventory then
            local corpo = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
            local cabeca = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
            if cabeca and cabeca.prefab == "aerodynamichat" then
                windproofness = 0.5
            end
            if corpo and corpo.prefab == "armor_windbreaker" then
                windproofness = 0
            end
        end
        local windfactor = 0.4 * windproofness * velocidadedovento * math.cos(windangle * DEGREES) + 1.0
        local wind_speed = math.max(0.1, windfactor)
        inst.components.locomotor:SetExternalSpeedMultiplier(inst, "sw_wind", wind_speed)
    else
        inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "sw_wind")
    end

    ----------------------efeito das correntes marinhas海流的影响----------------------------------
    local ondamarinha = GetClosestInstWithTag("ondamarinha", inst, 6)
    if ondamarinha then
        local wave = ondamarinha.Transform:GetRotation() + 180
        local waveangle = inst.Transform:GetRotation() - wave
        local waveproofness = 1.0
        local velocidadedoondamarinha = 2
        local wavefactor = 0.4 * waveproofness * velocidadedoondamarinha * math.cos(waveangle * DEGREES) + 1.0
        local wave_speed = math.max(0.1, wavefactor)
        inst.components.locomotor:SetExternalSpeedMultiplier(inst, "ondamarinha", wave_speed)
    else
        inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "ondamarinha")
    end

    ----------------------efeito da inundação洪水效应----------------------------------
    if GetClosestInstWithTag("sw_flood", inst, 8) then
        inst.components.locomotor:SetExternalSpeedMultiplier(inst, "sw_flood", 0.8)
    else
        inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "sw_flood")
    end
end

AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return end
    inst.components.locomotor:SetFasterOnGroundTile(WORLD_TILES.COBBLEROAD, true) --石板路为加速地皮

    inst:DoPeriodicTask(FRAMES * 4, UpdateSpeedMult)
end)
