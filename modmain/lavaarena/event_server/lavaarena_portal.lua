local assets =
{
    Asset("ANIM", "anim/lavaarena_portal.zip"),
    Asset("ANIM", "anim/lavaarena_keyhole.zip"),
    Asset("ANIM", "anim/lavaarena_portal_fx.zip"),
}

local function OnDoneTeleporting(inst, obj)
    if inst.closetask ~= nil then
        inst.closetask:Cancel()
    end

    if obj ~= nil and obj:HasTag("player") then
        obj:DoTaskInTime(1, obj.PushEvent, "wormholespit") -- for wisecracker
    end
end

local function OnActivate(inst, doer)
    if doer:HasTag("player") then
        ProfileStatsSet("wormhole_used", true)

        local other = inst.components.teleporter.targetTeleporter
        if other ~= nil then
            DeleteCloseEntsWithTag("WORM_DANGER", other, 15)
        end

        if doer.components.talker ~= nil then
            doer.components.talker:ShutUp()
        end
        if doer.components.sanity ~= nil then
            doer.components.sanity:DoDelta(-TUNING.SANITY_MED)
        end

        --Sounds are triggered in player's stategraph
    elseif inst.SoundEmitter ~= nil then
        inst.SoundEmitter:PlaySound("dontstarve/common/teleportworm/swallow")
    end
end

local function onaccept(inst, giver, item)
    inst.components.teleporter:Activate(item)
end

local function StartTravelSound(inst, doer)
    inst.SoundEmitter:PlaySound("dontstarve/common/teleportworm/swallow")
    doer:PushEvent("wormholetravel", WORMHOLETYPE.WORM) --Event for playing local travel sound
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
    inst.components.teleporter.onActivate = OnActivate
    inst.components.teleporter.offset = 0
    inst:ListenForEvent("starttravelsound", StartTravelSound) -- triggered by player stategraph
    inst:ListenForEvent("doneteleporting", OnDoneTeleporting)

    inst:AddComponent("trader")
    inst.components.trader.acceptnontradable = true
    inst.components.trader.onaccept = onaccept
    inst.components.trader.deleteitemonaccept = false
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
