local function OnPlayerFogStateChange(inst)
    if inst._parent ~= nil then
        inst._parent:PushEvent("pro_fogchange")
    end
end

local function RegisterNetListeners(inst)
    if not TheWorld.ismastersim then
        inst:ListenForEvent("pro_fogdirty", OnPlayerFogStateChange)
    end
end

AddPrefabPostInit("player_classified", function(inst)
    inst.pro_fog = net_bool(inst.GUID, "pro_fog", "pro_fogdirty") --是否在雾气中

    inst:DoStaticTaskInTime(0, RegisterNetListeners)
end)
