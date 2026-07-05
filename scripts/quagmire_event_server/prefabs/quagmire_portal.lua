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

local function OnActivateByOther(inst, source, doer)
    --    if not inst.sg:HasStateTag("open") then
    --        inst.sg:GoToState("opening")
    --    end
end

local function onaccept(inst, giver, item)
    inst.components.inventory:DropItem(item)
    inst.components.teleporter:Activate(item)
end

local function StartTravelSound(inst, doer)
    inst.SoundEmitter:PlaySound("dontstarve/common/teleportworm/swallow")
    doer:PushEvent("wormholetravel", WORMHOLETYPE.WORM) --Event for playing local travel sound
end

local function onclose(inst)
    local invader = GetClosestInstWithTag("quagmire_portal_activefx", inst, 3)
    if invader then
        invader:Remove()
    end
end

local function onopen(inst)
    local invader = GetClosestInstWithTag("quagmire_portal_activefx", inst, 3)
    if not invader then
        SpawnAt("quagmire_portal_activefx", inst)
    end
end

return {
    master_postinit = function(inst)
        inst:AddTag("trader")
        inst:AddTag("alltrader")

        inst:AddComponent("playerprox")
        inst.components.playerprox:SetDist(10, 13)
        inst.components.playerprox:SetOnPlayerNear(onopen)
        inst.components.playerprox:SetOnPlayerFar(onclose)

        inst:AddComponent("inspectable")
        inst.components.inspectable:RecordViews()

        inst:AddComponent("teleporter")
        inst.components.teleporter.onActivate = OnActivate
        inst.components.teleporter.onActivateByOther = OnActivateByOther
        inst.components.teleporter.offset = 0
        inst:ListenForEvent("starttravelsound", StartTravelSound) -- triggered by player stategraph
        inst:ListenForEvent("doneteleporting", OnDoneTeleporting)

        inst:AddComponent("inventory")

        inst:AddComponent("trader")
        inst.components.trader.acceptnontradable = true
        inst.components.trader.onaccept = onaccept
        inst.components.trader.deleteitemonaccept = false

        inst:DoTaskInTime(1, function(inst)
            for _, v in ipairs(TroGetEntsByPrefab("quagmire_portal")) do
                if v ~= inst and not v.components.teleporter.targetTeleporter then
                    inst.components.teleporter.targetTeleporter = v
                    v.components.teleporter.targetTeleporter = inst
                end
            end
        end)
    end
}
