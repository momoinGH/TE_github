local installables =
{
    "grill",
    "grill_small",
    "quagmire_pot_hanger",
    "quagmire_oven",
}

local function CanInstall(prefab)
    for _, v in ipairs(installables) do
        if prefab == v then
            return true
        end
    end
    return false
end

local function OnInstall(inst, target)
    inst:OnInstall(target)
end

local function OnPrefabOverrideDirty(inst)
    if inst.prefaboverride:value() ~= nil then
        inst:SetPrefabNameOverride(inst.prefaboverride:value().prefab)
        if not TheWorld.ismastersim and inst.replica.container:CanBeOpened() then
            inst.replica.container:WidgetSetup(inst.prefaboverride:value().prefab)
        end
    end
end

local function OnRadiusDirty(inst)
    inst:SetPhysicsRadiusOverride(inst.radius:value() > 0 and inst.radius:value() / 100 or nil)
end

AddPrefabPostInit("firepit", function(inst)
    inst:AddTag("installations")
    inst:AddTag("quagmire_stewer")
    inst:AddTag("quagmire_cookwaretrader")

    inst.takeitem = net_entity(inst.GUID, "firepit.takeitem")
    inst.prefaboverride = net_entity(inst.GUID, "firepit.prefaboverride", "prefaboverridedirty")
    inst.radius = net_byte(inst.GUID, "firepit.radius", "radiusdirty")

    inst.curradius = .6
    MakeObstaclePhysics(inst, inst.curradius)

    if not TheWorld.ismastersim then
        inst:ListenForEvent("prefaboverridedirty", OnPrefabOverrideDirty)
        inst:ListenForEvent("radiusdirty", OnRadiusDirty)
        return
    end

    inst:AddComponent("quagmire_installations")
    inst.components.quagmire_installations.oninstallfn = function(inst, station)
        local stationprefab = station.prefab
        if stationprefab == "quagmire_grill" or stationprefab == "quagmire_grill_small" then
            inst.components.container.canbeopened = true
            inst.components.container:WidgetSetup(stationprefab)
        end

        inst.prefaboverride:set(station)
        inst.radius:set(140)

        OnPrefabOverrideDirty(inst)
        OnRadiusDirty(inst)
    end

    inst:AddComponent("container")
    inst.components.container.canbeopened = false
end)
