Constructor.AddAction({ priority = 3, instant = false, mount_valid = true, rmb = true, distance = 1, canforce = true },
    "MEAL",
    STRINGS.ACTIONS.MEAL,
    function(act)
        if act.target ~= nil and act.target.components.mealer ~= nil then
            act.target.components.mealer:StartMealing()
            return true
        end
    end
)

Constructor.AddAction(nil,
    "SNACKRIFICE",
    STRINGS.ACTIONS.SNACKRIFICE,
    function(act)
        local snackrificer = act.target.components.snackrificer
        if snackrificer then
            snackrificer:Snackrifice(act.doer, act.invobject)
            return true
        end
    end
)
