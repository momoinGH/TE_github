local Utils = require("tropical_utils/utils")


Utils.FnDecorator(GLOBAL, "PlayFootstep", function(inst)
    return nil, inst.replica.inventory and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.SWBOAT) --海难小船时不播放走路音效
end)
