local Utils = require("tropical_utils/utils")

local TIMEOUT = 2

AddStategraphState("wilson_client", State {
    name = "shear_start",
    tags = { "preshear", "shearing", "working" },
    server_states = { "shear_start", "shear" },
    onenter = function(inst)
        inst.components.locomotor:Stop()
        if not inst.sg:ServerStateMatches() then
            inst.AnimState:PlayAnimation("cut_pre")
        end

        inst.sg:SetTimeout(TIMEOUT)
        inst:PerformPreviewBufferedAction()
    end,
    onupdate = function(inst)
        if inst.sg:ServerStateMatches() then
            if inst.entity:FlattenMovementPrediction() then
                inst.sg:GoToState("idle", "noanim")
            end
        elseif inst.bufferedaction == nil then
            inst.sg:GoToState("idle")
        end
    end,
    ontimeout = function(inst)
        inst:ClearBufferedAction()
        inst.sg:GoToState("idle")
    end,
    events =
    {
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("animover", function(inst) inst.sg:GoToState("shear") end),
    },
})

AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.SHEAR, function(inst)
    if not inst.sg:HasStateTag("preshear") then
        return "shear_start"
    end
end))
