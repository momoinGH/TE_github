local TIMEOUT = 2

local actionhandlers = {
    ActionHandler(ACTIONS.STOREOPEN, "doshortaction"),
    ActionHandler(ACTIONS.TRO_DISMANTLE, "dolongaction"),
    ActionHandler(ACTIONS.HACK, function(inst)
        if inst:HasTag("beaver") then
            return not inst.sg:HasStateTag("gnawing") and "gnaw" or nil
        end

        return not inst.sg:HasStateTag("prechop") and "chop_start" or nil
    end),
}

local eventhandlers = {

}



local states = {
    --剪刀剪
    State {
        name = "shear_start",
        tags = { "preshear", "shearing", "working" },
        server_states = { "shear_start", "shear" },
        onenter = function(inst)
            inst.components.locomotor:Stop()
            if not inst.sg:ServerStateMatches() then
                inst.AnimState:PlayAnimation("cut_pre")
            end

            inst.sg:SetTimeout(TIMEOUT)
            inst:PerformPreviewBufferedAction()
        end,
        onupdate = function(inst)
            if inst.sg:ServerStateMatches() then
                if inst.entity:FlattenMovementPrediction() then
                    inst.sg:GoToState("idle", "noanim")
                end
            elseif inst.bufferedaction == nil then
                inst.sg:GoToState("idle")
            end
        end,
        ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
        end,
        events =
        {
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animover", function(inst)
                if not inst:GetBufferedAction() then
                    inst.sg:GoToState("shear_end")
                end
            end),
        },
    },

    State {
        name = "shear_end",
        tags = { "working" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("cut_pst")
        end,

        events =
        {
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },

    },

    State {
        name = "speargun",
        tags = { "attack", "notalking", "abouttoattack" },

        onenter = function(inst)
            if inst.replica.rider ~= nil and inst.replica.rider:IsRiding() then
                inst.Transform:SetFourFaced()
            end
            local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            inst.components.locomotor:Stop()

            inst.AnimState:PlayAnimation("speargun")
            if inst.sg.prevstate == inst.sg.currentstate then
                inst.sg.statemem.chained = true
                inst.AnimState:SetTime(5 * FRAMES)
            end

            if inst.replica.combat ~= nil then
                inst.replica.combat:StartAttack()
                inst.sg:SetTimeout(math.max((inst.sg.statemem.chained and 14 or 18) * FRAMES,
                    inst.replica.combat:MinAttackPeriod() + .5 * FRAMES))
            end

            local buffaction = inst:GetBufferedAction()
            if buffaction ~= nil then
                inst:PerformPreviewBufferedAction()

                if buffaction.target ~= nil and buffaction.target:IsValid() then
                    inst:FacePoint(buffaction.target:GetPosition())
                    inst.sg.statemem.attacktarget = buffaction.target
                end
            end

            if (equip.projectiledelay or 0) > 0 then
                --V2C: Projectiles don't show in the initial delayed frames so that
                --     when they do appear, they're already in front of the player.
                --     Start the attack early to keep animation in sync.
                inst.sg.statemem.projectiledelay = (inst.sg.statemem.chained and 9 or 14) * FRAMES -
                    equip.projectiledelay
                if inst.sg.statemem.projectiledelay <= 0 then
                    inst.sg.statemem.projectiledelay = nil
                end
            end
        end,

        onupdate = function(inst, dt)
            if (inst.sg.statemem.projectiledelay or 0) > 0 then
                inst.sg.statemem.projectiledelay = inst.sg.statemem.projectiledelay - dt
                if inst.sg.statemem.projectiledelay <= 0 then
                    inst:ClearBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end
        end,

        timeline =
        {
            TimeEvent(8 * FRAMES, function(inst)
                if inst.sg.statemem.chained then
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_shoot", nil, nil, true)
                end
            end),
            TimeEvent(9 * FRAMES, function(inst)
                if inst.sg.statemem.chained and inst.sg.statemem.projectiledelay == nil then
                    inst:ClearBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end),



            TimeEvent(15 * FRAMES, function(inst)
                if not inst.sg.statemem.chained then
                    if inst.replica.combat:GetWeapon() and inst.replica.combat:GetWeapon():HasTag("blunderbuss") then
                        inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/items/weapon/blunderbuss_shoot")
                        if inst.replica.rider ~= nil and inst.replica.rider:IsRiding() then
                            local cloud = SpawnPrefab("cloudpuff")
                            local pt = inst:GetPosition()
                            cloud.Transform:SetPosition(pt.x, 4.5, pt.z)
                        else
                            local cloud = SpawnPrefab("cloudpuff")
                            local pt = inst:GetPosition()
                            cloud.Transform:SetPosition(pt.x, 2, pt.z)
                        end
                    else
                        inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/use_speargun")
                    end
                end
            end),

            TimeEvent(16 * FRAMES, function(inst)
                if not inst.sg.statemem.chained and inst.sg.statemem.projectiledelay == nil then
                    inst:ClearBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end),
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.sg:HasStateTag("abouttoattack") and inst.replica.combat ~= nil then
                inst.replica.combat:CancelAttack()
            end
            if inst.replica.rider ~= nil and inst.replica.rider:IsRiding() then
                inst.Transform:SetSixFaced()
            end
        end,
    },

    State {
        name = "goggleattack", --激光眼镜
        tags = { "attack", "notalking", "abouttoattack" },

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            if buffaction ~= nil then
                inst:PerformPreviewBufferedAction()
                if buffaction.target ~= nil and buffaction.target:IsValid() then
                    inst:FacePoint(buffaction.target:GetPosition())
                    inst.sg.statemem.attacktarget = buffaction.target
                    inst.sg.statemem.retarget = buffaction.target
                end
            end
            local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
            if (equip ~= nil and equip.projectiledelay or 0) > 0 then
                inst.sg.statemem.projectiledelay = (inst.sg.statemem.chained and 9 or 14) * FRAMES - equip.projectiledelay
                if inst.sg.statemem.projectiledelay <= 0 then
                    inst.sg.statemem.projectiledelay = nil
                end
            end
            inst.replica.combat:StartAttack()
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("goggle_fast")
            if inst.sg.laststate == inst.sg.currentstate then
                inst.sg.statemem.chained = true
                inst.AnimState:SetFrame(5)
            end
            inst.AnimState:PushAnimation("goggle_fast_pst", false)

            inst.sg:SetTimeout(math.max((inst.sg.statemem.chained and 14 or 18) * FRAMES, inst.replica.combat:MinAttackPeriod()))
        end,

        onupdate = function(inst, dt)
            if (inst.sg.statemem.projectiledelay or 0) > 0 then
                inst.sg.statemem.projectiledelay = inst.sg.statemem.projectiledelay - dt
                if inst.sg.statemem.projectiledelay <= 0 then
                    inst:ClearBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end
        end,

        timeline =
        {
            TimeEvent(9 * FRAMES, function(inst)
                if inst.sg.statemem.chained and inst.sg.statemem.projectiledelay == nil then
                    inst:ClearBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end),
            TimeEvent(14 * FRAMES, function(inst)
                if not inst.sg.statemem.chained and inst.sg.statemem.projectiledelay == nil then
                    inst:ClearBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end),
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.sg:HasStateTag("abouttoattack") then
                inst.replica.combat:CancelAttack()
            end
        end,
    }
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

AddStategraphPostInit("wilson_client", function(inst)
    Hooks.FnDecorator(inst.actionhandlers[ACTIONS.ATTACK], "deststate", function(inst, action)
        if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or IsEntityDead(inst)) then
            local weapon = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if weapon and (weapon:HasTag("speargun") or weapon:HasTag("blunderbuss")) then
                return { "speargun" }, true
            end

            local hat = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
            if weapon == nil and hat and hat.prefab == "gogglesshoothat" then
                return { "goggleattack" }, true
            end
        end
    end)

    -- 可以上床睡觉
    Hooks.FnDecorator(inst.actionhandlers[ACTIONS.SLEEPIN], "deststate", function(inst, action)
        if action.target:HasTag("bed") then
            local x, y, z = action.target.Transform:GetWorldPosition()
            action.doer.Transform:SetPosition(x + 0.02, y, z + 0.02)
            return { "bedroll" }, true
        end
    end)
end)

----------------------------------------------------------------------------------------------------
