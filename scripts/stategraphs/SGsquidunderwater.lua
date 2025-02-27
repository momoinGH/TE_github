require("stategraphs/commonstates")

-- Anims
-- hit
-- idle
-- gotosleep
-- sleeping
-- wakeup
-- eat
-- Swimming_right1 (2/3)
-- Swimming_left1 (2/3)

local actionhandlers =
{
    ActionHandler(ACTIONS.EAT, "eat"),
}

local events =
{
    CommonHandlers.OnLocomote(true, true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnAttacked(true),
    CommonHandlers.OnDeath(),
}

local states =
{
    State {
        name = "idle",
        tags = { "idle", "canrotate", "canslide" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("idle", true)
            inst:DoTaskInTime(math.random(0, 1), function(inst)
                local x, y, z = inst.Transform:GetWorldPosition()
                local bubble = SpawnPrefab("bubble_fx_small")
                bubble.Transform:SetPosition(x, y + 2, z)
            end)
        end,
    },

    State {
        name = "hit",
        tags = { "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "eat",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("eat")
        end,

        timeline =
        {
            TimeEvent(10 * FRAMES, function(inst) inst:PerformBufferedAction() end),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("sleep_pre")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)
            inst.components.lootdropper:DropLoot(inst:GetPosition())
        end,

    },
}

CommonStates.AddSleepStates(states)
CommonStates.AddWalkStates(states)
CommonStates.AddRunStates(states)

return StateGraph("squidunderwater", states, events, "idle", actionhandlers)
