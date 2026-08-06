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
-- 飓风移速单独高频刷新：服务端计算后由 locomotor 的网络字段同步给客户端。
local function UpdateHurricaneSpeedMult(inst)
    if inst:HasTag("playerghost") then
        inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "sw_wind")
        return
    end

    local hurricane = TheWorld.components.tro_hurricane
    if hurricane and hurricane:IsEntityInHurricaneRange(inst) then
        local windangle = hurricane:GetWindAngle(inst)
        local windfactor = hurricane.GetHurricaneWindFactor
            and hurricane:GetHurricaneWindFactor()
            or math.clamp(hurricane:GetHurricaneWindSpeed() or 0, 0, 1)
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
        if windfactor > 0 and windproofness > 0 then
            -- 玩家朝向与风向同向时顺风加速，反向时逆风减速。
            local relativeangle = inst.Transform:GetRotation() - windangle
            local speedfactor = 0.4 * windproofness * velocidadedovento
                * windfactor * math.cos(relativeangle * DEGREES)
                + 1.0
            inst.components.locomotor:SetExternalSpeedMultiplier(
                inst, "sw_wind", math.max(0.1, speedfactor))
        else
            inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "sw_wind")
        end
    else
        inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "sw_wind")
    end
end

----------------------------------------------------------------------------------------------------
-- 刷帧刷新其他环境倍率
local function UpdateSpeedMult(inst)
    if inst:HasTag("playerghost") then
        inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "ondamarinha")
        inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "sw_flood")
        return
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

    -- 这里用刷帧方式更新玩家移速倍率是为了方便服务端计算移速倍率，然后同步给客户端，防止延迟补偿下主客机速度不一致的情况
    -- 飓风范围和风向需要尽快更新，避免玩家刚进出范围时仍沿用旧倍率。
    inst:DoPeriodicTask(FRAMES * 4, UpdateSpeedMult)
    inst:DoPeriodicTask(0, UpdateHurricaneSpeedMult)
end)
