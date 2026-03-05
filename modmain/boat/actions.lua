-- 跳船
Constructor.AddAction({ priority = 10, distance = 4, mount_valid = false, encumbered_valid = true },
    "BOATMOUNT",
    STRINGS.ACTIONS.BOATMOUNT,
    function(act)
        act.doer.components.pro_driver:StartHopBoat(act.target)
        return true
    end
)
