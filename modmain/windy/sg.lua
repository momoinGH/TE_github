
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Mod Action (give) [too lazy to make new component for goddess item repair]
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.GIVE, function(inst, action)
    return action.invobject ~= nil and action.target ~= nil and (
            (action.target:HasTag("moonportal") and action.invobject:HasTag("moonportalkey") and "dochannelaction") or
            (action.invobject.prefab == "quagmire_portal_key" and action.target:HasTag("quagmire_altar") and "quagmireportalkey") or
            (action.target:HasTag("goddess_item") and "dolongaction") or
            (action.target:HasTag("trader") and "give"))
        or "give"
end))
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Mod Action (play_goddess_bell) [this should make the bell appear in cave servers and let this bell work with other bell mods]
AddStategraphState("wilson", State {
    name = "play_goddess_bell",
    tags = { "doing", "playing" },
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("action_uniqueitem_pre")
        inst.AnimState:PushAnimation("bell", false)
        inst.AnimState:OverrideSymbol("bell01", "goddess_bell", "bell01")
        inst.AnimState:Show("ARM_normal")
        inst.components.inventory:ReturnActiveActionItem(inst.bufferedaction ~= nil and inst.bufferedaction.invobject or
            nil)
    end,
    timeline = {
        TimeEvent(15 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/glommer_bell")
        end),
        TimeEvent(60 * FRAMES, function(inst)
            inst:PerformBufferedAction()
        end),
    },
    events = {
        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },
    onexit = function(inst)
        if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
            inst.AnimState:Show("ARM_carry")
            inst.AnimState:Hide("ARM_normal")
        end
    end,
})
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Mod Action (play_goddess_flute)
AddStategraphState("wilson", State {
    name = "play_goddess_flute",
    tags = { "doing", "playing" },
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("action_uniqueitem_pre")
        inst.AnimState:PushAnimation("flute", false)
        inst.AnimState:OverrideSymbol("pan_flute01", "goddess_flute", "pan_flute01")
        inst.AnimState:Hide("ARM_carry")
        inst.AnimState:Show("ARM_normal")
        inst.components.inventory:ReturnActiveActionItem(inst.bufferedaction ~= nil and inst.bufferedaction.invobject or
            nil)
    end,
    timeline =
    {
        TimeEvent(30 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/wilson/flute_LP", "flute")
            inst:PerformBufferedAction()
        end),
        TimeEvent(85 * FRAMES, function(inst)
            inst.SoundEmitter:KillSound("flute")
        end),
    },
    events =
    {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },
    onexit = function(inst)
        inst.SoundEmitter:KillSound("flute")
        if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
            inst.AnimState:Show("ARM_carry")
            inst.AnimState:Hide("ARM_normal")
        end
    end,
})
