require("stategraphs/commonstates")

local assets =
{
    Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),
    Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),
}

local actionhandlers =
{
    ActionHandler(ACTIONS.EAT, "eat"),
    ActionHandler(ACTIONS.GOHOME, "enterhome"),
    ActionHandler(ACTIONS.INVESTIGATE, "investigate"),
}

local events =
{
    EventHandler("attacked", function(inst)
        if not inst.components.health:IsDead() then
            if inst:HasTag("slip_warrior") or inst:HasTag("slip_spitter") then
                if not inst.sg:HasStateTag("attack") then -- don't interrupt attack or exit shield
                    inst.sg:GoToState("hit")              -- can still attack
                end
            elseif not inst.sg:HasStateTag("shield") then
                inst.sg:GoToState("hit_stunlock") -- can't attack during hit reaction
            end
        end
    end),
    EventHandler("doattack", function(inst, data)
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
            --target CAN go invalid because SG events are buffered
            local ataquetipo = math.random(1, 3)
            if ataquetipo == 1 then
                inst.sg:GoToState(
                    data.target:IsValid()
                    and not inst:IsNear(data.target, TUNING.SPIDER_WARRIOR_MELEE_RANGE)
                    and "warrior_attack" --Do leap attack
                    or "attack",
                    data.target
                )
            elseif ataquetipo == 2 then
                inst.sg:GoToState(
                    data.target:IsValid()
                    and not inst:IsNear(data.target, TUNING.SPIDER_SPITTER_MELEE_RANGE)
                    and "spitter_attack" --Do spit attack
                    or "attack",
                    data.target
                )
            else
                inst.sg:GoToState("attack", data.target)
            end
        end
    end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    EventHandler("entershield", function(inst) inst.sg:GoToState("shield") end),
    EventHandler("exitshield", function(inst) inst.sg:GoToState("shield_end") end),

    EventHandler("locomote", function(inst)
        if not inst.sg:HasStateTag("busy") then
            local is_moving = inst.sg:HasStateTag("moving")
            local wants_to_move = inst.components.locomotor:WantsToMoveForward()
            if not inst.sg:HasStateTag("attack") and is_moving ~= wants_to_move then
                if wants_to_move then
                    inst.sg:GoToState("premoving")
                else
                    inst.sg:GoToState("idle")
                end
            end
        end
    end),

    EventHandler("trapped", function(inst)
        if not inst.sg:HasStateTag("busy") then
            inst.sg:GoToState("trapped")
        end
    end),
}

local function SoundPath(inst, event)
    local creature = "spider"

    if inst:HasTag("slip_warrior") then
        creature = "spiderwarrior"
    elseif inst:HasTag("slip_hider") or inst:HasTag("slip_spitter") then
        creature = "cavespider"
    else
        creature = "spider"
    end
    return "dontstarve/creatures/" .. creature .. "/" .. event
end

local states =
{
    State {
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
            inst.SoundEmitter:PlaySound(SoundPath(inst, "die"))
            inst.AnimState:PlayAnimation("death2")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)
            inst.components.lootdropper:DropLoot(inst:GetPosition())
        end,
    },

    State {
        name = "premoving",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("transform_loop")
            inst.AnimState:PushAnimation("transform2_loop")
        end,

        timeline =
        {
            TimeEvent(3 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(SoundPath(inst,
                    "dontstarve_DLC002/creatures/twister/walk")) end),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("moving") end),
        },
    },

    State {
        name = "moving",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst.AnimState:PushAnimation("transform3_loop")
        end,

        timeline =
        {
            TimeEvent(0 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/twister/walk") end),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("moving") end),
        },
    },

    State {
        name = "idle",
        tags = { "idle", "canrotate" },

        ontimeout = function(inst)
            inst.sg:GoToState("taunt")
        end,

        onenter = function(inst, start_anim)
            inst.Physics:Stop()
            local animname = "idle"
            if math.random() < .3 then
                inst.sg:SetTimeout(math.random() * 2 + 2)
            end

            if inst.LightWatcher:GetLightValue() > 1 then
                inst.AnimState:PlayAnimation("cower")
                inst.AnimState:PushAnimation("cower_loop", true)
            elseif start_anim then
                inst.AnimState:PlayAnimation(start_anim)
                inst.AnimState:PushAnimation("eat_loop", true)
            else
                inst.AnimState:PlayAnimation("eat_loop", true)
            end
        end,
    },

    State {
        name = "eat",
        tags = { "busy" },

        onenter = function(inst, forced)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("eat_pre")
            inst.sg.statemem.forced = forced
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState((inst:PerformBufferedAction() or inst.sg.statemem.forced) and "eat_loop" or "eat_loop")
            end),
        },
    },

    State {
        name = "enterhome",
        tags = { "busy" },

        onenter = function(inst, forced)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("atk")
            inst.AnimState:PushAnimation("taunt2")
            inst.sg.statemem.forced = forced
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState((inst:PerformBufferedAction() or inst.sg.statemem.forced))
            end),
        },
    },

    State {
        name = "born",
        tags = { "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("taunt")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "eat_loop",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("eat_loop", true)
            inst.sg:SetTimeout(1 + math.random() * 1)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("idle", "eat_pst")
        end,
    },

    State {
        name = "taunt",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            inst.SoundEmitter:PlaySound(SoundPath(inst, "scream"))
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "investigate",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            inst.SoundEmitter:PlaySound(SoundPath(inst, "scream"))
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst:PerformBufferedAction()
                inst.sg:GoToState("idle")
            end),
        },
    },

    State {
        name = "attack",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("eat_pre")
            inst.sg.statemem.target = target
        end,

        timeline =
        {
            TimeEvent(10 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(SoundPath(inst, "Attack")) end),
            TimeEvent(10 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(SoundPath(inst, "attack_grunt")) end),
            TimeEvent(18 * FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "warrior_attack",
        tags = { "attack", "canrotate", "busy", "jumping" },

        onenter = function(inst, target)
            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(false)

            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("eat_pre")
            inst.sg.statemem.target = target
        end,

        onexit = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(true)
            inst.Physics:ClearMotorVelOverride()
        end,

        timeline =
        {
            TimeEvent(0 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(SoundPath(inst, "attack_grunt")) end),
            TimeEvent(0 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(SoundPath(inst, "Jump")) end),
            TimeEvent(8 * FRAMES, function(inst) inst.Physics:SetMotorVelOverride(20, 0, 0) end),
            TimeEvent(9 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(SoundPath(inst, "Attack")) end),
            TimeEvent(19 * FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
            TimeEvent(20 * FRAMES,
                function(inst)
                    inst.Physics:ClearMotorVelOverride()
                    inst.components.locomotor:Stop()
                end),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("taunt") end),
        },
    },

    State {
        name = "spitter_attack",
        tags = { "attack", "canrotate", "busy", "spitting" },

        onenter = function(inst, target)
            if inst.weapon and inst.components.inventory then
                inst.components.inventory:Equip(inst.weapon)
            end
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("eat_pre")
            inst.sg.statemem.target = target
        end,

        onexit = function(inst)
            if inst.components.inventory then
                inst.components.inventory:Unequip(EQUIPSLOTS.HANDS)
            end
        end,

        timeline =
        {
            TimeEvent(7 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound(SoundPath(inst, "spit_web"))
            end),

            TimeEvent(21 * FRAMES, function(inst)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst.SoundEmitter:PlaySound(SoundPath(inst, "spit_voice"))
            end),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("taunt") end),
        },
    },

    State {
        name = "hit",

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
        name = "hit_stunlock",
        tags = { "busy" },

        onenter = function(inst)
            inst.SoundEmitter:PlaySound(SoundPath(inst, "hit_response"))
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "shield",
        tags = { "busy", "shield" },

        onenter = function(inst)
            --If taking fire damage, spawn fire effect.
            inst.components.health:SetAbsorptionAmount(TUNING.SPIDER_HIDER_SHELL_ABSORB)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("sleep_pre")
            inst.AnimState:PushAnimation("sleep_loop")
        end,

        onexit = function(inst)
            inst.components.health:SetAbsorptionAmount(0)
        end,
    },

    State {
        name = "shield_end",
        tags = { "busy", "shield" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("sleep_pst")
        end,

        events =
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "dropper_enter",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt2")
            inst.AnimState:PushAnimation("taunt3")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/descend")
        end,

        events =
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("taunt") end),
        },
    },

    State {
        name = "trapped",
        tags = { "busy", "trapped" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst:ClearBufferedAction()
            inst.AnimState:PlayAnimation("cower")
            inst.AnimState:PushAnimation("cower_loop", true)
            inst.sg:SetTimeout(1)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("idle")
        end,
    },
}

CommonStates.AddSleepStates(states,
    {
        starttimeline = {
            TimeEvent(0 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(SoundPath(inst, "fallAsleep")) end),
        },
        sleeptimeline =
        {
            TimeEvent(35 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(SoundPath(inst, "sleeping")) end),
        },
        waketimeline = {
            TimeEvent(0 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(SoundPath(inst, "wakeUp")) end),
        },
    })
CommonStates.AddFrozenStates(states)

return StateGraph("slip", states, events, "idle", actionhandlers)
