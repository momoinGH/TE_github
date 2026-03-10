local actionhandlers = {

}

local eventhandlers = {

}

local states = {
    -- 望远镜
    State {
        name = "peertelescope",
        tags = { "doing", "busy", "nopredict", "canrotate" },

        onenter = function(inst, data)
            inst.components.locomotor:Stop()
            local pos = inst:GetBufferedAction() and inst:GetBufferedAction():GetActionPoint()
            if pos then
                inst:ForceFacePoint(pos:Get())
            end

            inst.components.playercontroller:Enable(false)
            inst.AnimState:PlayAnimation("telescope", false)
            inst.AnimState:PushAnimation("telescope_pst", false)
        end,

        timeline =
        {
            TimeEvent(20 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/use_spyglass")
            end),
        },

        events = {
            EventHandler("animover", function(inst)
                inst:PerformBufferedAction()
            end),
            EventHandler("animqueueover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },

        onexit = function(inst)
            inst.components.playercontroller:Enable(true)
        end,
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
    --望远镜
    Hooks.FnDecorator(sg.actionhandlers[ACTIONS.CASTSPELL], "deststate", function(inst)
        local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if item and item:HasTag("telescope") then
            return { "peertelescope" }, true
        end
    end)
end)
