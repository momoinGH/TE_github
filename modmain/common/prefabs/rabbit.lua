local OnIsWinter = Hooks.GetUpValue(require("prefabs/rabbit").fn, "OnWake", "OnIsWinter")
local IsForcedNightmare = OnIsWinter and Hooks.GetUpValue(OnIsWinter, "IsForcedNightmare")
local IsWinterRabbit = OnIsWinter and Hooks.GetUpValue(OnIsWinter, "IsWinterRabbit")
local BecomeWinterRabbit = OnIsWinter and Hooks.GetUpValue(OnIsWinter, "BecomeWinterRabbit")
local IsNormalRabbit = OnIsWinter and Hooks.GetUpValue(OnIsWinter, "IsNormalRabbit")
local BecomeRabbit = OnIsWinter and Hooks.GetUpValue(OnIsWinter, "BecomeRabbit")

if not (OnIsWinter and IsForcedNightmare and IsWinterRabbit and BecomeWinterRabbit and IsNormalRabbit and BecomeRabbit) then
    print("错误：rabbit预制体求上值失败，不再修改兔子受到的季节影响", OnIsWinter, IsForcedNightmare, IsWinterRabbit, BecomeWinterRabbit, IsNormalRabbit, BecomeRabbit)
    return
end

local function NewOnIsWinter(inst)
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
    if not IsForcedNightmare(inst) then
        if inst:TroIsWinter() then
            if not IsWinterRabbit(inst) then
                inst.task = inst:DoTaskInTime(math.random() * .5, BecomeWinterRabbit)
            end
        elseif not IsNormalRabbit(inst) then
            inst.task = inst:DoTaskInTime(math.random() * .5, BecomeRabbit)
        end
    end
end

local function OnEntityWakeAfter(retTab, inst)
    inst:StopWatchingWorldState("iswinter", OnIsWinter)
    inst:WatchWorldState("iswinter", NewOnIsWinter)
end

local function OnEntitySleepBefore(inst)
    inst:StopWatchingWorldState("iswinter", NewOnIsWinter)
end

AddPrefabPostInit("rabbit", function(inst)
    if not TheWorld.ismastersim then return end

    Hooks.FnDecorator(inst, "OnEntityWake", nil, OnEntityWakeAfter)
    Hooks.FnDecorator(inst, "OnEntitySleep", OnEntitySleepBefore)
end)
