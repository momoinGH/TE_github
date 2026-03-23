local OnIsWinter = Hooks.FindUpvalue(require("prefabs/rabbit").fn, "OnEntityWake", "OnIsWinter")
local IsForcedNightmare = OnIsWinter and Hooks.FindUpvalue(OnIsWinter, "IsForcedNightmare")
local IsWinterRabbit = OnIsWinter and Hooks.FindUpvalue(OnIsWinter, "IsWinterRabbit")
local BecomeWinterRabbit = OnIsWinter and Hooks.FindUpvalue(OnIsWinter, "BecomeWinterRabbit")
local IsNormalRabbit = OnIsWinter and Hooks.FindUpvalue(OnIsWinter, "IsNormalRabbit")
local BecomeRabbit = OnIsWinter and Hooks.FindUpvalue(OnIsWinter, "BecomeRabbit")

if not (OnIsWinter and IsForcedNightmare and IsWinterRabbit and BecomeWinterRabbit and IsNormalRabbit and BecomeRabbit) then
    print("rabbit预制体求上值失败，冰岛不再修改兔子")
    return
end

local function OnEntityWakeBefore(inst)
    if not inst:IsInFrostisLandArea() then
        return
    end

    -- inst:WatchWorldState("iswinter", OnIsWinter) --不监了，这兔子出不了冰岛，一直是冬天
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
    if not IsForcedNightmare(inst) then
        if --[[TheWorld.state.iswinter]] true then --一直是冬天
            if not IsWinterRabbit(inst) then
                BecomeWinterRabbit(inst)
            end
        elseif not IsNormalRabbit(inst) then
            BecomeRabbit(inst)
        end
    end

    return nil, true
end

AddPrefabPostInit("rabbit", function(inst)
    if not TheWorld.ismastersim then return end

    Hooks.FnDecorator(inst, "OnEntityWake", OnEntityWakeBefore)
end)
