local Utils = require("tropical_utils/utils")


AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.BOATMOUNT, function(inst, act)
    local x, y, z = act.target.Transform:GetWorldPosition()
    inst.components.embarker:SetDisembarkPos(x, z)

    if (inst.components.health == nil or not inst.components.health:IsDead()) and (inst.sg:HasStateTag("moving") or inst.sg:HasStateTag("idle")) then
        if not inst.sg:HasStateTag("jumping") then
            return "hop_pre"
        end
    elseif inst.components.embarker then
        inst.components.embarker:Cancel()
    end
end))

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.BOATMOUNT, function(inst, act)
    local x, y, z = act.target.Transform:GetWorldPosition()
    inst.components.embarker:SetDisembarkPos(x, z)

    if (inst.components.health == nil or not inst.components.health:IsDead()) and (inst.sg:HasStateTag("moving") or inst.sg:HasStateTag("idle")) then
        if not inst.sg:HasStateTag("jumping") then
            return "hop_pre"
        end
    elseif inst.components.embarker then
        inst.components.embarker:Cancel()
    end
end))



AddStategraphPostInit("wilson_client", function(sg)
    --跳船
    Utils.FnDecorator(sg.states["hop_pre"], "onenter", nil, function(retTab, inst)
        local act = inst:GetBufferedAction()
        if act and act.action == ACTIONS.BOATMOUNT then
            inst:PerformPreviewBufferedAction() --直接执行
        end
    end)
end)


-- 划船
AddStategraphPostInit("wilson", function(sg)
    --跳船
    Utils.FnDecorator(sg.states["hop_pre"], "onenter", nil, function(retTab, inst)
        local act = inst:GetBufferedAction()
        if act and act.action == ACTIONS.BOATMOUNT then
            inst:PerformBufferedAction() --直接执行
        end
    end)
end)
