local function CheckPlayerLocation(inst)
    if TUNING.tropical.startlocation == "default" then
        return
    end
    local x, y, z = inst.Transform:GetWorldPosition()
    if not TheWorld.Map:FindVisualNodeAtPoint(x, y, z, TUNING.tropical.startlocation) then
        return --不在指定地形
    end

    -- 替换玩家出生点
    local portal = TroGetAnyEntByPrefab("multiplayer_portal")
    if portal then
        portal.Transform:SetPosition(x, y, z)
    end
    portal = TroGetAnyEntByPrefab("spawnpoint_master")
    if portal then
        portal.Transform:SetPosition(x, y, z)
    end

    -- 删除所有传送门标记
    for _, v in ipairs(TroGetEntsByPrefab("tro_custom_startlocation")) do
        v:Remove()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:DoTaskInTime(0, CheckPlayerLocation)

    inst.persists = false

    return inst
end

return Prefab("tro_custom_startlocation", fn)
