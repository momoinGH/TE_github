local assets =
{
    Asset("ANIM", "anim/quagmire_portal.zip"),
    Asset("ANIM", "anim/quagmire_portal_base.zip"),
}

local prefabs =
{
    "quagmire_portal_activefx",
    --"quagmire_portal_bubblefx",
    "quagmire_portal_player_fx",
    "quagmire_portal_playerdrip_fx",
    "quagmire_portal_player_splash_fx",
}

local fx_assets =
{
    Asset("ANIM", "anim/quagmire_portal_fx.zip"),
}
--[[
local fx_bubble_assets =
{
    Asset("ANIM", "anim/quagmire_portalbubbles_fx.zip"),
}
]]
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
    local invader = GetClosestInstWithTag("quagmire_portal_activeanim", inst, 3)
    if invader then
        invader:Remove()
    end
end

local function onopen(inst)
    local invader = GetClosestInstWithTag("quagmire_portal_activeanim", inst, 3)
    if not invader then
        local portaentrada = SpawnPrefab("quagmire_portal_activeanim")
        local a, b, c = inst.Transform:GetWorldPosition()
        portaentrada.Transform:SetPosition(a, b, c)
    end
end


local function CreateDropShadow(parent)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    --Non-networked entity

    inst.AnimState:SetBuild("quagmire_portal_base")
    inst.AnimState:SetBank("quagmire_portal_base")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(1)
    --inst.AnimState:OverrideSymbol("quagmire_portal01", "quagmire_portal", "shadow")

    inst.Transform:SetEightFaced()

    inst:AddTag("DECOR")
    inst:AddTag("NOCLICK")

    inst.presists = false
    inst.entity:SetParent(parent.entity)

    return inst
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("gorge_portal.png")

    inst.AnimState:SetBuild("quagmire_portal")
    inst.AnimState:SetBank("quagmire_portal")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(6)
    inst.AnimState:SetFinalOffset(2)

    inst.Transform:SetEightFaced()

    if not TheNet:IsDedicated() then
        CreateDropShadow(inst)
    end
    --trader, alltrader (from trader component) added to pristine state for optimization	
    inst:AddTag("trader")
    inst:AddTag("alltrader")



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

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
        for k, v in pairs(Ents) do
            if v ~= inst and v.prefab == "gorge_portal" then
                inst.components.teleporter.targetTeleporter = v
                v.components.teleporter.targetTeleporter = inst
            end
        end
    end)


    return inst
end
--[[
local function fn1()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    inst.entity:AddMiniMapEntity()
	inst.MiniMapEntity:SetIcon("gorge_portal.png")

    inst.AnimState:SetBuild("quagmire_portal")
    inst.AnimState:SetBank("quagmire_portal")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(6)
    inst.AnimState:SetFinalOffset(2)

    inst.Transform:SetEightFaced()

    if not TheNet:IsDedicated() then
        CreateDropShadow(inst)
    end	
    --trader, alltrader (from trader component) added to pristine state for optimization	
    inst:AddTag("trader")
    inst:AddTag("alltrader")



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

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
	
		
    return inst
end]]

local function activefx_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("quagmire_portal_fx")
    inst.AnimState:SetBank("quagmire_portal_fx")
    inst.AnimState:PlayAnimation("portal_pre")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:OverrideMultColour(1, 1, 1, 1)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(6)
    inst.AnimState:SetFinalOffset(1)

    inst:AddTag("quagmire_portal_activeanim")

    inst.entity:AddLight()
    inst.Light:SetFalloff(0.4)
    inst.Light:SetIntensity(.7)
    inst.Light:SetRadius(3)
    inst.Light:SetColour(249 / 255, 130 / 255, 117 / 255)
    inst.Light:Enable(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:PushAnimation("portal_loop")

    inst.persists = false

    return inst
end

--[[
local function bubblefx_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("quagmire_portalbubbles_fx")
    inst.AnimState:SetBank("quagmire_portalbubbles_fx")
    inst.AnimState:PlayAnimation("idle")
--    inst:Hide()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end
]]

return Prefab("quagmire_portal_activeanim", activefx_fn, fx_assets),
    Prefab("gorge_portal", fn, assets)
--Prefab("gorge_portal1", fn1, assets)
--Prefab("quagmire_portal_bubblefx", bubblefx_fn, fx_bubble_assets)
