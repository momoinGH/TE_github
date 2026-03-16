local function OnPlayerFogStateChange(inst)
    if inst._parent ~= nil then
        inst._parent:PushEvent("tro_fogchange")
    end
end

local function RegisterNetListeners(inst)
    if not TheWorld.ismastersim then
        inst:ListenForEvent("tro_fogdirty", OnPlayerFogStateChange)
    end
end

AddPrefabPostInit("player_classified", function(inst)
    inst.tro_fog = net_bool(inst.GUID, "tro_fog", "tro_fogdirty") --是否在雾气中

    inst:DoStaticTaskInTime(0, RegisterNetListeners)
end)
