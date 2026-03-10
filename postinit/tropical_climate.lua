--温度变化更加丝滑
local function OnTemperatureUpdateBefore(self)
    if self.inst:IsInVolcanoArea() then
        local volcano_tem = 40
        self:SetModifier("volcanoregion", volcano_tem)

        return nil, false
    else
        self:RemoveModifier("volcanoregion")
    end


    if self.inst:IsInTropicalArea() then
        local tro_tem = math.max(10 - TheWorld.state.temperature, 0) + 5
        self:SetModifier("tropicalregion", tro_tem)
    else
        self:RemoveModifier("tropicalregion")
    end



    return nil, false
end

AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return end
    Hooks.FnDecorator(inst.components.temperature, "OnUpdate", OnTemperatureUpdateBefore)
    -- Hooks.FnDecorator(inst.components.weather, "OnUpdate", OnWeatherUpdateAfter)
    -- Hooks.FnDecorator(inst.components.moisture, "GetMoistureRate", GetMoistureRateBefore)
end)



local Moisture = require("components/moisture")
function Moisture:GetMoistureRate()
    if not TheWorld.state.israining and not (TheWorld.state.issnowing and self.inst:IsInTropicalArea()) then
        return -0.005 ---没搞懂为什么冬天不会自然干燥
    end

    return self:_GetMoistureRateAssumingRain()
end

--清除积雪覆盖效果
local Old_MakeSnowCovered = GLOBAL.MakeSnowCovered
local function ClearSnowCoveredPristine(inst)
    inst.AnimState:ClearOverrideSymbol("snow", "snow", "snow")
    inst:RemoveTag("SnowCovered")
    inst.AnimState:Hide("snow")
end
GLOBAL.MakeSnowCovered = function(inst, ...)
    Old_MakeSnowCovered(inst, ...)
    inst:DoTaskInTime(0, function()
        if inst.Transform ~= nil then
            local x, y, z = inst.Transform:GetWorldPosition()
            if TheWorld.Map:IsTropicalAreaAtPoint(x, y, z) then
                ClearSnowCoveredPristine(inst)
            end
        end
    end)
end


AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    --青蛙雨
    local frograin = Hooks.FindUpvalueWorldHandle(inst, "israining", "components/frograin") --下雨
    if frograin then
        -- print("找到青蛙雨了")
        local GetSpawnPoint = Hooks.FindUpvalue(frograin, "GetSpawnPoint")
        if GetSpawnPoint ~= nil then
            local old = GetSpawnPoint
            local function newGetSpawnPoint(pt)
                if TheWorld.Map:IsTropicalAreaAtPoint(pt:Get()) then
                    -- print("成功")
                    return nil
                end
                return old(pt)
            end
            Hooks.SetUpvalue(frograin, "GetSpawnPoint", newGetSpawnPoint)
        end
    end


    local wildfires = Hooks.FindUpvalueEventHandle(TheWorld, "ms_lightwildfireforplayer", "components/wildfires") --野火
    if wildfires then
        local LightFireForPlayer = Hooks.FindUpvalue(wildfires, "LightFireForPlayer")
        if LightFireForPlayer ~= nil then
            local old = LightFireForPlayer
            local function NewLightFireForPlayer(player, rescheduleFn)
                if player ~= nil then
                    local x, y, z = player.Transform:GetWorldPosition()
                    if TheWorld.Map:IsTropicalAreaAtPoint(x, y, z) then
                        return
                    end
                end
                old(player, rescheduleFn)
            end
            Hooks.SetUpvalue(wildfires, "LightFireForPlayer", NewLightFireForPlayer)
        end
    end
end)

--脚印
AddPrefabPostInit("dirtpile", function(inst)
    if TheWorld.ismastersim then
        inst:DoTaskInTime(0, function(...)
            if inst:IsInTropicalArea() then
                inst:Remove()
            end
        end)
    end
end)



--陷坑
AddComponentPostInit("sinkholespawner", function(self, inst)
    local old_SpawnSinkhole = self.SpawnSinkhole
    self.SpawnSinkhole = function(self, spawnpt, ...)
        if TheWorld.Map:IsTropicalAreaAtPoint(spawnpt.x, 0, spawnpt.z) then
            return false
        else
            old_SpawnSinkhole(self, spawnpt, ...)
        end
    end
end) --farming_manager


-- 用于控制熊大和巨鹿刷新条件，组件没有可以hook的方法，只好通过该方式来阻止生成
local function AreaAwareCurrentlyInTagBefore(self, tag)
    if tag == "nohasslers" and (self:CurrentlyInTag("tropical"))
    then
        return { true }, true
    end
end

AddComponentPostInit("areaaware", function(self)
    Hooks.FnDecorator(self, "CurrentlyInTag", AreaAwareCurrentlyInTagBefore)
end)