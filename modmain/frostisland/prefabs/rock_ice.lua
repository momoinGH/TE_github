local rock_ice_fn = require("prefabs/rock_ice").fn
local TryStageChange = Hooks.FnDecorator(rock_ice_fn, "ontimerdone", "TryStageChange")
if not TryStageChange then
    print("获取rock_ice预制件的TryStageChange函数失败，冰岛无法修改迷你冰川生成。")
    return
end

local SetStage = Hooks.FnDecorator(TryStageChange, "SetStage")
local RescheduleTimer = Hooks.FnDecorator(TryStageChange, "RescheduleTimer")
if not (SetStage and RescheduleTimer) then
    print("获取rock_ice预制件的SetStage和RescheduleTimer函数失败，冰岛无法修改迷你冰川生成。")
    return
end

local function NewTryStageChange(inst)
    if inst.components.workable ~= nil and
        inst.components.workable.lastworktime ~= nil and
        GetTime() - inst.components.workable.lastworktime < 10 then
        --Reschedule if we recently worked it
        --V2C: Can't StartTimer immediately, because we are in a handler
        --     triggered by the same timer name that we want to restart.
        inst:DoTaskInTime(0, RescheduleTimer)
        return
    end

    local pct = TheWorld.state.seasonprogress
    if inst:IsInFrostisLandArea() then --冰岛一直冬天！
        SetStage(inst, "tall", "grow")
    elseif TheWorld.state.isspring then
        SetStage(
            inst,
            (pct < inst.threshold1 and "tall") or
            (pct < inst.threshold2 and "medium") or
            (pct < inst.threshold3 and "short") or
            "empty",
            "melt"
        )
    elseif TheWorld.state.issummer then
        --if pct > .1 then
        SetStage(inst, "dryup", "melt")
        --end
    elseif TheWorld.state.isautumn then
        SetStage(
            inst,
            (pct < inst.threshold1 and "empty") or
            (pct < inst.threshold2 and "short") or
            (pct < inst.threshold3 and "medium") or
            "tall",
            "grow"
        )
    elseif TheWorld.state.iswinter then
        SetStage(inst, "tall", "grow")
    end
end
Hooks.SetUpvalue(rock_ice_fn, "ontimerdone", "TryStageChange", NewTryStageChange)


AddPrefabPostInit("rock_ice", function(inst)
    if not TheWorld.ismastersim then return end

    inst:DoTaskInTime(2 * FRAMES, function() --比科雷的慢一点儿，覆盖他的初始化
        if inst:IsInFrostisLandArea() then
            SetStage(inst, "tall")
        end
    end)
end)
