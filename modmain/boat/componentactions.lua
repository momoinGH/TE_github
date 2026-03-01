-- local Utils = require("tropical_utils/utils")

-- local COMPONENT_ACTIONS = Utils.ChainFindUpvalue(EntityScript.CollectActions, "COMPONENT_ACTIONS")
--     or Utils.ChainFindUpvalue(EntityScript.IsActionValid, "COMPONENT_ACTIONS")


-- if COMPONENT_ACTIONS then
--     Utils.FnDecorator(COMPONENT_ACTIONS.SCENE, "container", function(inst, doer)
--         if inst:HasTag("shipwrecked_boat") then
--             return nil, true --玩家不能控制小船容器开关
--         end
--     end)
-- end


TRO_AddComponentAction("SCENE", "shipwreckedboat", function(inst, doer, actions, right)
    if not right and inst:HasTag("shipwrecked_boat") and not inst:HasTag("fire") and not inst:HasTag("pro_fakeboat") then
        -- 海难小船登船
        table.insert(actions, ACTIONS.BOATMOUNT)
    end
end)
