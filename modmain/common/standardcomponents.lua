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
        inst.components.timer:StopTimer("spawndelay")
        inst.components.timer:StartTimer("spawndelay", inst._tro_mhp_respawn_time)
    end
end

local function OnPlantRespawnTimerDone(inst, data)
    if data and (data.name == "_tro_mhp_respawn" or data.name == "spawndelay") then
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

----------------------------------------------------------------------------------------------------

--清除积雪覆盖效果
local Old_MakeSnowCovered = GLOBAL.MakeSnowCovered
GLOBAL.MakeSnowCovered = function(inst, ...)
    Old_MakeSnowCovered(inst, ...)
    inst:DoTaskInTime(0, function()
        if not inst:TroHasWinter() then --这些地方建筑没有积雪
            inst.AnimState:ClearOverrideSymbol("snow", "snow", "snow")
            inst:RemoveTag("SnowCovered")
            inst.AnimState:Hide("snow")
        end
    end)
end

----------------------------------------------------------------------------------------------------
-- 海难飓风
local function ongustpick(inst)
    if inst.components.pickable and inst.components.pickable:CanBePicked() then
        inst.components.pickable:Pick(inst)
    end
end

-- 针对可采集的植物，添加刮风处理，播放刮风动画
function _G.MakePickableBlowInWindGust(inst, wind_speed, destroy_chance, done_anim)
    inst.tro_hurricane_done_anim = done_anim or "idle"

    local function onblownpstdone(inst)
        if inst.components.pickable and
            inst.components.pickable:CanBePicked() and
            (
                inst.AnimState:IsCurrentAnimation("blown_pst") or
                inst.AnimState:IsCurrentAnimation("blown_loop") or
                inst.AnimState:IsCurrentAnimation("blown_pre")
            )
        then
            inst.AnimState:PlayAnimation(inst.tro_hurricane_done_anim, true)
        end
        inst:RemoveEventCallback("animover", onblownpstdone)
    end

    local function ongustanimdone(inst)
        if inst.components.pickable and inst.components.pickable:CanBePicked() then
            if inst.components.blowinwindgust:IsGusting() then
                local anim = math.random(1, 2)
                inst.AnimState:PlayAnimation("blown_loop" .. anim, false)
            else
                inst:DoTaskInTime(math.random() / 2, function(inst)
                    inst:RemoveEventCallback("animover", ongustanimdone)

                    -- This may not be true anymore
                    if inst.components.pickable and inst.components.pickable:CanBePicked() then
                        inst.AnimState:PlayAnimation("blown_pst", false)
                        -- changed this from a push animation to an animover listen event so that it can be interrupted if necessary, and that a check can be made at the end to know if it should go to idle at that time.
                        --inst.AnimState:PushAnimation("idle", true)
                        inst:ListenForEvent("animover", onblownpstdone)
                    end
                end)
            end
        else
            inst:RemoveEventCallback("animover", ongustanimdone)
        end
    end
    local function onguststart(inst)
        inst:DoTaskInTime(math.random() / 2, function(inst)
            if inst.components.pickable and inst.components.pickable:CanBePicked() then
                inst.AnimState:PlayAnimation("blown_pre", false)
                inst:ListenForEvent("animover", ongustanimdone)
            end
        end)
    end

    inst:AddComponent("blowinwindgust")
    inst.components.blowinwindgust:SetWindSpeedThreshold(wind_speed)
    inst.components.blowinwindgust:SetDestroyChance(destroy_chance)
    inst.components.blowinwindgust:SetGustStartFn(onguststart)
    inst.components.blowinwindgust:SetGustEndFn(onblownpstdone)
    inst.components.blowinwindgust:SetDestroyFn(ongustpick)
    inst.components.blowinwindgust:Start()
end

function _G.MakeHackableBlowInWindGust(inst, wind_speed, destroy_chance)
    local function onblownpstdone(inst)
        if inst.components.hackable and
            inst.components.hackable:CanBeWorked() and
            (
                inst.AnimState:IsCurrentAnimation("blown_pst") or
                inst.AnimState:IsCurrentAnimation("blown_loop") or
                inst.AnimState:IsCurrentAnimation("blown_pre")
            )
        then
            inst.AnimState:PlayAnimation("idle", true)
        end
        inst:RemoveEventCallback("animover", onblownpstdone)
    end

    local function ongustanimdone(inst)
        if inst.components.hackable and inst.components.hackable:CanBeWorked() then
            if inst.components.blowinwindgust:IsGusting() then
                local anim = math.random(1, 2)
                inst.AnimState:PlayAnimation("blown_loop" .. anim, false)
            else
                inst:DoTaskInTime(math.random() / 2, function(inst)
                    inst:RemoveEventCallback("animover", ongustanimdone)

                    -- This may not be true anymore
                    if inst.components.hackable and inst.components.hackable:CanBeWorked() then
                        inst.AnimState:PlayAnimation("blown_pst", false)
                        -- changed this from a push animation to an animover listen event so that it can be interrupted if necessary, and that a check can be made at the end to know if it should go to idle at that time.
                        --inst.AnimState:PushAnimation("idle", true)
                        inst:ListenForEvent("animover", onblownpstdone)
                    end
                end)
            end
        else
            inst:RemoveEventCallback("animover", ongustanimdone)
        end
    end

    local function onguststart(inst, windspeed)
        inst:DoTaskInTime(math.random() / 2, function(inst)
            if inst.components.hackable and inst.components.hackable:CanBeWorked() then
                inst.AnimState:PlayAnimation("blown_pre", false)
                inst:ListenForEvent("animover", ongustanimdone)
            end
        end)
    end

    local function ongusthack(inst)
        if inst.components.lootdropper and inst.components.hackable and inst.components.hackable:CanBeWorked() then
            inst.components.lootdropper:SpawnLootPrefab(inst.components.hackable.product)
        end
    end

    inst:AddComponent("blowinwindgust")
    inst.components.blowinwindgust:SetWindSpeedThreshold(wind_speed)
    inst.components.blowinwindgust:SetDestroyChance(destroy_chance)
    inst.components.blowinwindgust:SetGustStartFn(onguststart)
    inst.components.blowinwindgust:SetGustEndFn(onblownpstdone)
    inst.components.blowinwindgust:SetDestroyFn(ongusthack)
    inst.components.blowinwindgust:Start()
end
