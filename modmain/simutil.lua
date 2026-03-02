local old_CanEntitySeePoint = GLOBAL.CanEntitySeePoint
GLOBAL.CanEntitySeePoint = function(inst, ...)
    return old_CanEntitySeePoint(inst, ...) or inst:IsInHamRoom()
end

local old_CanEntitySeeInDark = GLOBAL.CanEntitySeeInDark
GLOBAL.CanEntitySeeInDark = function(inst)
    return old_CanEntitySeeInDark(inst) or inst:IsInHamRoom()
end
