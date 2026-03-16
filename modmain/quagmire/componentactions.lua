TroAddComponentAction("USEITEM", "snackrificable", function(inst, doer, target, actions)
    if target:HasTag("gorge_altar") then
        table.insert(actions, ACTIONS.SNACKRIFICE)
    end
end)
