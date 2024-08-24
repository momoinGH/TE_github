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
    local fogspeed = 1
    if self.inst:HasTag("hamfogspeed") then
        fogspeed = 0.4
    end

    return self.externalspeedmultiplier * wind_speed * wave_speed * fogspeed * flood_speed
end

----------------------------------------------------------------------------------------------------
-- 移动时船动人不动
local function PlayerSetMotorSpeedBefore(self, speed)
    local boat = self.inst:GetCurrentPlatform()
    if boat and boat:HasTag("shipwrecked_boat") then
        boat.Transform:SetRotation(self.inst:GetRotation())
        --算上零件的移速加成
        speed = speed * boat.components.shipwreckedboat:GetSpeedMutliplier()
        --算上手上桨的移速加成
        local equip = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if equip and equip.components.oar then
            speed = speed * (equip.components.oar.force + 1)
        end
        boat.Physics:SetMotorVel(speed, 0, 0)
        return nil, true
    end
end

-- 一般情况上岸是玩家在船体边缘并且靠近岸边，GetPlatformAtPoint不会返回船体，但是小船是玩家在小船中间，原方法往前一段距离还是在小船范围，改成如果在岸上则不属于小船范围
local function PlayerCheckEdgeBefore(self, my_platform, map, my_x, my_z, dir_x, dir_z, radius)
    local boat = self.inst:GetCurrentPlatform()
    if not boat or not boat:HasTag("shipwrecked_boat") then return end

    local pt_x, pt_z = my_x + dir_x * radius, my_z + dir_z * radius
    local is_water = not map:IsVisualGroundAtPoint(pt_x, 0, pt_z)
    if not is_water then return end --目的地必须是有效地面，不然会跳进水里

    local old_platform_radius = boat.components.walkableplatform.platform_radius
    boat.components.walkableplatform.platform_radius = 0.2
    local platform = map:GetPlatformAtPoint(pt_x, pt_z) -- 关键步骤，不能检测到小船
    boat.components.walkableplatform.platform_radius = old_platform_radius

    return { (is_water and platform == nil) or platform ~= my_platform }, true
end

--开船时给玩家一丁点速度，让方法可以判断是否需要跨平台
local function PlayerOnUpdateBefore(self)
    if self.inst.Physics:GetMotorSpeed() <= 0 then
        local boat = self.inst:GetCurrentPlatform()
        if boat and boat:HasTag("shipwrecked_boat") then
            self.inst.Physics:SetMotorVel(0.001, 0, 0)
        end
    end
end

----------------------------------------------------------------------------------------------------

AddComponentPostInit("locomotor", function(self)
    Utils.FnDecorator(self, "UpdateGroundSpeedMultiplier", nil, UpdateGroundSpeedMultiplierAfter)

    if not TheWorld.ismastersim then return end

    if self.inst:HasTag("player") then --只在主机修改，如果开启了延迟补偿则不特殊处理，当做普通的船用
        Utils.FnDecorator(self, "SetMotorSpeed", PlayerSetMotorSpeedBefore)
        -- Utils.FnDecorator(self, "CheckEdge", PlayerCheckEdgeBefore)
        Utils.FnDecorator(self, "OnUpdate", PlayerOnUpdateBefore)
    end

    Utils.FnDecorator(self, "ExternalSpeedMultiplier", ExternalSpeedMultiplierBefore)
end)
