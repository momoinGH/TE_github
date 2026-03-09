local actionhandlers = {

}

local eventhandlers = {

}

local states = {
    State {
        name = "peertelescope",
        tags = { "doing", "busy", "canrotate" },

        onenter = function(inst, data)
            local act
            inst.sg.statemem.action = inst:GetBufferedAction()
            local buffaction = inst:GetBufferedAction()
            if buffaction ~= nil and buffaction.pos ~= nil then
                act = buffaction:GetActionPoint()
            end
            inst:ForceFacePoint(act.x, act.y, act.z)
            inst.components.playercontroller:Enable(false)
            inst.AnimState:PlayAnimation("telescope", false)
            inst.AnimState:PushAnimation("telescope_pst", false)

            inst.components.locomotor:Stop()
        end,

        timeline =
        {
            TimeEvent(20 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/use_spyglass")
            end),
        },

        onexit = function(inst)
            inst.components.playercontroller:Enable(true)
        end,

        events = {
            EventHandler("animover", function(inst)
                inst:PerformBufferedAction()
            end),
            EventHandler("animqueueover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
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

AddStategraphPostInit("wilson", function(sg)
    --望远镜
    Utils.FnDecorator(sg.actionhandlers[ACTIONS.CASTSPELL], "deststate", function(inst)
        local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if item and item:HasTag("telescope") then
            return { "peertelescope" }, true
        end
    end)
end)
