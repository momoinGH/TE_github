local Utils = require("tropical_utils/utils")

-- 源代码拷贝
local function ConfigureRunState(inst)
    if inst.components.rider:IsRiding() then
        inst.sg.statemem.riding = true
        inst.sg.statemem.groggy = inst:HasTag("groggy")
        inst.sg:AddStateTag("nodangle")
        inst.sg:AddStateTag("noslip")

        local mount = inst.components.rider:GetMount()
        inst.sg.statemem.ridingwoby = mount and mount:HasTag("woby")
    elseif inst.components.inventory:IsHeavyLifting() then
        inst.sg.statemem.heavy = true
        inst.sg.statemem.heavy_fast = inst.components.mightiness ~= nil and inst.components.mightiness:IsMighty()
        inst.sg:AddStateTag("noslip")
    elseif inst:IsChannelCasting() then
        inst.sg.statemem.channelcast = true
        inst.sg.statemem.channelcastitem = inst:IsChannelCastingItem()
    elseif inst:HasTag("wereplayer") then
        inst.sg.statemem.iswere = true
        inst.sg:AddStateTag("noslip")

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
        inst.sg:AddStateTag("noslip")
    else
        inst.sg.statemem.normal = true
        inst.sg.statemem.normalwonkey = inst:HasTag("wonkey") or nil
    end
end

local function Chronological(a, b)
    return a.time < b.time
end

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

AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(ACTIONS.BOATDISMOUNT, function(inst, act)
    local x, y, z = act:GetActionPoint():Get()
    act.doer.components.locomotor:StartHopping(x, z)
end))



-- 划船
AddStategraphPostInit("wilson", function(sg)
    Utils.FnDecorator(sg.actionhandlers[ACTIONS.CASTSPELL], "deststate", function(inst)
        local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if item and item:HasTag("telescope") then
            return { "peertelescope" }, true
        end
    end)

    ------------------------------------------------------------------------------------------------

    Utils.FnDecorator(sg.states["run_start"], "onenter", nil, function(retTab, inst)
        local boat = inst:TroGetSWBoat()
        if boat then
            local item = boat.components.container and boat.components.container:GetItemInSlot(1)
            local anim = inst.components.inventory:IsHeavyLifting() and "heavy_idle"
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

        local item = boat.components.container and boat.components.container:GetItemInSlot(1)
        local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        local move_sound = item and item.components.shipwreckedboatparts.move_sound
        if move_sound then
            inst.SoundEmitter:PlaySound(move_sound, "sailmove")
        end
        local anim = inst.components.inventory:IsHeavyLifting() and "heavy_idle"
            or boat:HasTag("surf") and "surf_loop"
            or item and item:HasTag("sail") and "sail_loop"
            or equip and equip:HasTag("oar") and "row_medium"
            or "row_loop"
        if anim == "row_loop" then
            inst.AnimState:AddOverrideBuild("player_actions_paddle")
        end
        inst.sg.statemem.row_boat = anim == "row_loop" or anim == "row_medium"
        if not inst.AnimState:IsCurrentAnimation(anim) then
            inst.AnimState:PlayAnimation(anim, true)
        end

        inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())

        return nil, true
    end)

    table.insert(sg.states["run"].timeline, TimeEvent(5 * FRAMES, function(inst)
        if inst.sg.statemem.row_boat then
            inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/small")
        end
        -- 生成波纹
        if inst:TroGetSWBoat() then
            local wake = SpawnPrefab("rowboat_wake")
            wake.Transform:SetPosition(inst.Transform:GetWorldPosition())
            wake.Transform:SetRotation(inst.Transform:GetRotation())
            -- 要不要根据速度缩放一下波纹的大小？
        end
    end))
    table.sort(sg.states["run"].timeline, Chronological)

    Utils.FnDecorator(sg.states["run"], "onexit", function(inst)
        inst.SoundEmitter:KillSound("sailmove")
        inst.AnimState:ClearOverrideBuild("player_actions_paddle")
    end)

    Utils.FnDecorator(sg.states["run_stop"], "onenter", nil, function(retTab, inst)
        local boat = inst:TroGetSWBoat()
        if boat then
            local item = boat.components.container and boat.components.container:GetItemInSlot(1)
            local anim = inst.components.inventory:IsHeavyLifting() and "heavy_idle"
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
            inst:PerformBufferedAction() --直接执行
        end
    end)
end)
