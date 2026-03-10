local actionhandlers = {

}

local eventhandlers = {

}

local states = {
    -- 进入小房子的门，因为我不想跳进去
    State {
        name = "jumpin_interior",
        tags = { "doing", "busy", "canrotate", "nopredict", "nomorph" },

        onenter = function(inst, data)
            ToggleOffPhysics(inst)
            inst.components.locomotor:Stop()

            local teleporter = inst:GetBufferedAction() and inst:GetBufferedAction().target

            inst.sg.statemem.target = teleporter
            inst.sg.statemem.heavy = inst.components.inventory:IsHeavyLifting()

            if teleporter ~= nil and teleporter.components.teleporter ~= nil then
                teleporter.components.teleporter:RegisterTeleportee(inst)
            end

            inst.AnimState:PlayAnimation("give")

            inst.sg.statemem.teleportarrivestate = "idle" -- this can be overriden in the teleporter component
        end,

        timeline =
        {
            TimeEvent(1 * FRAMES, function(inst)
                local target = inst.sg.statemem.target
                if not inst.sg.statemem.heavy and target and target:IsValid() and target.usesound then
                    inst.SoundEmitter:PlaySound(target.usesound) --使用门的声音
                end
            end),
            TimeEvent(5 * FRAMES, function(inst)
                local target = inst.sg.statemem.target
                if inst.sg.statemem.heavy and target and target:IsValid() and target.usesound then
                    inst.SoundEmitter:PlaySound(target.usesound)
                end
            end),

            --Normal
            TimeEvent(13 * FRAMES, function(inst)
                -- this is just hacked in here to make the sound play BEFORE the player hits the wormhole
                if inst.sg.statemem.target ~= nil then
                    if inst.sg.statemem.target:IsValid() then
                        inst.sg.statemem.target:PushEvent("starttravelsound", inst)
                    else
                        inst.sg.statemem.target = nil
                    end
                end
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    local should_teleport = false
                    if inst.sg.statemem.target ~= nil and
                        inst.sg.statemem.target:IsValid() and
                        inst.sg.statemem.target.components.teleporter ~= nil then
                        --Unregister first before actually teleporting
                        inst.sg.statemem.target.components.teleporter:UnregisterTeleportee(inst)

                        if inst.sg.statemem.target.components.teleporter:Activate(inst) then
                            should_teleport = true
                        end
                    end

                    if should_teleport then
                        inst.sg.statemem.isteleporting = true
                        inst.components.health:SetInvincible(true)
                        if inst.components.playercontroller ~= nil then
                            inst.components.playercontroller:Enable(false)
                        end
                        inst:Hide()
                        inst.DynamicShadow:Enable(false)
                        return
                    end

                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.sg.statemem.isphysicstoggle then
                ToggleOnPhysics(inst)
            end
            inst.Physics:Stop()

            if inst.sg.statemem.isteleporting then
                inst.components.health:SetInvincible(false)
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:Enable(true)
                end
                inst:Show()
                inst.DynamicShadow:Enable(true)
            elseif inst.sg.statemem.target ~= nil
                and inst.sg.statemem.target:IsValid()
                and inst.sg.statemem.target.components.teleporter ~= nil then
                inst.sg.statemem.target.components.teleporter:UnregisterTeleportee(inst)
            end
        end,
    },
}

for _, actionhandler in ipairs(actionhandlers) do
    AddStategraphActionHandler("wilson", actionhandler)
end

for _, eventhandler in ipairs(eventhandlers) do
    AddStategraphEvent("wilson", eventhandler)
end

for _, state in ipairs(states) do
    AddStategraphState("wilson", state)
end


AddStategraphPostInit("wilson", function(sg)
    Hooks.FnDecorator(sg.actionhandlers[ACTIONS.JUMPIN], "deststate", function(inst, act)
        return { "jumpin_interior" }, act.target and (act.target:HasTag("interior_door") or act.target.prefab == "lavaarena_portal")
    end)
end)
