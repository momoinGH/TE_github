local Utils = require("tropical_utils/utils")

local TIMEOUT = 2



----------------------------------------------------------------------------------------------------

-- 登船
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.BOATMOUNT, function(inst, act)
    local x, y, z = act.target.Transform:GetWorldPosition()
    inst.components.locomotor:StartHopping(x, z, act.target)
end))

AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TROPICAL_USE_ITEM, function(inst, act)
    return FunctionOrValue(act.invobject.components.tro_consumable.state, act.invobject, act.doer, act.target)
end))

----------------------------------------------------------------------------------------------------

AddStategraphState("wilson_client", State {
    name = "shear_start",
    tags = { "preshear", "shearing", "working" },
    server_states = { "shear_start", "shear" },
    onenter = function(inst)
        inst.components.locomotor:Stop()
        if not inst.sg:ServerStateMatches() then
            inst.AnimState:PlayAnimation("cut_pre")
        end

        inst.sg:SetTimeout(TIMEOUT)
        inst:PerformPreviewBufferedAction()
    end,
    onupdate = function(inst)
        if inst.sg:ServerStateMatches() then
            if inst.entity:FlattenMovementPrediction() then
                inst.sg:GoToState("idle", "noanim")
            end
        elseif inst.bufferedaction == nil then
            inst.sg:GoToState("idle")
        end
    end,
    ontimeout = function(inst)
        inst:ClearBufferedAction()
        inst.sg:GoToState("idle")
    end,
    events =
    {
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("animover", function(inst) inst.sg:GoToState("shear") end),
    },
})

AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.SHEAR, function(inst)
    if not inst.sg:HasStateTag("preshear") then
        return "shear_start"
    end
end))

----------------------------------------------------------------------------------------------------

for _, data in ipairs({
    -- {id，symbol}
    { 2, "swap_wind_conch" },
    { 3, "swap_antler" }
}) do
    AddStategraphState("wilson_client", State {
        name = "play_horn" .. data[1],
        server_states = { "play_horn" .. data[1] },
        forward_server_states = true,
        onenter = function(inst) inst.sg:GoToState("action_uniqueitem_busy") end,
    })
end

AddStategraphState("wilson_client", State {
    name = "play_flutesw",
    server_states = { "play_flutesw" },
    forward_server_states = true,
    onenter = function(inst) inst.sg:GoToState("action_uniqueitem_busy") end,
})

AddStategraphState("wilson_client", State {
    name = "crop_dust",
    server_states = { "crop_dust" },
    forward_server_states = true,
    onenter = function(inst) inst.sg:GoToState("action_uniqueitem_busy") end,
})

----------------------------------------------------------------------------------------------------
-- 淘金
AddStategraphState("wilson_client", State {
    name = "pan",
    tags = { "prepan", "panning", "working" },
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("pan_pre")
        inst.AnimState:PushAnimation("pan_loop", true)

        inst:PerformPreviewBufferedAction()
        inst.sg:SetTimeout(TIMEOUT)
    end,

    timeline =
    {
        TimeEvent(6 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/pool/pan") end),
        TimeEvent(14 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/pool/pan") end),

        TimeEvent((6 + 15) * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/pool/pan") end),
        TimeEvent((14 + 15) * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/pool/pan") end),

        TimeEvent((6 + 30) * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/pool/pan") end),
        TimeEvent((14 + 30) * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/pool/pan") end),

        TimeEvent((6 + 45) * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/pool/pan") end),
        TimeEvent((14 + 45) * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/pool/pan") end),

        TimeEvent((6 + 60) * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/pool/pan") end),
        TimeEvent((14 + 60) * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/pool/pan") end),
    },

    ontimeout = function(inst)
        inst:ClearBufferedAction()
        inst.sg:GoToState("idle", "pan_pst")
    end,
})


----------------------------------------------------------------------------------------------------

AddStategraphState("wilson_client", State {
    name = "investigate",
    tags = { "preinvestigate", "investigating", "working" },
    onenter = function(inst)
        inst.AnimState:PlayAnimation("lens")
        inst.AnimState:PushAnimation("lens_pst", false)

        inst:PerformPreviewBufferedAction()
        inst.sg:SetTimeout(TIMEOUT)
    end,

    timeline =
    {
        TimeEvent(9 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("preinvestigate")
        end),


        TimeEvent(16 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("investigating")
        end),
    },
})

----------------------------------------------------------------------------------------------------

-- 硬控玩家几秒
AddStategraphState("wilson_client", State {
    name = "sanity_stun",
    tags = { "busy" },

    onenter = function(inst, duration)
        inst.components.locomotor:Stop()

        inst.AnimState:PlayAnimation("idle_sanity_pre", false)
        inst.AnimState:PushAnimation("idle_sanity_loop", true)

        inst.sg:SetTimeout(duration or 4)
    end,

    ontimeout = function(inst)
        inst.sg:GoToState("idle")
    end,
})

----------------------------------------------------------------------------------------------------

AddStategraphState("wilson_client", State {
    name = "tap",
    tags = { "doing", "busy" },

    onenter = function(inst, timeout)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("tamp_pre")
        inst.AnimState:PushAnimation("tamp_loop", true)
        inst.sg:SetTimeout(timeout or 1)
        inst:PerformPreviewBufferedAction()
    end,

    timeline =
    {
        TimeEvent(4 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("busy")
        end),
        TimeEvent(5 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/tamping_tool")
        end),
        TimeEvent(12 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/tamping_tool")
        end),
        TimeEvent(20 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/tamping_tool")
        end),
        TimeEvent(28 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/tamping_tool")
        end),
        TimeEvent(36 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/tamping_tool")
        end),
    },

    ontimeout = function(inst)
        inst.sg:GoToState("idle")
    end,
})

----------------------------------------------------------------------------------------------------

AddStategraphState("wilson_client", State {
    name = "speargun",
    tags = { "attack", "notalking", "abouttoattack" },

    onenter = function(inst)
        if inst.replica.rider ~= nil and inst.replica.rider:IsRiding() then
            inst.Transform:SetFourFaced()
        end
        local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        inst.components.locomotor:Stop()

        inst.AnimState:PlayAnimation("speargun")
        if inst.sg.prevstate == inst.sg.currentstate then
            inst.sg.statemem.chained = true
            inst.AnimState:SetTime(5 * FRAMES)
        end

        if inst.replica.combat ~= nil then
            inst.replica.combat:StartAttack()
            inst.sg:SetTimeout(math.max((inst.sg.statemem.chained and 14 or 18) * FRAMES,
                inst.replica.combat:MinAttackPeriod() + .5 * FRAMES))
        end

        local buffaction = inst:GetBufferedAction()
        if buffaction ~= nil then
            inst:PerformPreviewBufferedAction()

            if buffaction.target ~= nil and buffaction.target:IsValid() then
                inst:FacePoint(buffaction.target:GetPosition())
                inst.sg.statemem.attacktarget = buffaction.target
            end
        end

        if (equip.projectiledelay or 0) > 0 then
            --V2C: Projectiles don't show in the initial delayed frames so that
            --     when they do appear, they're already in front of the player.
            --     Start the attack early to keep animation in sync.
            inst.sg.statemem.projectiledelay = (inst.sg.statemem.chained and 9 or 14) * FRAMES -
                equip.projectiledelay
            if inst.sg.statemem.projectiledelay <= 0 then
                inst.sg.statemem.projectiledelay = nil
            end
        end
    end,

    onupdate = function(inst, dt)
        if (inst.sg.statemem.projectiledelay or 0) > 0 then
            inst.sg.statemem.projectiledelay = inst.sg.statemem.projectiledelay - dt
            if inst.sg.statemem.projectiledelay <= 0 then
                inst:ClearBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
            end
        end
    end,

    timeline =
    {
        TimeEvent(8 * FRAMES, function(inst)
            if inst.sg.statemem.chained then
                inst.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_shoot", nil, nil, true)
            end
        end),
        TimeEvent(9 * FRAMES, function(inst)
            if inst.sg.statemem.chained and inst.sg.statemem.projectiledelay == nil then
                inst:ClearBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
            end
        end),



        TimeEvent(15 * FRAMES, function(inst)
            if not inst.sg.statemem.chained then
                if inst.replica.combat:GetWeapon() and inst.replica.combat:GetWeapon():HasTag("blunderbuss") then
                    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/items/weapon/blunderbuss_shoot")
                    if inst.replica.rider ~= nil and inst.replica.rider:IsRiding() then
                        local cloud = SpawnPrefab("cloudpuff")
                        local pt = inst:GetPosition()
                        cloud.Transform:SetPosition(pt.x, 4.5, pt.z)
                    else
                        local cloud = SpawnPrefab("cloudpuff")
                        local pt = inst:GetPosition()
                        cloud.Transform:SetPosition(pt.x, 2, pt.z)
                    end
                else
                    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/use_speargun")
                end
            end
        end),

        TimeEvent(16 * FRAMES, function(inst)
            if not inst.sg.statemem.chained and inst.sg.statemem.projectiledelay == nil then
                inst:ClearBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
            end
        end),
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
    end,

    events =
    {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        if inst.sg:HasStateTag("abouttoattack") and inst.replica.combat ~= nil then
            inst.replica.combat:CancelAttack()
        end
        if inst.replica.rider ~= nil and inst.replica.rider:IsRiding() then
            inst.Transform:SetSixFaced()
        end
    end,
})

----------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------

local function IsChannelCasting(inst)
    --essentially prediction, since the actions aren't busy w/ lag states
    local buffaction = inst.sg.mem.preview_channelcast_action
    if buffaction then
        return buffaction.action == ACTIONS.START_CHANNELCAST
        --Don't use "or inst:IsChannelCasting()"
        --We want to be able to return false here when predicting!
    end
    --otherwise return server state
    return inst:IsChannelCasting()
end

local function IsChannelCastingItem(inst)
    --essentially prediction, since the actions aren't busy w/ lag states
    local buffaction = inst.sg.mem.preview_channelcast_action
    if buffaction then
        return buffaction.invobject ~= nil
        --Don't use "or inst:IsChannelCastingItem()"
        --We want to be able to return false here when predicting!
    end
    --otherwise return server state
    return inst:IsChannelCastingItem()
end

local function ConfigureRunState(inst)
    if inst.replica.rider ~= nil and inst.replica.rider:IsRiding() then
        inst.sg.statemem.riding = true
        inst.sg.statemem.groggy = inst:HasTag("groggy")

        local mount = inst.replica.rider:GetMount()
        inst.sg.statemem.ridingwoby = mount and mount:HasTag("woby")
    elseif inst.replica.inventory:IsHeavyLifting() then
        inst.sg.statemem.heavy = true
        inst.sg.statemem.heavy_fast = inst:HasTag("mightiness_mighty")
    elseif IsChannelCasting(inst) then
        inst.sg.statemem.channelcast = true
        inst.sg.statemem.channelcastitem = IsChannelCastingItem(inst)
    elseif inst:HasTag("wereplayer") then
        inst.sg.statemem.iswere = true
        if inst:HasTag("weremoose") then
            if inst:HasTag("groggy") then
                inst.sg.statemem.moosegroggy = true
            else
                inst.sg.statemem.moose = true
            end
        elseif inst:HasTag("weregoose") then
            if inst:HasTag("groggy") then
                inst.sg.statemem.goosegroggy = true
            else
                inst.sg.statemem.goose = true
            end
        elseif inst:HasTag("groggy") then
            inst.sg.statemem.groggy = true
        else
            inst.sg.statemem.normal = true
        end
    elseif inst:IsInAnyStormOrCloud() and not inst.components.playervision:HasGoggleVision() then
        inst.sg.statemem.sandstorm = true
    elseif inst:HasTag("groggy") then
        inst.sg.statemem.groggy = true
    elseif inst:IsCarefulWalking() then
        inst.sg.statemem.careful = true
    else
        inst.sg.statemem.normal = true
        inst.sg.statemem.normalwonkey = inst:HasTag("wonkey") or nil
    end
end

-- 划船
AddStategraphPostInit("wilson_client", function(sg)
    Utils.FnDecorator(sg.states["run_start"], "onenter", nil, function(retTab, inst)
        local boat = inst:GetCurrentPlatform()
        if boat and boat:HasTag("shipwrecked_boat") then
            local item = boat.replica.container and boat.replica.container:GetItemInSlot(1)
            local anim = inst.replica.inventory:IsHeavyLifting() and "heavy_idle"
                or boat:HasTag("surf") and "surf_pre"
                or item and item:HasTag("sail") and "sail_pre"
                or "row_pre"
            inst.AnimState:PlayAnimation(anim)
        end
    end)

    Utils.FnDecorator(sg.states["run"], "onenter", function(inst)
        local boat = inst:GetCurrentPlatform()
        if not boat or not boat:HasTag("shipwrecked_boat") then
            return
        end

        ConfigureRunState(inst)
        inst.components.locomotor:RunForward()

        local item = boat.replica.container and boat.replica.container:GetItemInSlot(1)
        local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        local anim = inst.replica.inventory:IsHeavyLifting() and "heavy_idle"
            or boat:HasTag("surf") and "surf_loop"
            or item and item:HasTag("sail") and "sail_loop"
            or equip and equip:HasTag("oar") and "row_medium"
            or "row_loop"
        if anim == "row_loop" then
            inst.AnimState:AddOverrideBuild("player_actions_paddle")
        end
        if not inst.AnimState:IsCurrentAnimation(anim) then
            inst.AnimState:PlayAnimation(anim, true)
        end

        inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())

        return nil, true
    end)

    Utils.FnDecorator(sg.states["run"], "onexit", function(inst)
        inst.AnimState:ClearOverrideBuild("player_actions_paddle")
    end)

    Utils.FnDecorator(sg.states["run_stop"], "onenter", nil, function(retTab, inst)
        local boat = inst:GetCurrentPlatform()
        if boat and boat:HasTag("shipwrecked_boat") then
            local item = boat.replica.container and boat.replica.container:GetItemInSlot(1)
            local anim = inst.replica.inventory:IsHeavyLifting() and "heavy_idle"
                or boat:HasTag("surf") and "surf_pst"
                or item and item:HasTag("sail") and "sail_pst"
                or "row_pst"
            inst.AnimState:PlayAnimation(anim)
        end
    end)
end)
