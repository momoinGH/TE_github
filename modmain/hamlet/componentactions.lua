TRO_AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right)
    if target:HasTag("cost_one_oinc") and target:HasTag("playercrafted") and not target:HasTag("slot_one") then
        -- 物品放入柜中
        table.insert(actions, ACTIONS.GIVE_SHELF)
    end
end)
