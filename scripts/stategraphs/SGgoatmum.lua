require("stategraphs/commonstates")

local actionhandlers =
{
    ActionHandler(ACTIONS.GOHOME, "gohome"),
}

local events =
{
    CommonHandlers.OnLocomote(true, true),
}

local states =
{

    State {

        name = "idle",
        tags = { "idle", "canrotate" },
        onenter = function(inst, playanim)
            inst.Physics:Stop()
            if playanim then
                inst.AnimState:PlayAnimation(playanim)
                inst.AnimState:PushAnimation("idle_loop", true)
            else
                inst.AnimState:PlayAnimation("idle_loop", true)
            end
        end,

    },

    State {
        name = "idle_happy",
        tags = { "idle_happy", "busy" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("idle_happy")
            inst.Physics:Stop()
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "goodbye",
        tags = { "busy" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("goodbye")
            inst.Physics:Stop()
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("goodbye_loop") end),
        },
    },

    State {
        name = "goodbye_loop",
        tags = { "busy" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("goodbye_loop")
            inst.Physics:Stop()
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "give_item",
        tags = { "busy" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("give_item")
            inst.Physics:Stop()
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "coin",
        tags = { "busy" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.Transform:SetRotation(270)
            inst.AnimState:PlayAnimation("coin", false)
            inst.coin = true
        end,

        timeline = {
            TimeEvent(23 * FRAMES, function(inst)
                for i = 1, 10 do
                    inst:DoTaskInTime(math.random() / 5 + i / 100, function(inst)
                        local offset = 1
                        local spd = 1.75 + math.random() * 2.5
                        local angle = (135 + math.random() * 45) * DEGREES * 1.1
                        local x, y, z = inst.Transform:GetWorldPosition()
                        local coin = SpawnPrefab("quagmire_coin1")
                        coin.Transform:SetPosition(x - math.sin(angle) * offset, 1.35, z - math.cos(angle) * offset)
                        coin:Toss()
                        coin.Physics:SetVel(math.cos(angle) * spd, 12, math.sin(angle) * spd)
                    end)
                end

                inst.sg:RemoveStateTag("busy")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State {
        name = "look1",
        tags = { "hit", "busy" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("look1")
            inst.Physics:Stop()
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "look2",
        tags = { "hit", "busy" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("look2")
            inst.Physics:Stop()
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "start",
        tags = { "hit", "busy" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("start_pre")
            inst.AnimState:PushAnimation("start_loop")
            inst.AnimState:PushAnimation("start_pst")
            inst.Physics:Stop()
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "talk1",
        tags = { "hit", "busy" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("talk1")
            inst.Physics:Stop()
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "talk2",
        tags = { "hit", "busy" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("talk2")
            inst.Physics:Stop()
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "talk3",
        tags = { "hit", "busy" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("talk3")
            inst.Physics:Stop()
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "talk4",
        tags = { "hit", "busy" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("talk4")
            inst.Physics:Stop()
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

}

CommonStates.AddSleepStates(states,
    {
        sleeptimeline =
        {
            TimeEvent(35 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/sleep") end),
        },
    })

CommonStates.AddIdle(states)
CommonStates.AddSimpleActionState(states, "pickup", "walk_loop", 10 * FRAMES, { "busy" })
CommonStates.AddSimpleActionState(states, "gohome", "walk_loop", 4 * FRAMES, { "busy" })
CommonStates.AddFrozenStates(states)

CommonStates.AddWalkStates(states,
    {
        walktimeline =
        {
            TimeEvent(0 * FRAMES, PlayFootstep),
            TimeEvent(12 * FRAMES, PlayFootstep),
        },
    })
CommonStates.AddRunStates(states,
    {
        runtimeline = {
            TimeEvent(0 * FRAMES, PlayFootstep),
            TimeEvent(10 * FRAMES, PlayFootstep),
        },
    })


return StateGraph("goatmum", states, events, "idle", actionhandlers)
