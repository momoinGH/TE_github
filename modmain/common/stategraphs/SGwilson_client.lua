local Utils = require("tropical_utils/utils")

AddStategraphPostInit("wilson_client", function(sg)
    Utils.FnDecorator(sg.actionhandlers[ACTIONS.JUMPIN], "deststate", function(inst, act)
        return { "give" }, act.target and act.target:HasTag("hamlet_housedoor")
    end)
end)
