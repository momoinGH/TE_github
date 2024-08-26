local assets =
{
    Asset("ANIM", "anim/lavaarena_portal.zip"),
    Asset("ANIM", "anim/lavaarena_keyhole.zip"),
    Asset("ANIM", "anim/lavaarena_portal_fx.zip"),
    Asset("ANIM", "anim/lavaarena_player_teleport.zip"), --火焰的资产
}

local function OnDoneTeleporting(inst, doer)
    doer:DoTaskInTime(0.7, function()
        SpawnAt("lavaarena_portal_player_fx", doer)
    end)
end

local function OnPlayerFar(inst)
    if inst.activefx then
        inst.activefx:Kill()
        inst.activefx = nil
    end
end

local function OnPlayerNear(inst)
    if not inst.activefx then
        local fx = SpawnPrefab("lavaarena_portal_activefx")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx:ListenForEvent("onremove", function() fx:Remove() end, inst)
        inst.activefx = fx
    end
end

local function Bind(inst)
    for _, v in ipairs(TheWorld.components.tro_tempentitytracker:GetEnts(inst.prefab)) do
        if v ~= inst and not v.components.teleporter:GetTarget() then
            v.components.teleporter:Target(inst)
            inst.components.teleporter:Target(v)
            TheWorld.components.tro_tempentitytracker:RemoveEnt(inst) -- 传送门只匹配一次
            TheWorld.components.tro_tempentitytracker:RemoveEnt(v)
            return
        end
    end
end

local function master_postinit(inst)
    if TheWorld.components.tro_tempentitytracker:KeyExists("lavaarena_portal") then
        inst:DoTaskInTime(0, Bind)
    end

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(5, 5)
    inst.components.playerprox:SetOnPlayerNear(OnPlayerNear)
    inst.components.playerprox:SetOnPlayerFar(OnPlayerFar)

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()

    inst:AddComponent("teleporter")
    inst.components.teleporter.OnDoneTeleporting = OnDoneTeleporting
    inst.components.teleporter.offset = 0
    inst.components.teleporter.travelcameratime = 0
    inst.components.teleporter.travelarrivetime = 0
end

add_event_server_data("lavaarena", "prefabs/lavaarena_portal", {
    master_postinit = master_postinit,
}, assets)


local function Kill(inst)
    inst.AnimState:PushAnimation("portal_pst", false)
    inst:ListenForEvent("animqueueover", inst.Remove)
end

AddPrefabPostInit("lavaarena_portal_activefx", function(inst)
    if not TheWorld.ismastersim then return end
    inst.Kill = Kill
end)
