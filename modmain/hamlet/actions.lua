local Utils = require("tropical_utils/utils")

Utils.FnDecorator(ACTIONS.COOK, "stroverridefn", function(act)
    if act.target and act.target.prefab == "smelter" then
        return { STRINGS.ACTIONS.SMELT }, true
    end
end)
