local Utils = require("tropical_utils/utils")

local function IsChannelCasting(inst)
    --essentially prediction, since the actions aren't busy w/ lag states
    local buffaction = inst.sg.mem.preview_channelcast_action
    if buffaction then
        return buffaction.action == ACTIONS.START_CHANNELCAST
        --Don't use "or inst:IsChannelCasting()"
        --We want to be able to return false here when predicting!
    end
    --otherwise return server state
    return inst:IsChannelCasting()
end

local function IsChannelCastingItem(inst)
    --essentially prediction, since the actions aren't busy w/ lag states
    local buffaction = inst.sg.mem.preview_channelcast_action
    if buffaction then
        return buffaction.invobject ~= nil
        --Don't use "or inst:IsChannelCastingItem()"
        --We want to be able to return false here when predicting!
    end
    --otherwise return server state
    return inst:IsChannelCastingItem()
end

local function ConfigureRunState(inst)
    if inst.replica.rider ~= nil and inst.replica.rider:IsRiding() then
        inst.sg.statemem.riding = true
        inst.sg.statemem.groggy = inst:HasTag("groggy")

        local mount = inst.replica.rider:GetMount()
        inst.sg.statemem.ridingwoby = mount and mount:HasTag("woby")
    elseif inst.replica.inventory:IsHeavyLifting() then
        inst.sg.statemem.heavy = true
        inst.sg.statemem.heavy_fast = inst:HasTag("mightiness_mighty")
    elseif IsChannelCasting(inst) then
        inst.sg.statemem.channelcast = true
        inst.sg.statemem.channelcastitem = IsChannelCastingItem(inst)
    elseif inst:HasTag("wereplayer") then
        inst.sg.statemem.iswere = true
        if inst:HasTag("weremoose") then
            if inst:HasTag("groggy") then
                inst.sg.statemem.moosegroggy = true
            else
                inst.sg.statemem.moose = true
            end
        elseif inst:HasTag("weregoose") then
            if inst:HasTag("groggy") then
                inst.sg.statemem.goosegroggy = true
            else
                inst.sg.statemem.goose = true
            end
        elseif inst:HasTag("groggy") then
            inst.sg.statemem.groggy = true
        else
            inst.sg.statemem.normal = true
        end
    elseif inst:IsInAnyStormOrCloud() and not inst.components.playervision:HasGoggleVision() then
        inst.sg.statemem.sandstorm = true
    elseif inst:HasTag("groggy") then
        inst.sg.statemem.groggy = true
    elseif inst:IsCarefulWalking() then
        inst.sg.statemem.careful = true
    else
        inst.sg.statemem.normal = true
        inst.sg.statemem.normalwonkey = inst:HasTag("wonkey") or nil
    end
end

----------------------------------------------------------------------------------------------------

local actionhandlers = {
    ActionHandler(ACTIONS.BOATMOUNT, function(inst, act)
        local x, y, z = act.target.Transform:GetWorldPosition()
        inst.components.embarker:SetDisembarkPos(x, z)

        if (inst.components.health == nil or not inst.components.health:IsDead()) and (inst.sg:HasStateTag("moving") or inst.sg:HasStateTag("idle")) then
            if not inst.sg:HasStateTag("jumping") then
                return "hop_pre"
            end
        elseif inst.components.embarker then
            inst.components.embarker:Cancel()
        end
    end),

    -- 上岸，开启延迟补偿下主机和客机都执行跳跃逻辑，避免位置不同步的问题
    ActionHandler(ACTIONS.BOATDISMOUNT, function(inst, act)
        inst:PerformPreviewBufferedAction()

        local x, y, z = act:GetActionPoint():Get()
        act.doer.components.locomotor:StartHopping(x, z)
    end),
    ActionHandler(ACTIONS.BOATCANNON, "doshortaction"),
}

local eventhandlers = {

}

local states = {

}

for _, actionhandler in ipairs(actionhandlers) do
    AddStategraphActionHandler("wilson_client", actionhandler)
end

for _, eventhandler in ipairs(eventhandlers) do
    AddStategraphEvent("wilson_client", eventhandler)
end

for _, state in ipairs(states) do
    AddStategraphState("wilson_client", state)
end

----------------------------------------------------------------------------------------------------

AddStategraphPostInit("wilson_client", function(sg)
    -- 划船
    Utils.FnDecorator(sg.states["run_start"], "onenter", nil, function(retTab, inst)
        local boat = inst:TroGetSWBoat()
        if boat then
            local item = boat.replica.container and boat.replica.container:GetItemInSlot(1)
            local anim = inst.replica.inventory:IsHeavyLifting() and "heavy_idle"
                or boat:HasTag("surf") and "surf_pre"
                or item and item:HasTag("sail") and "sail_pre"
                or "row_pre"
            inst.AnimState:PlayAnimation(anim)
        end
    end)

    Utils.FnDecorator(sg.states["run"], "onenter", function(inst)
        local boat = inst:TroGetSWBoat()
        if not boat then
            return
        end

        ConfigureRunState(inst)
        inst.components.locomotor:RunForward()

        local item = boat.replica.container and boat.replica.container:GetItemInSlot(1)
        local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        local anim = inst.replica.inventory:IsHeavyLifting() and "heavy_idle"
            or boat:HasTag("surf") and "surf_loop"
            or item and item:HasTag("sail") and "sail_loop"
            or equip and equip:HasTag("oar") and "row_medium"
            or "row_loop"
        if anim == "row_loop" then
            inst.AnimState:AddOverrideBuild("player_actions_paddle")
        end
        if not inst.AnimState:IsCurrentAnimation(anim) then
            inst.AnimState:PlayAnimation(anim, true)
        end

        inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())

        return nil, true
    end)

    Utils.FnDecorator(sg.states["run"], "onexit", function(inst)
        inst.AnimState:ClearOverrideBuild("player_actions_paddle")
    end)

    Utils.FnDecorator(sg.states["run_stop"], "onenter", nil, function(retTab, inst)
        local boat = inst:TroGetSWBoat()
        if boat then
            local item = boat.replica.container and boat.replica.container:GetItemInSlot(1)
            local anim = inst.replica.inventory:IsHeavyLifting() and "heavy_idle"
                or boat:HasTag("surf") and "surf_pst"
                or item and item:HasTag("sail") and "sail_pst"
                or "row_pst"
            inst.AnimState:PlayAnimation(anim)
        end
    end)

    --跳船
    Utils.FnDecorator(sg.states["hop_pre"], "onenter", nil, function(retTab, inst)
        local act = inst:GetBufferedAction()
        if act and act.action == ACTIONS.BOATMOUNT then
            inst:PerformPreviewBufferedAction() --直接执行
        end
    end)
end)
