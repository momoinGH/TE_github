AddStategraphPostInit("wilson", function(sg)
    Hooks.FnDecorator(sg.actionhandlers[ACTIONS.GIVE], "deststate", nil, function(retTab, inst, action)
        if retTab[1] == "give" then
            if action.target and action.target:HasTag("goddess_item") then
                retTab[1] = "dolongaction"
            end
        end
        return retTab
    end)
end)
