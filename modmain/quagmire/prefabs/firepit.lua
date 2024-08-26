local installables =
{
    "grill",
    "grill_small",
    "pot_hanger",
    "oven",
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

    inst:AddComponent("installations")
    inst.components.installations:SetUp(CanInstall, OnInstall)

    inst:AddComponent("shelf")
    inst:AddComponent("specialstewer")
    inst:AddComponent("stewer")

    inst:AddComponent("container")
    -- inst.components.container:WidgetSetup("firepit") --不打开就不需要注册
    inst.components.container.canbeopened = false
end)
