local actionhandlers = {
    ActionHandler(ACTIONS.GIVE_SHELF, "give"),
    ActionHandler(ACTIONS.TAKE_SHELF, "give"),
    ActionHandler(ACTIONS.GAS, "crop_dust"),
    --剪刀剪
    ActionHandler(ACTIONS.SHEAR, function(inst)
        if not inst.sg:HasStateTag("preshear") then
            if inst.sg:HasStateTag("shearing") then
                return "shear"
            else
                return "shear_start"
            end
        end
    end),
    ActionHandler(ACTIONS.PAN, function(inst)
        if not inst.sg:HasStateTag("panning") then
            return "pan_start"
        end
    end),
}

local eventhandlers = {
    -- 害怕大鹏鸟
    EventHandler("cower", function(inst, data)
        if not (inst.components.health:IsDead() or inst.sg:HasStateTag("sleeping") or inst.sg:HasStateTag("frozen")) then
            inst.sg:GoToState("cower", data)
        end
    end),
    -- 被大鹏鸟抓住
    EventHandler("grabbed", function(inst)
        if not (inst.components.health:IsDead() or inst.components.health:IsInvincible() or
            --[[inst.sg:HasStateTag("sleeping") or inst.sg:HasStateTag("frozen") or]] inst.sg:HasStateTag("busy")) then
            inst.sg:GoToState("grabbed")
        end
    end),
    -- 蚁后叫喊
    EventHandler("sanity_stun", function(inst, data)
        if not inst.components.inventory:IsItemNameEquipped("earmuffshat") then
            inst.sg:GoToState("sanity_stun", data.duration)
            inst.components.sanity:DoDelta(-TUNING.SANITY_LARGE)
        end
    end),
    --花粉打喷嚏
    EventHandler("sneeze", function(inst, data)
        if not inst.components.health:IsDead() and not inst.components.health.invincible then
            if inst.sg:HasStateTag("busy") and inst.sg.currentstate.name ~= "emote" then
                inst.components.hayfever.wantstosneeze = true
            else
                inst.sg:GoToState("sneeze")
            end
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

    -- TODO 大鹏鸟抓住相关逻辑没写完，还有后续state
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

                if inst.DynamicShadow then
                    inst.DynamicShadow:Enable(false)
                end
            end),
        },
    },

    -- 硬控玩家几秒
    State {
        name = "sanity_stun",
        tags = { "busy" },

        onenter = function(inst, duration)
            inst.components.playercontroller:Enable(false)
            inst.components.locomotor:Stop()

            inst.AnimState:PlayAnimation("idle_sanity_pre", false)
            inst.AnimState:PushAnimation("idle_sanity_loop", true)

            inst.sg:SetTimeout(duration or 4)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("idle")
        end,

        onexit = function(inst)
            inst.components.playercontroller:Enable(true)
        end
    },

    -- 花粉症打喷嚏
    State {
        name = "sneeze",
        tags = { "busy", "sneeze", "pausepredict" },

        onenter = function(inst)
            local usehit = inst.components.rider:IsRiding() or inst:HasTag("wereplayer")
            local stun_frames = usehit and 6 or 9
            inst.components.hayfever.wantstosneeze = false
            inst:ClearBufferedAction()
            inst.components.locomotor:Stop()
            inst.SoundEmitter:PlaySound("dontstarve/wilson/hit", nil, .02)


            if inst.components.rider ~= nil and not inst.components.rider:IsRiding() then
                inst.AnimState:PlayAnimation("sneeze")
            end

            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:RemotePausePrediction(stun_frames <= 7 and stun_frames or nil)
            end


            if inst.prefab ~= "wes" then
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/sneeze")
                inst.components.talker:Say(STRINGS.CHARACTERS.GENERIC.ANNOUNCE_SNEEZE)
            end
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },

        timeline =
        {
            TimeEvent(1 * FRAMES, function(inst)
                local itemstodrop = 0
                if math.random() < 0.6 then itemstodrop = itemstodrop + 1 end
                if math.random() < 0.3 then itemstodrop = itemstodrop + 1 end
                if math.random() < 0.2 then itemstodrop = itemstodrop + 1 end
                if math.random() < 0.1 then itemstodrop = itemstodrop + 1 end

                if itemstodrop > 0 then
                    for i = 1, itemstodrop do
                        if inst.components.inventory and inst.components.inventory.isopen then
                            local item = inst.components.inventory:FindItem(function(item)
                                return not item:HasTag(
                                    "nosteal")
                            end)
                            if item then
                                local direction = inst:GetPosition() -
                                    inst:GetPosition()
                                inst.components.inventory:DropItem(item, false, direction:GetNormalized())
                            end
                        end
                    end
                end
            end),
            TimeEvent(10 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
                if inst.components.sanity then inst.components.sanity:DoDelta(-3) end
            end),
        },
    },

    -- 喷
    State {
        name = "crop_dust",
        tags = { "busy", "canrotate" },

        onenter = function(inst)
            if inst.components.rider:IsRiding() then
                inst.Transform:SetFourFaced()
            end

            local pos = inst:GetBufferedAction() and inst:GetBufferedAction():GetActionPoint()
            if pos then
                inst:FacePoint(pos:Get())
            end

            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("cropdust_pre")
            inst.AnimState:PushAnimation("cropdust_loop")
            inst.AnimState:PushAnimation("cropdust_pst", false)
        end,

        timeline =
        {
            TimeEvent(20 * FRAMES, function(inst)
                inst:PerformBufferedAction()
                inst.sg:RemoveStateTag("busy")
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/items/weapon/bugrepellant")
            end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },

        onexit = function(inst)
            if inst.components.rider:IsRiding() then
                inst.Transform:SetSixFaced()
            end
        end,
    },

    -- 淘金
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
            inst.sg:SetTimeout(1 + math.random())
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
            inst:PerformBufferedAction()
            inst.sg:GoToState("idle", "pan_pst")
        end,

        events =
        {
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle", "pan_pst") end),
        },
    },

    -- 放大镜调查
    State {
        name = "investigate",
        tags = { "preinvestigate", "investigating", "working" },
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("lens")
            inst.AnimState:PushAnimation("lens_pst", false)
        end,

        timeline =
        {
            TimeEvent(9 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("preinvestigate")
            end),


            TimeEvent(16 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("investigating")
            end),

            TimeEvent(45 * FRAMES, function(inst)
                -- this covers both mystery and lighting now
                inst:PerformBufferedAction()
            end),
        },

        events =
        {
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    -- 锤子敲文物
    State {
        name = "tap",
        tags = { "doing", "busy" },

        onenter = function(inst, timeout)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("tamp_pre")
            inst.AnimState:PushAnimation("tamp_loop", true)
            inst.sg:SetTimeout(timeout or 1)
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
            inst:PerformBufferedAction()
            inst.sg:GoToState("tap_pst")
        end,
    },

    State {
        name = "tap_pst",
        tags = { "idle" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("tamp_pst")
        end,
        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    }
}

for _, actionhandler in ipairs(actionhandlers) do
    AddStategraphActionHandler("wilson", actionhandler)
end

for _, eventhandler in ipairs(eventhandlers) do
    AddStategraphEvent("wilson", eventhandler)
end

for _, state in ipairs(states) do
    AddStategraphState("wilson", state)
end

----------------------------------------------------------------------------------------------------

AddStategraphPostInit("wilson", function(sg)
    Utils.FnDecorator(sg.actionhandlers[ACTIONS.LIGHT], "deststate", function(inst, action)
        local equipped = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if equipped and equipped:HasTag("magnifying_glass") then
            return { "investigate" }, true
        end
    end)
end)
