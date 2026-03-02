TRO_AddComponentAction("SCENE", "shipwreckedboat", function(inst, doer, actions, right)
    if not right and inst:HasTag("shipwrecked_boat") and not inst:HasTag("fire") then
        -- 海难小船登船
        table.insert(actions, ACTIONS.BOATMOUNT)
    end
end)
