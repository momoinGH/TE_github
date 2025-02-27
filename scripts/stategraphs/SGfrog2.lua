require("stategraphs/commonstates")

local sounds = {
    base = {
        grunt = "dontstarve/frog/grunt",
        walk = "dontstarve/frog/walk",
        spit = "dontstarve/frog/attack_spit",
        voice = "dontstarve/frog/attack_voice",
        splat = "dontstarve/frog/splat",
        die = "dontstarve/frog/die",
        wake = "dontstarve/frog/wake",
    },
    poison = {
        grunt = "dontstarve_DLC003/creatures/enemy/frog_poison/grunt",
        walk = "dontstarve/frog/walk",
        spit = "dontstarve_DLC003/creatures/enemy/frog_poison/attack_spit",
        voice = "dontstarve_DLC003/creatures/enemy/frog_poison/attack_spit",
        splat = "dontstarve/frog/splat",
        die = "dontstarve_DLC003/creatures/enemy/frog_poison/death",
        wake = "dontstarve/frog/wake",
    },
}

local actionhandlers =
{
    ActionHandler(ACTIONS.EAT, "eat"),
    ActionHandler(ACTIONS.GOHOME, "action"),
}

local events =
{
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    EventHandler("doattack",
        function(inst)
            if inst.components.health:GetPercent() > 0 and not inst.sg:HasStateTag("busy") then
                inst.sg
                    :GoToState("attack")
            end
        end),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    CommonHandlers.OnHop(),

    EventHandler("locomote",
        function(inst)
            if not inst.sg:HasStateTag("idle") and not inst.sg:HasStateTag("moving") then return end

            if not inst.components.locomotor:WantsToMoveForward() then
                if not inst.sg:HasStateTag("idle") then
                    inst.sg:GoToState("idle")
                end
            else
                if inst.onwater then
                    if not inst.sg:HasStateTag("swimming") then
                        inst.sg:GoToState("swim")
                    end
                else
                    if not inst.sg:HasStateTag("hopping") then
                        if inst.components.locomotor:WantsToRun() then
                            inst.sg:GoToState("aggressivehop")
                        else
                            inst.sg:GoToState("hop")
                        end
                    end
                end
            end
        end),
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
                inst.AnimState:PushAnimation("idle", true)
            else
                inst.AnimState:PlayAnimation("idle", true)
            end
            if not inst.onwater then
                inst.sg:SetTimeout(1 * math.random() + .5)
            end
        end,

        ontimeout = function(inst)
            if inst.components.locomotor:WantsToMoveForward() then
                inst.sg:GoToState("hop")
            else
                local num_frogs = 0
                local x, y, z = inst.Transform:GetWorldPosition()
                local ents = TheSim:FindEntities(x, y, z, 10, "frog")

                local volume = 1
                for k, v in pairs(ents) do
                    if volume > .5 and v ~= inst then
                        volume = volume - .1
                        if volume <= .5 then
                            break
                        end
                    end
                end
                inst.sounds = sounds.base
                inst.SoundEmitter:PlaySound(inst.sounds.grunt, nil, volume)
                inst.sg:GoToState("idle")
            end
        end,
    },

    State {

        name = "action",
        onenter = function(inst, playanim)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle", true)
            inst:PerformBufferedAction()
        end,
        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        }
    },

    State {
        name = "aggressivehop",
        tags = { "moving", "canrotate", "hopping", "running" },

        timeline =
        {
            TimeEvent(5 * FRAMES, function(inst)
                inst.components.locomotor:RunForward()
            end),
            TimeEvent(20 * FRAMES, function(inst)
                inst.sounds = sounds.base
                inst.SoundEmitter:PlaySound(inst.sounds.walk)
                inst.Physics:Stop()
            end),
        },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("jump_pre")
            inst.AnimState:PushAnimation("jump")
            inst.AnimState:PushAnimation("jump_pst", false)
        end,

        events =
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "hop",
        tags = { "moving", "canrotate", "hopping" },

        timeline =
        {
            TimeEvent(5 * FRAMES, function(inst)
                inst.components.locomotor:WalkForward()
            end),
            TimeEvent(20 * FRAMES, function(inst)
                inst.sounds = sounds.base
                inst.SoundEmitter:PlaySound(inst.sounds.walk)
                inst.Physics:Stop()
            end),
        },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("jump_pre")
            inst.AnimState:PushAnimation("jump")
            inst.AnimState:PushAnimation("jump_pst", false)
        end,

        events =
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "swim",
        tags = { "moving", "canrotate", "swimming" },

        onenter = function(inst)
            inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("swim_pre")
            if inst.components.burnable:IsBurning() then
                inst.components.burnable:Extinguish()
            end
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("swim_loop") end),
        },
    },

    State {
        name = "swim_loop",
        tags = { "moving", "canrotate", "swimming" },


        onenter = function(inst)
            inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("swim", true)
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("swim_loop") end),
        },
    },

    State {
        name = "attack",
        tags = { "attack" },

        onenter = function(inst, cb)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PushAnimation("atk", false)
        end,

        timeline =
        {
            TimeEvent(20 * FRAMES, function(inst)
                inst.sounds = sounds.base
                inst.SoundEmitter:PlaySound(inst.sounds.spit)
            end),
            TimeEvent(20 * FRAMES, function(inst)
                inst.sounds = sounds.base
                inst.SoundEmitter:PlaySound(inst.sounds.voice)
            end),
            TimeEvent(25 * FRAMES, function(inst) inst.components.combat:DoAttack() end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "fall",
        tags = { "busy" },
        onenter = function(inst)
            inst.Physics:SetDamping(0)
            inst.Physics:SetMotorVel(0, -20 + math.random() * 10, 0)
            inst.AnimState:PlayAnimation("fall_idle", true)
        end,

        onupdate = function(inst)
            local pt = Point(inst.Transform:GetWorldPosition())
            if pt.y < 2 then
                inst.Physics:SetMotorVel(0, 0, 0)
            end

            if pt.y <= .1 then
                pt.y = 0

                -- TODO: 20% of the time, they should explode on impact!

                inst.Physics:Stop()
                inst.Physics:SetDamping(5)
                inst.Physics:Teleport(pt.x, pt.y, pt.z)
                inst.DynamicShadow:Enable(true)
                inst.sounds = sounds.base
                inst.SoundEmitter:PlaySound(inst.sounds.splat)
                inst.sg:GoToState("idle", "jump_pst")
            end
        end,

        onexit = function(inst)
            local pt = inst:GetPosition()
            pt.y = 0
            inst.Transform:SetPosition(pt:Get())
        end,
    },


    State {
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
            inst.sounds = sounds.base
            inst.SoundEmitter:PlaySound(inst.sounds.die)
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)
            inst.components.lootdropper:DropLoot(inst:GetPosition())
        end,

    },

    State {
        name = "emerge",
        tags = { "canrotate", "busy" },

        onenter = function(inst)
            local should_move = inst.components.locomotor:WantsToMoveForward()
            local should_run = inst.components.locomotor:WantsToRun()
            if should_move then
                inst.components.locomotor:WalkForward()
            elseif should_run then
                inst.components.locomotor:RunForward()
            end
            inst.AnimState:SetBank("frog_water")
            inst.AnimState:PlayAnimation("jumpout_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("emerge_finish")
            end),
        },
    },

    State {
        name = "emerge_finish",
        tags = { "canrotate", "busy" },

        onenter = function(inst)
            local should_move = inst.components.locomotor:WantsToMoveForward()
            local should_run = inst.components.locomotor:WantsToRun()
            if should_move then
                inst.components.locomotor:WalkForward()
            elseif should_run then
                inst.components.locomotor:RunForward()
            end
            --            print("now play jumpout",inst)
            inst.AnimState:PlayAnimation("jumpout")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                --inst.AnimState:PlayAnimation("idle")
                inst.AnimState:SetBank("frog")
                inst.sg:GoToState("idle")
            end),
        },
    },

    State {
        name = "submerge",
        tags = { "canrotate", "busy" },

        onenter = function(inst)
            local should_move = inst.components.locomotor:WantsToMoveForward()
            local should_run = inst.components.locomotor:WantsToRun()
            if should_move then
                inst.components.locomotor:WalkForward()
            elseif should_run then
                inst.components.locomotor:RunForward()
            end

            inst.AnimState:SetBank("frog_water")
            --            print("setbank: frog_water")
            inst.AnimState:PlayAnimation("jumpin_pre")
            --            print("play anim: jumpin_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("submerge_finish")
            end),
        },
    },
    State {
        name = "submerge_finish",
        tags = { "canrotate", "busy" },

        onenter = function(inst)
            local should_move = inst.components.locomotor:WantsToMoveForward()
            local should_run = inst.components.locomotor:WantsToRun()
            if should_move then
                inst.components.locomotor:WalkForward()
            elseif should_run then
                inst.components.locomotor:RunForward()
            end

            inst.AnimState:PlayAnimation("jumpin")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },
    State {
        name = "eat",
        tags = { "canrotate", "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PushAnimation("atk", false)
        end,

        timeline =
        {
            TimeEvent(20 * FRAMES, function(inst)
                inst.sounds = sounds.base
                inst.SoundEmitter:PlaySound(inst.sounds.spit)
            end),
            TimeEvent(20 * FRAMES, function(inst)
                inst.sounds = sounds.base
                inst.SoundEmitter:PlaySound(inst.sounds.voice)
            end),
            TimeEvent(17 * FRAMES, function(inst) inst:PerformBufferedAction() end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

}

CommonStates.AddSleepStates(states,
    {
        waketimeline = {
            TimeEvent(0 * FRAMES,
                function(inst)
                    inst.sounds = sounds.base
                    inst.SoundEmitter:PlaySound(inst.sounds.wake)
                end),
        },
    })
CommonStates.AddFrozenStates(states)
CommonStates.AddHopStates(states, true, { loop = "jump" }) --, { pre = "boat_jump_pre", loop = "boat_jump_loop", pst = "boat_jump_pst"})

return StateGraph("frog2", states, events, "idle", actionhandlers)
