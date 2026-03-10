local TIMEOUT = 2

local actionhandlers = {
    ActionHandler(ACTIONS.GIVE_SHELF, "give"),
    ActionHandler(ACTIONS.TAKE_SHELF, "give"),
    ActionHandler(ACTIONS.GAS, "crop_dust"),
    ActionHandler(ACTIONS.SHEAR, function(inst)
        if not inst.sg:HasStateTag("preshear") then
            return "shear_start"
        end
    end),
    ActionHandler(ACTIONS.PAN, function(inst)
        if not inst.sg:HasStateTag("panning") then
            return "pan_start"
        end
    end),
    ActionHandler(ACTIONS.SMELT, "doshortaction")
}

local eventhandlers = {
    EventHandler("sanity_stun", function(inst, data)
        if not inst.replica.inventory:IsItemNameEquipped("earmuffshat") then
            inst.sg:GoToState("sanity_stun", data.duration)
        end
    end)
}

local states = {
    State {
        name = "cower",
        tags = { "cower", "pausepredict" },

        onenter = function(inst, data)
            inst.components.locomotor:Stop()
            inst:ClearBufferedAction()
            inst.AnimState:PlayAnimation("cower")
            inst.components.talker:Say("要被吃掉了!") --GetString(inst, "ANNOUNCE_QUAKE")
        end,
    },

    State {
        name = "grabbed",
        tags = { "busy", "pausepredict" },

        onenter = function(inst, data)
            if inst.components.playercontroller then
                inst.components.playercontroller:Enable(false)
            end
            if inst.player_classified and inst.player_classified.MapExplorer then
                inst.player_classified.MapExplorer:EnableUpdate(false)
            end
            -- inst.AnimState:SetFinalOffset(-10)
            inst.components.sanity:DoDelta(-TUNING.SANITY_MED)
            -- inst.components.health:SetInvincible(true)
            inst.AnimState:PlayAnimation("grab_loop")
            -- inst:ShakeCamera(CAMERASHAKE.FULL, 2, .06, .25) -- duration, speed, scale
        end,
        events =
        {
            EventHandler("animover", function(inst)
                inst:Hide()
                if inst.HUD then
                    inst.HUD:Hide()
                end
            end),
        },
    },

    -- 硬控玩家几秒
    State {
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
    },

    State {
        name = "crop_dust",
        server_states = { "crop_dust" },
        forward_server_states = true,
        onenter = function(inst) inst.sg:GoToState("action_uniqueitem_busy") end,
    },

    State { name = "pan_start",
        tags = { "prepan", "panning", "working" },
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("pan_pre")
        end,

        events =
        {
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animover", function(inst) inst.sg:GoToState("pan") end),
        },
    },

    State {
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
    },

    State {
        name = "investigate",
        tags = { "preinvestigate", "investigating", "working" },
        onenter = function(inst)
            inst.components.locomotor:Stop()
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
        events =
        {
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animover", function(inst)
                inst.sg:GoToState("investigate_post")
            end),
        },
    },

    State { name = "investigate_post",
        tags = { "investigating", "working" },
        onenter = function(inst)
            if inst.replica.rider:IsRiding() then
                inst.Transform:SetFourFaced()
            end
            inst.AnimState:PlayAnimation("lens_pst")
        end,
        onexit = function(inst)
            if inst.replica.rider:IsRiding() then
                inst.Transform:SetSixFaced()
            end
        end,
        events =
        {
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
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
    }
}

for _, actionhandler in ipairs(actionhandlers) do
    AddStategraphActionHandler("wilson_client", actionhandler)
end

for _, eventhandler in ipairs(eventhandlers) do
    AddStategraphEvent("wilson_client", eventhandler)
end

for _, state in ipairs(states) do
    AddStategraphState("wilson_client", state)
end

----------------------------------------------------------------------------------------------------

AddStategraphPostInit("wilson_client", function(sg)
    Hooks.FnDecorator(sg.actionhandlers[ACTIONS.LIGHT], "deststate", function(inst, action)
        local equipped = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if equipped and equipped:HasTag("magnifying_glass") then
            return { "investigate" }, true
        end
    end)
end)
