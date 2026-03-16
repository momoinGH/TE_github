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
local TogglePickable = Hooks.FindUpvalue(MakeNoGrowInWinter, "TogglePickable")
if not TogglePickable then
    print("获取TogglePickable函数失败，无法让作物冬天也生长了。")
end
function CancelNoGrowInWinter(inst)
    if not TogglePickable then return end
    inst.components.pickable:StopWatchingWorldState("iswinter", TogglePickable)
    inst.components.pickable:Resume()
end

GLOBAL.CancelNoGrowInWinter = CancelNoGrowInWinter
