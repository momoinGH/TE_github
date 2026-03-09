TRO_AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right)
    if target:HasTag("cost_one_oinc") and target:HasTag("playercrafted") and not target:HasTag("slot_one") then
        -- 物品放入柜中
        table.insert(actions, ACTIONS.GIVE_SHELF)
    end
end)

local function UseTool(inst, doer, target, actions)
    if inst:HasTag("shear_tool") and target:HasTag("shearable") then
        -- 剪
        table.insert(actions, ACTIONS.SHEAR)
        return true
    end
    return false
end

TRO_AddComponentAction("USEITEM", "tool", function(inst, doer, target, actions)
    UseTool(inst, doer, target, actions)
end)

TRO_AddComponentAction("EQUIPPED", "tool", function(inst, doer, target, actions, right)
    UseTool(inst, doer, target, actions)
end)

TRO_AddComponentAction("SCENE", "shelfer", function(inst, doer, actions, right)
    if inst:HasTag("cost_one_oinc") and inst:HasTag("slot_one") then
        --从柜子中拿取
        table.insert(actions, ACTIONS.TAKE_SHELF)
    end
end)

TRO_AddComponentAction("SCENE", "shopped", function(inst, doer, actions, right)
    if inst:HasTag("slot_one") then
        --拿取货架物品
        table.insert(actions, ACTIONS.TAKE_SHELF)
    end
end)

TRO_AddComponentAction("POINT", "gasser", function(inst, doer, pos, actions, right)
    if right and not doer.replica.rider:IsRiding() then
        --喷洒杀毒剂
        table.insert(actions, ACTIONS.GAS)
    end
end)

TRO_AddComponentAction("EQUIPPED", "gasser", function(inst, doer, target, actions, right)
    if right and not (doer.replica.rider:IsRiding() or doer:HasTag("bonked")) then
        --喷洒杀毒剂
        table.insert(actions, ACTIONS.GAS)
    end
end)
