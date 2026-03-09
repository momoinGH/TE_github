----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Mod Action (give) [too lazy to make new component for goddess item repair]
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.GIVE, function(inst, action)
    return action.invobject ~= nil and action.target ~= nil and (
            (action.target:HasTag("moonportal") and action.invobject:HasTag("moonportalkey") and "dochannelaction") or
            (action.invobject.prefab == "quagmire_portal_key" and action.target:HasTag("quagmire_altar") and "quagmireportalkey") or
            (action.target:HasTag("goddess_item") and "dolongaction") or
            (action.target:HasTag("trader") and "give"))
        or "give"
end))
