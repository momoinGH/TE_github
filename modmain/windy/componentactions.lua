AddComponentAction("USEITEM", "extrafillable", function(inst, doer, target, actions)
    if target:HasTag("goddess_fountain") then
        table.insert(actions, ACTIONS.FILLED)
    end
end)
