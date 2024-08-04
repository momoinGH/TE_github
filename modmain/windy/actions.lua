Constructor.AddAction(nil, "FILLED", STRINGS.ACTIONS.FILLED, function(act)
    return act.target ~= nil
        and act.invobject ~= nil
        and act.invobject.components.extrafillable ~= nil
        and act.target:HasTag("goddess_fountain")
        and act.invobject.components.extrafillable:Fill()
end
)
