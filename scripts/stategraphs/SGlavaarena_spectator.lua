local actionhandlers =
{

}
local events =
{

}

local function GetNewState()
    if next(TheWorld.components.lavaarenamobtracker.ents) then
        return math.random() < 0.25 and "boo" or "cheer"
    elseif math.random() < 0.15 then
        return "eat"
    end
    return nil
end

local cheers = { "cheer", "cheer2", "cheer3" }
local eats = { "eat_l", "eat_r" }
local states =
{
    State {

        name = "idle",
        tags = { "idle", "canrotate" },
        onenter = function(inst)
            local state = GetNewState()
            if state then
                inst.sg:GoToState(state)
            end

            inst.AnimState:PlayAnimation("idle_loop")
        end,

        events =
        {
            EventHandler("animover", function(inst, data) inst.sg:GoToState("idle") end),
        }
    },
    State {
        name = "boo",
        tags = { "idle", "canrotate" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("boo")
        end,
        events =
        {
            EventHandler("animover", function(inst, data) inst.sg:GoToState("idle") end),
        }
    },
    State {
        name = "cheer",
        tags = { "idle", "canrotate" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation(cheers[math.random(#cheers)])
        end,
        events =
        {
            EventHandler("animover", function(inst, data) inst.sg:GoToState("idle") end),
        }
    },
    State {
        name = "eat",
        tags = { "idle", "canrotate" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation(eats[math.random(#eats)])
        end,
        events =
        {
            EventHandler("animover", function(inst, data) inst.sg:GoToState("idle") end),
        }
    },
    State {
        name = "chat",
        tags = { "idle", "canrotate" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("chat") --只有朝下的动画
        end,
        events =
        {
            EventHandler("animover", function(inst, data) inst.sg:GoToState("idle") end),
        },
    },
}
return StateGraph("lavaarena_spectator", states, events, "idle", actionhandlers)
