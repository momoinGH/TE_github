local relative_temperature_thresholds = { -30, -10, 10, 30 }
local function GetRangeForTemperature(temp, ambient)
    local range = 1
    for i, v in ipairs(relative_temperature_thresholds) do
        if temp > ambient + v then
            range = range + 1
        end
    end
    return range
end
local emitted_temperatures = { -10, 10, 25, 40, 60 }
local function HeatFn(inst, observer)
    local range = GetRangeForTemperature(inst.components.temperature:GetCurrent(), TheWorld.state.temperature)
    return emitted_temperatures[range]
end

function MakeObsidianTool(inst)
    inst:AddTag("heatrock")

    local temperature = inst.components.temperature or inst:AddComponent("temperature")
    temperature.inherentinsulation = TUNING.INSULATION_MED
    temperature.inherentsummerinsulation = TUNING.INSULATION_LARGE * 2
    temperature:IgnoreTags("heatrock")

    local heater = inst.components.heater or inst:AddComponent("heater")
    heater.heatfn = HeatFn
    heater.equippedheatfn = HeatFn
    heater.carriedheatfn = HeatFn
    heater.carriedheatmultiplier = TUNING.HEAT_ROCK_CARRIED_BONUS_HEAT_FACTOR
    heater:SetThermics(true, false)
end

GLOBAL.MakeObsidianTool = MakeObsidianTool


----------------------------------------------------------------------------------------------------
-- 取消作物冬天不生长的限制
local TogglePickable = Hooks.GetUpValue(MakeNoGrowInWinter, "TogglePickable")
if not TogglePickable then
    print("获取TogglePickable函数失败，无法让作物冬天也生长了。")
end
function CancelNoGrowInWinter(inst)
    if not TogglePickable then return end
    inst.components.pickable:StopWatchingWorldState("iswinter", TogglePickable)
    inst.components.pickable:Resume()
end

GLOBAL.CancelNoGrowInWinter = CancelNoGrowInWinter

----------------------------------------------------------------------------------------------------
local function OnPlantWorkFinished(inst, data)
    if inst.components.hackable then
        inst.components.hackable:SetWorkLeft(0)
    end
    if inst.components.shearable then
        inst.components.shearable:SetWorkLeft(0)
    end
    if inst._tro_mhp_respawn_time and inst.components.timer then
        inst.components.timer:StopTimer("_tro_mhp_respawn")
        inst.components.timer:StartTimer("_tro_mhp_respawn", inst._tro_mhp_respawn_time)
    end
end

local function OnPlantRespawnTimerDone(inst, data)
    if data and data.name == "_tro_mhp_respawn" then
        if inst.components.hackable and inst._tro_mhp_hack_count then
            inst.components.hackable:SetWorkLeft(inst._tro_mhp_hack_count)
        end
        if inst.components.shearable and inst._tro_mhp_shear_count then
            inst.components.shearable:SetWorkLeft(inst._tro_mhp_shear_count)
        end
        if inst._tro_mhp_on_respawn then
            inst:_tro_mhp_on_respawn()
        end
    end
end

---制作可砍可剪可挖的植物
---有一点需要注意，虽然砍了或者剪了会把两个组件SetWorkLeft设置为0，但是OnLoad时需要还需要外部记录是否采集过，采集过手动设置SetWorkLeft为0
---@param inst ent
---@param hack_count number
---@param shear_count number
---@param dig_count number
---@param respawn_time number
---@param onwork function
---@param ondig function
---@param on_respawn function
function _G.MakeHackablePlant(inst,
                              hack_count, shear_count, dig_count, respawn_time,
                              onwork, ondig, on_respawn)
    inst._tro_mhp_hack_count = hack_count
    inst._tro_mhp_shear_count = shear_count
    inst._tro_mhp_respawn_time = respawn_time
    inst._tro_mhp_onwork = onwork
    inst._tro_mhp_on_respawn = on_respawn

    if hack_count then
        inst:AddComponent("hackable")
        inst.components.hackable:SetWorkLeft(hack_count)
        inst:ListenForEvent("onhacked", function(inst, data)
            data.is_hack = true --可以通过这个判断是剪刀剪的还是砍刀
            if onwork then
                onwork(inst, data)
            end
        end)
        inst:ListenForEvent("onhackfinished", OnPlantWorkFinished)
    end

    if shear_count then
        inst:AddComponent("shearable")
        inst.components.shearable:SetWorkLeft(shear_count)
        inst:ListenForEvent("onshear", function(inst, data)
            data.is_shear = true
            if onwork then
                onwork(inst, data)
            end
        end)
        inst:ListenForEvent("onshearfinished", OnPlantWorkFinished)
    end

    if dig_count then
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetWorkLeft(dig_count)
        inst.components.workable:SetOnFinishCallback(ondig)
    end

    if respawn_time then
        if not inst.components.timer then
            inst:AddComponent("timer")
        end
        inst:ListenForEvent("timerdone", OnPlantRespawnTimerDone)
    end
end
